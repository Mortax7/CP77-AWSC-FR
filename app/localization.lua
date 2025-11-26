local M = {}

-- Traductions Tables
local translations = {
  en = {
    menu_title_short        = "Adv. Weapons Stats",
    ranged_class_subcat     = "Class",
    variant_default         = "Default",
    option_crosshair_label  = "Crosshair",
    option_crosshair_desc   = "Crosshair",
    iconic_inherit_note     = " inherit all its stats from Default, and may have hidden mods affecting certain attributes",
    iconic_generic_note     = "Note: Iconics inherit some stats from Default, and may have hidden mods affecting certain attributes",
    suffix_multiplier       = "Multiplier",
    selector_variants_label = "Variants",
    selector_variants_desc  = "Choose a weapon variant",
    selector_weapons_label  = "Weapons",
    selector_weapons_desc   = "Choose a weapon",
    selector_kinds_label    = "Kinds",
    selector_kinds_desc     = "Choose a kind",
    selector_classes_label  = "Classes",
    selector_classes_desc   = "Choose a class",
  }

  fr = {
    menu_title_short        = "Stats avancées des armes",
    ranged_class_subcat     = "Classe",
    variant_default         = "Par défaut",
    option_crosshair_label  = "Réticule",
    option_crosshair_desc   = "Réticule de visée",
    iconic_inherit_note     = " hérite de toutes ses statistiques de Par défaut, et peut avoir des mods cachés affectant certains attributs",
    iconic_generic_note     = "Note: les iconiques héritent de certaines stats de par défaut, et peuvent avoir des mods cachés affectant certains attributs",
    suffix_multiplier       = "Multiplicateur",
    selector_variants_label = "Variantes",
    selector_variants_desc  = "Choisissez une variante d'arme",
    selector_weapons_label  = "Armes",
    selector_weapons_desc   = "Choisissez une arme",
    selector_kinds_label    = "Types",
    selector_kinds_desc     = "Choisissez un type",
    selector_classes_label  = "Classes",
    selector_classes_desc   = "Choisissez une classe",
  }
  -- Add Languages
}

local currentLang = "en"

function M.setLang(lang)
  if translations[lang] then
    currentLang = lang
  else
    print("[AWSC] Unknown language '" .. tostring(lang) .. "', falling back to English.")
    currentLang = "en"
  end
end

function M.t(key)
  local langTable = translations[currentLang] or translations["en"]
  return langTable[key] or translations["en"][key] or key
end

return M