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
    if (document.getElementById('busca')) {
        if(document.getElementById('busca').focus){

            if(e.key == "Enter"){
                chamar('consulta',e.target.value, '.flex-container',tip_user);
            }
        }
    }    
});

var loading;  

document.addEventListener('click', function(e){

    if(e.target.classList.contains('flex-perguntas')){ 
        e.target.parentNode.classList.toggle('selected');

        if (e.target.parentNode.classList.contains('selected')){
            e.target.parentNode.querySelector('.mais').src = URL_DOWNLOAD + "menos.png";
        } else {
            e.target.parentNode.querySelector('.mais').src = URL_DOWNLOAD + "mais.png";
        }
    }

    if(e.target.classList.contains('mais')){ 
        e.target.parentNode.parentNode.classList.toggle('selected');

        if (e.target.parentNode.parentNode.classList.contains('selected')){
            e.target.src = URL_DOWNLOAD + "menos.png";
        } else {
            e.target.src = URL_DOWNLOAD + "mais.png";
        }
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

    if(e.target.className == "go-doc-cadastro"){
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        window.open(url_doc + '.doc.main?prm_externo=CADASTRO','_blank');
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
        chamar('detalhe_pergunta', e.target.title, '', tip_user, 'somente_pergunta','S' );
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
        
        menu_seleciona_item(e.target, 'N');
        let cd_pergunta = e.target.getAttribute('data-pergunta');
        chamar('detalhe_pergunta', cd_pergunta, '', tip_user, 'somente_pergunta', 'N' );
        

    }


});

function menu_seleciona_item(item, posicionar) {
    var posicionar = posicionar || 'S';
    var itens = document.getElementById('menu-lateral-scroll').querySelectorAll('.menu-lateral-item.selecionado');
    for(let a=0;a<itens.length;a++){
        itens[a].classList.remove('selecionado');
    }
    item.classList.add('selecionado');

    if (posicionar == 'S') {
        let item_rect = item.getBoundingClientRect();
        let menu_rect = document.getElementById('menu-lateral-scroll').getBoundingClientRect();
        let limite_inferior = menu_rect.top + menu_rect.height - item_rect.height ;
        if (item_rect.top > limite_inferior) {
            document.getElementById('menu-lateral-scroll').scrollTop = document.getElementById('menu-lateral-scroll').scrollTop + (item_rect.top - limite_inferior);    
        } else if (item_rect.top < menu_rect.top) {
            document.getElementById('menu-lateral-scroll').scrollTop = 0;                
        }    
    }    
};


function chamar(proc, search, alvo, tipousuario, tipo, localiza_menu){

    var alvo = alvo || '.main';
    var tipo = tipo || 'tela';
    var localiza_menu = localiza_menu || 'S';

    loading = document.querySelector('.spinner');  
    loading.classList.add('ativado');
    var request = new XMLHttpRequest(); //aqui inicializa a requisição
    request.open('POST', 'dwu.doc.' + proc, true); //esse ponto define a procedure de comunicação

    if(proc == 'principal'){
        request.send('prm_valor=');
    } else if(proc == 'detalhe_pergunta'){
        request.send('prm_valor='+search+'&prm_tipuser='+tipousuario);
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        //window.history.pushState('','',url_doc + '.doc.main?prm_externo='+search);     // desativado por erro de segurança gerado pelo navegador 

    } else if(proc == 'rank_perguntas'){
        request.send(search); 
    } else if (proc == 'main'){
        let url_doc = document.getElementById('header_doc_variaveis').getAttribute('data-url_doc');
        window.location.replace(url_doc + '.doc.main');
    } else if (proc.toLowerCase() == 'doc_cad_conteudo'){
        request.send('prm_valor='+search); 
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
                if (proc == 'detalhe_pergunta' && localiza_menu == 'S') {
                    var itens = document.getElementById('menu-lateral-scroll').querySelectorAll('.menu-lateral-item');
                    for(let a=0;a<itens.length;a++){
                        if ( itens[a].getAttribute('data-pergunta') == search ) {
                            
                            // Abre os níveis superiores ao item selecionado 
                            let ul = itens[a].parentNode.parentNode;
                            let fim = 'N';
                            while (fim == 'N') {
                                ul.classList.remove('menu-lateral-fechado');
                                ul.classList.add('menu-lateral-aberto');
                                try {
                                    img = ul.previousElementSibling.getElementsByTagName('IMG')[0];
                                    img.classList.remove('menu-lateral-fechado');
                                    img.classList.add('menu-lateral-aberto');
                                    img.setAttribute('src', img.getAttribute('src').replace('mais.png','menos.png'));
                                    ul = ul.parentNode;
                                    fim = (ul.tagName != 'UL' ? 'S' : 'N');
                                } catch {
                                    fim = 'S';
                                }
                            }
                            menu_seleciona_item(itens[a], 'S');  // marca/seleciona item 
                        };
                    }
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
    if (proc == 'detalhe_pergunta') {
        try {
            document.getElementById('fundo-conteudo').scrollTo(0, 0); 
        } catch {
        }    
    } else {
        window.scrollTo(0, 0);
    }
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

function carrega_conteudo_arquivo(prm_pergunta, prm_arquivo, prm_tipo){

    let link = '';
    if (prm_tipo == 'PDF') {
        document.getElementById('iframe_conteudo_arquivo').style.display = 'none';
        document.getElementById('img_conteudo_arquivo').style.display    = 'none';        
        document.getElementById('pdf-loader').style.display              = 'flex';
        document.getElementById('iframe_conteudo_arquivo').src = 'https://docs.google.com/viewer?url=' + prm_arquivo + '&embedded=true';
    } else {
        link = prm_arquivo;
        document.getElementById('pdf-loader').style.display              = 'none';
        document.getElementById('iframe_conteudo_arquivo').style.display = 'none';
        document.getElementById('img_conteudo_arquivo').style.display    = 'block';       
        document.getElementById('img_conteudo_arquivo').src = prm_arquivo;
    }   
}    

function mostra_conteudo_pdf(){
    document.getElementById('pdf-loader').style.display              = 'none';
    document.getElementById('iframe_conteudo_arquivo').style.display = 'block';
    document.getElementById('img_conteudo_arquivo').style.display    = 'none';
}

function call(req, par, tipo){

    var tipo  = tipo || 'POST',
        par   = par || '',
        pkg   = 'doc',
        owner = 'dwu';
    
    return new Promise(function(resolve, reject){
        var request = new XMLHttpRequest();

        if(tipo == 'POST'){
            request.open(tipo, owner + '.'+pkg+'.'+req, true);
        } else {
            request.open(tipo, owner + '.'+pkg+'.'+req+'?'+par, true);
        }  

        if(tipo == 'POST'){
            request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");  
            request.send(par);
        } else {
            request.send(null);
        }

        request.onload = function(){
            if(request.status == 200){
                resolve(request.responseText.trim());
            } else {
                reject('ERRO');
            }
        }
    });
}

function alerta(tipo, msg){
  tipo = tipo || 'feed-fixo';  
  if(msg){
    var template;
    if(tipo == "alert"){ 
        alert(msg); 
    } else {

      template = document.getElementById("alerta-template").children[0].cloneNode(true);
      template.innerHTML = msg;
      if (tipo.toUpperCase() == 'ERRO') { 
        template.classList.add("erro"); 
      }

      document.getElementById("feed-fixo").appendChild(template);

      setTimeout(function(){ template.classList.add("show"); }, 100);
      setTimeout(function(){ if(template){ template.classList.remove("show"); } }, 4700);
      setTimeout(function(){ if(template){ template.remove(); } }, 5000);
    }
  }
}

async function uploadArquivos(input_id) {
    var arquivosInput = document.getElementById(input_id||'arquivos');
    var arquivos = arquivosInput.files;
    var acao = 'dwu.doc.upload';
   
    // if (input_id.length == 0) {
    //     let ele = document.getElementById('escolherArquivoButton');
    //     let id_conteudo = ele.getAttribute('data-id_topico');
    //     conteudo_atualiza(ele, id_conteudo, 'DS_TITULO');
    // }

    if (arquivos.length == 0) {
        alerta('feed-fixo', 'Nenhum arquivo selecionado para upload.');
    } else {
        var arquivo = arquivos[0];
        await enviarArquivo(arquivo, acao);
    }    
}

function enviarArquivo(arquivo, acao) {
    var acao = acao || 'dwu.doc.upload';
    return new Promise(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open('POST', acao, true);
      xhr.onload = function () {
        alerta('feed-fixo', xhr.responseText.split('|')[1]);
        resolve(xhr.responseText);
      };
      xhr.onerror = function () {
        reject(xhr.statusText);
      };
      var formData = new FormData();
      formData.append('arquivo', arquivo);
      xhr.send(formData);
    });
}
  
function  mostrarArquivosSelecionados(btn_id, input_id) {

    var arquivosInput = document.getElementById(input_id || 'arquivos');
    var arquivos = arquivosInput.files;
    var totalArquivos = arquivos.length;
    
    var escolherArquivoButton = document.getElementById(btn_id || 'escolherArquivoButton');
    
    if (totalArquivos > 1) {
      
      var arquivosString = "";
      
      for (var i = 0; i < totalArquivos; i++) {
        arquivosString += arquivos[i].name + '\n';
      }
  
      escolherArquivoButton.title = arquivosString;
      escolherArquivoButton.innerHTML = totalArquivos + ' ARQUIVOS';
    } else {
      escolherArquivoButton.title = arquivos[0].name;
      escolherArquivoButton.innerHTML = arquivos[0].name;
    }
  
  }
  

function topico_atualiza(ele, pergunta, coluna){
    
    let conteudo_ant = '',
        conteudo     = '';

    if (ele.tagName === 'INPUT' && ele.type === 'checkbox') {
        conteudo     = ele.checked ? 'S' : 'N';
    } else {
        conteudo = ele.innerHTML;    
        if (ele.getAttribute('data-old')) {
            conteudo_ant = ele.getAttribute('data-old');
        }   
    }    

    if (conteudo != conteudo_ant) {
        call('topico_atualiza', 'prm_pergunta='+pergunta+'&prm_coluna='+coluna+'&prm_conteudo='+encodeURIComponent(conteudo)).then(function(resposta){ 
            alerta('',resposta.split('|')[1]); 
        });    
    }    
}    


function conteudo_atualiza(ele, id_conteudo, coluna){
    
    if (!coluna) {
        coluna = ele.id.toUpperCase();
    }    

    let conteudo = '';
    if (ele.tagName === 'SELECT') {
        conteudo = Array.from(ele.options)
        .filter(option => option.selected)
        .map(option => option.text) // Usando text em vez de value
        .join('|');
    } else {
        if (ele.tagName === 'TEXTAREA') {
            conteudo = ele.value;    
        } else {
            conteudo = ele.innerHTML;    
        }    
    }


    var conteudo_ant = '',
        tipo_ant     = '';
    if (document.getElementById(ele.id+'-anterior')) {
        conteudo_ant = document.getElementById(ele.id+'-anterior').value;
        tipo_ant     = 'elemento';
    } else {
        if (ele.getAttribute('data-old')) {
            if (ele.tagName === 'INPUT' && ele.type === 'checkbox') {
                conteudo     = ele.checked ? 'S' : 'N';
            } else if (ele.tagName === 'INPUT' && ( ele.type === 'number' || ele.type === 'text')) {
                conteudo = ele.value;
            } else {   
                conteudo_ant = ele.getAttribute('data-old');
                tipo_ant     = 'atributo';
            }    
        }
    }

    if (conteudo != conteudo_ant) {

        call('conteudo_atualiza', 'prm_id_conteudo='+id_conteudo+'&prm_coluna='+coluna+'&prm_conteudo='+encodeURIComponent(conteudo)).then(function(resposta){ 
            alerta('',resposta.split('|')[1]); 
            if(resposta.split('|')[0] == 'OK'){ 
                if (tipo_ant == 'elemento') {
                    document.getElementById(ele.id+'-anterior').innerHTML = conteudo;
                } else if (tipo_ant == 'atributo') {
                    ele.setAttribute('data-old') = conteudo;
                }
                if (coluna == 'DS_TEXTO') {
                    document.getElementById('cadcon-texto-view-'+id_conteudo).innerHTML = resposta.split('|')[2];

                }
            } 
        });    
    }
}    

function conteudo_tela_cadastro(ele, cd_pergunta, id_conteudo){
    

    if (conteudoMovendoId) {
        if (id_conteudo == conteudoMovendoId) {
            conteudo_mover_cancelar();  // Se já estiver em modo de movimento, cancela
        } else {
            conteudo_mover_completar(id_conteudo);
            event.stopPropagation(); // Impede que o evento se propague
            event.preventDefault(); // Impede a ação padrão
        } 
        return; // Não continua com a função se estiver movendo
    }


    call('conteudo_tela_cadastro', 'prm_pergunta='+cd_pergunta+'&prm_id_conteudo='+id_conteudo).then(function(resposta){ 
        if(resposta.split('|')[0] == 'ERRO|'){ 
            alerta('',resposta.split('|')[1]); 
        } else {
            document.getElementById('cadastro-conteudo-altera').innerHTML = resposta; 

            let form = document.querySelector('.cadcon-cadastro');
            let ele_tp = form.querySelector('#tp_conteudo');
            conteudo_tela_cadastro_altera(ele_tp);

            let selecionados  = document.getElementById('cadastro-conteudo-detalhe').querySelectorAll('.cadastro-conteudo-item.selecionado');
            for (let a=0;a<selecionados.length;a++){
                selecionados[a].classList.remove('selecionado');
            }
            ele.classList.add('selecionado');
        }    
    });    
}    

function conteudo_tela_cadastro_altera(ele){

    let tp_conteudo = ele.value;
    let id_conteudo = ele.getAttribute('data-id_conteudo');
    let campos = document.querySelector('.cadcon-cadastro').querySelectorAll('.cadcon-cadastro-linha');

    for (let a=0;a<campos.length;a++){
        if (campos[a].id != 'cadastro-tp_conteudo' && campos[a].id != 'cadastro-id_ativo' && campos[a].id != 'cadastro-nr_linhas_antes') {
            campos[a].classList.add('ocultar');
        }
    }

    if (['IMAGEM','PDF','GIF'].indexOf(tp_conteudo) != -1) {        
        document.getElementById('cadastro-id_estilo').classList.remove('ocultar');
        document.getElementById('cadastro-ds_titulo').classList.remove('ocultar');
        if (tp_conteudo == 'IMAGEM') {        
            document.getElementById('arquivos').accept=".png,.jpg";
        } else if (tp_conteudo == 'PDF') {        
            document.getElementById('arquivos').accept=".pdf";
        } else if (tp_conteudo == 'GIF') {        
            document.getElementById('arquivos').accept=".gif";
        }       

    }    

    if (['PARAGRAFO','MARCADOR1','MARCADOR2','MARCADOR3','MARCADOR4'].indexOf(tp_conteudo) != -1) {
        document.getElementById('cadastro-id_estilo').classList.remove('ocultar');
    } 

    call('conteudo_tela_id_estilo', 'prm_id_conteudo='+id_conteudo).then(function(resposta){ 
        if(resposta.split('|')[0] == 'ERRO|'){ 
            alerta('',resposta.split('|')[1]); 
        } else {
            document.getElementById('id_estilo_selecao').innerHTML = resposta; 
        }    
    });    
   

}    

function conteudo_topico_seleciona(ele){
    
    let tr            = ele.parentNode;
    let pergunta      = tr.getAttribute('data-pergunta');
    let selecionados  = tr.parentNode.querySelectorAll('.lista-topico-item.selecionado');
    for (let a=0;a<selecionados.length;a++){
        selecionados[a].classList.remove('selecionado');
    }
    tr.classList.add('selecionado');

    conteudo_tela_conteudos(pergunta);

}    

function conteudo_tela_conteudos(cd_pergunta){
    
    // Monta tela de alteração somente com o botão NOVO
    call('conteudo_tela_cadastro', 'prm_pergunta='+cd_pergunta+'&prm_id_conteudo=').then(function(resposta){ 
        if(resposta.split('|')[0] == 'ERRO|'){ 
            alerta('',resposta.split('|')[1]); 
        } else {
            document.getElementById('cadastro-conteudo-altera').innerHTML = resposta; 
        }  
    });    

    // Monta tela de listagem de conteúdos
    call('conteudo_tela_conteudos', 'prm_pergunta='+cd_pergunta).then(function(resposta){ 
        if(resposta.split('|')[0] == 'ERRO|'){ 
            alerta('',resposta.split('|')[1]); 
        } else {
            document.getElementById('cadastro-conteudo-detalhe').innerHTML = resposta; 
        }  
    });    
}    

function cadastro_conteudo_excluir(id_conteudo) {

    if (confirm('Confirma a exclusão do conteúdo selecionando?')) {
        call('cadastro_conteudo_excluir', 'prm_id_conteudo=' + id_conteudo).then(function(resposta) { 
            alerta('', resposta.split('|')[1]); 
            if(resposta.split('|')[0] == 'OK') { 
                document.getElementById('conteudo-item-' + id_conteudo).remove();
                document.getElementById('cadastro-conteudo-altera').innerHTML = '';
            }
        });    
    }
}

function cadastro_conteudo_inserir(pergunta, id_conteudo) {
    
    // Call the server to insert a new content record
    call('cadastro_conteudo_inserir', 'prm_pergunta=' + pergunta+'&prm_id_conteudo='+id_conteudo).then(function(resposta) {
        let resultado = resposta.split('|');
        
        if (resultado[0] == 'OK') {
            // Recarrega toda a tela com os conteúdos atualizados
            conteudo_tela_conteudos(pergunta);
            alerta('', resultado[1]);

            // Recarrega a tela de cadastro / alteração do conteúdo 
            let id_conteudo = resultado[2];
            setTimeout(function() {
                let novoConteudo = document.getElementById('conteudo-item-' + id_conteudo);
                if (novoConteudo) {
                    conteudo_tela_cadastro(novoConteudo, pergunta, id_conteudo);
                }
            }, 500);
        } else {
            alerta('', resultado[1]);
        }
    });
}    


function cadastro_conteudo_salvar(id_conteudo) {
    // Get the form container
    let form = document.querySelector('.cadcon-cadastro');
    if (!form) {
        alerta('', 'Formulário não encontrado.');
        return;
    }

    let dados = {
        tp_conteudo: form.querySelector('#tp_conteudo')?.value || '',
        id_estilo: Array.from(form.querySelector('#id_estilo_selecao')?.selectedOptions || [])
                        .map(opt => opt.value)
                        .filter(val => val)
                        .join('|') || null,
        nr_linhas_antes: form.querySelector('#nr_linhas_antes')?.value || '0',
        id_ativo: form.querySelector('#id_ativo')?.checked ? 'S' : 'N',
        ds_titulo: form.querySelector('#escolherArquivoButton')?.innerHTML || ''
    };   

    call('cadastro_conteudo_salvar', 
            'prm_id_conteudo=' + id_conteudo + 
            '&prm_tp_conteudo=' + encodeURIComponent(dados.tp_conteudo) +
            '&prm_id_estilo=' + encodeURIComponent(dados.id_estilo || '') +
            '&prm_nr_linhas_antes=' + dados.nr_linhas_antes +
            '&prm_id_ativo=' + dados.id_ativo + 
            '&prm_ds_titulo=' + encodeURIComponent(dados.ds_titulo)

    ).then(function(resposta) {
        alerta('', resposta.split('|')[1]);
        if (resposta.split('|')[0] == 'OK') {
            // Recarrega a tela de conteudos 
            let cd_pergunta = document.getElementById('cadastro-conteudo-id').getAttribute('data-pergunta');
            if (cd_pergunta) {
                conteudo_tela_conteudos(cd_pergunta);
                setTimeout(function() {
                    // Recarrega a tela de cadastro / alteração do conteúdo
                    let novoConteudo = document.getElementById('conteudo-item-' + id_conteudo);
                    if (novoConteudo) {
                        conteudo_tela_cadastro(novoConteudo, cd_pergunta, id_conteudo);
                    }  
                }, 500);
            }
        }
    });
}

function cadcon_toolbar_habilita (id_conteudo, habita) {
    let toolbar = document.getElementById('cadcon-texto-toolbar-' + id_conteudo);
    if (toolbar) {
        if (habita) {
            toolbar.classList.add('visible');
        } else {
            toolbar.classList.remove('visible');
        }
    }
}


// Set up click handlers for toolbar buttons
function cadcon_toolbar_actions(ele) {

    let acao        = ele.getAttribute('data-action');
    let id_conteudo = ele.parentNode.getAttribute('data-id_conteudo');

    let textarea  = document.getElementById('cadcon-texto-'+id_conteudo);
    let texto     = textarea.value;
    let pos_sel_i = textarea.selectionStart,
        pos_sel_f = textarea.selectionEnd;
    let texto_sel = texto.substring(pos_sel_i, pos_sel_f);
    let formatado = '';

    if (acao == 'ESTILO' || acao == 'URL') {
        if ((pos_sel_f - pos_sel_i) == 0) {
            alerta('feed-fixo', 'Necess&aacute;rio selecionar um texto.'); 
            return;
        } 
    }    
    if (acao == 'SALVAR' || acao == 'CANCELAR') {
        finishTextareaEdit(id_conteudo, acao);  
    } else if (acao == 'ESTILO') {
        // Call the server to get the styles popup
        call('estilo_popup', 'prm_id_conteudo='+id_conteudo).then(function(resposta) {
            // Add the popup to the DOM
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = resposta;

            document.body.appendChild(tempDiv.children[1]); // Coloca primeiro o overlay 
            document.body.appendChild(tempDiv.firstChild);  // coloca o popup 

            // Show the popup
            const popup   = document.getElementById('estilos-popup');
            const overlay = document.getElementById('estilos-overlay');

            popup.style.display   = 'block';
            overlay.style.display = 'block';
                    
            // Set up event handlers for the buttons
            document.getElementById('estilos-aplicar').addEventListener('click', function() {
                // Get selected styles
                const select = document.getElementById('estilos-select');
                const estilos = Array.from(select.selectedOptions)
                    .map(option => option.value)
                    .join('|');
                
                if (estilos.length > 0) {
                    formatado = '<DOCF CLASSE=' + estilos.toUpperCase().trim() + '>'+texto_sel+'</DOCF>';
                    texto = texto.substring(0,pos_sel_i) + formatado + texto.substring(pos_sel_f,texto.length+1); 
                    textarea.value = texto; 
                }  
                
                // Close the popup
                closeEstilosPopup();
            });
            
            document.getElementById('estilos-cancelar').addEventListener('click', function() {
                closeEstilosPopup();
            });
            
            // Close popup when clicking on overlay
            overlay.addEventListener('click', function() {
                closeEstilosPopup();
            });
        });
        
        // Function to close the styles popup
        function closeEstilosPopup() {
            const popup   = document.getElementById('estilos-popup');
            const overlay = document.getElementById('estilos-overlay');
            textarea.focus();                
            if (popup)   { popup.remove(); }
            if (overlay) { overlay.remove();}
        }

    } else if (acao == 'URL') {
        // Call the server to get the URL popup
        call('url_popup', '').then(function(resposta) {
            // Add the popup to the DOM
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = resposta;

            document.body.appendChild(tempDiv.children[1]); // Coloca primeiro o overlay 
            document.body.appendChild(tempDiv.firstChild);  // coloca o popup 

            // Show the popup
            const popup = document.getElementById('url-popup');
            const overlay = document.getElementById('url-overlay');

            popup.style.display = 'block';
            overlay.style.display = 'block';
            
            // Focus on the URL input
            document.getElementById('url-input').focus();
                    
            // Set up event handlers for the buttons
            document.getElementById('url-aplicar').addEventListener('click', function() {
                // Get the URL
                const url = document.getElementById('url-input').value.trim();
                
                if (url) {
                    formatado = '<DOCF LINK=' + url + '>' + texto_sel + '</DOCF>';
                    texto = texto.substring(0, pos_sel_i) + formatado + texto.substring(pos_sel_f, texto.length + 1); 
                    textarea.value = texto; 
                }
                
                // Close the popup
                closeUrlPopup();
            });
            
            document.getElementById('url-cancelar').addEventListener('click', function() {
                closeUrlPopup();
            });
            
            // Close popup when clicking on overlay
            overlay.addEventListener('click', function() {
                closeUrlPopup();
            });
            
            // Handle Enter key in the input field
            document.getElementById('url-input').addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    document.getElementById('url-aplicar').click();
                }
            });
        });
        
        // Function to close the URL popup
        function closeUrlPopup() {
            const popup = document.getElementById('url-popup');
            const overlay = document.getElementById('url-overlay');
            textarea.focus();
            if (popup)   { popup.remove(); }
            if (overlay) { overlay.remove(); }
        }
    } else if (acao == 'TOPICO') {
        // Call the server to get the topic popup
        call('topico_popup', '').then(function(resposta) {
            // Add the popup to the DOM
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = resposta;
    
            document.body.appendChild(tempDiv.children[1]); // Coloca primeiro o overlay 
            document.body.appendChild(tempDiv.firstChild);  // coloca o popup 
    
            // Show the popup
            const popup = document.getElementById('topico-popup');
            const overlay = document.getElementById('topico-overlay');
    
            popup.style.display = 'block';
            overlay.style.display = 'block';
            
            // Focus on the search input
            document.getElementById('topico-search').focus();
            document.getElementById("topico-search").addEventListener("input", function() {
              const searchText = this.value.toLowerCase();
              const options = document.getElementById("topico-select").options;
              for (let i = 0; i < options.length; i++) {
                const optionText = options[i].text.toLowerCase();
                options[i].style.display = optionText.includes(searchText) ? "" : "none";
              }
            });
                    
            // Set up event handlers for the buttons
            document.getElementById('topico-aplicar').addEventListener('click', function() {
                // Get the selected topic
                const select = document.getElementById('topico-select');
                const selectedOption = select.options[select.selectedIndex];
                
                if (selectedOption) {
                    const topicoId = selectedOption.value;
                    
                    // If text is selected, use it as the link text, otherwise use the topic title
                    const linkText = (pos_sel_f - pos_sel_i > 0) ? texto_sel : selectedOption.text.split(' - ')[1];
                    formatado = '<DOCF PERG=' + topicoId + '>' + linkText + '</DOCF>';
                    texto = texto.substring(0, pos_sel_i) + formatado + texto.substring(pos_sel_f, texto.length + 1);
                    textarea.value = texto;
                }
                
                // Close the popup
                closeTopicoPopup();
            });
            
            document.getElementById('topico-cancelar').addEventListener('click', function() {
                closeTopicoPopup();
            });
            
            // Close popup when clicking on overlay
            overlay.addEventListener('click', function() {
                closeTopicoPopup();
            });
            
            // Handle double-click on select to apply
            document.getElementById('topico-select').addEventListener('dblclick', function() {
                document.getElementById('topico-aplicar').click();
            });
        });
        
        // Function to close the topic popup
        function closeTopicoPopup() {
            const popup = document.getElementById('topico-popup');
            const overlay = document.getElementById('topico-overlay');
            textarea.focus();
            
            if (popup) {
                popup.remove();
            }
            
            if (overlay) {
                overlay.remove();
            }
        }
    } else if (acao == 'IMAGEM') {
        // Chamar o servidor para obter o popup de imagem
        call('imagem_popup', '').then(function(resposta) {
            // Adicionar o popup ao DOM
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = resposta;
    
            document.body.appendChild(tempDiv.children[1]); // Coloca primeiro o overlay 
            document.body.appendChild(tempDiv.firstChild);  // coloca o popup 
    
            // Mostrar o popup
            const popup = document.getElementById('imagem-popup');
            const overlay = document.getElementById('imagem-overlay');
    
            popup.style.display = 'block';
            overlay.style.display = 'block';
            
            // Configurar o botão de seleção de arquivo
            document.getElementById('btn-selecionar-arquivo').addEventListener('click', function() {
                document.getElementById('imagem-arquivos').click();
            });
            
            // Atualizar o nome do arquivo quando selecionado
            document.getElementById('imagem-arquivos').addEventListener('change', function() {
                if (this.files.length > 0) {
                    document.getElementById('nome-arquivo-imagem').value = this.files[0].name;
                }
            });
            
            // Configurar manipuladores de eventos para os botões
            document.getElementById('imagem-aplicar').addEventListener('click', function() {
                const fileInput = document.getElementById('imagem-arquivos');

                // Verificar se um arquivo foi selecionado
                if (fileInput.files.length === 0) {
                    alerta('feed-fixo', 'Selecione uma imagem primeiro.');
                    return;
                }

                arquivo = fileInput.files[0];
                const nomeArquivo = fileInput.files[0].name;                

                const aplicar = async () => {
                    const retorno = await enviarArquivo(arquivo);
                    if (retorno.split('|')[0] == 'OK' || retorno.split('|')[0] == 'ERRO_EXISTE') {
                        formatado = '<DOCF IMG=' + nomeArquivo + '>' + (texto_sel || '') + '</DOCF>';
                        texto = texto.substring(0, pos_sel_i) + formatado + texto.substring(pos_sel_f, texto.length + 1);
                        textarea.value = texto;
                        closeImagemPopup();
                    }
                };
                aplicar();
            });
            
            document.getElementById('imagem-cancelar').addEventListener('click', function() {
                closeImagemPopup();
            });
            
            // Fechar popup ao clicar no overlay
            overlay.addEventListener('click', function() {
                closeImagemPopup();
            });
        });
        
        // Função para fechar o popup de imagem
        function closeImagemPopup() {
            const popup = document.getElementById('imagem-popup');
            const overlay = document.getElementById('imagem-overlay');
            textarea.focus();
            
            if (popup) {
                popup.remove();
            }
            
            if (overlay) {
                overlay.remove();
            }
        }
    } else if (acao == 'LIMPAR') {
        if (confirm('Deseja realmente limpar a formata\u00e7\u00e3o do texto?')) {
            if (pos_sel_i == pos_sel_f) {
              pos_sel_i = 0; 
              pos_sel_f = texto.length-1;
            }  
            formatado = texto.substring(pos_sel_i, pos_sel_f);
            let achou = 'S',
                count = 0,
                pos_i = 0,
                pos_f = 0;
            formatado = formatado.replace(/\<\/DOCF\>/g,''); 
            while (achou == 'S' && count < 100) {
              count     = count + 1;
              pos_i = formatado.indexOf('<DOCF');
              pos_f = formatado.substring(pos_i, formatado.length+1).indexOf('>') + pos_i +1;
              if (pos_i < 0 || pos_f < 0 || pos_f < pos_i) {
                achou = 'N';
              } else {
                formatado = formatado.substring(0,pos_i) + formatado.substring(pos_f,formatado.length+1); 
              }
            }
            texto = texto.substring(0,pos_sel_i) + formatado + texto.substring(pos_sel_f,texto.length+1); 
            textarea.value = texto;          
        }  
    
    }    
}

