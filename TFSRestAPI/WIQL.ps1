
#region WIQL - Work Item Query Language

### WIQL - Work Item Query Language 
### https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql

#############################################################
# .SYNOPSIS
# Run a TFS Query
# .DESCRIPTION
# Run a TFS Query
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER timePrecision
# True if time precision is allowed in the date time comparisons.
# .PARAMETER query
# The query string to run.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql#run-a-query
#############################################################
function Invoke-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [bool]$timePrecision,
        [Parameter(Mandatory=$true)][string]$query,
        [string]$apiversion = "1.0"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/wiql#run-a-query
    #
    # POST https://{instance}/DefaultCollection/[{project}/]_apis/wit/wiql?api-version={version}
    #
    # Example:

    $uri = "$instance/$project/_apis/wit/wiql?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ query = $query }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

    $params = @{ Method = "Post"; Uri = $uri; Body = $json; ContentType = 'application/json'}

    return invoke_rest $params
}


#endregion