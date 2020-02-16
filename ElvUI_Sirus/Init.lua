local AddOnName = ...
local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local addon = E:NewModule("ElvUI_Sirus", "AceEvent-3.0")

local oldIsAddOnLoaded = IsAddOnLoaded
function IsAddOnLoaded(name)
	if name == "Blizzard_TimeManager" then
		return true
	else
		return oldIsAddOnLoaded(name)
	end
end

NPE_TutorialPointerFrame.Show = E.noop


local function GameMenuFrame_UpdateVisibleButtons()
	if not GameMenuFrame.isSirus then
		GameMenuFrame.isSirus = true
	else
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	end

	local addonsButton = GameMenuButtonAddOns or ElvUI_AddonListButton
	if addonsButton then
		GameMenuButtonMacros:ClearAllPoints()
		GameMenuButtonMacros:Point("TOP", GameMenuButtonKeybindings, "BOTTOM", 0, -1)

		addonsButton:ClearAllPoints()
		addonsButton:Point("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)

		GameMenuFrame.ElvUI:ClearAllPoints()
		GameMenuFrame.ElvUI:Point("TOP", addonsButton, "BOTTOM", 0, -1)

		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	end
end

function addon:GetUnitCategory(unit)
	local category
	if ElvSirusDB[E.myrealm][unit] then
		category = self.Categories[self.CategoriesIDs[ElvSirusDB[E.myrealm][unit]]]
		return category.name, category.icon, category.name2
--	else

	end
end

function addon:UPDATE_MOUSEOVER_UNIT()
	if UnitIsPlayer("mouseover") then
		local name = UnitName("mouseover")
		if not name or name == UNKNOWN then return end

		for i = 1, 40 do
			local _, _, _, _, _, _, _, _, _, _, spellID = UnitAura("mouseover", i, "HARMFUL")
			if not spellID then break end

			if self.Categories[spellID] then
				local id = self.Categories[spellID].id
				if ElvSirusDB[E.myrealm][name] ~= id then
					ElvSirusDB[E.myrealm][name] = id
				end
				break
			end
		end
	end
end

function addon:FixArenaTaint()
	ArenaEnemyFrames.ClearAllPoints = E.noop
	ArenaEnemyFrames.SetPoint = E.noop
end

function addon:ADDON_LOADED(_, addonName)
	if addonName == "Blizzard_ArenaUI" then
		self:FixArenaTaint()
	end
end

function addon:Initialize()
	ElvSirusDB = ElvSirusDB or {}
	ElvSirusDB[E.myrealm] = ElvSirusDB[E.myrealm] or {}

	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	if E.private.unitframe.disabledBlizzardFrames.arena then
		if not IsAddOnLoaded("Blizzard_ArenaUI") then
			self:RegisterEvent("ADDON_LOADED")
		else
			self:FixArenaTaint()
		end
	end

	hooksecurefunc("WorldStateScoreFrame_Update", function()
		local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)
		local _, name, nameText

		for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
			name, _, _, _, _, faction, _, _, _, classToken = GetBattlefieldScore(offset + i)

			if name then
				local _, _, name2 = addon:GetUnitCategory(name)
				if name2 then
					nameText = _G["WorldStateScoreButton"..i.."NameText"]
					nameText:SetFormattedText("%s |cffffffff%s|r", name, name2)
				end
			end
		end
	end)

	GameMenuFrame:HookScript("OnShow", GameMenuFrame_UpdateVisibleButtons)

	local function StaticPopup_OnShow(self)
		if self.ReplayInfoFrame then
			self.ReplayInfoFrame:Hide()
		end
	end

	for index = 1, 4 do
		E.StaticPopupFrames[index]:HookScript("OnShow", StaticPopup_OnShow)
	end

	EP:RegisterPlugin(AddOnName, self.GetOptions)
end

local function InitializeCallback()
	addon:Initialize()
end

E:RegisterModule(addon:GetName(), InitializeCallback)






if true then return end

local mod = E:NewModule("ElvUI_BattlegroundTargets", "AceEvent-3.0")
BTar = mod

local bgData = {
	[444] = {},
	[541] = {},
	[513] = {},
	[402] = {},
	[462] = {},
	[483] = {}, -- Око бури
	[611] = {}, -- Долина узников
	[861] = {}, -- Сверкающие копи
}















mod.Units = {}
mod.UnitToIndex = {}
mod.IndexToButton = {}
mod.Buttons = {}

local isDebug = true

function mod:Debug(...)
	if not isDebug then return end

	E:Print("BT: ", ...)
end

local i = 1
function mod:CreateButton(index)
	if not self.Buttons[i] then
		self.Buttons[i] = CreateFrame("Frame", nil, self.frame)
		self.Buttons[i]:SetSize(100, 20)
		self.Buttons[i]:SetPoint("TOP", 0, -(i * 20))
		self.Buttons[i]:SetTemplate()
		self.Buttons[i].text = self.Buttons[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		self.Buttons[i].text:SetAllPoints()
	end
end

function mod:UpdateButton(id, index, name, classToken)
	if not self.Buttons[id] then return end

	self.Buttons[id]:Show()
	self.Buttons[id].text:SetText(name)
end

function mod:HideButton(id)
	if not self.Buttons[id] then return end

	self.Buttons[id]:Hide()
end

function mod:UPDATE_BATTLEFIELD_SCORE()
	table.wipe(self.Units)

	for index = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, _, classToken = GetBattlefieldScore(index)
		if name then
			if name == E.myname and faction and self.PlayerFaction ~= faction then
				self.PlayerFaction = faction

self:Debug("Получена инфа о фракции игрока", faction)

				self:UPDATE_BATTLEFIELD_SCORE()
				break
			end

			if self.PlayerFaction and faction ~= self.PlayerFaction then
				self.Units[name] = true

				local oldButton, oldIndex = self.IndexToButton[index], self.UnitToIndex[name]
				if not self.UnitToIndex[name] then -- Add new unit
					self.UnitToIndex[name] = index
					self.IndexToButton[index] = i

self:Debug("Добавляем игрока", index, name, faction)

					self:CreateButton(index)
					self:UpdateButton(i, index, name, classToken)

					i = i + 1
				end
				
				if self.UnitToIndex[name] ~= index then -- Update unit index
					self.UnitToIndex[name] = index
					self.IndexToButton[index] = oldButton

self:Debug("Обновляем игрока", index, name, faction)

					self:UpdateButton(oldButton, index, name, classToken)
				end
			end
		end
	end
	
	for name, index in pairs(self.UnitToIndex) do
		if not self.Units[name] then
			self:HideButton(self.IndexToButton[index])

			self.UnitToIndex[name] = nil
		end
	end
end

function mod:PLAYER_ENTERING_WORLD()
	local inInstance, instanceType = IsInInstance()
	local isInPVP = inInstance and (instanceType == "pvp")
	if isInPVP then
		local mapAreaID = GetCurrentMapAreaID()
		local mapData = bgData[mapAreaID]

		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

		self:UPDATE_BATTLEFIELD_SCORE()
	else
		self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")

		self.PlayerFaction = nil
	end
end

function mod:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	self.frame = CreateFrame("Frame", "Test Frame", UIParent)
	self.frame:SetPoint("CENTER", 300, 0)
	self.frame:SetSize(200, 200)
	self.frame:SetTemplate("Transparent")

	E:CreateMover(self.frame, self.frame:GetName().."Mover", "Test Frame")
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)



