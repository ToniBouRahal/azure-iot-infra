# 🚀 Azure IoT Infrastructure (Bicep + CI/CD)

![image](https://github.com/user-attachments/assets/0b6322e3-a819-4405-9f1c-bb04828cf5e6)



This repo defines the complete Azure infrastructure for an IoT solution using **Bicep templates** and **GitHub Actions**.

This repo defines the complete Azure infrastructure for an IoT solution using **Bicep templates** and **GitHub Actions**.

---

## ✅ What’s Deployed

- Azure IoT Hub
- Event Hub (for alerts)
- Stream Analytics (telemetry processing)
- Azure SQL (telemetry storage)
- Logic App (SMS alerting via Twilio)
- Azure Function (triggers Logic App)
- Web App (React + Node backend)
- Key Vault (secure secret storage)

---

## 🧰 Prerequisites

- Azure Subscription
- `az` CLI installed and logged in
- GitHub repository secrets set in **Settings > Secrets and Variables > Actions**:

| Secret Name             | Description                      |
|-------------------------|----------------------------------|
| `AZURE_CLIENT_ID`       | Azure AD App or federated identity |
| `AZURE_TENANT_ID`       | Azure tenant ID                  |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID            |

---

## 🛠️ Deployment Instructions

### 1. Clone and review parameters

```bash
git clone https://github.com/your-org/infra.git
cd infra
```

Modify `bicep/parameters/dev.parameters.json` as needed.

### 2. Push or merge to `main`

On every PR merge to `main`, the GitHub Actions pipeline will:

- Deploy Bicep infrastructure
- Auto-create or update Key Vault secrets
- Deploy Logic App workflow (from `logicapp/logicapp-workflow.json`)
- Deploy Azure Function code (from `function/alert-handler/`)

---

## 🔐 Secrets Managed in Key Vault

This repo provisions and maintains the following secrets in Azure Key Vault:

- `iotHubConnectionString`
- `eventHubConnectionString`
- `sqlAdminPassword`
- `twilioAccountSid`
- `twilioAuthToken`
- `twilioFromNumber`
- `twilioToNumber`

These are consumed by App Services, Azure Function, and Logic App via **Key Vault references**.

---

## 🧰 Helper Scripts

To manually patch secrets or extract connection strings from Azure resources, the `scripts/` directory provides:

```bash
scripts/
├── store-iothub-conn.sh     # Stores IoT Hub connection string to Key Vault
├── store-eventhub-conn.sh   # Stores Event Hub connection string to Key Vault
```

Usage:
```bash
./scripts/store-iothub-conn.sh rg-iot-dev iothub-dev-001 kv-dev-iot
./scripts/store-eventhub-conn.sh rg-iot-dev eh-dev-iot kv-dev-iot
```

These are automatically executed in the GitHub Actions pipeline.

---

## ➕ Optional: Device Provisioning Service (DPS)

You can optionally enable **automatic provisioning of simulated devices** using Azure DPS. A future module can be added:

```bash
modules/
└── dps.bicep                # Deploys DPS instance and enrollment group
```

This allows devices to auto-register using symmetric keys or certificates.

---

## 🧪 Manual Testing

### Create a new resource group:
```bash
az group create --name rg-iot-dev --location eastus
```

### Deploy Infra:
```bash
az deployment group create \
  --resource-group rg-iot-dev \
  --template-file main.bicep \
  --parameters parameters/dev.parameters.json
```

### Set Function App Settings:
```bash
az functionapp config appsettings set \
  --name func-dev-alerts \
  --resource-group rg-iot-dev \
  --settings LOGICAPP_ENDPOINT="https://<your-logicapp>.azurewebsites.net/api/..."
```

### Deploy Function Code:
```bash
cd function/alert-handler
zip -r ../../function.zip .
cd -
az functionapp deployment source config-zip \
  --name func-dev-alerts \
  --resource-group rg-iot-dev \
  --src function.zip
```

---

## 📦 Folder Structure

```
infra/
├── modules/                # Modular Bicep files
├── function/alert-handler/ # Azure Function code
├── parameters/             # Bicep parameters
├── scripts/                # Helper scripts
└── .github/workflows/      # CI/CD pipeline

```

---

## 📌 Notes

- App Services and Logic Apps use **Key Vault references** for secrets
- The Azure Function is triggered by Event Hub and calls the Logic App via HTTP POST
- Logic App sends Twilio SMS alerts on triggered events
---

## 🔗 Related Repositories

- [`web-app`](https://github.com/your-org/web-app): React + Node.js frontend
- [`simulated-devices`](https://github.com/your-org/simulated-devices): Python + Docker IoT simulators

