@echo off
echo 🏥 Healthcare Pipeline - Patient Intake Webhook Test
echo ===================================================
echo.

echo 🔍 Testing Patient Intake Webhook...
echo.

curl -X POST http://localhost:5678/webhook-test/patient-intake ^
  -H "Content-Type: application/json" ^
  -d "{\"firstName\": \"John\", \"lastName\": \"Doe\", \"age\": 55, \"gender\": \"Male\", \"phoneNumber\": \"+15551234567\", \"email\": \"john.doe@email.com\", \"chiefComplaint\": \"Chest pain and shortness of breath\", \"symptoms\": \"Severe chest pain, difficulty breathing, fatigue\", \"medicalHistory\": \"Hypertension, diabetes type 2\"}"

echo.
echo.
echo ✅ Patient Intake webhook test completed!
echo.
echo 📊 Check n8n at http://localhost:5678 for execution results
echo.
pause
