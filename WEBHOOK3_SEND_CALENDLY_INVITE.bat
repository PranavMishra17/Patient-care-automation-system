@echo off
echo 🏥 Healthcare Pipeline - Send Calendly Invite Webhook Test
echo =========================================================
echo.

echo 📅 Testing Send Calendly Invite Webhook...
echo.

curl -X GET "http://localhost:5678/webhook-test/send-calendly?caseId=CASE-1756255183150&specialist=Dr.%%20James%%20Smith&patientEmail=john.doe%%40email.com"

echo.
echo.
echo ✅ Send Calendly Invite webhook test completed!
echo.
echo 📊 Check n8n at http://localhost:5678 for execution results
echo 📧 Patient should receive Calendly scheduling email
echo.
pause