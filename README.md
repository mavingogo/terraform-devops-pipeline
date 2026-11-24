# Terraform DevSecOps Security Pipeline

## Project Overview

This project demonstrates how to integrate Infrastructure as Code (IaC) security scanning and automated security checks into a CI/CD pipeline using Terraform, Checkov, Gitleaks, and GitHub Actions.

The objective is to identify infrastructure misconfigurations and exposed secrets before infrastructure changes are merged into the main branch.

**Important:** This is a static infrastructure security demonstration. No AWS infrastructure is deployed, and no AWS resources are created.

## Technologies Used

- Terraform – Infrastructure as Code.
- AWS – Cloud infrastructure configuration examples.
- Checkov – Infrastructure security scanning.
- Gitleaks – Secret detection.
- GitHub Actions – CI/CD automation.
- Python – Checkov installation and execution.

## Project Structure

```text
terraform-devsecops-pipeline/
├── .github/
│   └── workflows/
│       └── security-pipeline.yml
├── terraform/
│   ├── main.tf
│   ├── versions.tf
│   └── .terraform.lock.hcl
├── .gitignore
└── README.md
