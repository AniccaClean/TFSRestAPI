############################
# Author: Adam Newhard
# Date: 7/20/2017
#
# Description:
# The following TFS Rest API PowerShell module leverages the Microsoft TFS Rest API via PowerShell to automate portions of 
# Team Foundation Services. 
# The root of the documentation for this REST API is available at https://www.visualstudio.com/en-us/docs/integrate/api/overview
#
# Instructions:
# In order to use this module, you must get a copy of the entire TFS_Rest_API directory, move to that directory, and execute the following
# in PowerShell.
# 
# Import-Module '.\TFS_Rest_API.psm1'
#
############################

# NOTE: Much of this code and loading structure was borrowed from the original TFS rest API implementation at
# https://github.com/majkinetor/TFS/blob/master/TFS/TFS.psm1

# TODO: Change to $PSScriptRoot when we run it via a moduel
$path = "C:\Users\ANEWHARD\Documents\GitHub\TFSRestAPI\TFSRestAPI"

# Get a list of all the functions avaiable before loading the TFS_Rest_API
$pre = Get-ChildItem Function:\*
# Execute all ps1. files that start with a capital letter to load the functions locally
Get-ChildItem "$path\*.ps1" | ? { $_.Name -cmatch '^[A-Z]+' } | % { . $_ }
# Get a list of all the functions now available after running the ps1 files
$post = Get-ChildItem Function:\*
$funcs = Compare-Object $pre $post | Select-Object -Expand InputObject | Select-Object -Expand Name
# Export all the functions that start with a capital letter that were found
$funcs | ? { $_ -cmatch '^[A-Z]+'} | % { Export-ModuleMember -Function $_ }


# Run the code that contains helper functions
. "$path\_globals.ps1"