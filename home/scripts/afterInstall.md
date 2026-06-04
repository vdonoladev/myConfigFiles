# afterInstall.sh

**Versão 2.0.0** — Script de pós-instalação para sistemas baseados em Debian/Ubuntu. Automatiza toda a configuração inicial após uma instalação limpa: detecta o sistema, verifica pré-requisitos, instala programas por diferentes métodos e gera um log completo da execução.

---

## Requisitos

- Sistema baseado em Debian/Ubuntu (Pop!\_OS, Linux Mint, Elementary OS, Zorin OS, etc.)
- Conexão com a internet
- Usuário com permissões `sudo`
- Pelo menos **5 GB** de espaço disponível em disco (recomendado)

---

## Como usar

```bash
chmod +x afterInstall.sh
./afterInstall.sh [opções]
```

> Não execute com `sudo`. O script solicita permissões quando necessário.

### Opções disponíveis

| Opção            | Descrição                                    |
| ---------------- | -------------------------------------------- |
| `-h, --help`     | Exibe a mensagem de ajuda                    |
| `-V, --version`  | Exibe a versão do script                     |
| `--dry-run`      | Simula toda a execução sem instalar nada     |
| `--skip-apt`     | Ignora instalações via APT                   |
| `--skip-flatpak` | Ignora instalações via Flatpak               |
| `--skip-snap`    | Ignora instalações via Snap                  |
| `--skip-debs`    | Ignora download e instalação de pacotes .deb |
| `--skip-extras`  | Ignora Tailscale, Zed Editor e NVM           |

### Exemplos

```bash
# Execução completa
./afterInstall.sh

# Simular sem instalar nada (útil para testar)
./afterInstall.sh --dry-run

# Ignorar Snap e Flatpak, instalar apenas APT e .deb
./afterInstall.sh --skip-snap --skip-flatpak
```

---

## Fluxo de execução

1. Verifica que não está rodando como root
2. Verifica lock file (impede execuções concorrentes)
3. Detecta a distribuição Linux (distro, kernel, arquitetura)
4. Verifica espaço disponível em disco
5. Testa conexão com a internet (tenta `8.8.8.8`, `1.1.1.1` e `9.9.9.9`)
6. Valida e renova permissões `sudo` (mantém o token ativo em background)
7. Exibe resumo das etapas e pede confirmação
8. Remove locks do APT e atualiza o sistema (`apt update && apt dist-upgrade`)
9. Instala e configura o **Snapd**
10. Baixa e instala os pacotes `.deb` externos (com retry automático)
11. Instala pacotes via **APT**
12. Instala apps via **Flatpak** (adiciona o Flathub automaticamente)
13. Instala apps via **Snap**
14. Instala o **Tailscale** via script oficial
15. Instala o **Zed Editor** via script oficial
16. Instala o **NVM** (Node Version Manager)
17. Executa limpeza final (`autoclean`, `autoremove`, atualiza Flatpak e Snap)
18. Exibe resumo com contadores de instalados, pulados, falhas e tempo total

---

## O que instala

### Pacotes `.deb` (download direto)

| Aplicativo          | Descrição                           |
| ------------------- | ----------------------------------- |
| DBeaver CE          | Cliente universal de banco de dados |
| Ente Auth           | Autenticador 2FA de código aberto   |
| OnlyOffice          | Suíte Office                        |
| VeraCrypt           | Criptografia de disco               |
| Visual Studio Code  | Editor de código da Microsoft       |

### APT

| Pacote                     | Descrição                                |
| -------------------------- | ---------------------------------------- |
| `curl`                     | Transferência de dados via URL           |
| `fastfetch`                | Exibição de informações do sistema       |
| `flatpak`                  | Gerenciador de pacotes Flatpak           |
| `git`                      | Controle de versão                       |
| `snapd`                    | Gerenciador de pacotes Snap              |
| `ubuntu-restricted-extras` | Codecs multimídia e fontes proprietárias |
| `wget`                     | Download de arquivos via terminal        |

### Flatpak

| Aplicativo            | Descrição                               |
| --------------------- | --------------------------------------- |
| Bazaar                | Loja de apps alternativa                |
| Brief                 | Leitor de RSS                           |
| Switcheroo Converter  | Conversor de unidades e arquivos        |
| Discord               | Comunicação por voz, vídeo e texto      |
| Extension Manager     | Gerenciador de extensões do GNOME       |
| Gear Lever            | Gerenciador de AppImages                |
| Gradia                | Editor de capturas de tela              |
| LocalSend             | Transferência de arquivos na rede local |
| Mission Center        | Monitor do sistema                      |
| Postman               | Plataforma para testes de API           |
| Startup Configuration | Gerencia apps de inicialização          |
| Telegram              | Mensageiro                              |
| Warehouse             | Gerenciador visual de apps Flatpak      |
| ZapZap                | Cliente desktop do WhatsApp             |

### Snap

| Aplicativo | Descrição                 |
| ---------- | ------------------------- |
| VLC        | Player de mídia universal |

### Scripts e instaladores oficiais

| Ferramenta | Descrição                                    |
| ---------- | -------------------------------------------- |
| Tailscale  | VPN mesh baseada em WireGuard                |
| Zed Editor | Editor de código rápido e moderno            |
| NVM        | Gerenciador de versões do Node.js (v0.40.3)  |

---

## Como adicionar novos programas

Edite os arrays no início do script. Cada seção está identificada com comentários e segue um formato `"id|Nome Exibido"`.

```bash
# Novo pacote .deb externo
# Formato: "nome_arquivo.deb|URL_DE_DOWNLOAD|Nome Exibido"
DEB_PACKAGES+=("meu-app.deb|https://exemplo.com/meu-app.deb|Meu App")

# Novo pacote APT
# Formato: "pacote|Nome Exibido"
PROGRAMS_APT+=("nome-do-pacote|Nome do Pacote")

# Novo app Flatpak
# Formato: "app.id|Nome Exibido"
PROGRAMS_FLATPAK+=("com.exemplo.App|Nome Amigável")

# Novo app Snap (flags opcionais: --classic, --beta, --edge)
# Formato: "id|Nome Exibido" ou "id|Nome Exibido|--flags"
PROGRAMS_SNAP+=("nome-do-snap|Nome Amigável|--classic")
```

---

## Log

O log completo é salvo automaticamente em:

```
~/.logs/afterinstall/afterInstall_YYYYMMDD_HHMMSS.log
```

O arquivo contém o registro de cada etapa — downloads, instalações e erros — sem códigos de cor ANSI, facilitando a leitura. O caminho exato é exibido no cabeçalho e no resumo final.

---

## Resumo final

Ao concluir, o script exibe um painel com:

- **Instalados com sucesso** — quantidade de pacotes novos instalados
- **Já instalados (pulados)** — pacotes que já estavam presentes no sistema
- **Falhas** — quantidade e lista detalhada de erros ocorridos
- **Tempo de execução** — duração total do script
