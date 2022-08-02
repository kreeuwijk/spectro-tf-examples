#!/bin/bash

eval "$(jq -r '. | to_entries | .[] | .key + "=" + (.value | @sh)')"

# results in:
# $CLUSTER_NAME, $SC_HOST, $SC_API_KEY, $SC_PROJECT

# Get project UID
PROJ_UID=$(curl -s -H "ApiKey:$SC_API_KEY" https://$SC_HOST/v1/projects | jq -r --arg SC_PROJECT "$SC_PROJECT" '.items[].metadata | select(.name==$SC_PROJECT) | .uid')
CLUSTER_STATE=$(curl -s -H "ApiKey:$SC_API_KEY" -H "projectUid:$PROJ_UID" https://$SC_HOST/v1/spectroclusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select((.status.state!="Deleted") and (.metadata.name==$CLUSTER_NAME)) | .status.state')

if [ "$CLUSTER_STATE" = "Running" ]; then
  jq -n '{state:"1"}'
else
  jq -n '{state:"0"}'
fi