# Template `config.yaml` Comentado

Arquivo de referência para `~/.hermes/config.yaml`:

```yaml
# ==============================================================================
# 1. Provedor Principal e Modelo (OmniRoute AI Gateway)
# ==============================================================================
model:
  # Nome do Model Combo criado no dashboard do OmniRoute
  default: "Antigravity-Smart"
  
  # Tipo de driver: protocolo universal OpenAI
  provider: "openai-api"
  
  # Endpoint local servido pelo systemd do OmniRoute
  base_url: "http://127.0.0.1:20128/v1"
  
  # Modo de compatibilidade para parse de streaming e tools
  api_mode: "codex_responses"

# ==============================================================================
# 2. Configuração de Subagentes e Delegação Paralela (delegate_task)
# ==============================================================================
delegation:
  model: "Antigravity-Smart"
  provider: "openai-api"
  base_url: "http://127.0.0.1:20128/v1"
  max_iterations: 250
  child_timeout_seconds: 600

# ==============================================================================
# 3. Backend de Execução de Terminal
# ==============================================================================
terminal:
  # "local" = execução nativa no host (permite controlar systemd, npm, hermes)
  # "docker" = container sandbox isolado
  backend: "local"
  timeout: 180

# ==============================================================================
# 4. Políticas de Compressão de Contexto
# ==============================================================================
compression:
  enabled: true
  threshold: 0.50     # Dispara compressão ao atingir 50% da janela
  target_ratio: 0.20  # Reduz para 20% do tamanho
  protect_last_n: 20  # Preserva as últimas 20 mensagens intactas

# ==============================================================================
# 5. Políticas de Segurança e Aprovação de Comandos
# ==============================================================================
approvals:
  mode: "smart"       # Avalia risco via IA antes de solicitar confirmação humana
  timeout: 60
```

Veja também:
- [[02 - Instalação & Configuração/02.7 - Configuração do Hermes Agent|02.7 - Configuração do Hermes Agent]]
- [[00 - Index|Central de Navegação]]
