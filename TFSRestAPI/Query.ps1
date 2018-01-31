#region Queries

### Team Settings
### https://www.visualstudio.com/en-us/docs/integrate/api/work/team-settings

function Get-Queries {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [string]$folderPath,
        [int]$depth,
        [string]$expand, # enum { none, all, clauses, wiql }
        [bool]$includeDeleted,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#get-a-list-of-queries
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/wit/queries[/{folderPath}]?api-version={version}[&$depth={int}&$expand={enum{none,all,clauses,wiql}} ]
    #
    # Example:
    # Get-Queries -instance $instance -project $project -folderPath "Shared Queries" -depth 2 -expand "all"

    $uri = "$instance/$project/_apis/wit/queries?api-version=$apiversion"

    if ($folderPath -ne "") {
        $uri = "$instance/$project/_apis/wit/queries/$($folderPath)?api-version=$apiversion"
    }
    if ($depth -ne 0) {
        $uri += "&`$depth=$depth"
    }
    if ($expand -ne "") {
        $uri += "&`$expand=$expand"
    }
    if ($includeDeleted -ne $false) {
        $uri += "&`$includeDeleted=$includeDeleted"
    }

    Write-Verbose $uri

  #  return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$Instance,
        [Parameter(Mandatory=$true)][string]$Project,
        [string]$FolderPath,
        [int]$Depth,
        [ValidateSet('none','all','clauses', 'wiql')]
        [string]$Expand,
        [bool]$IncludeDeleted,
        [string]$APIVersion = "2.2",
        [Parameter(Mandatory=$true)][PSCredential]$Credential
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#get-a-query-or-folder
    #
    # NOTE: Get-Query is the same command as Get-Queries. This may be an error with Microsoft's documentation.
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{folderPath}?api-version={version}[&$depth={int}&$expand={enum{none,all,clauses,wiql}}&$includeDeleted={true,false} ]
    #
    # Example:
    # Get-Query -instance $instance -project $project -folderPath "Shared Queries" -depth 2 -includeDeleted $true 

    $Uri = "$Instance/$Project/_apis/wit/queries?api-version=$APIVersion"

    if ($FolderPath -ne "") {
        $Uri = "$Instance/$Project/_apis/wit/queries/$($FolderPath)?api-version=$APIVersion"
    }
    if ($Depth -ne 0) {
        $Uri += "&`$depth=$Depth"
    }
    if ($Expand -ne "") {
        $Uri += "&`$expand=$Expand"
    }
    if ($IncludeDeleted -ne $false) {
        $Uri += "&`$includeDeleted=$IncludeDeleted"
    }

    Write-Verbose $Uri

    $Params = @{ Credential = $Credential; Method = "Get"; Uri = $Uri; ContentType = 'application/json'}

    return invoke_rest $params
}

