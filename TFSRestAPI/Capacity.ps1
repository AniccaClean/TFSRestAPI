#region Capacity 

### Capacity
### https://www.visualstudio.com/en-us/docs/integrate/api/work/capacity

function Get-TeamCapacity {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationid,
        [string]$apiversion = "2.0-preview.1"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/capacity#get-a-teams-capacity
    #
    # GET https://{instance}/DefaultCollection/{project}/{team}/_apis/work/TeamSettings/Iterations/{iterationid}/Capacities?api-version={version}
    #
    # Example:
    # Find the active "Iteration 8" and get the team capacity for the CDW Team under that iteration
    # $iterations = Get-TeamIterations -instance $instance -project $project -team $team
    # $iteration = $iterations.value | ? { $_.name -eq "Iteration 8" }
    # Get-TeamCapacity -instance $instance -project $project -team $team -iterationid $iteration.id

    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations/$($iterationid)/Capacities?api-version=$apiversion"

    Write-Verbose $uri

    #return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Get a team member's capacity
# .DESCRIPTION
# Get a team member's capacity
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team 
# Name or ID of the team.
# .PARAMETER iterationdi
# ID of the iteration.
# .PARAMETER member
# ID of the team member.
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
# Get Joe Shmoe's capacity for iteration CDW\2017\Iteration 6
# $teamMembers = Get-TeamMembers -instance $instance -project $project -team $team
# $teamMember = $teamMembers.value | ? { $_.displayName -eq "Shmoe, Joe" }
#
# $iterations = Get-TeamIterations -instance $instance -project $project -team $team
# $iteration6 = $iterations.value | ? { $_.path -eq "CDW\2017\Iteration 6" }
#
# $capacity = Get-TeamMemberCapacity -instance $instance -project $project -team $team -iterationid $iteration6.id -member $teamMember.id -Verbose
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/work/capacity#get-a-team-members-capacity
#############################################################
function Get-TeamMemberCapacity {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationid,
        [Parameter(Mandatory=$true)][string]$member,
        [string]$apiversion = "2.0-preview.1"
    )

    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations/$($iterationid)/Capacities/$($member)?api-version=$apiversion"

    Write-Verbose $uri

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Update-TeamMemberCapacity {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$iterationid,
        [Parameter(Mandatory=$true)][string]$member,
        [string]$apiversion = "2.0-preview.1",
        [Parameter(Mandatory=$true)][string]$activityName, # Deployment, Design, Development, Documentation, Localization, Program Managment, Testing (localized)
        [Parameter(Mandatory=$true)][int]$capacityPerDay
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/capacity#update-a-team-members-capacity
    #
    # PATCH https://{instance}/DefaultCollection/{project}/{team}/_apis/Work/TeamSettings/Iterations/{iterationid}/capacities/{member}?api-version={version}
    #
    # Example:
    # Update the team member, Tim Barry, in iteration 6 to have a capacity of 2 for the activity of Testing
    # $teamMembers = Get-TeamMembers -instance $instance -project $project -team $team
    # $teamMember = $teamMembers.value | ? { $_.displayName -eq "Barry, Tim" }
    #
    # $iterations = Get-TeamIterations -instance $instance -project $project -team $team
    # $iteration6 = $iterations.value | ? { $_.path -eq "CDW\2017\Iteration 6" }
    # 
    # Update-TeamMemberCapacity -instance $instance -project $project -team $team -iterationid $iteration6.id -member $teamMember.id -activityName "Testing" -capacityPerDay 2 -Verbose
    $uri = "$instance/$($project)/$($team)/_apis/work/TeamSettings/Iterations/$($iterationid)/Capacities/$($member)?api-version=$($apiversion)"

    Write-Verbose $uri

    $postData = @{ activities = @(@{ name = "$activityName"; capacityPerDay = $capacityPerDay }) }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   # return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#endregion