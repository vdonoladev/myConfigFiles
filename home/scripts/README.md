# Scripts

Scripts utilitários para Linux. Cada um possui documentação própria.

---

## Instalação

```bash
chmod +x *.sh
```

Para acessar de qualquer lugar no terminal:

```bash
mkdir -p ~/bin
for s in *.sh; do
  ln -sf "$PWD/$s" ~/bin/"${s%.sh}"
done
source ~/.bashrc
```

---

## Scripts disponíveis

| Script | Descrição | Documentação |
| --- | --- | --- |
| `afterInstall.sh` | Pós-instalação do sistema: instala todos os programas e configura o ambiente do zero | [afterInstall.md](afterInstall.md) |
| `cacar-duplicatas.sh` | Encontra arquivos duplicados por hash SHA-256, sem deletar nada | [cacar-duplicatas.md](cacar-duplicatas.md) |
| `installJetbrainsToolbox.sh` | Instala o JetBrains Toolbox no Linux (x86_64) | [installJetbrainsToolbox.md](installJetbrainsToolbox.md) |
| `organizar-downloads.sh` | Organiza arquivos de uma pasta em subpastas por tipo de extensão | [organizar-downloads.md](organizar-downloads.md) |
| `scanner-espaco.sh` | Exibe as maiores pastas e arquivos de um diretório, com resumo do disco | [scanner-espaco.md](scanner-espaco.md) |
| `scanner-wifi.sh` | Escaneia redes Wi-Fi e recomenda o canal menos congestionado | [scanner-wifi.md](scanner-wifi.md) |
| `setup-workspace.sh` | Gerencia layout multi-monitor com perfis salvos em arquivo de configuração | [setup-workspace.md](setup-workspace.md) |