function New-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$folderPath,
        [Parameter(Mandatory=$true)][string]$name,
        [Parameter(Mandatory=$true)][string]$wiql,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#create-a-query
    #
    # POST https://{instance}/DefaultCollection/{project}/_apis/wit/queries[/{folderPath}]?api-version={version}
    #
    # Example:
    # $folderPath = "Shared Queries"
    # $wiql = "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Bug' order by [Microsoft.VSTS.Common.Priority] asc, [System.CreatedDate] desc"
    # New-Query -instance $instance -project $project -folderPath "Shared Queries" -name "Test Query - ATN" -wiql $wiql -Verbose

    $uri = "$instance/$project/_apis/wit/queries?api-version=$apiversion"

    if ($folderPath -ne "") {
        $uri = "$instance/$project/_apis/wit/queries/$($folderPath)?api-version=$apiversion"
    }

    Write-Verbose $uri

    $postData = @{ name = "$name"; wiql = "$wiql" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

    #return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function New-QueryFolder {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$folderPath,
        [Parameter(Mandatory=$true)][string]$name,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#create-a-folder
    #
    # POST https://{instance}/DefaultCollection/{project}/_apis/wit/queries[/{folderPath}]?api-version={version}
    #
    # Example:
    # Need to include

    $uri = "$instance/$project/_apis/wit/queries?api-version=$apiversion"

    if ($folderPath -ne "") {
        $uri = "$instance/$project/_apis/wit/queries/$($folderPath)?api-version=$apiversion"
    }

    Write-Verbose $uri

    $postData = @{ name = "$name"; isFolder = $true }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   #return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

   $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Update-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$folderPath, # Really the query path
        [Parameter(Mandatory=$true)][string]$query,
        [Parameter(Mandatory=$true)][string]$wiql,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#update-a-query
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/queries[/{folderPath}]/{query}?api-version={version}
    #
    # Example:
    # Update the query at "Shared Queries/Test Query - ATN"
    # $wiql = "Select [System.Id], [System.Title] From WorkItems Where [System.WorkItemType] = 'Bug' order by [Microsoft.VSTS.Common.Priority] asc, [System.CreatedDate] desc"
    # Update-Query -instance $instance -project $project -folderPath "Shared Queries" -query "Test Query - ATN" -wiql $wiql -Verbose

    $uri = "$instance/$project/_apis/wit/queries/$($folderPath)/$($query)?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ wiql = "$wiql" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

    #return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Rename-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$queryPath,
        [Parameter(Mandatory=$true)][string]$name,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#rename-a-query
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{queryPath}?api-version={version}
    #
    # Example:
    # Rename the query at Shared Queries/Test Query - ATN to "Test Query - Rename"
    # Rename-Query -instance $instance -project $project -queryPath "Shared Queries/Test Query - ATN" -name "Test Query - Rename"

    $uri = "$instance/$project/_apis/wit/queries/$($queryPath)?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ name = "$name" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   # return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'
   $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Rename-QueryFolder {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$folderPath,
        [Parameter(Mandatory=$true)][string]$name,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#rename-a-folder
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{folderPath}?api-version={version}
    #
    # Example:
    # Rename the folder at Shared Queries/Test Folder to have the name "Test Folder - Rename"
    # Rename-QueryFolder -instance $instance -project $project -folderPath "Shared Queries/Test Folder" -name "Test Folder - Rename" -Verbose


    $uri = "$instance/$project/_apis/wit/queries/$($folderPath)?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ name = "$name" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

    #return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'
    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Move-QueryOrFolder {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$folderPath,
        [Parameter(Mandatory=$true)][string]$id,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#move-a-query-or-folder
    #
    # POST https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{folderPath}?api-version={version}
    #
    # Example:
    # Get the query named "Test Query - Rename" and move it under "Shared Queries/Test Folder - Rename"
    # $query = Get-Query -instance $instance -project $project -folderPath "Shared Queries/Test Query - Rename" -Verbose
    # Move-QueryOrFolder -instance $instance -project $project -folderPath "Shared Queries/Test Folder - Rename" -id $query.id -Verbose

    $uri = "$instance/$project/_apis/wit/queries/$($folderPath)?api-version=$apiversion"

    Write-Verbose $uri

    $postData = @{ id = "$id" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

    #return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Hide-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$queryPath,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#delete-a-query-or-folder
    #
    # DELETE https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{queryPath}?api-version={version}
    #
    # Example:
    # Hide the query at Shared Queries/Test Folder - Rename/Test Query - Rename
    # Hide-Query -instance $instance -project $project -queryPath "Shared Queries/Test Folder - Rename/Test Query - Rename" -Verbose
    
    $uri = "$instance/$project/_apis/wit/queries/$($queryPath)?api-version=$apiversion"

    Write-Verbose $uri

   # return Invoke-RestMethod -Method Delete -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
   $params = @{ Method = 'Delete'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Show-Query {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$id,
        [bool]$undeleteDescendants,
        [bool]$isDeleted = $false,
        [string]$apiversion = "2.2"
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/queries#undelete-a-query-or-folder
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/queries/{id}?api-version={version}[&$undeleteDescendants=true]
    #
    # Example:
    # $query = Get-Query -instance $instance -project $project -folderPath "Shared Queries/All wis" -Verbose
    # Show-Query -instance $instance -project $project -id $query.id -undeleteDescendants $true -Verbose
  
    
    $uri = "$instance/$project/_apis/wit/queries/$($id)?api-version=$apiversion"

    if ($undeleteDescendants -ne $false) {
        $uri += "&`$undeleteDescendants=$undeleteDescendants"
    }

    Write-Verbose $uri

    $postData = @{ isDeleted = "$isDeleted" }

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   # return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'
   $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#endregion