// Variável global para armazenar o ID do conteúdo selecionado para movimento
let conteudoMovendoId = null;

// Função para iniciar o modo de movimento de conteúdo
function conteudo_mover_iniciar(id_conteudo) {
    
    // Marca o botão como selecionado e o bloco como marcador para mover 
    document.getElementById('cadcon-ordem-' + id_conteudo).classList.add('marcado-mover');
    document.getElementById('conteudo-item-' + id_conteudo).classList.add('marcado-mover');
    conteudoMovendoId = id_conteudo;
    
    // Adiciona uma classe visual para indicar que está em modo de movimento
    document.querySelectorAll('.cadastro-conteudo-item').forEach(item => {
        if (item.id !== 'conteudo-item-' + id_conteudo) {
            item.classList.add('modo-mover');
        }
    });
    
    // Mostra uma mensagem para o usuário
    alerta('feed-fixo', 'Clique no item para onde deseja mover o conteúdo');
}

// Função para completar o movimento do conteúdo
function conteudo_mover_completar(id_conteudo_destino) {
    // Verifica se há um conteúdo selecionado para mover
    if (!conteudoMovendoId) {
        return;
    }
    
    // Verifica se não está tentando mover para o mesmo item
    if (conteudoMovendoId === id_conteudo_destino) {
        conteudo_mover_cancelar();
        return;
    }
    
    // Chama a procedure do servidor para atualizar as sequências
    call('conteudo_move', 'prm_id_conteudo_origem=' + conteudoMovendoId + '&prm_id_conteudo_destino=' + id_conteudo_destino)
        .then(function(resposta) {
            const resultado = resposta.split('|');
            
            if (resultado[0] === 'OK') {
                // Obtém os elementos DOM
                const itemOrigem = document.getElementById('conteudo-item-' + conteudoMovendoId);
                const itemDestino = document.getElementById('conteudo-item-' + id_conteudo_destino);
                const container = itemOrigem.parentNode;
                
                // Remove o item de origem
                container.removeChild(itemOrigem);
                
                // Insere o item de origem após o item de destino
                //if (itemDestino.nextSibling) {
                if (itemDestino.previousSibling) {
                    container.insertBefore(itemOrigem, itemDestino.previousSibling);
                } else {
                    container.appendChild(itemOrigem);
                }
                
                // Mostra mensagem de sucesso
                alerta('feed-fixo', resultado[1]);
            } else {
                // Mostra mensagem de erro
                alerta('feed-fixo', resultado[1]);
            }
            
            // Limpa o modo de movimento
            conteudo_mover_cancelar();
        });
}

