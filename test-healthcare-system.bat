@echo off
echo 🏥 Healthcare Pipeline - System Test Script
echo ===========================================
echo.

echo 🔍 Testing Patient Intake Webhook...
curl -X POST http://localhost:5678/webhook-test/patient-intake ^
  -H "Content-Type: application/json" ^
  -d "{\"firstName\": \"John\", \"lastName\": \"Doe\", \"age\": 55, \"gender\": \"Male\", \"phoneNumber\": \"+15551234567\", \"email\": \"john.doe@email.com\", \"chiefComplaint\": \"Chest pain and shortness of breath\", \"symptoms\": \"Severe chest pain, difficulty breathing, fatigue\", \"medicalHistory\": \"Hypertension, diabetes type 2\"}"

echo.
echo.
echo 🔍 Testing Slack Interaction Webhook...
curl -X POST http://localhost:5678/webhook-test/slack-interaction ^
  -H "Content-Type: application/json" ^
  -d "{\"type\": \"block_actions\", \"actions\": [{\"action_id\": \"accept_case\", \"value\": \"test-case-123\"}], \"user\": {\"id\": \"U123456\", \"name\": \"Dr. Smith\"}}"

echo.
echo.
echo 🔍 Testing Redis Channel Alert Webhook...
curl -X POST http://localhost:5678/webhook-test/redis-channel-alert ^
  -H "Content-Type: application/json" ^
  -d "{\"channel\": \"#redis-alerts\", \"message\": \"Test alert: System maintenance scheduled for tonight\", \"user\": \"test-user\"}"

echo.
echo.
echo ✅ All webhook tests completed!
echo.
echo 📊 Check n8n at http://localhost:5678 for execution results
echo.
pause
