# setup-workspace.sh

Gerenciador de layout multi-monitor para Linux. Posiciona janelas automaticamente em monitores específicos usando perfis salvos em arquivo de configuração.

---

## Requisitos

```bash
sudo apt install wmctrl xdotool x11-xserver-utils
```

| Dependência | Uso |
| --- | --- |
| `wmctrl` | Mover e redimensionar janelas |
| `xdotool` | Identificar janelas por nome |
| `xrandr` | Detectar monitores conectados e suas resoluções |

---

## Como usar

```bash
chmod +x setup-workspace.sh
```

```bash
./setup-workspace.sh                   # Abre o menu interativo
./setup-workspace.sh <perfil>          # Carrega um perfil diretamente
./setup-workspace.sh --save <nome>     # Salva o layout atual como perfil
./setup-workspace.sh --detect          # Lista os monitores conectados
./setup-workspace.sh --init            # Cria o arquivo de configuração padrão
```

### Comandos

| Comando | Descrição |
| --- | --- |
| *(sem argumentos)* | Abre o menu interativo |
| `<nome-do-perfil>` | Carrega e aplica o perfil informado |
| `--save <nome>` | Captura o layout atual das janelas e salva como perfil |
| `--detect` | Lista os monitores conectados com nome, resolução e posição |
| `--init` | Cria o arquivo `~/.config/workspace-profiles.conf` com um exemplo |

---

## Arquivo de configuração

**Localização:** `~/.config/workspace-profiles.conf`

> Use `--detect` para descobrir os nomes exatos dos seus monitores antes de configurar.

```ini
# Mapeamento de monitores
monitor.1=HDMI-1
monitor.2=DP-1

# Formato: perfil|Nome da Janela|número do monitor|posição
trabalho|Google Chrome|1|left
trabalho|Zed|1|right
trabalho|Discord|2|full
trabalho|Spotify|2|bottom-right
```

- O **nome da janela** é o título que aparece na barra de título ou no `wmctrl -l`. Correspondência parcial é suficiente.
- O **número do monitor** corresponde ao mapeamento definido nas linhas `monitor.N`.
- Múltiplos perfis podem coexistir no mesmo arquivo.

---

## Posições disponíveis

| Posição | Descrição |
| --- | --- |
| `full` | Tela cheia no monitor |
| `left` | Metade esquerda |
| `right` | Metade direita |
| `top` | Metade superior |
| `bottom` | Metade inferior |
| `top-left` | Quadrante superior esquerdo |
| `top-right` | Quadrante superior direito |
| `bottom-left` | Quadrante inferior esquerdo |
| `bottom-right` | Quadrante inferior direito |
| `x%,y%,w%,h%` | Posição e tamanho customizados em porcentagem da área do monitor |

---

## Menu interativo

Ao executar sem argumentos, o script exibe um menu com duas opções:

**1. Carregar perfil**
Lista os perfis disponíveis no arquivo de configuração e aplica o escolhido. Cada janela configurada é movida e redimensionada automaticamente.

**2. Capturar layout atual**
Detecta em qual monitor cada janela aberta está posicionada, calcula as coordenadas em porcentagem e salva como um novo perfil. Processos de sistema (como `gnome-shell`, `nautilus-desktop`, etc.) são ignorados automaticamente.

---

## Variável de ambiente

O caminho do arquivo de configuração pode ser sobrescrito:

```bash
WORKSPACE_CONFIG=~/.meu-config.conf ./setup-workspace.sh
```
