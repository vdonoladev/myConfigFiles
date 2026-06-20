#!/bin/bash

# Configurações dos seus usuários (Substitua com os seus dados reais)
NOME_PESSOAL="Seu Nome Pessoal"
EMAIL_PESSOAL="seu_email_pessoal@gmail.com"

NOME_TRABALHO="Seu Nome de Trabalho"
EMAIL_TRABALHO="seu_email_trabalho@empresa.com"

exibir_usuario_atual() {
    echo "-----------------------------------------------------------"
    echo "---------------------- USUÁRIO ATUAL ----------------------"
    echo "-----------------------------------------------------------"
    echo "Nome:  $(git config --global user.name)"
    echo "Email: $(git config --global user.email)"
    echo "-----------------------------------------------------------"
    echo ""
}

# Limpa a tela e mostra o usuário antes da troca
clear
exibir_usuario_atual

echo "Digite o usuário Git que você quer logar:"
echo "[1] Logar em Pessoal"
echo "[2] Logar em Trabalho"
echo "[3] Sair sem alterar"
echo ""
read -p "Digite a opção: " opcao
echo ""

case $opcao in
    1)
        git config --global user.name "$NOME_PESSOAL"
        git config --global user.email "$EMAIL_PESSOAL"
        ;;
    2)
        git config --global user.name "$NOME_TRABALHO"
        git config --global user.email "$EMAIL_TRABALHO"
        ;;
    3)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida!"
        exit 1
        ;;
esac

# Limpa a tela e mostra o resultado final
clear
exibir_usuario_atual
echo "Usuário alterado com sucesso!"
echo ""
read -n 1 -s -r -p "Pressione qualquer tecla para sair..."
echo ""