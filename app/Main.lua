Main = {
    description = "Personnalisation Avancée des Statistiques d’Armes",
    weapons = nil,
    rangeLabels = {
        ['MeleeWeapon'] = "Corps-à-corps",
        ['RangedWeapon'] = "Armes"
    },
    classLabels = {
        ['BladeWeapon'] = "Lame",
        ['BluntWeapon'] = "Contondante",
        ['HeavyWeapon'] = "Lourde",
        ['PowerWeapon'] = "Arme Cinétique",
        ['SmartWeapon'] = "Arme Intelligente",
        ['TechWeapon'] = "Arme Technique",
        ['ThrowableWeapon'] = "Armes de jet",
        ['OneHandedRangedWeapon'] = "Une main",
        ['Special'] = "Spéciales"
    },
    kindLabels = {
        ['Grenade Launcher'] = "Lance-grenade",
        ['Handgun'] = "Pistolet",
        ['HMG'] = "Mitrailleuse Lourde",
        ['LMG'] = "Mitrailleuse Légère",
        ['Revolver'] = "Revolver",
        ['Rifle Assault'] = "Fusils d’assaut",
        ['Rifle Precision'] = "Fusils de précision",
        ['Rifle Sniper'] = "Fusils de sniper",
        ['ShotgunWeapon'] = "Fusils à pompe",
        ['Shotgun Dual'] = "Double canon",
        ['SMG'] = "Mitraillette",

        ['Baton'] = "Matraque",
        ['BladeWeapon'] = "Lame",
        ['One Hand Blade'] = "Machette",
        ['One Hand Club'] = "Matraque à une main",
        ['Katana'] = "Katana",
        ['Knife'] = "Couteau",
        ['Two Hand Club'] = "Matraque à deux mains",
        ['Two Hand Hammer'] = "Marteau",
        ['Knuckles'] = "Poings américains"
    },
    triggerModes = {
        [1] = "Semi-Auto",
        [2] = "Rafale",
        [3] = "Auto",
        [4] = "Chargée",
        [5] = "Préparation",
        [6] = "Verrouillage"
    },
    triggerModesLabels = {
        ["Semi-Auto"] = "TriggerMode.FullAuto",
        ["Rafale"] = "TriggerMode.Burst",
        ["Auto"] = "TriggerMode.SemiAuto",
        ["Chargée"] = "TriggerMode.Charge",
        ["Préparation"] = "TriggerMode.Windup",
        ["Verrouillage"] = "TriggerMode.Loc"
    }
}
function Main.init()
    registerForEvent("onInit", function()
        log("AWSC: Hello World!")

        ConfigFile.Init()
    end)
end

function Main.SetRecordValue(path, field, value)
    if path == nil then log("Cannot set a record because it's path is not set") end
    if field == nil then log("Cannot set a record because it's field is not set") end
    if value == nil then log("Cannot set a record because it's value is not set") end

    if path == nil
        or field == nil
        or value == nil
    then
        log(
            {
                path,
                field,
                value
            }
        )
        return false
    end

    if TweakDB:GetFlat(path .. "." .. field) then
        if not TweakDB:SetFlat(path .. "." .. field, value) then
            log("Main: Failed to SetFlat: '" ..
                path .. "." .. field .. "' as '" .. value .. "'")
            return false
        end
    else
        if not field == "crosshair" then
            log("Main: the flat '" .. path .. "." .. field .. "' does not exist.")
        end
    end
    return true
end

return Main
