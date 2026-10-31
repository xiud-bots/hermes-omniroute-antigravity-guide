# Unit `omniroute.service` Comentada

Arquivo de referência para a unit de serviço de usuário em `~/.config/systemd/user/omniroute.service`:

```ini
[Unit]
Description=OmniRoute AI Gateway & Proxy Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
# Executa dentro do diretório home do usuário logado
WorkingDirectory=%h

# Variáveis essenciais de ambiente:
# Prioriza executáveis do usuário local (~/.local/bin) onde o Node e o OmniRoute residem
Environment="PATH=%h/.local/bin:/usr/local/bin:/usr/bin:/bin"
Environment="PORT=20128"
Environment="NODE_ENV=production"

# Executável do OmniRoute
ExecStart=%h/.local/bin/omniroute

# Resiliência: reiniciar sempre em caso de crash
Restart=always
RestartSec=5

# Logs direcionados nativamente para o journald do Linux
StandardOutput=journal
StandardError=journal

# Aumento do descritor de arquivos para alto volume de requisições SSE
LimitNOFILE=65536

[Install]
WantedBy=default.target
```

Veja também:
- [[02 - Instalação & Configuração/02.6 - Daemon Systemd de Usuário|02.6 - Daemon Systemd de Usuário]]
- [[00 - Index|Central de Navegação]]
