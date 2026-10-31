# 🚀 Guia Definitivo: Hermes Agent + OmniRoute + Antigravity CLI

[![Licença MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Hermes Agent](https://img.shields.io/badge/Hermes_Agent-Nous_Research-purple.svg)](https://github.com/NousResearch/hermes-agent)
[![OmniRoute](https://img.shields.io/badge/OmniRoute-AI_Gateway-green.svg)](https://github.com/diegosouzapw/OmniRoute)
[![Google Antigravity](https://img.shields.io/badge/Google-Antigravity-orange.svg)](https://deepmind.google/)
[![Obsidian Vault](https://img.shields.io/badge/Obsidian-Native_Vault-purple.svg)](https://obsidian.md/)

> 📖 **Este repositório é estruturado nativamente como um Obsidian Vault!**  
> Para a melhor experiência de leitura humana, navegação em grafo e links bidirecionais:
> 1. Clone este repositório: `git clone https://github.com/xiud-bots/hermes-omniroute-antigravity-guide.git`
> 2. No Obsidian, selecione **Open folder as vault** e aponte para esta pasta.
> 3. Acesse a nota central do cofre: **[[00 - Index]]** (ou navegue pelas pastas estruturadas).

---

Este repositório contém o tutorial completo, scripts operacionais e templates de infraestrutura para provisionar e integrar o **Hermes Agent** ao **Google Antigravity** através do gateway inteligente **OmniRoute**.

Essa arquitetura permite que agentes autônomos locais e subagentes executem inferência de ponta a ponta com modelos Gemini de alta performance (`gemini-3.8-flash-high`, `gemini-3.7-flash-tiered`) de forma resiliente, gratuita e com failover automático.

---

## 🗺️ Mapa de Conteúdo do Vault (MOC)

- **[[00 - Index|00 - Dashboard & Central de Navegação]]**
- **01 - Visão Geral & Arquitetura:**
  - [[01 - Visão Geral/01.1 - Topologia e Arquitetura|01.1 - Topologia e Arquitetura da Solução]]
  - [[01 - Visão Geral/01.2 - Benefícios do Ecossistema|01.2 - Por Que OmniRoute + Antigravity?]]
- **02 - Instalação & Configuração:**
  - [[02 - Instalação & Configuração/02.1 - Google Antigravity CLI|02.1 - Instalação do Antigravity CLI]]
  - [[02 - Instalação & Configuração/02.2 - OmniRoute AI Gateway|02.2 - Instalação do OmniRoute]]
  - [[02 - Instalação & Configuração/02.3 - Provedor Antigravity no OmniRoute|02.3 - Conexão OAuth Antigravity (agy)]]
  - [[02 - Instalação & Configuração/02.4 - Model Combo Antigravity-Smart|02.4 - Configuração do Combo Antigravity-Smart]]
  - [[02 - Instalação & Configuração/02.5 - Chaves de API e Isolamento|02.5 - Emissão de Chaves de API & Segurança]]
  - [[02 - Instalação & Configuração/02.6 - Daemon Systemd de Usuário|02.6 - Provisionamento do Serviço Systemd]]
  - [[02 - Instalação & Configuração/02.7 - Configuração do Hermes Agent|02.7 - Configuração Completa do Hermes Agent]]
  - [[02 - Instalação & Configuração/02.8 - Instalação e Configuração no Windows|02.8 - Guia de Instalação e Setup no Windows]]
- **03 - Validação & Smoke Tests:**
  - [[03 - Validação & Smoke Tests/03.1 - Testes Automatizados (Script)|03.1 - Execução do Script de Smoke Test]]
  - [[03 - Validação & Smoke Tests/03.2 - Testes Manuais (cURL & Hermes CLI)|03.2 - Verificação Manual via cURL e CLI]]
- **04 - Operação & Troubleshooting:**
  - [[04 - Operação & Troubleshooting/04.1 - Guia de Solução de Problemas|04.1 - Matriz de Resolução de Erros]]
  - [[04 - Operação & Troubleshooting/04.2 - Manutenção e Rotação de Tokens|04.2 - Manutenção e Ciclo de Vida de Tokens]]
  - [[04 - Operação & Troubleshooting/04.3 - Padronização de Subagentes e Perfis|04.3 - Padronização para Subagentes e Perfis]]
- **05 - Anexos & Referências:**
  - [[05 - Anexos & Referências/Arquivo config.yaml Explicado|Template config.yaml Comentado]]
  - [[05 - Anexos & Referências/Arquivo .env Explicado|Template .env Comentado]]
  - [[05 - Anexos & Referências/Unit omniroute.service Explicada|Unit omniroute.service Comentada]]

---

## 🏛️ Visão Geral da Arquitetura

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Hermes Agent Ecosystem                          │
│                                                                        │
│   ┌───────────────┐     ┌───────────────┐     ┌────────────────────┐   │
│   │ Hermes CLI    │     │ Hermes Desktop│     │ Subagents (Tasks)  │   │
│   └───────┬───────┘     └───────┬───────┘     └─────────┬──────────┘   │
└───────────┼─────────────────────┼───────────────────────┼──────────────┘
            │                     │                       │
            ▼                     ▼                       ▼
   OpenAI-Compatible Requests (http://127.0.0.1:20128/v1/chat/completions)
   Model: "Antigravity-Smart" | Auth: Bearer sk-...
            │
            ▼
┌────────────────────────────────────────────────────────────────────────┐
│                    OmniRoute Gateway (Port 20128)                      │
│                                                                        │
│  - Systemd User Daemon (omniroute.service)                             │
│  - Combo "Antigravity-Smart" (Estratégia de Prioridade & Fallback):    │
│      1. agy/gemini-3.8-flash-high (Primário)                           │
│      2. agy/gemini-3.7-flash-tiered (Fallback imediato)                │
│  - Token Bucket, Retry Logic & Context Protection                      │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                         Google OAuth 2.0 (agy)
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                      Google Antigravity Platform                       │
│                     (Gemini 3.8 / 3.7 Infrastructure)                  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Pré-requisitos

- **Sistema Operacional:** Linux (Debian, Ubuntu, Parrot OS, Arch, Fedora) ou macOS.
- **Node.js:** Versão 20 LTS ou superior.
- **Python:** Versão 3.10 ou superior.
- **Git & cURL:** Utilitários básicos de terminal instalados.
- **Conta Google:** Com acesso ativo ao ecossistema Antigravity / Gemini.

---

## 📦 Passo a Passo de Instalação e Configuração

### Passo 1: Instalação e Autenticação do Antigravity CLI

O **Antigravity** é o ambiente de inteligência do Google que fornece acesso direto aos modelos Gemini de alta fidelidade de raciocínio.

1. Instale o executável do Antigravity CLI conforme o seu ambiente (ou instale o pacote do Antigravity IDE).
2. Execute a autenticação inicial com a sua conta Google:
   ```bash
   antigravity auth login
   # Ou execute o assistente de primeira inicialização
   ```
3. Valide se os arquivos de credenciais foram criados no diretório padrão:
   ```bash
   ls -la ~/.gemini/antigravity-cli/
   ```

---

### Passo 2: Instalação do OmniRoute

O **OmniRoute** (desenvolvido por Diego Souza) atua como um multiplexador e gateway local compatível com a API da OpenAI.

1. Instale o OmniRoute globalmente via `npm`:
   ```bash
   npm install -g omniroute
   ```
2. Verifique a instalação:
   ```bash
   omniroute --version
   ```

---

### Passo 3: Configurar o Provedor Antigravity no OmniRoute

1. Inicie o OmniRoute interativamente no terminal:
   ```bash
   PORT=20128 omniroute
   ```
2. Acesse a interface web do OmniRoute no navegador:
   👉 **`http://localhost:20128`**
3. Realize o login no painel administrativo (na primeira execução, defina a senha de admin).
4. **Vincular Conexão Antigravity (`agy`):**
   - Vá em **Connections** (Provedores) → **Add Connection**.
   - Selecione o provedor **Antigravity (`agy`)**.
   - Selecione a autenticação via **OAuth** e complete o fluxo de login com sua conta Google.
   - O status da conexão deve ficar como **Active (Ativo)**.

---

### Passo 4: Criar o Modelo Inteligente (Combo `Antigravity-Smart`)

Para garantir 100% de disponibilidade mesmo sob rate limits ou instabilidade momentânea, crie um **Model Combo**:

1. No menu lateral do OmniRoute, clique em **Combos** → **Create Combo**.
2. Preencha as definições:
   - **Name:** `Antigravity-Smart`
   - **Strategy:** `Priority` (Prioridade em cascata)
3. Adicione os modelos na ordem:
   1. `agy/gemini-3.8-flash-high` (Modelo primário de alto raciocínio)
   2. `agy/gemini-3.7-flash-tiered` (Modelo de fallback com baixa latência)
4. Salve o Combo.

---

### Passo 5: Gerar a Chave de API no OmniRoute

1. No menu do OmniRoute, acesse **API Keys** → **Create Key**.
2. Dê um nome (ex.: `Hermes-Agent-Key`) e defina as permissões para o modelo `Antigravity-Smart`.
3. Copie a chave gerada (formato: `sk-...`). **Guarde este valor.**

---

### Passo 6: Configurar o Daemon do OmniRoute no Systemd

Para que o proxy rode continuamente em segundo plano e inicie automaticamente no boot:

1. Use o script automatizado incluído neste repositório:
   ```bash
   ./scripts/setup-omniroute-service.sh
   ```
   *Ou execute manualmente:*
   ```bash
   mkdir -p ~/.config/systemd/user
   cp systemd/omniroute.service ~/.config/systemd/user/
   systemctl --user daemon-reload
   systemctl --user enable --now omniroute.service
   ```
2. Confirme que o serviço está ativo:
   ```bash
   systemctl --user status omniroute.service
   ```

---

### Passo 7: Instalação e Configuração do Hermes Agent

1. **Instalar o Hermes Agent:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
   ```
   *(Ou baixe o executável do Hermes Desktop).*

2. **Configurar o Provedor no Hermes (`~/.hermes/config.yaml`):**
   Edite o arquivo de configuração principal:
   ```yaml
   model:
     default: Antigravity-Smart
     provider: openai-api
     base_url: http://127.0.0.1:20128/v1
     api_mode: codex_responses

   delegation:
     model: Antigravity-Smart
     provider: openai-api
     base_url: http://127.0.0.1:20128/v1
     max_iterations: 250

   terminal:
     backend: local
     timeout: 180
   ```
   *(Você também pode usar o template fornecido em `config/hermes-config.example.yaml`).*

3. **Injetar a Chave de API no Hermes (`~/.hermes/.env`):**
   ```bash
   echo "OPENAI_API_KEY=sk-sua-chave-gerada-no-omniroute" >> ~/.hermes/.env
   chmod 600 ~/.hermes/.env
   ```

---

## 🧪 Smoke Tests & Verificação

Execute o script de teste de conectividade incluído:

```bash
./scripts/test-omniroute-hermes.sh
```

O script realizará 4 etapas de teste:
1. **Health Check HTTP:** Checa se o OmniRoute responde na porta `20128`.
2. **Catalog Query:** Valida se a chave de API consegue listar os modelos.
3. **Inferência Direta via cURL:** Dispara um prompt de teste para `Antigravity-Smart`.
4. **Execução no Hermes Agent:** Dispara uma pergunta de validação através do Hermes CLI.

---

## 🛠️ Solução de Problemas (Troubleshooting)

### 1. `Connection refused` na porta 20128
- Verifique se o daemon está em execução: `systemctl --user status omniroute.service`.
- Inspecione os logs em tempo real: `journalctl --user -u omniroute.service -f`.

### 2. Erro de Autenticação `401 Unauthorized`
- Confirme que a variável `OPENAI_API_KEY` em `~/.hermes/.env` corresponde exatamente à chave ativa listada no painel do OmniRoute.

### 3. Falha de Token OAuth do Google Antigravity
- Se o Google expirar o token de sessão, acesse a UI do OmniRoute (`http://localhost:20128`), vá em **Connections** e clique em **Re-authenticate** no provedor `agy`.

### 4. Permissões de Backend no Hermes
- Se o Hermes estiver bloqueado para executar comandos do sistema ou criar profiles, configure `terminal.backend: local` em `~/.hermes/config.yaml` e reinicie a sessão.

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE). Desenvolvido pela equipe de engenharia da **XIUD (XIU Development)**.
