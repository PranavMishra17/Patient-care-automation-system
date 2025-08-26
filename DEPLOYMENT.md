# 🚀 Healthcare Pipeline Deployment Guide

## ✅ Pre-Deployment Checklist

### 1. Environment Variables
Make sure your `.env` file contains all required values:


### 2. Service Verifications
- ✅ Azure OpenAI: Model deployed and accessible
- ✅ Slack: App created, bot installed, channels created
- ✅ Twilio: Phone number purchased and verified
- ✅ SendGrid: Sender identity verified

## 🏁 Deployment Commands

### Step 1: Start All Services

**For Windows (Docker Desktop):**
```bash
# Start the healthcare pipeline
docker compose up -d

# Check if all services are running
docker compose ps
```

**For Linux/Mac (if you have docker-compose installed):**
```bash
# Start the healthcare pipeline
docker-compose up -d

# Check if all services are running
docker-compose ps
```

**Expected output:**
```
NAME                        COMMAND                  SERVICE             STATUS              PORTS
healthcare-pipeline-n8n-1       "tini -- /usr/local/…"   n8n                 running             127.0.0.1:5678->5678/tcp
healthcare-pipeline-postgres-1  "docker-entrypoint.s…"   postgres            running             127.0.0.1:5432->5432/tcp
healthcare-pipeline-redis-1     "docker-entrypoint.s…"   redis               running             127.0.0.1:6379->6379/tcp
```

### Step 2: Verify Database Setup
```bash
# Connect to PostgreSQL to verify tables were created
docker compose exec postgres psql -U n8n -d n8n_healthcare

# Run these commands in PostgreSQL:
\dt                              # List tables
SELECT COUNT(*) FROM patients;   # Should return 0 (empty table)
\q                              # Exit PostgreSQL
```

### Step 3: Verify Redis
```bash
# Connect to Redis
docker compose exec redis redis-cli -a your_redis_password_here

# Test Redis
PING                            # Should return PONG
KEYS *                          # Should return empty list initially
exit                           # Exit Redis
```

### Step 4: Access n8n Web Interface
1. **Open browser**: http://localhost:5678
2. **Create admin account** (first user becomes owner)
3. **Set up workspace**

### Step 5: Import Starter Workflow
1. **Click "New"** → **"Import from File"**
2. **Select** `starter-workflow.json`
3. **Activate the workflow** (toggle switch)
4. **Copy webhook URL** from the webhook node

## 🧪 Testing the Pipeline

### Test 1: Basic Workflow Test
```bash
# Test the patient intake webhook
curl -X POST http://localhost:5678/webhook/patient-intake \
  -H "Content-Type: application/json" \
  -d @sample-patient.json
```

**Expected result:**
- Workflow executes successfully
- Patient data encrypted
- AI analysis completed
- Specialist assigned
- Results logged

### Test 2: Database Storage Test
```bash
# Check if patient record was stored
docker compose exec postgres psql -U n8n -d n8n_healthcare -c "SELECT case_id, urgency_level, specialty, status FROM patients;"
```

### Test 3: Service Integration Tests

**Slack Test** (after adding Slack node):
```bash
# Should send message to #patient-alerts channel
```

**Twilio Test** (after adding Twilio node):
```bash
# Should send SMS to your verified phone number
```

**SendGrid Test** (after adding Email node):
```bash
# Should send email to your verified email address
```

## 📊 Monitoring

### View Service Logs
```bash
# View all logs
docker compose logs

# View specific service logs
docker compose logs n8n
docker compose logs postgres
docker compose logs redis

# Follow logs in real-time
docker compose logs -f n8n
```

### Health Checks
```bash
# Check service status
docker compose ps

# Check resource usage
docker stats

# Check n8n health
curl http://localhost:5678/healthz
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. "Cannot connect to database"
```bash
# Check if PostgreSQL is running
docker compose ps postgres

# Check PostgreSQL logs
docker compose logs postgres

# Restart PostgreSQL
docker compose restart postgres
```

#### 2. "Azure OpenAI API Error"
- Verify API key in `.env`
- Check endpoint URL format
- Ensure deployment name is correct
- Verify model is deployed in Azure

#### 3. "n8n not accessible"
```bash
# Check if n8n container is running
docker compose ps n8n

# Check n8n logs
docker compose logs n8n

# Restart n8n
docker compose restart n8n
```

#### 4. "Webhook not responding"
- Ensure workflow is activated in n8n
- Check webhook URL is correct
- Verify n8n is running on port 5678

## 🛑 Stopping Services

### Graceful Shutdown
```bash
# Stop all services
docker compose down

# Stop and remove volumes (⚠️ This deletes all data!)
docker compose down -v
```

### Restart Services
```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart n8n
```

## 🔄 Updates and Maintenance

### Update Docker Images
```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose up -d
```

### Backup Data
```bash
# Backup PostgreSQL data
docker compose exec postgres pg_dump -U n8n n8n_healthcare > backup_$(date +%Y%m%d).sql

# Backup n8n workflows
docker cp healthcare-pipeline-n8n-1:/home/node/.n8n ./n8n_backup/
```

## 🎉 Success Indicators

Your healthcare pipeline is successfully deployed when:

- ✅ All 3 Docker containers are running
- ✅ n8n web interface accessible at http://localhost:5678
- ✅ Database tables created successfully
- ✅ Starter workflow imports and activates
- ✅ Sample patient data processes without errors
- ✅ API integrations respond correctly

**You're now ready to build advanced healthcare automation workflows!** 🏥🤖
