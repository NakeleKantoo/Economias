//window.onload = onWindowLoad;
//window.onresize = resizeItems;
$(document).ready(onWindowLoad);
var index = 0;
cache = {};

let mpCache = {};
let catCache = {};
function onWindowLoad() {
    addGastos();
    addCategories();
    addMeioPagamento();
}

function addCategories() {
    let categoria = document.getElementById('categoria');
    let response = httpGet('https://www.leonnaviegas.dev.br/api/categoria');
    let obj = JSON.parse(response);
    for (var i = 0; i<=obj.length-1; i++){
        var opt = document.createElement('option');
        opt.value = obj[i].id;
        opt.innerHTML = obj[i].nome;
        categoria.appendChild(opt);
        catCache[obj[i].nome] = obj[i].id;
    }
}

function addMeioPagamento() {
    let meiopagamento = document.getElementById('meiopagamento');
    let response = httpGet('https://www.leonnaviegas.dev.br/api/meiopagamento');
    let obj = JSON.parse(response);
    for (var i = 0; i<=obj.length-1; i++){
        var opt = document.createElement('option');
        opt.value = obj[i].id;
        opt.innerHTML = obj[i].nome;
        meiopagamento.appendChild(opt);
        mpCache[obj[i].nome] = obj[i].id
    }
}

function addGastos() {
    //let gastosList = document.getElementById('gastosList');
    let gastosTable = document.getElementById('gastosTable');
    let response = httpGet('https://www.leonnaviegas.dev.br/api/gastos');
    let obj = JSON.parse(response);
    obj.sort(function(a, b){return b.id-a.id});
    obj.sort(function(a, b){return (a.dtgasto < b.dtgasto) ? 1 : ((a.dtgasto > b.dtgasto) ? -1 : 0);})
    cache = obj;
    console.log(obj);
    while(gastosTable.lastElementChild) {
        console.log(gastosTable.lastElementChild);
        if (gastosTable.lastElementChild.id == "Add") { break; }
        gastosTable.removeChild(gastosTable.lastElementChild);
    }
    index = 0;
    //var firstTr = gastosList.insertRow(gastosList.rows.length);
    for (var i = 0; i<=obj.length-1; i++){
        var gasto = obj[i];
        var div = document.createElement('div');
        div.className="item";
        div.setAttribute("onclick",`openEdit(${i})`);
        var another = document.createElement('div');
        another.style = "display:flex; justify-content:center; background-color: var(--secondary); height: 0.2fr; width: 100%; position:absolute; top:0px; margin: 0px; border-radius: 5px 5px 0px 0px;";
        var titulo = document.createElement('p');
        titulo.innerHTML=gasto.titulo;
        titulo.style="text-align:center; font-size:1.3em; margin-bottom: 5px"
        another.appendChild(titulo);
        div.appendChild(another);
        gastosTable.appendChild(div);
        var distance = another.offsetHeight;
        var text = document.createElement('p');
        var data = new Date(Date.parse(gasto.dtgasto));
        var dia = `${('0'+data.getDate()).slice(-2)}/${('0'+(data.getMonth()+1)).slice(-2)}/${(data.getFullYear())}`;
        text.innerHTML='Data: '+`${dia}`;
        text.style="text-align:center; border-bottom: 3px solid var(--secondary); padding-bottom:3px; margin-top: "+(distance+10)+"px;"
        div.appendChild(text);
        var another = document.createElement('div');
        another.style = "display:grid; grid-template-columns: auto;";
        var text = document.createElement('p');
        text.innerHTML=gasto.categoria;
        text.style="text-align:center;"
        another.appendChild(text);
        //var text = document.createElement('p');
        //text.innerHTML=gasto.dsc;
        //text.style="text-align:center;"
        //another.appendChild(text);
        div.appendChild(another);
        var another = document.createElement('div');
        another.style = "display:grid; grid-template-columns: auto;";
        //var text = document.createElement('p');
        //text.innerHTML=gasto.meioPagamento;
        //text.style="text-align:center;"
        //another.appendChild(text);
        var text = document.createElement('p');
        text.innerHTML='R$ '+gasto.valor.replace('.',',');
        text.style="text-align:center;"
        another.appendChild(text);
        div.appendChild(another);
        
        //gastosTable.appendChild(div);
        //var tr = gastosList.insertRow(i+1);
        //if (gasto.id>index) {index=gasto.id;}
        //var tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.id}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.titulo}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.categoria}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.meioPagamento}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<td>${gasto.dsc}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<td>R$ ${gasto.valor}</td>`;
        //var data = new Date(Date.parse(gasto.dtgasto));
        //tc = tr.insertCell(); tc.innerHTML = `<td>${data.getDate()}/${data.getMonth()+1}/${data.getFullYear()}</td>`;
        //tc = tr.insertCell(); tc.innerHTML = `<button onclick="removerGasto('${gasto.id}')"><img src="img/bin.png" style="width:2em;"></button><button onclick="prepareEdit('${tr.rowIndex-1}')"><img src="img/edit.png" style="width:2em;"></button>`;
    }
    //var tc = firstTr.insertCell(); tc.innerHTML = `<button onclick="prepareAdd('${index}')" style="vertical-align:middle;"><img src="img/add.png" style="width:2em;"></button>`; tc.colSpan=8; tc.style="text-align:center;"
}

