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