# ==============================================================================
# Script: tunnel-omniroute.ps1
# Finalidade: Criar túnel SSH com encaminhamento de porta no Windows (PowerShell)
# para OAuth do Antigravity e acesso ao dashboard do OmniRoute na VM Oracle
# ==============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$RemoteHost,

    [Parameter(Mandatory=$false, Position=1)]
    [string]$IdentityFile
)

$Port = 20128

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🔌 Estabelecendo Túnel SSH para OmniRoute na Oracle Cloud" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Porta Local:   http://localhost:$Port" -ForegroundColor Gray
Write-Host "Porta Remota:  http://localhost:$Port (na VM Oracle)" -ForegroundColor Gray
Write-Host "Host Remoto:   $RemoteHost" -ForegroundColor Gray
Write-Host ""
Write-Host "Instruções:" -ForegroundColor Yellow
Write-Host "1. Mantenha este terminal aberto enquanto fizer login ou usar o OmniRoute."
Write-Host "2. Abra no navegador do seu Windows: http://localhost:$Port"
Write-Host "3. Ao clicar em 'Conectar com Google (Antigravity)', o callback do OAuth"
Write-Host "   redirecionará para localhost:$Port e entregará o token diretamente à VM."
Write-Host "4. Pressione Ctrl+C para encerrar o túnel quando terminar."
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$SshArgs = @("-N", "-L", "${Port}:127.0.0.1:${Port}")
if ($IdentityFile) {
    $SshArgs += @("-i", $IdentityFile)
}
$SshArgs += $RemoteHost

ssh @SshArgs
