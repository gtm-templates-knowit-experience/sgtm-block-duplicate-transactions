___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Block Duplicate Transactions",
  "description": "Block duplicate transactions by checking transaction_id against a cookie, Stape Store, or atomic Firestore operations. Supports cookie-only, database-only, or hybrid modes.",
"categories": ["UTILITY","ANALYTICS","TAG_MANAGEMENT"],
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "transactionIdInputGroup",
    "displayName": "Transaction ID Input",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "transactionIdInput",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "transaction_id",
            "displayValue": "Event Data (transaction_id)"
          },
          {
            "value": "variable",
            "displayValue": "Variable"
          }
        ],
        "simpleValueType": true,
        "alwaysInSummary": true
      },
      {
        "type": "SELECT",
        "name": "transactionIdVariable",
        "displayName": "Read transaction_id from Variable",
        "macrosInSelect": true,
        "selectItems": [],
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "transactionIdInput",
            "paramValue": "variable",
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "By default, \u003cstrong\u003etransaction_id\u003c/strong\u003e will be read from \u003cstrong\u003eEvent Data\u003c/strong\u003e, but you can also choose to use a \u003cstrong\u003eVariable\u003c/strong\u003e as input."
  },
  {
    "type": "GROUP",
    "name": "Generic Settings",
    "displayName": "Generic Settings",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "allowedEvents",
        "displayName": "Events to Deduplicate",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Enter the events to deduplicate (e.g., \u003cb\u003epurchase\u003c/b\u003e, \u003cb\u003erefund\u003c/b\u003e).\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cb\u003eNote:\u003c/b\u003e This blocks identical \u003cb\u003eevent + transaction ID\u003c/b\u003e combinations. If you process multiple partial refunds for a single order, the second refund will be blocked. To prevent this, either remove \u0027refund\u0027 from this list, or pass a custom constructed ID (e.g., \u003cb\u003etransaction_id + refund_id\u003c/b\u003e) into the Transaction ID Input field above.",
        "alwaysInSummary": true,
        "defaultValue": "purchase, refund"
      },
      {
        "type": "SELECT",
        "name": "deduplicationMode",
        "displayName": "Deduplication Method",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "cookie_only",
            "displayValue": "Cookies"
          },
          {
            "value": "cookie_and_db",
            "displayValue": "Cookies and Database"
          },
          {
            "value": "db_only",
            "displayValue": "Database only"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "cookie_only",
        "help": ""
      },
      {
        "type": "TEXT",
        "name": "cookieExpiration",
        "displayName": "Expiration (Days)",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "defaultValue": 30,
        "help": "Enter how many days data should be stored.",
        "valueHint": "30",
        "alwaysInSummary": true
      },
      {
        "type": "CHECKBOX",
        "name": "sha256Sync",
        "checkboxText": "Hash transaction_id as SHA-256",
        "simpleValueType": true,
        "help": "Hash \u003cstrong\u003etransaction_id\u003c/strong\u003e stored with \u003cstrong\u003eSHA-256\u003c/strong\u003e . Highly recommended.\n\u003cbr/\u003e\u003cbr/\u003e\nThis makes the \u003cstrong\u003etransaction_id\u003c/strong\u003e stored unrecognizable.\n\u003cbr/\u003e\u003cbr/\u003e\n\u003cb\u003eNote:\u003c/b\u003e Changing hash settings after publishing will create a new identity namespace, meaning existing stored IDs will no longer match new ones.",
        "alwaysInSummary": true,
        "defaultValue": true
      },
      {
        "type": "SELECT",
        "name": "sha256Encoding",
        "displayName": "SHA-256 Encoding",
        "selectItems": [
          {
            "value": "hex",
            "displayValue": "Hex"
          },
          {
            "value": "base64",
            "displayValue": "Base64"
          }
        ],
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "sha256Sync",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Select the output format for the hash. Hex (Recommended) produces a standard 64-character string (numbers and letters only) that is natively supported by most marketing platforms. Base64 produces a shorter string, but includes special characters (like + or /) that can sometimes cause issues in URLs or certain databases."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "consentGroup",
    "displayName": "Consent Check",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "consentCheck",
        "checkboxText": "Enable Consent Check",
        "simpleValueType": true,
        "help": "Check analytics consent before storing deduplication data (applies to cookies and database).",
        "alwaysInSummary": true,
        "defaultValue": true
      },
      {
        "type": "RADIO",
        "name": "consentConfigMode",
        "radioItems": [
          {
            "value": "auto",
            "displayValue": "Detect analytics consent automatically"
          },
          {
            "value": "manual",
            "displayValue": "Map consent values manually"
          }
        ],
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "consentCheck",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "consentParam",
        "displayName": "Add Consent Check",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Consent Input",
            "name": "consentInput",
            "type": "SELECT",
            "macrosInSelect": true,
            "valueHint": "{{Google Consent Mode Query Parameter}}",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Consent Value",
            "name": "consentValue",
            "type": "TEXT",
            "valueHint": "G111"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "consentConfigMode",
            "paramValue": "manual",
            "type": "EQUALS"
          }
        ],
        "help": "Select a \u003cstrong\u003eVarible\u003c/strong\u003e that contains Consent Information (e.g. Google Consent Mode). In the \u003cstrong\u003eConsent Value\u003c/strong\u003e field, enter a value from the Variable that signals Consent (e.g. \u003cstrong\u003eG111\u003c/strong\u003e if you are checking against GCM).",
        "newRowButtonText": "Add Consent Check",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "dbConsentGroup",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "dbRequiresConsent",
            "checkboxText": "Require Consent for Database Operations",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "deduplicationMode",
                "paramValue": "cookie_only",
                "type": "NOT_EQUALS"
              }
            ],
            "help": "If checked, database deduplication strictly requires user consent. If unchecked, the database runs for all transactions regardless of consent. (Note: If a hybrid mode is used, cookies will still always respect consent).",
            "defaultValue": true
          }
        ],
        "enablingConditions": [
          {
            "paramName": "consentCheck",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "cookieSettingsGroup",
    "displayName": "Cookie Settings",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "limitCookie",
        "checkboxText": "Limit  Cookie Size",
        "simpleValueType": true,
        "help": "Limit  number of Transaction ID\u0027s stored in the cookie to avoid that the size of the cookie grows too big.\n\u003cbr /\u003e\u003cbr /\u003e\nWhen the limit is reached, the oldest Transaction ID will be deleted from the cookie when a new Transaction ID is added.",
        "alwaysInSummary": false
      },
      {
        "type": "TEXT",
        "name": "limitCookieNumber",
        "displayName": "Max Transaction ID\u0027s stored in Cookie",
        "simpleValueType": true,
        "defaultValue": 5,
        "enablingConditions": [
          {
            "paramName": "limitCookie",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "alwaysInSummary": false
      },
      {
        "type": "TEXT",
        "name": "cookieName",
        "displayName": "Cookie Name",
        "simpleValueType": true,
        "defaultValue": "sgtm_transaction_ids",
        "help": "Enter the name of the cookie. \u003cstrong\u003esgtm_\u003c/strong\u003e is suggested as a prefix of the cookie since it will give a hint about where the cookie was set.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "alwaysInSummary": true,
        "valueHint": "sgtm_transaction_ids"
      },
      {
        "type": "TEXT",
        "name": "cookieDomain",
        "displayName": "Cookie Domain",
        "simpleValueType": true,
        "defaultValue": "auto",
        "help": "If you set Domain to \u003cstrong\u003eauto\u003c/strong\u003e, the Variable will try to write the cookie on the highest possible level in the domain name hierarchy (e.g. \u003cstrong\u003e.domain.com\u003c/strong\u003e).",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "SELECT",
        "name": "cookieSameSite",
        "displayName": "SameSite",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "",
            "displayValue": "Value not set"
          },
          {
            "value": "Lax",
            "displayValue": "Lax"
          },
          {
            "value": "Strict",
            "displayValue": "Strict"
          }
        ],
        "simpleValueType": true,
        "help": "The SameSite attribute controls what contexts your cookie will be used in.  \n\u003cbr /\u003e\u003cbr /\u003e\nTo see the differences between Lax and Strict settings, see the \u003ca href\u003d\"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite\" target\u003d\"_blank\"\u003e\u003cstrong\u003eMDN documentation\u003c/strong\u003e\u003c/a\u003e. If set to \u0027Value not set\u0027 the SameSite attribute will not be written."
      },
      {
        "type": "CHECKBOX",
        "name": "cookieHttpOnly",
        "checkboxText": "HttpOnly",
        "simpleValueType": true,
        "help": "If \u003cstrong\u003echecked\u003c/strong\u003e,  the cookie is set as \u003cstrong\u003eHttpOnly\u003c/strong\u003e, which forbids JavaScript from accessing the cookie."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "deduplicationMode",
        "paramValue": "db_only",
        "type": "NOT_EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "databaseGroup",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "dbType",
        "displayName": "Select Database Provider",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "firestore",
            "displayValue": "Google Cloud Firestore"
          },
          {
            "value": "stape",
            "displayValue": "Stape Store"
          }
        ],
        "simpleValueType": true,
        "enablingConditions": [],
        "alwaysInSummary": true
      },
      {
        "type": "GROUP",
        "name": "firestoreGroup",
        "subParams": [
          {
            "type": "TEXT",
            "name": "firebaseProjectId",
            "displayName": "Firebase Project ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "help": "Enter your Google Cloud / Firebase Project ID. You can find this in your Google Cloud Console dashboard. (Example: my-company-analytics-123)"
          },
          {
            "type": "TEXT",
            "name": "firebasePath",
            "displayName": "Firestore Collection Path",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "REGEX",
                "args": [
                  "^[a-zA-Z0-9_-]+$"
                ],
                "errorMessage": "Path can only contain letters, numbers, underscores, and hyphens. No slashes allowed."
              }
            ],
            "defaultValue": "duplicate_transactions",
            "help": "The name of the collection where transaction IDs will be stored. (Default: duplicate_transactions)",
            "alwaysInSummary": true
          },
          {
            "type": "CHECKBOX",
            "name": "addTtlTimestamp",
            "checkboxText": "Add Date and time for Firestore TTL",
            "simpleValueType": true,
            "help": "Saves a specially formatted \u0027Date and time\u0027 timestamp (ISO 8601) required by Firestore\u0027s native Time-To-Live (TTL) engine. This allows Firestore to automatically delete old transactions based on your Cookie Expiration setting. Note: You must also create a TTL policy for this field in Firestore.",
            "defaultValue": true
          },
          {
            "type": "TEXT",
            "name": "ttlFieldName",
            "displayName": "Time-To-Live Field Name",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "addTtlTimestamp",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": "time_to_live"
          },
          {
            "type": "CHECKBOX",
            "name": "addTimestamp",
            "checkboxText": "Add Timestamp to document",
            "simpleValueType": true,
            "help": "Saves the exact time the transaction occurred. Highly recommended: You can use this field in Google Cloud to set up a TTL (Time-to-Live) policy to automatically delete old transactions."
          },
          {
            "type": "TEXT",
            "name": "timestampFieldName",
            "displayName": "Timestamp Field Name",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "addTimestamp",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": "timestamp",
            "help": "The name of the field in your database document where the time will be saved (e.g., \"timestamp\", \"created_at\")."
          }
        ],
        "enablingConditions": [
          {
            "paramName": "dbType",
            "paramValue": "firestore",
            "type": "EQUALS"
          }
        ],
        "groupStyle": "NO_ZIPPY",
        "displayName": "Google Cloud Firestore"
      },
      {
        "type": "GROUP",
        "name": "stapeGroup",
        "displayName": "Stape Store",
        "groupStyle": "ZIPPY_OPEN",
        "subParams": [
          {
            "type": "TEXT",
            "name": "stapeCollection",
            "displayName": "Stape Store Collection Name",
            "simpleValueType": true,
            "defaultValue": "default",
            "help": "Leave as \"default\" unless you have created a specific collection in Stape Store.",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "alwaysInSummary": true
          }
        ],
        "enablingConditions": [
          {
            "paramName": "dbType",
            "paramValue": "stape",
            "type": "EQUALS"
          }
        ]
      }
    ],
    "displayName": "Database Settings",
    "enablingConditions": [
      {
        "paramName": "deduplicationMode",
        "paramValue": "cookie_only",
        "type": "NOT_EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advancedSettingsGroup",
    "displayName": "Advanced Transaction ID handling",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "TEXT",
        "name": "ignoredIds",
        "displayName": "Ignored Transaction IDs (Comma-separated)",
        "simpleValueType": true,
        "help": "Enter placeholder IDs that should never be deduplicated (e.g., 0, test_order). Separate multiple values with a comma.",
        "valueHint": "0, test_order"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "transaction_id"
              },
              {
                "type": 1,
                "string": "event_name"
              },
              {
                "type": 1,
                "string": "x-ga-gcs"
              },
              {
                "type": 1,
                "string": "x-ga-gcd"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gtm-identifier"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gtm-default-domain"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gtm-api-key"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://firestore.googleapis.com/*"
              },
              {
                "type": 1,
                "string": "https://*.stape.io/*"
              },
              {
                "type": 1,
                "string": "https://*.stape.net/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "use_google_credentials",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedScopes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://www.googleapis.com/auth/datastore"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []

___NOTES___

Created on 8/31/2021, 9:02:14 PM

