Write-Host "🏥 Healthcare Pipeline - System Test Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🔍 Testing Patient Intake Webhook..." -ForegroundColor Yellow
try {
    $patientData = @{
        firstName = "John"
        lastName = "Doe"
        age = 55
        gender = "Male"
        phoneNumber = "+15551234567"
        email = "john.doe@email.com"
        chiefComplaint = "Chest pain and shortness of breath"
        symptoms = "Severe chest pain, difficulty breathing, fatigue"
        medicalHistory = "Hypertension, diabetes type 2"
    }
    
    $response = Invoke-WebRequest -Uri "http://localhost:5678/webhook-test/patient-intake" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body ($patientData | ConvertTo-Json -Depth 10)
    
    Write-Host "✅ Patient Intake: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Patient Intake Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔍 Testing Slack Interaction Webhook..." -ForegroundColor Yellow
try {
    $slackData = @{
        type = "block_actions"
        actions = @(@{action_id = "accept_case"; value = "test-case-123"})
        user = @{id = "U123456"; name = "Dr. Smith"}
    }
    
    $response = Invoke-WebRequest -Uri "http://localhost:5678/webhook-test/slack-interaction" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body ($slackData | ConvertTo-Json -Depth 10)
    
    Write-Host "✅ Slack Interaction: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Slack Interaction Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔍 Testing Redis Channel Alert Webhook..." -ForegroundColor Yellow
try {
    $redisData = @{
        channel = "#redis-alerts"
        message = "Test alert: System maintenance scheduled for tonight"
        user = "test-user"
    }
    
    $response = Invoke-WebRequest -Uri "http://localhost:5678/webhook-test/redis-channel-alert" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body ($redisData | ConvertTo-Json -Depth 10)
    
    Write-Host "✅ Redis Alert: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Redis Alert Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ All webhook tests completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Check n8n at http://localhost:5678 for execution results" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to continue..."
