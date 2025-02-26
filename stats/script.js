window.onload = onWindowLoad;

function onWindowLoad() {
    addGastos();
}


function addGastos() {
    let gastosList = document.getElementById('gastosList');
    let response = httpGet('https://leonnaviegas.dev.br/api/gastos');
    let obj = JSON.parse(response);
    obj.sort(function(a, b){return a.id-b.id})
    console.log(obj);
    for (var i = gastosList.rows.length-1; i>=0; i--) {
        console.log(i);
        gastosList.deleteRow(i);
    }
    for (var i = 0; i<=obj.length-1; i++){
        var gasto = obj[i];
        var tr = gastosList.insertRow(i);
        
        var tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.id}</td>`;
        tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.titulo}</td>`;
        tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.categoria}</td>`;
        tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.meioPagamento}</td>`;
        tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.dsc}</td>`;
        tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.valor}</td>`;
        var data = new Date(Date.parse(gasto.dtgasto));
        tc = tr.insertCell(); tc.innerHTML = `<td>${data.getDate()}/${data.getMonth()+1}/${data.getFullYear()}</td>`;
    }
}

function adicionarGasto() {
    let tituloObj = document.getElementById('titulo');
    let categoriaObj = document.getElementById('categoria');
    let meiopagamentoObj = document.getElementById('meiopagamento');
    let descricao = document.getElementById('descricao');
    let datapagamento = document.getElementById('datapagamento');

    let obj = {
        titulo:tituloObj.value,
        categoria:categoriaObj.value,
        meiopagamento:meiopagamentoObj.value,
        dsc:descricao.value,
        dtgasto:datapagamento.value
    };

    let body = JSON.stringify(obj);
    console.log(body);
    let response = httpPost('https://leonnaviegas.dev.br/api/gastos', body);
    console.log(response);
    addGastos();
}

function httpPost(theUrl, body) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "POST", theUrl, false ); // false for synchronous request
    xmlHttp.send( body );
    return xmlHttp.responseText;
}

function httpGet(theUrl)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
    xmlHttp.send( null );
    return xmlHttp.responseText;
}

function gotoRemove() {
    window.location.href = "https://leonnaviegas.dev.br/economias/remover";
}

function gotoEdit() {
    window.location.href = "https://leonnaviegas.dev.br/economias/editar";
}

function gotoAdd() {
    window.location.href = "https://leonnaviegas.dev.br/economias";
}