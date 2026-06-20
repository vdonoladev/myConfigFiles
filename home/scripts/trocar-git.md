# 🔄 Git Profile Switcher (Shell Script)

Este é um script em Shell Bash simples e eficiente para desenvolvedores Linux (como usuários de Zorin OS, Ubuntu, Mint, etc.) que precisam alternar rapidamente entre diferentes perfis do Git (ex: **Pessoal** e **Trabalho**).

O script atualiza automaticamente as configurações `--global` do Git (`user.name` e `user.email`), exibindo o perfil ativo antes e depois da alteração.

## 🚀 Funcionalidades

- **Visualização Rápida:** Mostra o `user.name` e `user.email` atualmente ativos no sistema.
- **Menu Interativo:** Permite escolher qual perfil ativar com apenas um dígito.
- **Segurança:** Opção de saída sem alterações caso o script seja aberto por engano.
- **Flexibilidade:** Evita que você faça commits de trabalho na sua conta pessoal (ou vice-versa).

## 🛠️ Como Configurar

1. **Baixe ou Crie o Arquivo**
   Abra o terminal na pasta onde deseja salvar o script e crie o arquivo:
   ```bash
   nano trocar_git.sh
    ```

2. **Cole e Edite o Código**
Cole o código do script dentro do arquivo. Lembre-se de alterar as variáveis no início do arquivo com os seus dados reais:
```bash
NOME_PESSOAL="Seu Nome Pessoal"
EMAIL_PESSOAL="seu_email@pessoal.com"

NOME_TRABALHO="Seu Nome da Empresa"
EMAIL_TRABALHO="seu_email@empresa.com"
```

Salve o arquivo pressionando `Ctrl + O`, depois `Enter`, e saia com `Ctrl + X`.
3. **Dê Permissão de Execução**
Por padrão, novos arquivos `.sh` não rodam como programas no Linux. Para liberar a execução, rode:
```bash
chmod +x trocar_git.sh
```

## 🏃 Modos de Rodar

Você pode executar este script de três formas diferentes, dependendo de como prefere organizar seu fluxo de trabalho:

### Modo 1: Execução Direta (Local)

Se o script estiver na mesma pasta em que você está com o terminal aberto, basta rodar:

```bash
./trocar_git.sh
```

### Modo 2: Executando de qualquer lugar do sistema (Recomendado)

Para não precisar copiar o script para todas as pastas ou digitar o caminho completo, você pode movê-lo para a pasta de binários locais do sistema. Isso transforma o script em um comando global:

```bash
sudo mv trocar_git.sh /usr/local/bin/trocar-git
```

Agora, basta abrir **qualquer terminal** em **qualquer pasta** e digitar apenas:

```bash
trocar-git
```

### Modo 3: Criando um Atalho (Alias)

Se preferir manter o script em uma pasta específica (como `~/scripts/`), você pode criar um atalho no seu arquivo de configuração do terminal (`.bashrc` ou `.zshrc`):

1. Abra o arquivo de configuração:
```bash
nano ~/.bashrc
```

2. Adicione a seguinte linha no final do arquivo (ajustando o caminho):
```bash
alias gitswitch="~/caminho/para/seu/script/trocar_git.sh"
```

3. Atualize o terminal:
```bash
source ~/.bashrc
```

4. Agora você pode rodar o script digitando apenas `gitswitch`.

## 📦 Dependências

O script utiliza apenas ferramentas nativas do sistema Bash:

* `git` (instalado e configurado na sua máquina)
* `bash`

## 📄 Licença

Este projeto é de uso livre. Sinta-se à vontade para clonar, modificar e adaptar para quantos perfis de Git você precisar!
