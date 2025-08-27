@echo off
echo 🏥 Healthcare Pipeline - Slack Interaction Webhook Test (ACCEPT)
echo ================================================================
echo.

echo 🔍 Testing Slack Interaction Webhook - CASE ACCEPTED...
echo.

curl -X POST http://localhost:5678/webhook-test/slack-interaction ^
  -H "Content-Type: application/json" ^
  -d "{\"type\": \"block_actions\", \"actions\": [{\"action_id\": \"accept_case\", \"value\": \"accept\"}], \"user\": {\"id\": \"U123456\", \"name\": \"Dr. Smith\"}, \"channel\": {\"id\": \"C123456\", \"name\": \"patient-alerts\"}}"

echo.
echo.
echo ✅ Slack Interaction webhook test (ACCEPT) completed!
echo.
echo 📊 Check n8n at http://localhost:5678 for execution results
echo.
pause