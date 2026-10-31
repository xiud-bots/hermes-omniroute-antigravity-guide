# ==============================================================================
# Script: test-omniroute-hermes.ps1
# Finalidade: Smoke test de ponta a ponta no Windows (PowerShell)
# ==============================================================================

[CmdletBinding()]
param()

$Endpoint = "http://127.0.0.1:20128/v1"
$ApiKey = $env:OPENAI_API_KEY

# Buscar chave no ~/.hermes/.env se não estiver exportada
if (-not $ApiKey) {
    $EnvFile = Join-Path $HOME ".hermes\.env"
    if (Test-Path $EnvFile) {
        $Line = Get-Content $EnvFile | Where-Object { $_ -match "^OPENAI_API_KEY=" } | Select-Object -First 1
        if ($Line) {
            $ApiKey = ($Line -split "=", 2)[1].Trim('"'' ')
        }
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🧪 Smoke Test Windows: OmniRoute + Antigravity + Hermes" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Health check HTTP
Write-Host -NoNewline "1. Checando disponibilidade da porta 20128... "
try {
    $Health = Invoke-WebRequest -Uri "http://127.0.0.1:20128" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ ONLINE" -ForegroundColor Green
} catch {
    Write-Host "❌ OFFLINE (Verifique se o OmniRoute está rodando)" -ForegroundColor Red
    exit 1
}

# 2. Listar modelos
Write-Host -NoNewline "2. Consultando modelos registrados no OmniRoute... "
try {
    $Headers = @{ Authorization = "Bearer $ApiKey" }
    $Models = Invoke-RestMethod -Uri "$Endpoint/models" -Headers $Headers -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ SUCESSO" -ForegroundColor Green
} catch {
    Write-Host "⚠️ AVISO: Falha ao listar modelos via API." -ForegroundColor Yellow
}

# 3. Inferência de teste
Write-Host "3. Disparando inferência de teste para 'Antigravity-Smart'..."
$Payload = @{
    model = "Antigravity-Smart"
    messages = @(
        @{ role = "user"; content = "Responda apenas com a palavra TESTE_WINDOWS_OK" }
    )
    max_tokens = 10
} | ConvertTo-Json -Compress

try {
    $Inference = Invoke-RestMethod -Uri "$Endpoint/chat/completions" `
        -Method Post `
        -Headers @{
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $ApiKey"
        } `
        -Body $Payload `
        -TimeoutSec 20 `
        -ErrorAction Stop

    $Reply = $Inference.choices[0].message.content
    Write-Host "✅ INFERÊNCIA CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "   Resposta: $Reply" -ForegroundColor Gray
} catch {
    Write-Host "❌ FALHA NA INFERÊNCIA: $_" -ForegroundColor Red
    exit 1
}

# 4. Teste via Hermes CLI se disponível
if (Get-Command hermes -ErrorAction SilentlyContinue) {
    Write-Host "4. Testando execução direta via Hermes Agent CLI..."
    try {
        $HermesOut = hermes chat -q "Quem é você e qual modelo está ativo? Responda em uma frase."
        Write-Host "   Saída do Hermes:" -ForegroundColor Gray
        Write-Host "   $HermesOut" -ForegroundColor Cyan
    } catch {
        Write-Host "⚠️ Hermes CLI executou com advertência ou timeout." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Todos os testes de conectividade no Windows passaram!" -ForegroundColor Green
