local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:GetModule("Tooltip")

--Lua functions
--WoW API / Variables

function TT:GetItemLvL(unit)
	ItemLevelMixIn:Request(unit)
	local ilvl = ItemLevelMixIn:GetItemLevel(UnitGUID(unit))
	if ilvl then
		local color = ItemLevelMixIn:GetColor(ilvl)
		return string.format("%s%s|r", E:RGBToHex(color.r, color.g, color.b), ilvl)
	end
end