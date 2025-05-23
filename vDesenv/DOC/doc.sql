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
ws_class_cad    varchar2(20);
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
        htp.p('const URL_DOWNLOAD = "dwu.fcl.download?arquivo=";');
    htp.p('</script>');

    htp.p('<!DOCTYPE html>');
    htp.p('<html lang="pt-br">');
            
        htp.p('<head>');

            htp.p('<link rel="favicon" href="dwu.fcl.download?arquivo=upquery-icon.png"/>');
            htp.p('<link rel="shortcut icon" href="dwu.fcl.download?arquivo=upquery-icon.png"/>');
            htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo=doc.css"/>' );
            htp.p('<script src="dwu.fcl.download?arquivo=doc.js"></script>');
            --htp.p('<script src="dwu.fcl.download?arquivo=pdf-min.js"></script>');
            htp.p('<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"></script>');
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

            htp.p('<ul id="feed-fixo"></ul>');
            htp.p('<ul style="display: none;" id="alerta-template">');
                htp.p('<li>');
                    htp.p('<span></span>');
                    htp.p('<a onclick="var template = this.parentNode; template.classList.add(''clicked''); setTimeout(function(){ template.parentNode.removeChild(template); }, 300);">'||fun.lang('FECHAR')||'</a>');
                    htp.p('<span style="display: none;" onclick="this.nextElementSibling.classList.toggle(''show'');">mais detalhes</span>');
                    htp.p('<span></span>');
                htp.p('</li>');
            htp.p('</ul>');

            htp.p('<div id="header_doc_variaveis" style="display: none;" '); 
                for a in (select variavel, conteudo from doc_variaveis) loop
                    htp.p('data-'||a.variavel||'="'||a.conteudo||'" '); 
                end loop;
            htp.p('></div>'); 
            
            if nvl(prm_externo,'.') <> 'CADASTRO' THEN
                htp.p('<div class="header-doc">');  
                    ws_usuario := nvl(UPPER(gbl.getusuario),'N/A');
                    htp.p('<img src="dwu.fcl.download?arquivo=logo-upquery-01.png" class="retorna-princ" tittle ="Logotipo do produto UpQuery"/>');
                        htp.p('<a class="go-faq">Central de Ajuda</a>');
                        htp.p('<a class="go-doc-public">Documenta&ccedil;&atilde;o</a>');
                        if upper(trim(ws_usuario)) <> 'NOUSER' then
                            htp.p('<a class="go-doc-private" id="'||ws_usuario||'">Doc. Interna</a>');
                        end if;
                        if upper(trim(ws_usuario)) <> 'NOUSER' then
                            htp.p('<a class="go-doc-cadastro" id="cad_'||ws_usuario||'">Cadastro</a>');
                        end if;
                htp.p('</div>');
            end if;

            htp.p('<div class="spinner"></div>');

            -- Condição criada para quando a DOC for chamada pelo BI 23/11/22
            ws_class_cad := '';
            IF PRM_EXTERNO IS NOT NULL THEN
                IF PRM_EXTERNO = 'CADASTRO' THEN
                    ws_class_cad := ' cadastro';
                    htp.p('<script>chamar(''doc_cad_conteudo'','''','''','''','''',''N'');</script>');
                else 
                    ws_tipouser:=prm_usuario;
                    ws_externo:=prm_externo;
                    htp.p('<a id="prm_externo" data-usuario="'||ws_tipouser||'" data-search="'||ws_externo||'"></a>');
                    htp.p('<script>gopage=document.getElementById(''prm_externo'');chamar(''detalhe_pergunta'',gopage.getAttribute(''data-search''),'''',gopage.getAttribute(''data-usuario''),'''',''S'');</script>');
                    ws_tipouser:='';
                    ws_externo:='';
                end if; 
            END IF;
            
                                            
            htp.p('<div class="main'||ws_class_cad||'">');

                doc.principal;

            htp.p('</div>');

            if prm_externo <> 'CADASTRO' then
                htp.p('<div class="footer-doc">');
                    htp.p('<span>');
                        htp.p('<a class="links" title="WhatsApp" href="https://wa.me/message/DWVS7MC4FU2RF1"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="sociais" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><g><g><path d="M440.164,71.836C393.84,25.511,332.249,0,266.737,0S139.633,25.511,93.308,71.836S21.473,179.751,21.473,245.263    c0,41.499,10.505,82.279,30.445,118.402L0,512l148.333-51.917c36.124,19.938,76.904,30.444,118.403,30.444    c65.512,0,127.104-25.512,173.427-71.836C486.488,372.367,512,310.776,512,245.263S486.488,118.16,440.164,71.836z     M266.737,460.495c-38.497,0-76.282-10.296-109.267-29.776l-6.009-3.549L48.952,463.047l35.878-102.508l-3.549-6.009    c-19.479-32.985-29.775-70.769-29.775-109.266c0-118.679,96.553-215.231,215.231-215.231s215.231,96.553,215.231,215.231    C481.968,363.943,385.415,460.495,266.737,460.495z"/></g></g><g><g><path d="M398.601,304.521l-35.392-35.393c-11.709-11.71-30.762-11.71-42.473,0l-13.538,13.538    c-32.877-17.834-60.031-44.988-77.866-77.865l13.538-13.539c5.673-5.672,8.796-13.214,8.796-21.236    c0-8.022-3.124-15.564-8.796-21.236l-35.393-35.393c-5.672-5.672-13.214-8.796-21.236-8.796c-8.023,0-15.564,3.124-21.236,8.796    l-28.314,28.314c-15.98,15.98-16.732,43.563-2.117,77.664c12.768,29.791,36.145,62.543,65.825,92.223    c29.68,29.68,62.432,53.057,92.223,65.825c16.254,6.965,31.022,10.44,43.763,10.44c13.992,0,25.538-4.193,33.901-12.557    l28.314-28.314c5.673-5.672,8.796-13.214,8.796-21.236S404.273,310.193,398.601,304.521z M349.052,354.072    c-6.321,6.32-23.827,4.651-44.599-4.252c-26.362-11.298-55.775-32.414-82.818-59.457c-27.043-27.043-48.158-56.455-59.457-82.818    c-8.903-20.772-10.571-38.278-4.252-44.599l28.315-28.314l35.393,35.393l-28.719,28.719l4.53,9.563    c22.022,46.49,59.753,84.221,106.244,106.244l9.563,4.53l28.719-28.719l35.393,35.393L349.052,354.072z"/></g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg></a>');                        
                        htp.p('<a class="links" title="Instagram" href="https://www.instagram.com/upquery/"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" id="sociais" feather-instagram"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.5" y2="6.5"/></svg></a>');
                        htp.p('<a class="links" title="LinkedIn" href="https://www.linkedin.com/company/upquery-do-brasil/"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" id="sociais"><path d="m437 0h-362c-41.355469 0-75 33.644531-75 75v362c0 41.355469 33.644531 75 75 75h362c41.355469 0 75-33.644531 75-75v-362c0-41.355469-33.644531-75-75-75zm45 437c0 24.8125-20.1875 45-45 45h-362c-24.8125 0-45-20.1875-45-45v-362c0-24.8125 20.1875-45 45-45h362c24.8125 0 45 20.1875 45 45zm0 0"/><path d="m91 422h90v-212h-90zm30-182h30v152h-30zm0 0"/><path d="m331.085938 210c-.027344 0-.058594 0-.085938 0-10.371094 0-20.472656 1.734375-30 5.101562v-5.101562h-90v212h90v-107c0-8.269531 6.730469-15 15-15s15 6.730469 15 15v107h90v-117.3125c0-48.546875-39.382812-94.640625-89.914062-94.6875zm59.914062 182h-30v-77c0-24.8125-20.1875-45-45-45s-44.996094 20.1875-45 44.996094v77.003906h-30v-152h30v30.019531l24.007812-18.03125c10.441407-7.84375 22.886719-11.988281 35.992188-11.988281h.058594c31.929687.03125 59.941406 30.257812 59.941406 64.6875zm0 0"/><path d="m91 180h90v-90h-90zm30-60h30v30h-30zm0 0"/></svg></a>');
                    htp.p('</span>');

                    htp.p('<span >');
                        htp.p('<a class="links" href="https://www.upquery.com">2021 © UpQuery do Brasil</a>');
                    htp.p('</span>');

                    htp.p('<span >');
                        htp.p('<a class="links" href="https://www.upquery.com/politica-de-privacidade">Pol&iacute;tica de Privacidade | </a>');
                        htp.p('<a class="links" href="https://www.upquery.com/termos-de-uso">Termos de Uso</a>');
                    htp.p('</span>');
                htp.p('</div>');
            end if;            
            htp.p('<div id="loadingscreens">');					
            htp.p('</div>');

        htp.p('</body>');

