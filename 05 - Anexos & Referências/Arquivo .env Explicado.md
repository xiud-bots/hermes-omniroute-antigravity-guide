# Template `.env` Comentado

Arquivo de referência para variáveis de ambiente sensíveis do Hermes em `~/.hermes/.env`:

```env
# ==============================================================================
# Chave de Autenticação do OmniRoute (Obrigatória)
# ==============================================================================
# Gerada no painel do OmniRoute: Dashboard -> API Keys -> Create Key
# O valor deve iniciar com o prefixo padrão configurado (ex: sk-...)
OPENAI_API_KEY=sk-sua-chave-gerada-no-omniroute-aqui

# ==============================================================================
# Provedores de Busca na Web (Opcionais)
# ==============================================================================
# Usados para web search e content extraction
# TAVILY_API_KEY=tvly-...
# FIRECRAWL_API_KEY=fc-...

# ==============================================================================
# Controle de Acesso e Plataformas de Mensageria (Opcionais)
# ==============================================================================
# GITHUB_TOKEN=ghp_...
# TELEGRAM_BOT_TOKEN=...
# DISCORD_BOT_TOKEN=...
```

> [!WARNING]
> Nunca compartilhe seu arquivo `.env` nem o adicione em commits do Git. Sempre valide as permissões de sistema:
> `chmod 600 ~/.hermes/.env`

Veja também:
- [[02 - Instalação & Configuração/02.5 - Chaves de API e Isolamento|02.5 - Chaves de API e Isolamento]]
- [[00 - Index|Central de Navegação]]
