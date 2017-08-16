#region Team Settings

### Team Settings
### https://www.visualstudio.com/en-us/docs/integrate/api/work/team-settings

function Get-TeamSettings {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [string]$apiversion = "3.0-preview.1"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/team-settings#get-a-teams-settings
    #
    # GET https://{instance}/DefaultCollection/{project}/{team}/_apis/Work/TeamSettings?api-version={version}
    #
    # Example:
    # Get-TeamSettings -instance $instance -project $project -team $team

    $uri = "$instance/$project/$team/_apis/Work/TeamSettings?api-version=$apiversion"

    Write-Verbose $uri

    #return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Update-TeamSettings {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$team,
        [string]$apiversion = "3.0-preview.1",
        [string]$bugsBehavior, # AsRequirements, AsTasks, Off
        [string[]]$workingDays, # monday, tuesday, wednesday, thursday, friday, saturday, sunday
        [hashtable]$backlogVisibilities, # A dictionary of keys (Microsoft.EpicCategory, Microsoft.FeatureCategor, Microsoft.RequirementCategory) and boolean values.
        [string]$defaultIteration
        # Possible incomplete list of parameters
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/work/team-settings#update-a-teams-settings
    #
    # NOTE: The documentation calls out only says we can only pass bugBehavior, workingDays, and backlogVisibilities
    #
    # PATCH https://{instance}/DefaultCollection/{project}/{team}/_apis/Work/TeamSettings?api-version={version}
    #
    # Example:
    # $bugsBehavior = "AsRequirements"
    # $workingDays = @("monday", "tuesday", "wednesday", "thursday", "friday")
    # $backlogVisibilities = @{"Microsoft.EpicCategory" = $false; "Microsoft.FeatureCategory" = $false; "Microsoft.RequirementCategory" = $true}
    # Update-TeamSettings -instance $instance -project $project -team $team -bugsBehavior $bugsBehavior -workingDays $workingDays -backlogVisibilities $backlogVisibilities -Verbose

    $uri = "$instance/$project/$team/_apis/Work/TeamSettings?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ }
    
    if ($bugsBehavior -ne "") {
        $postData.Add("bugsBehavior", $bugsBehavior)
    }
    if ($workingDays -ne $null) {
        $postData.Add("workingDays", $workingDays)
    }
    if ($backlogVisibilities -ne $null) {
        $postData.Add("backlogVisibilities", $backlogVisibilities)
    }
    if ($defaultIteration -ne "") {
        $postData.Add("defaultIteration", $defaultIteration)
    }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

  #  return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#endregion