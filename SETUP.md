# Healthcare Pipeline Setup Guide

## 🚀 Quick Start

### 1. Environment Setup


Create a `.env` file in your project root with these values:

```bash
# Database Configuration (choose your own strong passwords)
DB_PASSWORD=your_secure_db_password_here
REDIS_PASSWORD=your_secure_redis_password_here

# n8n Configuration (already generated for you)
N8N_ENCRYPTION_KEY=0238C2720ED442CED780C460BE9E15A4499146DCA1B9FAF31240362CB0ED1EB8
JWT_SECRET=E2812C3169A965DA4C6D7582FE943EAAE15D2A5F57F5FD2F7E0EDA76C7AF1425
PHI_ENCRYPTION_KEY=0CEEE0AB50A53FE648A00565C91CEE8CC1479A84EAEE06AFA2803EF68511F082

# Azure OpenAI Configuration (you need to set these up)
AZURE_OPENAI_API_KEY=your_azure_openai_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name_here
AZURE_OPENAI_API_VERSION=2024-02-15-preview

# Optional - for advanced features (can skip initially)
SLACK_BOT_TOKEN=xoxb-your-slack-bot-token-here
TWILIO_ACCOUNT_SID=your_twilio_account_sid_here
TWILIO_AUTH_TOKEN=your_twilio_auth_token_here
SENDGRID_API_KEY=your_sendgrid_api_key_here
```

## 🔧 What You Need to Set Up

### ✅ **INCLUDED IN DOCKER (No separate setup needed):**
- **PostgreSQL** - Runs locally in Docker container
- **Redis** - Runs locally in Docker container  
- **n8n** - Runs locally in Docker container

### 🔑 **EXTERNAL ACCOUNTS NEEDED:**

