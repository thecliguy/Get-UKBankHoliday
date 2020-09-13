################################################################################
# Copyright (C) 2020
# Adam Russell <adam[at]thecliguy[dot]co[dot]uk> 
# https://www.thecliguy.co.uk
# 
# Licensed under the MIT License.
#
################################################################################
# Development Log:
#
# 1.0.0 - 2020-09-13 - Adam Russell
#   * First release.
#
################################################################################

Function Get-UKBankHoliday {
    <#
    .SYNOPSIS
        Gets UK bank holiday dates for a specific jurisdiction (England and 
	Wales, Scotland or Northern Ireland).
        
    .DESCRIPTION
        Uses the GOV.UK Bank Holidays API to obtain bank holiday dates for a
	specific jurisdiction (England and Wales, Scotland or Northern Ireland)
	in a given year and (optionally) month.
		
	For further details about GOV.UK APIs, see https://www.gov.uk/help/reuse-govuk-content
    
    .EXAMPLE  
        Get-UKBankHoliday -Month 4 -Year 2021 -Jurisdiction england-and-wales
        
        title         date                notes bunting
        -----         ----                ----- -------
        Good Friday   02/04/2021 00:00:00         False
        Easter Monday 05/04/2021 00:00:00          True
        
        # Gets the bank holiday(s) for England and Wales in April 2021.
    
    .EXAMPLE  
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
        
        # Gets all bank holidays for Scotland in 2021.
    
    .LINK
        https://github.com/thecliguy/Get-UKBankHoliday/
    #>

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$False)]
	[ValidateRange(1,12)]
        [Int]$Month,
        
        [parameter(Mandatory=$True)]
        [Int]$Year,
		
	[parameter(Mandatory=$True)]
	[ValidateSet('england-and-wales','scotland','northern-ireland')]
        [String]$Jurisdiction
    )
	
	$GovUkBankHolidaysApi = "https://www.gov.uk/bank-holidays.json"
	
	# I wanted all errors produced by Invoke-RestMethod to be terminating, 
	# however the cmdlet doesn't respect '-ErrorAction Stop'. As a workaround, 
	# wrapping the cmdlet in a Try/Catch and throwing an error works (AR). 
	Try {
		$Holidays = Invoke-RestMethod -Uri $GovUkBankHolidaysApi -ErrorAction Stop | Select-Object -expandproperty $Jurisdiction
	}
	Catch {
		Throw $_
	}
    
	# Check that the API supports the specified year.
	If (!($Holidays.Events.Date.ForEach({ (Get-Date $_).Where({ $_.Year -eq $Year }) }))) {
		Throw "The GOV.UK Bank Holidays API doesn't support the year $($Year)."
	}
	
	If ($PSBoundParameters.ContainsKey('Month')) {
		$RetVal = $Holidays.Events.Where({ ((Get-Date -Date $_.Date).Month -eq $Month) -and ((Get-Date -Date $_.Date).Year -eq $Year) })
	}
	Else {
		$RetVal = $Holidays.Events.Where({ (Get-Date -Date $_.Date).Year -eq $Year })
	}
	
	# Convert the date property from a string to a DateTime type.
	If ($RetVal) {
		$RetVal.ForEach({ $_.Date = [System.DateTime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) })
	}
	
	$RetVal
}
