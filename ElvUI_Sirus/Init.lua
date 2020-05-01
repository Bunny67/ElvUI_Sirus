local AddOnName = ...
local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local addon = E:NewModule("ElvUI_Sirus", "AceEvent-3.0")

do
	local oldPlayerTalentFrame_Refresh = PlayerTalentFrame_Refresh
	function PlayerTalentFrame_Refresh()
		if not PlayerTalentFrame:IsShown() then return end

		return oldPlayerTalentFrame_Refresh()
	end
end

do -- temp fix extra ab
	local LAB = E.Libs.LAB
	local function Update(self)
		local name = self:GetName()

		if self:HasAction() then
			local actionType, id, _, spellID = GetActionInfo(self._state_action)
			if spellID then
				SPELL_ACTION_DATA[name] = spellID
			elseif actionType == "item" and id then
				ITEM_ACTION_DATA[name] = id
			end
		else
			SPELL_ACTION_DATA[name] = false
			ITEM_ACTION_DATA[name] = false
		end
	end

	local old_script = ExtraActionBarFrame.FindOnActionBar
	function ExtraActionBarFrame:FindOnActionBar(...)
		for button in next, LAB.buttonRegistry do
			if button._state_type == "action" then
				Update(button)
			end
		end

		return old_script(ExtraActionBarFrame, ...)
	end
end

local oldIsAddOnLoaded = IsAddOnLoaded
function IsAddOnLoaded(name)
	if name == "Blizzard_TimeManager" then
		return true
	else
		return oldIsAddOnLoaded(name)
	end
end

PVPUIFrame:HookScript("OnHide", function(self)
	if self.TitleTimer then
		self.TitleTimer:Cancel()
		self.TitleTimer = nil
	end
end)

PVPHonorFrame:HookScript("OnHide", function(self)
	local worldPVP2Button = self.BottomInset.WorldPVPContainer.WorldPVP2Button

	if worldPVP2Button.Timer then
		worldPVP2Button.Timer:Cancel()
		worldPVP2Button.Timer = nil
	end
end)

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