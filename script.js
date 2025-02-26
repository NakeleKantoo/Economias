window.onload = onWindowLoad;
var index = 0;
function onWindowLoad() {
    //addGastos();
}

function changeToRegister() {
    document.getElementById('login').style.display='none';
    document.getElementById('register').style.display='flex';
}

function changeToLogin() {
    document.getElementById('login').style.display='flex';
    document.getElementById('register').style.display='none';
}

function login() {
    let email = document.getElementById('email').value;
    let pass = document.getElementById('senha').value;
    let obj = {email, pass};
    let body = JSON.stringify(obj);
    console.log(obj);
    let res = httpPost("https://www.leonnaviegas.dev.br/api/auth", body);
    res = JSON.parse(res);
    document.cookie = "auth="+res.code;
    document.location.href = "https://www.leonnaviegas.dev.br/economias/gastos";
    console.log(res);
}

function registrar() {
    let name = document.getElementById('Rnome').value;
    let email = document.getElementById('Remail').value;
    let pass = document.getElementById('Rsenha').value;
    let obj = {name, email, pass};
    let body = JSON.stringify(obj);
    console.log(obj);
    let res = httpPut("https://www.leonnaviegas.dev.br/api/auth", body);
    res = JSON.parse(res);
    document.cookie = "auth="+res.code;
    document.location.href = "https://www.leonnaviegas.dev.br/economias/gastos";
    console.log(res);
}


function httpPut(theUrl, body) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "PUT", theUrl, false ); // false for synchronous request
    xmlHttp.send( body );
    return xmlHttp.responseText;
}

function httpDelete(theUrl) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "DELETE", theUrl, false ); // false for synchronous request
    xmlHttp.send( null );
    return xmlHttp.responseText;
}

function httpPost(theUrl, body) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "POST", theUrl, false ); // false for synchronous request
    xmlHttp.send( body );
    return xmlHttp.responseText;
}

function httpGet(theUrl, body)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
    xmlHttp.send( body );
    return xmlHttp.responseText;
}



function gotoRemove() {
    window.location.href = "https://leonnaviegas.dev.br/economias/remover";
}

function gotoEdit() {
    window.location.href = "https://leonnaviegas.dev.br/economias/editar";
}

function gotoStats() {
    window.location.href = "https://leonnaviegas.dev.br/economias/stats";
}