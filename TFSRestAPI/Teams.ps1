### Teams
### https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams

#############################################################
# .SYNOPSIS
# Get the list of teams within a TFS project.
# .DESCRIPTION
# Get the list of teams under a particular TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER top
# Maximum number of teams to return.
# .PARAMETER skip
# Number of teams to skip.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#get-a-list-of-teams
#############################################################
function Get-Teams {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [int]$top,
        [int]$skip,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams?api-version=$apiversion"

    if ($top -ne 0) {
        $uri += "&`$top=$($top)"
    }
    if ($skip -ne 0) {
        $uri += "&`$skip=$($skip)"
    }

    Write-Verbose $uri

   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
   return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Get the team's information based on the team name.
# .DESCRIPTION
# Get the team's information based on the team name.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team
# Name or ID of the team.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#get-a-team
#############################################################
function Get-Team {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams/$($team)?api-version=$apiversion"

    Write-Verbose $uri

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Get the team members for the given team.
# .DESCRIPTION
# Get the team members for the given team.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team 
# Name or ID of the team.
# .PARAMETER top
# Maximum number of teams to return. Default: 100
# .PARAMETER skip
# Number of teams to skip.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#get-a-teams-members
#############################################################
function Get-TeamMembers {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [int]$top,
        [int]$skip,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams/$($team)/members?api-version=$apiversion"

    if ($top -ne 0) {
        $uri += "&`$top=$($top)"
    }
    if ($skip -ne 0) {
        $uri += "&`$skip=$($skip)"
    }

    Write-Verbose $uri

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Create a new team under the TFS project.
# .DESCRIPTION
# Create a new team under the TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER name
# Name of the team.
# .PARAMETER description
# Description of the team.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#create-a-team
#############################################################
function New-Team {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$name,
        [Parameter(Mandatory=$true)][string]$description,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ name = "$name"; description = "$description"; }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

  #  return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Create a new team under the TFS project.
# .DESCRIPTION
# Create a new team under the TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team
# Name or ID of the project.
# .PARAMETER name
# New name of the team.
# .PARAMETER description
# New description of the team.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#update-a-team
#############################################################
function Update-Team {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [Parameter(Mandatory=$true)][string]$name,
        [Parameter(Mandatory=$true)][string]$description,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams/$($team)?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ name = "$name"; description = "$description"; }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

  #  return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Create a new team under the TFS project.
# .DESCRIPTION
# Create a new team under the TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Name or ID of the project.
# .PARAMETER team
# Name or ID of the project.
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#delete-a-team
#############################################################
function Remove-Team {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [string]$apiversion = "2.2"
    )

    $uri = "$instance/_apis/projects/$($project)/teams/$($team)?api-version=$apiversion"

    Write-Verbose $uri

  # return Invoke-RestMethod -Method Delete -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Delete'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}
