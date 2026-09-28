const queryPermission = require('queryPermission');
const getEventData = require('getEventData');
const setCookie = require('setCookie');
const getCookieValues = require('getCookieValues');
const JSON = require('JSON');
const makeString = require('makeString');
const encodeUriComponent = require('encodeUriComponent');
const encodeUri = require('encodeUri');
const getType = require('getType');
const getTimestampMillis = require('getTimestampMillis');
const makeInteger = require('makeInteger');
const Math = require('Math');
const sha256Sync = require('sha256Sync');

// ==========================================
// 1. EVENT GATEKEEPER (Fail-fast for ignored events)
// ==========================================
const eventName = getEventData('event_name');

// Split user input by comma and trim spaces
const allowedEvents = data.allowedEvents.split(',').map(function(e) {
  return e.trim();
});

// If the current event is NOT in the allowed list, immediately exit.
if (allowedEvents.indexOf(eventName) === -1) {
  return false; 
}

// ==========================================
// 2. FETCH ID & GUARD CLAUSES
// ==========================================
const keyPath = 'transaction_id';
let raw_transaction_id;

if (data.transactionIdVariable !== undefined && data.transactionIdVariable !== null && makeString(data.transactionIdVariable).trim() !== '') {
  raw_transaction_id = data.transactionIdVariable;
} else {
  if (!queryPermission('read_event_data', keyPath)) return false;
  raw_transaction_id = getEventData(keyPath);
}

let tx_str = makeString(raw_transaction_id).trim();

// Hardcoded safety net: Ignore blanks and serialized invalid values
if (tx_str === '' || tx_str === 'null' || tx_str === 'undefined' || tx_str === 'NaN') {
  return false; 
}

// User-defined Ignored IDs
if (data.ignoredIds) {
  const ignoredArray = makeString(data.ignoredIds).split(',');
  for (let i = 0; i < ignoredArray.length; i++) {
    const ignoredId = ignoredArray[i].trim();
    if (ignoredId !== '' && tx_str === ignoredId) {
      return false; 
    }
  }
}

// Optional hashing of the transaction ID before storage
if (data.sha256Sync) {
  tx_str = sha256Sync(tx_str, { outputEncoding: data.sha256Encoding});
}

// ==========================================
// 3. NAMESPACING & DATABASE KEY CREATION
// ==========================================
// Use a pipe to prevent collisions (e.g., "purchase|12345")
const dedupKey = eventName + '|' + tx_str;

// ==========================================
// 4. CONFIGURATION VALIDATION & MODES
// ==========================================
const expirationDays = makeInteger(data.cookieExpiration);
const cookieLimit = makeInteger(data.limitCookieNumber);

// Migration fallback for older template versions
let mode = data.deduplicationMode;
if (mode !== 'cookie_only' && mode !== 'db_only' && mode !== 'cookie_and_db') {
  mode = 'cookie_only';
}

let useCookie = (mode === 'cookie_only' || mode === 'cookie_and_db');
let useDb = (mode === 'db_only' || mode === 'cookie_and_db');

// ==========================================
// 5. COOKIE OPTIONS & CONSENT GATE
// ==========================================
const cookieName = data.cookieName; 
let consent = true;

const writeOptions = {
  domain: data.cookieDomain,
  path: '/',
  samesite: data.cookieSameSite,
  secure: true,
  'max-age': expirationDays * 86400
};
if (data.cookieHttpOnly) writeOptions.httpOnly = true;

