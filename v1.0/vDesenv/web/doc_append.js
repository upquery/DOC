// Append this function to the existing doc.js file

function cadastro_conteudo_excluir() {
    let id_conteudo = document.querySelector('.cadastro-conteudo.selecionado')?.querySelector('.cadcon-conteudo')?.getAttribute('id')?.replace('cadcon-conteudo-', '');
    
    if (!id_conteudo) {
        alerta('', 'Selecione um conteúdo para excluir.');
        return;
    }

    if (confirm('Confirma a exclusão do conteúdo?')) {
        call('conteudo_excluir', 'prm_id_conteudo=' + id_conteudo).then(function(resposta) { 
            alerta('', resposta.split('|')[1]); 
            if(resposta.split('|')[0] == 'OK') { 
                document.querySelector('.cadastro-conteudo.selecionado').remove();
                document.getElementById('cadastro-menu-direito').innerHTML = '';
            }
        });    
    }
}