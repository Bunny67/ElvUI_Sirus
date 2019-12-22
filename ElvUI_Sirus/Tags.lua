local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local ElvUF = E.oUF

local addon = E:GetModule("ElvUI_Sirus")

--Lua functions
local format = string.format
local gmatch = gmatch
local gsub = gsub
local match = string.match
local utf8upper = string.utf8upper
local utf8sub = string.utf8sub
--WoW API / Variables
local UnitAura = UnitAura

local CategoriesIDs = {
	90001, 90002,
	90003, 90004, 90005,
	90006, 90007, 90008, 90009,
	90010, 90011, 90012, 90013, 90014,
	90015, 90016, 90017, 90018, 90019, 90020,
	90021, 90022, 90023, 90024, 90025, 90026, 90027,
	90028, 90029, 90030, 90031, 90032, 90033, 90034, 90035,
	90036, 302100, 302101, 302102, 302103, 302104, 302105, 302106, 302107,
}
addon.CategoriesIDs = CategoriesIDs

local Categories = {
	[90001] = {id = 1, name = "7-я Категория", icon = "INTERFACE\\ICONS\\seven", name2 = "7-я"},
	[90002] = {id = 2, name = "7-я (+) Категория", icon = "INTERFACE\\ICONS\\seven", name2 = "7-я (1+)"},
	[90003] = {id = 3, name = "6-я Категория", icon = "INTERFACE\\ICONS\\six", name2 = "6-я"},
	[90004] = {id = 4, name = "6-я (+) Категория", icon = "INTERFACE\\ICONS\\six", name2 = "6-я (1+)"},
	[90005] = {id = 5, name = "6-я (++) Категория", icon = "INTERFACE\\ICONS\\six", name2 = "6-я (2+)"},
	[90006] = {id = 6, name = "5-я Категория", icon = "INTERFACE\\ICONS\\five", name2 = "5-я"},
	[90007] = {id = 7, name = "5-я (+) Категория", icon = "INTERFACE\\ICONS\\five", name2 = "5-я (1+)"},
	[90008] = {id = 8, name = "5-я (++) Категория", icon = "INTERFACE\\ICONS\\five", name2 = "5-я (2+)"},
	[90009] = {id = 9, name = "5-я (+++) Категория", icon = "INTERFACE\\ICONS\\five", name2 = "5-я (3+)"},
	[90010] = {id = 10, name = "4-я Категория", icon = "INTERFACE\\ICONS\\four", name2 = "4-я"},
	[90011] = {id = 11, name = "4-я (+) Категория", icon = "INTERFACE\\ICONS\\four", name2 = "4-я (1+)"},
	[90012] = {id = 12, name = "4-я (++) Категория", icon = "INTERFACE\\ICONS\\four", name2 = "4-я (2+)"},
	[90013] = {id = 13, name = "4-я (+++) Категория", icon = "INTERFACE\\ICONS\\four", name2 = "4-я (3+)"},
	[90014] = {id = 14, name = "4-я (++++) Категория", icon = "INTERFACE\\ICONS\\four", name2 = "4-я (4+)"},
	[90015] = {id = 15, name = "3-я Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я"},
	[90016] = {id = 16, name = "3-я (+) Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я (1+)"},
	[90017] = {id = 17, name = "3-я (++) Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я (2+)"},
	[90018] = {id = 18, name = "3-я (+++) Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я (3+)"},
	[90019] = {id = 19, name = "3-я (++++) Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я (4+)"},
	[90020] = {id = 20, name = "3-я (+++++) Категория", icon = "INTERFACE\\ICONS\\three", name2 = "3-я (5+)"},
	[90021] = {id = 21, name = "2-я Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я"},
	[90022] = {id = 22, name = "2-я (+) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (1+)"},
	[90023] = {id = 23, name = "2-я (++) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (2+)"},
	[90024] = {id = 24, name = "2-я (+++) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (3+)"},
	[90025] = {id = 25, name = "2-я (++++) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (4+)"},
	[90026] = {id = 26, name = "2-я (+++++) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (5+)"},
	[90027] = {id = 27, name = "2-я (++++++) Категория", icon = "INTERFACE\\ICONS\\two", name2 = "2-я (6+)"},
	[90028] = {id = 28, name = "1-я Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я"},
	[90029] = {id = 29, name = "1-я (+) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (1+)"},
	[90030] = {id = 30, name = "1-я (++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (2+)"},
	[90031] = {id = 31, name = "1-я (+++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (3+)"},
	[90032] = {id = 32, name = "1-я (++++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (4+)"},
	[90033] = {id = 33, name = "1-я (+++++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (5+)"},
	[90034] = {id = 34, name = "1-я (++++++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (6+)"},
	[90035] = {id = 35, name = "1-я (+++++++) Категория", icon = "INTERFACE\\ICONS\\one", name2 = "1-я (7+)"},
	[90036] = {id = 36, name = "Вне котегории", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК"},

	[302100] = {id = 37, name = "Вне категории (+)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (1+)"},
	[302101] = {id = 38, name = "Вне категории (++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (2+)"},
	[302102] = {id = 39, name = "Вне категории (+++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (3+)"},
	[302103] = {id = 40, name = "Вне категории (++++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (4+)"},
	[302104] = {id = 41, name = "Вне категории (+++++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (5+)"},
	[302105] = {id = 42, name = "Вне категории (++++++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (6+)"},
	[302106] = {id = 43, name = "Вне категории (+++++++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (7+)"},
	[302107] = {id = 44, name = "Вне категории (++++++++)", icon = "INTERFACE\\ICONS\\eternity", name2 = "ВК (8+)"},
}
addon.Categories = Categories

local VIP = {
	[90039] = {name = "VIP Bronze", icon = "Interface\\icons\\vipbronze"},
	[90040] = {name = "VIP Silver", icon = "interface\\icons\\vipsilver"},
	[90041] = {name = "VIP Gold", icon = "Interface\\icons\\vipgold"},
	[90042] = {name = "Elite VIP Bronze", icon = "interface\\icons\\vipbronze_el"},
	[90043] = {name = "Elite VIP Silver", icon = "Interface\\icons\\vipsilver_el"},
	[90044] = {name = "Elite VIP Gold", icon = "interface\\icons\\vipgold_el"},
	[90045] = {name = "Elite VIP Black", icon = "interface\\icons\\vipblack_el"},
	[308221] = {name = "VIP Bronze", icon = "Interface\\icons\\vipbronze"},
	[308222] = {name = "VIP Silver", icon = "interface\\icons\\vipsilver"},
	[308223] = {name = "VIP Gold", icon = "Interface\\icons\\vipgold"},
	[308224] = {name = "Elite VIP Bronze", icon = "interface\\icons\\vipbronze_el"},
	[308225] = {name = "Elite VIP Silver", icon = "Interface\\icons\\vipsilver_el"},
	[308226] = {name = "Elite VIP Gold", icon = "interface\\icons\\vipgold_el"},
	[308227] = {name = "Elite VIP Black", icon = "interface\\icons\\vipblack_el"},
}
addon.VIP = VIP

local Premium = {
	[90037] = {name = "Premium", icon = "INTERFACE\\ICONS\\VIP", name2 = "(P)"},
}
addon.Premium = Premium

ElvUF.Tags.Events["category:name"] = "UNIT_AURA"
ElvUF.Tags.Methods["category:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Categories[spellID] then
			return name
		end
	end
end

local function abbrev(name)
	local letters, lastWord = "", match(name, ".+%s(%p+)$")
	for word in gmatch(name, "%S+") do
		local firstLetter = utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
		firstLetter = utf8upper(firstLetter)
		letters = format("%s%s", letters, firstLetter)
	end

	if lastWord then
		return format("%s %s", letters, lastWord)
	else
		return format("%s", letters)
	end
end

ElvUF.Tags.Events["category:name:short"] = "UNIT_AURA"
ElvUF.Tags.Methods["category:name:short"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Categories[spellID] then
			return spellID < 90036 and gsub(name, "%s(%S+)$", "") or abbrev(name)
		end
	end
end

ElvUF.Tags.Events["category:name:veryshort"] = "UNIT_AURA"
ElvUF.Tags.Methods["category:name:veryshort"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Categories[spellID] then
			return Categories[spellID].name2 or (spellID < 90036 and gsub(name, "%s(%S+)$", "") or abbrev(name))
		end
	end
end

ElvUF.Tags.Events["category:icon"] = "UNIT_AURA"
ElvUF.Tags.Methods["category:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Categories[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end
end

ElvUF.Tags.Events["vip:name"] = "UNIT_AURA"
ElvUF.Tags.Methods["vip:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if VIP[spellID] then
			return name
		end
	end
end

ElvUF.Tags.Events["vip:icon"] = "UNIT_AURA"
ElvUF.Tags.Methods["vip:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if VIP[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end
end

ElvUF.Tags.Events["premium:name"] = "UNIT_AURA"
ElvUF.Tags.Methods["premium:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Premium[spellID] then
			return name
		end
	end
end

ElvUF.Tags.Events["premium:name:short"] = "UNIT_AURA"
ElvUF.Tags.Methods["premium:name:short"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Premium[spellID] then
			return Premium[spellID].name2
		end
	end
end

ElvUF.Tags.Events["premium:icon"] = "UNIT_AURA"
ElvUF.Tags.Methods["premium:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if Premium[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end
end

E:AddTagInfo("category:name", "Sirus", "Показывает на юните категорию в виде текста")
E:AddTagInfo("category:name:short", "Sirus", "Показывает на юните категорию в виде текста (коротко)")
E:AddTagInfo("category:name:veryshort", "Sirus", "Показывает на юните категорию в виде текста (коротко)")
E:AddTagInfo("category:icon", "Sirus", "Показывает на юните категорию в виде иконки")
E:AddTagInfo("vip:name", "Sirus", "Показывает на юните VIP статус в виде текста")
E:AddTagInfo("vip:icon", "Sirus", "Показывает на юните VIP статус в виде иконки")
E:AddTagInfo("premium:name", "Sirus", "Показывает на юните Premium статус в виде текста")
E:AddTagInfo("premium:name:short", "Sirus", "Показывает на юните Premium статус в виде текста (коротко)")
E:AddTagInfo("premium:icon", "Sirus", "Показывает на юните Premium статус в виде иконки")