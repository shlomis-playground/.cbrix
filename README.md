# Playground for .CBRIX Centralised workflow
## Intro
This repo contains the centralised workflow to be activated on all repositories by the _workflow-service_.

This workflow is triggered by the _push_ flow on the _workflow-service_ and expects the following context under `github.event.inputs`:
```javascript
{
    "app_id":             // Github App ID
    "installation_id":    // Github App installation ID
    "commit_sha":         // The original commit sha
    "tenant_id":          // tenant_id of the original repo
    "workflow_suite_id":  // CBrix ID for the entire workflow suite
    "owner":              // Github owner of the original repo
    "original_repository":               // original_repo_name
    "github_token":       // Tenant's oauth token to checkout the repo
    "callback_url":       // The register check endpoint
    "callback_token":     // Used to verify the request against the workflow id 
}
```

When the workflow is triggered, each job do the following:
-  Calls the _register_ endpoint of the _workflow-service_ 
-  Run the action
-  Calls the _completed_ endpoint of the _workflow-service_ 


The register call is authenticated, the token is passed as part of the context as `callback_token` and should be populated in the `Authorization` header.

The checks on this workflow are performed on the original repo using a _Checkout_ step in a job.

## What can be improved?
1. The checkout is performed multiple times and can be cached for better performance. [There is a story for that](https://app.clubhouse.io/cbrix/story/397/workflow-service-cbrix-workflow-performance-improve).
