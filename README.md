# Dev Box

Microsoft Dev Box is an Azure service that gives developers access to ready-to-code, project-specific dev boxes that are preconfigured and centrally managed. Support hybrid dev teams of any size with high-performance, cloud-based workstations, and let developers focus on writing code by streamlining access to the tools they need.

This repository contains the infra-as-code components to quickly scaffold a new Microsoft Dev Box environment.

_Please note these artifacts are under development and subject to change._

---

### Getting Started

Azure Active Directory

- Create new application
- Setup federated credentials
- Create role assignment

GitHub Actions

- Add repository secrets
  - AZURE_TENANT_ID
  - AZURE_SUBSCRIPTION_ID
  - AZURE_CLIENT_ID

Azure Deployment

- Update config settings

Azure DevCenter

- Create role assignment for to project

---

### Deployment

The following resources will be provisioned.

- Virtual Network
- Network Security Group
- Managed Identity (User)
- Network Connection
- DevCenter
- DevCenter Definitions
- DevCenter Project
- DevCenter Pools

---

### Links

- [Microsoft Dev Box](https://docs.microsoft.com/azure/dev-box)
- [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep)
- [OpenID Connect](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)
