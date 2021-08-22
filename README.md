# Block Duplicate Transactions - SGTM Variable
This Variable for **Google Tag Manager Server-side (SGTM)** makes it possible to **Block duplicate Transactions** from being sent to your analytics/marketing tools.

## How the Variable Works
Incoming **transaction_id** will be checked against **earlier transaction id's** from the user stored in a cookie. If **a match is found** the Variable will return **true** (duplicates is true). We can then block transactions from being sent if the Variable returns true.

If **no match is found** the Variable will return **false** (duplicates is false), and incoming **transaction_id** will be added to the cookie.

## Variable Settings
### Transaction ID Input
Text

### Cookie Settings
#### Cookie Name
Text

#### Cookie Expiration in Days
Text

#### Cookie Domain
Text

#### Same Site
Text

#### HttpOnly
Text

![Block Duplicate Transactions Variable Settings](https://github.com/gtm-templates-knowit-experience/sgtm-block-duplicate-transactions/blob/main/images/sgtm-block-duplicate-transactions-variable.png)

### Variable Permissions
The Variable Permissions are:
* Read Any Cookie
* Set Any Cookie
* Read Event Data **transaction_id**

## Trigger Settings for Blocking Duplicate Transactions
* Edit your existing Trigger(s)
* Add the settings as shown in the image below
  * YourVariableName *does not equal* **true**

![Trigger Settings for Blocking Duplicate Transactions](https://github.com/gtm-templates-knowit-experience/sgtm-block-duplicate-transactions/blob/main/images/sgtm-block-duplicate-transactions-trigger-settings.png)

## How to Really fix Duplicate Transactions
The best method to avoid duplicate transactions is to fix the ecommerce implementation. With SGTM it is possible to send data directly from the server to SGTM. Using this method for tracking transactions will ensure the best data quality, and no issues with duplicate transactions (if implemented correctly).