// Função para cancelar o movimento
function conteudo_mover_cancelar() {
    if (conteudoMovendoId) {
        document.getElementById('cadcon-ordem-' + conteudoMovendoId).classList.remove('marcado-mover');
        document.getElementById('conteudo-item-' + conteudoMovendoId).classList.remove('marcado-mover');
        conteudoMovendoId = null;
        document.querySelectorAll('.cadastro-conteudo-item.modo-mover').forEach(item => {
            item.classList.remove('modo-mover');
        });
    }
}

// Função para lidar com o clique no botão de ordem
function conteudo_ordem_click(event, id_conteudo) {
    event.stopPropagation(); // Impede que o evento se propague para o item pai   
    if (conteudoMovendoId) {
        if (id_conteudo == conteudoMovendoId) {
            conteudo_mover_cancelar();  // Se já estiver em modo de movimento, cancela
        } else {
            conteudo_mover_completar(id_conteudo);
            event.stopPropagation(); // Impede que o evento se propague
            event.preventDefault(); // Impede a ação padrão
        } 
    } else {
        conteudo_mover_iniciar(id_conteudo); // Inicia o modo de movimento
    }
}

// Função para alternar para o modo de edição
function toggleTextareaEdit(id_conteudo) {
    
    // Se está em modo de movimento então não faz nada
    if (conteudoMovendoId) {
        return;
    } 

    // Ocultar todas as barras de ferramentas antes de mostrar a atual
    for (let a=0;a<document.querySelectorAll('.cadcon-texto-toolbar').length;a++) {
        let toolbar = document.querySelectorAll('.cadcon-texto-toolbar')[a];
        if (toolbar.classList.contains('visible')) {
            id_conteudo_visible = toolbar.getAttribute('data-id_conteudo'); 
            finishTextareaEdit(id_conteudo_visible, 'CANCELAR');
        }    
    } 

    // Ocultar a div de visualização
    const viewDiv = document.getElementById('cadcon-texto-view-' + id_conteudo);
    const textarea = document.getElementById('cadcon-texto-' + id_conteudo);
    
    if (viewDiv && textarea) {
        let altura = (viewDiv.clientHeight + 6) + 'px';

        viewDiv.style.display = 'none';
        textarea.style.minHeight = altura;
        textarea.style.height = altura;
        textarea.style.display = 'block';
        textarea.focus();
       
        cadcon_toolbar_habilita(id_conteudo, true); // Habilitar a barra de ferramentas
    }
}

// Função para finalizar a edição e voltar para o modo de visualização
function finishTextareaEdit(id_conteudo, acao) {

    const viewDiv      = document.getElementById('cadcon-texto-view-' + id_conteudo);
    const textarea     = document.getElementById('cadcon-texto-' + id_conteudo);
    const textarea_ant = document.getElementById('cadcon-texto-' + id_conteudo+ '-anterior');
    
    if (viewDiv && textarea) {
        
        // Ocultar o textarea e mostrar a div
        textarea.style.display = 'none';
        viewDiv.style.display = 'block';
       
        cadcon_toolbar_habilita(id_conteudo, false);  // Desabilitar a barra de ferramentas

        if (acao == 'SALVAR') {
            conteudo_atualiza(textarea, id_conteudo, 'DS_TEXTO'); // Atualizar o conteúdo no servidor
        } else {
            textarea.value = textarea_ant.value; // Reverter para o valor anterior
        }    

    }    

}
