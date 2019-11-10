local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
--WoW API / Variables

-- Скиннер кнопок NavBar`a с ретейл версии ElvUI.
local function SkinNavBarButtons(self)
	if (self:GetParent():GetName() == "EncounterJournal" and not E.private.skins.blizzard.encounterjournal) or (self:GetParent():GetName() == "WorldMapFrame" and not E.private.skins.blizzard.worldmap) or (self:GetParent():GetName() == "HelpFrameKnowledgebase" and not E.private.skins.blizzard.help) then
		return
	end

	local navButton = self.navList[#self.navList]
	if navButton and not navButton.isSkinned then
		S:HandleButton(navButton, true)
		navButton:GetFontString():SetTextColor(1, 1, 1)
		if navButton.MenuArrowButton then
			navButton.MenuArrowButton:StripTextures()
			if navButton.MenuArrowButton.Art then
				navButton.MenuArrowButton.Art:Size(18)
				navButton.MenuArrowButton.Art:SetTexture(E.Media.Textures.ArrowUp)
				navButton.MenuArrowButton.Art:SetTexCoord(0, 1, 0, 1)
				navButton.MenuArrowButton.Art:SetRotation(3.14)
			end
		end

		navButton.xoffset = 1

		navButton.isSkinned = true
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local BlizzardMenuButtons = {
		"Help",
		"Store",
		"PromoCodes",
		"AudioOptions",
	}

	for i = 1, #BlizzardMenuButtons do
		local ElvuiMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
		if ElvuiMenuButtons then
			S:HandleButton(ElvuiMenuButtons)
		end
	end

	-- Static Popups
	for i = 1, 4 do
		local staticPopup = _G["StaticPopup"..i]
		staticPopup.bar:StripTextures()
		staticPopup.bar:CreateBackdrop("Transparent")


		staticPopup.bar:Point("TOP", staticPopup, "BOTTOM", 0, -4)
		staticPopup.bar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(staticPopup.bar)
	end

	if InterfaceOptionsCombatPanelTargetOfTarget:GetAlpha() == 0 then
		InterfaceOptionsCombatPanelTOTDropDown:ClearAllPoints()
		InterfaceOptionsCombatPanelTOTDropDown:SetPoint("TOPRIGHT", InterfaceOptionsCombatPanelSubText, "BOTTOMRIGHT", 0, -2)
	end

	hooksecurefunc("NavBar_AddButton", SkinNavBarButtons)

	-- GhostFrame
	GhostFrame:StripTextures(nil, true)
	GhostFrameContentsFrame:SetTemplate("Transparent")
	GhostFrameContentsFrameIcon:CreateBackdrop()
	GhostFrameContentsFrameIcon:SetTexCoord(unpack(E.TexCoords))
end

S:AddCallback("Sirus_Misc", LoadSkin)