END MAIN;

------------------------------------------------------------------------------------------------------------------------------
PROCEDURE PRINCIPAL (PRM_VALOR VARCHAR2 DEFAULT NULL) AS
BEGIN
    htp.p('<div class="apresentation">');
        if instr(owa_util.get_cgi_env('HTTP_USER_AGENT'), 'iPhone') = 0 and instr(owa_util.get_cgi_env('HTTP_USER_AGENT'), 'Android') = 0 then
            htp.p('<img src="dwu.fcl.download?arquivo=doc_apresentation_main.png" class="bgmenur" />');
        else
            htp.p('<div class="bgmenur" ></div>');
        end if;
    htp.p('</div>');
END PRINCIPAL;


------------------------------------------------------------------------------------------------------------------------------
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

---------------------------------------------------------------------------------------------------------------    
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
    
------------------------------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------------------------------------
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

        ws_limit := ' order by nvl(id_notas_versao,''N'') desc, categoria asc,ordem_categoria asc,cd_pergunta asc ' ;

        IF nvl(PRM_TIPUSER,'T') <> 'T' THEN
            execute immediate 'select * from doc_perguntas where categoria is not null and tp_conteudo <> ''ARQUIVOS'' and '||ws_liberado||' tp_usuario IN('||chr(39)||nvl(PRM_TIPUSER,'T')||chr(39)||','||chr(39)||'T'||chr(39)||') and classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
        ELSE
            execute immediate 'select * from doc_perguntas where categoria is not null and tp_conteudo <> ''ARQUIVOS'' and '||ws_liberado||' classe ='||chr(39)||prm_classe||chr(39)||' and '||lower(ws_where)||ws_limit bulk collect into ws_linha;
        END IF;
        
        FOR i in 1..ws_linha.COUNT LOOP			

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
        ws_classe       varchar2(10);
        ws_link_pag     varchar2(100);
        ws_conteudo     clob;
        ws_cd_pai       number;
        ws_ds_pai       varchar2(200);
        ws_ds_titulo    varchar2(1000);
        ws_count        number;
        ws_cd_aux       number; 
        ws_tp_conteudo  varchar2(20);
        ws_cd_pergunta  varchar2(20);

        ws_raise_erro   exception;
    BEGIN
        if PRM_VALOR = 'VERSIONAMENTO' then 
            select max(cd_pergunta) into ws_cd_pergunta 
              from doc_perguntas 
             where nvl(id_notas_versao,'N') = 'S' 
              and ordem_categoria = (select max(ordem_categoria) from doc_perguntas where nvl(id_notas_versao,'N') = 'S') ;
        else 
            ws_cd_pergunta := PRM_VALOR;
        end if;            

        select nvl(max(tp_conteudo),'HTML'), nvl(max(classe),'X') into ws_tp_conteudo, ws_classe 
          from doc_perguntas where cd_pergunta = ws_cd_pergunta;

        htp.p('<link rel="stylesheet" href="dwu.fcl.download?arquivo='||nvl(ws_css, 'ideativo')||'.css">');

        htp.p('<div class="spinner"></div>');
        
        htp.p('<div class="main-conteudo" data-pergunta="'||ws_cd_pergunta||'">');
            
            htp.p('<div class="menu-lateral-conteudo">');
                htp.p('<div id="menu-lateral-scroll" class="menu-lateral-scroll">');
                    if ws_classe = 'D' then  -- menu somente para documentação do BI
                        doc.MONTA_MENU_LATERAL(0, 1, 2);
                    end if;    
                htp.p('</div>');    
            htp.p('</div>');
            
            htp.p('<div id="fundo-conteudo" class="fundo-conteudo '||lower(ws_tp_conteudo)||'">');

                if ws_classe = 'P' and nvl(gbl.getusuario,'NOUSER') = 'NOUSER' then   -- se for documentação Privada é necessário logon no sistema 

                    htp.p('<div class="detalhe-conteudo">');

                        htp.p('<span class="detalhe-resposta resposta_conteudo">'); 
                            htp.p('<p style="color: #f00;">Acesso bloqueado !</p>');
                            htp.p('<p>Para acesso a essa documenta&ccedil;&atilde;o &eacute; necess&aacute;rio estar logado no BI da base de conhecimento Upquery.</p>');
                            htp.p('<p>Se necess&aacute;rio solicite essa documenta&ccedil;&atilde;o ao nosso suporte.</p>');                                                
                        htp.p('</span>');

                    htp.p('</div>');

                else               

                    select detalhes,pergunta,categoria,versao,classe into ws_detalhes,ws_pergunta,ws_categoria,ws_versao,ws_classe
                    from ( select t1.detalhes detalhes,t2.pergunta pergunta,t2.categoria categoria,t1.versao versao ,t2.classe
                            from doc_detalhes t1
                            left join doc_perguntas t2  on t2.cd_pergunta = t1.cd_pergunta
                            where t2.cd_pergunta = ws_cd_pergunta
                                and t1.versao      = nvl(prm_versao,t1.versao) 
                            order by t1.versao desc
                        )
                        where rownum = 1; 

                    ws_ds_titulo := ws_pergunta; 
                    ws_cd_aux    := ws_cd_pergunta;
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

                    if ws_tp_conteudo = 'ARQUIVOS' then 
                        ws_conteudo := null;
                        doc.monta_conteudo_arquivos(ws_cd_pergunta, ws_conteudo);

                        if ws_conteudo is not null then 
                            ws_detalhes := ws_conteudo;
                        end if;     
                    else 
                        ws_conteudo := null;
                        doc.monta_conteudo_html(ws_cd_pergunta, ws_conteudo);
                        if ws_conteudo is not null then 
                            ws_detalhes := ws_conteudo;
                        end if;     
                    end if;     

                                    
                    htp.p('<div class="detalhe-conteudo">');
                        
                        htp.p('<span class="detalhe-pergunta">'||ws_ds_titulo||'</span>');
                        htp.p('<span class="detalhe-resposta resposta_conteudo '||lower(ws_tp_conteudo)||'">'||WS_DETALHES||'</span>');

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

                            IF NVL(PRM_TIPUSER,'T') = 'T' THEN

                                FOR I IN (SELECT CD_PERGUNTA,PERGUNTA FROM DOC_PERGUNTAS 
                                            WHERE (ID_LIBERADO = 'S' or gbl.getNivel = 'A')
                                            AND CATEGORIA   = WS_CATEGORIA 
                                            AND CLASSE      = WS_CLASSE 
                                            AND CD_PERGUNTA <> ws_cd_pergunta 
                                            ORDER BY CD_PERGUNTA ) 
                                    LOOP
                                        htp.p('<img src="dwu.fcl.download?arquivo=seta-doc.png" class="seta" />');
                                        htp.p('<li class="lista-pergunta" title="'||I.CD_PERGUNTA||'">'||I.PERGUNTA||'</li>');
                                    END LOOP;
                            ELSE 
                                FOR I IN (SELECT CD_PERGUNTA,PERGUNTA FROM DOC_PERGUNTAS 
                                            WHERE ( ID_LIBERADO = 'S' or gbl.getNivel = 'A' )
                                            AND CATEGORIA   = WS_CATEGORIA 
                                            AND CLASSE      = WS_CLASSE 
                                            AND CD_PERGUNTA <> ws_cd_pergunta
                                            AND TP_USUARIO IN (NVL(PRM_TIPUSER,'T'),'T')  
                                            ORDER BY CD_PERGUNTA ) 
                                    LOOP
                                        htp.p('<img src="dwu.fcl.download?arquivo=seta-doc.png" class="seta" />');
                                        htp.p('<li class="lista-pergunta" title="'||I.CD_PERGUNTA||'">'||I.PERGUNTA||'</li>');
                                    END LOOP;
                            END IF;

                        htp.p('</ul>');
                        
                    htp.p('</div>');    -- detalhe-conteudo2
                end if;
            htp.p('</div>');        -- fundo-conteudo 

            if ws_tp_conteudo <> 'ARQUIVOS' then 
                htp.p('<div class="bloco-direito-conteudo"></div>');
            end if;     

        htp.p('</div>');            -- principal-conteudo 

    exception when others then
        null;
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

    procedure monta_conteudo_html ( prm_pergunta     varchar2,
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
            if a.tp_conteudo not like 'MARCADOR%' and a.tp_conteudo <> 'IMAGEM' and ws_marcador_ante > 0 then 
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
            insert into bi_log_sistema values (sysdate, 'monta_conteudo_html: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    END monta_conteudo_html; 



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
            insert into bi_log_sistema values (sysdate, 'formatar_texto_html: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    end formatar_texto_html; 

    
    procedure monta_conteudo_json ( prm_classe    varchar2) as
        cursor c_conteudo is 
            select c.cd_pergunta, p.pergunta ds_sessao, c.ds_titulo, c.ds_texto, c.tp_conteudo 
             from doc_perguntas p, doc_conteudos c
            where p.cd_pergunta = c.cd_pergunta
              and p.classe = decode(prm_classe,'T', p.classe, prm_classe) 
              and c.tp_conteudo <> 'IMAGEM'
            order by c.cd_pergunta, c.sq_conteudo;

        ws_cd_ante doc_perguntas.cd_pergunta%type; 
        ws_ds_conteudo    clob;
        ws_json_total     clob; 
        ws_json_pergunta  clob; 

    begin 
        ws_cd_ante       := null;
        ws_json_pergunta := null;
        for a in c_conteudo loop
            if a.ds_titulo is not null then 
                ws_ds_conteudo := trim(a.ds_titulo||' '||a.ds_texto);
            else 
                ws_ds_conteudo := trim(a.ds_texto);
            end if; 
            ws_ds_conteudo := replace(ws_ds_conteudo,'"',''); 
            
            --doc.formatar_texto_html(a.cd_pergunta, ws_ds_conteudo);
            --ws_ds_conteudo := replace(ws_ds_conteudo,'"', '''');
            --ws_ds_conteudo := replace(ws_ds_conteudo,'dwu.fcl.download?arquivo=','https://cloud.upquery.com/conhecimento/dwu.fcl.download?arquivo=');

            limpar_formatacao (ws_ds_conteudo);

            if a.cd_pergunta = nvl(ws_cd_ante,'-1') then 
                ws_json_pergunta := ws_json_pergunta||' '||ws_ds_conteudo;
            else 
                if ws_cd_ante is not null then 
                    ws_json_pergunta := trim(ws_json_pergunta)||'"},'; 
                end if; 
                ws_json_total    := ws_json_total||ws_json_pergunta;
                ws_json_pergunta := '{"seção": "'||a.ds_sessao||'","conteúdo":"'||ws_ds_conteudo; 
            end if; 
            ws_cd_ante := a.cd_pergunta; 
        end loop;

        if ws_cd_ante is not null then 
            ws_json_pergunta := ws_json_pergunta||'"}'; 
            ws_json_total    := ws_json_total||ws_json_pergunta;
        end if; 
        ws_json_total := '{"documentação": ['||ws_json_total||']}';
        
        ws_json_total := replace(replace(replace(ws_json_total,chr(10),' '),chr(9),' '),chr(11), ' ');

        update doc_json set json = ws_json_total where classe = prm_classe;
        if sql%notfound then 
            insert into doc_json (classe, json) values (prm_classe, ws_json_total);
        end if; 
        commit; 
    end monta_conteudo_json; 

    -----------------------------------------------------------------------------------------------------------------------------------------------
    procedure monta_conteudo_arquivos ( prm_pergunta     varchar2,
                                        prm_conteudo out clob ) as
        ws_conteudo       clob;
        ws_html           clob;
        ws_primeiro_arq   varchar2(300);
        ws_primeiro_tipo  varchar2(20);
        ws_url_doc        varchar2(300);
        ws_link_arquivo   varchar2(300);
        ws_style_load     varchar2(200);
        ws_style_gif      varchar2(200);
        ws_src_pdf        varchar2(200);
        ws_src_gif        varchar2(200);

    begin
        ws_conteudo         := null;
        --select max(conteudo) into ws_url_doc from doc_variaveis where variavel = 'URL_DOC';
        ws_url_doc := 'https://cloud.upquery.com/conhecimento/dwu';

        ws_html         := null;
        ws_primeiro_arq := null;
        for a in (select * from doc_conteudos where cd_pergunta = prm_pergunta and tp_conteudo in ('PDF','GIF') and upper(id_ativo) = 'S' 
                   order by decode(tp_conteudo,'PDF',1,'GIF',2,3), sq_conteudo) loop
            ws_link_arquivo := ws_url_doc||'.fcl.download_tab?prm_arquivo='||a.ds_titulo;
            if ws_primeiro_arq is null then
                ws_primeiro_tipo := a.tp_conteudo;
                ws_primeiro_arq := ws_link_arquivo;
            end if;    
            ws_html := ws_html||'<a class="link-conteudo-arquivo" onclick="carrega_conteudo_arquivo('''||prm_pergunta||''', '''||ws_link_arquivo||''', '''||a.tp_conteudo||''');" title="'||a.ds_texto||'">'||a.ds_texto||'</a>';
        end loop;
        
        -- Monta lista de arquivos 
        ws_conteudo := '<div class="conteudo-arquivos-lista">'||ws_html||'</div>';

        -- Monta bloco para mostrar o conteúo do arquivo
        if ws_primeiro_tipo = 'PDF' then 
            ws_style_load   := ' style="display:flex;"' ;
            ws_style_gif    := ' style="display:none;"' ;
            ws_src_pdf      := 'https://docs.google.com/viewer?url='||ws_primeiro_arq||'&embedded=true';
            ws_src_gif      := '';
        else 
            ws_style_load   := ' style="display:none;"' ;
            ws_style_gif    := ' style="display:block;"' ;
            ws_src_pdf      := '';
            ws_src_gif      := ws_primeiro_arq;
        end if;

        ws_conteudo  := ws_conteudo|| '<div id="pdf-loader" '||ws_style_load||'><div class="spinner"></div></div>'; 
        ws_conteudo  := ws_conteudo|| '<iframe id="iframe_conteudo_arquivo" class="conteudo-arquivo-visualiza" style="display:none;" src="'||ws_src_pdf||'" onload="mostra_conteudo_pdf();" onerror="console.log(''erro carregando pdf'');"></iframe>'; 
        ws_conteudo  := ws_conteudo|| '<img id="img_conteudo_arquivo" class="conteudo-arquivo-visualiza" '||ws_style_gif||' src="'||ws_src_gif||'"></img>'; 
        prm_conteudo := ws_conteudo;


    exception
        when others then
            insert into bi_log_sistema values (sysdate, 'monta_conteudo_arquivos: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    END monta_conteudo_arquivos; 


    -----------------------------------------------------------------------------------------------------------------------------------------------
    procedure limpar_formatacao ( prm_texto     in out clob ) as
        ws_retorno          varchar2(32000);
        ws_qt_formatar      integer; 
        ws_formatar         varchar2(32000);
        ws_idx              integer;

        ws_raise_fim        exception;
    begin

        ws_qt_formatar := regexp_count(prm_texto, '<DOCF');
        ws_retorno     := prm_texto;

        if ws_qt_formatar = 0 then 
            raise ws_raise_fim;
        end if;     

        ws_idx := 0; 
        while ws_idx < ws_qt_formatar loop
            ws_idx := ws_idx + 1;
            ws_formatar := substr(prm_texto, instr(prm_texto, '<DOCF', 1, ws_idx),1000000);
            ws_formatar := substr(ws_formatar, 1, instr(ws_formatar, '>', 1, 1));  
            ws_retorno := replace(ws_retorno, ws_formatar, '');
        end loop;
        
        ws_retorno := replace(ws_retorno,'</DOCF>','');

        prm_texto := ws_retorno;

    exception 
        when ws_raise_fim then 
            null;        
        when others then
            insert into bi_log_sistema values (sysdate, 'limpar_formatacao: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
            commit;

    end limpar_formatacao; 


------------------------------------------------------------------------------------------------------------------------
procedure doc_cad_conteudo (prm_valor 	varchar2 default null) as
   
    ws_cd_pergunta  varchar2(20);
    ws_raise_fim    exception;

begin
    ws_cd_pergunta := prm_valor; 
    ws_cd_pergunta := 236; 

    if nvl(gbl.getusuario,'NOUSER') = 'NOUSER' then 
        htp.p('<div class="cadastro-main">');
            htp.p('<span class="cadastro-main-erro">'); 
                htp.p('<p style="color: #f00;">Acesso bloqueado !</p>');
                htp.p('<p>Para acesso a essa documenta&ccedil;&atilde;o &eacute; necess&aacute;rio estar logado no BI da base de conhecimento Upquery.</p>');
                htp.p('<p>Se necess&aacute;rio solicite essa documenta&ccedil;&atilde;o ao nosso suporte.</p>');                                                
            htp.p('</span>');
        htp.p('</div>');
        raise ws_raise_fim; 
    end if; 

    htp.p('<div class="cadastro-main">');
        doc.conteudo_tela_topicos;
        htp.p('<div id="cadastro-conteudo" class="cadastro-conteudo">');
            htp.p('<div id="cadastro-conteudo-detalhe" class="cadastro-conteudo-detalhe">');
                doc.conteudo_tela_conteudos(ws_cd_pergunta);
            htp.p('</div>'); 
        htp.p('</div>');        
        --htp.p('<div id="cadastro-menu-direito" class="cadastro-menu-direito"></div>');
    htp.p('</div>');

exception 
    when ws_raise_fim then 
        null;
end doc_cad_conteudo;



-----------------------------------------------------------------------------------------------------------------
procedure conteudo_tela_topicos as
    ws_url_doc    varchar2(300);
    ws_checked    varchar2(20);
begin
    -- Obter URL do documento da tabela de variáveis
    select max(conteudo) into ws_url_doc from doc_variaveis where variavel = 'URL_DOC';
    
    -- Criar a tabela na parte esquerda da tela com as perguntas
    htp.p('<div id="cadastro-menu-esquerdo" class="cadastro-menu-esquerdo">');
        htp.p('<div class="cadastro-lista-topico">');
            htp.p('<div class="cadastro-lista-titulo">TÓPICOS</div>');
            htp.p('<table style="width:100%; border-collapse: collapse;">');
                htp.p('<thead>');
                    htp.p('<tr>');
                        htp.p('<th>Cód.</th><th>Descrição</th><th>Categoria</th><th>Ativo</th>');
                    htp.p('</tr>');
                htp.p('</thead>');
                htp.p('<tbody>');
                
                -- Loop através das perguntas na tabela doc_perguntas
                for a in (select cd_pergunta, pergunta, categoria, id_liberado from doc_perguntas order by cd_pergunta desc ) loop
                    htp.p('<tr data-pergunta="'||a.cd_pergunta||'" class="lista-topico-item">');
                        htp.p('<td onclick="conteudo_tela_conteudos('''||a.cd_pergunta||''');">');
                            htp.p('<span>'||a.cd_pergunta||'</span>');
                        htp.p('</td>');

                        htp.p('<td onclick="conteudo_tela_conteudos('''||a.cd_pergunta||''');">');
                            htp.p('<span>'||a.pergunta||'</span>');
                        htp.p('</td>');

                        htp.p('<td onclick="conteudo_tela_conteudos('''||a.cd_pergunta||''');">');
                            htp.p('<span>'||a.categoria||'</span>');
                        htp.p('</td>');


                        htp.p('<td style="text-align: center;">');
                            ws_checked := '';
                            if a.id_liberado = 'S' then 
                                ws_checked := 'checked';
                            end if;
                            htp.p('<input type="checkbox" '||ws_checked||' data-old="'||a.id_liberado||'" onchange="topico_atualiza(this, '''||a.cd_pergunta||''', ''ID_LIBERADO'');" />');
                        htp.p('</td>');                        
                    htp.p('</tr>');
                end loop;
                
                htp.p('</tbody>');
            htp.p('</table>');
        htp.p('</div>');    

        htp.p('<div id="cadastro-conteudo-altera" class="cadastro-conteudo-altera"></div>');

    htp.p('</div>');
end conteudo_tela_topicos;

-----------------------------------------------------------------------------------------------------------------
procedure conteudo_tela_conteudos (prm_pergunta    varchar2,
                                   prm_id_conteudo varchar2 default null) as 
    ws_class        varchar2(4000); 
    ws_class2       varchar2(4000); 
    ws_url_doc      varchar2(300);
begin

    select max(conteudo) into ws_url_doc from doc_variaveis where variavel = 'URL_DOC';

    htp.p('<input type="hidden" id="cadastro-conteudo-id" data-pergunta="'||prm_pergunta||'"/>');

    for a in (select * from doc_conteudos 
              where cd_pergunta = prm_pergunta 
                and id_conteudo = nvl(prm_id_conteudo,id_conteudo)
              order by sq_conteudo) loop

        -- Monta class/estilo do elemento 
        ws_class := null;
        if a.id_estilo is not null then 
            ws_class     := replace(a.id_estilo,'|',' ')||'"';
        end if; 

        htp.p('<div id="conteudo-item-'||a.id_conteudo||'" class="cadastro-conteudo-item" data-id_conteudo="'||a.id_conteudo||'" onclick="conteudo_tela_cadastro(this, '''||a.id_conteudo||''');">');
            
            htp.p('<div id="cadcon-botoes-'||a.id_conteudo||'" class="cadcon-botoes">');
                htp.p('<a id="cadcon-ordem-'||a.id_conteudo||'" class="cadcon-conteudo-botao" onclick="this.classList.toggle(''selecionado'');">');
                    htp.p('<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 490 490" xml:space="preserve"><g><g><path d="M487.557,237.789l-64-64c-3.051-3.051-7.659-3.947-11.627-2.304c-3.989,1.643-6.592,5.547-6.592,9.856v32h-128v-128h32 c4.309,0,8.213-2.603,9.856-6.592c1.643-3.989,0.725-8.576-2.304-11.627l-64-64c-4.16-4.16-10.923-4.16-15.083,0l-64,64 c-3.051,3.072-3.968,7.637-2.325,11.627c1.643,3.989,5.547,6.592,9.856,6.592h32v128h-128v-32c0-4.309-2.603-8.213-6.592-9.856 c-3.925-1.664-8.555-0.747-11.627,2.304l-64,64c-4.16,4.16-4.16,10.923,0,15.083l64,64c3.072,3.072,7.68,4.011,11.627,2.304 c3.989-1.621,6.592-5.525,6.592-9.835v-32h128v128h-32c-4.309,0-8.213,2.603-9.856,6.592c-1.643,3.989-0.725,8.576,2.304,11.627 l64,64c2.091,2.069,4.821,3.115,7.552,3.115s5.461-1.045,7.552-3.115l64-64c3.051-3.051,3.968-7.637,2.304-11.627 c-1.664-3.989-5.547-6.592-9.856-6.592h-32v-128h128v32c0,4.309,2.603,8.213,6.592,9.856c3.947,1.685,8.576,0.747,11.627-2.304 l64-64C491.717,248.712,491.717,241.971,487.557,237.789z"></path></g></g></svg>');
                htp.p('</a>');
                htp.p('<a id="cadcon-inserir-'||a.id_conteudo||'" class="cadcon-conteudo-botao inserir" onclick="cadastro_conteudo_inserir('''||prm_pergunta||''','''||a.id_conteudo||''');" title="Cria um novo conteúdo abaixo." class="cadcon-conteudo-botao">+</a>'); 
                htp.p('<a id="cadcon-excluir-'||a.id_conteudo||'" class="cadcon-conteudo-botao excluir" onclick="cadastro_conteudo_excluir('''||a.id_conteudo||''');" title="Exclui o conteúdo atual." class="cadcon-conteudo-botao">x</a>'); 
            htp.p('</div>');

            htp.p('<div id="cadcon-conteudo-'||a.id_conteudo||'" class="cadcon-conteudo" data-tp_conteudo="'||a.tp_conteudo||'">');
                if a.tp_conteudo = 'LINHA' then 
                    htp.p('<hr>');
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
                        ws_class2 := 'style="display: block ruby; width: 100%; '||ws_class2||'"';
                    end if; 
                    htp.p('<span '||ws_class2||'><img class="'||ws_class||'" src="dwu.fcl.download?arquivo='||a.ds_titulo||'"></span>');
                elsif a.tp_conteudo like 'LINK' then  
                    htp.p('<a class="'||ws_class||'" href="'||a.ds_titulo||'" target="_blank">');
                elsif a.tp_conteudo like 'PERGUNTA' then  
                    htp.p('<a class="'||ws_class||'" href="'||ws_url_doc||'.doc.main?prm_externo='||a.ds_titulo||'" target="_blank">');
                else     
                    if a.tp_conteudo like 'MARCADOR%' then 
                        htp.p('<div class="cadcon-titulo '||a.tp_conteudo||'"><li></li>');
                        htp.p('<div id="cadcon-titulo-'||a.id_conteudo||'-anterior" style="display:none;">'||a.ds_titulo||'</div>');                                
                        htp.p('<div id="cadcon-titulo-'||a.id_conteudo||'" contenteditable="true" onblur="conteudo_atualiza(this,'''||a.id_conteudo||''',''DS_TITULO'');">'||a.ds_titulo||'</div>');
                        htp.p('</div>');
                    end if;     
                    htp.p('<div id="cadcon-texto-' ||a.id_conteudo||'-anterior" style="display:none;">'||a.ds_texto||'</div>');
                    htp.p('<div id="cadcon-texto-' ||a.id_conteudo||'" contenteditable="true" class="cadcon-texto '||ws_class||'" onblur="conteudo_atualiza(this,'''||a.id_conteudo||''',''DS_TEXTO'');">'||a.ds_texto||'</div>');
                end if;        
            htp.p('</div>');    
        htp.p('</div>');     
    end loop;    

    htp.p('<style id="style-conteudo">');
    for a in (select id_estilo, css_estilo from doc_estilos order by id_estilo ) loop
        htp.p(' .'||a.id_estilo||' {'||a.css_estilo||'} ');
    end loop;
    htp.p('</style>');

  
end;
-----------------------------------------------------------------------------------------------------------------
procedure conteudo_tela_cadastro (prm_id_conteudo    varchar2)as 
    cursor c1 is 
      select * from doc_conteudos 
      where id_conteudo = prm_id_conteudo;
    
    ws_cont       c1%rowtype;  
    ws_checked    varchar2(20);
    ws_erro       varchar2(300);
    ws_script_atu varchar2(500);

    ws_raise_erro exception;
begin
    ws_script_atu := '"conteudo_atualiza(this,'''||prm_id_conteudo||''');"';
    open  c1;
    fetch c1 into ws_cont;
    close c1;
    if ws_cont.id_conteudo is null then 
        raise ws_raise_erro;
        ws_erro := 'Conteúdo não localizado.';
    end if; 
    
    htp.p('<div class="cadastro-conteudo-titulo">CONTEÚDO</div>');
    htp.p('<div class="cadcon-cadastro">'); 

        htp.p('<div class="cadcon-cadastro-linha">'); 
            htp.p('<label for="tp_conteudo">TIPO:</label>'); 
            htp.p('<select id="tp_conteudo" name="tp_conteudo">'); 
            for a in (  select 'PARAGRAFO' cd, 'Paragrafo' ds from dual union all 
                        select 'PARAGRAFO', 'PARAGRAFO' from dual union all 
                        select 'LINHA'    , 'LINHA'     from dual union all 
                        select 'IMAGEM'   , 'IMAGEM'    from dual union all 
                        select 'MARCADOR1', 'MARCADOR1' from dual union all  
                        select 'MARCADOR2', 'MARCADOR2' from dual union all  
                        select 'MARCADOR3', 'MARCADOR3' from dual union all  
                        select 'MARCADOR4', 'MARCADOR4' from dual union all  
                        select 'PDF'      , 'PDF'       from dual union all 
                        select 'GIF'      , 'GIF'       from dual
                    ) loop
                    if a.cd = ws_cont.tp_conteudo then 
                        htp.p('<option value="'||a.cd||'" selected>'||a.ds||'</option>');
                    else
                        htp.p('<option value="'||a.cd||'" >'||a.ds||'</option>');
                    end if;    
            end loop;   
            htp.p('/<select>'); 
        htp.p('</div>'); 

        htp.p('<div class="cadcon-cadastro-linha">'); 
            htp.p('<label for="id_estilo">ESTILOS:</label>'); 
            htp.p('<select multiple id="id_estilo">'); 
            for a in (  select 2 ordem, id_estilo as cd from doc_estilos union all 
                        select 1 ordem, null      as cd from dual 
                        order by ordem, cd ) loop
                    if instr(ws_cont.id_estilo||'|', a.cd||'|') > 0 or (ws_cont.id_estilo is null and a.cd is null ) then 
                        htp.p('<option value="'||a.cd||'" selected>'||a.cd||'</option>');
                    else
                        htp.p('<option value="'||a.cd||'" >'||a.cd||'</option>');
                    end if;    
            end loop;  
            htp.p('/<select>'); 
        htp.p('</div>'); 

        htp.p('<div class="cadcon-cadastro-linha">'); 
            htp.p('<label for="nr_linhas_antes">LINHAS ANTES:</label>'); 
            htp.p('<input type="number" id="nr_linhas_antes" value="'||ws_cont.nr_linhas_antes||'">'); 
        htp.p('</div>'); 

        htp.p('<div class="cadcon-cadastro-linha">'); 
            htp.p('<label for="id_ativo">id_ativo:</label>');
            ws_checked := '';
            if ws_cont.id_ativo = 'S' then 
                ws_checked := 'checked';
            end if;    
            htp.p('<input type="checkbox" id="id_ativo" '||ws_checked||' value="'||ws_cont.id_ativo||'"/>');
        htp.p('</div>'); 
    htp.p('</div>'); 

    htp.p('<div class="cadastro-conteudo-botoes">');
        htp.p('<a onclick="cadastro_conteudo_salvar('''||prm_id_conteudo||''');" title="Atualiza a tela de conteúdo do tópico." class="cadastro-conteudo-botao">SALVAR</a>'); 
    htp.p('</div>');

exception
  when ws_raise_erro then
    htp.p(ws_erro);


end conteudo_tela_cadastro; 

-------------------------------------------------------------------------------------------
procedure topico_atualiza (prm_pergunta       varchar2, 
                           prm_coluna         varchar2,
                           prm_conteudo       varchar2 default null) as
begin 
    update doc_perguntas
       set  pergunta        = decode(upper(prm_coluna),'PERGUNTA'        , prm_conteudo, pergunta        ),
            categoria       = decode(upper(prm_coluna),'CATEGORIA'       , prm_conteudo, categoria       ),
            tp_usuario      = decode(upper(prm_coluna),'TP_USUARIO'      , prm_conteudo, tp_usuario      ),
            id_liberado     = decode(upper(prm_coluna),'ID_LIBERADO'     , prm_conteudo, id_liberado     ),
            tp_conteudo     = decode(upper(prm_coluna),'TP_CONTEUDO'     , prm_conteudo, tp_conteudo     ),
            id_notas_versao = decode(upper(prm_coluna),'ID_NOTAS_VERSAO' , prm_conteudo, id_notas_versao )
    where cd_pergunta = prm_pergunta;
    if sql%notfound then 
        htp.p('ERRO|Tópico não localizado para atualização.');
    else 
        htp.p('OK|Tópico atualizado.');
    end if;             
exception 
    when others then 
        htp.p('ERRO|Erro atualizando tópico.');
end topico_atualiza;

--------------------------------------------------------------------------------------
procedure conteudo_atualiza (prm_id_conteudo    varchar2, 
                             prm_coluna         varchar2,
                             prm_conteudo       varchar2 default null) as
begin 
    update doc_conteudos
       set  sq_conteudo     = decode(upper(prm_coluna),'SQ_CONTEUDO'    , prm_conteudo, sq_conteudo     ),
            tp_conteudo     = decode(upper(prm_coluna),'TP_CONTEUDO'    , prm_conteudo, tp_conteudo     ),
            id_estilo       = decode(upper(prm_coluna),'ID_ESTILO'      , prm_conteudo, id_estilo       ),
            nr_linhas_antes = decode(upper(prm_coluna),'NR_LINHAS_ANTES', prm_conteudo, nr_linhas_antes ),
            ds_titulo       = decode(upper(prm_coluna),'DS_TITULO'      , prm_conteudo, ds_titulo       ),
            ds_texto        = decode(upper(prm_coluna),'DS_TEXTO'       , prm_conteudo, ds_texto        ),
            id_ativo        = decode(upper(prm_coluna),'ID_ATIVO'       , prm_conteudo, id_ativo        )
    where id_conteudo = prm_id_conteudo;
    if sql%notfound then 
        htp.p('ERRO|Conteúdo não localizado para atualização.');
    else 
        htp.p('OK|Conteúdo atualizado.');
    end if;             
exception 
    when others then 
        insert into bi_log_sistema values (sysdate, 'conteudo_atualiza: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
        commit;
        htp.p('ERRO|Erro atualizando conteúdo.');
end conteudo_atualiza;


-----------------------------------------------------------------------------------------------------------
procedure cadastro_conteudo_excluir (prm_id_conteudo varchar2) as
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
        insert into bi_log_sistema values (sysdate, 'cadastro_conteudo_excluir: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');	
        commit;
        htp.p('ERRO|Erro excluindo conteúdo.');
end cadastro_conteudo_excluir;

---------------------------------------------------------------------------------------
procedure cadastro_conteudo_inserir (prm_pergunta    varchar2,
                                     prm_id_conteudo varchar2) as
    ws_id_conteudo number;
    ws_sq_conteudo number;
    ws_sq_atual    number; 
begin
    
    select nvl(max(id_conteudo), 0) + 1 into ws_id_conteudo from doc_conteudos;
    
    -- Get the next sequence number for this topic
    select nvl(max(sq_conteudo), 0) + 1 into ws_sq_conteudo 
    from doc_conteudos 
    where cd_pergunta = prm_pergunta;

    select nvl(max(sq_conteudo), 0) into ws_sq_atual 
    from doc_conteudos 
    where id_conteudo = prm_id_conteudo;

    if (ws_sq_atual+1) < ws_sq_conteudo Then
        ws_sq_conteudo := ws_sq_atual+1;
        update doc_conteudos set sq_conteudo = sq_conteudo + 1
         where cd_pergunta = prm_pergunta
           and sq_conteudo > ws_sq_atual;
    end if;

    -- Insert the new record
    insert into doc_conteudos (
        id_conteudo, 
        cd_pergunta, 
        sq_conteudo, 
        tp_conteudo, 
        id_estilo, 
        nr_linhas_antes, 
        ds_titulo, 
        ds_texto, 
        id_ativo
    ) values (
        ws_id_conteudo, 
        prm_pergunta, 
        ws_sq_conteudo, 
        'PARAGRAFO', 
        null, 
        0, 
        null, 
        'Novo conteúdo - '||ws_sq_conteudo, 
        'S'
    );

    commit;
    
    htp.p('OK|Conteúdo criado com sucesso.|' || ws_id_conteudo);
exception
    when others then
        rollback;
        insert into bi_log_sistema values (sysdate, 'cadastro_conteudo_inserir: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');
        commit;
        htp.p('ERRO|Erro ao criar conteúdo.');
end cadastro_conteudo_inserir;

---------------------------------------------------------------------------------------------------------------------
procedure cadastro_conteudo_salvar (prm_id_conteudo     varchar2,
                                    prm_tp_conteudo     varchar2,
                                    prm_id_estilo       varchar2,
                                    prm_nr_linhas_antes varchar2,
                                    prm_id_ativo        varchar2) as
begin
    update doc_conteudos
       set tp_conteudo     = prm_tp_conteudo,
           id_estilo       = prm_id_estilo,
           nr_linhas_antes = prm_nr_linhas_antes,
           id_ativo        = prm_id_ativo
     where id_conteudo = prm_id_conteudo;
     
    if sql%notfound then 
        htp.p('ERRO|Conteúdo não localizado para atualização.');
    else 
        commit;
        htp.p('OK|Conteúdo atualizado com sucesso.');
    end if;
exception
    when others then
        rollback;
        insert into bi_log_sistema values (sysdate, 'cadastro_conteudo_salvar: '|| dbms_utility.format_error_stack||'-'||dbms_utility.format_error_backtrace, 'dwu', 'erro');
        commit;
        htp.p('ERRO|Erro ao salvar conteúdo.');
end cadastro_conteudo_salvar;


END DOC;
/
SHOW ERROR;