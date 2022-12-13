local QBCore = exports[Config.QBCoreName]:GetCoreObject()
local IsRenting = false
local Vehicle = nil

CreateThread(function()
    for k, v in pairs(Config.RentalSpots) do
        local PedLoc = v.PedCoords
        RequestModel(GetHashKey(v.PedModel))
        while not HasModelLoaded(GetHashKey(v.PedModel)) do
            Wait(1)
        end
        RentalPed =  CreatePed(4, v.PedModelHash, PedLoc.x, PedLoc.y, PedLoc.z, v.PedHeading, false, true)
        SetEntityHeading(RentalPed, v.PedHeading)
        FreezeEntityPosition(RentalPed, true)
        SetEntityInvincible(RentalPed, true)
        SetBlockingOfNonTemporaryEvents(RentalPed, true)
        TaskStartScenarioInPlace(RentalPed, "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true) 

        exports[Config.QBTargetName]:AddBoxZone(v.SpotName, v.PedCoords, 1, 1, {
            name=v.SpotName,
            heading=v.PedHeading,
            debugpoly = Config.DebugPoly,
        }, {
            options = {
                {
                    targeticon = v.TargetIcon,
                    icon = "fas fa-clipboard",
                    label = v.LabelSpotName,
                    action = function()
                        TriggerEvent('mt-rental:client:RentalMenu', v.SpotName, v.VehicleSpawnLocation)
                    end
                },
            },
            distance = 2.5
        })

        v.SpotName = AddBlipForCoord(v.PedCoords)
        SetBlipSprite(v.SpotName, v.MapBlipSprite)
        SetBlipDisplay(v.SpotName, 2)
        SetBlipScale(v.SpotName, 0.5)
        SetBlipAsShortRange(v.SpotName, true)
        SetBlipColour(v.SpotName, v.MapBlipColour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.LabelSpotName)
        EndTextCommandSetBlipName(v.SpotName)
    end
end)

RegisterNetEvent('mt-rental:client:RentalMenu', function(Spot, VehicleSpawnLocation)
    if IsRenting == false then
        local columns = {
            {
                header = Lang.MenuHeader,
                isMenuHeader = true,
                icon = "fas fa-clipboard",
            },
            {
                header = Lang.CloseMenu,
                icon = "fas fa-circle-xmark",
                event = Config.QBMenuName..":closeMenu",
            },
        }
        for k, v in pairs(Config.RentalSpots[Spot]["AvailableVehicles"]) do
            local item = {}
            item.header = v.VehicleLableName .. " - " .. v.RentPrice .. "$" .. Lang.PerMinute
            item.icon = v.MenuIcon
            item.params = {
                event = "mt-rental:client:RentVehicleInput",
                args = {
                    RentPrice = v.RentPrice,
                    VehicleSpawnName = v.VehicleSpawnName,
                    VehicleSpawnLocation = VehicleSpawnLocation,
                    VehicleLableName = v.VehicleLableName
                },
            }
            table.insert(columns, item)
        end

        exports[Config.QBMenuName]:openMenu(columns)
    else
        local columns = {
            {
                header = Lang.MenuHeader,
                isMenuHeader = true,
                icon = "fas fa-clipboard",
            },
            {
                header = Lang.CloseMenu,
                icon = "fas fa-circle-xmark",
                event = Config.QBMenuName..":closeMenu",
            },
            {
                header = Lang.CancelCurrentRenting,
                icon = "fas fa-ban",
                params = {
                    event = "mt-rental:client:CancelRenting",
                }
            },
        }
        exports[Config.QBMenuName]:openMenu(columns)
    end
end)

RegisterNetEvent('mt-rental:client:RentVehicleInput', function(data)
    if IsRenting == false then
        local dialog = exports[Config.QBInputName]:ShowInput({
            header = Lang.InputHeader,
            submitText = Lang.Submit,
            inputs = {
                {
                    text = Lang.InputText,
                    name = "TimeAmount",
                    type = "number",
                    isRequired = true,
                },
            }
        })

        if dialog ~= nil then
            exports[Config.QBMenuName]:openMenu({
                {
                    header = Lang.ConfirmMenuHeader,
                    isMenuHeader = true,
                    icon = "fas fa-question",
                },
                {
                    header = Lang.Yes,
                    icon = "fas fa-check",
                    params = {
                        event = "mt-rental:client:RentVehicle",
                        args = {
                            RentPrice = data.RentPrice,
                            VehicleSpawnName = data.VehicleSpawnName,
                            TimeAmount = dialog.TimeAmount,
                            VehicleSpawnLocation = data.VehicleSpawnLocation,
                            VehicleLableName = data.VehicleLableName
                        },
                    }
                },
                {
                    header = Lang.No,
                    icon = "fas fa-circle-xmark",
                    event = Config.QBMenuName..":closeMenu",
                },
            })
        end
    else
        QBCore.Functions.Notify(Lang.AlreadyRenting, 'error', 7500)
    end
end)

RegisterNetEvent('mt-rental:client:RentVehicle', function(data)
    local coords = data.VehicleSpawnLocation
    local vehicle = data.VehicleSpawnName
    local PlayerData = QBCore.Functions.GetPlayerData()
    local RentPrice = data.RentPrice * data.TimeAmount
    local FeesPrice = data.RentPrice * Config.PriceMultiplier

    QBCore.Functions.TriggerCallback("mt-rental:server:VerifyMoney", function(hasMoney)
        if (hasMoney) then
            if IsRenting == false then
                QBCore.Functions.SpawnVehicle(vehicle, function(veh)
                    SetVehicleNumberPlateText(veh, "MTFN"..tostring(math.random(1000, 9999)))
                    exports['LegacyFuel']:SetFuel(veh, 100.0)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    SetVehicleEngineOn(veh, true, true)
                    TriggerServerEvent('mt-rental:server:RentVehicle', RentPrice, data.VehicleLableName, GetVehicleNumberPlateText(veh), data.TimeAmount,PlayerData)
                    Vehicle = veh
                end, coords, true)
                IsRenting = true
                if IsRenting == true then
                    Wait(data.TimeAmount*60000)
                    if IsRenting == true then
                        if Config.PhoneName == 'qb-phone' then
                            TriggerServerEvent('qb-phone:server:sendNewMail', {
                                sender = Lang.MailSender,
                                subject = Lang.MailSubject,
                                message = Lang.MailMessage,
                            })
                        elseif Config.PhoneName == 'gksphone' then
                            TriggerServerEvent('gksphone:NewMail', {
                                sender = Lang.MailSender,
                                subject = Lang.MailSubject,
                                message = Lang.MailMessage,
                            })
                        end
                        CreateThread(function()
                            while IsRenting == true do
                                Wait(Config.BillingAfterMailTime*60000)
                                if IsRenting == true then
                                TriggerServerEvent('mt-rental:server:BillPlayer', FeesPrice)
                                TriggerEvent('mt-rental:client:Mail2')
                                end
                            end
                        end)
                    end
                end
            elseif IsRenting == true then
                QBCore.Functions.Notify(Lang.AlreadyRenting, 'error', 7500)
            end
        else
            QBCore.Functions.Notify(Lang.NoMoney, "error")
            return
        end
    end, data.RentPrice)
end)

RegisterNetEvent('mt-rental:client:CancelRenting', function(data)
    print(Vehicle)
    print(IsRenting)
    if IsRenting == true then
        IsRenting = false
        DeleteVehicle(Vehicle)
        DeleteEntity(Vehicle)
        TriggerServerEvent('mt-rental:server:RemoveContract')
    else 
        QBCore.Functions.Notify(Lang.NotRenting, 'error', 7500)
    end
end)

RegisterNetEvent('mt-rental:client:Mail2', function()
    if Config.PhoneName == 'qb-phone' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Lang.MailSender,
            subject = Lang.MailSubject,
            message = Lang.MailMessage2,
        })
    elseif Config.PhoneName == 'gksphone' then
        TriggerServerEvent('gksphone:NewMail', {
            sender = Lang.MailSender,
            subject = Lang.MailSubject,
            message = Lang.MailMessage2,
        })
    end
end)