if (data.consentCheck) {
  const consentMode = data.consentConfigMode; 

  if (consentMode === 'auto') {
    let hasAnalyticsConsent = false;
    let parsedGoogleConsent = false;

    const xGaGcd = getEventData('x-ga-gcd');
    if (xGaGcd && getType(xGaGcd) === 'string') {
      let letters = [];
      for (let i = 0; i < xGaGcd.length; i++) {
        let char = xGaGcd[i].toLowerCase();
        if (char >= 'a' && char <= 'z') letters.push(char);
      }
      if (letters.length >= 2) {
        const analyticsLetter = letters[1]; 
        const grantedStatuses = ['t', 'r', 'n', 'v'];
        if (grantedStatuses.indexOf(analyticsLetter) !== -1) hasAnalyticsConsent = true;
        parsedGoogleConsent = true;
      }
    }

    if (!parsedGoogleConsent) {
      const xGaGcs = getEventData('x-ga-gcs');
      if (xGaGcs && getType(xGaGcs) === 'string' && xGaGcs.length >= 4 && xGaGcs[0] === 'G' && xGaGcs[1] === '1') {
        if (xGaGcs[3] === '1') hasAnalyticsConsent = true;
        parsedGoogleConsent = true;
      }
    }
    consent = hasAnalyticsConsent;

  } else {
    if (data.consentParam) {
      data.consentParam.forEach((consentRow) => {
        if (consentRow.consentInput !== consentRow.consentValue) consent = false;
      });
    }
  }
}

if (!consent) {
  if (useCookie) {
    const deleteOptions = {
      domain: data.cookieDomain,
      path: '/',
      samesite: data.cookieSameSite,
      secure: true,
      'max-age': 0
    };
    if (queryPermission('set_cookies', cookieName, deleteOptions)) {
      setCookie(cookieName, '', deleteOptions);
    }
    useCookie = false; // Turn off cookies for the rest of the script
  }
  
  // Exit script completely IF database requires consent OR if database isn't used
  if (!useDb || data.dbRequiresConsent) {
    return false; 
  }
}

// ==========================================
// 6. READ COOKIE (CACHE)
// ==========================================
let cookieValue = [];
let foundInCookie = false;
let canUseCookie = false;

if (useCookie) {
  canUseCookie = queryPermission('get_cookies', cookieName);
  
  if (canUseCookie) {
    const rawCookies = getCookieValues(cookieName);
    if (rawCookies && rawCookies.length > 0) {
      const parsed = JSON.parse(rawCookies[0]);
      if (getType(parsed) === 'array') cookieValue = parsed;
    }
    foundInCookie = cookieValue.indexOf(dedupKey) > -1;
  }

  // Cost-saving early exit
  if (foundInCookie) {
    return true; 
  }
}

const saveToCookie = function() {
  if (!useCookie || !canUseCookie || cookieValue.indexOf(dedupKey) !== -1) return;
  if (!queryPermission('set_cookies', cookieName, writeOptions)) return;

  cookieValue.push(dedupKey);
  
  if (data.limitCookie && cookieValue.length > cookieLimit) {
    cookieValue.splice(0, cookieValue.length - cookieLimit);
  }

  let serialized = JSON.stringify(cookieValue);
  let encoded = encodeUriComponent(serialized);
  
  while (encoded && encoded.length > 3800 && cookieValue.length > 1) {
    cookieValue.splice(0, 1);
    serialized = JSON.stringify(cookieValue);
    encoded = encodeUriComponent(serialized);
  }

  if (encoded && encoded.length <= 3800) {
    setCookie(cookieName, serialized, writeOptions);
  }
};

