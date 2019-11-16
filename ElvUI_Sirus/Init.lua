local AddOnName = ...
local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local addon = E:NewModule("ElvUI_Sirus", "AceEvent-3.0")

local function GameMenuFrame_UpdateVisibleButtons()
	if not GameMenuFrame.isSirus then
		GameMenuFrame.isSirus = true
	else
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	end

	if ElvUI_ButtonAddons then
		ElvUI_ButtonAddons:ClearAllPoints()
		ElvUI_ButtonAddons:Point("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)

		GameMenuFrame.ElvUI:ClearAllPoints()
		GameMenuFrame.ElvUI:Point("TOP", ElvUI_ButtonAddons, "BOTTOM", 0, -1)

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

function addon:Initialize()
	ElvSirusDB = ElvSirusDB or {}
	ElvSirusDB[E.myrealm] = ElvSirusDB[E.myrealm] or {}

	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

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