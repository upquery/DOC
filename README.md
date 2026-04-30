# UPDOC — Documentação Upquery

Aplicação web de base de conhecimento e documentação da Upquery. Centraliza FAQ, documentação pública e documentação interna em um único portal, com busca, menu lateral hierárquico, suporte a Markdown e área de cadastro de conteúdos.

A aplicação é servida diretamente do banco Oracle através do módulo **mod_plsql / Oracle HTTP Server**: o backend é uma *package* PL/SQL que gera o HTML via `htp.p`, e os assets de frontend (JS/CSS) ficam armazenados como BLOB em uma tabela do banco e são entregues ao navegador pelo procedimento de download da Upquery.

---

## Estrutura de pastas

```
DOC/
├── v1.0/                          # Versão legada (arquivada)
└── v2.0/
    └── vDesenv/                   # Workspace de desenvolvimento
        ├── DOC/                   # Backend PL/SQL
        │   ├── doc_header.sql     # Cabeçalho da package DOC (specification)
        │   └── doc.sql            # Corpo da package DOC (body)
        ├── web/                   # Frontend
        │   ├── doc.js             # Lógica do cliente
        │   ├── doc.css            # Estilos
        │   └── marked.min.js      # Conversor Markdown → HTML
        ├── compila_doc/           # Ferramenta de build/deploy (Node.js)
        │   ├── index.js
        │   └── package.json
        └── menu_docs.bat          # Menu interativo (Windows) para o build
```

---

## Backend (Oracle PL/SQL)

Toda a aplicação é encapsulada na *package* **`DOC`**, definida em [v2.0/vDesenv/DOC/doc_header.sql](v2.0/vDesenv/DOC/doc_header.sql) e implementada em [v2.0/vDesenv/DOC/doc.sql](v2.0/vDesenv/DOC/doc.sql).

Principais procedures/funções expostas:

| Rotina | Função |
|---|---|
| `MAIN` | Página principal — monta `<head>`, importa CSS/JS e renderiza o portal. Aceita parâmetros UTM e `prm_externo` para deep links. |
| `FAQ` | Renderiza a seção de FAQ (perguntas frequentes). |
| `DOC_PUBLIC` | Renderiza a documentação pública. |
| `DOC_PRIVATE` | Renderiza a documentação interna (requer login). |
| `CONSULTA` | Busca livre de conteúdo. |
| `DETALHE_PERGUNTA` | Renderiza o detalhe de um tópico/pergunta. |
| `LOGIN` / `VALIDAR_USER` / `VALIDAR_SENHA` / `LOGOUT` | Fluxo de autenticação. |
| `MONTA_MENU_LATERAL` | Monta árvore de navegação lateral (recursiva por nível). |
| `RANK_PERGUNTAS` | Sistema de votação/ranking dos tópicos. |
| `monta_conteudo_html` / `monta_conteudo_markdown` / `monta_conteudo_arquivos` | Renderizadores de conteúdo. |
| `formatar_texto_html` / `limpar_formatacao` | Normalização de texto. |
| `TRADUZIR` | Tradução de strings de interface. |
| `upload` / `download` | Upload e entrega de arquivos. |
| `doc_cad_conteudo` + `topico_atualiza` / `conteudo_atualiza` / `conteudo_move` / `cadastro_conteudo_*` | Tela e operações de cadastro/edição de tópicos e conteúdos. |
| `conteudo_tela_*` / `estilo_popup` / `url_popup` / `topico_popup` / `imagem_popup` | Telas e popups da área administrativa. |
| `getUsuario` / `getNivel` / `SET_USUARIO` / `SET_SESSAO` | Helpers de sessão e autorização. |

### Classes de documentação

O frontend identifica a área pelo símbolo `classe_doc`:

- **`F`** — FAQ (Dúvidas frequentes)
- **`D`** — Documentação pública
- **`P`** — Documentação interna (privada)

E o tipo de usuário pela variável `tip_user`:

- **`T`** — Ambos
- **`A`** — Admin
- **`N`** — Usuário normal

---

## Frontend

[v2.0/vDesenv/web/doc.js](v2.0/vDesenv/web/doc.js) — JavaScript baunilha (sem framework), responsável por:

