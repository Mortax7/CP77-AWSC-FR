local L = require("app.localization")

RangedUI = {

}

function RangedUI.Init()
    local ui = MainUI.UI

    ui.addTab(
        "/AWSCRanged",
        L.t("menu_title_short")
    )

    local uiOptions = {}

    ui.addSubcategory(
        "/AWSCRanged/classSelector",
        L.t("ranged_class_subcat")
    )

    local options = table_keys(ConfigFile.Weapons.RangedWeapon)
    local optionsLabels = table_map(options, function(k, v) return Main.classLabels[v] end)

    local activeClass = nil
    local setClass = function(value)
        ui.removeSubcategory("/AWSCRanged/class")
        ui.removeSubcategory("/AWSCRanged/kind")
        ui.removeSubcategory("/AWSCRanged/weapon")
        ui.removeSubcategory("/AWSCRanged/variant")

        local class = options[value]
        local classLabel = Main.classLabels[class]
        ui.addSubcategory(
            "/AWSCRanged/class",
            classLabel
        )

        local kinds = table_keys(ConfigFile.Weapons.RangedWeapon[class])
        local kindLabels = table_map(kinds, function(k, kind) return Main.kindLabels[kind] end)

        local setKind = function(value)
            ui.removeSubcategory("/AWSCRanged/kind")
            ui.removeSubcategory("/AWSCRanged/weapon")
            ui.removeSubcategory("/AWSCRanged/variant")

            local kind = kinds[value]
            local kindLabel = Main.kindLabels[kind]
            ui.addSubcategory(
                "/AWSCRanged/kind",
                kindLabel
            )

            local weapons = table_keys(ConfigFile.Weapons.RangedWeapon[class][kind])
            local weaponLabels = {}

            table_map(weapons,
                function(k, weapon)
                    weaponLabels[k] = ConfigFile.Weapons.RangedWeapon[class][kind][weapon].Variants.Default
                    .LocalizedName
                end
            )

            local setWeapon = function(value)
                ui.removeSubcategory("/AWSCRanged/weapon")
                ui.removeSubcategory("/AWSCRanged/variant")

                local weaponLabel = weaponLabels[value]
                local weaponRecordName = weapons[value]

                log("RangedUI: Setting weapon " .. weaponLabel)

                local storageWeapon = Weapon.FindByName(weaponRecordName)
                if not storageWeapon then dd(weaponRecordName, storageWeapon) end

                local variantNames = {
                    [1] = "Default"
                }

                local variantLabels = {
                    [1] = L.t("variant_default")
                }

                if not pcall(function()
                        table_map(
                            storageWeapon.Variants,
                            function(variantName, storageVariant)
                                if table_count(storageVariant) > 1 and variantName ~= "Default" then
                                    log(variantName, storageVariant.LocalizedName)
                                    if storageVariant.LocalizedName == storageWeapon.Variants.Default.LocalizedName then
                                        table.insert(variantLabels, variantName)
                                        table.insert(variantNames, variantName)
                                    else
                                        table.insert(variantLabels, storageVariant.LocalizedName)
                                        table.insert(variantNames, variantName)
                                    end
                                end
                            end
                        )
                    end) then
                    log("RanderUI: Inserting one or more " .. weaponLabel .. " variants failed")
                end

                ui.addSubcategory(
                    "/AWSCRanged/weapon",
                    weaponLabel
                )

                local setVariant = function(value)
                    ui.removeSubcategory("/AWSCRanged/variant")
                    ui.removeSubcategory("/AWSCRanged/iconicDisclaimer")

                    local variantName = variantNames[value]
                    local variantLabel = variantLabels[value]

                    local storageVariant = storageWeapon.Variants[variantName]

                    log("RangedUI: Setting variant " .. variantLabel)

                    ---@type gamedataWeaponItem_Record
                    --local variantRecord = TweakDB:GetRecord(storageVariant.recordPath)
					
                    ui.addSubcategory(
                        "/AWSCRanged/variant",
                        variantLabel
                    )

                    local isIconic = false

                    if variantName == "Default" and storageVariant.Stats.Crosshair then
                        local xhsuccess, errorMessage = pcall(
                            function()
                                ui.addSelectorString(
                                    "/AWSCRanged/variant",
                                    L.t("option_crosshair_label"),
                                    L.t("option_crosshair_desc"), 
                                    MainUI.xhairsOptions,
                                    table_indexOf(MainUI.xhairsOptions, storageVariant.Stats.Crosshair.custom),
                                    table_indexOf(MainUI.xhairsOptions, storageVariant.Stats.Crosshair.default),
                                    function(value)
                                        local flatSuccess = Weapon.SetCrosshair(storageWeapon,
                                            MainUI.xhairsOptions[value])

                                        if flatSuccess then
                                            ConfigFile.Weapons.RangedWeapon[class][kind][weaponRecordName].Variants.Default.Stats.Crosshair.custom =
                                                MainUI.xhairsOptions[value]

                                            ConfigFile.Save()

                                            log("RangedUI: Setting the crosshair for the '" ..
                                                variantLabel .. "' variant of '" .. weaponLabel .. "'")
                                        else
                                            log("RangedUI: Failed setting the crosshair for the '" ..
                                                variantLabel .. "' variant of '" .. weaponLabel .. "'")
                                        end
                                    end)
                            end
                        )
                        if xhsuccess then
                            --storageVariant.Stats = table_remove(storageVariant.Stats, "Crosshair")
                        else
                            log("RangedUI: Failed to create the Crosshair control for the '" ..
                                variantLabel .. "' variant of '" .. weaponLabel .. "'")
                            log(errorMessage)
                        end
                    else
                        isIconic = true
                        storageVariant.Stats = table_remove(storageVariant.Stats, "Crosshair")
                        log("RangedUI: '" ..
                            variantLabel .. "' Identified as an Iconic")

                        if storageVariant.Disclaimer then
                            ui.addSubcategory(
                                "/AWSCRanged/iconicDisclaimer",
                                storageVariant.Disclaimer
                            )
                        elseif table_count(storageVariant.Stats) < 3 then
                            ui.removeSubcategory("/AWSCRanged/variant")
                            ui.addSubcategory(
                                "/AWSCRanged/iconicDisclaimer",
                                variantName .. L.t("iconic_inherit_note")
                            )
                        else
                            ui.addSubcategory(
                                "/AWSCRanged/iconicDisclaimer",
                                L.t("iconic_generic_note")
                            )
                        end
                    end

                    local subcat = "/AWSCRanged/variant"
                    if isIconic then subcat = "/AWSCRanged/iconicDisclaimer" end

                    local validStats = table_filter(storageVariant.Stats, function(k, v) return type(v) == "table" end)

                    log("RangedUI: " .. table_count(validStats) .. " stats identified:")
                    log(table_keys(validStats))

                    for stat, statValues in pairs(validStats) do
                        if stat ~= "Crosshair" then
                            local status, errorMessage = pcall(function()
                                log("RangedUI: Creating the " ..
                                    statValues.uiLabel ..
                                    " control for the '" .. variantLabel .. "' variant of '" .. weaponLabel .. "'")

                                local label = statValues.uiLabel
                                local desc = statValues.uiDescription
                                if statValues.modifierType == "Multiplier" then
                                    label = label .. " " .. L.t("suffix_multiplier")
                                    desc = desc .. " " .. L.t("suffix_multiplier")
                                end
                                ui.addRangeFloat(
                                    subcat,                   --path
                                    label,                    --label
                                    statValues.uiDescription, --description
                                    statValues.min,           --min
                                    statValues.max,           --max
                                    statValues.step,          --step
                                    statValues.format,        --format
                                    statValues.custom + 0.0,  --currentValue
                                    statValues.default + 0.0, --defaultValue
                                    function(value)           --callback
                                        log("RangedUI: Setting " ..
                                            statValues.uiLabel ..
                                            " for the '" ..
                                            variantLabel .. "' variant of '" .. weaponLabel .. "'")
                                        Main.SetRecordValue(statValues.flatPath, "value", value)
                                        ConfigFile.Weapons.RangedWeapon[class][kind][weaponRecordName].Variants[variantName].Stats[stat].custom =
                                            value
                                        ConfigFile.Save()
                                    end
                                )
                            end
                            )

                            if not status then
                                log("RangedUI: Failed to create the control for the " ..
                                    stat .. 
                                    " stat for the '" .. variantLabel .. "' variant of '" .. weaponLabel .. "'")
                                log(errorMessage)
                                log(statValues)
                            end
                        end
                    end
                end

                ui.addSelectorString(
                    "/AWSCRanged/weapon",
                    L.t("selector_variants_label"),
                    L.t("selector_variants_desc"),
                    variantLabels,
                    1,
                    1,
                    setVariant
                )

                setVariant(1)
            end

            ui.addSelectorString(
                "/AWSCRanged/kind",
                L.t("selector_weapons_label"),
                L.t("selector_weapons_desc"),
                weaponLabels,
                1,
                1,
                setWeapon
            )

            setWeapon(1)
        end

        ui.addSelectorString(
            "/AWSCRanged/class",
            L.t("selector_kinds_label"),
            L.t("selector_kinds_desc"),
            kindLabels,
            1,
            1,
            setKind
        )

        setKind(1)
    end

    ui.addSelectorString(
        "/AWSCRanged/classSelector",
        L.t("selector_classes_label"),
        L.t("selector_classes_desc"),
        optionsLabels,
        1,
        1,
        setClass
    )

    setClass(1)
end

return RangedUI