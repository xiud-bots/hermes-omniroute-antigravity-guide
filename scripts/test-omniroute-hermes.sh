#!/usr/bin/env bash
# ==============================================================================
# Script: test-omniroute-hermes.sh
# Finalidade: Smoke test de ponta a ponta (OmniRoute + Antigravity + Hermes)
# ==============================================================================

set -uo pipefail

ENDPOINT="http://127.0.0.1:20128/v1"
API_KEY="${OPENAI_API_KEY:-}"

if [ -z "$API_KEY" ] && [ -f "$HOME/.hermes/.env" ]; then
    API_KEY="$(grep -E '^OPENAI_API_KEY=' "$HOME/.hermes/.env" | cut -d'=' -f2- | tr -d '"'\'' ' || true)"
fi

echo "=========================================================="
echo "🧪 Smoke Test: OmniRoute + Antigravity CLI + Hermes Agent"
echo "=========================================================="

# 1. Teste de Saúde HTTP do OmniRoute
echo -n "1. Checando disponibilidade da porta 20128... "
if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 "http://127.0.0.1:20128" >/dev/null; then
    echo "✅ ONLINE"
else
    echo "❌ OFFLINE (Verifique se o serviço está rodando: systemctl --user status omniroute.service)"
    exit 1
fi

# 2. Listar modelos disponíveis via API do OmniRoute
echo -n "2. Consultando modelos registrados no OmniRoute... "
MODELS_RESPONSE="$(curl -s -H "Authorization: Bearer $API_KEY" "$ENDPOINT/models" || true)"
if echo "$MODELS_RESPONSE" | grep -qi "Antigravity"; then
    echo "✅ SUCESSO (Modelos Antigravity encontrados)"
else
    echo "⚠️ AVISO: Modelo Antigravity-Smart não listado explicitamente no payload /models."
fi

# 3. Teste de Inferência Direta via curl
echo "3. Disparando inferência de teste para 'Antigravity-Smart'..."
PAYLOAD='{
  "model": "Antigravity-Smart",
  "messages": [{"role": "user", "content": "Responda apenas com a palavra TESTE_OK"}],
  "max_tokens": 10
}'

INFERENCE_RES="$(curl -s -X POST "$ENDPOINT/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "$PAYLOAD" || true)"

if echo "$INFERENCE_RES" | grep -qi "TESTE_OK"; then
    echo "✅ INFERÊNCIA CONCLUÍDA COM SUCESSO!"
    echo "   Resposta: $(echo "$INFERENCE_RES" | grep -o '"content":"[^"]*"' | head -1)"
else
    echo "❌ FALHA NA INFERÊNCIA:"
    echo "$INFERENCE_RES"
    exit 1
fi

# 4. Teste via Hermes CLI se instalado
if command -v hermes >/dev/null 2>&1; then
    echo "4. Testando execução direta via Hermes Agent CLI..."
    HERMES_TEST="$(hermes chat -q "Quem é você e qual modelo está ativo? Responda em uma frase." 2>&1 || true)"
    echo "   Saída do Hermes:"
    echo "   $HERMES_TEST"
fi

echo ""
echo "🎉 Todos os testes de conectividade passaram com sucesso!"
