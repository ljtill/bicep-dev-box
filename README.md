# Dev Box

Microsoft Dev Box is an Azure service that gives developers access to
ready-to-code, project-specific dev boxes that are preconfigured and centrally
managed. Support hybrid dev teams of any size with high-performance, cloud-based
workstations, and let developers focus on writing code by streamlining access to
the tools they need.

This repository contains the infra-as-code components to quickly scaffold a new
Microsoft Dev Box environment.

_Please note these artifacts are under development and subject to change._

---

### Getting Started

Before deploying the Dev Box resources, the configuration file `src/configs/main.json` needs to be updated.

#### Using locally with PowerShell

```powershell
./eng/deploy.ps1 -SubscriptionId "{GUID}"
./eng/delete.ps1 -SubscriptionId "{GUID}"
```

To override the default config file, use the `-ConfigFile {FilePath}` parameter.

#### Using locally with Bash

```bash
./eng/deploy.sh -s "{GUID}"
./eng/deploy.sh -s "{GUID}"
```

To override the default config file, use the `-c {FilePath}` parameter.

#### Using with GitHub Actions

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

### Connection

After the deployment is complete, to provide the ability to create and connect to desktops following steps are required

Azure Resource Manager

- Navigate to the DevCenter Project resource in the Azure Portal
- Select 'Access control (IAM)' and 'Add' - 'Add role assignment'
- Select Role 'DevCenter Dev Box User' and select Members
- Provide the 'Name' of the User / Groups to allow access to the Dev Box portal

Browser

- Navigate to the Dev Box Portal

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

- [Microsoft Dev Box](https://learn.microsoft.com/azure/dev-box/overview-what-is-microsoft-dev-box)
  - [Key Concepts](https://learn.microsoft.com/azure/dev-box/concept-dev-box-concepts)
  - [How-to Guides](https://learn.microsoft.com/azure/dev-box/how-to-project-admin)
  - [Connect](https://learn.microsoft.com/azure/dev-box/tutorial-connect-to-dev-box-with-remote-desktop-app)
  - [Portal](https://devbox.microsoft.com/)
- [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep)
- [OpenID Connect](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)
