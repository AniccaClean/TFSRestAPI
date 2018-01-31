#region Work Items

### Work Items
### https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items

#############################################################
# .SYNOPSIS
# Get the list of teams within a TFS project
# .DESCRIPTION
# Get the list of teams under a particular TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER ids
# A comma-separated list of up to 200 IDs of the work items to get.
# .PARAMETER fields
# A comma-separated list of up to 100 fields to get with each work item.
# If not specified, all fields with values are returned. Calculated fields such as Attached File Count must be specifically queried for using this parameter.
# .PARAMETER asOf
# Gets the work items as they existed at this time. DateTime.
# .PARAMETER expand
# Gets work item relationships (work item links, hyperlinks, file attachements, etc.). enum { all, relations, none } Default: none.
# .PARAMETER ErrorPolicy
# Determines if the call will throw an error when encountering a work item (default behavior) that doesn't exist or simply omit it. string { throw, omit } Default: none.
# .PARAMETER apiversion
# Version of the API to use.
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#get-a-list-of-work-items
#############################################################
function Get-WorkItems {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [string]$Ids,
        [string]$Fields,
        [datetime]$AsOf,
        [ValidateSet('all','relations','none')]
        [string]$Expand = "none", # all, relations, none
        [ValidateSet('throw','omit')]
        [string]$ErrorPolicy = "throw", # throw, omit
        [string]$APIVersion = "1.0",
        [ValidateNotNull()]
        [PSCredential]$Credential
    )

    $Uri = "$Instance/_apis/wit/workitems?api-version=$APIVersion"

    if ($Ids -ne "") {
        $Uri += "&ids=$Ids"
    }
    if ($Fields -ne "") {
        $Uri += "&fields=$Fields"
    }
    if ($AsOf -ne $null) {
        $Uri += "&asOf=$AsOf"
    }
    if ($Expand -ne "") {
        $Uri += "&`$expand=$Expand"
    }
    if ($ErrorPolicy -ne "") {
        $Uri += "&ErrorPolicy=$ErrorPolicy"
    }

    Write-Verbose $Uri

   $Params = @{ Credential = $Credential; Method = "Get"; Uri = $Uri; ContentType = 'application/json'}

   return invoke_rest $Params
}

#############################################################
# .SYNOPSIS
# Get a TFS work item
# .DESCRIPTION
# Get a TFS work item
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER id
# ID of the work item to retrieve.
# .PARAMETER expand
# Gets work item relationships (work item links, hyperlinks and file attachements).  enum { all, relations, none }
# .PARAMETER apiversion
# Version of the TFS REST API version to use
#
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#get-a-work-item
#############################################################
function Get-WorkItem {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [Parameter(Mandatory=$true)][string]$Id,
        [ValidateSet('all','relations','none')]
        [string]$Expand = "none",
        [string]$APIVersion = "1.0",
        [ValidateNotNull()]
        [PSCredential]$Credential
    )

    $Uri = "$Instance/_apis/wit/workitems/$($Id)?api-version=$APIVersion"

    if ($Expand -ne "") {
        $Uri += "&`$expand=$Expand"
    }

    Write-Verbose $Uri
   
    $Params = @{ Credential = $Credential; Method = "Get"; Uri = $Uri; ContentType = 'application/json'}

    return invoke_rest $Params
}


function Get-WorkItemDefaultValues {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [Parameter(Mandatory=$true)][string]$Project,
        [ValidateSet('Task','Product Backlog Item','Bug')]
        [Parameter(Mandatory=$true)][string]$WorkItemTypeName,
        [string]$APIVersion = "1.0",
        [PSCredential]$Credential
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#get-default-values
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/wit/workitems/${workItemTypeName}?api-version={version}
    #
    # Example:
    # Get-WorkItemDefaultValues -instance $instance -project $project -workItemTypeName "Product Backlog Item"

    $Uri = "$Instance/$Project/_apis/wit/workitems/`$$($WorkItemTypeName)?api-version=$APIVersion"

    Write-Verbose $Uri

    $Params = @{ Credential = $Credential; Method = "Get"; Uri = $Uri; ContentType = 'application/json'}

    return invoke_rest $Params
}


