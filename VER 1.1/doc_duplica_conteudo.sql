create or replace procedure doc_duplica_conteudo(prm_rowid         rowid, 
                                                 prm_retorno   out varchar2) as
    cursor c1 is 
       select * from doc_conteudos where rowid = prm_rowid;
    r1               c1%rowtype;
    ws_id_conteudo   doc_conteudos.id_conteudo%type;
    ws_sq_conteudo   doc_conteudos.sq_conteudo%type;
begin
    open  c1;
    fetch c1 into r1;
    close c1; 
    --
    select nvl(max(id_conteudo),0) + 1 into ws_id_conteudo from doc_conteudos ;
    --
    select nvl(max(sq_conteudo),0) + 1 into ws_sq_conteudo from doc_conteudos where cd_pergunta = r1.cd_pergunta ;
    --
    insert into doc_conteudos (id_conteudo, cd_pergunta, sq_conteudo, tp_conteudo, id_estilo, nr_linhas_antes, ds_titulo, ds_texto, id_ativo)
                       values (ws_id_conteudo, r1.cd_pergunta, ws_sq_conteudo, r1.tp_conteudo, r1.id_estilo, r1.nr_linhas_antes, r1.ds_titulo, r1.ds_texto, r1.id_ativo);
    --
    commit; 
    --
    prm_retorno := 'RECARREGAR_BROWSER'; 
    --
exception 
    when others then 
        rollback; 
        prm_retorno := 'ERRO|'||'Erro duplicando linha';
		insert into bi_log_sistema (dt_log, ds_log, nm_usuario, nm_procedure) values (sysdate, 'DOC_DUPLICA_CONTEUDO(others):'||DBMS_UTILITY.FORMAT_ERROR_STACK||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'DWU', 'ERRO');
    	commit;
end;