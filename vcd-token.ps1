$org           = "<VCD Organization Code>" # The VCD Organization for the API token (use 'system' for provider login)
$vcdhost       = "<VCD Hostname>"          # The VCD Hostname (e.g. 'my.cloud.com')
$token         = "<VCD API Token String>"  # The API Token generated within VCD
$skipsslverify = $false                    # Whether to skip verifying VCD SSL certificate (NOT recommended for production use)

# Use the token to generate an access-token, use Org 'System' for Provider login
try {
  if ($org.ToLower() -eq "system") {
    $uri = "https://$($vcdhost)/oauth/provider/token"
  } else {
    $uri = "https://$($vcdhost)/oauth/tenant/$($org)/token" 
  }
  $body = "grant_type=refresh_token&refresh_token=$($token)"
  $headers = @{
    'Accept' = 'application/json'
    'ContentType' = 'application/x-www-form-urlencoded'
  }
  $access_token = (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body -SkipCertificateCheck:$skipsslverify).access_token
  Write-Host -ForegroundColor Green ("Created access_token from token successfully")
} catch {
  Write-Host -ForegroundColor Red ("Could not create access_token from token, response code: $($_.Exception.Response.StatusCode.value__)")
  Write-Host -ForegroundColor Red ("Status Description: $($_.Exception.Response.ReasonPhrase).")
  break
}

try {
  Connect-CIServer -Server $vcdhost -SessionId "Bearer $access_token"
  Write-Host -ForegroundColor Green ("Connected to VCD successfully")
} catch {
  Write-Host -ForegroundColor Red ("Could not connect to VCD, response code: $($_.Exception.Response.StatusCode.value__)")
  Write-Host -ForegroundColor Red ("Status Description: $($_.Exception.Response.ReasonPhrase).")
  break
}

# Example PowerCLI to return all VMs in Org:
Get-CIVM | Format-Table

# (Optional) Disconnect the CIServer session:
Disconnect-CIServer -Server $vcdhost -Confirm:$false
