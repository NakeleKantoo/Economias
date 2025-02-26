function readGastosMes(mes)
    local date = os.date("*t")
    local timestampstart = date.year.."-"..mes.."-01"
    local timestampend = date.year.."-"..mes.."-31"
    local cur, err = conn:execute("select gastos.id, gastos.titulo, categoria.nome as categoria, meioPagamento.nome as meioPagamento, gastos.dsc, gastos.dtgasto from gastos, categoria, meioPagamento where gastos.categoria=categoria.id and gastos.meioPagamento=meioPagamento.id and dtgasto>='"..timestampstart.."' and dtgasto<='"..timestampend.."';")
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

function deleteGasto(id)
    local stmt = "DELETE FROM gastos WHERE id='"..id.."';"
    print(stmt)
    local num, err = conn:execute(stmt)
    print(num, err)
end

function readGastosRaw()
    local cur, err = conn:execute("select * from gastos;")
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