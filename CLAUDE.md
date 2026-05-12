# UPDOC — Portal de Documentação Upquery

Aplicação web de base de conhecimento (FAQ, documentação pública e interna) da Upquery, **servida diretamente do Oracle** via `mod_plsql` / Oracle HTTP Server. O backend é uma *package* PL/SQL que gera HTML com `htp.p`; o frontend (JS/CSS) é armazenado como **BLOB** na tabela `DWU.TAB_DOCUMENTOS` e entregue ao navegador pelo procedimento `dwu.fcl.download?arquivo=<nome>`.

## Layout do repositório

```
DOC/
├── v1.0/                          # Legado — NÃO MEXER (referência histórica)
└── v2.0/vDesenv/                  # ✅ Workspace ativo de desenvolvimento
    ├── DOC/                       # Backend PL/SQL
    │   ├── doc_header.sql         # Spec da package DOC
    │   └── doc.sql                # Body da package DOC
    ├── web/                       # Frontend (JS/CSS baunilha)
    │   ├── doc.js  / doc.css      # Frontend em produção
    │   └── marked.min.js          # Markdown → HTML no cliente
    ├── compila_doc/               # Build/deploy Node.js (ESM)
    │   ├── index.js
    │   └── package.json
    └── menu_docs.bat              # Menu interativo Windows p/ o build
```

**Importante:** todo desenvolvimento ativo é em `v2.0/vDesenv/`. A `v1.0/` está mantida só como referência — não editar.

## Backend — package `DOC` (Oracle PL/SQL)

Schema **`DWU`**. Toda a aplicação está encapsulada na package `DOC` (spec em `doc_header.sql`, body em `doc.sql`).

Procedures principais expostas via URL (`dwu.doc.<nome>`):

- **Páginas:** `MAIN`, `FAQ`, `DOC_PUBLIC`, `DOC_PRIVATE`, `CONSULTA`, `DETALHE_PERGUNTA`
- **Autenticação:** `LOGIN`, `VALIDAR_USER`, `VALIDAR_SENHA`, `LOGOUT`, `SET_USUARIO`, `SET_SESSAO`
- **Navegação:** `MONTA_MENU_LATERAL` (recursiva por nível), `RANK_PERGUNTAS`
- **Renderizadores:** `monta_conteudo_html`, `monta_conteudo_markdown`, `monta_conteudo_arquivos`, `formatar_texto_html`, `limpar_formatacao`
- **i18n:** `TRADUZIR`
- **Arquivos:** `upload`, `download`
- **Cadastro/edição:** `doc_cad_conteudo`, `topico_atualiza`, `conteudo_atualiza`, `conteudo_move`, `cadastro_conteudo_*`, `conteudo_tela_*`, popups (`estilo_popup`, `url_popup`, `topico_popup`, `imagem_popup`)
- **Helpers:** `getUsuario`, `getNivel`

### Convenções

- **`classe_doc`** (área da aplicação):
  - `F` → FAQ
  - `D` → Documentação pública
  - `P` → Documentação interna
- **`tip_user`** (perfil):
  - `T` → ambos
  - `A` → admin
  - `N` → normal
- Parâmetros de procedure seguem o padrão `PRM_*` em maiúsculas.

## Frontend

JavaScript **baunilha** (sem framework). Padrões em uso:

- Delegação de eventos no `document` (click e keypress).
- Função `chamar(<procedure>, ...)` dispara as procedures via URL `dwu.doc.<procedure>`.
- Fluxo de login com `XMLHttpRequest` para `dwu.doc.validar_senha`.
- Estado de seleção persistido em `sessionStorage`.
- Markdown convertido no cliente com `marked.min.js`.

## Build & deploy — `compila_doc`

Utilitário Node.js (ESM, `"type": "module"`) que sobe os fontes para o Oracle:

- `--js` / `--css` → grava `doc.js`/`doc.css` como BLOB em `TAB_DOCUMENTOS` (chave: `name`).
- `--head` / `--sql` → executa o `.sql` no banco (recompila a package).
- `--plsql` → atalho para `--head` + `--sql`.
- `--all` → tudo acima.

Atalho Windows: `menu_docs.bat` (na raiz de `vDesenv/`).

### Configuração de conexão

Hardcoded em `v2.0/vDesenv/compila_doc/index.js` (objeto `dbDocs`):
- Banco de **desenvolvimento**: `DWU@172.1.1.198:1521/DESENV`
- **Atenção:** senha em claro no arquivo (deixado assim deliberadamente para o ambiente atual).

Caminho dos fontes resolvido a partir de `%USERPROFILE%\FONTES\OUTROS\DOC\V2.0\vDesenv` — quem rodar precisa ter o repo nesse caminho (ou ajustar `dirDoc` no script). O OneDrive do desenvolvedor expõe esse caminho através do diretório do usuário.

## Fluxo típico de trabalho

1. Editar `doc.js` / `doc.css` em `v2.0/vDesenv/web/` ou `doc_header.sql` / `doc.sql` em `v2.0/vDesenv/DOC/`.
2. Rodar `menu_docs.bat` (ou `node compila_doc/index.js --<flag>`) para subir ao banco de desenvolvimento.
3. Validar no navegador via `dwu.doc.main`.

## Stack & ambiente

- **Banco:** Oracle (schema `DWU`), servido via Oracle HTTP Server + `mod_plsql`.
- **Frontend:** HTML/CSS/JS puro (sem build step, sem bundler).
- **Tooling:** Node.js + `oracledb` (apenas para deploy).
- **SO de desenvolvimento:** Windows (PowerShell). Comandos shell aqui usam sintaxe PowerShell.
- **Idioma:** código, comentários, identificadores e mensagens ao usuário em **português**.