- Delegação de eventos (clique e teclado) na raiz do `document`.
- Função `chamar(...)` que dispara as procedures do backend via URL `dwu.doc.<procedure>`.
- Navegação entre seções (FAQ, pública, privada, cadastro), busca, votação, abrir/fechar nós do menu lateral, fluxo de login com `XMLHttpRequest` para `dwu.doc.validar_senha`, e estado de seleção via `sessionStorage`.

[v2.0/vDesenv/web/doc.css](v2.0/vDesenv/web/doc.css) — Estilos do portal.

[v2.0/vDesenv/web/marked.min.js](v2.0/vDesenv/web/marked.min.js) — Biblioteca [marked](https://marked.js.org/) para converter Markdown em HTML no cliente.

---

## Build e deploy — `compila_doc`

A pasta [v2.0/vDesenv/compila_doc/](v2.0/vDesenv/compila_doc/) contém um utilitário Node.js que:

1. Lê os arquivos de `web/` e os grava como **BLOB** na tabela `TAB_DOCUMENTOS` do schema `DWU` (campo `blob_content`, indexado por `name`). Essa tabela é a fonte servida ao navegador via `dwu.fcl.download?arquivo=<nome>`.
2. Lê os `.sql` de `DOC/` e os executa diretamente no banco para recompilar a *package* `DOC` (header e body).

### Pré-requisitos

- **Node.js** (ESM — `"type": "module"`).
- Acesso de rede ao banco Oracle de desenvolvimento.
- Cliente Oracle compatível com a lib [`oracledb`](https://www.npmjs.com/package/oracledb).

### Instalação

```bash
cd v2.0/vDesenv/compila_doc
npm install
```

### Configuração de conexão

Os parâmetros do banco estão em [v2.0/vDesenv/compila_doc/index.js](v2.0/vDesenv/compila_doc/index.js) (objeto `dbDocs`). Ajuste `user`, `password`, `host`, `port` e `service` conforme o ambiente.

O caminho dos fontes é resolvido a partir de `%USERPROFILE%/FONTES/OUTROS/DOC/V2.0/vDesenv` — quem executa precisa ter o repositório nesse caminho ou ajustar `dirDoc` no script.

### Uso

A partir de `v2.0/vDesenv/`:

```bash
node compila_doc/index.js [flags]
```

| Flag | Ação |
|---|---|
| `--js` | Faz upload do `web/doc.js` para `TAB_DOCUMENTOS`. |
| `--css` | Faz upload do `web/doc.css`. |
| `--head` | Compila o header da package (`DOC/doc_header.sql`). |
| `--sql` | Compila o body da package (`DOC/doc.sql`). |
| `--plsql` | Atalho: compila header **e** body. |
| `--all` | Executa todas as operações acima. |
| `--help` | Exibe a ajuda (mesma saída quando nenhuma flag é informada). |

### Menu interativo (Windows)

Para conforto no Windows, [v2.0/vDesenv/menu_docs.bat](v2.0/vDesenv/menu_docs.bat) abre um menu com as opções:

```
1 - WEB    (JS + CSS)
2 - PLSQL  (Header + Body)
3 - TUDO
0 - Sair
```

Basta executar `menu_docs.bat` na pasta `vDesenv`.

---

## Fluxo de desenvolvimento típico

1. Editar `doc.js` / `doc.css` em `v2.0/vDesenv/web/` ou `doc.sql` / `doc_header.sql` em `v2.0/vDesenv/DOC/`.
2. Rodar `menu_docs.bat` (ou `node compila_doc/index.js --<flag>`) para subir as alterações ao banco de desenvolvimento.
3. Validar no portal apontando o navegador para a URL `dwu.doc.main` do ambiente.

---

## Observações

- A versão **v1.0** está mantida apenas para referência histórica; todo o desenvolvimento ativo acontece em **v2.0/vDesenv**.
- As credenciais do banco de desenvolvimento estão em claro no `index.js` — ao mover este projeto para outro ambiente, considere extrair para variáveis de ambiente ou para um arquivo de configuração não versionado.
