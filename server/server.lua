local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent(Config.CoreName ..':GetObject', function(obj) QB = obj end)

QBCore.Functions.CreateCallback('zh-documents:submitDocument', function(source, cb, data)
    local Player = QBCore.Functions.GetPlayer(source)
    local db_form = nil;
    local _data = data;
    MySQL.Async.fetchAll("INSERT INTO player_documents (owner, data) VALUES (@owner, @data)", {['@owner'] = Player.PlayerData.citizenid, ['@data'] = json.encode(data)}, function(id)
        if id ~= nil then
             MySQL.Async.fetchAll('SELECT * FROM player_documents WHERE id = @id', {['@id']=id.insertId}, function (result)
                if(result[1] ~= nil) then
                    db_form = result[1]
                    db_form.data = json.decode(result[1].data)
                    cb(db_form)
                   local metatest = {aDocument = json.encode(data), adocs = db_form.data, dataid = id , description = db_form.data.headerTitle }
                   Player.Functions.AddItem("documents", 1, false, metatest)
                end
            end)
        else
            cb(db_form)
        end
    end)
end)

QBCore.Functions.CreateUseableItem("documents", function(source, item)
    local src = source
    TriggerClientEvent('mydocuments:show', src, item)
end)

QBCore.Functions.CreateCallback('zh-documents:deleteDocument', function(source, cb, id)
    local db_document = nil;
    local Player = QBCore.Functions.GetPlayer(source)
    MySQL.Async.fetchAll('DELETE FROM player_documents WHERE id = @id AND owner = @owner', {
        ['@id']  = id,
        ['@owner'] = Player.PlayerData.citizenid
    }, function(result)
        if result ~= nil then
            TriggerClientEvent(Config.CoreName.. ':Notify', source, 'Document deleted', 'inform')
            cb(true)
        else
            TriggerClientEvent(Config.CoreName.. ':Notify', source, 'Cound\'t delete documet', 'error')
            cb(false)
        end
    end)
end)

QBCore.Functions.CreateCallback('zh-documents:getPlayerDocuments', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local forms = {}
    if Player ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM player_documents WHERE owner = @owner", {
            ['@owner'] = Player.PlayerData.citizenid
        }, function(result)
        if #result > 0 then
            for i=1, #result, 1 do
                local tmp_result = result[i]
                tmp_result.data = json.decode(result[i].data)
                table.insert(forms, tmp_result)
            end
                cb(forms)
            end
        end)
    end
end)

QBCore.Functions.CreateCallback('zh-documents:getPlayerDetails', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local cb_data = nil
    MySQL.Async.fetchAll("SELECT charinfo FROM players WHERE citizenid = @owner", {
        ['@owner'] = Player.PlayerData.citizenid
    }, function(result)
        if result[1] ~= nil then
            cb_data = result[1]
            cb(cb_data)
        else
            cb(cb_data)
        end

    end)

end)

RegisterServerEvent('zh-documents:ShowToPlayer')
AddEventHandler('zh-documents:ShowToPlayer', function(targetID, aForm)
    TriggerClientEvent('zh-documents:viewDocument', targetID, aForm)
end)

RegisterServerEvent('zh-documents:CopyToME')
AddEventHandler('zh-documents:CopyToME', function(aForm)
    local player = QBCore.Functions.GetPlayer(source)
    local _aForm    = aForm
    local metatest = {aDocument = json.encode(_aForm), adocs = _aForm, dataid = id , description = _aForm.headerTitle }
    player.Functions.AddItem("documents", 1, false, metatest)
end)