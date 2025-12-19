# TODO Infra Monolithic Setup

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Terraform infrastructure repository to deploy the **TODO App** on **Microsoft Azure** using GitHub Actions and Azure CI/CD.  
This project demonstrates a scalable, reusable, modular Terraform codebase with best practices for cloud infrastructure provisioning.

---

## 🧠 Project Overview

This repository contains Terraform configurations and automation to provision:

- Virtual Network, Subnets, Bastion
- Virtual Machines (Linux)
- Load Balancer and Backend Pools
- SQL Servers & Databases
- Security Groups and Firewall Rules
- CI/CD with GitHub Actions / Azure DevOps
- Module-based architecture for reusability

> All resources are managed using Infrastructure-as-Code (IaC) principles and follow Terraform best practices. :contentReference[oaicite:0]{index=0}

---

## 🗂️ Repository Structure

.
├── .github/ # GitHub CI/CD workflows
├── modules/ # Terraform reusable modules
│ ├── network/
│ ├── vm/
│ ├── loadbalancer/
│ ├── sql/
│ └── bastion/
├── scripts/ # Initialization / provisioning scripts
├── environments/ # Environment specific configs
│ ├── dev/
│ └── prod/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── backend.tf
├── README.md # This file
└── .gitignore


---

## 🚀 Getting Started

### 1. **Clone the Repository**

```bash
git clone https://github.com/pawangiri3/todo-Monolithic-infra-setup.git
cd todo-Monolithic-infra-setup

2. Configure Azure Credentials

Ensure you are authenticated with Azure CLI or Managed Identity:

az login
az account set --subscription "<subscription-id>"


Avoid hardcoding sensitive credentials. Use AAD auth, environment variables, or GitHub secrets.

3. Bootstrap Terraform
terraform init

4. Preview Infrastructure
terraform plan -var-file="terraform.tfvars"

5. Apply Configuration
terraform apply -var-file="terraform.tfvars"

⚙️ Configuration
Terraform Backend (Remote State)

Configure remote state in backend.tf using an Azure Storage Account. This avoids storing state locally.

Variables

All variables are defined in variables.tf. You can customize values by editing terraform.tfvars.

📦 Modules

Each component is modularized:

Module	Purpose
network	Virtual network + subnet setup
vm	Linux virtual machines provisioning
loadbalancer	Load balancer with backend pools
sql	Azure SQL Server & Databases
bastion	Bastion host provisioning

Modules have input/output documentation and are reusable across environments. 
HashiCorp Developer

📁 Scripts

Scripts in the scripts/ directory are used during VM provisioning or automation tasks. These are optional helpers and can be extended.

📈 CI/CD Integration

This repo includes GitHub Actions workflows to automatically plan and apply Terraform changes on push or pull request.

Ensure you set the following secrets:

Secret	Purpose
AZURE_CLIENT_ID	Azure Service Principal
AZURE_CLIENT_SECRET	Azure SP Secret
AZURE_TENANT_ID	Azure Tenant ID
AZURE_SUBSCRIPTION_ID	Subscription context
ARM_ACCESS_KEY	Storage Account access for state
📌 Outputs

After apply, the following Terraform outputs provide key information:

VM private & public IPs

Load balancer public IP

Database connection details

Resource identifiers

📚 Best Practices Included

This Terraform repository follows recommended standards:

✔ Modular structure
✔ Remote state backend
✔ Secure authentication
✔ Variable validation
✔ Meaningful outputs
✔ Reusable modules
✔ Clear naming conventions
✔ Production-ready defaults 
Spacelift

🤝 Contributing

We welcome contributions!
Please fork the repository, create a feature branch and submit a pull request.

📜 License

This project is licensed under the MIT License – see the LICENSE file for details.

🚀 About

A Terraform repository to automate the deployment of the TODO application infrastructure using Azure cloud services and CI/CD pipelines.



---

## 📌 Notes

✔ This README follows Terraform documentation recommendations: overview, usage, examples, and module explanations. :contentReference[oaicite:3]{index=3}  
✔ You can enhance it further with invocation examples or architectural diagrams.  
✔ Consider adding an `.terraform-docs.yml` and using **terraform-docs** to auto-generate inputs/outputs tables into the README. :contentReference[oaicite:4]{index=4}


