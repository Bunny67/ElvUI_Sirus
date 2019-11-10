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

local Categories = {
	[90001] = {name = "7-я Категория", icon = "INTERFACE\\ICONS\\seven"},
	[90002] = {name = "7-я (+) Категория", icon = "INTERFACE\\ICONS\\seven"},
	[90003] = {name = "6-я Категория", icon = "INTERFACE\\ICONS\\six"},
	[90004] = {name = "6-я (+) Категория", icon = "INTERFACE\\ICONS\\six"},
	[90005] = {name = "6-я (++) Категория", icon = "INTERFACE\\ICONS\\six"},
	[90006] = {name = "5-я Категория", icon = "INTERFACE\\ICONS\\five"},
	[90007] = {name = "5-я (+) Категория", icon = "INTERFACE\\ICONS\\five"},
	[90008] = {name = "5-я (++) Категория", icon = "INTERFACE\\ICONS\\five"},
	[90009] = {name = "5-я (+++) Категория", icon = "INTERFACE\\ICONS\\five"},
	[90010] = {name = "4-я Категория", icon = "INTERFACE\\ICONS\\four"},
	[90011] = {name = "4-я (+) Категория", icon = "INTERFACE\\ICONS\\four"},
	[90012] = {name = "4-я (++) Категория", icon = "INTERFACE\\ICONS\\four"},
	[90013] = {name = "4-я (+++) Категория", icon = "INTERFACE\\ICONS\\four"},
	[90014] = {name = "4-я (++++) Категория", icon = "INTERFACE\\ICONS\\four"},
	[90015] = {name = "3-я Категория", icon = "INTERFACE\\ICONS\\three"},
	[90016] = {name = "3-я (+) Категория", icon = "INTERFACE\\ICONS\\three"},
	[90017] = {name = "3-я (++) Категория", icon = "INTERFACE\\ICONS\\three"},
	[90018] = {name = "3-я (+++) Категория", icon = "INTERFACE\\ICONS\\three"},
	[90019] = {name = "3-я (++++) Категория", icon = "INTERFACE\\ICONS\\three"},
	[90020] = {name = "3-я (+++++) Категория", icon = "INTERFACE\\ICONS\\three"},
	[90021] = {name = "2-я Категория", icon = "INTERFACE\\ICONS\\two"},
	[90022] = {name = "2-я (+) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90023] = {name = "2-я (++) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90024] = {name = "2-я (+++) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90025] = {name = "2-я (++++) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90026] = {name = "2-я (+++++) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90027] = {name = "2-я (++++++) Категория", icon = "INTERFACE\\ICONS\\two"},
	[90028] = {name = "1-я Категория", icon = "INTERFACE\\ICONS\\one"},
	[90029] = {name = "1-я (+) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90030] = {name = "1-я (++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90031] = {name = "1-я (+++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90032] = {name = "1-я (++++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90033] = {name = "1-я (+++++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90034] = {name = "1-я (++++++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90035] = {name = "1-я (+++++++) Категория", icon = "INTERFACE\\ICONS\\one"},
	[90036] = {name = "Вне котегории", icon = "INTERFACE\\ICONS\\eternity"},

	[302100] = {name = "Вне категории (+)", icon = "INTERFACE\\ICONS\\eternity"},
	[302101] = {name = "Вне категории (++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302102] = {name = "Вне категории (+++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302103] = {name = "Вне категории (++++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302104] = {name = "Вне категории (+++++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302105] = {name = "Вне категории (++++++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302106] = {name = "Вне категории (+++++++)", icon = "INTERFACE\\ICONS\\eternity"},
	[302107] = {name = "Вне категории (++++++++)", icon = "INTERFACE\\ICONS\\eternity"},
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
}
addon.VIP = VIP

local Premium = {
	[90037] = {name = "Premium", icon = "INTERFACE\\ICONS\\VIP"},
}
addon.Premium = Premium

ElvUF.Tags.Events["category:name"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["category:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if Categories[spellID] then
			return name
		end
	end

	return nil
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

ElvUF.Tags.Events["category:name:short"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["category:name:short"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if Categories[spellID] then
			return spellID < 90036 and gsub(name, "%s(%S+)$", "") or abbrev(name)
		end
	end

	return nil
end

ElvUF.Tags.Events["category:icon"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["category:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if Categories[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end

	return nil
end

ElvUF.Tags.Events["vip:name"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["vip:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if VIP[spellID] then
			return name
		end
	end

	return nil
end

ElvUF.Tags.Events["vip:icon"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["vip:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if VIP[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end

	return nil
end

ElvUF.Tags.Events["premium:name"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["premium:name"] = function(unit)
	for i = 1, 40 do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if Premium[spellID] then
			return name
		end
	end

	return nil
end

ElvUF.Tags.Events["premium:icon"] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["premium:icon"] = function(unit)
	for i = 1, 40 do
		local name, _, icon, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not name then return nil end

		if Premium[spellID] then
			return format("|T%s:18:18:0:0:64:64:4:60:4:60|t", icon)
		end
	end

	return nil
end

E:AddTagInfo("category:name", "Sirus", "Показывает на юните категорию в виде текста")
E:AddTagInfo("category:name:short", "Sirus", "Показывает на юните категорию в виде текста (коротко)")
E:AddTagInfo("category:icon", "Sirus", "Показывает на юните категорию в виде иконки")
E:AddTagInfo("vip:name", "Sirus", "Показывает на юните VIP статус в виде текста")
E:AddTagInfo("vip:icon", "Sirus", "Показывает на юните VIP статус в виде иконки")
E:AddTagInfo("premium:name", "Sirus", "Показывает на юните Premium статус в виде текста")
E:AddTagInfo("premium:icon", "Sirus", "Показывает на юните Premium статус в виде иконки")