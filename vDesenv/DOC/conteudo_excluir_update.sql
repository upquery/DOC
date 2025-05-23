-- Execute this script to add the conteudo_excluir procedure to the DOC package body

SET DEFINE OFF

-- Add the new procedure to the DOC package body
ALTER PACKAGE BODY DOC ADD
procedure conteudo_excluir (prm_id_conteudo varchar2) as
begin 
    delete from doc_conteudos
    where id_conteudo = prm_id_conteudo;
    
    if sql%notfound then 
        htp.p('ERRO|Conteúdo não localizado para exclusão.');
    else 
        htp.p('OK|Conteúdo excluído com sucesso.');
    end if;             
exception 
    when others then 
        insert into bi_log_sistema values (sysdate, 'conteudo_excluir: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
        commit;
        htp.p('ERRO|Erro excluindo conteúdo.');
end conteudo_excluir;
/