function New-WorkItem {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [Parameter(Mandatory=$true)][string]$Project,
        [ValidateSet('Task','Product Backlog Item','Bug')]
        [Parameter(Mandatory=$true)][string]$WorkItemTypeName, # Task, Product Backlog Item, Bug
        [Parameter(Mandatory=$true)][array]$PatchDocument,
        [string]$APIVersion = "1.0",
        [Parameter(Mandatory=$true)][PSCredential]$Credential
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#create-a-work-item
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/workitems/${workItemTypeName}?api-version={version}
    #
    # Example:
    # $patchDocument = @([PSCustomObject]@{op="add";path="/fields/System.Title";value="One more JSON test - Updated"},
    #                   [PSCustomObject]@{op="add";path="/fields/System.IterationPath";value="CDW\2017"})
    # New-WorkItem -instance $instance -project $project -workItemTypeName "Product Backlog Item" -patchDocument $patchDocument

    $Uri = "$Instance/$Project/_apis/wit/workitems/`$$($WorkItemTypeName)?api-version=$APIVersion"

    Write-Verbose $Uri

    $PostData = $PatchDocument

    Write-Verbose ($PostData | Out-String)

    $Json = $PostData | ConvertTo-Json

    # In PowerShell, an array of length 1 will flatten and the JSON format will not contain the brackets. We need to modify our json string to accomodate this.
    if ($Json.StartsWith("[") -eq $false) {
        $Json = "[" + $Json
    }
    if ($Json.EndsWith("]") -eq $false) {
        $Json = $Json + "]"
    }
    
    Write-Verbose $Json

    $Params = @{ Credential = $Credential; Method = "Patch"; Uri = $Uri;  Body = $Json; ContentType = 'application/json-patch+json'}

    return invoke_rest $Params
}

#############################################################
# .SYNOPSIS
# Get the list of teams within a TFS project
# .DESCRIPTION
# Get the list of teams under a particular TFS project.
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER id
# ID of the work item to retrieve.
# .PARAMETER patchDocument
# Contains the changes to be made to the work item. See MSDN documentation for more information.
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
#
# $patchDocument = @([PSCustomObject]@{op="add";path="/fields/System.Title";value="One more JSON test - Updated"},
#                  [PSCustomObject]@{op="add";path="/fields/System.IterationPath";value="CDW\2017"})
# Update-WorkItem -instance $instance -id 2801927 -patchDocument $patchDocument
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#update-work-items
#############################################################
function Update-WorkItem {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$id,
        [Parameter(Mandatory=$true)][array]$patchDocument,
        [string]$apiversion = "1.0"
    )

    $uri = "$instance/_apis/wit/workitems/$($id)?api-version=$apiversion"
    
    Write-Verbose $uri

    $postData = $patchDocument

    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

    # In PowerShell, an array of length 1 will flatten and the JSON format will not contain the brackets. We need to modify our json string to accomodate this.
    if ($json.StartsWith("[") -eq $false) {
        $json = "[" + $json
    }
    if ($json.EndsWith("]") -eq $false) {
        $json = $json + "]"
    }
    
    Write-Verbose $json

   # return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json-patch+json'
   $params = @{ Method = "Patch"; Uri = $uri; Body = $json; ContentType = 'application/json-patch+json'}

   return invoke_rest $params
}

function Remove-WorkItem {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][string]$id
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#delete-a-work-item
    #
    # DELETE https://{instance}/DefaultCollection/_apis/wit/workitems/{id}?api-version={version}
    #
    # Example:
    # Remove-WorkItem -instance $instance -id 2801927

    $uri = "$instance/_apis/wit/workitems/$($id)?api-version=$apiversion"

    Write-Verbose $uri

  #  return Invoke-RestMethod -Method Delete -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json-patch+json'

  $params = @{ Method = "Delete"; Uri = $uri;  ContentType = 'application/json-patch+json'}

   return invoke_rest $params
}


#endregion