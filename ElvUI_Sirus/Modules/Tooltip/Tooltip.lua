local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:GetModule("Tooltip")

--Lua functions
local tonumber = tonumber
local format = string.format
local sub = string.sub
local tconcat = table.concat
local tinsert = table.insert
local twipe = table.wipe
--WoW API / Variables
local GetMouseFocus = GetMouseFocus
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitReaction = UnitReaction
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local ID = ID
local TARGET = TARGET

TOOLTIP_UNIT_LEVEL_RACE_CLASS_TYPE = string.gsub(TOOLTIP_UNIT_LEVEL_RACE_CLASS_TYPE, "\n.+", "")

local targetList = {}

function TT:GetItemLvL(unit)
	ItemLevelMixIn:Request(unit)
	local ilvl = ItemLevelMixIn:GetItemLevel(UnitGUID(unit))
	if ilvl then
		local color = ItemLevelMixIn:GetColor(ilvl)
		return string.format("%s%s|r", E:RGBToHex(color.r, color.g, color.b), ilvl)
	end
end

function TT:GameTooltip_OnTooltipSetUnit(tt)
	local isShiftKeyDown = IsShiftKeyDown()
	local isControlKeyDown = IsControlKeyDown()

	if tt:GetOwner() ~= UIParent and (self.db.visibility and self.db.visibility.unitFrames ~= "NONE") then
		local modifier = self.db.visibility.unitFrames

		if modifier == "ALL" or not ((modifier == "SHIFT" and isShiftKeyDown) or (modifier == "CTRL" and isControlKeyDown) or (modifier == "ALT" and IsAltKeyDown())) then
			tt:Hide()
			return
		end
	end

	local _, unit = tt:GetUnit()

	if not unit then
		local GMF = GetMouseFocus()
		if GMF and GMF:GetAttribute("unit") then
			unit = GMF:GetAttribute("unit")
		end

		if not unit or not UnitExists(unit) then return end
	end

	self:RemoveTrashLines(tt)

	if not isShiftKeyDown and not isControlKeyDown and self.db.targetInfo then
		local unitTarget = unit.."target"
		if unit ~= "player" and UnitExists(unitTarget) then
			local targetColor
			if UnitIsPlayer(unitTarget) and not UnitHasVehicleUI(unitTarget) then
				local _, class = UnitClass(unitTarget)
				targetColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

				if not targetColor then
					targetColor = RAID_CLASS_COLORS.PRIEST
				end
			else
				targetColor = E.db.tooltip.useCustomFactionColors and E.db.tooltip.factionColors[UnitReaction(unitTarget, "player")] or FACTION_BAR_COLORS[UnitReaction(unitTarget, "player")]
			end

			tt:AddDoubleLine(format("%s:", TARGET), format("|cff%02x%02x%02x%s|r", targetColor.r * 255, targetColor.g * 255, targetColor.b * 255, UnitName(unitTarget)))
		end

		local numParty = GetNumPartyMembers()
		local numRaid = GetNumRaidMembers()
		local inRaid = numRaid > 0

		if inRaid or numParty > 0 then
			for i = 1, (inRaid and numRaid or numParty) do
				local groupUnit = (inRaid and "raid"..i or "party"..i)

				if not UnitIsUnit(groupUnit, "player") and UnitIsUnit(groupUnit.."target", unit) then
					local _, class = UnitClass(groupUnit)
					local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

					if not classColor then
						classColor = RAID_CLASS_COLORS.PRIEST
					end

					tinsert(targetList, format("%s%s", E:RGBToHex(classColor.r, classColor.g, classColor.b), UnitName(groupUnit)))
				end
			end

			local numList = #targetList
			if numList > 0 then
				tt:AddLine(format("%s (|cffffffff%d|r): %s", L["Targeted By:"], numList, tconcat(targetList, ", ")), nil, nil, nil, 1)
				twipe(targetList)
			end
		end
	end

	local isPlayerUnit = UnitIsPlayer(unit)
	local color = self:SetUnitText(tt, unit, UnitLevel(unit), isShiftKeyDown)

	if isPlayerUnit then
		self:ShowInspectInfo(tt, unit, color.r, color.g, color.b)
	end

	if unit and self.db.npcID and not isPlayerUnit then
		local guid = UnitGUID(unit)
		if guid then
			local id = tonumber(sub(guid, 8, 12), 16)
			if id then
				tt:AddLine(format("|cFFCA3C3C%s|r %d", ID, id))
			end
		end
	end

	if color then
		tt.StatusBar:SetStatusBarColor(color.r, color.g, color.b)
	else
		tt.StatusBar:SetStatusBarColor(0.6, 0.6, 0.6)
	end

	local textWidth = tt.StatusBar.text:GetStringWidth()
	if textWidth then
		tt:SetMinimumWidth(textWidth)
	end
end