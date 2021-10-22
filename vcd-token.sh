#!/bin/bash

org="<VCD Organization Code>"
vcdhost="<VCD Hostname>"
token="<VCD API Token String>"

uri="https://$vcdhost/oauth/tenant/$org/token?grant_type=refresh_token&refresh_token=$token"
accesstok=`curl -s -k -X POST $uri -H "Accept: application/json" | jq -r '.access_token'`
headers=`curl -s -H "Accept: application/*+xml;version=36.1" -H "Authorization: Bearer $accesstok" -k -I -X GET https://$vcdhost/api/session`
export VCD_TOKEN=`echo "$headers" | grep X-VMWARE-VCLOUD-ACCESS-TOKEN: | cut -f2- -d: | awk '{$1=$1};1'`
