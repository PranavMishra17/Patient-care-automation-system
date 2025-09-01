<div align="center">
  <img src="head.png" alt="Healthcare Pipeline Automation" width="800"/>
  
 # 🏥 Automated Patient Care Coordination System [in dev]
  
  [![n8n](https://img.shields.io/badge/n8n-✓-green.svg)](https://n8n.io/)
  [![Docker](https://img.shields.io/badge/Docker-✓-blue.svg)](https://www.docker.com/)
  [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-green.svg)](https://www.postgresql.org/)
  [![Redis](https://img.shields.io/badge/Redis-7-red.svg)](https://redis.io/)
  [![Azure OpenAI](https://img.shields.io/badge/Azure%20OpenAI-✓-blue.svg)](https://azure.microsoft.com/en-us/services/openai/)
  [![HIPAA](https://img.shields.io/badge/HIPAA-Compliant-green.svg)](https://www.hhs.gov/hipaa/index.html)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
  
  **Intelligent healthcare automation with AI-powered triage, specialist assignment, and real-time care coordination**
  
  [Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Testing](#-testing) • [Security](#-security)
</div>

---

## 🎯 Overview

This system implements a **complete healthcare automation pipeline** that transforms patient care coordination through intelligent workflows. From initial symptom assessment to specialist assignment, medical report generation, and appointment scheduling - everything is automated while maintaining HIPAA compliance and clinical accuracy.

## ✨ Core Features

### 🤖 **AI-Powered Medical Intelligence**
- **Smart Triage**: Azure OpenAI GPT-4 analyzes symptoms and assigns urgency levels (1-10 scale)
- **Specialist Matching**: Intelligent routing based on medical conditions, availability, and expertise
- **Medical Report Generation**: Comprehensive clinical assessments with differential diagnoses
- **Risk Stratification**: Automatic identification of high-risk patients requiring immediate attention

### 💬 **Multi-Channel Communication**
- **Slack Integration**: Real-time specialist notifications with interactive accept/decline buttons
- **Email Automation**: SendGrid-powered professional medical reports and appointment confirmations  
- **Redis Alerts**: High-speed alert system for critical patient conditions
- **Calendly Integration**: Automated appointment scheduling with specialist availability

### 📊 **Data & Analytics**
- **PostgreSQL Database**: Structured storage for patient history, specialist profiles, and case tracking
- **Redis Caching**: Fast retrieval of active cases and real-time alert management
- **Case Management**: Comprehensive tracking from intake to resolution with reassignment capability
- **Medical History Integration**: Full patient context including medications, allergies, and procedures

## Potential Add-ons for future

### 🔐 **HIPAA-Compliant Security**
- **PHI Encryption**: AES-256 encryption for Protected Health Information with configurable keys
- **Selective Data Masking**: Automatic detection and encryption of sensitive patient identifiers
- **Audit Trail**: Complete logging of all data access, modifications, and workflow executions
- **Secure Communications**: End-to-end encryption for all patient data transmissions

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Patient       │───▶│   n8n Workflow  │───▶│  Azure OpenAI   │
│   Intake        │    │   Orchestration │    │   GPT-4 Analysis│
│   (Webhooks)    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │◀───│   PHI Detection │───▶│   Slack Bot     │
│   Patient DB    │    │   & Encryption  │    │   Notifications │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Redis Cache   │◀───│   Specialist    │───▶│   SendGrid      │
│   & Alerts      │    │   Assignment    │    │   Email Reports │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Calendly      │◀───│   Medical       │───▶│   PDF           │
│   Scheduling    │    │   Report Gen    │    │   Generation    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔄 Complete Workflow Process

1. **Patient Intake** → Webhook receives patient symptoms and medical history
2. **PHI Detection** → Automatic identification and encryption of sensitive data
3. **AI Analysis** → GPT-4 performs medical triage and generates differential diagnoses
4. **Specialist Assignment** → Intelligent routing to available specialists by specialty
5. **Slack Notification** → Real-time alerts to assigned specialists with case details
6. **Interactive Response** → Specialists accept/decline cases via Slack buttons
7. **Case Reassignment** → Automatic routing to next available specialist if declined
8. **Medical Report** → Comprehensive clinical assessment generation with patient history
9. **Email Delivery** → Professional medical reports sent to specialists
10. **Appointment Scheduling** → Calendly integration for patient appointment booking

---

## 📸 Workflow Documentation Gallery

### 🔔 Slack Bot Notifications
<div align="center">
  <img src="notifications/slack1.png" alt="Slack Bot Message - Primary Specialist Assignment" width="400"/>
  <img src="notifications/slack2.png" alt="Slack Bot Message - Secondary Specialist Assignment" width="400"/>
  
  **Initial Case Assignment to Specialist 1** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **Case Reassignment to Specialist 2**
</div>


### 🗓️ Mail Appointment Notifications

<div align="center">
  <img src="notifications/mail2.png" alt="Patient Appointment Notification" width="400"/>
  
  **1. Specialist Medical Report** - Comprehensive clinical assessment with AI analysis sent to accepting specialist
  
  **2. Patient Appointment Notification** - Case acceptance confirmation with Calendly scheduling link
</div>

---

## 🚀 Quick Start

### Prerequisites
- Docker Desktop (Windows/Mac/Linux)
- Azure OpenAI API access with GPT-4 deployment
- Slack workspace with admin permissions
- SendGrid API key for email automation

### 1. Clone & Setup
```bash
git clone https://github.com/yourusername/Patient-care-automation-system.git
cd Patient-care-automation-system
cp .env.example .env
```

### 2. Configure Environment Variables
```bash
# Azure OpenAI Configuration
AZURE_OPENAI_API_KEY=your_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4o-deployment-name

# PHI Encryption (32-character hex key)
PHI_ENCRYPTION_KEY=your_32_character_encryption_key

# SendGrid Email Service
SENDGRID_API_KEY=your_sendgrid_api_key

# Slack Integration
SLACK_BOT_TOKEN=xoxb-your-slack-bot-token
```

### 3. Start Services
```bash
docker compose up -d
```

### 4. Access & Configure
- **n8n Interface**: http://localhost:5678
- **Import workflows** from provided JSON files
- **Configure credentials** for each service
- **Activate workflows** to start processing

## 🧪 Testing System

### Automated Test Scripts
```bash
# Test patient intake workflow
./WEBHOOK1_PATIENT_INTAKE.bat

# Test specialist interaction (accept/decline)
./WEBHOOK2_SLACK_INTERACTION.bat

# Test Calendly appointment scheduling
./WEBHOOK3_SEND_CALENDLY_INVITE.bat
```

### Manual Testing via API
```bash
# Patient intake with chest pain symptoms
curl -X POST http://localhost:5678/webhook-test/patient-intake \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe", 
    "age": 55,
    "gender": "Male",
    "chiefComplaint": "Chest pain and shortness of breath",
    "symptoms": "Severe chest pain, difficulty breathing, fatigue",
    "medicalHistory": "Hypertension, diabetes type 2"
  }'
```

## 📁 Project Structure

```
Patient-care-automation-system/
├── 📄 README.md                           # System documentation
├── 🐳 docker-compose.yml                  # Docker services configuration
├── 🔐 .env                                # Environment variables (create locally)
├── 🗄️ synthetic-patient-database.sql     # Sample patient and specialist data
├── 🔄 healthcare-workflows/               # n8n workflow JSON files
├── 🧪 WEBHOOK1_PATIENT_INTAKE.bat        # Patient intake testing
├── 🧪 WEBHOOK2_SLACK_INTERACTION.bat     # Specialist interaction testing  
├── 🧪 WEBHOOK3_SEND_CALENDLY_INVITE.bat  # Appointment scheduling testing
├── 📋 SETUP.md                           # Detailed setup instructions
└── 📄 LICENSE                            # MIT License
```

## 🔐 Security & HIPAA Compliance

### Built-in Security Features
- **PHI Encryption**: Automatic AES-256 encryption for patient names, contact info, and identifiers
- **Data Minimization**: Only necessary medical information is processed and stored
- **Access Controls**: Role-based permissions and secure API authentication
- **Audit Logging**: Complete trail of all patient data access and modifications
- **Secure Storage**: Encrypted Redis cache and PostgreSQL database with access controls

### HIPAA Compliance Measures
- **Administrative Safeguards**: Proper access management and staff training protocols
- **Physical Safeguards**: Docker container isolation and secure hosting requirements
- **Technical Safeguards**: Encryption, audit logs, and secure transmission protocols
- **Risk Assessment**: Regular security evaluations and vulnerability assessments

### Privacy Protection
- **De-identification**: Automatic removal of direct patient identifiers where possible
- **Minimum Necessary**: Only essential PHI shared with authorized healthcare providers
- **Business Associate Agreements**: Proper contracts with third-party service providers
- **Patient Rights**: Support for access, amendment, and deletion requests

## 🚨 Advanced Features & Add-ons

### 📊 **Analytics & Reporting**
- **Performance Metrics**: Response times, throughput, and error rates
- **Clinical Insights**: Pattern recognition in patient symptoms and outcomes
- **Resource Utilization**: Specialist workload and availability tracking
- **Quality Metrics**: Patient satisfaction and care coordination efficiency

### 🔄 **Workflow Extensions**
- **Multi-language Support**: Patient intake in multiple languages with AI translation
- **Telemedicine Integration**: Video consultation scheduling and management
- **Lab Results Integration**: Automatic processing of diagnostic test results
- **Insurance Verification**: Automated benefits checking and prior authorization

### 🤖 **AI Enhancements**
- **Predictive Analytics**: Early warning systems for patient deterioration
- **Clinical Decision Support**: Evidence-based treatment recommendations
- **Drug Interaction Checking**: Automatic medication safety screening
- **Symptom Progression Tracking**: Longitudinal patient monitoring

### 📱 **Mobile Integration**
- **Patient Mobile App**: Direct symptom reporting and appointment management
- **Provider Mobile Dashboard**: Real-time case notifications and quick responses
- **WhatsApp/SMS Integration**: Multi-channel patient communication
- **Voice Recognition**: Hands-free data entry for healthcare providers

## 🎯 Deployment Options

### Development Environment
- **Local Docker**: Complete system on single machine for testing
- **Ngrok Tunneling**: External webhook testing with public URLs
- **Sample Data**: Synthetic patient and specialist database for development

### Production Environment  
- **Cloud Deployment**: AWS, Azure, or GCP with managed databases
- **High Availability**: Multi-region deployment with failover capabilities
- **Auto-scaling**: Dynamic resource allocation based on patient volume
- **Backup & Recovery**: Automated data backups with point-in-time recovery

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for:
- **Development Setup**: Local environment configuration
- **Code Standards**: Formatting, testing, and documentation requirements
- **Security Guidelines**: HIPAA compliance and security best practices
- **Pull Request Process**: Review and approval workflow

## 📞 Support & Documentation

- **Setup Guide**: [SETUP.md](SETUP.md) - Detailed installation instructions
- **API Documentation**: [API.md](API.md) - Complete webhook and API reference
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions
- **GitHub Issues**: Report bugs and request features
- **Discussion Forum**: Ask questions and share improvements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p><strong>🏥 Transforming Healthcare Through Intelligent Automation</strong></p>
  <p>Built with <a href="https://n8n.io">n8n</a> • <a href="https://azure.microsoft.com/en-us/services/openai">Azure OpenAI</a> • <a href="https://www.docker.com">Docker</a></p>
  <p><em>HIPAA-compliant • Enterprise-ready • Open Source</em></p>
</div>
