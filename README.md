# Dev Box

Microsoft Dev Box is an Azure service that gives developers access to ready-to-code, project-specific dev boxes that are preconfigured and centrally managed. Support hybrid dev teams of any size with high-performance, cloud-based workstations, and let developers focus on writing code by streamlining access to the tools they need.

This repository contains the infra-as-code components to quickly scaffold a new Microsoft Dev Box environment.

_Please note these artifacts are under development and subject to change._

---

### Getting Started

1. Configure Azure Active Directory
    1. Create a new application
    2. Setup the federated credentials
2. Configure GitHub Actions
    1. Add the following repository secrets
        - ARM_TENANT_ID
        - ARM_SUBSCRIPTION_ID
        - ARM_CLIENT_ID
3. Configure Azure Deployment
    1. Update `src/azureconfig.json` file with required values

### Resources

The following resources will be provisioned as part of the deployment.

- Virtual Network
- Network Security Group
- Managed Identity (User)
- Network Connection
- DevCenter
- DevCenter Definitions
- DevCenter Project
- DevCenter Pools

### Links

- [Microsoft Dev Box](https://docs.microsoft.com/azure/dev-box)
- [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep)
- [OpenID Connect](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)