function addGasto(str)
    local table = json.decode(str)
    local stmt = "INSERT INTO gastos (titulo, categoria, meiopagamento, dsc, dtgasto, valor) VALUES ('"..table.titulo.."', '"..table.categoria.."','"..table.meiopagamento.."','"..table.dsc.."','"..table.dtgasto.."','"..table.valor.."')"
    local num, err = conn:execute(stmt)
    return num, err
end

function modifyGasto(str,id)
    local table = json.decode(str)
    local stmt = "UPDATE gastos SET titulo = '"..table.titulo.."', categoria = '"..table.categoria.."', meiopagamento = '"..table.meiopagamento.."', dsc = '"..table.dsc.."', dtgasto = '"..table.dtgasto.."', valor = '"..table.valor.."' WHERE id='"..id.."';"
    local num, err = conn:execute(stmt)
    return num, err
end

function readGastosMes(mes)
    local date = os.date("*t")
    local timestampstart = date.year.."-"..mes.."-01"
    local timestampend = date.year.."-"..mes.."-31"
    local cur, err = conn:execute("select gastos.id, gastos.titulo, categoria.nome as categoria, meioPagamento.nome as meioPagamento, gastos.dsc, gastos.dtgasto from gastos, categoria, meioPagamento where gastos.categoria=categoria.id and gastos.meioPagamento=meioPagamento.id and dtgasto>='"..timestampstart.."' and dtgasto<='"..timestampend.."';")
    if not cur then
        return nil, err
    end
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return nil, "Erro desconhecido" end
    obj = json.encode(table)
    return obj
end

function deleteGasto(id)
    local stmt = "DELETE FROM gastos WHERE id='"..id.."';"
    local num, err = conn:execute(stmt)
end

function readGastosRaw()
    local cur, err = conn:execute("select * from gastos;")
    if not cur then
        return nil, err
    end
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return nil, "Erro desconhecido" end
    obj = json.encode(table)
    return obj
end

function readGastos()
    local cur, err = conn:execute("select gastos.id, gastos.titulo, categoria.nome as categoria, meioPagamento.nome as meioPagamento, gastos.dsc, gastos.dtgasto, gastos.valor from gastos, categoria, meioPagamento where gastos.categoria=categoria.id and gastos.meioPagamento=meioPagamento.id;")
    if not cur then
        return nil, err
    end
    local obj = ""
    local table = {}
    local t = {}
    while cur:fetch(t,"a") do
        table[#table+1] = deepcopy(t)
    end
    if #table==0 then return nil, "Erro desconhecido" end
    obj = json.encode(table)
    print(obj)
    return obj
end