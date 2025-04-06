<h1 align="center" style="font-weight: bold;">myConfigFiles</h1>

<p align="center">
  <a href="#tech">Tecnologias</a> • 
  <a href="#about">Sobre</a> •
  <a href="#started">Começando</a> • 
  <a href="#structure">Estrutura</a> • 
  <a href="#description">Descrição</a>
</p>

<p align="center">
    <b>Repositório pessoal com meus arquivos de configuração no Linux (Pop!_OS)</b>
</p>

<h2 id="tech">Tecnologias</h2>

- [Bash Script](https://devdocs.io/bash)
  - Todos os arquivos são escritos em **Shell Script (bash)**, seguindo o padrão dos arquivos de configuração que o próprio sistema usa. A ideia é manter tudo simples, leve e fácil de replicar.

<h2 id="about">Sobre</h2>

<p>Este repositório contém meus arquivos de configuração utilizados no <b>Pop!_OS</b>, a distribuição Linux baseada em Ubuntu desenvolvida pela <b>System76</b>. Ele serve tanto como backup quanto como referência para quem estiver interessado em personalizar seu ambiente Linux.</p>

<p>Ao longo do tempo, fui ajustando meu sistema para deixá-lo do meu jeito -- mais produtivo, limpo e funcional. Neste repositório, você encontrará:</p>

- Arquivos de configuração de terminal (como `.bashrc`, `.profile`, etc)
- Alias personalizados e funções para o shell
- Configurações do ambiente gráfico
- Outros scripts úteis que uso no dia a dia

<p>O foco principal está na <b>linha de comando</b>, com ajustes voltados para desenvolvedores e usuários mais avançados de Linux.</p>

<h2 id="started">Começando</h2>

1. **Clone este repositório:**

```bash
git clone https://github.com/vdonoladev/myConfigFiles.git
```

2. **Navegue até o diretório do projeto:**

```bash
cd myConfigFiles
```

3. **Copie os arquivos desejados para o seu diretório home:**

```bash
cp .bashrc ~/.bashrc
```

- ou edite manualmente conforme necessário

⚠️ **Importante:** sempre faça backup dos seus arquivos antes de sobrescrevê-los!

<h2 id="structure">Estrutura</h2>

<p>A estrutura do repositório foi pensada para ser o mais próxima possível da organização real do sistema. Os aquivos estão organizados a partir da pasta `Home`, representando o diretório pessoal do usuário (`~`). Ou seja:</p>

- Todos os arquivos de configuração localizados diretamente na `Home` estarão dentro da pasta `home`.
- Caso algum arquivo pertença a uma subpasta específica (como `.config`, `.local`, etc.), ele será mantido dentro da mesma hierarquia. <b>Exemplo:</b>

  - `home/.bashrc`
  - `home/.profile`
  - `home/.config/Code/User/settings.json`

- Isso permite que você entenda exatamente onde cada arquivo deve ser colocado no seu sistema.

```text
myConfigFiles/
└── home/
    ├── .bash_aliases
    ├── .gitconfig
    ├── .config/
    │   └── Code/
    │       └── User/
    │           └── settings.json
    └── scripts/
        ├── afterInstall.sh
```

<h2 id="description">Descrição</h2>

<h3>.bash_aliases</h3>

- Arquivo responsável por <b>armazenar atalhos de comandos</b> usados no terminal, facilitando e agilizando tarefas do dia a dia.

<h3>afterInstall.sh</h3>

- Um script automatizado de <b>pós-instalação</b> para sistemas baseados em Debian/Ubuntu, como o <b>Pop!\_OS</b>. Ele realiza uma série de tarefas para configurar o sistema rapidamente após uma instalação limpa.

<h3>settings.json</h3>

- Este arquivo define uma configuração enxuta, rápida e sem distrações para o Visual Studio Code.

<h3>.gitconfig</h3>

- Arquivo de configuração global do Git para identidade, editor padrão e comportamento visual.
