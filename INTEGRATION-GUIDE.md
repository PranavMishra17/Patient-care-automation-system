# 🏥 Healthcare Pipeline - Complete Integration Guide

## 🚨 **CRITICAL: Azure Credentials Fix First**

### **Step 1: Fix Azure OpenAI Environment Variables**

Your Azure credentials are showing as `[undefined]` because the `.env` file isn't being loaded properly. Let's fix this:

1. **Stop n8n container:**
   ```bash
   docker compose stop n8n
   ```

2. **Check your `.env` file exists and has correct values:**
   ```bash
   # Make sure these values are in your .env file (not [undefined])
   AZURE_OPENAI_API_KEY=your_actual_key_here
   AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
   AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name
   AZURE_OPENAI_API_VERSION=2024-02-15-preview
   ```

3. **Restart n8n with environment refresh:**
   ```bash
   docker compose up -d n8n
   ```

4. **Verify environment variables are loaded:**
   ```bash
   docker compose exec n8n env | grep AZURE
   ```

## 🔧 **Step 2: Import All Workflows**

### **Main Healthcare Workflow (Primary)**
1. **Go to n8n**: http://localhost:5678
2. **Click "Import from File"**
3. **Upload**: `healthcare-complete-workflow.json`
4. **Save as**: "Healthcare Complete Pipeline"

### **PDF Generation Enhancement**
1. **In the same workflow**, add these nodes after "Generate Medical Report":
   - **"Format Report for PDF"** (Function node)
   - **"Convert HTML to PDF"** (HTTP Request node)  
   - **"Email PDF Report to Specialist"** (Email node)

2. **Copy the code** from `pdf-generation-nodes.json` into each node

### **Redis Alert System (Separate Workflow)**
1. **Create new workflow**: Click "+" to add workflow
2. **Import**: `redis-slack-alert-workflow.json`
3. **Save as**: "Redis Slack Alert Monitor"

## 📋 **Step 3: Set Up All Credentials**

### **Required Credentials in n8n:**

#### **1. PostgreSQL Credential**
- **Name**: `Healthcare PostgreSQL`
- **Host**: `postgres`
- **Database**: `n8n_healthcare`
- **User**: `n8n`
- **Password**: [your DB_PASSWORD from .env]

#### **2. Redis Credential**
- **Name**: `Healthcare Redis`
- **Host**: `redis`
- **Password**: [your REDIS_PASSWORD from .env]

#### **3. Slack Credential**
- **Name**: `Healthcare Slack Bot`
- **OAuth Token**: [your SLACK_BOT_TOKEN from .env]

#### **4. SendGrid Credential**
- **Name**: `Healthcare SendGrid`
- **API Key**: [your SENDGRID_API_KEY from .env]

#### **5. Twilio Credential**
- **Name**: `Healthcare Twilio`
- **Account SID**: [your TWILIO_ACCOUNT_SID from .env]
- **Auth Token**: [your TWILIO_AUTH_TOKEN from .env]

## 🔗 **Step 4: Connect All Services**

### **Main Workflow Connections:**
1. **Patient Intake** → **PHI Encryption** → **Azure OpenAI Analysis**
2. **AI Analysis** → **Specialist Assignment** → **Redis Cache**
3. **Redis Cache** → **Slack Alert** → **Interactive Buttons**
4. **Button Response** → **Medical History** → **PDF Report** → **Email/SMS**

### **Redis Alert Workflow Connections:**
1. **Slack Webhook** → **Message Parser** → **Alert Checker**
2. **Alert Checker** → **Patient Database** → **Email Notifications**
3. **Scheduled Cleanup** → **Redis Maintenance**

## 🧪 **Step 5: Test Complete System**

### **Test Patient Data:**
```bash
curl -X POST http://localhost:5678/webhook/patient-intake \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "age": 55,
    "gender": "Male",
    "phoneNumber": "+15551234567",
    "email": "john.doe@email.com",
    "chiefComplaint": "Chest pain and shortness of breath",
    "symptoms": "Severe chest pain, difficulty breathing, fatigue",
    "medicalHistory": "Hypertension, diabetes type 2"
  }'
```

