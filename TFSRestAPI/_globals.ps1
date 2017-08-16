function invoke_rest {
    Param (
        [Parameter(Mandatory=$true)][Hashtable]$params
    )

    # TODO: Forcing default credentials to be used. It might be nice in the future to figure out which credential set to use for different environments.
    $params.Add("UseDefaultCredentials", $true)
    
    # TODO: Code block will need to change. Borrowed from https://github.com/majkinetor/TFS/blob/master/TFS/_globals.ps1
    try {
        return Invoke-RestMethod @params
    } catch {
        $err = $_
        try { $err = $_ | ConvertFrom-Json } catch { throw $err }
        $err = ($err | fl * | Out-String) -join '`n'
        Write-Error $err
    }
    return $null
}
