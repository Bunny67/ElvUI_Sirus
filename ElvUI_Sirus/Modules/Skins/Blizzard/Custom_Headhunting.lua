local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.headhunting then return end

	local HeadHuntingFrame = HeadHuntingFrame
	S:HandlePortraitFrame(HeadHuntingFrame)

	for i = 1, 3 do
		local popup = HeadHuntingFrame["PopupFrame"..i]
		popup:SetTemplate("Transparent")
		S:HandleButton(popup.Button1)
	end

	HeadHuntingFrame.navBar:StripTextures()
	HeadHuntingFrame.navBar.overlay:StripTextures()

	S:HandleButton(HeadHuntingFrame.navBar.home, true)
	HeadHuntingFrame.navBar.home.xoffset = 1

	HeadHuntingFrame.inset:StripTextures()

	S:HandleButton(HeadHuntingFrame.Container.HomeTab, true)
	S:HandleButton(HeadHuntingFrame.Container.AllTargetsTab, true)
	S:HandleButton(HeadHuntingFrame.Container.YouTargetsTab, true)

	local function Panel_OnShow(self)
		for _, button in ipairs(HeadHuntingFrame.columnButtons) do
			if not button.isSkinned then
				button:StripTextures()
				button:StyleButton()
				button.isSkinned = true
			end
		end
	end

	HeadHuntingFrame.Container.HomePanel:HookScript("OnShow", Panel_OnShow)
	HeadHuntingFrame.Container.HomePanel:SetTemplate("Transparent")

	HeadHuntingFrame.Container.AllTargetsPanel:HookScript("OnShow", Panel_OnShow)
	HeadHuntingFrame.Container.AllTargetsPanel:SetTemplate("Transparent")
	HeadHuntingFrame.Container.AllTargetsPanel.ScrollFrame.Background:SetAlpha(0)
	S:HandleScrollBar(HeadHuntingFrameContainerAllTargetsPanelScrollFrameScrollBar)
	HeadHuntingFrame.Container.AllTargetsPanel.ScrollFrame.ShadowOverlay:SetAlpha(0)

	HeadHuntingFrame.Container.AllTargetsPanel.InfoFrame:SetTemplate("Transparent")
	HeadHuntingFrame.Container.AllTargetsPanel.InfoFrame.BackgroundTile:SetAlpha(0)
	HeadHuntingFrame.Container.AllTargetsPanel.InfoFrame.ShadowOverlay:SetAlpha(0)
	S:HandleScrollBar(HeadHuntingFrameContainerAllTargetsPanelInfoFrameContainerScrollFrameScrollBar)
	
	local closseButton = select(3, HeadHuntingFrame.Container.AllTargetsPanel.InfoFrame:GetChildren())
	S:HandleCloseButton(closseButton)
	closseButton.Corner:SetAlpha(0)

	HeadHuntingFrame.Container.AllTargetsPanel.ContractOnPlayer:StripTextures()

	HeadHuntingFrame.Container.YouTargetsPanel:HookScript("OnShow", Panel_OnShow)
	HeadHuntingFrame.Container.YouTargetsPanel:SetTemplate("Transparent")

	S:HandleButton(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardButton)
	HeadHuntingFrame.Container.YouTargetsPanel.ScrollFrame.Background:SetAlpha(0)
	S:HandleScrollBar(HeadHuntingFrameContainerYouTargetsPanelScrollFrameScrollBar)
	HeadHuntingFrame.Container.YouTargetsPanel.ScrollFrame.ShadowOverlay:SetAlpha(0)

	HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame:SetTemplate("Transparent")
	HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.CloseCorner:SetAlpha(0)
	HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.Divider:SetAlpha(0)
	S:HandleCheckBox(HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.Container.NotifyWhenKilling)
	S:HandleCheckBox(HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.Container.NotifyWhenComplete)
	S:HandleCloseButton(HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.CloseButton)
	S:HandleButton(HeadHuntingFrame.Container.YouTargetsPanel.DetailsFrame.RemoveContractButton)

	S:HandlePortraitFrame(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame)
	S:HandleEditBox(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.SearchFrame.SearchBox)
	S:HandleButton(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.SearchFrame.SearchButton)
	HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.CentralContainer:StripTextures()
	HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.CentralContainer.ScrollFrame.ShadowOverlay:SetAlpha(0)
	S:HandleScrollBar(HeadHuntingFrameContainerYouTargetsPanelSetRewardFrameCentralContainerScrollFrameScrollBar)
	S:HandleEditBox(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.NumKills)
	S:HandleEditBox(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.GoldPerKillsEditBox)
	S:HandleButton(HeadHuntingFrame.Container.YouTargetsPanel.SetRewardFrame.SetRewardButton)

	for i = 1, 2 do
		S:HandleTab(_G["HeadHuntingFrameTab"..i])
	end
end

S:AddCallback("Custom_Headhunting", LoadSkin)