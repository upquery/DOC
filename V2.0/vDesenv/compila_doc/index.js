#!/usr/bin/env node

import oracledb from 'oracledb';
import path from 'node:path'; 
import fs from 'node:fs';

// Caminho do codigo fonte chamado
const dirDoc = path.join(process.env.USERPROFILE,'FONTES','OUTROS','DOC','V2.0','vDesenv');
const dirSql = path.join(dirDoc, 'UPDOC');
const dirWeb = path.join(dirDoc, 'web');

// Configuração de conexão
const dbDocs = {
    user: 'DWU',
    host: 'conexoes.upquery.com',
    password: '2iGh952aSUL1',
    port: '1522',
    service: 'documentacao',
};

async function conexao(user, senha, service, host, port = '1521') {
    let connection;
    try {
        connection = await oracledb.getConnection({
            user: user,
            password: senha,
            connectString: `${host}:${port}/${service}`
        });
        console.log('\n' + '\x1b[32m' + `Conectado no serviço ${service} no usuário ${user}!` + '\x1b[0m\n\n');
        return connection;
    }
    catch (err) {
        console.error('\n' + '\x1b[31m' + 'Erro ao conectar ao banco de dados:' + err.message + '\x1b[0m');
        return null;
    }
}

function getBufferFile(fileName = '', tipo = 'sql') {
    // Ler o arquivo como buffer
    const fileData = fs.readFileSync(path.join(tipo === 'sql' ? dirSql : dirWeb, fileName));

    if(fileData?.length === 0) {
        console.log('\n'+'\x1b[31m'+'O arquivo está vazio ou não foi encontrado: '+fileName+'\x1b[0m');
        return null;
    }

    return fileData;
}

async function inserirBlob(conn, fileName, logger = console.log) {
    if(!conn) {
        console.error('Conexão não foi passada corretamente.');
        return;
    }

  try {
    // Ler o arquivo como buffer
    const fileData = getBufferFile(fileName, 'web');

    // Existe o arquivo no banco?
    const countFile = await conn.execute(
        `SELECT COUNT(*) AS count FROM TAB_DOCUMENTOS WHERE upper(name) = :fileName`,
        { fileName: fileName.toUpperCase() }
    ).then(result => result.rows).then(result => result[0]);

    if(countFile[0] > 0) {
        await conn.execute(
            `UPDATE TAB_DOCUMENTOS SET blob_content = :blob WHERE upper(name) = :fileName`,
            {
                blob: fileData,
                fileName: fileName.toUpperCase()
            },
            { autoCommit: true }
        );
        logger('\x1b[32m' + `Arquivo ${fileName} atualizado com sucesso!`+'\x1b[0m');
        return;
    }

    // Inserir o BLOB
    logger(`O arquivo ${fileName} não existe no banco de dados\n\nFazendo inserção...` + '\n');
    await conn.execute(
        `INSERT INTO TAB_DOCUMENTOS (name, blob_content,last_updated) VALUES (:fileName, :blob, sysdate)`,
        {
            fileName: fileName,
            blob: fileData
        },
        { autoCommit: true }
    );


    logger('\x1b[32m' + `Arquivo ${fileName} inserido com sucesso!`+'\x1b[0m');
  } catch (err) {
    logger('Erro:', err);
  } 
}

async function compilePLSQL(conn, fileName, logger = console.log) {
    if(!conn) {
        console.error('Conexão não foi passada corretamente.');
        return;
    }
     
    try{
        const fileData = getBufferFile(fileName, 'sql');
        // Corrigir a conversão para string
        const sql = fileData.toString('utf8');
        
        // Executar o SQL
        await conn.execute(sql);
        
        logger('\x1b[32m' + `${fileName} compilado com sucesso!` + '\x1b[0m');

    } catch(err) {
        logger('\x1b[31m' + `Erro ao compilar ${fileName}:` + '\x1b[0m', err.message);
    }
    
}

function getLogger() {
    const fila = [];
    function logger(message) {
        if(message.indexOf('sucesso!') > 0){
            fila.push(message);
            return;
        }
        console.log(message);
    };
    logger.logSuccess = function () {
        while (fila.length > 0) {
            console.log(fila.shift());
        }
    };

    return logger;
}

const args =process.argv.slice(2);

// Principal

let conn;
conexao(dbDocs.user, dbDocs.password, dbDocs.service, dbDocs.host, dbDocs.port)
            .then(async connection => {
                conn = connection;
                let all = false;
                let encontrou = false;
                const logger = getLogger();

                if (args.includes('--all')) {
                    all = true;
                } 

                if( all || args.includes('--js') ) {
                    encontrou = true;
                    console.log('JS flag detectada!\n');
                    await inserirBlob(conn, 'updoc.js', logger);
                }
                if (all || args.includes('--css')) {
                    encontrou = true;
                    console.log('CSS flag detectada!\n');
                    await inserirBlob(conn, 'updoc.css', logger);
                } 
                
                if (all || args.includes('--plsql') || args.includes('--head')){
                    encontrou = true;
                    console.log('HEAD flag detectada!\n');
                    await compilePLSQL(conn, 'updoc_header.sql', logger);
                }

                if (all || args.includes('--plsql') || args.includes('--sql')){
                    encontrou = true;
                    console.log('SQL flag detectada!\n');
                    await compilePLSQL(conn, 'updoc.sql', logger);
                }

                if(!encontrou){
                    console.log("\n"+
                        "Uso: docs [flags]"+"\n\n"+

                        "Opções:"+"\n"+
                        "   --js      faz upload do updoc.js"+"\n"+
                        "   --css     faz upload do updoc.css"+"\n"+
                        "   --head    compila a package updoc_header.sql"+"\n"+
                        "   --sql     compila o body da package updoc.sql"+"\n"+
                        "   --plsql   atalho para compilar o head e o body da package updoc"+"\n"+
                        "   --all     Roda todas as operações acima"+"\n"+
                        "   --help    Mostra esta ajuda"+"\n"
                    );
                    return;
                }

                logger.logSuccess();
            })
            .catch(console.error)
            .finally(() => conn?.close());