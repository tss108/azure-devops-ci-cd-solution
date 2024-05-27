## Azure DevOps CI/CD Solution

This repository contains the Azure DevOps CI/CD solution for deploying an Azure infrastructure using Terraform and an ASP.NET Core application, following the Microsoft tutorial.

## Requirements

1. **Azure DevOps Repositories**: The solution utilizes Azure DevOps repositories for version control.
2. **Branching Strategy**: The repository follows either the GitFlow or Trunk-based branching strategy.
3. **Terraform Backend**: The Terraform solution uses the `azurerm` backend.
4. **Environments**: The solution includes four environments: DEV, QA, UAT, and PROD. Each environment has the same infrastructure configuration.
5. **Resource Groups**: Each infrastructure stage deployment is performed in your Azure subscription, with resource groups named `rg-{RESOURCE_NAME_PREFIX}-{LOCATION}-{ENV}`.
6. **Pipeline Format**: The pipelines are defined in YAML format.
7. **ADO Environments**: ADO Environments are configured, and deployment jobs are used for pipelines requiring approvals.
8. **Terraform Apply Approval**: Each Terraform apply stage requires approval, and the approver can review the Plan before approving.
9. **Variable Groups**: Only variable groups are used to configure variables, with one group per environment. Sensitive data is encrypted.


## Best Practices

1. **Branch Policies**: ADO branch policies are configured for all repositories.
2. **Repository Structure**: The repository has a clear folder structure.
3. **Default Branch**: The last code version is merged into the default branch (develop for GitFlow, main for Trunk-based).
4. **Pull Requests**: Pull requests are used to merge code into long-living branches.
5. **Test Failures**: Tests fail the pipeline in case of unsuccessful results.
6. **Scripts as Files**: Scripts are used as files whenever possible.
7. **Approval Requirements**: Any pipeline deployment task requires approval.
8. **Pipeline Artifacts**: Pipeline artifacts contain only the required files.
9. **Naming Conventions**: Pipeline steps, jobs, stages, variables, files, and folders follow clear and descriptive naming conventions.
10. **ADO Predefined Variables**: Azure DevOps predefined variables are used in the pipeline.
11. **No Hardcoding**: Hardcoding is not allowed.


## Project Structure
- **ADO-APP:** Contains the .NET application and ADO-App-CI-CD.yml pipeline.
- **ADO-INFRA:** Contains the Azure infrastructure using Terraform (IaC) and ADO-IaC-CI-CD.yml pipeline.



## Infrastructure CI/CD Pipeline

1. **Repository Setup**: Create a new repository with a clear folder structure for the Terraform solution, and copy the provided Terraform solution. Configure Git policies as specified in the requirements.
2. **Terraform State Storage**: Manually create a resource group, storage account, and container to store Terraform state files. Store the names in ADO variable groups.
3. **Service Connection**: Create a service connection to your Azure subscription.
4. **CI/CD Pipeline**: Create a new CI/CD pipeline named `ADO-IaC-CI-CD` with the following stages:
  - **Build**: Validate commit messages, update build numbers, check Terraform formatting, validate Terraform solution, create artifacts, and upload artifacts.
  - **Terraform Plan and Apply**: Download artifacts, install Terraform, run Terraform plan, and run Terraform apply for each environment (DEV, QA, UAT, PROD) with approval requirements and specific trigger conditions.
5. **Pipeline Triggers**: Configure pipeline triggers based on branch patterns (feature/*, bugfix/*, hotfix/*, develop, master, release/*).
6. **Terraform Variables**: Pass required values to Terraform as variables.
7. **Testing**: Test your solution by deploying to the DEV environment first, then copy and rename stages for other environments.



## Application CI/CD Pipeline

1. **Tools**: Visual Studio Code and .NET Core SDK v6.0.
2. **Code Repository**: Clone the provided GitHub repository with a .NET Core application, reset to a specific commit, rename the `master` branch to `main`, and create a new Azure DevOps repository for the application code.
3. **CI/CD Pipeline**: Create a new CI/CD pipeline named `ADO-App-CI-CD` with the following stages:
  - **Build**: Validate commit messages, update build numbers, build the application, prepare SQL migration scripts, and publish artifacts (application code and SQL migration script separately).
  - **Deploy App**: Update the database schema and deploy the application to the Azure App Service Staging slot.
  - **Swap Slots**: Swap the Azure App Service slots.
4. **Environment Variables**: Add the `ASPNETCORE_ENVIRONMENT=Production` variable to the pipeline and import it into the app settings in the Azure Web App.
5. **Pipeline Triggers**: Configure pipeline triggers based on branch patterns (feature/*, bugfix/*, hotfix/*, develop, master, release/*).
6. **Testing**: Test your solution by deploying the application to the previously created infrastructure.

