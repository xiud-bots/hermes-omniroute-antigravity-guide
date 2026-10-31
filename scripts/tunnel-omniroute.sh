#!/usr/bin/env bash
# ==============================================================================
# Script: tunnel-omniroute.sh
# Finalidade: Criar túnel SSH com encaminhamento de porta para OAuth do Antigravity
# e acesso seguro ao dashboard do OmniRoute na VM Oracle Cloud
# ==============================================================================

set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Uso: $0 <usuario@ip-tailscale-ou-host> [chave_ssh]"
    echo "Exemplo: $0 ubuntu@100.85.120.45"
    echo "Exemplo: $0 ubuntu@hermes-oracle ~/.ssh/id_rsa"
    exit 1
fi

REMOTE_HOST="$1"
SSH_KEY="${2:-}"

PORT=20128

echo "=========================================================="
echo "🔌 Estabelecendo Túnel SSH para OmniRoute na Oracle Cloud"
echo "=========================================================="
echo "Porta Local:   http://localhost:$PORT"
echo "Porta Remota:  http://localhost:$PORT (na VM Oracle)"
echo "Host Remoto:   $REMOTE_HOST"
echo ""
echo "Instruções:"
echo "1. Mantenha este terminal aberto enquanto fizer login ou usar o OmniRoute."
echo "2. Abra no navegador do seu computador: http://localhost:$PORT"
echo "3. Ao clicar em 'Conectar com Google (Antigravity)', o callback do OAuth"
echo "   redirecionará para localhost:$PORT e entregará o token diretamente à VM."
echo "4. Pressione Ctrl+C para encerrar o túnel quando terminar."
echo "=========================================================="
echo ""

SSH_CMD="ssh -N -L ${PORT}:127.0.0.1:${PORT}"
if [ -n "$SSH_KEY" ]; then
    SSH_CMD="$SSH_CMD -i $SSH_KEY"
fi

$SSH_CMD "$REMOTE_HOST"
