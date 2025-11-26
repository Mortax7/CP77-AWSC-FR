Mod = {
    descrition = "Advanced Weapon Stat Customization"
}

require("vendors/autoloader")
Autoloader.init()
Config.Init()

local Localization = require("app.localization")
local settingsFile = FileManager.load("../config/settings.json")
if settingsFile then
    local json = require("app.json")
    local ok, data = pcall(json.decode, settingsFile)
    if ok and data.language then
        Localization.setLang(data.language)
    else
        print("[AWSC] settings.json invalid, using 'en'")
        Localization.setLang("en")
    end
else
    print("[AWSC] settings.json missing, using 'en'")
    Localization.setLang("en")
end

local a = config("app.enabled", true)

FileManager.save("", "../" .. config("app.shortName") .. ".log")

if config("app.enabled", true) then
    Mod.init = Main.init()
else
    Mod.init = os.exit()
end

return Mod
