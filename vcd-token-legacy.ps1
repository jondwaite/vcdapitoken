$org = "<VCD Organization Code>"
$vcdhost = "<VCD Hostname>"
$token = "<VCD API Token String>"

# Use the token to generate an access-token
try {
  $uri = "https://$($vcdhost)/oauth/tenant/$($org)/token?grant_type=refresh_token&refresh_token=$($token)"
  $access_token = (Invoke-RestMethod -Method Post -Uri $uri -Headers @{'Accept' = 'application/json'}).access_token
  Write-Host -ForegroundColor Green ("Created access_token from token successfully")
} catch {
  Write-Host -ForegroundColor Red ("Could not create access_token from token, response code: $($_.Exception.Response.StatusCode.value__)")
  Write-Host -ForegroundColor Red ("Status Description: $($_.Exception.Response.ReasonPhrase).")
}

# Use the access-token to get a SessionId from the x-vcloud-authorization header response:
$headers = @{"Accept" = "application/*+xml;version=36.1"; "Authorization" = "Bearer $($access_token)"}
try {
  $SessionId = [string](Invoke-WebRequest -Method Get -Uri "https://$($vcdhost)/api/session" -Headers $headers).headers.'x-vcloud-authorization'
  Write-Host -ForegroundColor Green ("Got SessionId from access_token successfully")
} catch {
  Write-Host -ForegroundColor Red ("Could not create SessionId from access_token, response code: $($_.Exception.Response.StatusCode.value__)")
  Write-Host -ForegroundColor Red ("Status Description: $($_.Exception.Response.ReasonPhrase).")
}

# Create a new PowerCLI connection using the returned SessionId:
Connect-CIServer -Server $vcdhost -SessionId $SessionId

# Example PowerCLI to return all VMs in Org:
Get-CIVM | Format-Table

# (Optional) Disconnect the CIServer session:
Disconnect-CIServer -Server $vcdhost -Confirm:$false