#### **Required for Basic Workflow:**
1. **Azure OpenAI** (Required for AI analysis)
   - Go to [Azure Portal](https://portal.azure.com)
   - Create an "Azure OpenAI Service" resource
   - Deploy a GPT-4 model
   - Get: API Key, Endpoint URL, Deployment Name

#### **Optional for Advanced Features:**
2. **Slack** (For notifications - can skip initially)
   - Go to [api.slack.com](https://api.slack.com/apps)
   - Create a new Slack app using the provided manifest
   - Get Bot Token (starts with `xoxb-`)
   - **Detailed setup below** ⬇️

3. **Twilio** (For SMS - can skip initially)
   - Sign up at [twilio.com](https://www.twilio.com)
   - Get Account SID and Auth Token
   - **Additional setup required** ⬇️

4. **SendGrid** (For email - can skip initially)
   - Sign up at [sendgrid.com](https://sendgrid.com)
   - Get API Key
   - **Additional setup required** ⬇️

## 📋 **Detailed Azure OpenAI Setup** (Required)

Since Azure OpenAI is required for the basic workflow, here's how to set it up:

### Step 1: Create Azure OpenAI Resource
1. Go to [Azure Portal](https://portal.azure.com)
2. Click "Create a resource"
3. Search for "Azure OpenAI"
4. Click "Create" and fill in:
   - **Subscription**: Your Azure subscription
   - **Resource Group**: Create new or use existing
   - **Name**: Choose a unique name (e.g., `healthcare-openai-001`)
   - **Region**: Choose a region that supports GPT-4 (e.g., East US, West Europe)
   - **Pricing Tier**: Standard S0

### Step 2: Deploy a Model
1. After creation, go to your Azure OpenAI resource
2. Click "Go to Azure OpenAI Studio"
3. Navigate to "Deployments" → "Create new deployment"
4. Select:
   - **Model**: `gpt-4` or `gpt-4-turbo`
   - **Deployment name**: `gpt-4-healthcare` (this goes in your .env)
   - **Version**: Latest available

### Step 3: Get Your Credentials
1. In Azure OpenAI Studio, go to "Playground"
2. Click "View code" 
3. You'll see:
   - **Endpoint**: `https://your-resource-name.openai.azure.com/`
   - **API Key**: Click "Show" to reveal
   - **Deployment name**: The name you chose above

### Step 4: Update Your .env File
```bash
AZURE_OPENAI_API_KEY=your_actual_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4-healthcare
```

## 🚀 **Quick Start for Testing** (Minimum Setup)

**To test the basic workflow, you only need:**

1. **Create `.env` file** with Azure OpenAI credentials + database passwords
2. **Run `docker-compose up -d`** 
3. **Access n8n at http://localhost:5678**
4. **Import the starter workflow**

**You can skip Slack, Twilio, and SendGrid for initial testing!**

## 📱 **Detailed Slack App Setup** (Optional)

If you want to add Slack notifications to your workflow, follow these steps:

### Step 1: Create Slack App from Manifest
1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Click "Create New App"
3. Choose "From an app manifest"
4. Select your workspace
5. Copy and paste the contents from `slack-app-manifest.json` file
6. **IMPORTANT**: Before creating, update the URLs in the manifest:
   - Replace `http://your-n8n-url:5678` with your actual n8n URL
   - For local testing: `http://localhost:5678`
   - For production: `https://your-domain.com`

### Step 2: Install App to Workspace
1. After creating the app, go to "Install App" in the sidebar
2. Click "Install to Workspace"
3. Authorize the app with the requested permissions
4. **Copy the Bot User OAuth Token** (starts with `xoxb-`)

### Step 3: Create Slack Channels
Create these channels in your Slack workspace:
- `#patient-alerts` - For new patient assignments
- `#critical-care` - For urgent cases
- `#care-coordination` - For general updates

### Step 4: Add Bot to Channels
1. Go to each channel
2. Type `/invite @Healthcare Pipeline Bot`
3. The bot will now be able to post messages

### Step 5: Get Bot Token and Update .env
1. After installing the app, go to "OAuth & Permissions" in your Slack app settings
2. Copy the **"Bot User OAuth Token"** (starts with `xoxb-`)
3. Update your `.env` file:

```bash
# Slack Configuration
SLACK_BOT_TOKEN=xoxb-your-actual-bot-token-here

# Optional: For webhook verification (recommended for production)
SLACK_SIGNING_SECRET=82a1c638a076dc55580bf3f394199173
```

### Step 6: Which Slack Credentials to Use

**✅ REQUIRED for basic functionality:**
- **Bot User OAuth Token** (`xoxb-...`) - For sending messages and API calls
  - Found in: OAuth & Permissions → Bot User OAuth Token
  - Use in: n8n Slack nodes

**✅ RECOMMENDED for security:**
- **Signing Secret** (`82a1c638a076dc55580bf3f394199173`) - To verify requests from Slack
  - Found in: Basic Information → App Credentials → Signing Secret
  - Use in: n8n webhook nodes to verify Slack requests

**❌ NOT NEEDED for basic setup:**
- **Client ID & Client Secret** - Only for OAuth flow (if users install your app)
- **Verification Token** - Deprecated, use Signing Secret instead
- **App ID** - Only for advanced app management

### Step 6: Test Slack Integration
1. In n8n, add a Slack node to your workflow
2. Configure it with your bot token
3. Test sending a message to `#patient-alerts`

### What the Slack App Can Do:
- ✅ **Send patient assignment notifications**
- ✅ **Interactive buttons for accepting cases**
- ✅ **Slash commands for checking case status**
- ✅ **Direct messages for urgent alerts**
- ✅ **Reactions for quick responses**

### Slack App Features Included:
- **Bot User**: Healthcare Pipeline Bot
- **Slash Commands**: `/patient-status`, `/accept-case`
- **Interactive Components**: Buttons and menus
- **Event Subscriptions**: Mentions and reactions
- **Permissions**: Send messages, read channels, access user info

## 📱 **Detailed Twilio Setup** (Optional)

Since you've signed up for Twilio, here's what you need to complete the setup:

### Step 1: Get a Phone Number
1. **Go to Twilio Console** → Phone Numbers → Manage → Buy a number
2. **Choose a number** that supports SMS in your region
3. **Buy the number** (free trial gives you credit)
4. **Copy the phone number** (e.g., +15551234567)

### Step 2: Update Your .env File
```bash
# Twilio Configuration
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_FROM_NUMBER=+15551234567
```

### Step 3: Healthcare Compliance Considerations

**⚠️ IMPORTANT for Healthcare:**

**For HIPAA Compliance with Twilio:**
1. **Sign Business Associate Agreement (BAA)**
   - Go to Twilio Console → Settings → Compliance
   - Request and sign the HIPAA BAA
   - This is REQUIRED for sending PHI via SMS

2. **Enable Message Retention Controls**
   - Set message retention to minimum required
   - Configure data location preferences
   - Enable audit logging

3. **Use Secure Message Content**
   - Never send full PHI in SMS
   - Use case IDs and secure links only
   - Example: "Case #12345 requires attention. Login to view details."

### Step 4: Test SMS Functionality
In your n8n workflow, add a Twilio node with:
- **Account SID**: `{{$env.TWILIO_ACCOUNT_SID}}`
- **Auth Token**: `{{$env.TWILIO_AUTH_TOKEN}}`
- **From Number**: `{{$env.TWILIO_FROM_NUMBER}}`
- **To Number**: Test with your own phone number
- **Message**: "Test message from Healthcare Pipeline"

### Step 5: Message Templates for Healthcare

**✅ HIPAA-Compliant Message Examples:**
```
"URGENT: Case #{{caseId}} requires immediate attention. Please check your secure portal."

"Reminder: You have a patient case pending review. Case ID: {{caseId}}"

"Critical alert: High-priority case assigned. Login to healthcare portal for details."
```

**❌ NEVER Send in SMS:**
- Patient names
- Medical conditions
- Treatment details
- Any PHI/sensitive information

### What Twilio Enables in Your Pipeline:
- ✅ **Critical case alerts** to specialists
- ✅ **Appointment reminders** to patients
- ✅ **System notifications** for staff
- ✅ **Emergency escalations** for urgent cases

### Free Trial Limitations:
- **$15.50 credit** for testing
- **SMS costs ~$0.0075** per message
- **Can send ~2000 test messages**
- **Verified phone numbers only** (until you upgrade)

## 📧 **Detailed SendGrid Setup** (Optional)

Since you have your SendGrid API key, here's what else you need to configure:

### Step 1: Verify Your Sender Identity
**⚠️ REQUIRED - SendGrid won't send emails without this:**

1. **Go to SendGrid Dashboard** → **Settings** → **Sender Authentication**
2. **Choose one option:**
   
   **Option A: Single Sender Verification (Easier)**
   - Click "Verify a Single Sender"
   - Enter your email (e.g., `noreply@yourdomain.com` or your personal email)
   - Check your email and click the verification link
   
   **Option B: Domain Authentication (Professional)**
   - Click "Authenticate Your Domain"
   - Enter your domain (e.g., `yourdomain.com`)
   - Add DNS records as instructed

### Step 2: Update Your .env File
```bash
# SendGrid Configuration
SENDGRID_API_KEY=your_sendgrid_api_key_here
SENDGRID_FROM_EMAIL=noreply@yourdomain.com  # Must match verified sender
SENDGRID_FROM_NAME=Healthcare Pipeline
```

### Step 3: Healthcare Email Templates

**✅ HIPAA-Compliant Email Examples:**

**Subject**: `Healthcare Appointment Confirmation - Case #{{caseId}}`
**Body**:
```html
<h2>Appointment Confirmation</h2>
<p>Your specialist appointment has been scheduled.</p>
<p><strong>Case Reference:</strong> {{caseId}}</p>
<p><strong>Next Steps:</strong> Please log into your patient portal for details.</p>
<p>If you have questions, contact our office.</p>
```

**Subject**: `Specialist Assignment Notification`
**Body**:
```html
<h2>New Patient Case Assignment</h2>
<p>You have been assigned a new patient case.</p>
<p><strong>Case ID:</strong> {{caseId}}</p>
<p><strong>Priority:</strong> {{urgency}}</p>
<p><a href="{{portalLink}}">Review Case Details</a></p>
```

### Step 4: Test Email Functionality
In n8n, add an Email node with:
- **Service**: SendGrid
- **API Key**: `{{$env.SENDGRID_API_KEY}}`
- **From Email**: `{{$env.SENDGRID_FROM_EMAIL}}`
- **From Name**: `{{$env.SENDGRID_FROM_NAME}}`
- **To**: Your email for testing
- **Subject**: "Test from Healthcare Pipeline"
- **Body**: "Email integration working!"

### Step 5: Healthcare Compliance for Email

**✅ DO:**
- Use case IDs instead of patient names
- Include secure portal links
- Keep email content minimal
- Use professional templates

**❌ DON'T:**
- Include PHI in email content
- Send medical details via email
- Use patient names in subject lines
- Include treatment information

### What SendGrid Enables:
- ✅ **Appointment confirmations** to patients
- ✅ **Case notifications** to specialists  
- ✅ **System alerts** to administrators
- ✅ **Professional HTML emails** with templates

### Free Tier Limitations:
- **100 emails/day** for free
- **No dedicated IP** (shared sending)
- **SendGrid branding** in emails
- **Basic analytics** only

### API Key Security Note:
- Your API Key ID (`o9SoI7u1Rei5YNze-njusw`) is just an identifier
- Keep the actual API key secret in your `.env` file
- Never commit API keys to git (they're in `.gitignore`)

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
