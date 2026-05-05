# myConfigFiles

Dotfiles e scripts utilitários para Linux — testado no Pop!_OS e Ubuntu.

---

## Estrutura

```text
myConfigFiles/
└── home/
    ├── .bash_aliases
    ├── .bashrc
    ├── .gitconfig
    ├── .config/
    │   ├── Code/User/settings.json
    │   └── zed/settings.json
    └── scripts/
        ├── README.md
        ├── afterInstall.sh
        ├── cacar-duplicatas.sh
        ├── installJetbrainsToolbox.sh
        ├── organizar-downloads.sh
        ├── scanner-espaco.sh
        ├── scanner-wifi.sh
        └── setup-workspace.sh
```

A pasta `home/` espelha o diretório pessoal (`~`). Cada arquivo deve ser copiado para o mesmo caminho relativo na sua máquina.

---

## Começando

```bash
git clone https://github.com/vdonoladev/myConfigFiles.git
cd myConfigFiles
```

> Faça backup dos seus arquivos originais antes de substituir qualquer coisa.

---

## Dotfiles

### `.bashrc`

Configuração principal do Bash: histórico com timestamp, prompt de duas linhas com branch Git, autocomplete aprimorado e carregamento automático de NVM, Cargo, Homebrew e Angular CLI.

Inclui funções como `mkcd`, `extract`, `backup`, `search`, `serve`, `sysinfo`, `memtop`, `cputop` e outras. Veja [.bashrc.md](home/.bashrc.md) para a documentação completa das funções.

```bash
cp home/.bashrc ~/.bashrc
source ~/.bashrc
```

### `.bash_aliases`

Aliases organizados por categoria: atualizações do sistema (`update-all`), rede (`myip`, `speedtest`), comandos aprimorados (`cat` → `batcat`, `ls` → `exa`, `find` → `fd`), Git (`gadd`, `gcom`, `gpush`...) e Docker (`dps`, `dpa`, `dstop`).

```bash
cp home/.bash_aliases ~/.bash_aliases
```

### `.gitconfig`

Configuração global do Git com `delta` como pager, `rebase` no pull, `autoSetupRemote`, `prune` automático no fetch, algoritmo `histogram` para diffs e aliases úteis (`git lg`, `git undo`, `git wip`, `git br`...).

> Requer `git-delta`: `sudo apt install git-delta`

```bash
cp home/.gitconfig ~/.gitconfig
```

### Editores

```bash
# VS Code
cp home/.config/Code/User/settings.json ~/.config/Code/User/settings.json

# Zed
cp home/.config/zed/settings.json ~/.config/zed/settings.json
```

---

## Scripts

Documentação individual de cada script em [home/scripts/README.md](home/scripts/README.md).

| Script | Descrição |
| --- | --- |
| [`afterInstall.sh`](home/scripts/afterInstall.md) | Pós-instalação: instala todos os programas e configura o sistema do zero |
| [`cacar-duplicatas.sh`](home/scripts/cacar-duplicatas.md) | Encontra arquivos duplicados por SHA-256, sem deletar nada |
| [`installJetbrainsToolbox.sh`](home/scripts/installJetbrainsToolbox.md) | Instala o JetBrains Toolbox no Linux |
| [`organizar-downloads.sh`](home/scripts/organizar-downloads.md) | Organiza arquivos em subpastas por tipo de extensão |
| [`scanner-espaco.sh`](home/scripts/scanner-espaco.md) | Exibe as maiores pastas e arquivos, com resumo do disco |
| [`scanner-wifi.sh`](home/scripts/scanner-wifi.md) | Escaneia redes Wi-Fi e recomenda o canal menos congestionado |
| [`setup-workspace.sh`](home/scripts/setup-workspace.md) | Gerencia layout multi-monitor com perfis de configuração |

### Instalação rápida

```bash
chmod +x home/scripts/*.sh

# Para acessar de qualquer lugar no terminal
mkdir -p ~/bin
for s in home/scripts/*.sh; do
  ln -sf "$PWD/$s" ~/bin/"$(basename "${s%.sh}")"
done
source ~/.bashrc
```

---

## Licença

MIT — veja o arquivo [LICENSE](LICENSE).
