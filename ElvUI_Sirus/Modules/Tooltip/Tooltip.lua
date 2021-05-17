local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:GetModule("Tooltip")
local S = E:GetModule("Skins")
local ElvUF = E.oUF

--Lua functions
local tonumber = tonumber
local format = string.format
local find = string.find
local sub = string.sub
local gsub = string.gsub
local tconcat = table.concat
local tinsert = table.insert
local twipe = table.wipe
--WoW API / Variables
local CanInspect = CanInspect
local GetGuildInfo = GetGuildInfo
local GetMouseFocus = GetMouseFocus
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetTime = GetTime
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local NotifyInspect = NotifyInspect
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitCreatureType = UnitCreatureType
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsPVP = UnitIsPVP
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapped = UnitIsTapped
local UnitIsTappedByPlayer = UnitIsTappedByPlayer
local UnitIsUnit = UnitIsUnit
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitPVPName = UnitPVPName
local UnitRace = UnitRace
local UnitReaction = UnitReaction
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local FOREIGN_SERVER_LABEL = FOREIGN_SERVER_LABEL
local ID = ID
local PVP = PVP
local TAPPED_COLOR = TAPPED_COLOR
local TARGET = TARGET

local AFK_LABEL = " |cffFFFFFF[|r|cffE7E716"..L["AFK"].."|r|cffFFFFFF]|r"
local DND_LABEL = " |cffFFFFFF[|r|cffFF0000"..L["DND"].."|r|cffFFFFFF]|r"

local targetList = {}

local classification = {
	worldboss = format("|cffAF5050 %s|r", BOSS),
	rareelite = format("|cffAF5050+ %s|r", ITEM_QUALITY3_DESC),
	elite = "|cffAF5050+|r",
	rare = format("|cffAF5050 %s|r", ITEM_QUALITY3_DESC)
}

function TT:GetItemLvL(unit, giud)
	local ilvl = ItemLevelMixIn:GetItemLevel(giud or UnitGUID(unit))
	if ilvl and ilvl ~= -1 then
		local color = ItemLevelMixIn:GetColor(ilvl)
		if color then
			return format("%s%s|r", E:RGBToHex(color.r, color.g, color.b), ilvl)
		end
	else
		return TOOLTIP_UNIT_LEVEL_ILEVEL_LOADING_LABEL
	end
end

function TT:SetUnitText(tt, unit, level, isShiftKeyDown)
	local color
	if UnitIsPlayer(unit) then
		local localeClass, class = UnitClass(unit)
		if not localeClass or not class then return end

		local name, realm = UnitName(unit)
		local guildName, guildRankName = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)

		color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		if not color then
			color = RAID_CLASS_COLORS.PRIEST
		end

		if self.db.playerTitles and pvpName then
			name = pvpName
		end

		if realm and realm ~= "" then
			if isShiftKeyDown or self.db.alwaysShowRealm then
				name = name.."-"..realm
			else
				name = name..FOREIGN_SERVER_LABEL
			end
		end

		local category = ElvUF.Tags.Methods["category:name:short"](unit)
		if category then
			name = name.." |cffffffff"..category.."|r"
		end

		if UnitIsAFK(unit) then
			name = name..AFK_LABEL
		elseif UnitIsDND(unit) then
			name = name..DND_LABEL
		end

		GameTooltipTextLeft1:SetFormattedText("%s%s", E:RGBToHex(color.r, color.g, color.b), name)

		local lineOffset = 2
		if guildName then
			if self.db.guildRanks then
				GameTooltipTextLeft2:SetFormattedText("<|cff00ff10%s|r> [|cff00ff10%s|r]", guildName, guildRankName)
			else
				GameTooltipTextLeft2:SetFormattedText("<|cff00ff10%s|r>", guildName)
			end

			lineOffset = 3
		end

		local levelLine = self:GetLevelLine(tt, lineOffset)
		if levelLine then
			local diffColor = GetQuestDifficultyColor(level)
			local race = UnitRace(unit)
			levelLine:SetFormattedText("|cff%02x%02x%02x%s|r %s %s%s|r", diffColor.r * 255, diffColor.g * 255, diffColor.b * 255, level > 0 and level or "??", race or "", E:RGBToHex(color.r, color.g, color.b), localeClass)
		end
	else
		if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
			color = TAPPED_COLOR
		else
			local unitReaction = UnitReaction(unit, "player")
			if E.db.tooltip.useCustomFactionColors then
				if unitReaction then
					color = E.db.tooltip.factionColors[unitReaction]
				end
			else
				color = FACTION_BAR_COLORS[unitReaction]
			end
		end

		if not color then
			color = RAID_CLASS_COLORS.PRIEST
		end

		local levelLine = self:GetLevelLine(tt, 2)
		if levelLine then
			local creatureClassification = UnitClassification(unit)
			local creatureType = UnitCreatureType(unit)
			local pvpFlag = ""
			local diffColor = GetQuestDifficultyColor(level)

			if UnitIsPVP(unit) then
				pvpFlag = format(" (%s)", PVP)
			end

			levelLine:SetFormattedText("|cff%02x%02x%02x%s|r%s %s%s", diffColor.r * 255, diffColor.g * 255, diffColor.b * 255, level > 0 and level or "??", classification[creatureClassification] or "", creatureType or "", pvpFlag)
		end
	end

	return color
