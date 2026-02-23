# 🚀 Self-Hosted GitHub Actions Runner on AWS

A production-ready setup to deploy and manage a **Self-Hosted GitHub Actions Runner** on AWS infrastructure.

This project demonstrates how to provision AWS resources and configure a self-hosted runner to execute GitHub Actions workflows securely and efficiently.

---

## 📌 Project Overview

GitHub provides hosted runners by default, but in many production scenarios you may need:

- ✅ Custom compute configurations (CPU/RAM)
- ✅ Access to private VPC resources
- ✅ Integration with internal services (EKS, RDS, etc.)
- ✅ Full control over the runner environment
- ✅ Cost optimization for long-running workloads

This repository helps you achieve exactly that using AWS.

---

## 🏗️ Architecture
Developer Push → GitHub Repository → Self-Hosted Runner (EC2 on AWS) → Executes Workflow


The runner is deployed on an AWS EC2 instance and registered to your GitHub repository.

---

## 📂 Repository Structure
.
├── .github/workflows/ # GitHub Actions workflow examples
├── demo/github-runner/ # Runner configuration files
│ └── configuration/
│ └── terragrunt.hcl # Infrastructure configuration
├── .gitignore
└── README.md


---

## ⚙️ Prerequisites

Before deploying, ensure you have:

- AWS Account
- IAM permissions to create EC2 instances
- GitHub repository
- Git installed
- (Optional) Terraform / Terragrunt installed

---

## 🚀 Setup Guide

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/imMonu27/Self-Hosted-GitHub-Actions-Runner-on-AWS.git
cd Self-Hosted-GitHub-Actions-Runner-on-AWS

2️⃣ Launch EC2 Instance (Manual Setup)

Launch an EC2 instance (Ubuntu recommended)

Allow outbound HTTPS traffic

Open port 22 for SSH

3️⃣ Register Self-Hosted Runner

Go to:
    GitHub Repository → Settings → Actions → Runners → New Self-hosted Runner

Choose:

OS: Linux

Architecture: x64

GitHub will generate commands similar to:

mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz
tar xzf actions-runner-linux-x64.tar.gz

Configure using:
    ./config.sh --url https://github.com/<OWNER>/<REPO> --token <TOKEN>

Start runner:
    ./run.sh

Example Workflow
    .github/workflows/self-hosted.yml