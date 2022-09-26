local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local USER_DOCUMENTS = {}
local CURRENT_DOCUMENT = nil
local DOCUMENT_FORMS = nil

RegisterNetEvent(Config.CoreName.. ':Client:OnPlayerLoaded')
AddEventHandler(Config.CoreName.. ':Client:OnPlayerLoaded', function()
    GetAllUserForms()
end)

 RegisterNetEvent('opennneddocument',function()
    OpenMainMenu()
    GetAllUserForms()
end)

function OpenMainMenu()
    local ply = QBCore.Functions.GetPlayerData().job
   if ply.name == 'unemployed' then
    exports['qb-menu']:openMenu({
        {
            header = "Documents Menu",
            isMenuHeader = true,
        },
        {
            header = "Public Documents",
            params = {
                event = "OpenNewPublicFormMenu",
                args = ""
            }
        },
        {
            header = "Saved Documents",
            params = {
                event = "OpenMyDocumentsMenu",
                args = ""
            }
        },
        {
            header = "Close",
            params = {
                event = "qb-menu:client:closeMenu",
                args = ""
            }
        },
    })
else
    exports['qb-menu']:openMenu({
        {
            header = "Documents Menu",
            isMenuHeader = true,
        },
        {
            header = "Public Documents",
            params = {
                event = "OpenNewPublicFormMenu",
                args = ""
            }
        },
        {
            header = "Job Documents "..QBCore.Shared.Jobs[ply.name].label,
            params = {
                event = "OpenNewJobFormMenu",
                args = job
            }
        },
        {
            header = "Saved Documents",
            params = {
                event = "OpenMyDocumentsMenu",
                args = ""
            }
        },
        {
            header = "Close",
            params = {
                event = "qb-menu:client:closeMenu",
                args = ""
            }
        },
    })
end
end

RegisterNetEvent("ShowToNearestPlayers",function(aDocument)
    local players_clean = GetNeareastPlayers()
    CURRENT_DOCUMENT = aDocument
    local zhShowDocMenu = {
        {
            header = 'Copy',
            isMenuHeader = true
        }
    }
    if #players_clean > 0 then
        for i=1, #players_clean, 1 do
            zhShowDocMenu[#zhShowDocMenu+1] = {
                header = players_clean[i].playerName .. "[" .. tostring(players_clean[i].playerId) .. "]",
                params = {
                    event = "ShowDocument",
                    args = players_clean[i].playerId
                }
            }
        end
        exports['qb-menu']:openMenu(zhShowDocMenu)
    else
        QBCore.Functions.Notify('Tidak Ada Player', "error", 5000)
    end

end)

RegisterNetEvent("CopyFormToMES",function(aDocument)
    CURRENT_DOCUMENT = aDocument
    TriggerServerEvent('zh-documents:CopyToME', CURRENT_DOCUMENT)
end)

RegisterNetEvent("OpenNewPublicFormMenu",function()
    
    local zhPublicDocMenu = {
        {
            header = 'Public Document',
            isMenuHeader = true
        }
    }
    for i=1, #Config.Docs["public"], 1 do
        
        zhPublicDocMenu[#zhPublicDocMenu+1] = {
            header = Config.Docs["public"][i].headerTitle,
            txt = Config.Docs["public"][i].headerSubtitle,
            params = {
                event = "CreateNewForm",
                args = Config.Docs["public"][i]
            }
        }
        exports['qb-menu']:openMenu(zhPublicDocMenu)
    end
end)

RegisterNetEvent("OpenNewJobFormMenu",function()
    local zhJobDocMenu = {
        {
            header = 'Job Document',
            isMenuHeader = true
        }
    }
        PlayerData = QBCore.Functions.GetPlayerData()
            for i=1, #Config.Docs[PlayerData.job.name], 1 do
                zhJobDocMenu[#zhJobDocMenu+1] = {
                    header = Config.Docs[PlayerData.job.name][i].headerTitle,
                    txt = Config.Docs[PlayerData.job.name][i].headerSubtitle,
                    params = {
                        event = "CreateNewForm",
                        args = Config.Docs[PlayerData.job.name][i]
                    }
                }
                exports['qb-menu']:openMenu(zhJobDocMenu)
        
        end
    end)

RegisterNetEvent("OpenMyDocumentsMenu",function()
local zhMyDocMenu = {
    {
        header = 'Public Document',
        isMenuHeader = true
    }
}
    for i=#USER_DOCUMENTS, 1, -1 do
        local date_created = ""
        if USER_DOCUMENTS[i].data.headerDateCreated ~= nil then
            date_created = USER_DOCUMENTS[i].data.headerDateCreated .. " - "
        end
        zhMyDocMenu[#zhMyDocMenu+1] = {
            header = date_created .. USER_DOCUMENTS[i].data.headerTitle,
            txt = date_created .. USER_DOCUMENTS[i].data.headerSubtitle,
            params = {
                event = "OpenFormPropertiesMenu",
                args = USER_DOCUMENTS[i]
            }
        }
        exports['qb-menu']:openMenu(zhMyDocMenu)
    end
end)

RegisterNetEvent("OpenDeleteFormMenu",function(aDocument)
    exports['qb-menu']:openMenu({
        {
            header = "DELETE?",
            isMenuHeader = true,
        },
        {
            header = "Yes Delete",
            params = {
                event = "DeleteDocument",
                args = aDocument
            }
        },
        {
            header = "Go Back",
            params = {
                event = "OpenFormPropertiesMenu",
                args = aDocument
            }
        },
    })
end)

