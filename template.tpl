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
  "description": "Block Duplicate Ecommerce Transactions by checking incoming transaction_id  against previous transaction_id\u0027s is stored in a cookie.",
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
    "name": "consentGroup",
    "displayName": "Consent Check",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "consentCheck",
        "checkboxText": "Only set Cookie if Consent is given",
        "simpleValueType": true,
        "help": "Only set Cookie with Transaction ID\u0027s if the user has given consent. \n\u003cbr /\u003e\n\u003cbr /\u003e\nWhich level of Consent needed for setting the cookie, and which incoming parameter to check is up to you. But if you for example are using \u003cstrong\u003eGoogle Consent Mode\u003c/strong\u003e, you could check against the \u003cstrong\u003egcs\u003c/strong\u003e parameter.\n\u003cbr /\u003e\n\u003cbr /\u003e\nIf the user \u003cstrong\u003ehaven\u0027t given consent\u003c/strong\u003e, any existing Block Duplicate Transactions \u003cstrong\u003ecookie will be deleted\u003c/strong\u003e.",
        "alwaysInSummary": true
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
            "paramName": "consentCheck",
            "paramValue": true,
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
        "name": "sha256Sync",
        "checkboxText": "Hash transaction_id as SHA-256",
        "simpleValueType": true,
        "help": "Hash \u003cstrong\u003etransaction_id\u003c/strong\u003e stored in the cookie with \u003cstrong\u003eSHA-256\u003c/strong\u003e .\n\u003cbr/\u003e\u003cbr/\u003e\nThis makes the \u003cstrong\u003etransaction_id\u003c/strong\u003e stored in the cookie unrecognizable.",
        "alwaysInSummary": true
      },
      {
        "type": "SELECT",
        "name": "sha256Encoding",
        "displayName": "SHA-256 Encoding",
        "selectItems": [
          {
            "value": "base64",
            "displayValue": "Base64"
          },
          {
            "value": "hex",
            "displayValue": "Hex"
          }
        ],
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "sha256Sync",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "limitCookie",
        "checkboxText": "Limit  Cookie Size",
        "simpleValueType": true,
        "help": "Limit  number of Transaction ID\u0027s stored in the cookie to avoid that the size of the cookie grows too big.\n\u003cbr /\u003e\u003cbr /\u003e\nWhen the limit is reached, the oldest Transaction ID will be deleted from the cookie when a new Transaction ID is added.",
        "alwaysInSummary": true
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
        "alwaysInSummary": true
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
        "name": "cookieExpiration",
        "displayName": "Cookie Expiration in Days",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "defaultValue": 90,
        "help": "Enter how many days the cookie should live.",
        "alwaysInSummary": true,
        "valueHint": "90",
        "valueUnit": "days"
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
        ],
        "alwaysInSummary": true
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
        "help": "The SameSite attribute controls what contexts your cookie will be used in.  \n\u003cbr /\u003e\u003cbr /\u003e\nTo see the differences between Lax and Strict settings, see the \u003ca href\u003d\"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite\" target\u003d\"_blank\"\u003e\u003cstrong\u003eMDN documentation\u003c/strong\u003e\u003c/a\u003e. If set to \u0027Value not set\u0027 the SameSite attribute will not be written.",
        "alwaysInSummary": true
      },
      {
        "type": "CHECKBOX",
        "name": "cookieHttpOnly",
        "checkboxText": "HttpOnly",
        "simpleValueType": true,
        "help": "If \u003cstrong\u003echecked\u003c/strong\u003e,  the cookie is set as \u003cstrong\u003eHttpOnly\u003c/strong\u003e, which forbids JavaScript from accessing the cookie.",
        "alwaysInSummary": true
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const queryPermission = require('queryPermission');
const getEventData = require('getEventData');

const keyPath = 'transaction_id';
if (queryPermission('read_event_data', keyPath)) {
  let transaction_id = data.transactionIdVariable ? data.transactionIdVariable : getEventData(keyPath);

  if(transaction_id) {
    const setCookie = require('setCookie');
    const cookieName = data.cookieName;
    const cookieOptions = {
      domain: data.cookieDomain,
      path: '/',
      sameSite: data.cookieSameSite,
      secure: true
    };

    let consent = true;
    if(data.consentCheck && data.consentParam) {
      data.consentParam.forEach((consentArray) => {
        if (consentArray.consentInput === consentArray.consentValue) {
          consent = true;
        } else {
          consent = false;
          cookieOptions['max-age'] = 0;
          setCookie(cookieName, '', cookieOptions);
        }
      });
    }
    if(consent){ 
      const JSON = require('JSON');
      const getCookieValues = require('getCookieValues');
      if (queryPermission('get_cookies', cookieName)) {
        let cookieValue = getCookieValues(cookieName).length>0 ? JSON.parse(getCookieValues(cookieName)) : JSON.parse('[]');
      
        if(data.sha256Sync) {
          const sha256Sync = require('sha256Sync');
          transaction_id = sha256Sync(transaction_id, {outputEncoding: data.sha256Encoding});
        }
      
        if(cookieValue.indexOf(transaction_id) === -1) {
          cookieValue.push(transaction_id);
        
          if(data.limitCookie && cookieValue.length > data.limitCookieNumber) {
            cookieValue.splice(0, cookieValue.length-data.limitCookieNumber);        
          }       
        
          cookieOptions['max-age'] = (data.cookieExpiration*86400);
          if (data.cookieHttpOnly) cookieOptions.HttpOnly = data.cookieHttpOnly;
          setCookie(cookieName, JSON.stringify(cookieValue), cookieOptions, true);
            return false;
       } else if(cookieValue.indexOf(transaction_id) > -1) {
            return true;
        }
      }
    }
  }
}


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
  }
]


___TESTS___

scenarios: []
setup: |-
  const transactionIdCookie = ["T1234","ABC"];
  const transaction_id = "ABC";


___NOTES___

Created on 8/31/2021, 9:02:14 PM


