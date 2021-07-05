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
APP_ID=$(jq -r '.app_id' <<< ${CLIENT_PAYLOAD[@]})

# Github App installation ID
INSTALLATION_ID=$(jq -r '.installation_id' <<< ${CLIENT_PAYLOAD[@]})

# Endpoint url for register check
CALLBACK_URL=$(jq -r '.callback_url' <<< ${CLIENT_PAYLOAD[@]})

# Sha of original commit
COMMIT_SHA=$(jq -r '.commit_sha' <<< ${CLIENT_PAYLOAD[@]})

# Tenant id that owns the original repo
TENANT_ID=$(jq -r '.tenant_id' <<< ${CLIENT_PAYLOAD[@]})

# Github owner of the original repo
OWNER=$(jq -r '.owner' <<< ${CLIENT_PAYLOAD[@]})

# Original repo name
ORIGINAL_REPO_NAME=$(jq -r '.original_repository' <<< ${CLIENT_PAYLOAD[@]})

# Used to verify the request against the workflow
CALLBACK_TOKEN=$(jq -r '.callback_token' <<< ${CLIENT_PAYLOAD[@]})

# CBrix ID for the entire workflow suite
WORKFLOW_SUITE_ID=$(jq -r '.workflow_suite_id' <<< ${CLIENT_PAYLOAD[@]})

echo "VENDOR: ${VENDOR}"
echo "APP_ID: ${APP_ID}"
echo "INSTALLATION_ID: ${INSTALLATION_ID}"
echo "WORKFLOW_NAME: ${WORKFLOW_NAME}"
echo "TENANT_ID: ${TENANT_ID}"
echo "WORKFLOW_ID: $WORKFLOW_ID"
echo "JOB_ID: ${JOB_ID}"
echo "CALLBACK_URL: ${CALLBACK_URL}"
echo "COMMIT_SHA: ${COMMIT_SHA}"
echo "OWNER: ${OWNER}"
echo "ORIGINAL_REPO_NAME: ${ORIGINAL_REPO_NAME}"


curl --request POST ${CALLBACK_URL}/${CALLBACK_ACTION} \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${CALLBACK_TOKEN}" \
    --data-raw "{
    \"tenant_id\": \"${TENANT_ID}\",
    \"vendor\": \"$VENDOR\",
    \"app_id\": \"${APP_ID}\",
    \"installation_id\": \"${INSTALLATION_ID}\",
    \"owner\": \"${OWNER}\",
    \"original_repository\": \"${ORIGINAL_REPO_NAME}\",
    \"commit_sha\": \"${COMMIT_SHA}\",
    \"workflow_suite_id\": \"${WORKFLOW_SUITE_ID}\",
    \"workflow_id\": \"${WORKFLOW_ID}\",
    \"workflow_name\": \"${WORKFLOW_NAME}\",
    \"job_name\": \"${JOB_ID}\",
    \"status\": \"${CALLBACK_ACTION}\",
    \"conclusion\": \"${JOB_STATUS}\"
    }"