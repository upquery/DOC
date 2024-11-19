var classe_doc;
/*
====================================
==    CLASSE_DOC = CLASSE         ==
==    F = FAQ-DÚVIDAS FREQUENTES  ==
==    D = DOCUMENTAÇÃO PÚBLICA    ==
==    P = DOCUMENTAÇÃO INTERNA    ==
====================================
 */  
var tip_user = 'T' ;
/*
====================================
==    TIP_USER = TIPO DE USUARIO  ==
==    T = AMBOS                   ==
==    A = ADMIN                   ==
==    N = NORMAL                  ==
====================================
 */  


document.addEventListener('keypress', function(e){
    if(document.getElementById('busca').focus){

        if(e.key == "Enter"){
            chamar('consulta',e.target.value, '.flex-container',tip_user);
        }
    }
});

var loading;  

document.addEventListener('click', function(e){

    if(e.target.classList.contains('flex-perguntas')){ 
        e.target.parentNode.classList.toggle('selected');
    }

    if(e.target.classList.contains('mais')){ 
        e.target.parentNode.parentNode.classList.toggle('selected');
    }

    if(e.target.classList.contains('cxmsg')){
        document.querySelector('.cxmsg').classList.remove('mostrar');
    }
    
    if(e.target.id == "lupa"){
        chamar('consulta', e.target.previousElementSibling.value, '.flex-container',tip_user);   
    }

    if(e.target.className == "ler-mais"){

        //chamar('detalhe_pergunta', e.target.title,'',tip_user);
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        window.open(url_doc + '.doc.main?prm_externo='+e.target.title+'&prm_usuario='+tip_user,'_blank');
       
        if(document.querySelector('.escolhido')){

            document.querySelector('.escolhido').classList.remove('escolhido');
        }
    }

    if(e.target.className == "retorna-princ"){
        chamar('main');
        if(document.querySelector('.escolhido')){
            document.querySelector('.escolhido').classList.remove('escolhido');
        }
    }


    if(e.target.className == "go-doc-public"){
        classe_doc = 'D';
        chamar('DOC_PUBLIC', e.target.title,'',tip_user);
        if(document.querySelector('.escolhido')){
            document.querySelector('.escolhido').classList.remove('escolhido');
        }
        e.target.classList.add('escolhido');
    }


    if(e.target.className == "go-doc-private"){
        classe_doc = 'P';
        chamar('DOC_PRIVATE', e.target.title,'',tip_user);
        if(document.querySelector('.escolhido')){
            document.querySelector('.escolhido').classList.remove('escolhido');
        }
        e.target.classList.add('escolhido');
    }

    if(e.target.className == "go-faq"){
        classe_doc = 'F';
        chamar('faq', e.target.title,'',tip_user);
        if(document.querySelector('.escolhido')){
            document.querySelector('.escolhido').classList.remove('escolhido');
        }
        e.target.classList.add('escolhido');
    }
    
    if(e.target.classList.contains("votacao")){
        chamar('rank_perguntas', 'prm_valor='+ e.target.title + '&prm_pergunta=' + document.querySelector('.retorna-faq').id); 
    }

    
    if(e.target.className == "lista-pergunta"){
        
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        chamar('detalhe_pergunta', e.target.title, '', tip_user, 'somente_pergunta' );
        //window.location.replace(url_doc + '.doc.main?prm_externo='+e.target.title+'&prm_usuario='+tip_user);
        document.body.scrollTop = 0

    }

    if(e.target.tagName == 'IMG' && (e.target.classList.contains('menu-lateral-aberto') || e.target.classList.contains('menu-lateral-fechado')) ){
        let li_pai   = e.target.parentNode.parentNode;
        let ul_irmao = li_pai.nextElementSibling;
        if (ul_irmao.classList.contains('menu-lateral-aberto')) {
            ul_irmao.classList.remove('menu-lateral-aberto');
            ul_irmao.classList.add('menu-lateral-fechado');
        } else {
            ul_irmao.classList.remove('menu-lateral-fechado');
            ul_irmao.classList.add('menu-lateral-aberto');
        }    
        let img_src = e.target.getAttribute('src');
        if (e.target.classList.contains('menu-lateral-aberto')) {
            e.target.classList.remove('menu-lateral-aberto');
            e.target.classList.add('menu-lateral-fechado');
            e.target.setAttribute('src',img_src.replace('menos.png', 'mais.png'));
        } else {
            e.target.classList.remove('menu-lateral-fechado');
            e.target.classList.add('menu-lateral-aberto');
            e.target.setAttribute('src',img_src.replace('mais.png', 'menos.png'));
        }
    
    } else if(e.target.classList.contains('menu-lateral-item') ){
        let cd_pergunta = e.target.getAttribute('data-pergunta');
        var itens = document.getElementById('menu-lateral-scroll').querySelectorAll('.menu-lateral-item.selecionado');
        for(let a=0;a<itens.length;a++){
            itens[a].classList.remove('selecionado');
        }
        e.target.classList.add('selecionado');
        chamar('detalhe_pergunta', cd_pergunta, '', tip_user, 'somente_pergunta' );

    }    


});

