# iac
IaC

## Prerequisites:

* Terraform --> https://www.terraform.io `v0.14.4`
* Packer --> https://www.packer.io `v1.6.6`
* Azure Service Principal (SPN)

## Objectives

- [x] Create the infrastructure for a classic highly available website architecture with front end web servers and a managed SQL database for the back end.
- [x] Demonstrate scaling up of the front end webservers using a gitops workflow.
- [x] Create a Packer script or similar tool to configure a windows webserver golden image build.
- [x] Show in your code a redeployment using new images using a gitops workflow.

## Explanations, Considerations

- [x] In your README.md detail the security aspects that must be considered in the architecture and pipelines.
```markdown
- All passwords must be stored in Azure Vault and access via data sources in Terraform (Pipeline)
- All VMs must be placed in the Public subnet and not the DMZ subnet (Architecture)
```
- [x] How would you validate your website service is up?
```markdown
Website services can be validate by accessing the public IP of the loadbalancer deployed. Validation can also be done by examining the Health State of the instances in the VMSS.
```  
- [x] Serve your own Hello World page
```markdown
Webserver accessible [here](http://20.49.235.95/)
```
- [x] In three to four months we may have an auditor reviewing your work. How would you take this into account?
```markdown
- No passwords are exposed in the infrastructure code or pipelines
- Access to the DB is limited to only Azure Services
- No RDP access configured for the VMs in the VMSS
```