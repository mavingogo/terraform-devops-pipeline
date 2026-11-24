# Terraform DevSecOps Security Pipeline

## Project Overview

This project demonstrates Infrastructure as Code (IaC) security
scanning and CI/CD automation using Terraform, Checkov, Gitleaks,
GitHub Actions, and Git.

The objective is to detect infrastructure misconfigurations,
prevent accidental exposure of secrets, and automatically validate
Terraform configurations before changes are accepted.

## Technologies Used

- Terraform: Infrastructure as Code
- Checkov: Static security analysis
- Gitleaks: Secret detection
- Git: Version control
- GitHub: Source code hosting
- GitHub Actions: CI/CD automation

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
