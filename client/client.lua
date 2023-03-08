local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local USER_DOCUMENTS = {}
local CURRENT_DOCUMENT = nil

local function GetAllUserForms()
    QBCore.Functions.TriggerCallback('document:server:GetPlayerDocuments', function(cb_forms)
        if cb_forms ~= nil then
            USER_DOCUMENTS = cb_forms
        end
    end)
end

local function OpenMainMenu()
    local job = QBCore.Functions.GetPlayerData().job
    local jobName = job.name
    if jobName == 'unemployed' then
        lib.registerContext({
            id = 'documents_menu_openmainmenu',
            title = "Documents Menu",
            options = {
                {
                    title = "Public Documents",
                    event = "document:client:OpenNewPublicFormMenu",
                },
                {
                    title = "Saved Documents",
                    event = "document:client:OpenMyDocumentsMenu",
                }
            }
        })
        lib.showContext('documents_menu_openmainmenu')
    else
        lib.registerContext({
            id = 'documents_menu_openmainmenujob',
            title = "Documents Menu",
            options = {
                {
                    title = "Public Documents",
                    event = "document:client:OpenNewPublicFormMenu",
                },
                {
                    title = "Job Documents " .. QBCore.Shared.Jobs[jobName].label,
                    event = "document:client:OpenNewJobFormMenu",
                    args = jobName
                },
                {
                    title = "Saved Documents",
                    event = "document:client:OpenMyDocumentsMenu",
                },
            }
        })
        lib.showContext('documents_menu_openmainmenujob')
    end
end

local function OpenMenuPrinter()
    OpenMainMenu()
    GetAllUserForms()
end

local function GetNeareastPlayers()
    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords(coords)
    local closestDistance = -1
    local players_clean = {}
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)
            if closestDistance == -1 or closestDistance > distance then
                for i = 1, #closestPlayers, 1 do
                    if closestPlayers[i] ~= PlayerId() then
                        table.insert(players_clean,
                            {
                                playerName = GetPlayerName(closestPlayers[i]),
                                playerId = GetPlayerServerId(closestPlayers[i])
                            }
                        )
                    end
                end
            end
        end
    end
    return players_clean
end

RegisterNetEvent("document:client:ShowToNearestPlayers", function(aDocument)
    local players_clean = GetNeareastPlayers()
    CURRENT_DOCUMENT = aDocument
    local menu = {}
    if #players_clean > 0 then
        for i = 1, #players_clean, 1 do
            menu[#menu + 1] = {
                title = players_clean[i].playerName .. "[" .. tostring(players_clean[i].playerId) .. "]",
                event = "ShowDocument",
                args = players_clean[i].playerId
            }
        end
        lib.registerContext({
            id = 'documents_menu_showtonearestplayer',
            title = 'Copy',
            options = menu
        })
        lib.showContext('documents_menu_showtonearestplayer')
    else
        QBCore.Functions.Notify('No one nearby', "error", 5000)
    end
end)

RegisterNetEvent("document:client:CopyFormToMe", function(aDocument)
    CURRENT_DOCUMENT = aDocument
    TriggerServerEvent('zh-documents:CopyToME', CURRENT_DOCUMENT)
end)

RegisterNetEvent("document:client:OpenNewPublicFormMenu", function()
    local menu = {}
    for i = 1, #Config.Docs["public"], 1 do
        menu[#menu + 1] = {
            title = Config.Docs["public"][i].headerTitle,
            description = Config.Docs["public"][i].headerSubtitle,
            event = "CreateNewForm",
            args = Config.Docs["public"][i]
        }
        lib.registerContext({
            id = 'documents_menu_opennewpublicformmenu',
            title = 'Public Document',
            options = menu
        })
        lib.showContext('documents_menu_opennewpublicformmenu')
    end
end)

RegisterNetEvent("document:client:OpenNewJobFormMenu", function()
    local menu = {}
    PlayerData = QBCore.Functions.GetPlayerData()
    for i = 1, #Config.Docs[PlayerData.job.name], 1 do
        menu[#menu + 1] = {
            title = Config.Docs[PlayerData.job.name][i].headerTitle,
            description = Config.Docs[PlayerData.job.name][i].headerSubtitle,
            event = "CreateNewForm",
            args = Config.Docs[PlayerData.job.name][i]
        }
        lib.registerContext({
            id = 'documents_menu_opennewjobformmenu',
            title = 'Job Document',
            options = menu
        })
        lib.showContext('documents_menu_opennewjobformmenu')
    end
end)

RegisterNetEvent("document:client:OpenMyDocumentsMenu", function()
    local menu = {}
    for i = #USER_DOCUMENTS, 1, -1 do
        local date_created = ""
        if USER_DOCUMENTS[i].data.headerDateCreated ~= nil then
            date_created = USER_DOCUMENTS[i].data.headerDateCreated .. " - "
        end
        menu[#menu + 1] = {
            title = date_created .. USER_DOCUMENTS[i].data.headerTitle,
            description = date_created .. USER_DOCUMENTS[i].data.headerSubtitle,
            event = "document:client:OpenFormPropertiesMenu",
            args = USER_DOCUMENTS[i]
        }
        lib.registerContext({
            id = 'documents_menu_opennewjobformmenu',
            title = 'My Document',
            options = menu
        })
        lib.showContext('documents_menu_opennewjobformmenu')
    end
end)

RegisterNetEvent("document:client:OpenDeleteFormMenu", function(aDocument)
    lib.registerContext({
        id = 'documents_menu_deleteformmenu',
        title = "DELETE?",
        options = {
            {
                title = "Yes Delete",
                event = "DeleteDocument",
                args = aDocument
            },
            {
                title = "Go Back",
                event = "document:client:OpenFormPropertiesMenu",
                args = aDocument
            }
        }
    })
    lib.showContext('documents_menu_deleteformmenu')
end)