RegisterNetEvent("DeleteDocument",function(aDocument)
    QBCore.Functions.TriggerCallback('zh-documents:deleteDocument', function (cb)
        if cb == true then
            for i=1, #USER_DOCUMENTS, 1 do
                if USER_DOCUMENTS[i].id == aDocument.id then
                    key_to_remove = i
                end
            end
            if key_to_remove ~= nil then
                table.remove(USER_DOCUMENTS, key_to_remove)
            end
            TriggerEvent("OpenMyDocumentsMenu")
        end
    end, aDocument.id)
end)

RegisterNetEvent("CreateNewForm",function(aDocument)
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('zh-documents:getPlayerDetails', function (cb_player_details)
        if cb_player_details ~= nil then
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
        else
        end
    end, data)
end)

RegisterNetEvent("ShowDocument",function(aPlayer)

        TriggerServerEvent('zh-documents:ShowToPlayer', aPlayer, CURRENT_DOCUMENT)
        CURRENT_DOCUMENT = nil

end)

RegisterNetEvent('zh-documents:viewDocument')
AddEventHandler('zh-documents:viewDocument', function(data)
    TriggerEvent("ViewDocument",data)
end)

RegisterNetEvent('ViewDocument',function(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ShowDocument",
        data = aDocument
    })
end)

RegisterNetEvent('zh-documents:copyForm')
AddEventHandler('zh-documents:copyForm', function(db_form)
    table.insert(USER_DOCUMENTS, db_form)
   -- TriggerEvent("OpenFormPropertiesMenu",db_form)
end)

function GetAllUserForms()
    QBCore.Functions.TriggerCallback('zh-documents:getPlayerDocuments', function (cb_forms)
        if cb_forms ~= nil then
            USER_DOCUMENTS = cb_forms
        else
        end
    end, data)
end

RegisterNUICallback('form_close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('form_submit', function(data, cb)
    QBCore.Functions.TriggerCallback('zh-documents:submitDocument', function (cb_form)
        if cb_form ~= nil then
            table.insert(USER_DOCUMENTS, cb_form)
            TriggerEvent("OpenFormPropertiesMenu",cb_form)
        else
        end
    end, data)
    SetNuiFocus(false, false)
end)

function GetNeareastPlayers()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())
    local players_clean = {}
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)
            if closestDistance == -1 or closestDistance > distance then
                for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            found_players = true
            table.insert(players_clean, {playerName = GetPlayerName(closestPlayers[i]), playerId = GetPlayerServerId(closestPlayers[i])} )
        end
    end
            end
        end
    end
    return players_clean
end

function ViewDocument2(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ShowDocument",
        data = aDocument
    })
end


RegisterNetEvent('mydocuments:show')
AddEventHandler('mydocuments:show', function(item, wait, cb, aDocument)
    local Ply = QBCore.Functions.GetPlayerData().items
   local wew = Ply[item.slot]
    local aDocument = wew.info.adocs
  TriggerEvent("OpenFormPropertiesMenuItem", aDocument)
end)
RegisterNetEvent("OpenFormPropertiesMenuItem",function(aDocument)
    exports['qb-menu']:openMenu({
        {
            header = "Properties Menu",
            isMenuHeader = true,
        },
        {
            header = "View",
            params = {
                event = "ViewDocument",
                args = aDocument
            }
        },
        {
            header = "Show",
            params = {
                event = "ShowToNearestPlayers",
                args = aDocument
            }
        },
        {
            header = "Go Back",
            params = {
                event = "OpenMyDocumentsMenu",
                args = aDocument
            }
        },
    })
end)

RegisterNetEvent("OpenFormPropertiesMenu",function(aDocument)
    exports['qb-menu']:openMenu({
        {
            header = "Properties Menu",
            isMenuHeader = true,
        },
        {
            header = "View",
            params = {
                event = "ViewDocument",
                args = aDocument.data
            }
        },
        {
            header = "Show",
            params = {
                event = "ShowToNearestPlayers",
                args = aDocument.data
            }
        },
        {
            header = "Copy Documents",
            params = {
                event = "CopyFormToMES",
                args = aDocument.data
            }
        },
        {
            header = "Delete",
            params = {
                event = "OpenDeleteFormMenu",
                args = aDocument
            }
        },
        {
            header = "Go Back",
            params = {
                event = "OpenMyDocumentsMenu",
                args = aDocument.data
            }
        },
    })
end)

local Spawn_Printer = function(model, coord, rotation)
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
    exports['qb-target']:AddTargetEntity(entity, {
         options = { {
              icon = "fas fa-book",
              label = "Printer",
              action = function(entity)
                TriggerEvent("opennneddocument")
             --   openMainMenu()
                   return true
              end
         }
         },
         distance = 1.5
    })

    return entity
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
         return
    end
    Load_Printer()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1500)
    Load_Printer()
end)

local print_ent = {}
function Load_Printer()
    if loaded then return end
    CreateThread(function()
         for k, v in pairs(Config.Printer) do
              print_ent[#print_ent + 1] = Spawn_Printer(v.printer_model, v.coords, v.rotation)
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