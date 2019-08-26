local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
local GetWhoInfo = GetWhoInfo
local GetGuildRosterInfo = GetGuildRosterInfo

local function FriendsFrameTooltip_Show(self)
	if self.buttonType == FRIENDS_BUTTON_TYPE_HEADER then return end

	local toonIndex, anchor = 1
	local tooltip = FriendsTooltip
	tooltip.height = 0
	tooltip.maxWidth = 0
	
	if self.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local name, level, class, area, connected, _, noteText = GetFriendInfo(self.id)
		anchor = FriendsFrameTooltip_SetLine(FriendsTooltipHeader, nil, name)
		if connected then
			FriendsTooltipHeader:SetTextColor(FRIENDS_WOW_NAME_COLOR.r, FRIENDS_WOW_NAME_COLOR.g, FRIENDS_WOW_NAME_COLOR.b)
			local str = string.format(FRIENDS_LEVEL_TEMPLATE, level, class)
			local catID = GetGuildCharacterCategory(name)
			if catID then
				str = GetSpellInfo(catID).."\n\n"..str
			end
			FriendsFrameTooltip_SetLine(FriendsTooltipToon1Name, nil, str)
			anchor = FriendsFrameTooltip_SetLine(FriendsTooltipToon1Info, nil, area)
		else
			FriendsTooltipHeader:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
			FriendsTooltipToon1Name:Hide()
			FriendsTooltipToon1Info:Hide()
		end
		if noteText then
			FriendsTooltipNoteIcon:Show()
			anchor = FriendsFrameTooltip_SetLine(FriendsTooltipNoteText, anchor, noteText, -8)
		else
			FriendsTooltipNoteIcon:Hide()
			FriendsTooltipNoteText:Hide()
		end
	end

	for i = toonIndex + 1, FRIENDS_TOOLTIP_MAX_TOONS do
		toonNameString = _G["FriendsTooltipToon"..i.."Name"]
		toonInfoString = _G["FriendsTooltipToon"..i.."Info"]
		toonNameString:Hide()
		toonInfoString:Hide()
	end

	FriendsTooltipBroadcastIcon:Hide()
	FriendsTooltipOtherToons:Hide()
	FriendsTooltipToonMany:Hide()

	tooltip.button = self
	tooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 36, 0)
	tooltip:SetHeight(tooltip.height + FRIENDS_TOOLTIP_MARGIN_WIDTH)
	tooltip:SetWidth(min(FRIENDS_TOOLTIP_MAX_WIDTH, tooltip.maxWidth + FRIENDS_TOOLTIP_MARGIN_WIDTH))
	tooltip:Show()
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true then return; end

	-- Friends Frame
	FriendsFrame:StripTextures(true)
	FriendsFrame:CreateBackdrop("Transparent")
	FriendsFrame.backdrop:Point("TOPLEFT", 10, -12)
	FriendsFrame.backdrop:Point("BOTTOMRIGHT", -33, 76)

	S:HandleCloseButton(FriendsFrameCloseButton)

	S:HandleDropDownBox(FriendsFrameStatusDropDown, 70)
	FriendsFrameStatusDropDown:Point("TOPLEFT", FriendsListFrame, "TOPLEFT", 13, -44)
	S:HandleEditBox(FriendsFrameBroadcastInput)
	FriendsFrameBroadcastInput:Width(224)
	FriendsFrameBroadcastInput:Point("TOPLEFT", FriendsFrameStatusDropDown, "TOPRIGHT", 13, -3)

	for i = 1, 5 do
		S:HandleTab(_G["FriendsFrameTab"..i])
	end

	-- Friends List Frame
	for i = 1, 2 do
		local Tab = _G["FriendsTabHeaderTab"..i]
		Tab:StripTextures()
		Tab:CreateBackdrop("Default", true)
		Tab.backdrop:Point("TOPLEFT", 3, -7)
		Tab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		Tab:HookScript("OnEnter", S.SetModifiedBackdrop)
		Tab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	for i = 1, #FriendsFrameFriendsScrollFrame.buttons do
		local button = FriendsFrameFriendsScrollFrame.buttons[i]
		button:SetScript("OnEnter", FriendsFrameTooltip_Show)

		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonIcon"]:SetTexCoord(unpack(E.TexCoords))
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonNormalTexture"]:SetAlpha(0)
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButton"]:StyleButton()
	end

	S:HandleScrollBar(FriendsFrameFriendsScrollFrameScrollBar)

	S:HandleButton(FriendsFrameAddFriendButton, true)
	S:HandleButton(FriendsFrameSendMessageButton, true)

	-- Ignore List Frame
	S:HandleButton(FriendsFrameIgnorePlayerButton, true)
	S:HandleButton(FriendsFrameUnsquelchButton, true)

	-- Who Frame
	WhoFrameColumnHeader3:ClearAllPoints()
	WhoFrameColumnHeader3:SetPoint("TOPLEFT", 20, -70)

	WhoFrameColumnHeader4:ClearAllPoints()
	WhoFrameColumnHeader4:SetPoint("LEFT", WhoFrameColumnHeader3, "RIGHT", -2, -0)
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader4, 48)

	WhoFrameColumnHeader1:ClearAllPoints()
	WhoFrameColumnHeader1:SetPoint("LEFT", WhoFrameColumnHeader4, "RIGHT", -2, -0)
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader1, 105)

	WhoFrameColumnHeader2:ClearAllPoints()
	WhoFrameColumnHeader2:SetPoint("LEFT", WhoFrameColumnHeader1, "RIGHT", -2, -0)

	for i = 1, 4 do
		_G["WhoFrameColumnHeader"..i]:StripTextures()
		_G["WhoFrameColumnHeader"..i]:StyleButton()
	end

	S:HandleDropDownBox(WhoFrameDropDown)

	for i = 1, 17 do
		local button = _G["WhoFrameButton"..i]

		button.icon = button:CreateTexture("$parentIcon", "ARTWORK")
		button.icon:Point("LEFT", 45, 0)
		button.icon:Size(15)
		button.icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")

		button:CreateBackdrop("Default", true)
		button.backdrop:SetAllPoints(button.icon)
		S:HandleButtonHighlight(button)

		_G["WhoFrameButton"..i.."Level"]:ClearAllPoints()
		_G["WhoFrameButton"..i.."Level"]:SetPoint("TOPLEFT", 11, -1)

		_G["WhoFrameButton"..i.."Name"]:SetSize(100, 14)
		_G["WhoFrameButton"..i.."Name"]:ClearAllPoints()
		_G["WhoFrameButton"..i.."Name"]:SetPoint("LEFT", 85, 0)

		_G["WhoFrameButton"..i.."Class"]:Hide()
	end

	WhoListScrollFrame:StripTextures()
	S:HandleScrollBar(WhoListScrollFrameScrollBar)

	S:HandleEditBox(WhoFrameEditBox)
	WhoFrameEditBox:Point("BOTTOM", -12, 107)
	WhoFrameEditBox:Size(326, 18)

	S:HandleButton(WhoFrameWhoButton)
	WhoFrameWhoButton:ClearAllPoints()
	WhoFrameWhoButton:SetPoint("BOTTOMLEFT", 16, 82)
	S:HandleButton(WhoFrameAddFriendButton)
	WhoFrameAddFriendButton:SetPoint("LEFT", WhoFrameWhoButton, "RIGHT", 3, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -3, 0)
	S:HandleButton(WhoFrameGroupInviteButton)

	hooksecurefunc("WhoList_Update", function()
		local _, level
		local button, buttonText, classTextColor, classFileName, levelTextColor

		for i = 1, WHOS_TO_DISPLAY, 1 do
			button = _G["WhoFrameButton"..i]
			_, _, level, _, _, _, classFileName = GetWhoInfo(button.whoIndex)

			if classFileName then
				classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName]
				button.icon:Show()
				button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
			else
				classTextColor = HIGHLIGHT_FONT_COLOR
				button.icon:Hide()
			end

			levelTextColor = GetQuestDifficultyColor(level)

			buttonText = _G["WhoFrameButton"..i.."Name"]
			buttonText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
			buttonText = _G["WhoFrameButton"..i.."Level"]
			buttonText:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b)
			buttonText = _G["WhoFrameButton"..i.."Class"]
			buttonText:SetTextColor(1.0, 1.0, 1.0)
		end
	end)

	-- Channel Frame
	ChannelFrameVerticalBar:Kill()

	S:HandleCheckBox(ChannelFrameAutoJoinParty)
	S:HandleCheckBox(ChannelFrameAutoJoinBattleground)

	S:HandleButton(ChannelFrameNewButton)

	ChannelListScrollFrame:StripTextures()
	S:HandleScrollBar(ChannelListScrollFrameScrollBar)

	for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
		_G["ChannelButton"..i]:StripTextures()
		_G["ChannelButton"..i.."Collapsed"]:SetTextColor(1, 1, 1)

		S:HandleButtonHighlight(_G["ChannelButton"..i])
	end

	for i = 1, 22 do
		S:HandleButtonHighlight(_G["ChannelMemberButton"..i])
	end

	ChannelRosterScrollFrame:StripTextures()
	S:HandleScrollBar(ChannelRosterScrollFrameScrollBar)

	ChannelFrameDaughterFrame:StripTextures()
	ChannelFrameDaughterFrame:SetTemplate("Transparent")

	S:HandleEditBox(ChannelFrameDaughterFrameChannelName)
	S:HandleEditBox(ChannelFrameDaughterFrameChannelPassword)

	S:HandleCloseButton(ChannelFrameDaughterFrameDetailCloseButton)

	S:HandleButton(ChannelFrameDaughterFrameCancelButton)
	S:HandleButton(ChannelFrameDaughterFrameOkayButton)

	-- Raid Frame
	S:HandleButton(RaidFrameConvertToRaidButton)
	S:HandleButton(RaidFrameRaidInfoButton)
	S:HandleButton(RaidFrameNotInRaidRaidBrowserButton)

	-- Raid Info Frame
	RaidInfoFrame:StripTextures(true)
	RaidInfoFrame:SetTemplate("Transparent")

	RaidInfoInstanceLabel:StripTextures()
	RaidInfoIDLabel:StripTextures()

	S:HandleCloseButton(RaidInfoCloseButton)

	S:HandleScrollBar(RaidInfoScrollFrameScrollBar)

	S:HandleButton(RaidInfoExtendButton)
	S:HandleButton(RaidInfoCancelButton)
end

S:RemoveCallback("Friends")
S:AddCallback("Friends", LoadSkin)