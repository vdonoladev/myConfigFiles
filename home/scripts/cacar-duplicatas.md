# cacar-duplicatas.sh

Encontra arquivos com conteúdo idêntico usando hash SHA-256. Nenhum arquivo é deletado — tudo é apenas listado para revisão manual.

---

## Requisitos

- `sha256sum` (disponível por padrão no Linux)
- `bc` para cálculo de tamanhos (disponível por padrão na maioria das distros)

---

## Como usar

```bash
chmod +x cacar-duplicatas.sh
```

```bash
./cacar-duplicatas.sh                  # Pasta atual, mínimo 1 KB
./cacar-duplicatas.sh ~/Fotos          # Pasta específica
./cacar-duplicatas.sh ~/Fotos 4096     # Pasta específica com tamanho mínimo em bytes
```

### Parâmetros

| Parâmetro | Padrão | Descrição |
| --- | --- | --- |
| `[pasta]` | `.` (pasta atual) | Diretório a ser escaneado |
| `[tamanho-mínimo]` | `1024` (1 KB) | Tamanho mínimo em bytes para considerar o arquivo |

---

## Como funciona

O script usa uma estratégia em dois passos para ser eficiente mesmo em pastas grandes:

1. **Listagem:** Varre o diretório e lista todos os arquivos acima do tamanho mínimo
2. **Pré-filtro por tamanho:** Agrupa os arquivos por tamanho — apenas arquivos com o mesmo tamanho podem ser duplicatas, então o hash é calculado apenas nesses candidatos
3. **Hash SHA-256:** Calcula o hash de cada candidato
4. **Identificação:** Agrupa os arquivos com hash idêntico
5. **Exibição:** Mostra os grupos de duplicatas com caminhos, tamanho e espaço recuperável

---

## Pastas ignoradas

O script ignora automaticamente:

- `node_modules/`
- `.git/`
- `.venv/` e `venv/`
- `__pycache__/`
- Dotfiles (arquivos cujo nome começa com `.`)

---

## O que é exibido

Para cada grupo de duplicatas:

- Número do grupo e quantidade de cópias
- Espaço em disco recuperável (exibido em B, KB, MB ou GB)
- Primeiros 16 caracteres do hash SHA-256
- Caminho completo de cada arquivo duplicado

Ao final, um resumo com:

- Total de grupos encontrados
- Total de arquivos duplicados
- Espaço total recuperável

---

## Observação

Nenhum arquivo é deletado ou modificado. O script é somente leitura — a decisão de deletar os arquivos é sempre do usuário.
