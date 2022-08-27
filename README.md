# Dev Box

Microsoft Dev Box is an Azure service that gives developers access to ready-to-code, project-specific dev boxes that are preconfigured and centrally managed. Support hybrid dev teams of any size with high-performance, cloud-based workstations, and let developers focus on writing code by streamlining access to the tools they need.

This repository contains the infra-as-code components to quickly scaffold a new Microsoft Dev Box environment.

_Please note these artifacts are under development and subject to change._

---

### Getting Started

Azure Active Directory - Application

- Navigate to the 'App Registration' blade wihin the Azure portal
- Select 'New registration' and provide a Name for the application
- Select the newly created application and select 'Certificates & secrets'
- Select 'Federated Credentials' and 'Add credential'
- Provide the 'Organization (username)' and Repository for the credential
- Select 'Entity type' - Branch and provide 'main'

Azure Resource Manager - Role Assignment

- Navigate to the Subscription in the Azure portal
- Select 'Access control (IAM)' and 'Add' - 'Add role assignment'
- Select Role - Contributor and select 'Members'
- Provide the 'Name' of the application from the previous steps

GitHub Actions - Secrets

- Navigate to 'Settings' on the repository
- Select 'Secrets' and 'Actions' link
- Select 'New repository secret' and create a secret for the following:
  - AZURE_TENANT_ID
  - AZURE_SUBSCRIPTION_ID
  - AZURE_CLIENT_ID

Azure Deployment

- Update the `src/configs/main.json` file with environment specifics

Azure Resource Manager - Role Assignment - Post Deployment

- Navigate to the DevCenter Project resource in the Azure Portal
- Select 'Access control (IAM)' and 'Add' - 'Add role assignment'
- Select Role 'DevCenter Dev Box User' and select Members
- Provide the 'Name' of the User / Groups for assignment

---

### Deployed Resources

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
