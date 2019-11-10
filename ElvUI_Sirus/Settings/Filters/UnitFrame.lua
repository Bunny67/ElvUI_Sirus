local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--Lua functions
local print = print
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

G.unitframe.aurafilters.Blacklist.spells[90001] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90002] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90003] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90004] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90005] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90006] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90007] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90008] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90009] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90010] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90011] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90012] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90013] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90014] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90015] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90016] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90017] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90018] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90019] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90020] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90021] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90022] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90023] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90024] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90025] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90026] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90027] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90028] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90029] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90030] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90031] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90032] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90033] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90034] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90035] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90036] = Defaults()

G.unitframe.aurafilters.Blacklist.spells[302100] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302100] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302101] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302102] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302103] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302104] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302105] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302106] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[302107] = Defaults()

G.unitframe.aurafilters.Blacklist.spells[90039] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90040] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90041] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90042] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90043] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90044] = Defaults()
G.unitframe.aurafilters.Blacklist.spells[90045] = Defaults()

G.unitframe.aurafilters.Blacklist.spells[90037] = Defaults()