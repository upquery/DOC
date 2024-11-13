create table doc_variaveis (
variavel   varchar2(50),
conteudo   varchar2(1000) );
alter table doc_variaveis add constraint doc_variaveis_pk primary key (variavel);
insert into doc_variaveis (variavel, conteudo) values ('URL_DOC', 'http://cloud.upquery.com/conhecimento'); 
commit; 
--
create table doc_estrutura  (
cd_pergunta     number not null,
nr_ordem        number not null, 
cd_pergunta_pai number not null); 
alter table doc_estrutura add constraint doc_estrutura_pk primary key (cd_pergunta, cd_pergunta_pai) ;
--
ALTER TABLE doc_perguntas ADD id_VISUALIZACAO varchar2(2) default 'TM' not null;