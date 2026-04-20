# Terraform Infra Provision
### [ DRAFT ]

### Summary
Terraform Stack deployments using an environment agnostic pattern.

**NOTES:** 
- After first invocation, runTF will create some useful aliases [ tbe, tfp, tfa ]
- The runTF script itself is meant to be used the same way locally or within a pipeline runner
- **AZURE** - Script requires azcli and expects the following ENV vars to already exist:
```
export ARM_TENANT_ID=XXXX-XXXXX-XXXXXX-XXXX-XXXXX
export ARM_SUBSCRIPTION_ID=XXXX-XXXXX-XXXXXX-XXXX-XXXXX
export ARM_CLIENT_ID=XXXX-XXXXX-XXXXXX-XXXX-XXXXX
export ARM_CLIENT_SECRET=XXXX-XXXXX-XXXXXX-XXXX-XXXXX
export AZ_TENANT_ID="${ARM_TENANT_ID}"
export AZ_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
export AZURE_DEFAULT_LOCATION="eastus"
```


### Usage
1. Init the backend for the appropriate environment context with:

 ```
 ./runTF init [dev | qa| prod]

  or
   
  tbe dev 

  or

 terraform init -backend-config=backend/backend.dev.tfvars -backend-config=cfg_APPSTACK_StateKey.tfvars 
  ```

2. Perform PLAN:

```
tfp [dev|qa|prod] 

or 

terraform plan -var-file=config/cfg.dev.tfvars -var-file=backend/backend.dev.tfvars -var-file=cfg_APPSTACK_StateKey.tfvars -out=TFPlan.tmp
```

3. Perform Apply:
```
tfa

or 

terraform apply TFPlan.tmp
```
