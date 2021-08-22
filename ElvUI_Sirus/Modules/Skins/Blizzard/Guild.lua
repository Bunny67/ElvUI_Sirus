local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true then return end

	-- Guild Frame
	S:HandlePortraitFrame(GuildFrame)

	GuildXPBar:StripTextures()
	GuildXPBar.progress:SetTexture(E.media.normTex)
	E:RegisterStatusBar(GuildXPBar.progress)
	GuildXPBar.cap:SetTexture(E.media.normTex)
	E:RegisterStatusBar(GuildXPBar.cap)
	GuildXPBarArt:StripTextures()
	GuildXPBar:CreateBackdrop()
	GuildXPBar.backdrop:SetOutside(GuildXPBarBG)

	for i = 1, 4 do
		local tab = _G["GuildFrameRightTab"..i]
		if i == 1 then
			tab:Point("TOPLEFT", GuildFrame, "TOPRIGHT", -E.Border, -36)
		end
		tab:GetRegions():Hide()
		tab:StyleButton()
		tab:SetTemplate("Default", true)

		tab.Icon:SetInside()
		tab.Icon:SetTexCoord(unpack(E.TexCoords))
	end

	-- top tab
	for i = 1, 3 do
		local tab = _G["GuildInfoFrameTab"..i]
		S:HandleTab(tab)
	end

	S:HandleButton(GuildRecruitmentInviteButton, true)
	S:HandleButton(GuildRecruitmentMessageButton, true)
	S:HandleButton(GuildRecruitmentDeclineButton, true)

	-- GuildPerks Frame
	GuildAllPerksFrame:StripTextures()
	S:HandleScrollBar(GuildPerksContainerScrollBar)

	for i = 1, #GuildPerksContainer.buttons do
		local button = GuildPerksContainer.buttons[i]
		button:StripTextures()

		button.icon:CreateBackdrop()
		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:SetParent(button.icon.backdrop)
	end

	-- GuildRewards Frame
	GuildRewardsFrame:StripTextures()
	S:HandleScrollBar(GuildRewardsContainerScrollBar)

	for i = 1, #GuildRewardsContainer.buttons do
		local button = GuildRewardsContainer.buttons[i]
		button:StripTextures()

		button.icon:CreateBackdrop()
		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:SetParent(button.icon.backdrop)
	end

	-- GuildRoster Frame
	S:HandleDropDownBox(GuildRosterViewDropdown)

	for i = 1, 5 do
		_G["GuildRosterColumnButton"..i]:StripTextures()
		_G["GuildRosterColumnButton"..i]:StyleButton()
	end

	S:HandleScrollBar(GuildRosterContainerScrollBar)

	S:HandleCheckBox(GuildRosterShowOfflineButton)

	-- GuildMemberDetail Frame
	GuildMemberDetailFrame:StripTextures()
	GuildMemberDetailFrame:SetTemplate("Transparent")

	S:HandleCloseButton(GuildMemberDetailCloseButton)

	S:HandleButton(GuildMemberRemoveButton)
	S:HandleButton(GuildMemberGroupInviteButton)

	-- GuildInfo Frame
	GuildInfoFrame:StripTextures()

	S:HandleScrollBar(GuildInfoFrameInfoMOTDScrollFrameScrollBar)
	S:HandleButton(GuildInfoEditMOTDButton)
	S:HandleButton(GuildInfoEditDetailsButton)
	S:HandleScrollBar(GuildInfoDetailsFrameScrollBar)
	S:HandleButton(GuildAddMemberButton, true)
	S:HandleButton(GuildControlButton, true)
	S:HandleButton(GuildViewLogButton, true)
	S:HandleButton(GuildRenameButton, true)

	-- GuildTextEditFrame
	GuildTextEditFrame:SetTemplate("Transparent")
	S:HandleCloseButton(GuildTextEditFrameCloseButton)
	GuildTextEditContainer:SetBackdrop(nil)

	S:HandleScrollBar(GuildTextEditScrollFrameScrollBar)

	S:HandleButton(GuildTextEditFrameAcceptButton)
	S:HandleButton(GuildTextEditFrameCloseButton)

	-- GuildLogFrame not work for now
	GuildLogFrame:StripTextures()
	GuildLogFrame:SetTemplate("Transparent")

	local CloseButton, _, CloseButton2 = GuildLogFrame:GetChildren()
	S:HandleCloseButton(CloseButton)
	GuildLogContainer:SetBackdrop(nil)

	S:HandleScrollBar(GuildLogScrollFrameScrollBar)

	S:HandleButton(CloseButton2)

	S:HandleDropDownBox(GuildMemberRankDropdown)
    local dropdownArrowColor = {1, 0.8, 0}
    S:HandleNextPrevButton(GuildMemberRankDropdownButton, "down", dropdownArrowColor)
    GuildMemberRankDropdownButton:Size(23)

end

S:AddCallback("Guild", LoadSkin)