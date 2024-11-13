SET DEFINE OFF
CREATE OR REPLACE PACKAGE BODY DOC  IS

    PROCEDURE MAIN (PRM_USUARIO     VARCHAR2 DEFAULT NULL,
                    PRM_EXTERNO     VARCHAR2 DEFAULT NULL,
                    utm_source      VARCHAR2 DEFAULT NULL,
                    utm_medium      VARCHAR2 DEFAULT NULL,
                    utm_campaign    VARCHAR2 DEFAULT NULL,
                    utm_content     VARCHAR2 DEFAULT NULL,
                    utm_term        VARCHAR2 DEFAULT NULL,
                    fbclid          VARCHAR2 DEFAULT NULL) AS
    
    WS_CSS          VARCHAR2(80);
    ws_usuario      VARCHAR2(200);
    ws_tipouser     VARCHAR2(200);
    ws_externo      VARCHAR2(200);

    BEGIN
    htp.p('<script>');

	    htp.prn('const ');
		for i in(select cd_constante, vl_constante from bi_constantes) loop
			htp.prn(i.cd_constante||' = "'||fun.lang(i.vl_constante)||'", ');
		end loop;
		htp.prn('TR_END = "";');
        htp.p('const USUARIO = "'||gbl.getusuario||'";');

	htp.p('</script>');

        htp.p('<!DOCTYPE html>');
        htp.p('<html lang="pt-br">');
                
            htp.p('<head>');

                htp.p('<link rel="favicon" href="dwu.fcl.download?arquivo=upquery-icon.png"/>');
                htp.p('<link rel="shortcut icon" href="dwu.fcl.download?arquivo=upquery-icon.png"/>');
                htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo=doc.css"/>' );
                htp.p('<script src="dwu.fcl.download?arquivo=doc.js"></script>');
                htp.p('<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet" type="text/css">');
                htp.p('<link href="https://fonts.googleapis.com/css?family=Rubik" rel="stylesheet" type="text/css">');
                htp.p('<link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet" type="text/css">');
                htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');
                htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo=MADETOMMY.otf">');
                htp.p('<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">');
                htp.p('<meta http-equiv="Content-Language" content="pt-br">');
                htp.p('<title>Conhecimento - UPQUERY</title>');

            htp.p('</head>');

            htp.p('<body style="position: absolute; width: 100%; margin: 0; background: #f9f9f9; display: block; /*display: flex; flex-flow: column nowrap;*/">');      

                htp.p('<div id="header_doc_variaveis" style="display: none;" '); 
                    for a in (select variavel, conteudo from doc_variaveis) loop
                       htp.p('data-'||a.variavel||'="'||a.conteudo||'" '); 
                    end loop;
                htp.p('></div>'); 

                htp.p('<div class="header-doc">');  

                    ws_usuario := nvl(UPPER(gbl.getusuario),'N/A');
                                            
                    htp.p('<img src="dwu.fcl.download?arquivo=logo-upquery-01.png" class="retorna-princ" tittle ="Logotipo do produto UpQuery"/>');

                        htp.p('<a class="go-faq">Central de Ajuda</a>');
                        htp.p('<a class="go-doc-public">Documenta&ccedil;&atilde;o</a>');
                    
                        if upper(trim(ws_usuario)) <> 'NOUSER' then
                            htp.p('<a class="go-doc-private" id="'||ws_usuario||'">Doc. Interna</a>');
                        end if;

                htp.p('</div>');

                htp.p('<div class="spinner"></div>');
                -- Condição criada para quando a DOC for chamada pelo BI 23/11/22
                IF PRM_EXTERNO IS NOT NULL THEN
                    ws_tipouser:=prm_usuario;
                    ws_externo:=prm_externo;
                    htp.p('<a id="prm_externo" data-usuario="'||ws_tipouser||'" data-search="'||ws_externo||'"></a>');
                    htp.p('<script>gopage=document.getElementById(''prm_externo'');chamar(''detalhe_pergunta'',gopage.getAttribute(''data-search''),'''',gopage.getAttribute(''data-usuario''));</script>');
                    ws_tipouser:='';
                    ws_externo:='';
                END IF;
                
                								
                htp.p('<div class="main">');

                    
                    doc.principal;

                htp.p('</div>');

                htp.p('<div class="footer-doc">');
                    
                    htp.p('<span>');
                        htp.p('<a class="links" title="WhatsApp" href="https://wa.me/message/DWVS7MC4FU2RF1"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="sociais" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><path d="M440.164,71.836C393.84,25.511,332.249,0,266.737,0S139.633,25.511,93.308,71.836S21.473,179.751,21.473,245.263    c0,41.499,10.505,82.279,30.445,118.402L0,512l148.333-51.917c36.124,19.938,76.904,30.444,118.403,30.444    c65.512,0,127.104-25.512,173.427-71.836C486.488,372.367,512,310.776,512,245.263S486.488,118.16,440.164,71.836z     M266.737,460.495c-38.497,0-76.282-10.296-109.267-29.776l-6.009-3.549L48.952,463.047l35.878-102.508l-3.549-6.009    c-19.479-32.985-29.775-70.769-29.775-109.266c0-118.679,96.553-215.231,215.231-215.231s215.231,96.553,215.231,215.231    C481.968,363.943,385.415,460.495,266.737,460.495z"/></g></g><g><g><path d="M398.601,304.521l-35.392-35.393c-11.709-11.71-30.762-11.71-42.473,0l-13.538,13.538    c-32.877-17.834-60.031-44.988-77.866-77.865l13.538-13.539c5.673-5.672,8.796-13.214,8.796-21.236    c0-8.022-3.124-15.564-8.796-21.236l-35.393-35.393c-5.672-5.672-13.214-8.796-21.236-8.796c-8.023,0-15.564,3.124-21.236,8.796    l-28.314,28.314c-15.98,15.98-16.732,43.563-2.117,77.664c12.768,29.791,36.145,62.543,65.825,92.223    c29.68,29.68,62.432,53.057,92.223,65.825c16.254,6.965,31.022,10.44,43.763,10.44c13.992,0,25.538-4.193,33.901-12.557    l28.314-28.314c5.673-5.672,8.796-13.214,8.796-21.236S404.273,310.193,398.601,304.521z M349.052,354.072    c-6.321,6.32-23.827,4.651-44.599-4.252c-26.362-11.298-55.775-32.414-82.818-59.457c-27.043-27.043-48.158-56.455-59.457-82.818    c-8.903-20.772-10.571-38.278-4.252-44.599l28.315-28.314l35.393,35.393l-28.719,28.719l4.53,9.563    c22.022,46.49,59.753,84.221,106.244,106.244l9.563,4.53l28.719-28.719l35.393,35.393L349.052,354.072z"/></g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg></a>');                        
                        htp.p('<a class="links" title="Instagram" href="https://www.instagram.com/upquery/"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" id="sociais" feather-instagram"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.5" y2="6.5"/></svg></a>');
                        htp.p('<a class="links" title="LinkedIn" href="https://www.linkedin.com/company/upquery-do-brasil/"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" id="sociais"><path d="m437 0h-362c-41.355469 0-75 33.644531-75 75v362c0 41.355469 33.644531 75 75 75h362c41.355469 0 75-33.644531 75-75v-362c0-41.355469-33.644531-75-75-75zm45 437c0 24.8125-20.1875 45-45 45h-362c-24.8125 0-45-20.1875-45-45v-362c0-24.8125 20.1875-45 45-45h362c24.8125 0 45 20.1875 45 45zm0 0"/><path d="m91 422h90v-212h-90zm30-182h30v152h-30zm0 0"/><path d="m331.085938 210c-.027344 0-.058594 0-.085938 0-10.371094 0-20.472656 1.734375-30 5.101562v-5.101562h-90v212h90v-107c0-8.269531 6.730469-15 15-15s15 6.730469 15 15v107h90v-117.3125c0-48.546875-39.382812-94.640625-89.914062-94.6875zm59.914062 182h-30v-77c0-24.8125-20.1875-45-45-45s-44.996094 20.1875-45 44.996094v77.003906h-30v-152h30v30.019531l24.007812-18.03125c10.441407-7.84375 22.886719-11.988281 35.992188-11.988281h.058594c31.929687.03125 59.941406 30.257812 59.941406 64.6875zm0 0"/><path d="m91 180h90v-90h-90zm30-60h30v30h-30zm0 0"/></svg></a>');
                    htp.p('</span>');

                    htp.p('<span >');
                        htp.p('<a class="links" href="https://www.upquery.com">2021 © UpQuery do Brasil</a>');
                    htp.p('</span>');
                   
                    -- Retirado a pedido do suporte
                    /*htp.p('<span class="cversion"> Current Version: ');
                    --     gbl.getVersion;
                    htp.p('</span>');*/

                    htp.p('<span >');
                        htp.p('<a class="links" href="https://www.upquery.com/politica-de-privacidade">Pol&iacute;tica de Privacidade | </a>');
                        htp.p('<a class="links" href="https://www.upquery.com/termos-de-uso">Termos de Uso</a>');
                    htp.p('</span>');

                htp.p('</div>');
                
                htp.p('<div id="loadingscreens">');					
				htp.p('</div>');

			htp.p('</body>');
    
    END MAIN;

    PROCEDURE PRINCIPAL (PRM_VALOR VARCHAR2 DEFAULT NULL) AS

    BEGIN

        htp.p('<div class="apresentation">');
            -- testa para ver se o dispositivo acessado é mobile ou não para ajustar o tamanho da imagem  no css
            if instr(owa_util.get_cgi_env('HTTP_USER_AGENT'), 'iPhone') = 0 and instr(owa_util.get_cgi_env('HTTP_USER_AGENT'), 'Android') = 0 then
                htp.p('<img src="dwu.fcl.download?arquivo=doc_apresentation_main.png" class="bgmenur" />');
            else
                --utilizado background-image para quando o dispositivo for do tipo mobile.
                htp.p('<div class="bgmenur" ></div>');
            end if;

            
            /*htp.p('<span>');                

                htp.p('COLOQUE AQUI O CONTEUDO DE APRESENTAÇÃO/NOTAS DA VERSÃO');
            
            htp.p('</span>');*/


        htp.p('</div>');

    END PRINCIPAL;

    PROCEDURE FAQ (	PRM_VALOR 	VARCHAR2 DEFAULT NULL,
                    PRM_CLASSE  VARCHAR2 DEFAULT NULL,
                    PRM_USUARIO VARCHAR2 DEFAULT NULL,
                    PRM_TIPUSER VARCHAR2 DEFAULT NULL) AS
        
        WS_USUARIO	    VARCHAR2(80);
        WS_CSS		    VARCHAR2(80);
        WS_TIPUSER      VARCHAR2(2);

    BEGIN
        WS_TIPUSER:=PRM_TIPUSER;
      
        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

            htp.p('<div class="conteudo-faq">');

            
                htp.p('<div class="fundo-busca">');
                        
                        
 
                        htp.p('<h1 class="titulo-faq"> COMO PODEMOS AJUDAR?</h1>');

                        htp.p('<div class="mensagem">');
                            htp.p('<span class="label-tipUser">');
                                htp.p('<a>Tipo de usuario:</a>');
                                 htp.p('<select id ="change-tipUser" onchange="tip_user=this.value; chamar(''FAQ'', '''||PRM_VALOR||''','''',this.value);" >');
                                    
                                    if WS_TIPUSER = 'T' THEN
                                        htp.p('<option value="T" selected>Todos</option>');
                                    ELSE
                                        htp.p('<option value="T" >Todos</option>');
                                    END IF;

                                    if WS_TIPUSER  = 'A' THEN
                                        htp.p('<option value="A" selected>Admin</option>');
                                    ELSE
                                        htp.p('<option value="A" >Admin</option>');
                                    END IF;

                                    if WS_TIPUSER = 'N' THEN
                                        htp.p('<option value="N" selected>Normal</option>');
                                    ELSE
                                        htp.p('<option value="N" >Normal</option>');
                                    END IF;

                                htp.p('</select>');
                            htp.p('</span>');                            
                            htp.p('<input id="busca" placeholder="Utilize palavras-chaves na busca..." value="'||lower(prm_valor)||'" />');
                            htp.p('<img src="dwu.fcl.download?arquivo=lupabusca.png" id="lupa" />');
                        htp.p('</div>');

                        htp.p('<img src="dwu.fcl.download?arquivo=doc_bg_pesquisa.png" class="bgdoc" />');

                htp.p('</div>');

                        htp.p('<ul class="flex-container">');
                            doc.consulta(PRM_VALOR,'F',WS_TIPUSER);
                        htp.p('</ul>');

            htp.p('</div>');

    END FAQ;
    
    PROCEDURE DOC_PUBLIC (	PRM_VALOR 	VARCHAR2 DEFAULT NULL,
                            PRM_CLASSE  VARCHAR2 DEFAULT NULL,
                            PRM_USUARIO VARCHAR2 DEFAULT NULL,
                            PRM_TIPUSER VARCHAR2 DEFAULT NULL) AS
        
        WS_USUARIO	    VARCHAR2(80);
        WS_CSS		    VARCHAR2(80);
        WS_TIPUSER      VARCHAR2(2);

    BEGIN
        WS_TIPUSER:=PRM_TIPUSER;
        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

            htp.p('<div class="conteudo-faq">');

                htp.p('<div class="fundo-busca">');
                        
                        htp.p('<h1 class="titulo-faq"> DOCUMENTA&Ccedil;&Atilde;O</h1>');

                        htp.p('<div class="mensagem">');
                            htp.p('<span class="label-tipUser">');
                                htp.p('<a>Tipo de usuario:</a>');
                                htp.p('<select onchange="tip_user=this.value; chamar(''DOC_PUBLIC'', '''||PRM_VALOR||''','''',this.value);"id ="change-tipUser">');
                                    
                                    if WS_TIPUSER = 'T' THEN
                                        htp.p('<option value="T" selected>Todos</option>');
                                    ELSE
                                        htp.p('<option value="T" >Todos</option>');
                                    END IF;

                                    if WS_TIPUSER = 'A' THEN
                                        htp.p('<option value="A" selected>Admin</option>');
                                    ELSE
                                        htp.p('<option value="A" >Admin</option>');
                                    END IF;

                                    if WS_TIPUSER = 'N' THEN
                                        htp.p('<option value="N" selected>Normal</option>');
                                    ELSE
                                        htp.p('<option value="N" >Normal</option>');
                                    END IF;

                                htp.p('</select>');
                            htp.p('</span>');                            
                            htp.p('<input id="busca" placeholder="Utilize palavras-chaves na busca..." value="'||lower(prm_valor)||'" />');
                            htp.p('<img src="dwu.fcl.download?arquivo=lupabusca.png" id="lupa" />');
                        htp.p('</div>');

                        htp.p('<img src="dwu.fcl.download?arquivo=doc_bg_pesquisa.png" class="bgdoc" />');

                htp.p('</div>');
                        
                        htp.p('<ul class="flex-container">');
                            doc.consulta(PRM_VALOR,'D',WS_TIPUSER);
                        htp.p('</ul>');

            htp.p('</div>');

    END DOC_PUBLIC;
    
    PROCEDURE DOC_PRIVATE (	PRM_VALOR 	VARCHAR2 DEFAULT NULL,
                            PRM_CLASSE  VARCHAR2 DEFAULT NULL,
                            PRM_USUARIO VARCHAR2 DEFAULT NULL,
                            PRM_TIPUSER VARCHAR2 DEFAULT NULL) AS
        
        WS_USUARIO	    VARCHAR2(80);
        WS_CSS		    VARCHAR2(80);
        WS_TIPUSER      VARCHAR2(2);

    BEGIN

        WS_TIPUSER:=PRM_TIPUSER;
      
        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

            htp.p('<div class="conteudo-faq">');

                htp.p('<div class="fundo-busca">');
                        
                        htp.p('<h1 class="titulo-faq"> DOCUMENTA&Ccedil;&Atilde;O INTERNA</h1>');

                        htp.p('<div class="mensagem">');
                            htp.p('<span class="label-tipUser">');
                                htp.p('<a>Tipo de usuario:</a>');
                                htp.p('<select onchange="tip_user=this.value; chamar(''DOC_PRIVATE'', '''||PRM_VALOR||''','''',this.value);" id="change-tipUser">');
                                    
                                    if WS_TIPUSER = 'T' THEN
                                        htp.p('<option value="T" selected>Todos</option>');
                                    ELSE
                                        htp.p('<option value="T" >Todos</option>');
                                    END IF;

                                    if WS_TIPUSER = 'A' THEN
                                        htp.p('<option value="A" selected>Admin</option>');
                                    ELSE
                                        htp.p('<option value="A" >Admin</option>');
                                    END IF;

                                    if WS_TIPUSER = 'N' THEN
                                        htp.p('<option value="N" selected>Normal</option>');
                                    ELSE
                                        htp.p('<option value="N" >Normal</option>');
                                    END IF;

                                htp.p('</select>');
                            htp.p('</span>');                            
                            htp.p('<input id="busca" placeholder="Utilize palavras-chaves na busca..." value="'||lower(prm_valor)||'" />');
                            htp.p('<img src="dwu.fcl.download?arquivo=lupabusca.png" id="lupa" />');
                        htp.p('</div>');

                        htp.p('<img src="dwu.fcl.download?arquivo=doc_bg_pesquisa.png" class="bgdoc" />');

                htp.p('</div>');
              
                        htp.p('<ul class="flex-container">');
                            doc.consulta(PRM_VALOR,'P',WS_TIPUSER);
                        htp.p('</ul>');

            htp.p('</div>');
       
    END DOC_PRIVATE;

    PROCEDURE CONSULTA (PRM_VALOR   VARCHAR2 DEFAULT NULL,
                        PRM_CLASSE  VARCHAR2 DEFAULT NULL,
                        PRM_TIPUSER VARCHAR2 DEFAULT NULL) AS

        WS_USUARIO	 VARCHAR2(80);
        WS_CATEGORIA VARCHAR2(80) := 'N/A';
        WS_VALOR     VARCHAR2(1000);
        WS_CLASSE    VARCHAR2(2);
        
        WS_COUNT NUMBER := 0;
        TYPE WS_LINHAS IS TABLE OF DOC_PERGUNTAS%ROWTYPE;
        WS_LINHA WS_LINHAS;
        WS_WHERE VARCHAR2(800);
        WS_LIMIT VARCHAR2(200);
        WS_PAG NUMBER :=0;

        -------------------------------------
        -------------------------------------
        ---------PARAMETROS CLASSE ----------
        ---- P = DOCUMENTAÇÃO INTERNA -------
        ---- D = DOCUMENTAÇÃO PÚBLICA -------
        ---- F = FAQ-DÚVIDAS FREQUENTES -----
        -------------------------------------
        -------------------------------------

    BEGIN

        WS_VALOR:= DOC.TRADUZIR(LOWER(NVL(PRM_VALOR,'')));            
        ws_where := replace(trim(WS_VALOR), ' ', '%'' or DOC.TRADUZIR(lower(pergunta)) like ''%');

        if length(ws_valor) > 3 then
            ws_where := 'DOC.TRADUZIR(lower(pergunta)) like ''%'||ws_where||'%''';
        else
            ws_where := 'DOC.TRADUZIR(lower(pergunta)) like '||chr(39)||ws_where||'%''';
        end if;

        ws_limit := ' order by categoria asc,ordem_categoria asc,cd_pergunta asc ' ;
            
            IF nvl(PRM_TIPUSER,'T') <> 'T' THEN
                execute immediate 'select * from doc_perguntas where id_visualizacao like ''%T%'' and tp_usuario IN('||chr(39)||nvl(PRM_TIPUSER,'T')||chr(39)||','||chr(39)||'T'||chr(39)||') and classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
            ELSE
                execute immediate 'select * from doc_perguntas where id_visualizacao like ''%T%'' and classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
            END IF;
            
            FOR i in 1..ws_linha.COUNT

                LOOP			

                    IF (WS_CATEGORIA<>WS_LINHA(I).CATEGORIA) THEN			   
                        
                        IF WS_CATEGORIA<>'N/A' THEN
                            HTP.P('</UL>');
                                HTP.P('</LI>');
                        END IF;
                        HTP.P('<LI CLASS="flex-categorias" TITLE="'||WS_LINHA(I).CATEGORIA||'">');
                            
                            HTP.P('<UL CLASS ="">');
                                WS_CATEGORIA:=WS_LINHA(I).CATEGORIA;					
                    END IF;

                        htp.p('<li>');
                            htp.p('<span class="flex-perguntas"><img src="dwu.fcl.download?arquivo=mais.png" class="mais" />'||ws_linha(i).pergunta||'</span>');

                            if prm_classe <> 'F' then
                                htp.p('<span class="flex-resposta">'||ws_linha(i).resposta||'<a class ="ler-mais" title="'||ws_linha(i).cd_pergunta||'">Ler mais</a></span>');                        
                            else
                                htp.p('<span class="flex-resposta-faq">'||ws_linha(i).resposta||'</span>');
                            end if;

                        htp.p('</li>');
                
                END LOOP;

    EXCEPTION
        WHEN OTHERS THEN

            HTP.P(DBMS_UTILITY.FORMAT_ERROR_STACK||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            INSERT INTO BI_LOG_SISTEMA VALUES (SYSDATE, DBMS_UTILITY.FORMAT_ERROR_STACK||' -- '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||' -- '||WS_WHERE||'--'||WS_LIMIT, WS_USUARIO, 'ERRO');	
            COMMIT;

    END CONSULTA;

    PROCEDURE DETALHE_PERGUNTA (    PRM_VALOR VARCHAR2 DEFAULT NULL, 
                                    PRM_VERSAO VARCHAR2 DEFAULT NULL,
                                    PRM_TIPUSER VARCHAR2 DEFAULT NULL) AS

        WS_USUARIO		VARCHAR2(80);
        WS_CSS			VARCHAR2(80);
        WS_DETALHES 	CLOB;
        WS_PERGUNTA		VARCHAR2(1000);
        WS_CATEGORIA	VARCHAR2(80);
        WS_PERGUNTA_REL	VARCHAR2(1000);
        WS_VERSAO       VARCHAR2(80);
        WS_CLASSE       VARCHAR2(3);
        WS_LINK_PAG     VARCHAR2(100);

    BEGIN

        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

        htp.p('<div class="spinner"></div>');
        
        htp.p('<div class="main-conteudo">');
            
            htp.p('<div class="menu-lateral-conteudo">');
                if gbl.getusuario <> 'NOUSER' then 
                    MONTA_MENU_LATERAL(0, 1, 2);
                end if;     
            htp.p('</div>');

            htp.p('<div class="fundo-conteudo">');
                SELECT DETALHES,PERGUNTA,CATEGORIA,VERSAO,CLASSE 
                    INTO WS_DETALHES,WS_PERGUNTA,WS_CATEGORIA,WS_VERSAO,WS_CLASSE 
                    FROM 
                    (   SELECT t1.DETALHES DETALHES,T2.PERGUNTA PERGUNTA,T2.CATEGORIA CATEGORIA,T1.VERSAO VERSAO ,T2.CLASSE
                            FROM DOC_DETALHES T1
                            LEFT JOIN DOC_PERGUNTAS T2 
                            ON T2.CD_PERGUNTA = T1.CD_PERGUNTA
                            WHERE T2.CD_PERGUNTA = PRM_VALOR
                            AND T1.VERSAO      = NVL(prm_versao,T1.VERSAO) 
                            ORDER BY T1.VERSAO DESC
                    )
                    WHERE ROWNUM = 1; 
                
                htp.p('<div class="detalhe-conteudo">');
                    
                    htp.p('<span class="detalhe-pergunta">'||WS_PERGUNTA||'</span>');
                    htp.p('<span class="detalhe-resposta">'||WS_DETALHES||'</span>');

                htp.p('</div>');

                htp.p('<div class="detalhe-conteudo2">');
                                                            
                    htp.p('<div class= "voto">');

                        htp.p('<span class="detalhe-pesquisa">Esse artigo foi &uacute;til?</span>');
                        htp.p('<img src="dwu.fcl.download?arquivo=sim.png" title="Sim" class="resp-sim votacao" />');

                        htp.p('<img src="dwu.fcl.download?arquivo=nao.png" title="Nao" class="resp-nao votacao" />');
                        
                    htp.p('</div>');
                    htp.p('<span class="cxmsg">Obrigado pelo seu feedback.</span>');

                    htp.p('<span class="relacionados">Artigos relacionados</span>');
                    htp.p('<ul id="perg-rel">');

                        IF PRM_TIPUSER <> 'T' THEN

                            FOR I IN (SELECT CD_PERGUNTA,PERGUNTA FROM DOC_PERGUNTAS 
                                        WHERE ID_VISUALIZACAO LIKE '%T%' 
                                          AND CATEGORIA   = WS_CATEGORIA 
                                          AND CLASSE      = WS_CLASSE 
                                          AND CD_PERGUNTA <> PRM_VALOR
                                          AND TP_USUARIO IN (NVL(PRM_TIPUSER,'T'),'T')  
                                        ORDER BY CD_PERGUNTA ) 
                                LOOP
                                    htp.p('<img src="dwu.fcl.download?arquivo=seta-doc.png" class="seta" />');
                                    htp.p('<li class="lista-pergunta" title="'||I.CD_PERGUNTA||'">'||I.PERGUNTA||'</li>');
                                END LOOP;

                        ELSE

                            FOR I IN (SELECT CD_PERGUNTA,PERGUNTA FROM DOC_PERGUNTAS 
                                        WHERE ID_VISUALIZACAO LIKE '%T%' 
                                          AND CATEGORIA   = WS_CATEGORIA 
                                          AND CLASSE      = WS_CLASSE 
                                          AND CD_PERGUNTA <> PRM_VALOR 
                                        ORDER BY CD_PERGUNTA ) 
                                LOOP
                                    htp.p('<img src="dwu.fcl.download?arquivo=seta-doc.png" class="seta" />');
                                    htp.p('<li class="lista-pergunta" title="'||I.CD_PERGUNTA||'">'||I.PERGUNTA||'</li>');
                                END LOOP;

                        END IF;

                    htp.p('</ul>');
                    
                htp.p('</div>');    -- detalhe-conteudo2
            htp.p('</div>');        -- fundo-conteudo 
        htp.p('</div>');            -- principal-conteudo 

    END DETALHE_PERGUNTA;


    PROCEDURE MONTA_MENU_LATERAL  ( PRM_PERGUNTA_PAI VARCHAR2,
                                    PRM_NIVEL        NUMBER,
                                    PRM_NIVEL_ABERTO NUMBER ) AS
        WS_MOSTRAR VARCHAR2(300);
        WS_IMG     VARCHAR2(300);
    BEGIN
        
        IF PRM_NIVEL <= PRM_NIVEL_ABERTO THEN 
            WS_MOSTRAR := ' class="menu-lateral-aberto"';
        ELSE     
            WS_MOSTRAR := ' class="menu-lateral-fechado"';
        END IF;

        HTP.P('<ul '||WS_MOSTRAR||'>');

        
        FOR A IN (SELECT A.NR_ORDEM, A.CD_PERGUNTA, B.PERGUNTA, (SELECT COUNT(*) FROM DOC_ESTRUTURA C WHERE C.CD_PERGUNTA_PAI = A.CD_PERGUNTA) as QT_FILHO 
                    FROM DOC_ESTRUTURA A, DOC_PERGUNTAS B 
                   WHERE B.CD_PERGUNTA     = A.CD_PERGUNTA
                     AND B.ID_VISUALIZACAO LIKE '%M%'
                     AND A.CD_PERGUNTA_PAI = PRM_PERGUNTA_PAI 
                    ORDER BY A.NR_ORDEM, B.PERGUNTA ) loop
            IF A.QT_FILHO = 0 THEN 
                WS_IMG := '';
            ELSE
                IF PRM_NIVEL < PRM_NIVEL_ABERTO THEN
                    WS_IMG    := ' <img src="dwu.fcl.download?arquivo=menos.png" class="menu-lateral-aberto">';
                ELSE 
                    WS_IMG    := ' <img src="dwu.fcl.download?arquivo=mais.png" class="menu-lateral-fechado">';
                END IF;     
            END IF;

            HTP.P('<li data-nivel="'||prm_nivel||'" style="padding-left: '||PRM_NIVEL*20||'px;">'); 
            HTP.P('<span class="menu-lateral-item" data-pergunta="'||a.CD_PERGUNTA||'">'||WS_IMG||'-'||a.CD_PERGUNTA||'-'||A.PERGUNTA||'</span>');
            HTP.P('</li>');                        
            --HTP.P('<li><span class="menu-lateral-item"><img src="dwu.fcl.download?arquivo=mais.png" class="menu-lateral-mais">CRIAÇÃO DE UM OBJETO BROWSER</span></li>');
            IF A.QT_FILHO > 0 THEN 
                DOC.MONTA_MENU_LATERAL  (A.CD_PERGUNTA, PRM_NIVEL + 1, PRM_NIVEL_ABERTO);
            END IF; 
        END LOOP;

        HTP.P('</ul>');                       

    END MONTA_MENU_LATERAL; 



    PROCEDURE RANK_PERGUNTAS (  PRM_VALOR                VARCHAR2 DEFAULT NULL, 
                                PRM_PERGUNTA             VARCHAR2 DEFAULT NULL) AS
    
    BEGIN
        
        UPDATE DOC_PERGUNTAS 
           SET 
            RANK_PERGUNTAS  = DECODE(upper(PRM_VALOR), 'SIM', RANK_PERGUNTAS+1, 'NAO', RANK_PERGUNTAS-1)
         WHERE 
            CD_PERGUNTA     = PRM_PERGUNTA;
        COMMIT;
    
        htp.p('!!!');
      
    END RANK_PERGUNTAS;

    FUNCTION TRADUZIR (PRM_TEXTO VARCHAR2) RETURN VARCHAR2 AS
       
        WS_TRANSLATE VARCHAR2(1000);
        
    BEGIN

        WS_TRANSLATE:= TRANSLATE( PRM_TEXTO,'ÁÇÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕËÜáçéíóúàèìòùâêîôûãõëü',
                                            'ACEIOUAEIOUAEIOUAOEUaceiouaeiouaeiouaoeu');

        RETURN(WS_TRANSLATE);

    END TRADUZIR;

END DOC;
/
SHOW ERROR;