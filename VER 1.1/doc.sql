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
                    htp.p('<script>gopage=document.getElementById(''prm_externo'');chamar(''detalhe_pergunta'',gopage.getAttribute(''data-search''),'''',gopage.getAttribute(''data-usuario''),'''',''S'');</script>');
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

    EXCEPTION
        WHEN OTHERS THEN

            INSERT INTO BI_LOG_SISTEMA VALUES (SYSDATE, 'DOC_PUBLIC: '|| DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'DWU', 'ERRO');	
            COMMIT;

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
        WS_LIBERADO    VARCHAR2(200);

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

        
        if gbl.getNivel = 'A' then 
            ws_liberado := ' ';
        else    
            ws_liberado := ' id_liberado = ''S'' and ';
        end if; 

        ws_limit := ' order by categoria asc,ordem_categoria asc,cd_pergunta asc ' ;

            IF nvl(PRM_TIPUSER,'T') <> 'T' THEN
                execute immediate 'select * from doc_perguntas where '||ws_liberado||' tp_usuario IN('||chr(39)||nvl(PRM_TIPUSER,'T')||chr(39)||','||chr(39)||'T'||chr(39)||') and classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
            ELSE
                execute immediate 'select * from doc_perguntas where '||ws_liberado||' classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
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

        ws_usuario		varchar2(80);
        ws_css			varchar2(80);
        ws_detalhes 	clob;
        ws_pergunta		varchar2(1000);
        ws_categoria	varchar2(80);
        ws_pergunta_rel	varchar2(1000);
        ws_versao       varchar2(80);
        ws_classe       varchar2(3);
        ws_link_pag     varchar2(100);
        ws_conteudo     clob;
        ws_cd_pai       number;
        ws_ds_pai       varchar2(200);
        ws_ds_titulo    varchar2(1000);
        ws_count        number;
        ws_cd_aux       number; 

    BEGIN

        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

        htp.p('<div class="spinner"></div>');
        
        htp.p('<div class="main-conteudo">');
            
            htp.p('<div class="menu-lateral-conteudo">');
                htp.p('<div id="menu-lateral-scroll" class="menu-lateral-scroll">');
                    if gbl.getusuario <> 'NOUSER' then 
                        doc.MONTA_MENU_LATERAL(0, 1, 2);
                    end if;     
                htp.p('</div>');    
            htp.p('</div>');

            htp.p('<div id="fundo-conteudo" class="fundo-conteudo">');
                select detalhes,pergunta,categoria,versao,classe into ws_detalhes,ws_pergunta,ws_categoria,ws_versao,ws_classe
                  from ( select t1.detalhes detalhes,t2.pergunta pergunta,t2.categoria categoria,t1.versao versao ,t2.classe
                           from doc_detalhes t1
                           left join doc_perguntas t2  on t2.cd_pergunta = t1.cd_pergunta
                          where t2.cd_pergunta = prm_valor
                            and t1.versao      = nvl(prm_versao,t1.versao) 
                         order by t1.versao desc
                       )
                    where rownum = 1; 

                ws_ds_titulo := ws_pergunta; 
                ws_cd_aux    := prm_valor;
                ws_count     := 0;
                while ws_count < 20  loop
                    select max(t2.cd_pergunta_pai), max(t1.pergunta) into ws_cd_pai, ws_ds_pai 
                      from doc_perguntas t1, doc_estrutura t2 
                      where t1.cd_pergunta = t2.cd_pergunta_pai and t2.cd_pergunta = ws_cd_aux ;
                    if ws_cd_pai is null then 
                        ws_count := 20;
                    else 
                        ws_cd_aux    := ws_cd_pai;
                        ws_ds_titulo := ws_ds_pai||' > '||ws_ds_titulo;
                    end if;  
                    ws_count := ws_count + 1;
                end loop;   
                
                if gbl.getusuario <> 'NOUSER' then 
                    ws_conteudo := null;
                    doc.monta_html_conteudo(prm_valor, ws_conteudo);
                    if ws_conteudo is not null then 
                        ws_detalhes := ws_conteudo;
                    end if;     
                end if; 
                                
                htp.p('<div class="detalhe-conteudo">');
                    
                    htp.p('<span class="detalhe-pergunta">'||ws_ds_titulo||'</span>');
                    htp.p('<span class="detalhe-resposta  resposta_conteudo">'||WS_DETALHES||'</span>');

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
                                        WHERE ( ID_LIBERADO = 'S' or gbl.getNivel = 'A' )
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
                                        WHERE (ID_LIBERADO = 'S' or gbl.getNivel = 'A')
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

            htp.p('<div class="bloco-direito-conteudo"></div>');

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
                     AND (B.ID_LIBERADO = 'S' or gbl.getNivel = 'A') 
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
            HTP.P('<span class="menu-lateral-item" data-pergunta="'||a.CD_PERGUNTA||'">'||WS_IMG||A.PERGUNTA||'</span>');
            HTP.P('</li>');                        
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

    procedure monta_html_conteudo ( prm_pergunta     varchar2,
                                    prm_conteudo out clob ) as
        ws_conteudo clob;
        ws_tag_i       varchar2(4000);
        ws_tag_f       varchar2(10);
        ws_class       varchar2(4000);
        ws_class2      varchar2(4000);
        ws_class_tot   varchar2(32000);
        ws_styles      varchar2(32000);
        ws_texto       clob; 
        ws_url_doc     varchar2(200); 
        
        ws_marcador_nivel   integer;
        ws_marcador_ante    integer;
        ws_marcador_atual   integer;
        ws_count            integer;
        ws_qt_conteudo      integer;

    begin
        ws_conteudo         := null;
        ws_class_tot        := null;
        ws_marcador_ante    := 0;
        ws_qt_conteudo      := 0;
        select max(conteudo) into ws_url_doc from doc_variaveis where variavel = 'URL_DOC';

        for a in (select * from doc_conteudos where cd_pergunta = prm_pergunta and upper(id_ativo) = 'S' order by sq_conteudo) loop
            ws_qt_conteudo := ws_qt_conteudo + 1;
            ws_tag_i       := null;
            ws_tag_f       := null;
            ws_texto       := a.ds_texto; 

            -- Fecha marcadores abertos 
            if a.tp_conteudo not like 'MARCADOR%' and ws_marcador_ante > 0 then 
                ws_conteudo      := ws_conteudo||RPAD('</ul>', (5*ws_marcador_ante), '</ul>');
                ws_marcador_ante := 0;
            end if;  

            -- Coloca linhas em branco 
            if a.nr_linhas_antes > 0 then 
                ws_conteudo := ws_conteudo || RPAD('<br>', (4*a.nr_linhas_antes), '<br>');
            end if; 

            -- Monta class/estilo do elemento 
            ws_class := null;
            if a.id_estilo is not null then 
                ws_class     := ' class="'||replace(a.id_estilo,'|',' ')||'"';
                ws_class_tot := replace(ws_class_tot, a.id_estilo||'|','');
                ws_class_tot := ws_class_tot||'|'||a.id_estilo||'|';
            end if; 

            -- Define o tipo de elemento 
            if a.tp_conteudo = 'PARAGRAFO' then 
                ws_tag_i            := '<p>';
                ws_tag_f            := '</p>';
            elsif a.tp_conteudo = 'LINHA' then 
                ws_tag_i := '<hr>';
                ws_tag_f := '';
            elsif a.tp_conteudo like 'MARCADOR%' then  
                ws_marcador_atual
                 := replace(a.tp_conteudo,'MARCADOR','');
                if ws_marcador_atual > ws_marcador_ante then
                    ws_tag_i            := '<ul class="'||a.tp_conteudo||'">';
                elsif ws_marcador_atual < ws_marcador_ante then                    
                    ws_tag_i          :=  RPAD('</ul>', (5*(ws_marcador_ante-ws_marcador_atual)), '</ul>');   -- Fecha os marcadores anteriores 
                    ws_marcador_atual := ws_marcador_ante-ws_marcador_atual;
                end if;     

                ws_tag_i := ws_tag_i||'<li><span>'||a.ds_titulo||'&nbsp;</span>';
                ws_tag_f := '</li>';

                ws_marcador_ante := ws_marcador_atual; 
            elsif a.tp_conteudo like 'IMAGEM' then  
                -- Alinhamento não funciona em objeto IMG, alinha um span externo 
                ws_class2 := null;
                select max(lower(css_estilo)) into ws_class2 
                  from doc_estilos 
                 where id_estilo in (select column_value from table(fun.vpipe(a.id_estilo)))
                   and lower(css_estilo) like '%text-align%'; 
                if ws_class2 is not null then    
                    ws_class2 := substr(ws_class2,instr(ws_class2,'text-align:',1,1), 100);
                    ws_class2 := substr(ws_class2,1,instr(ws_class2,';',1,1));
                    ws_class2 := 'style="display: block ruby; '||ws_class2||'"';
                end if; 
                ws_tag_i            := '<span '||ws_class2||'><img '||ws_class||' src="dwu.fcl.download?arquivo='||a.ds_titulo||'"></span>';
                ws_tag_f            := null;
                ws_texto            := null;
                ws_class            := null;
            elsif a.tp_conteudo like 'LINK' then  
                ws_tag_i            := '<a class="'||ws_class||'" href="'||a.ds_titulo||'" target="_blank">';
                ws_tag_f            := '</a>';
            elsif a.tp_conteudo like 'PERGUNTA' then  
                ws_tag_i            := '<a class="'||ws_class||'" href="'||ws_url_doc||'.doc.main?prm_externo='||a.ds_titulo||'" target="_blank">';
                ws_tag_f            := '</a>';
            end if; 

            if ws_class is not null then 
                ws_tag_i := replace(ws_tag_i,'>',ws_class||'>');
            end if; 

            doc.formatar_texto_html(a.cd_pergunta, ws_texto);

            ws_conteudo := ws_conteudo||ws_tag_i||ws_texto||ws_tag_f;

        end loop;
        
        -- Fecha marcadores abertos 
        if ws_marcador_ante > 0 then 
            ws_conteudo :=  ws_conteudo||RPAD('</ul>', (5*ws_marcador_ante), '</ul>');
        end if;  

        if ws_qt_conteudo > 0 then 
            ws_styles := '<style id="style-conteudo">';
            for a in (select id_estilo, css_estilo from doc_estilos order by id_estilo ) loop
                ws_styles := ws_styles||' .'||a.id_estilo||' {'||a.css_estilo||'} ';
            end loop;
            ws_styles := ws_styles ||'</style>';
            
            prm_conteudo := ws_styles||' '||ws_conteudo; 
        else 
            prm_conteudo := null;
        end if;     

    exception
        when others then
            insert into bi_log_sistema values (sysdate, 'monta_html_conteudo: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    END monta_html_conteudo; 



    -----------------------------------------------------------------------------------------------------------------------------------------------
    procedure formatar_texto_html ( prm_pergunta         varchar2,
                                    prm_texto     in out clob ) as
        ws_retorno          varchar2(32000);
        ws_url_doc          VARCHAR2(200); 
        ws_qt_formatar      integer; 
        ws_formatar         varchar2(32000);
        ws_formato          varchar2(1000);
        ws_texto            varchar2(32000);
        ws_idx              integer;
        ws_class            varchar2(1000);
        ws_link             varchar2(1000);
        ws_img              varchar2(1000);
        ws_perg             varchar2(1000);
        ws_html             varchar2(32000);      

        ws_raise_fim        exception;
    begin

        ws_qt_formatar := regexp_count(prm_texto, '<DOCF');
        ws_retorno     := prm_texto;
        select max(conteudo) into ws_url_doc from doc_variaveis where variavel = 'URL_DOC';

        if ws_qt_formatar = 0 then 
            raise ws_raise_fim;
        end if;     

        ws_idx := 0; 
        while ws_idx < ws_qt_formatar loop
            ws_idx := ws_idx + 1;

            ws_formatar := substr(prm_texto, instr(prm_texto, '<DOCF', 1, ws_idx),1000000);
            ws_formatar := substr(ws_formatar, 1, instr(ws_formatar, '</DOCF>', 1, 1) + 6);  

            ws_retorno := replace(ws_retorno, ws_formatar, '[#DOCF99#]');
            
            ws_texto    := ws_formatar;  
            ws_texto    := substr(ws_texto, instr(ws_texto, '>', 1, 1)+1,1000000);  
            ws_texto    := substr(ws_texto, 1, instr(ws_texto, '</DOCF>', 1, 1)-1);  

            ws_formato := replace(ws_formatar,'<DOCF ','');
            ws_formato := substr(ws_formato,1,instr(ws_formato,'>',1,1)-1)||' ' ;

            ws_class := null;
            if instr(ws_formato, 'CLASSE=') > 0 then 
                ws_class     := substr(ws_formato, instr(ws_formato, 'CLASSE=', 1, 1)+7, 100000);
                ws_class     := substr(ws_class, 1, instr(ws_class, ' ', 1, 1)-1);
                ws_class     := upper(replace(ws_class,'|', ' '));
            end if;    

            ws_link := null;
            if instr(ws_formato, 'LINK=') > 0 then 
                ws_link     := substr(ws_formato, instr(ws_formato, 'LINK=', 1, 1)+5, 100000);
                ws_link     := substr(ws_link, 1, instr(ws_link, ' ', 1, 1)-1);
                ws_link     := replace(ws_link,'|', ' ');
            end if;    

            ws_perg := null;
            if instr(ws_formato, 'PERG=') > 0 then 
                ws_perg     := substr(ws_formato, instr(ws_formato, 'PERG=', 1, 1)+5, 100000);
                ws_perg     := substr(ws_perg, 1, instr(ws_perg, ' ', 1, 1)-1);
                ws_perg     := replace(ws_perg,'|', ' ');
            end if;    

            ws_img := null;
            if instr(ws_formato, 'IMG=') > 0 then 
                ws_img     := substr(ws_formato, instr(ws_formato, 'IMG=', 1, 1)+4, 100000);
                ws_img     := substr(ws_img, 1, instr(ws_img, ' ', 1, 1)-1);
                ws_img     := replace(ws_img,'|', ' ');
            end if;    

            if ws_img is not null then 
                ws_img := 'dwu.fcl.download?arquivo='||ws_img; 
                ws_html := '<img class="'||ws_class||'" src="'||ws_img||'">';
            else     
                ws_html := ws_texto; 
            end if;     

            if ws_perg is not null then 
                ws_perg := ws_url_doc||'.doc.main?prm_externo='||ws_perg; 
                ws_html := '<a class="'||ws_class||'" href="'||ws_perg||'" target="_blank">'||ws_html||'</a>';
            elsif ws_link is not null then 
                ws_html := '<a class="'||ws_class||'" href="'||ws_link||'" target="_blank">'||ws_html||'</a>';
            else 
                ws_html := '<span class="'||ws_class||'">'||ws_html||'</span>';
            end if; 

            ws_retorno := replace(ws_retorno,'[#DOCF99#]',ws_html);

        end loop;

        prm_texto := ws_retorno;

    exception 
        when ws_raise_fim then 
            null;        
        when others then
            insert into bi_log_sistema values (sysdate, 'monta_html_conteudo: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    end formatar_texto_html; 

END DOC;
/
SHOW ERROR;