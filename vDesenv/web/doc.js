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

async function uploadArquivos(prm_alternativo, input_id) {
    var arquivosInput = document.getElementById(input_id||'arquivos');
    var arquivos = arquivosInput.files;
    var acao = 'dwu.doc.upload';
   
    let ele = document.getElementById('escolherArquivoButton');
    let id_conteudo = ele.getAttribute('data-id_topico');
    conteudo_atualiza(ele, id_conteudo, 'DS_TITULO');

    var arquivo = arquivos[0];
    await enviarArquivo(arquivo, acao);
}

function enviarArquivo(arquivo, acao) {
    return new Promise(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open('POST', acao, true);
      xhr.onload = function () {
        alerta('feed-fixo', xhr.responseText.split('|')[1]);
        resolve();
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
        conteudo = ele.innerHTML;    
    }

console.log('x2');
console.log(conteudo)    ;
console.log(ele)    ;


    var conteudo_ant = '',
        tipo_ant     = '';
    if (document.getElementById(ele.id+'-anterior')) {
        conteudo_ant = document.getElementById(ele.id+'-anterior').innerHTML;
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
            }    
        });    
    }    
}    

function conteudo_tela_cadastro(ele, id_conteudo){
    
    call('conteudo_tela_cadastro', 'prm_id_conteudo='+id_conteudo).then(function(resposta){ 
        if(resposta.split('|')[0] == 'ERRO|'){ 
            alerta('',resposta.split('|')[1]); 
        } else {
            document.getElementById('cadastro-conteudo-altera').innerHTML = resposta; 

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
    let campos = document.querySelector('.cadcon-cadastro').querySelectorAll('.cadcon-cadastro-linha');

    for (let a=0;a<campos.length;a++){
        if (campos[a].id != 'cadastro-tp_conteudo' && campos[a].id != 'cadastro-id_ativo' && campos[a].id != 'cadastro-nr_linhas_antes') {
            campos[a].classList.add('ocultar');
        }
    }

    if (tp_conteudo == 'IMAGEM') {
        document.getElementById('cadastro-id_estilo').classList.remove('ocultar');
        document.getElementById('cadastro-ds_titulo').classList.remove('ocultar');
    }    

    if (['PARAGRAFO','MARCADOR1','MARCADOR2','MARCADOR3','MARCADOR4'].indexOf(tp_conteudo) != -1) {
        document.getElementById('cadastro-id_estilo').classList.remove('ocultar');
    }    

}    

function conteudo_tela_conteudos(cd_pergunta){
  
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
            // Refresh the content area to show the new item
            conteudo_tela_conteudos(pergunta);
            alerta('', resultado[1]);
            
            // Select the new content for editing
            let id_conteudo = resultado[2];
            setTimeout(function() {
                //let novoConteudo = document.querySelector('#cadcon-conteudo-' + id_conteudo)?.closest('.cadastro-conteudo-item');
                let novoConteudo = document.querySelector('#cadcon-conteudo-' + id_conteudo);
                if (novoConteudo) {
                    conteudo_tela_cadastro(novoConteudo, id_conteudo);
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
        id_estilo: Array.from(form.querySelector('#id_estilo')?.selectedOptions || [])
                        .map(opt => opt.value)
                        .filter(val => val)
                        .join('|') || null,
        nr_linhas_antes: form.querySelector('#nr_linhas_antes')?.value || '0',
        id_ativo: form.querySelector('#id_ativo')?.checked ? 'S' : 'N'
    };

    call('cadastro_conteudo_salvar', 
            'prm_id_conteudo=' + id_conteudo + 
            '&prm_tp_conteudo=' + encodeURIComponent(dados.tp_conteudo) +
            '&prm_id_estilo=' + encodeURIComponent(dados.id_estilo || '') +
            '&prm_nr_linhas_antes=' + dados.nr_linhas_antes +
            '&prm_id_ativo=' + dados.id_ativo
    ).then(function(resposta) {
        alerta('', resposta.split('|')[1]);
        if (resposta.split('|')[0] == 'OK') {
            // Refresh a tela de conteudos 
            let cd_pergunta = document.getElementById('cadastro-conteudo-id').getAttribute('data-pergunta');
            if (cd_pergunta) {
                conteudo_tela_conteudos(cd_pergunta);
                setTimeout(function() {
                    document.getElementById('conteudo-item-' + id_conteudo).classList.add('selecionado');
                }, 500);
            }
        }
    });
}
