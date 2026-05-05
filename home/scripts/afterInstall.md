# afterInstall.sh

Script de pós-instalação para sistemas baseados em Debian/Ubuntu. Automatiza toda a configuração inicial após uma instalação limpa: atualiza o sistema, instala programas por diferentes métodos e gera um log completo da execução.

---

## Requisitos

- Sistema baseado em Debian/Ubuntu (Pop!_OS, Linux Mint, etc.)
- Conexão com a internet
- Usuário com permissões `sudo`

---

## Como usar

```bash
chmod +x afterInstall.sh
./afterInstall.sh
```

> Não execute com `sudo`. O script solicita permissões quando necessário.

---

## Fluxo de execução

1. Verifica que não está rodando como root
2. Testa a conexão com a internet (`ping 8.8.8.8`)
3. Remove locks do APT e atualiza o sistema (`apt update && apt dist-upgrade`)
4. Instala e configura o **Snapd**
5. Baixa e instala os pacotes `.deb` externos
6. Instala pacotes via **APT**
7. Instala apps via **Flatpak** (adiciona o Flathub automaticamente se necessário)
8. Instala apps via **Snap**
9. Instala o **Tailscale** via script oficial
10. Instala o **Zed Editor** via script oficial
11. Executa limpeza final (`autoclean`, `autoremove`, atualiza Flatpak e Snap)
12. Exibe resumo com status de cada instalação

---

## O que instala

### Pacotes `.deb` (download direto)

| Aplicativo | Descrição |
| --- | --- |
| 1Password | Gerenciador de senhas |
| DBeaver CE | Cliente universal de banco de dados |
| Ente Auth | Autenticador 2FA de código aberto |
| OnlyOffice Desktop | Suite de escritório |
| Upscayl | Upscaling de imagens com IA |
| VeraCrypt | Criptografia de disco |

### APT

| Pacote | Descrição |
| --- | --- |
| `wget` | Download de arquivos via terminal |
| `curl` | Transferência de dados via URL |
| `git` | Controle de versão |
| `flatpak` | Gerenciador de pacotes Flatpak |
| `snapd` | Gerenciador de pacotes Snap |
| `ubuntu-restricted-extras` | Codecs multimídia e fontes proprietárias |
| `fastfetch` | Exibição de informações do sistema |
| `code` | Visual Studio Code |

### Flatpak

| Aplicativo | Descrição |
| --- | --- |
| Bazaar | Loja de apps alternativa |
| Bitwarden | Gerenciador de senhas |
| Brief | Leitor de RSS |
| Discord | Comunicação por voz, vídeo e texto |
| Extension Manager | Gerenciador de extensões do GNOME |
| Gear Lever | Gerenciador de AppImages |
| Gradia | Editor de capturas de tela |
| KeePassXC | Gerenciador de senhas offline |
| LocalSend | Transferência de arquivos na rede local |
| Mission Center | Monitor do sistema |
| Muon | Cliente SSH e SFTP |
| Planify | Gerenciador de tarefas |
| Postman | Plataforma para testes de API |
| Progress | Rastreador de progresso pessoal |
| Spotify | Streaming de música |
| Startup Configuration | Gerencia apps de inicialização |
| Converter | Conversor de unidades e arquivos |
| Telegram | Mensageiro |
| Warehouse | Gerenciador visual de apps Flatpak |
| ZapZap | Cliente desktop do WhatsApp |

### Snap

| Aplicativo | Descrição |
| --- | --- |
| VLC | Player de mídia universal |

### Scripts oficiais

| Aplicativo | Descrição |
| --- | --- |
| Tailscale | VPN mesh baseada em WireGuard |
| Zed Editor | Editor de código rápido e moderno |

---

## Como adicionar novos programas

Edite os arrays no topo do script. Cada seção está claramente identificada com comentários.

```bash
# Novo pacote .deb externo
URL_MEU_APP="https://exemplo.com/meu-app.deb"
DEB_URLS+=("$URL_MEU_APP")

# Novo pacote APT
PROGRAMS_APT+=("nome-do-pacote")

# Novo app Flatpak
PROGRAMS_FLATPAK+=("com.exemplo.App|Nome Amigável")

# Novo app Snap (flags: --classic, --beta, --edge ou deixe vazio)
PROGRAMS_SNAP+=("nome-do-snap|--classic|Nome Amigável")
```

---

## Log

Um arquivo de log completo é salvo automaticamente em:

```
~/afterInstall_YYYYMMDD_HHMMSS.log
```

O log registra cada etapa da instalação, incluindo downloads, instalações e erros. O caminho exato é exibido no resumo final.
