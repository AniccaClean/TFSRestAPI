#region Test Plans

### Test Plans
### https://www.visualstudio.com/en-us/docs/integrate/api/test/plans

function Get-TestPlans {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [string]$apiversion = "1.0",
        [string]$owner,
        [bool]$includePlanDetails,
        [bool]$filterActivePlans,
        [int]$skip,
        [int]$top
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#get-a-list-of-test-plans
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/test/plans?api-version={version}[&owner={string}&includePlanDetails={bool}&filterActivePlans={bool}&$skip={int}&$top={int}]
    #
    # Example:
    # Get-TestPlans -instance $instance -project $project

    $uri = "$instance/$project/_apis/test/plans?api-version=$apiversion"

    if ($owner -ne "") {
        $uri += "&owner=$owner"
    }
    if ($includePlanDetails -eq $true) {
        $uri += "&includePlanDetails=true"
    }
    if ($filterActivePlans -eq $true) {
        $uri += "&filterActivePlans=true"
    }
    if ($skip -gt 0) {
        $uri += "&`$skip=$skip"
    }
    if ($top -gt 0) {
        $uri += "&`$top=$top"
    }

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

   $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Get-TestPlan {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [string]$apiversion = "1.0"

    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#get-a-test-plan
    #
    # GET https://{instance}/DefaultCollection/{project}/_apis/test/plans/{plan}?api-version={version}
    #
    # Example:
    # Get-TestPlan -instance $instance -project $project -plan $plan.id

    $uri = "$instance/$project/_apis/test/plans/$($plan)?api-version=$apiversion"

   # return Invoke-RestMethod -Method Get -Uri "$uri" -UseDefaultCredentials -ContentType 'application/json'

    $params = @{ Method = 'Get'; Uri = "$uri"; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function New-TestPlan {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [string]$apiversion = "1.0",
        [Parameter(Mandatory=$true)][string]$name,
        [string]$description,
        [string]$area,
        [string]$iteration,
        [datetime]$startDate,
        [datetime]$endDate
    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#create-a-testplan
    #
    # Example:
    # New-TestPlan -instance $instance -project "$project" -name "$testPlanName"

    $uri = "$instance/$project/_apis/test/plans?api-version=$apiversion"

    $postData = @{ name = $name }

    if ($description -ne "") {
        $postData.Add("description", $description)
    }
    if ($area -ne "") {
        $postData.Add("description", $area)
    }
    if ($iteration -ne "") {
        $postData.Add("iteration", $iteration)
    }
    if ($startDate -ne $null) {
        $postData.Add("startDate", $startDate)
    }
    if ($endDate -ne $null) {
        $postData.Add("endDate", $endDate)
    }
    
    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

   # return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

    $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}

function Edit-TestPlan {
    Param (
        [Parameter(Mandatory=$true)][string]$instance,
        [Parameter(Mandatory=$true)][string]$project,
        [Parameter(Mandatory=$true)][int]$plan,
        [string]$apiversion = "1.0",
        [string]$name,
        [string]$description,
        [string]$area,
        [string]$iteration,
        [int]$build,
        [string]$state

    )
    # Documentation
    # https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#update-a-testplan
    #
    # Example:
    # Edit-TestPlan -instance $instance -project "$project" -name "$testPlanName"

    $uri = "$instance/$project/_apis/test/plans?api-version=$apiversion"

    $postData = @{ }

    if ($name -ne "") {
        $postData.Add("name", $name)
    }
    if ($description -ne "") {
        $postData.Add("description", $description)
    }
    if ($area -ne "") {
        $postData.Add("area", $area)
    }
    if ($iteration -ne "") {
        $postData.Add("iteration", $iteration)
    }
    if ($startDate -ne $null) {
        $postData.Add("startDate", $startDate)
    }
    if ($endDate -ne $null) {
        $postData.Add("endDate", $endDate)
    }
    if ($state -ne "") {
        $postData.Add("state", $state)
    }
   
    Write-Verbose ($postData | Out-String)

    $json = $postData | ConvertTo-Json

    
   # return Invoke-RestMethod -Method Post -Uri "$uri" -Body $json -UseDefaultCredentials  -ContentType 'application/json'

   # Even though this is documented as "PATCH", you need to run it as a POST. Documentation error?
   $params = @{ Method = 'Post'; Uri = "$uri"; Body = $json; ContentType = 'application/json' }
   
    return invoke_rest $params
}


#endregion