#! /bin/bash

# Callback action, can be: [register, completed]
echo "CALLBACK_ACTION: ${CALLBACK_ACTION}"
echo "JOB_STATUS: ${JOB_STATUS}"

# Vendor
VENDOR="github"

# Name of the workflow
WORKFLOW_NAME=$(jq -r '.workflow' <<< $1)

# ID of centralized workflow run
WORKFLOW_ID=$(jq -r '.run_id' <<< $1)

# ID of centralized job run (i.e: linter, unit-test)
JOB_ID=$(jq -r '.job' <<< $1)

# Client payload
CLIENT_PAYLOAD=$(jq -r '.event.client_payload' <<< $1)

# Github App ID
APP_AND_INSTALLATION_ID=$(jq -r '.app_and_installation_id' <<< ${CLIENT_PAYLOAD[@]})

# Github App asset ID
ASSET_ID=$(jq -r '.asset_id' <<< ${CLIENT_PAYLOAD[@]})

# Endpoint url for register check
WORFLOW_CALLBACK_URL=$(jq -r '.callback_url.workflow' <<< ${CLIENT_PAYLOAD[@]})
FINDINGS_CALLBACK_URL=$(jq -r '.callback_url.findings' <<< ${CLIENT_PAYLOAD[@]})

# Sha of original commit
COMMIT_SHA=$(jq -r '.commit_sha' <<< ${CLIENT_PAYLOAD[@]})

# Tenant id that owns the original repo
TENANT_ID=$(jq -r '.tenant_id' <<< ${CLIENT_PAYLOAD[@]})

# Github full repo path (owner/repo_name)
FULL_REPO_PATH=$(jq -r '.full_repo_path' <<< ${CLIENT_PAYLOAD[@]})

# Original branch name
BRANCH_NAME=$(jq -r '.branch' <<< ${CLIENT_PAYLOAD[@]})

# Used to verify the request against the workflow
CALLBACK_TOKEN=$(jq -r '.callback_token' <<< ${CLIENT_PAYLOAD[@]})

# CBrix ID for the entire workflow suite
WORKFLOW_SUITE_ID=$(jq -r '.workflow_suite_id' <<< ${CLIENT_PAYLOAD[@]})

echo "VENDOR: ${VENDOR}"
echo "APP_AND_INSTALLATION_ID: ${APP_AND_INSTALLATION_ID}"
echo "ASSET_ID: ${ASSET_ID}"
echo "WORKFLOW_NAME: ${WORKFLOW_NAME}"
echo "TENANT_ID: ${TENANT_ID}"
echo "WORKFLOW_ID: ${WORKFLOW_ID}"
echo "JOB_ID: ${JOB_ID}"
echo "WORFLOW_CALLBACK_URL: ${WORFLOW_CALLBACK_URL}"
echo "FINDINGS_CALLBACK_URL: ${FINDINGS_CALLBACK_URL}"
echo "COMMIT_SHA: ${COMMIT_SHA}"
echo "FULL_REPO_PATH: ${FULL_REPO_PATH}"
echo "BRANCH_NAME: ${BRANCH_NAME}"


curl --request POST ${WORFLOW_CALLBACK_URL}/${CALLBACK_ACTION} \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${CALLBACK_TOKEN}" \
    --data-raw "{
    \"tenant_id\": \"${TENANT_ID}\",
    \"vendor\": \"$VENDOR\",
    \"app_and_installation_id\": \"${APP_AND_INSTALLATION_ID}\",
    \"asset_id\": \"${ASSET_ID}\",
    \"full_repo_path\": \"${FULL_REPO_PATH}\",
    \"branch\": \"${BRANCH_NAME}\",
    \"commit_sha\": \"${COMMIT_SHA}\",
    \"workflow_suite_id\": \"${WORKFLOW_SUITE_ID}\",
    \"workflow_id\": \"${WORKFLOW_ID}\",
    \"workflow_name\": \"${WORKFLOW_NAME}\",
    \"job_name\": \"${JOB_ID}\",
    \"status\": \"${CALLBACK_ACTION}\",
    \"conclusion\": \"${JOB_STATUS}\"
    }"

if [ "$CALLBACK_ACTION" == "completed" ]
then
  echo "***************"
  echo $FINDINGS_CALLBACK_URL
  echo "***************"
fi
