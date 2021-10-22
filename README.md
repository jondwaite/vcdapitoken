# vcdapitoken
Scripts to aid using API tokens with VCD 10.3.1+

These scripts accompany my blog posts [here](https://kiwicloud.ninja/?p=68945) and [here](https://kiwicloud.ninja/?p=68963) on using the new API Token feature in VMware Cloud Director (VCD) versions 10.3.1 and later. They will not function against earlier releases of VCD. See the VCD 10.3.1 release notes [here](https://docs.vmware.com/en/VMware-Cloud-Director/10.3/rn/VMware-Cloud-Director-1031-Release-Notes.html) for details.

## vcd-token.ps1
Example script in PowerShell which shows connecting to the VCD API using an API Token to generate a SessionId which can then be used to login (`Connect-CIServer`) to the PowerCLI cmdlets provided by VMware. This allows use of existing PowerCLI scripts with an API Token instead of stored credentials.

Usage: Adjust variables at the top fo the file as appropriate and commands at end. Will create a persistent PowerCLI session if the `Disconnect-CIServer` part is removed.

## vcd-token.sh
Example script in Bash which connects to the VCD API using an API Token and then sets the 'VCD_TOKEN' environment variable to the value of a valid VCD SessionId which can then be consumed in the Terraform VCD Provider rather than storing user credentials in Terraform variables.

>Note: Requires [jq](https://stedolan.github.io/jq/) utility to be installed and accessible to parse returned JSON.

>Note: Script should be saved and made executable (`chmod u+x vcd-token.sh`)

Usage: Adjust variables at the top of the file as appropriate and then dot source (. ./vcd-token.sh) to set environment variable with the session Id.