RegisterNetEvent("document:client:OpenFormPropertiesMenu", function(aDocument)
    lib.registerContext({
        id = 'documents_menu_openpropertiesmenu2',
        title = "Properties Menu",
        options = {
            {
                title = "View",
                event = "ViewDocument",
                args = aDocument.data
            },
            {
                title = "Show",
                event = "document:client:ShowToNearestPlayers",
                args = aDocument.data
            },
            {
                title = "Copy Documents",
                event = "document:client:CopyFormToMe",
                args = aDocument.data
            },
            {
                title = "Delete",
                event = "document:client:OpenDeleteFormMenu",
                args = aDocument
            },
        }
    })
    lib.showContext('documents_menu_openpropertiesmenu2')
end)

RegisterNetEvent("DeleteDocument", function(aDocument)
    QBCore.Functions.TriggerCallback('document:server:DeleteDocument', function(cb)
        if cb == true then
            for i = 1, #USER_DOCUMENTS, 1 do
                if USER_DOCUMENTS[i].id == aDocument.id then
                    key_to_remove = i
                end
            end
            if key_to_remove ~= nil then
                table.remove(USER_DOCUMENTS, key_to_remove)
            end
            TriggerEvent("document:client:OpenMyDocumentsMenu")
        end
    end, aDocument.id)
end)

RegisterNetEvent("CreateNewForm", function(aDocument)
    PlayerData = QBCore.Functions.GetPlayerData()
    SetNuiFocus(true, true)
    aDocument.headerFirstName = PlayerData.charinfo.firstname
    aDocument.headerLastName = PlayerData.charinfo.lastname
    aDocument.headerDateOfBirth = PlayerData.charinfo.birthdate
    aDocument.headerJobLabel = PlayerData.job.name
    aDocument.headerJobGrade = PlayerData.charinfo.nationality
    aDocument.locale = Config.Locale
    SendNUIMessage({
        type = "createNewForm",
        data = aDocument
    })
end)

RegisterNetEvent("ShowDocument", function(aPlayer)
    TriggerServerEvent('zh-documents:ShowToPlayer', aPlayer, CURRENT_DOCUMENT)
    CURRENT_DOCUMENT = nil
end)

RegisterNetEvent('zh-documents:viewDocument')
AddEventHandler('zh-documents:viewDocument', function(data)
    TriggerEvent("ViewDocument", data)
end)

RegisterNetEvent('ViewDocument', function(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ShowDocument",
        data = aDocument
    })
end)

RegisterNetEvent('zh-documents:copyForm')
AddEventHandler('zh-documents:copyForm', function(db_form)
    table.insert(USER_DOCUMENTS, db_form)
end)

RegisterNUICallback('form_close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('form_submit', function(data, cb)
    QBCore.Functions.TriggerCallback('zh-documents:submitDocument', function(cb_form)
        if cb_form ~= nil then
            table.insert(USER_DOCUMENTS, cb_form)
            TriggerEvent("document:client:OpenFormPropertiesMenu", cb_form)
        else
        end
    end, data)
    SetNuiFocus(false, false)
end)

function ViewDocument2(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ShowDocument",
        data = aDocument
    })
end

RegisterNetEvent('mydocuments:show')
AddEventHandler('mydocuments:show', function(item, wait, cb, aDocument)
    local dataItem = exports.ox_inventory:Search('slots', 'documents')
    for k, v in pairs(dataItem) do
        local aDocument = v.metadata.adocs
        TriggerEvent("document:client:OpenFormPropertiesDocumentItem", aDocument)
    end
end)

RegisterNetEvent("document:client:OpenFormPropertiesDocumentItem", function(aDocument)
    lib.registerContext({
        id = 'documents_menu_openpropertiesmenu',
        title = 'Properties menu',
        options = {
            {
                title = "View",
                event = "ViewDocument",
                args = aDocument
            },
            {
                title = "Show",
                event = "document:client:ShowToNearestPlayers",
                args = aDocument
            },
            {
                title = "Go Back",
                event = "document:client:OpenMyDocumentsMenu",
                args = aDocument
            }
        }
    })
    lib.showContext('documents_menu_openpropertiesmenu')
end)

local SpawnPrinter = function(model, coord, rotation)
    model = model or Config.Printmodel
    local modelHash = GetHashKey(model)

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
    end
    local entity = CreateObject(modelHash, coord, false)
    SetEntityAsMissionEntity(entity, true, true)
    while not DoesEntityExist(entity) do Wait(10) end
    SetEntityRotation(entity, rotation, 0.0, true)
    FreezeEntityPosition(entity, true)
    SetEntityProofs(entity, 1, 1, 1, 1, 1, 1, 1, 1)
    local options = {
        {
            icon = "fas fa-book",
            label = 'Printer',
            onSelect = function()
                OpenMenuPrinter()
            end
        }
    }
    exports.ox_target:addLocalEntity(entity, options)
    return entity
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    LoadPrinter()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    GetAllUserForms()
    Wait(1500)
    LoadPrinter()
end)


local print_ent = {}

function LoadPrinter()
    if loaded then return end
    CreateThread(function()
        for k, v in pairs(Config.Printer) do
            print_ent[#print_ent + 1] = SpawnPrinter(v.printer_model, v.coords, v.rotation)
        end
        loaded = true
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, v in pairs(print_ent) do
            DeleteObject(v)
        end
    end
end)
