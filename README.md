# Dev Box

## Introduction

This repository contains the modules and tools to quickly scaffold a new Dev Box environment.

### Getting Started

1. Configure Azure Active Directory
  1. Create a new application & service principal
  2. Add federated credentials to the application
2. Configure GitHub Actions
  1. Create the following secrets for the workflows
    - ARM_TENANT_ID
    - ARM_SUBSCRIPTION_ID
    - ARM_CLIENT_ID
3. Configure Azure Deployment
  1. Update the `src/azureconfig.json` with required values

### Resources

The following resources will be created as part of the deployment.

- Virtual Network
- Network Security Group
- Managed Identity (User)
- Network Connection
- DevCenter
- DevCenter Definitions
- DevCenter Project
- DevCenter Pools

## Useful Links

[Microsoft Dev Box](https://docs.microsoft.com/azure/dev-box)
[Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep)
[OpenID Connect](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)