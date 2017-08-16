#region Iterations

### Iterations
### https://www.visualstudio.com/en-us/docs/integrate/api/work/iterations

#############################################################
# .SYNOPSIS
# Get the list of teams within a TFS project
# .DESCRIPTION
# Get the list of teams under a particular TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team
# Name or ID of the team.
# .PARAMETER timeframe
# A filter for which iterations are returned based on relative time. enum { current }
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/work/iterations#get-a-teams-iterations
#############################################################
function Get-TeamIterations {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [string]$timeframe, # current
        [string]$apiversion = "v2.0-preview"
    )
    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations?api-version=$apiversion"

    if ($timeframe -ne "") {
        $uri += "&`$timeframe=current"
    }

    Write-Verbose $uri

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-TeamIterationSettings {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationId,
        [string]$apiversion = "v2.0-preview"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/iterations#get-team-settings-for-an-iteration
    #
    # GET https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationId}?api-version={version}
    #
    # Example: 
    # $iterations = Get-TeamIterations -instance $instance -project $project -team $team
    # Test with just the first iteration
    # $settings = Get-TeamIterationSettings -instance $instance -project $project -team $team -iterationId $iterations.value[0].id -Verbose

    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations/$($iterationId)?api-version=$apiversion"

    Write-Verbose $uri

    #return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

# This item isn't working now. there is a POST call that passes an id value GUID to the post data, but MS doesn't document it.
function New-TeamIteration {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$id,
        [string]$apiversion = "v2.0-preview"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/iterations#add-an-iteration-to-the-team
    #
    # POST https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations?api-version={version}
    #
    # Example: 
    # New-TeamIteration -instance $instance -project $project -team $team -Verbose

    # TODO: This item is incomplete and needs to be finished. It calls a POST and there is no body data
    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ id = "$id"; }
    
    $json = $postData | ConvertTo-Json
    
    Write-Verbose $json

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json'; }

    return invoke_rest $params
   # return Invoke-RestMethod -Method Post -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
}

function Disable-TeamIteration {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationId,
        [string]$apiversion = "v2.0-preview"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/iterations#remove-an-iteration-from-the-team
    #
    # DELETE https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationId}?api-version={version}
    #
    # Example
    # Disable-TeamIteration -instance $instance -project $project -team $team -iterationId $iteration.id -Verbose

    # Whilte the Rest API documentation says this is a DELETE method, this actually just unchecks the iteration's value to inactivate the iteration

    # https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationId}?api-version={version}
    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations/$($iterationId)?api-version=$apiversion"

    Write-Verbose $uri

    #return Invoke-RestMethod -Method Delete -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Delete'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#endregion