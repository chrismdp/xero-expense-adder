# Expense Adder

A little utility script to help me add expenses in a certain format into Xero quickly as a Payment Invoice.

## Usage

To use create a yaml file with the following in it:

    ---
    key: <your xero key>
    secret: <your xero secret>
    contact: <your contact - used for the name on the AP invoice>

Then type:

    $ ruby expenseadder.rb path/to/folder/with/expenses

Your expenses need to be in one folder, in the format:

    yyyy-mm-dd Name of Seller £xx.xx.pdf

Have fun! Patches and contributions welcome.
