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
-------------------------------------------------------------------

create table doc_conteudos (
id_conteudo      number,     
cd_pergunta      number,
sq_conteudo      number,
tp_conteudo      varchar2(30),  -- TITULO / PARAGRAFO / TEXTO / IMAGEM / MARCADOR1 / MARCADOR2 / MARCADOR3 / MARCAODR4 
id_estilo        varchar2(30), 
nr_linhas_antes  integer default 0 not null, 
ds_titulo        varchar2(300),
ds_texto         clob,
id_ativo         varchar2(1) default 'S' not null);
alter table doc_conteudos add constraint doc_conteudo_pk primary key (id_conteudo);
create index doc_conteudos_idx001 on doc_conteudos (cd_pergunta);
--
create table doc_estilos (
id_estilo        varchar2(30), 
css_estilo       varchar2(4000) ); 
alter table doc_estilos add constraint doc_estilos_pk primary key (id_estilo);
