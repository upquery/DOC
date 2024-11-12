create table doc_variaveis (
variavel   varchar2(50),
conteudo   varchar2(1000) );
alter table doc_variaveis add constraint doc_variaveis_pk primary key (variavel);
insert into doc_variaveis (variavel, conteudo) values ('URL_DOC', 'http://cloud.upquery.com/conhecimento'); 
commit; 