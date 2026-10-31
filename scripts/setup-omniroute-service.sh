#!/usr/bin/env bash
# ==============================================================================
# Script: setup-omniroute-service.sh
# Finalidade: Instalar e habilitar o OmniRoute como daemon de usuário no Systemd
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_SOURCE="$SCRIPT_DIR/../systemd/omniroute.service"
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "==> Verificando dependências..."
if ! command -v node >/dev/null 2>&1; then
    echo "ERRO: Node.js não encontrado no PATH." >&2
    exit 1
fi

OMNIRoute_BIN="$(command -v omniroute || echo "$HOME/.local/bin/omniroute")"
if [ ! -x "$OMNIRoute_BIN" ]; then
    echo "ERRO: Binário do OmniRoute não encontrado em $OMNIRoute_BIN." >&2
    echo "Execute: npm install -g omniroute" >&2
    exit 1
fi

echo "==> Criando diretório de serviços do systemd do usuário..."
mkdir -p "$USER_SYSTEMD_DIR"

echo "==> Copiando arquivo de unit..."
cp "$SERVICE_SOURCE" "$USER_SYSTEMD_DIR/omniroute.service"

echo "==> Recarregando systemd daemon..."
systemctl --user daemon-reload

echo "==> Habilitando e iniciando omniroute.service..."
systemctl --user enable --now omniroute.service

echo "==> Verificando status..."
systemctl --user status omniroute.service --no-pager || true

echo ""
echo "Sucesso! O OmniRoute está em execução na porta 20128."
echo "Para verificar os logs: journalctl --user -u omniroute.service -f"