// ==========================================
// 7. DATABASE DEDUPLICATION
// ==========================================
if (useDb) {
  const sendHttpRequest = require('sendHttpRequest');
  const currentTime = getTimestampMillis();
  
  // Create a hashed Document ID for Firestore/Stape URLs
  const docId = sha256Sync(dedupKey, { outputEncoding: 'hex' });

  // --- FIRESTORE NATIVE REST API (ATOMIC POST) ---
  if (data.dbType === 'firestore') {
    if (!data.firebaseProjectId) {
      saveToCookie();
      return false;
    }

    const getGoogleAuth = require('getGoogleAuth');
    const projectId = encodeUriComponent(data.firebaseProjectId);
    const collectionId = encodeUri(data.firebasePath);
    
    const firestoreUrl = 'https://firestore.googleapis.com/v1/projects/' + projectId + 
                         '/databases/(default)/documents/' + collectionId + '?documentId=' + docId;

    const auth = getGoogleAuth({ scopes: ['https://www.googleapis.com/auth/datastore'] });
    
    let fieldsObj = {
      "transaction_id": { "stringValue": tx_str },
      "event_name": { "stringValue": eventName }
    };

    if (data.addTimestamp) {
      const tsField = data.timestampFieldName ? data.timestampFieldName : 'timestamp';
      fieldsObj[tsField] = { "integerValue": makeString(currentTime) };
    }

    if (data.addTtlTimestamp) {
      const getIsoTimestamp = function(ms) {
        let days = Math.floor(ms / 86400000);
        let year = 1970;
        
        for (let i = 0; i < 1000; i++) {
          let isLeap = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0));
          let daysInYear = isLeap ? 366 : 365;
          if (days >= daysInYear) {
            days = days - daysInYear;
            year = year + 1;
          } else { break; }
        }
        
        let isLeapYear = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0));
        let daysInMonth = [31, (isLeapYear ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        let month = 0;
        
        for (let j = 0; j < 12; j++) {
          if (days >= daysInMonth[j]) {
            days = days - daysInMonth[j];
            month = month + 1;
          } else { break; }
        }
        
        let day = days + 1;
        let t = Math.floor(ms % 86400000);
        let h = Math.floor(t / 3600000);
        let min = Math.floor((t % 3600000) / 60000);
        let s = Math.floor((t % 60000) / 1000);
        let ms_rem = t % 1000;
        
        let pad = function(n) { return n < 10 ? '0' + makeString(n) : makeString(n); };
        let ms_str = makeString(ms_rem);
        if (ms_rem < 10) ms_str = '00' + ms_str;
        else if (ms_rem < 100) ms_str = '0' + ms_str;

        return makeString(year) + '-' + pad(month + 1) + '-' + pad(day) + 'T' + pad(h) + ':' + pad(min) + ':' + pad(s) + '.' + ms_str + 'Z';
      };

      const ttlField = data.ttlFieldName ? data.ttlFieldName : 'time_to_live';
      const expireMillis = currentTime + (expirationDays * 86400000); 
      fieldsObj[ttlField] = { "timestampValue": getIsoTimestamp(expireMillis) };
    }

    const postOptions = {
      method: 'POST',
      authorization: auth,
      headers: { 'Content-Type': 'application/json' },
      timeout: 4000
    };

    return sendHttpRequest(firestoreUrl, postOptions, JSON.stringify({ "fields": fieldsObj }))
      .then((response) => {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          saveToCookie();
          return false; 
        } else if (response.statusCode === 409) {
          saveToCookie();
          return true;  
        }
        saveToCookie();
        return false;
      })
      .catch(() => {
        saveToCookie();
        return false;
      });

  // --- STAPE STORE NATIVE API (BEST EFFORT) ---
  } else if (data.dbType === 'stape') {
    const getRequestHeader = require('getRequestHeader');
    
    const stapeId = getRequestHeader('x-gtm-identifier');
    const stapeDomain = getRequestHeader('x-gtm-default-domain');
    const stapeKey = getRequestHeader('x-gtm-api-key');
    
    if (!stapeId || !stapeDomain || !stapeKey) {
      saveToCookie();
      return false;
    }

    const stapeUrl = 'https://' + encodeUriComponent(stapeId) +
      '.' + encodeUriComponent(stapeDomain) +
      '/stape-api/' + encodeUriComponent(stapeKey) +
      '/v2/store/collections/' + encodeUriComponent(data.stapeCollection) +
      '/documents/' + docId;

    return sendHttpRequest(stapeUrl, { method: 'GET', timeout: 3000 }).then(function(response) {
      if (response.statusCode === 200) {
        saveToCookie();
        return true;
      } else if (response.statusCode === 404) {
        
        let stapeBody = { 
          transaction_id: tx_str,
          event_name: eventName 
        };
        
        if (data.addTimestamp) {
          const tsField = data.timestampFieldName ? data.timestampFieldName : 'timestamp';
          stapeBody[tsField] = currentTime;
        }

        return sendHttpRequest(
          stapeUrl,
          { method: 'PUT', headers: { 'Content-Type': 'application/json' }, timeout: 3000 },
          JSON.stringify(stapeBody)
        ).then(function(putRes) {
          saveToCookie();
          return false;
        }).catch(function() {
          saveToCookie();
          return false;
        });
      }
      saveToCookie();
      return false;
    }).catch(function() {
      saveToCookie();
      return false;
    });
  }
}

// Fallback for cookie-only mode
saveToCookie();
return false;