function chamar(proc, search, alvo, tipousuario, tipo){

    var alvo = alvo || '.main';
    var tipo = tipo || 'tela';
    loading = document.querySelector('.spinner');  
    loading.classList.add('ativado');
    var request = new XMLHttpRequest(); //aqui inicializa a requisição
    request.open('POST', 'dwu.doc.' + proc, true); //esse ponto define a procedure de comunicação

    if(proc == 'principal'){
        request.send('prm_valor=');
    } else if(proc == 'detalhe_pergunta'){
        request.send('prm_valor='+search+'&prm_tipuser='+tipousuario);
    } else if(proc == 'rank_perguntas'){
        request.send(search); 
    } else if (proc == 'main'){
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        window.location.replace(url_doc + '.doc.main');
    }else{
        request.send('prm_valor='+search+'&prm_classe='+classe_doc+'&prm_tipuser='+tipousuario); //esse ponto define a passagem de parametros
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        try {
            window.history.pushState("", "", url_doc + ".doc.main");//remove os parametros da url , caso esteja acessando de um link externo
        } catch {
        }
    }

    request.onload = function(){  
        if(request.status == 200){
            if(request.responseText.indexOf('!!!') == -1){ 
                if (tipo == 'somente_pergunta') {
                    var etemp = document.createElement('div');
                    etemp.innerHTML = request.responseText;
                    document.querySelector('.fundo-conteudo').innerHTML = etemp.querySelector('.fundo-conteudo').innerHTML;      
                } else {
                    document.querySelector(alvo).innerHTML = request.responseText;      
                }    
            } else { 
                document.querySelector('.voto').remove();
                document.querySelector('.cxmsg').classList.add('mostrar');
                setTimeout(function(){ 
                    document.querySelector('.cxmsg').classList.remove('mostrar');
                }, 3000)
            }
            loading.classList.remove('ativado');// esse ponto testa se o endereço alcançou 200, e traz a resposta do backend               
        }
    }; 
    window.scrollTo(0, 0);
};


function changeBody(alvo, x, y, z){
    
    var conteudo = document.querySelector('.apresentation'); 
    var tableconteudo = document.querySelector('.linha');
    var loading = document.querySelector('.spinner');

    loading.classList.add('ativado');

    if(document.querySelector('.selected')){
        
      document.querySelector('.selected').classList.remove('selected');
    }

    if(alvo){

        alvo.classList.add('selected');
    }

    if(conteudo){

        conteudo.classList.add('desfocar');
    }
        
    if(tableconteudo){

        tableconteudo.classList.add('desfocar');
    }

        var container = document.getElementById('header-doc');
     
    chama(x, y).then(function(resposta){

        container.innerHTML = resposta;

        if (z == 'grant'){

            alerta('feed-fixo', "Acesso concedido!");
        }
        if (z == 'revoke'){

            alerta('feed-fixo', "Acesso Removido!");
        }
        if (z == 'limpo'){

            alerta('feed-fixo', "Limpeza Concluída!");
        }               
    }).then(function(){ 

        loading.classList.remove('ativado'); 

    });
};
    
    //Função descontinuada 11/11/2022 não sera mais necessário o usuário digitar mais que 3 carancteres.
function keyword(texto){  
    return texto.split(' ').filter(palavra => palavra.length > 3).join(' ');
};
      

document.addEventListener('change', function(e){
       
    if(e.target.className == ("check-ver")){
           
        chamar('detalhe_pergunta', document.querySelector('.retorna-faq').id + '&prm_versao=' + e.target.value); 
    }
    
});