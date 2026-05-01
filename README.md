## 🚀 myConfigFiles

<p align="center">
<a href="#about">Sobre</a> •
<a href="#tech">Tecnologias</a> •
<a href="#started">Começando</a> •
<a href="#structure">Estrutura de Arquivos</a> •
<a href="#config-details">Detalhes das Configurações</a> •
<a href="#apps-installed">Aplicações Instaladas</a>
</p>

<p align="center">
<b>Repositório pessoal com meus arquivos de configuração do ambiente Linux (Pop!_OS)</b>
</p>

---

## 🎯 Sobre

Este repositório contém meus arquivos de **configuração** (`dotfiles`) utilizados no **Pop\!\_OS**, a distribuição Linux baseada em Ubuntu desenvolvida pela System76.

Ele serve como um **backup** pessoal e como **referência** para quem estiver interessado em personalizar seu ambiente Linux. O foco principal está na **linha de comando**, com ajustes voltados para **desenvolvedores** e usuários mais avançados.

Ao longo do tempo, ajustei meu sistema para torná-lo mais **produtivo, limpo e funcional**. Aqui você encontrará:

- Arquivos de configuração de **terminal** (como `.bashrc`, `.profile`, etc.)
- **Alias** personalizados e **funções** para o shell.
- Outros **scripts** úteis que uso no dia a dia.
- Configurações específicas para alguns editores de código e ferramentas.

---

## 💻 Tecnologias

- **Bash Script**
  - Todos os arquivos principais são escritos em **Shell Script (Bash)**, seguindo o padrão de arquivos de configuração que o próprio sistema usa. A ideia é manter tudo **simples, leve e fácil de replicar**.

---

## ⚙️ Começando

Siga os passos abaixo para começar a usar (ou referenciar) estas configurações em seu sistema.

1.  **Clone este repositório:**

    ```bash
    git clone https://github.com/vdonoladev/myConfigFiles.git
    ```

2.  **Navegue até o diretório do projeto:**

    ```bash
    cd myConfigFiles
    ```

3.  **Copie os arquivos desejados para o seu diretório _home_ (`~`):**

    ```bash
    # Exemplo: Copiando o .bashrc da pasta 'home' para a sua pasta pessoal
    cp home/.bashrc ~/.bashrc
    ```

    ⚠️ **Importante:** Sempre faça **backup** dos seus arquivos de configuração originais antes de sobrescrevê-los\!

---

## 📂 Estrutura de Arquivos

A estrutura do repositório foi pensada para ser o mais próxima possível da organização real do sistema, com a pasta `home` representando o diretório pessoal do usuário (`~`).

Isso permite que você entenda exatamente onde cada arquivo deve ser colocado.

```text
myConfigFiles/
└── home/
    ├── .bash_aliases      # Configurações de atalhos do terminal
    ├── .bashrc            # Configurações do shell bash
    ├── .gitconfig         # Configurações globais do Git
    ├── .config/
    │   └── Code/
    │       └── User/
    │           └── settings.json        # Configurações do VS Code
    |   └── zed
    |       └── settings.json            # Configurações do Zed
    └── scripts/
        └── afterInstall.sh              # Script de pós-instalação
        └── installJetbrainsToolbox.sh   # Script de instalação do Jetbrains-Toolbox
```

---

## 📝 Detalhes das Configurações

### Arquivos Principais

- **`.bash_aliases`**
  - Arquivo responsável por armazenar **atalhos de comandos** (_aliases_) usados no terminal, facilitando e agilizando tarefas do dia a dia.
- **`.bashrc`**
  - Arquivo de configuração principal do shell Bash. Ele carrega o `.bash_aliases` e define o comportamento do terminal, como o _prompt_ e as **funções personalizadas**.
- **`.gitconfig`**
  - Arquivo de configuração global do **Git** para identidade, editor padrão e comportamento visual.
- **`settings.json`**
  - Configurações do **Visual Studio Code** para um ambiente enxuto, rápido e sem distrações.

### Scripts Úteis

- **`afterInstall.sh`**
  - Um script automatizado de **pós-instalação** para sistemas baseados em Debian/Ubuntu, como o **Pop\!\_OS**. Ele realiza uma série de tarefas para configurar o sistema rapidamente após uma instalação limpa.

### 🌟 Funções Personalizadas no `.bashrc`

As seguintes funções foram adicionadas ao `.bashrc` para maior produtividade:

| Comando               | Descrição                                                         |
| :-------------------- | :---------------------------------------------------------------- |
| `mkcd nome_pasta`     | Cria uma pasta e entra nela.                                      |
| `extract arquivo.zip` | Extrai **qualquer** arquivo compactado (suporta vários formatos). |
| `search "texto"`      | Busca texto em arquivos dentro do diretório atual.                |
| `topcommands`         | Mostra seus 10 comandos mais usados.                              |
| `backup arquivo.txt`  | Cria backup de um arquivo com _timestamp_.                        |
| `dirsize`             | Mostra o tamanho das pastas no diretório atual.                   |
| `serve`               | Inicia um servidor HTTP local simples.                            |
| `memtop`              | Mostra os Top 10 processos por consumo de memória.                |
| `cputop`              | Mostra os Top 10 processos por consumo de CPU.                    |
| `sysinfo`             | Exibe um resumo das informações do sistema.                       |

---

## 📦 Aplicações Instaladas

Uma lista das principais aplicações e extensões que eu utilizo:

### 🖥️ Aplicações

| Tipo de Instalação | Pacotes                                                          |
| :----------------- | :--------------------------------------------------------------- |
| **.deb**           | Google Chrome, Ente Auth                                         |
| **apt**            | wget, flatpak, curl, ubuntu-restricted-extras, neofetch, code    |
| **flatpak**        | BitWarden, Telegram, LocalSend, WareHouse, Discord, VLC, Spotify |
| **snap**           | Jetbrains Rider, Jetbrains PHPStorm                              |

### 🌐 Extensões de Navegador (Google Chrome)

- [1Password – Password Manager](https://chromewebstore.google.com/detail/1password-%E2%80%93-password-mana/aeblfdkhhhdcdjpifhhbdiojplfjncoa)
- [Chrome Remote Desktop](https://chromewebstore.google.com/detail/chrome-remote-desktop/inomeogfingihgjfjlpeplalcfajhgai)
- [Integração com GNOME Shell](https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep)
- [Documentos Google off-line](https://chromewebstore.google.com/detail/documentos-google-off-lin/ghbmnnjooekpmoecnnnilnnbdlolhkhi)
- [Inoreader: Read-later and RSS extension](https://chromewebstore.google.com/detail/inoreader-read-later-and/kfimphpokifbjgmjflanmfeppcjimgah)
- [Notion Web Clipper](https://chromewebstore.google.com/detail/notion-web-clipper/knheggckgoiihginacbkhaalnibhilkk)
