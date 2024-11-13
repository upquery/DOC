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

    PROCEDURE MAIN 				(PRM_USUARIO     VARCHAR2 DEFAULT NULL,
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

END DOC;
/