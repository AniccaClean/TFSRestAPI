

#region Classification Nodes

### Classification nodes
### https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes

function Get-ClassificationNodes {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)]
		  [ValidateSet("areas", "iterations")][string]$nodeType, # areas or iterations
        [string]$nodePath, # Node path starts its path with the area under the default "$project" value. e.g. CDW\CMRE node path is CMRE
        [string]$apiversion = "1.0",
        [int]$depth
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#get-a-list-of-classification-nodes
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/[{nodePath}]?api-version={version}[&$depth={int}]
    #
    # Example
    # Get-ClassificationNodes -instance $instance -project $project -nodeType "areas" -nodePath "CMRE" -Verbose

    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)?api-version=$apiversion"

    if ($nodePath -ne "") {
        $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($nodePath)?api-version=$apiversion"
    }

    if ($depth -ne "") {
        $uri += "&`$depth=$($depth)"
    }

    Write-Verbose $uri
    
  #  return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-ClassificationNode {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$nodeType, # areas or iterations
        [Parameter(Mandatory=$true)][string]$nodePath, # Node path starts its path with the area under the default "$project" value. e.g. CDW\CMRE node path is CMRE
        [string]$apiversion = "1.0",
        [int]$depth
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#get-a-classification-node
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/{nodePath}?api-version={version}[&$depth={int}]
    #
    # Example
    # Get-ClassificationNode -instance $instance -project $project -nodeType "areas" -nodePath "CMRE" -Verbose
    #
    # Get-ClassificationNode -instance $instance -project $project -nodeType "iterations" -nodePath "2017\Iteration 6" -Verbose


    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($nodePath)?api-version=$apiversion"

    if ($depth -ne "") {
        $uri += "&`$depth=$($depth)"
    }

    Write-Verbose $uri

    #return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function New-ClassificationNode {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$nodeType, # areas or iterations
        [string]$nodePath,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][string]$name,
        [hashtable]$attributes
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#create-a-classification-node
    #
    # POST https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/{nodePath}?api-version={version}[&$depth={int}]
    # I think there is a bug here because $depth parameter is not called out in the online documentation
    #
    # Examples
    # New-ClassificationNode -instance $instance -project $project -nodeType "areas" -nodePath "Test Name" -name "Test Name2" -Verbose
    #
    # $attributes = @{ startDate = "2014-10-27T00:00:00Z"; finishDate = "2014-10-31T00:00:00Z" }
    # New-ClassificationNode -instance $instance -project $project -nodeType "iterations" -nodePath "Test Iteration" -name "Test Iteration Sub4" -attributes $attributes -Verbose

    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)?api-version=$apiversion"

    if ($nodePath -ne "") {
        $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($nodePath)?api-version=$apiversion"
    }

    $postData = @{ name = $name; }

    if ($attributes -ne $null) {
        $postData.Add("attributes", $attributes)
    }

    Write-Verbose $uri

    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   # return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'
    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Update-ClassificationNode {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$nodeType, # areas or iterations
        [string]$nodePath,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][string]$name,
        [hashtable]$attributes
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#update-a-classification-node
    #
    # PATCH https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/{nodePath}?api-version={version}
    #
    # Examples
    # Update-ClassificationNode -instance $instance -project $project -nodeType "areas" -nodePath "Test Name2" -name "New Name" -Verbose
    # 
    # $attributes = @{ startDate = "2014-10-27T00:00:00Z"; finishDate = "2016-10-31T00:00:00Z" }
    # Update-ClassificationNode -instance $instance -project $project -nodeType "iterations" -nodePath "Test Iteration" -name "Moded Iteration" -attributes $attributes -Verbose
    #
    # -nodePath's end of the path is the value that will change
    # -name is the new name

    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)?api-version=$apiversion"

    if ($nodePath -ne "") {
        $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($nodePath)?api-version=$apiversion"
    }

    $postData = @{ name = $name; }

    if ($attributes -ne $null) {
        $postData.Add("attributes", $attributes)
    }

    Write-Verbose $uri

    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   #return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Move-ClassificationNode {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$nodeType, # areas or iterations
        [Parameter(Mandatory=$true)][string]$targetNodePath,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][int]$id
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#move-a-classification-node
    #
    # POST https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/{targetNodeName}?api-version={version}
    #
    # Example:
    # Move a "Iteration 6" under 2017 to a child of iteration path "2016"
    # $iterationNode = Get-ClassificationNode -instance $instance -project $project -nodeType "iterations" -nodePath "2017\Iteration 6" -Verbose
    # Move-ClassificationNode -instance $instance -project $project -nodeType "iterations" -targetNodePath "2016" -id $iterationNode.id -Verbose

    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($targetNodePath)?api-version=$apiversion"

    $postData = @{ id = $id; }

    Write-Verbose $uri

    $json = $postData | ConvertTo-Json

    Write-Verbose $json

   #return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Remove-ClassificationNode {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][string]$nodeType, # areas or iterations
        [Parameter(Mandatory=$true)][string]$nodePath,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][int]$reclassifyId
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/wit/classification-nodes#delete-a-classification-node
    #
    # DELETE https://{instance}/DefaultCollection/{project}/_apis/wit/classificationnodes/{nodeType}/{nodePath}?api-version={version}[?$reclassifyId={reclassifyId}]
    #
    # Example: 
    # Remove the area path "New Name\Test Name2" and move all items under that area path to the "Data Warehouse" area path.
    # $areaNodeTarget = Get-ClassificationNode -instance $instance -project $project -nodeType "areas" -nodePath "Data Warehouse" -Verbose
    # Remove-ClassificationNode -instance $instance -project $project -nodeType "areas" -nodePath "New Name\Test Name2" -reclassifyId $areaNodeTarget.id -Verbose

    $uri = "$instance/$($project)/_apis/wit/classificationnodes/$($nodeType)/$($nodePath)?api-version=$apiversion"

    if ($reclassifyId -ne 0) {
        $uri += "&`$reclassifyId=$reclassifyId"
    }

    Write-Verbose $uri

   # return Invoke-RestMethod -Method Delete -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Delete'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#endregion