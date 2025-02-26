local server = require 'http.server'
local headers = require 'http.headers'

local driver = require 'luasql.mysql'
local env = driver.mysql()
local json = require('json')

local bcrypt = require('bcrypt')


local function gethammertime()
    return tonumber(assert(assert(io.popen'date +%s%3N'):read'a'))
end
math.randomseed(gethammertime())

local config = {}
local srv = server.listen {
  host = '0.0.0.0',
  port = 7272,
  tls = false,
  onstream = function (sv, out)
    local hdrs = out:get_headers()
    local authCode = hdrs:get('Authorization')
    local method = hdrs:get(':method')
    local path = hdrs:get(':path') or '/'
    local body = out:get_body_as_string()
    local rh = headers.new()
    rh:append(':status','200')
    rh:append('content-type','application/json')
    rh:append("Access-Control-Allow-Origin", "*")
    rh:append("Access-Control-Allow-Headers", "Origin, crossorigin")

    --if hdrs:get("authorization")~=config.pass then
    --    rh:upsert(":status","403")
    --    out:write_headers(rh,false)
    --    out:write_chunk('{"error":"true","text":"Acesso não autorizado"}',true)
    --end

    if authCode then print("auth code: "..authCode) end

    local command = split(path,"/")
    print(#command)
    if #command==0 then
        rh:upsert(":status","404")
        out:write_headers(rh,false)
        out:write_chunk('{"error":"true","text":"Endpoint desconhecido"}',true)
    end
    if method == "GET" then
        if command[1] == "meiopagamento" then
            out:write_headers(rh, false)
            out:write_chunk(readMeioPagamento(), true)
        elseif command[1] == "categoria" then
            out:write_headers(rh, false)
            out:write_chunk(readCategoria(), true)
        elseif command[1] == "gastos" then
            if #command==3 then
                if command[2] == "mes" then
                    out:write_headers(rh, false)
                    out:write_chunk(readGastosMes(command[3]), true)
                end
            elseif #command==2 and command[2]=="raw" then
                out:write_headers(rh, false)
                out:write_chunk(readGastosRaw(), true)
            else
                out:write_headers(rh, false)
                out:write_chunk(readGastos(), true)
            end
        end
    elseif method == "POST" then
        if command[1] == "gastos" then
            addGasto(body)
            out:write_headers(rh, false)
            out:write_chunk('{"error"="false","text":"Adição feita com sucesso"}', true)
        elseif command[1] == "auth" then
            local returnObj = checkAuth(body)
            out:write_headers(rh, false)
            out:write_chunk(returnObj, true)
        end

    elseif method == "DELETE" then
        if command[1] == "gastos" then
            deleteGasto(command[2])
            out:write_headers(rh, false)
            out:write_chunk('{"error"="false","text":"Remoção feita com sucesso"}', true)
        end
    elseif method == "PUT" then
        if command[1] == "gastos" then
            modifyGasto(body,command[2])
            out:write_headers(rh, false)
            out:write_chunk('{"error"="false","text":"Alteração feita com sucesso"}', true)
        elseif command[1] == "auth" then
            local returnObj = addUser(body)
            out:write_headers(rh, false)
            out:write_chunk(returnObj, true)
        end
    end
    
    
  end,
  onerror = function (err, errn, a, b, c, d, e)
    print(err, errn,a,b,c,d,e)
  end
}

function checkAuth(body)
    print(body)
    local t = json.decode(body)
    local email = t.email
    local pass = t.pass
    local query = "select senha from usuarios where email='"..email.."';"
    local cur, err = conn:execute(query)
    local cache = {}
    if cur then
        print("uau")
        cur:fetch(cache, "n")
        if bcrypt.verify(pass, cache[1]) then
            print("deu certo")
            local res = {text="Success", error=false, code=randomString(255)}
            local query = "insert into auth (code) values ('"..res.code.."');"
            local resTxt = json.encode(res)
            return resTxt
        else
            print("deu errado")
            return json.encode({text="POOOOOOOOOOOOOOOORRA", error=true, code=""})
        end
    else
        print("deu errado")
        return json.encode({text="POOOOOOOOOOOOOOOORRA", error=true, code=""})
    end
end

function addUser(body)
    print(body)
    local t = json.decode(body)
    local name = t.name
    local email = t.email
    local pass = t.pass
    local log_rounds = 9 --change if too slow/quick
    local hashed = bcrypt.digest(pass, log_rounds)
    local query = "insert into usuarios (nome, email, senha) values ('"..name.."','"..email.."','"..hashed.."');"
    local cur, err = conn:execute(query)
    if cur then
        print("Sucesso")
        local code = randomString(255)
        local query = "insert into auth (code) values ('"..code.."');"
        return json.encode({text="Success", error=false, code=code})
    else
        print("Erro")
        return json.encode({text="Erro: "..err, error=true})
    end
end

function split(inputstr, sep)
	if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function addGasto(str)
    local table = json.decode(str)
    local stmt = "INSERT INTO gastos (titulo, categoria, meiopagamento, dsc, dtgasto, valor) VALUES ('"..table.titulo.."', '"..table.categoria.."','"..table.meiopagamento.."','"..table.dsc.."','"..table.dtgasto.."','"..table.valor.."')"
    print(stmt)
    local num, err = conn:execute(stmt)
    print(num, err)
end

function modifyGasto(str,id)
    local table = json.decode(str)
    local stmt = "UPDATE gastos SET titulo = '"..table.titulo.."', categoria = '"..table.categoria.."', meiopagamento = '"..table.meiopagamento.."', dsc = '"..table.dsc.."', dtgasto = '"..table.dtgasto.."', valor = '"..table.valor.."' WHERE id='"..id.."';"
    print(stmt)
    local num, err = conn:execute(stmt)
    print(num, err)
end

function readMeioPagamento()
    local cur = conn:execute("select * from meioPagamento;")
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return "{}" end
    obj = json.encode(table)
    print(obj)
    return obj
end

function readCategoria()
    local cur = conn:execute("select * from categoria;")
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return "{}" end
    obj = json.encode(table)
    print(obj)
    return obj
end

function readGastos()
    local cur, err = conn:execute("select gastos.id, gastos.titulo, categoria.nome as categoria, meioPagamento.nome as meioPagamento, gastos.dsc, gastos.dtgasto, gastos.valor from gastos, categoria, meioPagamento where gastos.categoria=categoria.id and gastos.meioPagamento=meioPagamento.id;")
    if not cur then
        print(err)
        return "{}"
    end
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return "{}" end
    obj = json.encode(table)
    print(obj)
    return obj
end

local user, pass = "",""
function readConfig()
    local filename = ".env"
    local file = io.open(filename,"r")
    local config = file:read("a")
    local obj = json.decode(config)
    user = obj.user
    pass = obj.pass
end
readConfig()
print(user, pass)
local conn = env:connect('economia',user,pass)


srv:listen()
local n, err, errnum = srv:loop()

if n==nil then print(err,errnum) end