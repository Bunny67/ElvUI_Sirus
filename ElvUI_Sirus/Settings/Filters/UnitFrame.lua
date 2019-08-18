local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--Lua functions
local print, unpack = print, unpack
--WoW API / Variables
local GetSpellInfo = GetSpellInfo

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		print("|cff1784d1ElvUI:|r SpellID is not valid: "..id..". Please check for an updated version, if none exists report to ElvUI author.")
		return "Impale"
	else
		return name
	end
end

local function Defaults(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

-- RAID DEBUFFS: This should be pretty self explainitory

-- Jaina Sirus
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306487)] = Defaults() -- Взрывоопасный пламень
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306488)] = Defaults() -- Взрывоопасный пламень
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306171)] = Defaults() -- Дикое пламя
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306499)] = Defaults() -- Яркое пламя
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306498)] = Defaults() -- Яркое пламя
G.unitframe.aurafilters.RaidDebuffs.spells[SpellName(306468)] = Defaults() -- Нестабильная магия