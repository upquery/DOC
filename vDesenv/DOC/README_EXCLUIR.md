# Implementação da função cadastro_conteudo_excluir

## Sobre a implementação
Foi criada uma função JavaScript `cadastro_conteudo_excluir` para excluir o conteúdo selecionado da tabela doc_conteudos, e uma procedure PL/SQL `conteudo_excluir` para realizar a exclusão no banco de dados.

## Arquivos disponíveis
1. `doc_append.js` - Contém a função JavaScript cadastro_conteudo_excluir para adicionar ao arquivo doc.js
2. `conteudo_excluir.sql` - Contém o código da procedure conteudo_excluir
3. `conteudo_excluir_update.sql` - Script para adicionar a procedure ao package body DOC
4. `package_spec_update.sql` - Script para atualizar a especificação do package DOC

## Como implementar

### Passo 1: Adicionar a função JavaScript
Adicione a função `cadastro_conteudo_excluir` ao arquivo doc.js. Você pode copiar o conteúdo do arquivo `doc_append.js` e adicioná-lo ao final do arquivo doc.js.

### Passo 2: Adicionar a procedure PL/SQL
Execute o script `conteudo_excluir_update.sql` para adicionar a procedure ao package body DOC.

```sql
@conteudo_excluir_update.sql
```

### Passo 3: Atualizar a especificação do package (se necessário)
Execute o script `package_spec_update.sql` para adicionar a declaração da procedure à especificação do package DOC.

```sql
@package_spec_update.sql
```

## Como funciona
1. A função `cadastro_conteudo_excluir` é chamada quando o usuário clica no botão "EXCLUIR" na div cadastro-conteudo-botoes
2. A função identifica o id_conteudo do elemento selecionado
3. Após confirmação do usuário, a função chama a procedure `conteudo_excluir` via AJAX
4. A procedure exclui o registro da tabela doc_conteudos
5. Se a exclusão for bem-sucedida, o elemento é removido da interface do usuário