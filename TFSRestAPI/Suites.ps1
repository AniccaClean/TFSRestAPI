#region Test Suites

### Test Suite implementation
### https://www.visualstudio.com/en-us/docs/integrate/api/test/suites


function Get-TestSuites {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [string]$apiversion = "1.0",
        [int]$skip,
        [int]$top,
        [bool]$asTreeView
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/suites#get-a-list-of-test-suites
    #
    # Example:
    # Get-TestSuites -instance $instance -project "$project" -plan $plan.id

    $uri = "$instance/$project/_apis/test/plans/$($plan)/suites?api-version=$apiversion"

    if ($skip -gt 0) {
        $uri += "&`$skip=$skip"
    }
    if ($top -gt 0) {
        $uri += "&`$top=$top"
    }
    if ($asTreeView -eq $true) {
        $uri += "&`$asTreeView=true"
    }

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-TestSuite {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [Parameter(Mandatory=$true)][int]$suite,
        [string]$apiversion = "1.0",
        [bool]$includeChildSuites
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/suites#get-a-test-suite
    #
    # Example:
    # Get-TestSuite -instance $instance -project "$project" -plan $plan.id -suite $suite.id

    $uri = "$instance/$project/_apis/test/plans/$($plan)/suites/$($suite)?api-version=$apiversion"

    if ($includeChildSuites -eq $true) {
        $uri += "&includeChildSuites=true"
    }

  #  return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function New-TestSuite {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [Parameter(Mandatory=$true)][int]$parent,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][string]$suiteType, # StaticTestSuite, DynamicTestSuite, RequirementTestSuite
        [Parameter(Mandatory=$true)][string]$name,
        [string]$queryString,
        [int[]]$requirementIds
    )

    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/suites#create-a-test-suite
    #
    # Example:
    # New-TestSuite -instance $instance -project "$project" -plan $plan.id -parent $parentSuite.id -suiteType "StaticTestSuite" -name "Functional Suite"
    
    $uri = "$instance/$project/_apis/test/plans/$($plan)/suites/$($parent)?api-version=$apiversion"
     
    $postData = @{ suiteType = "$($suiteType)";
                    name = "$($name)" }

    if ($queryString -ne "") {
        $postData.Add("queryString", $queryString)
    }
    if ($requirementIds -ne $null) {
        $postData.Add("requirementIds", $requirementIds);
    }

    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

   # return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Edit-TestSuite {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [Parameter(Mandatory=$true)][int]$suite,
        [string]$apiversion = "1.0",
        [string]$name,
        [int]$parent,
        [string]$queryString,
        [bool]$inheritDefaultConfigurations,
        [int[]]$defaultConfigurations # Will implement as needed
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/suites#update-a-test-suite
    #
    # Example:
    # Update-TestSuite -instance $instance -project "$project" -plan $plan.id -suite $suite.id -name "New Suite Name"

    $uri = "$instance/$project/_apis/test/plans/$($plan)/suites/$($suite)?api-version=$apiversion"

    $postData = @{}

    if ($name -ne "") {
        $postData.Add("name", $name)
    }
    if ($parent -ne 0) {
        $postData.Add("parent", $parent)
    }
    if ($queryString -ne "") {
        $postData.Add("queryString", $queryString)
    }
    if ($inheritDefaultConfigurations -eq $true) {
        $postData.Add("inheritDefaultConfigurations", "true")
    }
    if ($requirementIds -ne $null) {
        $postData.Add("requirementIds", $requirementIds);
    }

    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

  #  return Invoke-RestMethod -Method Patch -Uri "$uri" -Body $json -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Patch'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

#endregion