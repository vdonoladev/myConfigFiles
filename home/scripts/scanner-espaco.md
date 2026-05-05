# scanner-espaco.sh

Analisa o uso de espaço em disco de um diretório, exibindo as maiores pastas e os maiores arquivos com tamanhos coloridos e um resumo geral da partição.

---

## Como usar

```bash
chmod +x scanner-espaco.sh
```

```bash
./scanner-espaco.sh                    # Escaneia ~, exibe top 20
./scanner-espaco.sh /var/log           # Pasta específica
./scanner-espaco.sh ~ 30               # Define quantos itens exibir
```

### Parâmetros

| Parâmetro | Padrão | Descrição |
| --- | --- | --- |
| `[pasta]` | `~` | Diretório a ser analisado |
| `[quantidade]` | `20` | Número de itens exibidos no top de pastas e arquivos |

---

## O que é exibido

**Maiores pastas**
- Profundidade 1 a partir do diretório alvo
- Ordenadas por tamanho, da maior para a menor

**Maiores arquivos**
- Busca recursiva até 4 níveis de profundidade
- Dotfiles são ignorados
- Ordenados por tamanho, do maior para o menor

**Resumo do disco**
- Espaço usado, total e percentual de uso da partição onde o diretório está montado

---

## Cores nos tamanhos

| Cor | Faixa de tamanho |
| --- | --- |
| Normal (sem cor) | Abaixo de 1 GB |
| Amarelo | Entre 1 GB e 5 GB |
| Vermelho | Acima de 5 GB |
