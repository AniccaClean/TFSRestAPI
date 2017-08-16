#region Build (2.0)

#############################################################
# .SYNOPSIS
# Get a list of build definitions
# .DESCRIPTION
# Get a list of build definitions
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Team project ID or name
# .PARAMETER definitions
# A comma-delimited list of definition IDs.
# .PARAMETER resultFilter
# The build result. enum { succeeded, partiallySucceeded, failed, canceled }
# .PARAMETER statusFilter
# The build status. enum { inProgress, completed, cancelling, postponed, notStarted, all }
# .PARAMETER top
# Maximum number of builds to return.
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
# 
# 
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-list-of-builds
#############################################################
function Get-Builds {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [string]$definitions,
        [string]$resultFilter,
        [string]$statusFilter,
        [int]$top,
        [string]$apiversion = "2.0"
    )

    # GET https://{instance}/DefaultCollection/{project}/_apis/build/builds?api-version={version}[&definitions={string}][&queues={string}][&buildNumber={string}][&type={string}][&minFinishTime={DateTime}][&maxFinishTime={DateTime}][&requestedFor={string}][&reasonFilter={string}][&statusFilter={string}][&tagFilters={string}][&propertyFilters={string}][&$top={int}][&continuationToken={string}]
    $uri = "$instance/$($project)/_apis/build/builds?api-version=$apiversion"

    if ($definitions -ne "") {
        $uri += "&definitions=$definitions"
    }
    if ($resultFilter -ne "") {
        $uri += "&resultFilter=$resultFilter"
    }
    if ($statusFilter -ne "") {
        $uri += "&statusFilter=$statusFilter"
    }
    if ($top -ne 0) {
        $uri += "&`$top=$top"
    }
   
    Write-Verbose $uri
   
   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json' 

   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Get a list of build definitions
# .DESCRIPTION
# Get a list of build definitions
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Team project ID or name
# .PARAMETER name
# Filters to definitions whose names equal this value. Append a * to filter to definitions whose names start with this value. For example: MS*.
# .PARAMETER type
# The type of the build definitions to retrieve. If not specified, all types will be returned. enum {build, xaml }
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
# Get-BuildDefinitions -instance $instance -project "My_Project" -type "build" -name "My_Def"
# 
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#get-a-list-of-build-definitions
#############################################################
function Get-BuildDefinitions {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [string]$name,
        [string]$type,
        [string]$apiversion = "2.0"
    )

    # GET https://{instance}/DefaultCollection/{project}/_apis/build/definitions?api-version={version}[&name={string}][&type={string}]
    $uri = "$instance/$($project)/_apis/build/definitions?api-version=$apiversion"

    if ($name -ne "") {
        $uri += "&name=$name"
    }
    if ($type -eq "build" -or $type -eq "xaml") {
        $uri += "&type=$type"
    }

    Write-Verbose $uri
   
    #return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json' 

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#############################################################
# .SYNOPSIS
# Get a list of build definitions
# .DESCRIPTION
# Get a list of build definitions
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Team project ID or name
# .PARAMETER definitionID
# ID of the build definition.
# .PARAMETER revision
# The specific revision number of the definition to retrieve.
# .PARAMETER propertyFilters
# a-delimited list of extended properties to retrieve.
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
# Get-BuildDefinitions -instance $instance -project "My_Project" -definitionId 132
# 
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#get-a-build-definition
#############################################################
function Get-BuildDefinition {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$definitionId,
        [int]$revision,
        #[string]$propertyFilters, # This doesn't appear in the Rest API documentation so will not try it
        [string]$apiversion = "2.0"
    )

    # GET https://{instance}/DefaultCollection/{project}/_apis/build/definitions/{definitionId}?api-version={version}[&revision={int}]
    $uri = "$instance/$($project)/_apis/build/definitions/$($definitionId)?api-version=$apiversion"

    if ($revision -ne 0) {
        $uri += "&revision=$revision"
    }

    Write-Verbose $uri
   
   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json' 

   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#############################################################
# .SYNOPSIS
# Update a build definition
# .DESCRIPTION
# Update a build definition
# 
# .PARAMETER instance
# VS Team Services account ({instance}.visualstudio.com) or TFS server ({server:port}).
# .PARAMETER project
# Team project ID or name
# .PARAMETER definitionId
# ID of the build definition.
# .PARAMETER revision
# The current revision number of the definition. If this doesn't match the current version, the update will fail.
# .PARAMETER body
# The build definition information to update. It is helpful to get this by calling Get-BuildDefinition and modifying an existing definition.
# .PARAMETER apiversion
# Version of the API to use.
#
# .EXAMPLE
# 
# 
# .LINK 
# https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#update-a-build-definition
#############################################################
function Update-BuildDefinition {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$definitionId,
        [Parameter(Mandatory=$true)][int]$revision,
        [Parameter(Mandatory=$true)][object]$body,
        [string]$apiversion = "2.0"
    )

    # PUT https://{instance}/DefaultCollection/{project}/_apis/build/definitions/{definitionId}?api-version={version}
    $uri = "$instance/$($project)/_apis/build/definitions/$($definitionId)?api-version=$apiversion"
   
    Write-Verbose $uri

    # These build definitions can get big. ConvertTo-Json only goes to a depth of 2 by default. Set it to 10 to make sure we get everything updated appropriately.
    $json = $body | ConvertTo-Json -Depth 10

    Write-Verbose $json
   
   # return Invoke-RestMethod -Method Put -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json' 

   $params = @{ Method = 'Put'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#endregion