### **Expected Flow:**
1. ✅ **Patient data received** → PHI encrypted
2. ✅ **Azure OpenAI analyzes** → Determines specialist needed
3. ✅ **Specialist assigned** → From pool of 10 specialists
4. ✅ **Slack alert sent** → With Accept/Decline buttons
5. ✅ **If accepted** → Medical history retrieved, PDF report generated
6. ✅ **Email sent** → PDF report to specialist, confirmation to patient
7. ✅ **SMS sent** → Patient notification

## 🚨 **Troubleshooting Common Issues**

### **Issue 1: Azure OpenAI Still Shows [undefined]**
```bash
# Check if .env is being loaded
docker compose exec n8n cat /home/node/.n8n/.env

# If empty, restart with explicit environment
docker compose down
docker compose up -d
```

### **Issue 2: Workflow Import Errors**
- **Check n8n version**: Should be latest
- **Clear browser cache**: Hard refresh (Ctrl+F5)
- **Check file format**: Ensure JSON is valid

### **Issue 3: Credential Connection Errors**
- **Verify service names**: Must match exactly in workflow
- **Check credentials**: Test each service individually
- **Restart n8n**: After credential changes

### **Issue 4: Slack Buttons Not Working**
- **Verify webhook URLs**: Check Slack app settings
- **Check channel permissions**: Bot must be in #patient-alerts
- **Test interactivity**: Use Slack's test feature

## 📊 **Step 6: Monitor and Verify**

### **Check Workflow Status:**
1. **Go to n8n** → Executions tab
2. **View execution logs** for each step
3. **Check for failed nodes** and error messages

### **Database Verification:**
```bash
# Connect to database
docker compose exec postgres psql -U n8n -d n8n_healthcare

# Check tables
\dt

# Check patient data
SELECT * FROM patients ORDER BY created_at DESC LIMIT 5;
```

### **Redis Verification:**
```bash
# Connect to Redis
docker compose exec redis redis-cli -a your_redis_password_here

# Check cached cases
KEYS case:*

# View specific case
GET case:CASE-1234567890
```

## 🎯 **Step 7: Activate All Workflows**

### **Main Healthcare Workflow:**
- **Set to Active** (toggle switch)
- **Test webhook**: Use curl command above
- **Monitor execution**: Check each node success

### **Redis Alert Workflow:**
- **Set to Active** (toggle switch)
- **Test Slack integration**: Send message to #redis-alerts
- **Verify patient notifications**: Check email delivery

## 🏆 **Success Checklist**

Your system is fully integrated when:

- ✅ **Azure OpenAI** shows proper values (not [undefined])
- ✅ **Main workflow** processes patient intake end-to-end
- ✅ **Slack alerts** appear with specialist @mentions
- ✅ **Accept/Decline buttons** function properly
- ✅ **PDF reports** generate and email to specialists
- ✅ **Patient notifications** sent via email and SMS
- ✅ **Redis alert system** monitors Slack channels
- ✅ **Database** contains patient and specialist data
- ✅ **All credentials** connect successfully

## 🚀 **Next Steps After Integration**

1. **Test with real patient data** (HIPAA compliant)
2. **Customize Slack channels** for your team
3. **Adjust email templates** for your branding
4. **Set up monitoring** and alerting
5. **Scale specialist pool** as needed
6. **Add calendar integration** for appointments

## 📞 **Need Help?**

If you encounter issues:

1. **Check n8n logs**: `docker compose logs n8n`
2. **Verify environment**: `docker compose exec n8n env | grep AZURE`
3. **Test individual services**: Check each credential connection
4. **Review workflow execution**: Check failed nodes in n8n

**🎉 Congratulations! You're building a production-ready healthcare automation system!**
