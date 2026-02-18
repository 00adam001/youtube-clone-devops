# 🎬 YouTube Clone — Full DevOps Pipeline

[![CI Pipeline](https://github.com/00adam001/youtube-clone-devops/actions/workflows/ci.yml/badge.svg)](https://github.com/00adam001/youtube-clone-devops/actions/workflows/ci.yml)
[![CD Pipeline](https://github.com/00adam001/youtube-clone-devops/actions/workflows/cd.yml/badge.svg)](https://github.com/00adam001/youtube-clone-devops/actions/workflows/cd.yml)
[![Infrastructure](https://github.com/00adam001/youtube-clone-devops/actions/workflows/infrastructure.yml/badge.svg)](https://github.com/00adam001/youtube-clone-devops/actions/workflows/infrastructure.yml)

A modern YouTube clone built with **React 18** and **Material UI 5**, deployed on **Azure** with a complete **DevOps CI/CD pipeline** using **GitHub Actions** and **Terraform**.

> **Live Demo:** [https://youtube-clone-prod.azurewebsites.net](https://youtube-clone-prod.azurewebsites.net)

---

## 🏗️ Architecture

```
Developer → GitHub (PR)
               │
    ┌──────────▼──────────┐
    │   GitHub Actions CI  │
    │  ┌────────────────┐  │
    │  │ ESLint + Prettier│ │
    │  │ Jest Unit Tests  │ │
    │  │ npm audit        │ │
    │  │ Docker Build     │ │
    │  │ Trivy CVE Scan   │ │
    │  │ Push to ACR      │ │
    │  └────────────────┘  │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │   GitHub Actions CD  │
    │  ┌────────────────┐  │
    │  │ Terraform Plan  │ │
    │  │ Terraform Apply │ │
    │  │ Deploy to Azure │ │
    │  │ Health Check     │ │
    │  └────────────────┘  │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │    Azure Cloud       │
    │  ┌────────────────┐  │
    │  │ Container Reg.  │ │
    │  │ App Service     │ │
    │  │ App Insights    │ │
    │  │ Log Analytics   │ │
    │  └────────────────┘  │
    └─────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | React 18, Material UI 5, React Router 6, Axios |
| **API** | YouTube v3 (RapidAPI) |
| **Containerization** | Docker (multi-stage: Node 18 → Nginx) |
| **CI/CD** | GitHub Actions (3 workflows) |
| **Infrastructure** | Terraform (Azure provider) |
| **Cloud** | Azure App Service, ACR, Application Insights |
| **Code Quality** | ESLint, Prettier, Jest |
| **Security** | Trivy container scanning, npm audit |
| **Monitoring** | Azure Application Insights, Log Analytics |

---

## 📁 Project Structure

```
youtube-clone-devops/
├── .github/
│   └── workflows/
│       ├── ci.yml              # CI: lint, test, build, scan, push
│       ├── cd.yml              # CD: deploy staging/production
│       └── infrastructure.yml  # IaC: Terraform plan & apply
├── terraform/
│   ├── main.tf                 # Provider & backend config
│   ├── variables.tf            # Variable definitions
│   ├── resources.tf            # Azure resources
│   └── outputs.tf              # Output values
├── src/
│   ├── components/             # React components
│   ├── utils/                  # API helpers & constants
│   ├── App.js                  # Root app component
│   └── index.js                # Entry point
├── public/                     # Static assets
├── Dockerfile                  # Multi-stage Docker build
├── nginx.conf                  # Production Nginx configuration
├── .eslintrc.json              # ESLint configuration
├── .prettierrc                 # Prettier configuration
├── .env.example                # Environment variable template
└── package.json                # Dependencies & scripts
```

---

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Docker (optional, for containerized development)
- Azure CLI (for deployment)
- Terraform 1.5+ (for infrastructure)

### Local Development

```bash
# Clone the repository
git clone https://github.com/00adam001/youtube-clone-devops.git
cd youtube-clone-devops

# Create environment file
cp .env.example .env
# Edit .env and add your RapidAPI key

# Install dependencies
npm install

# Start development server
npm start
```

### Docker

```bash
# Build the image
docker build --build-arg REACT_APP_RAPID_API_KEY=your_key -t youtube-clone .

# Run the container
docker run -p 80:80 youtube-clone
```

---

## 🔄 CI/CD Pipeline

### Branch Strategy
| Branch | Environment | Trigger |
|--------|------------|---------|
| `feature/*` | — | PR checks (lint, test) |
| `develop` | Staging | Auto-deploy on merge |
| `main` | Production | Auto-deploy on merge |

### Pipeline Stages

**CI Pipeline** (on every push/PR):
1. **Lint** — ESLint + Prettier format check
2. **Test** — Jest unit tests with coverage
3. **Security** — `npm audit` vulnerability scan
4. **Build** — Docker multi-stage build
5. **Scan** — Trivy container vulnerability scan
6. **Push** — Push image to Azure Container Registry

**CD Pipeline** (on CI success):
1. **Deploy** — Update Azure App Service with new image
2. **Health Check** — Verify deployment is healthy

**Infrastructure Pipeline** (on terraform/ changes):
1. **Plan** — `terraform plan` with format & validation
2. **Apply** — `terraform apply` (main branch only)

---

## ☁️ Azure Infrastructure

All infrastructure is managed with Terraform:

| Resource | Purpose |
|----------|---------|
| Resource Group | Logical container for all resources |
| Container Registry (ACR) | Store Docker images |
| App Service Plan (B1) | Compute for web apps |
| Web App (Production) | Production deployment |
| Web App (Staging) | Staging deployment |
| Application Insights | Monitoring & telemetry |
| Log Analytics Workspace | Centralized logging |

---

## 🔐 Required Secrets

Configure these in **GitHub → Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `REACT_APP_RAPID_API_KEY` | RapidAPI YouTube v3 API key |
| `ACR_USERNAME` | Azure Container Registry admin username |
| `ACR_PASSWORD` | Azure Container Registry admin password |
| `AZURE_CREDENTIALS` | Azure Service Principal JSON |
| `ARM_CLIENT_ID` | Terraform: Azure SP client ID |
| `ARM_CLIENT_SECRET` | Terraform: Azure SP client secret |
| `ARM_SUBSCRIPTION_ID` | Terraform: Azure subscription ID |
| `ARM_TENANT_ID` | Terraform: Azure tenant ID |

---

## 📊 Monitoring

- **Application Insights** — Performance metrics, request tracing, failure analysis
- **Health Endpoint** — `/health` returns `{"status":"healthy"}`
- **Log Analytics** — Centralized log aggregation with 30-day retention

---

## 📜 License

This project is for educational and portfolio purposes.

---

## 🙏 Acknowledgments

- Original YouTube Clone by [Piyush Sachdeva](https://github.com/piyushsachdeva)
- YouTube v3 API via [RapidAPI](https://rapidapi.com)
