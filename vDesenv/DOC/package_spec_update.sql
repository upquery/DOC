-- Execute this script to update the DOC package specification with the new procedure

SET DEFINE OFF

ALTER PACKAGE DOC ADD
procedure conteudo_excluir (prm_id_conteudo varchar2);
/