# Block Duplicate Transactions - SGTM Variable
This Variable for **Google Tag Manager Server-side (SGTM)** makes it possible to **Block Duplicate Transactions** from being sent to your analytics/marketing tools.

## How the Variable Works
Incoming **transaction_id** will be checked against **earlier transaction id's** from the user stored in a cookie. If **a match is found**, the Variable will return **true** (duplicate is true). We can then block transactions from being sent based on this output.

If **no match is found** the Variable will return **false** (duplicate is false), and incoming **transaction_id** will be added to the cookie.
Transaction ID's will be stored in the cookie as an array (e.g. ["123","456"]).

## Variable Settings
![Block Duplicate Transactions Variable Settings](https://github.com/gtm-templates-knowit-experience/sgtm-block-duplicate-transactions/blob/main/images/sgtm-block-duplicate-transactions-variable.png)

### Transaction ID Input
As standard **transaction_id** is read from **Event Data**, but you can choose to read it from a **Variable** if you want.

### Limit Cookie Size
Limit  number of Transaction ID's stored in the cookie to avoid that the size of the cookie grows out of proportions.

When the limit is reached, the oldest Transaction ID(s) will be deleted from the cookie to to make space for the latest Transaction ID.

#### Example
In this example, the limit is set to 2 Transaction ID's. This is the Cookie Value:
["12", "34"]

The user makes a new Transaction with the Transaction ID **56**. This is now the new Cookie Value:
["34", "56"]

### Cookie Settings
#### Cookie Name
Choose the name of the cookie. Suggested name is **sgtm_transactions_ids**, where **sgtm_** is a prefix which tells that SGTM set this cookie.

#### Cookie Expiration in Days
Enter how many days the cookie should live.

#### Cookie Domain
If you set Domain to **auto**, the Variable will try to write the cookie on the highest possible level in the domain name hierarchy (e.g. .domain.com).
For technical information, see the **[setCookie documentation](https://developers.google.com/tag-manager/serverside/api#setcookie)**.

#### Same Site
The **SameSite attribute** controls what contexts your cookie will be used in. You can set SameSite as **Lax**, **Strict** or **Value not set**. If set to 'Value not set' the SameSite attribute will not be written.

To see the differences between Lax and Strict settings, see the **[MDN documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite)**. 

#### HttpOnly
If **checked**, the cookie is set as HttpOnly, which forbids JavaScript from accessing the cookie.

If you need to read this cookie in GTM (Web), HttpOnly must be **unchecked**.

## Trigger Settings for Blocking Duplicate Transactions
* Edit your existing Trigger(s)
* Add the setting as shown in the image below
  * YourVariableName *does not equal* **true**

![Trigger Settings for Blocking Duplicate Transactions](https://github.com/gtm-templates-knowit-experience/sgtm-block-duplicate-transactions/blob/main/images/sgtm-block-duplicate-transactions-trigger-settings.png)

## The best method for avoiding Duplicate Transactions
The best method to avoid duplicate transactions is to fix the ecommerce implementation. With SGTM it is also possible to send data directly from your server to SGTM, which is the best method for ensuring high data quality. With other words, aim for fixing the implementation, and use this Variable as a temporary solution.
