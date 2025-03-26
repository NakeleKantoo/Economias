function handleAccess(command, rh, out, body, method)
    if #command==0 then
        returnNotFound(rh, out)
    end
    if method == "GET" then
        handleGet(command, rh, out)
    elseif method == "POST" then
        handlePost(command, rh, out, body)
    elseif method == "DELETE" then
        handleDelete(command, rh, out)
    elseif method == "PUT" then
        handlePut(command, rh, out, body)
    end
end

function handleGet(command, rh, out)
    local where = command[1]
    if where == "meiopagamento" then
        local response, error = readMeioPagamento()
        tryToSend(response, error, rh, out)
    elseif where == "categoria" then
        local response, error = readCategoria()
        tryToSend(response, error, rh, out)
    elseif where == "gastos" then
        local response, error = readGastos()
        tryToSend(response, error, rh, out)
    end
end

function handlePost(command, rh, out, body)
    if command[1] == "gastos" then
        local response, error = addGasto(body)
        tryToSend(response, error, rh, out)
    elseif command[1] == "auth" then
        local response, error = checkAuth(body)
        tryToSend(response, error, rh, out)
    end
end

function handleDelete(command, rh, out)
    if command[1] == "gastos" then
        local response, error = deleteGasto(command[2])
        tryToSend(response, error, rh, out)
    end
end

function handlePut(command, rh, out)
    if command[1] == "gastos" then
        local response, error = modifyGasto(body,command[2])
        tryToSend(response, error, rh, out)
    elseif command[1] == "auth" then
        local response, error = addUser(body)
        tryToSend(response, error, rh, out)
    end
end

function tryToSend(body, error, rh, out)
    if body then
        returnOk(rh, out, body)
    else
        returnError(rh, out, error)
    end
end