function checkAuth(body)
    local t = json.decode(body)
    local email = t.email
    local pass = t.pass
    local query = "select senha from usuarios where email='"..email.."';"
    local cur, err = conn:execute(query)
    local cache = {}
    if cur then
        cur:fetch(cache, "n")
        if bcrypt.verify(pass, cache[1]) then
            local res = {text="Success", error=false, code=randomString(255)}
            local query = "insert into auth (code) values ('"..res.code.."');"
            local resTxt = json.encode(res)
            return resTxt
        else
            return json.encode({text="ERRO: Senha ou Usuario invalido", error=true, code=""})
        end
    else
        return json.encode({text="ERRO: Senha ou Usuario invalido", error=true, code=""})
    end
end

function addUser(body)
    local t = json.decode(body)
    local name = t.name
    local email = t.email
    local pass = t.pass
    local log_rounds = 9 --change if too slow/quick
    local hashed = bcrypt.digest(pass, log_rounds)
    local query = "insert into usuarios (nome, email, senha) values ('"..name.."','"..email.."','"..hashed.."');"
    local cur, err = conn:execute(query)
    if cur then
        local code = randomString(255)
        local query = "insert into auth (code) values ('"..code.."');"
        return json.encode({text="Success", error=false, code=code})
    else
        return json.encode({text="Erro", error=true})
    end
end