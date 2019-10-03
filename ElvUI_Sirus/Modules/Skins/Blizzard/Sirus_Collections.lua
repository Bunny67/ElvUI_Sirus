local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true then return end

	CollectionsJournal:StripTextures()
	CollectionsJournal:SetTemplate("Transparent")

	S:HandleCloseButton(CollectionsJournal.CloseButton)

	MountJournal.navBar:StripTextures(true)
	MountJournal.navBar.overlay:StripTextures(true)

	MountJournal.navBar:CreateBackdrop()
	MountJournal.navBar.backdrop:Point("TOPLEFT", -2, 0)
	MountJournal.navBar.backdrop:Point("BOTTOMRIGHT")
	S:HandleButton(MountJournal.navBar.home, true)
	MountJournal.navBar.home.xoffset = 1

	MountJournal.navBar:ClearAllPoints()
	MountJournal.navBar:SetPoint("TOPLEFT", 6, -22)

	S:HandleEditBox(MountJournal.searchBox)

	MountJournal.FilterButton:StripTextures(true)
	S:HandleButton(MountJournal.FilterButton)

	MountJournal.ListScrollFrame:StripTextures()
	S:HandleScrollBar(MountJournal.ListScrollFrame.scrollBar)

	for _, button in pairs(MountJournal.ListScrollFrame.buttons) do
		button:SetTemplate()
		button:StyleButton()

		button.background:Hide()

		button.selectedTexture:SetTexture(.9, .8, .1, .3)
		button.selectedTexture:SetInside()
	end

	for _, button in pairs(MountJournal.CategoryScrollFrame.buttons) do
		button:SetTemplate()
		button:StyleButton()

		button.Background:Hide()

		button.Icon:SetDrawLayer("ARTWORK")

		S:HandleIcon(button.Icon)
	end

	hooksecurefunc("MountJournal_CategoryDisplayButton", function(button)
		button.Icon:SetShown(element.isCategory)
		button.backdrop:SetShown(element.isCategory)
	end)

	MountJournal.CategoryScrollFrame:StripTextures()
	S:HandleScrollBar(MountJournal.CategoryScrollFrame.scrollBar)

	MountJournal.LeftInset:StripTextures()
	MountJournal.LeftInset:SetTemplate("Transparent")

	MountJournal.RightTopInset:StripTextures()
	MountJournal.RightTopInset:SetTemplate("Transparent")

	MountJournal.RightBottomInset:StripTextures()
	MountJournal.RightBottomInset:SetTemplate("Transparent")

	MountJournal.MountCount:StripTextures()
	MountJournal.MountCount:SetTemplate("Transparent")

	MountJournal.MountDisplay:StripTextures()
	MountJournal.MountDisplay:SetTemplate("Transparent")

	MountJournal.MountDisplay.ShadowOverlay:Hide()

	S:HandleRotateButton(MountDisplayModelSceneRotateLeftButton)
	S:HandleRotateButton(MountDisplayModelSceneRotateRightButton)

	-- Не нашел отдельного метода под ActionButton.
	S:HandleItemButton(MountJournal.SummonRandomFavoriteButton)

	S:HandleIcon(MountJournal.MountDisplay.ModelScene.InfoButton.Icon)

	S:HandleButton(MountJournal.MountButton, true)
end

S:AddCallback("Sirus_Collections", LoadSkin)