function openEdit(index) {
    let obj = cache[index];
    let titulo = obj.titulo;
    let categoria = catCache[obj.categoria];
    let meioPagamento = mpCache[obj.meioPagamento];
    let dsc = obj.dsc;
    let valor = obj.valor;
    let data = new Date(obj.dtgasto);
    let id = obj.id;
    data = `${(data.getFullYear())}-${('0'+(data.getMonth()+1)).slice(-2)}-${('0'+data.getDate()).slice(-2)}`;

    document.getElementById('myModal').style.display='block';
    let tituloObj = document.getElementById('titulo');
    let categoriaObj = document.getElementById('categoria');
    let meiopagamentoObj = document.getElementById('meiopagamento');
    let descricao = document.getElementById('descricao');
    let datapagamento = document.getElementById('datapagamento');
    let valorObj = document.getElementById('valor');

    tituloObj.value = titulo;
    categoriaObj.value = categoria;
    meiopagamentoObj.value = meioPagamento;
    descricao.value = dsc;
    datapagamento.value = data;
    valorObj.value = valor;

    let btn = document.getElementById('btnAdd');
    btn.setAttribute('onclick', 'editarGasto('+id+')');
    btn.textContent = "Editar";

    let btnRmv = document.getElementById('btnRmv');
    btnRmv.style.display='block';
    btnRmv.setAttribute('onclick', `removerGasto(${id})`);
}

function closeModal() {
    let data = new Date();
    data = `${(data.getFullYear())}-${('0'+(data.getMonth()+1)).slice(-2)}-${('0'+data.getDate()).slice(-2)}`;

    document.getElementById('myModal').style.display='block';
    let tituloObj = document.getElementById('titulo');
    let categoriaObj = document.getElementById('categoria');
    let meiopagamentoObj = document.getElementById('meiopagamento');
    let descricao = document.getElementById('descricao');
    let datapagamento = document.getElementById('datapagamento');
    let valorObj = document.getElementById('valor');

    tituloObj.value = "";
    categoriaObj.value = "";
    meiopagamentoObj.value = "";
    descricao.value = "";
    datapagamento.value = data;
    valorObj.value = "";

    let modal = document.getElementById('myModal');
    modal.style.display='none';

    let btn = document.getElementById('btnAdd');
    btn.setAttribute('onclick', 'adicionarGasto()');
    btn.textContent = "Adicionar Gasto";

    let btnRmv = document.getElementById('btnRmv');
    btnRmv.style.display='none';
}

function adicionarGasto() {
    let tituloObj = document.getElementById('titulo');
    let categoriaObj = document.getElementById('categoria');
    let meiopagamentoObj = document.getElementById('meiopagamento');
    let descricao = document.getElementById('descricao');
    let datapagamento = document.getElementById('datapagamento');
    let valorObj = document.getElementById('valor');

    let obj = {
        titulo:tituloObj.value,
        categoria:categoriaObj.value,
        meiopagamento:meiopagamentoObj.value,
        dsc:descricao.value,
        dtgasto:datapagamento.value,
        valor:valorObj.value
    };

    let body = JSON.stringify(obj);
    console.log(body);
    let response = httpPost('https://www.leonnaviegas.dev.br/api/gastos', body);
    console.log(response);
    addGastos();
    let modal = document.getElementById('myModal');
    modal.style.display='none';
}


function removerGasto(id) {
    let response = httpDelete('https://www.leonnaviegas.dev.br/api/gastos/'+id);
    console.log(response);
    addGastos();

    closeModal();
}

function editarGasto(id) {
    let tituloObj = document.getElementById('titulo');
    let categoriaObj = document.getElementById('categoria');
    let meiopagamentoObj = document.getElementById('meiopagamento');
    let descricao = document.getElementById('descricao');
    let datapagamento = document.getElementById('datapagamento');
    let valorObj = document.getElementById('valor');
    let obj = {
        titulo:tituloObj.value,
        categoria:categoriaObj.value,
        meiopagamento:meiopagamentoObj.value,
        dsc:descricao.value,
        dtgasto:datapagamento.value,
        valor:valorObj.value
    };

    let body = JSON.stringify(obj);
    console.log(body);
    let response = httpPut('https://www.leonnaviegas.dev.br/api/gastos/'+id, body);
    console.log(response);
    addGastos();

    closeModal();
}

function httpPut(theUrl, body) {
    var xmlHttp = new XMLHttpRequest();
    let auth = getCookie("auth");
    xmlHttp.open( "PUT", theUrl, false ); // false for synchronous request
    xmlHttp.setRequestHeader("Authorization", auth);
    xmlHttp.send( body );
    return xmlHttp.responseText;
}

function httpDelete(theUrl) {
    var xmlHttp = new XMLHttpRequest();
    let auth = getCookie("auth");
    xmlHttp.open( "DELETE", theUrl, false ); // false for synchronous request
    xmlHttp.setRequestHeader("Authorization", auth);
    xmlHttp.send( null );
    return xmlHttp.responseText;
}

function httpPost(theUrl, body) {
    var xmlHttp = new XMLHttpRequest();
    let auth = getCookie("auth");
    xmlHttp.open( "POST", theUrl, false ); // false for synchronous request
    xmlHttp.setRequestHeader("Authorization", auth);
    xmlHttp.send( body );
    return xmlHttp.responseText;
}

function httpGet(theUrl)
{
    var xmlHttp = new XMLHttpRequest();
    let auth = getCookie("auth");
    xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
    xmlHttp.setRequestHeader("Authorization", auth);
    xmlHttp.send( null );
    return xmlHttp.responseText;
}



function gotoRemove() {
    window.location.href = "https://www.leonnaviegas.dev.br/economias/remover";
}

function gotoEdit() {
    window.location.href = "https://www.leonnaviegas.dev.br/economias/editar";
}

function gotoStats() {
    window.location.href = "https://www.leonnaviegas.dev.br/economias/stats";
}

function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for(let i = 0; i <ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
    }
    return "";
  }

function openDialog() {
    let modal = document.getElementById('myModal');
    modal.style.display='block';
}