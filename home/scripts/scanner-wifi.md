# scanner-wifi.sh

Escaneia as redes Wi-Fi próximas e recomenda o canal menos congestionado para o roteador, tanto para 2.4 GHz quanto para 5 GHz.

---

## Requisitos

O script detecta automaticamente qual ferramenta usar:

| Prioridade | Ferramenta | Instalação |
| --- | --- | --- |
| Principal | `nmcli` (NetworkManager) | Pré-instalado na maioria das distros com GNOME |
| Fallback | `iwlist` (wireless-tools) | `sudo apt install wireless-tools` |

---

## Como usar

```bash
chmod +x scanner-wifi.sh
./scanner-wifi.sh
```

Não há parâmetros. O script detecta automaticamente a interface Wi-Fi e a rede atual.

---

## O que é exibido

### Tabela 2.4 GHz (canais 1–13)

- Canal, número de redes detectadas naquele canal, barra visual de congestionamento e nomes das redes
- Os canais 1, 6 e 11 (os não sobrepostos, ideais para configurar o roteador) sempre aparecem na tabela, mesmo se estiverem vazios

### Tabela 5 GHz (canais 36–165)

- Mesmo formato da tabela 2.4 GHz
- Exibida apenas se ao menos uma rede for detectada nessa faixa

### Diagnóstico

- Nome da sua rede atual (SSID)
- Canal atual com avaliação de congestionamento
- Canal ideal recomendado para 2.4 GHz (entre 1, 6 e 11)
- Canal ideal recomendado para 5 GHz

---

## Cores na tabela de canais

| Cor | Critério |
| --- | --- |
| Normal | 1–2 redes no canal |
| Amarelo | 3–4 redes no canal |
| Vermelho | 5 ou mais redes no canal |

---

## Avaliação do canal atual

| Avaliação | Critério |
| --- | --- |
| BOM | Menos de 3 redes no canal |
| MODERADO | 3 ou 4 redes no canal |
| CONGESTIONADO | 5 ou mais redes no canal |

---

## Como aplicar a recomendação

Acesse o painel de administração do seu roteador (normalmente `192.168.1.1` ou `192.168.0.1`) e altere o canal nas configurações de Wi-Fi para o canal recomendado pelo script.
