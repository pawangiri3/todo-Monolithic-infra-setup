
# TODO Monolithic Infrastructure Setup (Azure + Terraform)

This repository contains **production-grade Terraform infrastructure code** to deploy and manage the complete backend infrastructure for a **TODO Monolithic Application** on **Microsoft Azure**.

The codebase is written with **real enterprise standards** in mind and reflects how infrastructure is designed, secured, and operated in **production environments**.

---

## 🚀 What This Repository Does

This project provisions the following Azure resources using Terraform:

- Virtual Networks & Subnets
- Azure Bastion Host (optional, secure VM access)
- Linux Virtual Machines
- Azure Load Balancer (Standard SKU)
- Network Security Groups
- Azure SQL Server & Databases
- Public & Private IP management
- Modular, reusable Terraform code
- Remote Terraform state using Azure Storage

---

## 🧠 Design Philosophy

- Infrastructure as Code (IaC)
- Modular and reusable Terraform modules
- Security-first approach
- No hardcoded secrets or credentials
- Azure AD / Managed Identity ready
- Production-safe defaults
- Easy to extend for multi-environment setups

---

## 📁 Repository Structure

```

.
├── backend.tf
├── providers.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── network/        # VNet, Subnet, Bastion
│   ├── linux_vm/       # Linux VM provisioning
│   ├── loadbalancer/   # Azure Load Balancer
│   └── sql/            # Azure SQL Server & DB
├── scripts/            # VM bootstrap scripts
└── README.md

````

---

## 🔐 Authentication & Security

This repository **does not store secrets in code**.

Supported authentication methods:
- Azure CLI (`az login`)
- Azure DevOps Service Connection
- GitHub Actions (OIDC)
- Azure Managed Identity

Terraform remote state is stored in **Azure Blob Storage** using **Azure AD authentication**.

---

## ⚙️ Prerequisites

- Terraform `>= 1.6`
- Azure CLI
- Azure Subscription
- Proper Azure RBAC permissions

---

## 🧪 Usage

### 1️⃣ Login to Azure
```bash
az login
az account set --subscription <subscription-id>
````

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Review the Plan

```bash
terraform plan
```

### 4️⃣ Apply Infrastructure

```bash
terraform apply
```

---

## 📦 Terraform Modules

### `network`

* Virtual Network
* Subnets
* Azure Bastion Host

### `linux_vm`

* Linux Virtual Machines
* NICs & NSGs
* Optional Public IP
* User-data support

### `loadbalancer`

* Azure Standard Load Balancer
* Backend address pools
* Health probes
* Load balancing rules

### `sql`

* Azure SQL Server
* Azure SQL Databases
* Azure AD authentication
* Private access ready

---

## 📤 Outputs

After deployment, Terraform outputs include:

* VM private & public IPs
* Load Balancer public IP
* VNet and Subnet IDs
* Resource IDs for downstream usage

---

## 🏗️ Environment Strategy

* Designed for separate environments (dev / test / prod)
* Remote state isolation supported
* CI/CD pipeline ready

---

## ✅ Best Practices Followed

✔ Modular Terraform design
✔ Remote backend with state locking
✔ Secure authentication (AAD / Managed Identity)
✔ No secrets in code or outputs
✔ Clean variable structure
✔ AzureRM provider v4 compatible
✔ Production-oriented defaults

---

## 🤝 Contribution

Contributions are welcome.

Standard workflow:

* Fork the repository
* Create a feature branch
* Submit a Pull Request

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 👤 Author

**Pawan Kumar**
Senior DevOps / Cloud Engineer
Terraform • Azure • CI/CD • Kubernetes

---

