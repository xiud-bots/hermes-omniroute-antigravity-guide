# 👥 Perfis Base do Ecossistema Hermes: Forge & Potz

Para que qualquer equipe ou desenvolvedor possa replicar uma governança multi-agente de alto nível com o Hermes, disponibilizamos neste diretório os templates sanitizados dos dois agentes de fundação que orquestram a plataforma:

```
┌────────────────────────────────────────────────────────────────────────┐
│                      Liderança Técnica / Usuário                       │
└───────────────────┬────────────────────────────────┬───────────────────┘
                    │                                │
                    ▼                                ▼
       ┌────────────────────────┐       ┌────────────────────────┐
       │         POTZ           │       │         FORGE          │
       │  Head of Agent Res.    │◄─────►│   Platform Engineer    │
       │ (Arquiteta de Agentes) │       │ (SRE & Infraestrutura) │
       └────────────┬───────────┘       └────────────┬───────────┘
                    │                                │
                    │ Modela o SOUL.md e identidade  │ Provisiona .env, systemd,
                    │                                │ MCPs e tokens
                    ▼                                ▼
       ┌─────────────────────────────────────────────────────────┐
       │               Novos Agentes Especializados               │
       │       (Squads de Desenvolvimento, Produto, QA, DB)      │
       └─────────────────────────────────────────────────────────┘
```

---

## 🎭 Os Dois Papéis Fundamentais

### 1. [[05 - Anexos & Referências/Perfis Base/SOUL-Forge|Forge (Platform & Infrastructure Manager)]]
- **Missão:** Forjar a infraestrutura de suporte. Cuida de daemons `systemd`, proxies como OmniRoute, credenciais de API, permissões no sistema de arquivos, servidores MCP e conectividade.
- **Quando usar:** Sempre que precisar provisionar serviços de fundo, diagnosticar erros de rede, criar scripts de automação, timers ou configurar permissões.

### 2. [[05 - Anexos & Referências/Perfis Base/SOUL-Potz|Potz (Head of Agent Resources & Agent Architect)]]
- **Missão:** Projetar e batizar novos agentes. Conduz o discovery de requisitos, desenha o escopo cognitivo, define a persona e redige os arquivos `SOUL.md` de novos especialistas.
- **Quando usar:** Sempre que seu projeto ou organização precisar de um novo perfil de IA (ex: Dev Spring Boot, Dev React, DBA, QA Gatekeeper, Product Manager).

---

## 🚀 Como Aplicar na Prática

1. **Criar os Perfis no Hermes:**
   ```bash
   hermes profile create forge --clone-from default
   hermes profile create potz --clone-from default
   ```

2. **Aplicar os `SOUL.md`:**
   Copie os modelos deste diretório para as pastas locais:
   - Para o Forge: `~/.hermes/profiles/forge/SOUL.md`
   - Para a Potz: `~/.hermes/profiles/potz/SOUL.md`

3. **No Hermes Desktop:**
   - Crie uma Section chamada `Core Staff`.
   - Adicione o `@forge` e a `@potz` nela.
   - Abra um Group Chat ou use a ferramenta `message_agent` para vê-los cooperar no provisionamento de novos times!

---

## 🔗 Navegação
- [[05 - Anexos & Referências/Perfis Base/SOUL-Forge|Ver SOUL.md do Forge]]
- [[05 - Anexos & Referências/Perfis Base/SOUL-Potz|Ver SOUL.md da Potz]]
- [[00 - Index|Central de Navegação]]
