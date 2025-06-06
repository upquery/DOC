set scan off

-- >>>>>>>-----------------------------------------------------
-- >>>>>>> POR:				UPQUERY							 --
-- >>>>>>> DATA:			15/10/2021						 --
-- >>>>>>> PACOTE:			DOC								 --
-- >>>>>>> PACOTE:			VER. 1.0					 	 --
-- >>>>>>>													 --
-- >>>>>>> DESENVOLVIDO POR:-----------------------------------
-- >>>>>>> BACKEND:			ANTONI MEDEIROS MATTEI			 --
-- >>>>>>> FRONTEND: 		AUGUSTO ZANETTE BRESSAN			 --
-- >>>>>>> COORDENADO POR:	JOÃO HENRIQUE DA ROCHA MACHADO 	 --
-- >>>>>>>-----------------------------------------------------

create or replace package DOC  is
	/*PROCEDURE MAIN_EXT			( PRM_USUARIO     VARCHAR2 DEFAULT NULL,
								 PRM_EXTERNO     VARCHAR2 DEFAULT NULL,
								 utm_source      VARCHAR2 DEFAULT NULL,
								 utm_medium      VARCHAR2 DEFAULT NULL,
								 utm_campaign    VARCHAR2 DEFAULT NULL,
								 utm_content     VARCHAR2 DEFAULT NULL,
								 utm_term        VARCHAR2 DEFAULT NULL,
								 fbclid          VARCHAR2 DEFAULT NULL);*/

PROCEDURE MAIN 			(PRM_USUARIO     VARCHAR2 DEFAULT NULL,
							PRM_EXTERNO     VARCHAR2 DEFAULT NULL,
							utm_source      VARCHAR2 DEFAULT NULL,
							utm_medium      VARCHAR2 DEFAULT NULL,
							utm_campaign    VARCHAR2 DEFAULT NULL,
							utm_content     VARCHAR2 DEFAULT NULL,
							utm_term        VARCHAR2 DEFAULT NULL,
							fbclid          VARCHAR2 DEFAULT NULL);

PROCEDURE FAQ 				(PRM_VALOR 				VARCHAR2 DEFAULT NULL,
							PRM_CLASSE  			VARCHAR2 DEFAULT NULL,
							PRM_USUARIO 			VARCHAR2 DEFAULT NULL,
							PRM_TIPUSER			VARCHAR2 DEFAULT NULL);

PROCEDURE DOC_PUBLIC 		(PRM_VALOR 				VARCHAR2 DEFAULT NULL,
							PRM_CLASSE  			VARCHAR2 DEFAULT NULL,
							PRM_USUARIO 			VARCHAR2 DEFAULT NULL,
							PRM_TIPUSER			VARCHAR2 DEFAULT NULL);

PROCEDURE DOC_PRIVATE 		(PRM_VALOR 				VARCHAR2 DEFAULT NULL,
							PRM_CLASSE  			VARCHAR2 DEFAULT NULL,
							PRM_USUARIO 			VARCHAR2 DEFAULT NULL,
							PRM_TIPUSER			VARCHAR2 DEFAULT NULL);

PROCEDURE CONSULTA 			(PRM_VALOR 				VARCHAR2 DEFAULT NULL,
							PRM_CLASSE				VARCHAR2 DEFAULT NULL,
							PRM_TIPUSER			VARCHAR2 DEFAULT NULL);

PROCEDURE DETALHE_PERGUNTA 	(PRM_VALOR 				VARCHAR2 DEFAULT NULL, 
							PRM_VERSAO 				VARCHAR2 DEFAULT NULL,
							PRM_TIPUSER				VARCHAR2 DEFAULT NULL);

PROCEDURE MONTA_MENU_LATERAL  ( PRM_PERGUNTA_PAI VARCHAR2,
								PRM_NIVEL        NUMBER,
								PRM_NIVEL_ABERTO NUMBER );

PROCEDURE PRINCIPAL 		(PRM_VALOR 				VARCHAR2 DEFAULT NULL);

PROCEDURE RANK_PERGUNTAS (  PRM_VALOR               VARCHAR2 DEFAULT NULL, 
							PRM_PERGUNTA            VARCHAR2 DEFAULT NULL); 

FUNCTION TRADUZIR 			(PRM_TEXTO 				VARCHAR2) RETURN VARCHAR2;

procedure monta_conteudo_html ( prm_pergunta     varchar2,
								prm_conteudo out clob );

procedure formatar_texto_html ( prm_pergunta         varchar2,
								prm_texto     in out clob) ;

procedure monta_conteudo_json ( prm_classe    varchar2);
procedure monta_conteudo_arquivos ( prm_pergunta     varchar2,
									prm_conteudo out clob ) ;

procedure limpar_formatacao ( prm_texto     in out clob ) ; 

procedure upload (arquivo  IN  varchar2);


procedure doc_cad_conteudo (prm_valor 	varchar2 default null);

procedure topico_atualiza (prm_pergunta       varchar2, 
                           prm_coluna         varchar2,
                           prm_conteudo       varchar2 default null);

procedure conteudo_atualiza (prm_id_conteudo    varchar2, 
                             prm_coluna         varchar2,
                             prm_conteudo       varchar2 default null);

procedure conteudo_move (prm_id_conteudo_origem varchar2,
                         prm_id_conteudo_destino varchar2);

procedure conteudo_tela_cadastro (prm_pergunta     varchar2 default null, 
                                  prm_id_conteudo  varchar2 default null) ;


procedure conteudo_tela_id_estilo (prm_id_conteudo    varchar2); 

procedure conteudo_tela_topicos;

procedure conteudo_tela_conteudos (prm_pergunta    varchar2,
                                   prm_id_conteudo varchar2 default null) ;

procedure cadastro_conteudo_excluir (prm_id_conteudo varchar2);

procedure cadastro_conteudo_inserir (prm_pergunta    varchar2,
								     prm_id_conteudo varchar2 default null);

procedure cadastro_conteudo_salvar (prm_id_conteudo     varchar2,
                                    prm_tp_conteudo     varchar2,
                                    prm_id_estilo       varchar2,
                                    prm_nr_linhas_antes varchar2,
                                    prm_id_ativo        varchar2,
									prm_ds_titulo       varchar2);
procedure estilo_popup (prm_id_conteudo    varchar2);

procedure url_popup;

procedure topico_popup;

procedure imagem_popup;

END DOC;
/