Write-Host "🏥 Healthcare Pipeline - Azure Credentials Fix" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🔍 Checking current container status..." -ForegroundColor Yellow
docker compose ps

Write-Host ""
Write-Host "🚨 Stopping n8n container to refresh environment..." -ForegroundColor Red
docker compose stop n8n

Write-Host ""
Write-Host "⏳ Waiting 5 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "🚀 Restarting n8n with fresh environment..." -ForegroundColor Green
docker compose up -d n8n

Write-Host ""
Write-Host "⏳ Waiting for n8n to start (10 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "🔍 Checking Azure environment variables..." -ForegroundColor Yellow
docker compose exec n8n env | Select-String "AZURE"

Write-Host ""
Write-Host "✅ Done! Now check n8n at http://localhost:5678" -ForegroundColor Green
Write-Host ""
Write-Host "📋 If you still see [undefined], check your .env file has:" -ForegroundColor Yellow
Write-Host "   AZURE_OPENAI_API_KEY=your_actual_key" -ForegroundColor White
Write-Host "   AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/" -ForegroundColor White
Write-Host "   AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name" -ForegroundColor White
Write-Host "   AZURE_OPENAI_API_VERSION=2024-02-15-preview" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to continue..."
