Config = {}

Config.QBMenuName = 'qb-menu'
Config.QBCoreName = 'qb-core'
Config.QBTargetName = 'qb-target'
Config.InventoryName = 'qb-inventory'
Config.QBInputName = 'qb-input'
Config.QBPhoneName = 'qb-phone'
Config.PhoneName = 'qb-phone' -- Can be qb-phone or gksphone (Maybe later can i'll update to use qs-smartphone)
Config.DebugPoly = false
Config.BillingAfterMailTime = 1 -- Time to receive bill after receive mail to take vehicle back (in minutes)
Config.PriceMultiplier = 10 -- The fees price multiplier (It multipliers vehicle price)

Config.RentalSpots = {
    ["Rental1"] = {
        ["SpotName"] = "Rental1",
        ["LabelSpotName"] = "Vehicle rental",
        ["PedCoords"] = vector3(-905.74, -2338.29, 5.71),
        ["PedHeading"] = 345.89,
        ["MapBlipSprite"] = 67,
        ["MapBlipColour"] = 5,
        ["TargetIcon"] = "fas fa-car",
        ["PedModel"] = "csb_anita",
        ["PedModelHash"] = 0x0703F106,
        ["VehicleSpawnLocation"] = vector4(-894.32, -2332.21, 6.71, 59.05),
        ["AvailableVehicles"] = {
            [1] = { VehicleSpawnName = "neon", VehicleLableName = "Pfister Neon", RentPrice = 10, MenuIcon = "fas fa-car" },
            [2] = { VehicleSpawnName = "calico", VehicleLableName = "Karin Calico", RentPrice = 100, MenuIcon = "fas fa-car" },
            [3] = { VehicleSpawnName = "sultan", VehicleLableName = "Karin Sultan", RentPrice = 200, MenuIcon = "fas fa-car" },
            [4] = { VehicleSpawnName = "shinobi", VehicleLableName = "Nagasaki Shinobi", RentPrice = 300, MenuIcon = "fas fa-motorcycle" },
            [5] = { VehicleSpawnName = "sultan3", VehicleLableName = "Karin Sultan Classic", RentPrice = 50, MenuIcon = "fas fa-car" },
        },
    },
}

Lang = {
    ["MenuHeader"] = "Renting Menu",
    ["CloseMenu"] = "Close menu",
    ["InputHeader"] = "How many time you want to rent the vehicle?",
    ["Submit"] = "Submit",
    ["InputText"] = "Time (In minutes)",
    ["AlreadyRenting"] = "You are already renting an vehicle...",
    ["NoMoney"] = "You dont have money for this...",
    ["CancelCurrentRenting"] = "Cancel current renting",
    ["ConfirmMenuHeader"] = "You are sure you want to rent this vehicle?",
    ["Yes"] = "Yes",
    ["No"] = "No",
    ["MailSender"] = "Rent a car department",
    ["MailSubject"] = "Vehicle renting",
    ["MailMessage"] = "Your renting time as been ended. <br> You have 5 minutes to take the vehicle back to our department or you will need to pay more for renting! <br> Bes regards Rent a car department",
    ["MailMessage2"] = "Like i said, you dont put vehicle at rent department at time and need to pay more... Let's go take that to here...",
    ["PerMinute"] = " per minute",
}