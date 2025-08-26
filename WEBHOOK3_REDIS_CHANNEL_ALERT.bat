@echo off
echo 🏥 Healthcare Pipeline - Redis Channel Alert Webhook Test
echo =======================================================
echo.

echo 🔍 Testing Redis Channel Alert Webhook...
echo.

curl -X POST http://localhost:5678/webhook-test/redis-channel-alert ^
  -H "Content-Type: application/json" ^
  -d "{\"channel\": \"#redis-alerts\", \"message\": \"Test alert: System maintenance scheduled for tonight\", \"user\": \"test-user\", \"timestamp\": \"2024-08-26T20:00:00Z\"}"

echo.
echo.
echo ✅ Redis Channel Alert webhook test completed!
echo.
echo 📊 Check n8n at http://localhost:5678 for execution results
echo.
pause
