# ==============================================================================
# Script: setup-omniroute-service.ps1
# Finalidade: Configurar o OmniRoute para rodar em background no Windows (PM2)
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "==> Verificando dependências no Windows..." -ForegroundColor Cyan

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "Node.js não foi encontrado no PATH. Instale com: winget install OpenJS.NodeJS.LTS"
    exit 1
}

if (-not (Get-Command omniroute -ErrorAction SilentlyContinue)) {
    Write-Host "OmniRoute não encontrado. Instalando globalmente via npm..." -ForegroundColor Yellow
    npm install -g omniroute
}

# Verificar se PM2 está instalado
if (-not (Get-Command pm2 -ErrorAction SilentlyContinue)) {
    Write-Host "==> Instalando gerenciador de processos PM2..." -ForegroundColor Yellow
    npm install -g pm2
}

Write-Host "==> Iniciando o OmniRoute com PM2 na porta 20128..." -ForegroundColor Cyan
pm2 start omniroute --name "omniroute" -- --port 20128

Write-Host "==> Salvando a lista de processos do PM2..." -ForegroundColor Cyan
pm2 save

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "✅ OmniRoute configurado e ativo na porta 20128!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Comandos úteis do PM2:"
Write-Host "  pm2 status omniroute    # Verificar status"
Write-Host "  pm2 logs omniroute      # Visualizar logs em tempo real"
Write-Host "  pm2 restart omniroute   # Reiniciar o serviço"
Write-Host "  pm2 stop omniroute      # Parar o serviço"
Write-Host ""
Write-Host "Para iniciar automaticamente no boot do Windows:"
Write-Host "  npm install -g pm2-windows-startup"
Write-Host "  pm2-startup install"
