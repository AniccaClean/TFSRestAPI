#region Work Item Relationship Types

### Work Item Relationship Types
### https://www.visualstudio.com/en-us/docs/integrate/api/wit/relation-types

function Get-WorkItemRelationshipTypes {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [string]$apiversion = "1.0"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/relation-types#get-a-list-of-relation-types
    #
    # GET https://{instance}/DefaultCollection/_apis/wit/workItemRelationTypes?api-version={version}
    #
    # Example:
    # Get-WorkItemRelationshipTypes -instance $instance

    $uri = "$instance/_apis/wit/workItemRelationTypes?api-version=$apiversion"

    Write-Verbose $uri


   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-WorkItemRelationshipType {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$name,
        [string]$apiversion = "1.0"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/relation-types#get-a-relation-type
    #
    # GET https://{instance}/DefaultCollection/_apis/wit/workItemRelationTypes/{name}?api-version={version}
    #
    # Example:
    # Get-WorkItemRelationshipType -instance $instance -name "System.LinkType.Related"

    # GET https://{instance}/DefaultCollection/_apis/wit/workItemRelationTypes?api-version={version}
    $uri = "$instance/_apis/wit/workItemRelationTypes/$($name)?api-version=$apiversion"

    Write-Verbose $uri

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#endregion