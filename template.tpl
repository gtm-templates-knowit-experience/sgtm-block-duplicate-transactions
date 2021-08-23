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
  "description": "Block Duplicate Transactions by checking transaction_id  against previous transaction_id\u0027s is stored in a cookie.",
"categories": ["UTILITY","TAG_MANAGEMENT","ANALYTICS"],
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "transactionIdInputGroup",
    "displayName": "",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "transactionIdInput",
        "displayName": "Transaction ID Input",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "transaction_id",
            "displayValue": "transaction_id"
          },
          {
            "value": "variable",
            "displayValue": "Variable"
          }
        ],
        "simpleValueType": true,
        "help": "By default, \u003cstrong\u003etransaction_id\u003c/strong\u003e will be read from \u003cstrong\u003eEvent Data\u003c/strong\u003e, but you can also choose to use a \u003cstrong\u003eVariable\u003c/strong\u003e as input.",
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
      },
      {
        "type": "CHECKBOX",
        "name": "limitCookie",
        "checkboxText": "Limit  Cookie Size",
        "simpleValueType": true,
        "help": "Limit  number of Transaction ID\u0027s stored in the cookie to avoid that the size of the cookie grows out of proportions.\n\u003cbr /\u003e\u003cbr /\u003e\nWhen the limit is reached, the oldest Transaction ID(s) will be deleted from the cookie to make space for the latest Transaction ID.",
        "alwaysInSummary": true
      },
      {
        "type": "TEXT",
        "name": "limitCookieNumber",
        "displayName": "Max Transaction ID\u0027s stored in Cookie",
        "simpleValueType": true,
        "defaultValue": 10,
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
  const transaction_id = data.transactionIdVariable ? data.transactionIdVariable : getEventData(keyPath);

  if(transaction_id) {
    const JSON = require('JSON');
    const getCookieValues = require('getCookieValues');
    const cookieName = data.cookieName;
    if (queryPermission('get_cookies', cookieName)) {
      let cookieValue = getCookieValues(cookieName).length>0 ? JSON.parse(getCookieValues(cookieName)) : JSON.parse('[]');
      
      if(cookieValue.indexOf(transaction_id) === -1) {
        cookieValue.push(transaction_id);
        
        if(data.limitCookie && cookieValue.length > data.limitCookieNumber) {
          cookieValue.splice(0, cookieValue.length-data.limitCookieNumber);        
        }       
        const setCookie = require('setCookie');
        const cookieOptions = {
          domain: data.cookieDomain,
          path: '/',
          'max-age': (data.cookieExpiration*86400),
          sameSite: data.cookieSameSite,
          secure: true
        };
        
        if (data.cookieHttpOnly) cookieOptions.HttpOnly = data.cookieHttpOnly;
        setCookie(cookieName, JSON.stringify(cookieValue), cookieOptions, true);
          return false;
     } else if(cookieValue.indexOf(transaction_id) > -1) {
          return true;
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

Created on 8/23/2021, 4:21:46 PM


