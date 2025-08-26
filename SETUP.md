# Healthcare Pipeline Setup Guide

## 🚀 Quick Start

### 1. Environment Setup

First, copy the environment template and fill in your API keys:

```bash
cp environment-template.txt .env
```

**Edit the `.env` file and replace these placeholders with your actual values:**

- `DB_PASSWORD` - Choose a strong password for PostgreSQL
- `REDIS_PASSWORD` - Choose a strong password for Redis
- `AZURE_OPENAI_API_KEY` - Your Azure OpenAI API key
- `AZURE_OPENAI_ENDPOINT` - Your Azure OpenAI endpoint (e.g., https://your-resource.openai.azure.com/)
- `AZURE_OPENAI_DEPLOYMENT_NAME` - Your Azure OpenAI deployment name
- `SLACK_BOT_TOKEN` - Your Slack bot token (optional for basic testing)

**Note:** The encryption keys are already generated for you in the template.

### 2. Start the Services

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on port 5432
- Redis cache on port 6379
- n8n workflow engine on port 5678

### 3. Access n8n Web Interface

1. Open your browser and go to: http://localhost:5678
2. Create your admin account (first user becomes the owner)
3. Set up your workspace

### 4. Import the Starter Workflow

1. In n8n web interface, click on **"New"** → **"Import from File"**
2. Select the `starter-workflow.json` file from this project
3. The workflow will be imported with 5 nodes:
   - **Patient Intake Webhook** - Receives patient data
   - **PHI Detection & Encryption** - Secures sensitive data
   - **Azure OpenAI Medical Analysis** - AI-powered triage
   - **Specialist Assignment** - Assigns appropriate specialist
   - **Output Results** - Shows the results

### 5. Test the Basic Workflow

1. **Activate the workflow** by clicking the toggle switch in n8n
2. **Get the webhook URL** from the webhook node (it will show something like `http://localhost:5678/webhook/patient-intake`)
3. **Test with sample data** using curl or Postman:

```bash
curl -X POST http://localhost:5678/webhook/patient-intake \
  -H "Content-Type: application/json" \
  -d @sample-patient.json
```

Or use the provided sample patient data:

```json
{
  "firstName": "John",
  "lastName": "Doe",
  "age": 45,
  "gender": "Male",
  "phoneNumber": "555-0123",
  "email": "john.doe@example.com",
  "chiefComplaint": "Chest pain and shortness of breath",
  "symptoms": "Severe chest pain, difficulty breathing, fatigue for the past 2 hours",
  "medicalHistory": "Hypertension, diabetes type 2, family history of heart disease"
}
```

## 🔧 What to Add Next in n8n

### Step 1: Add Database Storage
1. Add a **PostgreSQL** node after the Specialist Assignment
2. Configure it to connect to the local database:
   - Host: `postgres`
   - Database: `n8n_healthcare`
   - User: `n8n`
   - Password: `{{$env.DB_PASSWORD}}`
3. Use this SQL to store patient records:
```sql
INSERT INTO patients (
    patient_id, case_id, encrypted_data, phi_fields, 
    assigned_specialist_id, urgency_level, specialty, status
) VALUES (
    '{{$json.patientId}}', '{{$json.caseId}}', '{{$json.originalData}}', 
    '{{$json.phiFields}}', '{{$json.assignedSpecialist.id}}', 
    '{{$json.aiAnalysis.urgency}}', '{{$json.aiAnalysis.specialist}}', 'assigned'
);
```

### Step 2: Add Slack Notifications
1. Add a **Slack** node after the database storage
2. Configure your Slack app and get the bot token
3. Create a channel like `#patient-alerts`
4. Set up the message to notify specialists

### Step 3: Add Redis Caching
1. Add a **Redis** node to cache patient data
2. Configure connection:
   - Host: `redis`
   - Password: `{{$env.REDIS_PASSWORD}}`
3. Store case data with TTL for quick lookups

### Step 4: Add Error Handling
1. Add **Error Trigger** nodes to handle failures
2. Add retry logic for external API calls
3. Set up error notifications

## 📊 Monitoring

### Check Service Status
```bash
# Check if all services are running
docker-compose ps

# View logs
docker-compose logs n8n
docker-compose logs postgres
docker-compose logs redis
```

### Database Access
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U n8n -d n8n_healthcare

# Check if tables were created
\dt

# View sample data
SELECT * FROM patients LIMIT 5;
```

### Redis Access
```bash
# Connect to Redis
docker-compose exec redis redis-cli -a your_redis_password_here

# Check stored data
KEYS *
```

## 🔒 Security Notes

- All PHI data is encrypted using AES-256
- Database connections use strong passwords
- n8n runs with encryption keys for workflow data
- Environment variables keep secrets out of code

## 🚨 Troubleshooting

### Common Issues:

1. **"Cannot connect to database"**
   - Check if PostgreSQL container is running: `docker-compose ps`
   - Verify password in `.env` file

2. **"Azure OpenAI API Error"**
   - Verify your API key and endpoint in `.env`
   - Check if your deployment name is correct

3. **"Webhook not responding"**
   - Make sure the workflow is activated
   - Check n8n logs: `docker-compose logs n8n`

4. **"Permission denied"**
   - On Windows, make sure Docker Desktop is running
   - Check file permissions for the project directory

### Getting Help:
- Check n8n execution logs in the web interface
- View Docker logs: `docker-compose logs [service-name]`
- Ensure all environment variables are set correctly

## ✅ Next Steps

Once the basic workflow is running:

1. **Add more sophisticated AI analysis** with additional Azure OpenAI calls
2. **Implement Slack bot interactions** for specialist responses
3. **Add appointment scheduling** with Calendly integration
4. **Set up email notifications** with SendGrid
5. **Add SMS alerts** with Twilio for critical cases
6. **Build dashboards** for monitoring and analytics

You now have a solid foundation for a HIPAA-compliant healthcare automation pipeline! 🏥✨
