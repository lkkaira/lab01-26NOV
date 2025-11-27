
name: Deploy Azure Infrastructure (Multi-Stage)

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  # ------------------- STAGE 1: App Service Plan -------------------
  deploy-asp:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install Terraform
        run: |
          sudo apt-get update
          sudo apt-get install -y wget unzip
          wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
          unzip terraform_1.5.7_linux_amd64.zip
          sudo mv terraform /usr/local/bin/
          terraform -version

      - name: Login to Azure
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      # First job: init fresh workspace, plan/apply ONLY ASP
      - name: Terraform Init, Plan & Apply (ASP)
        run: |
          terraform init -input=false
          terraform plan -out=tfplan -input=false -target=module.app_service_plan
          terraform apply -auto-approve tfplan

      - name: Upload Terraform State
        uses: actions/upload-artifact@v4
        with:
          name: tfstate
          path: |
            terraform.tfstate
            .terraform.lock.hcl
          overwrite: true   # <-- Allow re-upload with same name in later jobs

  # ------------------- STAGE 2: Web App -------------------
  deploy-webapp:
    runs-on: ubuntu-latest
    needs: deploy-asp
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install Terraform
        run: |
          sudo apt-get update
          sudo apt-get install -y wget unzip
          wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
          unzip terraform_1.5.7_linux_amd64.zip
          sudo mv terraform /usr/local/bin/
          terraform -version

      - name: Login to Azure
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Download Terraform State
        uses: actions/download-artifact@v4
        with:
          name: tfstate
          path: .

      - name: Terraform Init, Plan & Apply (Web App)
        run: |
          terraform init -input=false
          terraform plan -out=tfplan -input=false -target=module.web_app
          terraform apply -auto-approve tfplan

      - name: Upload Terraform State
        uses: actions/upload-artifact@v4
        with:
          name: tfstate
          path: |
            terraform.tfstate
            .terraform.lock.hcl
          overwrite: true

  # ------------------- STAGE 3: Storage Account -------------------
  deploy-storage:
    runs-on: ubuntu-latest
    needs: deploy-webapp
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install Terraform
        run: |
          sudo apt-get update
          sudo apt-get install -y wget unzip
          wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
          unzip terraform_1.5.7_linux_amd64.zip
          sudo mv terraform /usr/local/bin/
          terraform -version

      - name: Login to Azure
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Download Terraform State
        uses: actions/download-artifact@v4
        with:
          name: tfstate
          path: .

      - name: Terraform Init, Plan & Apply (Storage)
        run: |
          terraform init -input=false
          terraform plan -out=tfplan -input=false -target=module.storage_account
          terraform apply -auto-approve tfplan

      - name: Upload Terraform State
        uses: actions/upload-artifact@v4
        with:
          name: tfstate
          path: |
            terraform.tfstate
            .terraform.lock.hcl
          overwrite: true
