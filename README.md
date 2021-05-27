# .CBRIX Centralised workflow
## Intro
This repo contains the centralised workflow to be activated on all repositories by the _workflow-service_.

The workflows are triggered by repository_dispatch event by the _push_ flow on the _workflow-service_ and expects the following context under `github.event.client_payload`:
```javascript
{
    "sha":          // the original commit sha
    "tenant_id":    // tenant_id of the original repo
    "owner":        // github owner of the original repo
    "original_repo_name": 
    "original_repo_full_name":  // "owner/original_repo_name"
    "token":        // tenant's oauth token to checkout the repo
    "callback_url": // the register check endpoint 
},

```

When the workflow is triggered, it calls the _register_ endpoint of the _workflow-service_ to relate the checks in the centrilise workflow with those on the original repository.

The checks on this workflow are performed on the original repo using a _Checkout_ step in a job.

## What can be improved?
1. The checkout is performed multiple times and can be cached for better performance. [There is a story for that](https://app.clubhouse.io/cbrix/story/397/workflow-service-cbrix-workflow-performance-improve).
