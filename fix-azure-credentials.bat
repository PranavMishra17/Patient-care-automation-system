@echo off
echo 🏥 Healthcare Pipeline - Azure Credentials Fix
echo ==============================================
echo.

echo 🔍 Checking current container status...
docker compose ps

echo.
echo 🚨 Stopping n8n container to refresh environment...
docker compose stop n8n

echo.
echo ⏳ Waiting 5 seconds...
timeout /t 5 /nobreak >nul

echo.
echo 🚀 Restarting n8n with fresh environment...
docker compose up -d n8n

echo.
echo ⏳ Waiting for n8n to start (10 seconds)...
timeout /t 10 /nobreak >nul

echo.
echo 🔍 Checking Azure environment variables...
docker compose exec n8n env | findstr AZURE

echo.
echo ✅ Done! Now check n8n at http://localhost:5678
echo.
echo 📋 If you still see [undefined], check your .env file has:
echo    AZURE_OPENAI_API_KEY=your_actual_key
echo    AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
echo    AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name
echo    AZURE_OPENAI_API_VERSION=2024-02-15-preview
echo.
pause
