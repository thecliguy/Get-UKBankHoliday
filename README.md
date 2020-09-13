# Get-UKBankHoliday

Gets UK bank holiday dates for a specific jurisdiction (England and Wales, 
Scotland or Northern Ireland).

DESCRIPTION
------------
Uses the GOV.UK Bank Holidays API to obtain bank holiday dates for a specific 
jurisdiction (England and Wales, Scotland or Northern Ireland) in a given year 
and (optionally) month.

USAGE
-----
```
Get-UKBankHoliday [[-Month] <Int32>] 
                  [-Year] <Int32> 
                  [-Jurisdiction] <String> 
```

EXAMPLES
--------
Get the bank holiday(s) for England and Wales in April 2021:
```
Get-UKBankHoliday -Month 4 -Year 2021 -Jurisdiction england-and-wales

title         date                notes bunting
-----         ----                ----- -------
Good Friday   02/04/2021 00:00:00         False
Easter Monday 05/04/2021 00:00:00          True
```

Gets all bank holidays for Scotland in 2021:
```
Get-UKBankHoliday -Year 2021 -Jurisdiction scotland

title                  date                notes          bunting
-----                  ----                -----          -------
New Year’s Day         01/01/2021 00:00:00                   True
2nd January            04/01/2021 00:00:00 Substitute day    True
Good Friday            02/04/2021 00:00:00                  False
Early May bank holiday 03/05/2021 00:00:00                   True
Spring bank holiday    31/05/2021 00:00:00                   True
Summer bank holiday    02/08/2021 00:00:00                   True
St Andrew’s Day        30/11/2021 00:00:00                   True
Christmas Day          27/12/2021 00:00:00 Substitute day    True
Boxing Day             28/12/2021 00:00:00 Substitute day    True
```

FURTHER READING
---------------
This function features in a blog post I wrote, see https://www.thecliguy.co.uk/2020/01/25/get-the-nth-working-day-of-the-month/
