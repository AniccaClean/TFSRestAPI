
#region WIQL - Work Item Query Language

### WIQL - Work Item Query Language 
### https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql

#############################################################
# .SYNOPSIS
# Run a TFS Query
# .DESCRIPTION
# Run a TFS Query
# 
# .PARAMETER Instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER Project
# Name or ID of the project.
# .PARAMETER TimePrecision
# True if time precision is allowed in the date time comparisons.
# .PARAMETER Query
# The query string to run.
# .PARAMETER APIVersion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql#run-a-query
#############################################################
function Invoke-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [Parameter(Mandatory=$true)][string]$Project,
        [bool]$TimePrecision,
        [Parameter(Mandatory=$true)][string]$Query,
        [string]$APIVersion = "1.0",
        [Parameter(Mandatory=$true)][PSCredential]$Credential
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql#run-a-query
    #
    # POST https://{instance}/DefaultCollection/[{project}/]_apis/wit/wiql?api-version={version}
    #
    # Example:

    $Uri = "$Instance/$Project/_apis/wit/wiql?api-version=$APIVersion"

    Write-Verbose $Uri

    $PostData = @{ query = $Query }

    $Json = $PostData | ConvertTo-Json

    Write-Verbose $Json

    $Params = @{ Credential = $Credential; Method = "Post"; Uri = $Uri;  Body = $Json; ContentType = 'application/json'}

    return invoke_rest $Params
}


#endregion