end

local inspectCache = {}

function TT:INSPECT_TALENT_READY(event, unit)
	if not unit then
		if self.lastGUID ~= UnitGUID("mouseover") then return end

		self:UnregisterEvent(event)

		unit = "mouseover"
		if not UnitExists(unit) then return end
	end

	local _, specName = E:GetTalentSpecInfo(true)
	inspectCache[self.lastGUID] = {time = GetTime()}

	if specName then
		inspectCache[self.lastGUID].specName = specName
	end

	GameTooltip:SetUnit(unit)
end

function TT:ShowInspectInfo(tt, unit, r, g, b)
	local canInspect = CanInspect(unit)
	if not canInspect then return end

	local GUID = UnitGUID(unit)
	if GUID == E.myguid then
		local _, specName = E:GetTalentSpecInfo()

		tt:AddDoubleLine(L["Talent Specialization:"], specName, nil, nil, nil, r, g, b)
		return
	elseif inspectCache[GUID] then
		local specName = inspectCache[GUID].specName

		if (GetTime() - inspectCache[GUID].time) < 900 and specName then
			tt:AddDoubleLine(L["Talent Specialization:"], specName, nil, nil, nil, r, g, b)
			return
		else
			inspectCache[GUID] = nil
		end
	end

	if InspectFrame and InspectFrame.unit then
		if UnitIsUnit(InspectFrame.unit, unit) then
			self.lastGUID = GUID
			self:INSPECT_TALENT_READY(nil, unit)
		end
	else
		self.lastGUID = GUID
		NotifyInspect(unit)
		self:RegisterEvent("INSPECT_TALENT_READY")
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
			else
				targetColor = E.db.tooltip.useCustomFactionColors and E.db.tooltip.factionColors[UnitReaction(unitTarget, "player")] or FACTION_BAR_COLORS[UnitReaction(unitTarget, "player")]
			end

			if not targetColor then
				targetColor = RAID_CLASS_COLORS.PRIEST
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

		if not UnitIsEnemy("player", unit) then
			ItemLevelMixIn:Request(unit)

			tt:AddDoubleLine(L["Item Level:"], self:GetItemLvL(unit), nil, nil, nil, 1, 1, 1)
		end
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

function TT:RepositionSocialToast(frame, _, anchor)
	if anchor ~= SocialToastMover then
		frame:ClearAllPoints()
		frame:Point("TOPLEFT", SocialToastMover, "TOPLEFT")
	end
end

if E.private.tooltip.enable then
	if SocialToastFrame then
		SocialToastFrame:SetTemplate("Transparent")
		S:HandleIcon(SocialToastFrame.Icon)
		TT:SecureHook(SocialToastFrame, "ShowToast", function(self) self.Icon:SetTexCoord(unpack(E.TexCoords)) end)
		SocialToastFrame.backdrop:SetFrameLevel(SocialToastFrame:GetFrameLevel() + 2)
		SocialToastFrame.Icon:SetParent(SocialToastFrame.backdrop)
		S:HandleCloseButton(SocialToastFrame.CloseButton)
		SocialToastFrame:ClearAllPoints()
		SocialToastFrame:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 4, 195)
		E:CreateMover(SocialToastFrame, "SocialToastMover", L["Social Toast Frame"])
		TT:SecureHook(SocialToastFrame, "SetPoint", "RepositionSocialToast")
	elseif SocialToastAnchorFrame then
		hooksecurefunc(SocialToastAnchorFrame, "ShowToast", function(self)
			for _, toastFrame in ipairs(self.toastFrames) do
				if not toastFrame.isSkinned then
					toastFrame:SetTemplate("Transparent")
					S:HandleIcon(toastFrame.Icon)
					toastFrame.backdrop:SetFrameLevel(toastFrame:GetFrameLevel() + 2)
					toastFrame.Icon:SetParent(toastFrame.backdrop)
					S:HandleCloseButton(toastFrame.CloseButton)

					toastFrame.isSkinned = true
				end

				toastFrame.Icon:SetTexCoord(unpack(E.TexCoords))
			end
		end)
	end

	TOOLTIP_UNIT_LEVEL_RACE_CLASS_TYPE = gsub(TOOLTIP_UNIT_LEVEL_RACE_CLASS_TYPE, "\n.+", "")

	hooksecurefunc(ItemLevelMixIn, "Update", function(self, unit)
		unit = unit or self.unit
		local giud = unit and UnitGUID(unit) or self.guid

		if unit and giud then
			local _, tooltipUNIT = GameTooltip:GetUnit()
			if tooltipUNIT and giud == UnitGUID(tooltipUNIT) then
				local itemLevel = TT:GetItemLvL(unit, giud)

				for lineID = 3, GameTooltip:NumLines() do
					local line = _G["GameTooltipTextRight"..lineID]
					local lineText = line:GetText()

					if lineText and find(lineText, TOOLTIP_UNIT_LEVEL_ILEVEL_LOADING_LABEL) then
						line:SetText(gsub(lineText, TOOLTIP_UNIT_LEVEL_ILEVEL_LOADING_LABEL, itemLevel))
						break
					end
				end
			end
		end
	end)
end