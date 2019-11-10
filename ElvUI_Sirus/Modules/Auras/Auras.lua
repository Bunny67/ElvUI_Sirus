local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local addon = E:GetModule("ElvUI_Sirus")
local A = E:GetModule("Auras")

--Lua functions
local next = next
local wipe, tinsert, tsort, tremove = table.wipe, table.insert, table.sort, table.remove
--WoW API / Variables
local UnitAura = UnitAura

local freshTable
local releaseTable
do
	local tableReserve = {}
	freshTable = function ()
		local t = next(tableReserve) or {}
		tableReserve[t] = nil
		return t
	end
	releaseTable = function (t)
		tableReserve[t] = wipe(t)
	end
end

local function sortFactory(key, separateOwn, reverse)
	if separateOwn ~= 0 then
		if reverse then
			return function(a, b)
				if a.filter == b.filter then
					local ownA, ownB = a.caster == "player", b.caster == "player"
					if ownA ~= ownB then
						return ownA == (separateOwn > 0)
					end
					return a[key] > b[key]
				else
					return a.filter < b.filter
				end
			end;
		else
			return function(a, b)
				if a.filter == b.filter then
					local ownA, ownB = a.caster == "player", b.caster == "player"
					if ownA ~= ownB then
						return ownA == (separateOwn > 0)
					end
					return a[key] < b[key]
				else
					return a.filter < b.filter
				end
			end;
		end
	else
		if reverse then
			return function(a, b)
				if a.filter == b.filter then
					return a[key] > b[key]
				else
					return a.filter < b.filter
				end
			end;
		else
			return function(a, b)
				if a.filter == b.filter then
					return a[key] < b[key]
				else
					return a.filter < b.filter
				end
			end;
		end
	end
end

local sorters = {}
for _, key in ipairs{"index", "name", "expires"} do
	local label = string.upper(key)
	sorters[label] = {}
	for bool in pairs{[true] = true, [false] = false} do
		sorters[label][bool] = {}
		for sep = -1, 1 do
			sorters[label][bool][sep] = sortFactory(key, sep, bool)
		end
	end
end
sorters.TIME = sorters.EXPIRES

local sortingTable = {}
function A:UpdateHeader(header)
	local filter = header.filter
	local db = self.db.debuffs

	wipe(sortingTable)

	local weaponPosition
	if filter == "HELPFUL" then
		db = self.db.buffs
		weaponPosition = 1
	end

	local i, spellID = 1
	repeat
		local aura, _ = freshTable()
		aura.name, _, aura.icon, aura.count, aura.dispelType, aura.duration, aura.expires, aura.caster, _, _, spellID = UnitAura("player", i, filter)
		if aura.name then
			aura.filter = filter
			aura.index = i

			if filter == "HARMFUL" then
				if not (self.db.hideCategorieIcon and addon.Categories[spellID] or self.db.hideVIPIcon and addon.VIP[spellID]) then
					tinsert(sortingTable, aura)
				end
			else
				tinsert(sortingTable, aura)
			end
		else
			releaseTable(aura)
		end
		i = i + 1
	until not aura.name

	local sortMethod = (sorters[db.sortMethod] or sorters.INDEX)[db.sortDir == "-"][db.seperateOwn]
	tsort(sortingTable, sortMethod)

	self:ConfigureAuras(header, sortingTable, weaponPosition)
	while sortingTable[1] do
		releaseTable(tremove(sortingTable))
	end

	if self.LBFGroup then
		self.LBFGroup:Skin(E.private.auras.lbf.skin)
	end
end
