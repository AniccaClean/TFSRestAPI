#region Team Days Off

### Team Days Off
### https://www.visualstudio.com/en-us/docs/integrate/api/work/team-days-off

function Get-TeamDaysOff {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationId,
        [string]$apiversion = "2.0-preview.1"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/team-days-off#get-a-teams-days-off
    #
    # GET https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationId}/TeamDaysOff?api-version={version}
    #
    # Example:
    # Get-TeamDaysOff -instance $instance -project $project -team $team -iterationId $iteration6.id

    $uri = "$instance/$project/$team/_apis/work/TeamSettings/Iterations/$iterationId/TeamDaysOff?api-version=$apiversion"

    Write-Verbose $uri

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Set-TeamDaysOff {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationId,
        [string]$apiversion = "2.0-preview.1",
        [Parameter(Mandatory=$true)][object[]]$daysOff
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/team-days-off#set-a-teams-days-off
    #
    # PATCH https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationId}/TeamDaysOff?api-version={version}
    #
    # Example:
    # For the given team, give them 4/11/2017 and 4/12/2017 through 4/14/2017 off during iteration 6
    # $daysOff = @(@{ start = "2017-04-11T00:00:00Z"; end = "2017-04-11T00:00:00Z" },
    #            @{ start = "2017-04-12T00:00:00Z"; end = "2017-04-14T00:00:00Z" })
    # Set-TeamDaysOff -instance $instance -project $project -team $team -iterationId $iteration6.id -daysOff $daysOff

    $uri = "$instance/$project/$team/_apis/work/TeamSettings/Iterations/$iterationId/TeamDaysOff?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ daysOff = $daysOff }
    
    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   # return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#endregion