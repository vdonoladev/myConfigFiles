### Linux

```bash
git clone https://github.com/vdonoladev/myConfigFiles.git
cd myConfigFiles/scripts

chmod +x *.sh

# (Opcional) Acessar de qualquer lugar
mkdir -p ~/bin
for s in *.sh; do ln -sf "$PWD/$s" ~/bin/"${s%.sh}"; done
```

## Uso

### organizar-downloads

Organiza arquivos por extensao em subpastas categorizadas.

**Terminal:**
```bash
organizar-downloads              # organiza a pasta atual
organizar-downloads ~/Downloads  # organiza ~/Downloads
```

Categorias: Imagens, Documentos, Videos, Audio, Instaladores, Compactados, Codigo, Outros.

### scanner-espaco

Mostra os maiores arquivos e pastas, com resumo de disco.

**Terminal:**
```bash
scanner-espaco            # escaneia a pasta atual
scanner-espaco ~ 30       # top 30 em ~/
```

### cacar-duplicatas

Encontra duplicatas por SHA-256. Nenhum arquivo e deletado.

**Terminal:**
```bash
cacar-duplicatas                 # escaneia a pasta atual
cacar-duplicatas ~/Fotos 4096    # minimo 4 KB
```

Pre-filtra por tamanho antes de calcular hashes — rapido mesmo em pastas grandes. Ignora `node_modules`, `.venv`, `.git`, `__pycache__`.

### scanner-wifi

Escaneia redes proximas e recomenda o canal menos congestionado.

**Terminal:**
```bash
scanner-wifi
```

Mostra SSID, canal, sinal, seguranca e mapa de congestionamento por canal (2.4 GHz e 5 GHz).

### setup-workspace

Posiciona janelas automaticamente em multiplos monitores usando perfis.

**Terminal:**
```bash
setup-workspace              # menu interativo
setup-workspace padrao       # carrega o perfil "padrao"
setup-workspace --save work  # salva o layout atual como "work"
setup-workspace --detect     # lista monitores conectados
```

O menu interativo permite carregar um perfil existente ou capturar o layout atual das janelas. A captura detecta automaticamente em qual monitor cada janela esta e calcula as posicoes em porcentagem.

**Config:** `~/.config/workspace-profiles.conf`

```ini
# Mapeamento de monitores
monitor.1=LU28R55
monitor.2=LG HDR 4K
monitor.3=Built-in Retina

# perfil|App|monitor|posicao
padrao|Google Chrome|1|left
padrao|Obsidian|1|right
padrao|Discord|3|full
```

Posicoes: `left`, `right`, `full`, `top`, `bottom`, `top-left`, `top-right`, `bottom-left`, `bottom-right` ou customizada em porcentagem (`x,y,largura,altura`).
