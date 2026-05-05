# organizar-downloads.sh

Move os arquivos de uma pasta para subpastas organizadas por tipo de extensão. Conflitos de nomes são resolvidos automaticamente com sufixo numérico. Dotfiles e subpastas existentes são ignorados.

---

## Como usar

```bash
chmod +x organizar-downloads.sh
```

```bash
./organizar-downloads.sh               # Organiza a pasta atual
./organizar-downloads.sh ~/Downloads   # Organiza uma pasta específica
```

### Parâmetros

| Parâmetro | Padrão | Descrição |
| --- | --- | --- |
| `[pasta]` | `.` (pasta atual) | Diretório a ser organizado |

---

## Categorias e extensões

| Pasta destino | Extensões reconhecidas |
| --- | --- |
| `Imagens/` | jpg, jpeg, png, gif, bmp, svg, webp, ico, tiff, heic, heif, raw, cr2, nef, avif |
| `Documentos/` | pdf, doc, docx, xls, xlsx, ppt, pptx, odt, ods, odp, rtf, tex, pages, numbers, key, epub |
| `Videos/` | mp4, mov, avi, mkv, wmv, flv, webm, m4v, mpg, mpeg, ts |
| `Audio/` | mp3, wav, flac, aac, ogg, wma, m4a, opus, aiff, alac |
| `Instaladores/` | dmg, pkg, exe, msi, deb, rpm, appimage, snap, flatpak |
| `Compactados/` | zip, rar, 7z, tar, gz, bz2, xz, tgz, zst |
| `Codigo/` | py, js, html, css, sh, json, xml, yaml, yml, md, csv, sql, rb, go, rs, java, c, cpp, h, swift, kt, lua, r |
| `Outros/` | Qualquer extensão não listada acima |

---

## Comportamento

- As subpastas de destino são criadas automaticamente se não existirem
- Se um arquivo com o mesmo nome já existir no destino, o script adiciona um sufixo: `arquivo (1).ext`, `arquivo (2).ext`, etc.
- Dotfiles (arquivos cujo nome começa com `.`) são ignorados
- Subpastas dentro do diretório alvo não são movidas nem processadas
- Ao final, exibe um resumo com a contagem de arquivos movidos por categoria
