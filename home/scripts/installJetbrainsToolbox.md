# installJetbrainsToolbox.sh

Instala o JetBrains Toolbox App no Linux (x86_64) seguindo o processo oficial da JetBrains.

---

## Requisitos

- Linux x86_64
- `curl` ou acesso ao navegador para baixar o `.tar.gz`
- Permissões `sudo`

---

## Antes de executar

Baixe o arquivo `.tar.gz` do Toolbox em:

**[jetbrains.com/toolbox-app](https://www.jetbrains.com/toolbox-app/)**

Coloque o arquivo baixado na **mesma pasta** do script antes de executar.

---

## Como usar

```bash
chmod +x installJetbrainsToolbox.sh
bash installJetbrainsToolbox.sh
```

---

## Fluxo de instalação

1. Localiza o arquivo `jetbrains-toolbox-*.tar.gz` na pasta atual
2. Verifica se `libfuse2` está instalada — necessária no Ubuntu 22.04+ — e instala automaticamente se não estiver
3. Extrai o tarball em pasta temporária (`/tmp/jb-toolbox-$$`)
4. Localiza o binário dentro do tarball, independente da profundidade de subpastas
5. Copia os arquivos para `/opt/jetbrains-toolbox/`
6. Cria link simbólico em `/usr/local/bin/jetbrains-toolbox`
7. Remove os arquivos temporários
8. Inicia o Toolbox em background para criar as configurações iniciais e o atalho no menu de aplicativos

---

## Resultado

| Item | Caminho |
| --- | --- |
| Binário | `/opt/jetbrains-toolbox/jetbrains-toolbox` |
| Comando global | `jetbrains-toolbox` |
| Configurações | `~/.local/share/JetBrains/Toolbox/` |
| Atalho no menu | `~/.local/share/applications/` |

Após a instalação, o Toolbox pode ser iniciado de qualquer terminal:

```bash
jetbrains-toolbox
```

---

## Próximos passos

1. Faça login com sua conta JetBrains no Toolbox
2. Escolha os IDEs que deseja instalar (IntelliJ, PyCharm, WebStorm, etc.)
3. Para instalar uma versão específica: clique em `...` no produto → **Available versions**
