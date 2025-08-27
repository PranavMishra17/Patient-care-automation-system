# n8n Workflows

This directory contains the n8n workflow JSON files for the healthcare automation system.

## 📁 Workflow Files

| File | Description | Purpose |
|------|-------------|---------|
| `healthcare-patient-intake.json` | Main patient intake workflow | Processes webhooks, PHI detection, AI analysis |
| `specialist-assignment.json` | Specialist assignment workflow | Slack notifications, case assignments |
| `medical-report-generation.json` | Report generation workflow | LLM reports, email delivery |
| `calendly-appointment-scheduling.json` | Appointment scheduling | Calendly integration workflow |
| `slack-interaction-handler.json` | Slack button interactions | Accept/decline case handling |

## 🔄 How to Import

1. Open n8n interface: http://localhost:5678
2. Click "+" to create new workflow
3. Click "Import from File" or paste JSON
4. Configure credentials for each service
5. Activate the workflow

## 📤 How to Export

1. Open workflow in n8n
2. Click menu (3 dots) → "Download"
3. Save to this workflows/ directory
4. Commit to git repository

## 🔗 Dependencies

Make sure these credentials are configured in n8n:
- Healthcare PostgreSQL
- Healthcare Redis  
- Healthcare Slack Bot
- Healthcare SendGrid
- Azure OpenAI API

## ⚠️ Important Notes

- Always export workflows after making changes
- Keep credentials separate from workflow files
- Test imported workflows in development first
- Update this README when adding new workflows