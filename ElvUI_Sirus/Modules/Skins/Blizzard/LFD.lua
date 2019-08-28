local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local select, unpack = select, unpack
local find = string.find
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfd ~= true then return end

	S:HandlePortraitFrame(LFDParentFrame)
	S:HandleCloseButton(LFDParentFrameCloseButton)
	LFDParentFrame:SetTemplate("Transparent")
	LFDParentFrame.LeftInset:StripTextures()
	LFDParentFrame.Shadows:StripTextures()

	for i = 1, LFDParentFrame:GetNumChildren() do
		local child = select(i, LFDParentFrame:GetChildren())
		if child and child:GetName() and find(child:GetName(), "Art") then
			child:StripTextures()
		end
	end

	for i = 1, 3 do
		S:HandleTab(_G["LFDParentFrameTab"..i])
	end

	LFDParentFrameGroupButton1.ring:Kill()
	LFDParentFrameGroupButton1.bg:Kill()
	S:HandleButton(LFDParentFrameGroupButton1)
	LFDParentFrameGroupButton1.icon:Size(45)
	LFDParentFrameGroupButton1.icon:ClearAllPoints()
	LFDParentFrameGroupButton1.icon:Point("LEFT", 10, 0)
	LFDParentFrameGroupButton1.icon:SetTexCoord(unpack(E.TexCoords))
	LFDParentFrameGroupButton1.icon:CreateBackdrop()
	LFDParentFrameGroupButton1.icon:SetParent(LFDParentFrameGroupButton1.icon.backdrop)
	LFDParentFrameGroupButton1.icon.backdrop:SetFrameLevel(LFDParentFrameGroupButton1:GetFrameLevel() + 2)

	LFDQueueParentFrame:StripTextures()
	LFDQueueParentFrameInset:StripTextures()

	LFDQueueFrame:StripTextures(true)

	S:HandleCheckBox(LFDQueueFrameRoleButtonTank.checkButton)
	LFDQueueFrameRoleButtonTank.checkButton:SetFrameLevel(LFDQueueFrameRoleButtonTank.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(LFDQueueFrameRoleButtonHealer.checkButton)
	LFDQueueFrameRoleButtonHealer.checkButton:SetFrameLevel(LFDQueueFrameRoleButtonHealer.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(LFDQueueFrameRoleButtonDPS.checkButton)
	LFDQueueFrameRoleButtonDPS.checkButton:SetFrameLevel(LFDQueueFrameRoleButtonDPS.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(LFDQueueFrameRoleButtonLeader.checkButton)
	LFDQueueFrameRoleButtonLeader.checkButton:SetFrameLevel(LFDQueueFrameRoleButtonLeader.checkButton:GetFrameLevel() + 2)

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown, 150)

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown)
	LFDQueueFrameTypeDropDown:ClearAllPoints()
	LFDQueueFrameTypeDropDown:Point("TOPLEFT", 110, -125)

	LFDQueueFrameRandomScrollFrame:StripTextures()
	S:HandleScrollBar(LFDQueueFrameRandomScrollFrameScrollBar)

	local function SkinLFDRandomDungeonLoot(frame)
		if frame.isSkinned then return end

		local icon = _G[frame:GetName().."IconTexture"]
		local nameFrame = _G[frame:GetName().."NameFrame"]
		local count = _G[frame:GetName().."Count"]

		frame:StripTextures()
		frame:CreateBackdrop("Transparent")
		frame.backdrop:SetOutside(icon)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetDrawLayer("BORDER")
		icon:SetParent(frame.backdrop)

		nameFrame:SetSize(118, 39)

		count:SetParent(frame.backdrop)
		frame.isSkinned = true
	end

	local scan
	local function GetLFGDungeonRewardLinkFix(dungeonID, rewardIndex)
		local _, link = GetLFGDungeonRewardLink(dungeonID, rewardIndex)
		if not link then
			if not scan then
				scan = CreateFrame("GameTooltip", "DungeonRewardLinkScan", nil, "GameTooltipTemplate")
				scan:SetOwner(UIParent, "ANCHOR_NONE")
			end
			scan:ClearLines()
			scan:SetLFGDungeonReward(dungeonID, rewardIndex)
			_, link = scan:GetItem()
		end
		return link
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if not dungeonID then return end

		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)
		for i = 1, numRewards do
			local frame = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			local name = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Name"]
			SkinLFDRandomDungeonLoot(frame)

			local link = GetLFGDungeonRewardLinkFix(dungeonID, i)
			if link then
				local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(link)
				if quality then
					_G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]:SetTexture(texture)
					frame.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
					name:SetTextColor(GetItemQualityColor(quality))
				end
			else
				frame.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
				name:SetTextColor(1, 1, 1)
			end
		end
	end)

	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		local button = _G["LFDQueueFrameSpecificListButton"..i]
		button.enableButton:StripTextures()
		button.enableButton:CreateBackdrop("Default")
		button.enableButton.backdrop:SetInside(nil, 4, 4)

		button.expandOrCollapseButton:SetNormalTexture(E.Media.Textures.Plus)
		button.expandOrCollapseButton.SetNormalTexture = E.noop
		button.expandOrCollapseButton:GetNormalTexture():Size(16)

		button.expandOrCollapseButton:SetHighlightTexture(nil)

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
			elseif find(texture, "PlusButton") then
				self:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
			end
		end)
	end

	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	S:HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)

	S:HandleButton(LFDQueueFrameFindGroupButton, true)

	hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
		if LFDQueueFrameCooldownFrame:IsShown() then
			LFDQueueFrameCooldownFrame:SetFrameLevel(LFDQueueFrameCooldownFrame:GetParent():GetFrameLevel() + 5)
		end
	end)

	S:HandleButton(LFDQueueFramePartyBackfillBackfillButton)
	S:HandleButton(LFDQueueFramePartyBackfillNoBackfillButton)

	S:HandleButton(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)

	-- ElvUI
	LFDDungeonReadyStatus:SetTemplate("Transparent")

	S:HandleCloseButton(LFDDungeonReadyStatusCloseButton, nil, "-")

	LFDDungeonReadyDialog:SetTemplate("Transparent")

	LFDDungeonReadyDialog.label:Size(280, 0)
	LFDDungeonReadyDialog.label:Point("TOP", 0, -10)

	LFDDungeonReadyDialog:CreateBackdrop("Default")
	LFDDungeonReadyDialog.backdrop:Point("TOPLEFT", 10, -35)
	LFDDungeonReadyDialog.backdrop:Point("BOTTOMRIGHT", -10, 40)

	LFDDungeonReadyDialog.backdrop:SetFrameLevel(LFDDungeonReadyDialog:GetFrameLevel())
	LFDDungeonReadyDialog.background:SetInside(LFDDungeonReadyDialog.backdrop)

	LFDDungeonReadyDialogFiligree:SetTexture("")
	LFDDungeonReadyDialogBottomArt:SetTexture("")

	S:HandleCloseButton(LFDDungeonReadyDialogCloseButton, nil, "-")

	LFDDungeonReadyDialogEnterDungeonButton:Point("BOTTOMRIGHT", LFDDungeonReadyDialog, "BOTTOM", -7, 10)
	S:HandleButton(LFDDungeonReadyDialogEnterDungeonButton)
	LFDDungeonReadyDialogLeaveQueueButton:Point("BOTTOMLEFT", LFDDungeonReadyDialog, "BOTTOM", 7, 10)
	S:HandleButton(LFDDungeonReadyDialogLeaveQueueButton)

	local function SkinLFDDungeonReadyDialogReward(button)
		if button.isSkinned then return end

		button:Size(28)
		button:SetTemplate("Default")
		button.texture:SetInside()
		button.texture:SetTexCoord(unpack(E.TexCoords))
		button:DisableDrawLayer("OVERLAY")
		button.isSkinned = true
	end

	hooksecurefunc("LFDDungeonReadyDialogReward_SetMisc", function(button)
		SkinLFDDungeonReadyDialogReward(button)

		SetPortraitToTexture(button.texture, "")
		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFDDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex)
		SkinLFDDungeonReadyDialogReward(button)

		local link = GetLFGDungeonRewardLinkFix(dungeonID, rewardIndex)
		if link then
			local _, _, quality = GetItemInfo(link)
			button:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		local texturePath = button.texture:GetTexture()
		if texturePath then
			SetPortraitToTexture(button.texture, "")
			button.texture:SetTexture(texturePath)
		end
	end)

	LFDRoleCheckPopup:SetTemplate("Transparent")

	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonTank.checkButton)
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonHealer.checkButton)
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonDPS.checkButton)

	S:HandleButton(LFDRoleCheckPopupAcceptButton)
	S:HandleButton(LFDRoleCheckPopupDeclineButton)

	LFDSearchStatus:SetTemplate("Transparent")
	-- End ElvUI

	S:HandlePortraitFrame(PVPUIFrame)
	S:HandleCloseButton(PVPUIFrameCloseButton)
	PVPUIFrame:SetTemplate("Transparent")
	PVPUIFrame.LeftInset:StripTextures()
	PVPUIFrame.Shadows:StripTextures()

	for i = 1, PVPUIFrame:GetNumChildren() do
		local child = select(i, PVPUIFrame:GetChildren())
		if child and child:GetName() and find(child:GetName(), "Art") then
			child:StripTextures()
		end
	end

	for i = 1, 3 do
		S:HandleTab(_G["PVPUIFrameTab"..i])
	end

	for i = 1, 3 do
		local b = PVPQueueFrame["CategoryButton"..i]
		b.Ring:Kill()
		b.Background:Kill()
		S:HandleButton(b)
		b.Icon:Size(45)
		b.Icon:ClearAllPoints()
		b.Icon:Point("LEFT", 10, 0)
		b.Icon:SetTexCoord(unpack(E.TexCoords))
		b.Icon:CreateBackdrop()
		b.Icon:SetParent(b.Icon.backdrop)
		b.Icon.backdrop:SetFrameLevel(b:GetFrameLevel() + 2)
	end

	PVPQueueFrame.CapTopFrame:StripTextures()

	PVPQueueFrame.CapTopFrame.StatusBar:CreateBackdrop()
	PVPQueueFrame.CapTopFrame.StatusBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(PVPQueueFrame.CapTopFrame.StatusBar)
	PVPQueueFrame.CapTopFrame.StatusBar.Left:Kill()
	PVPQueueFrame.CapTopFrame.StatusBar.Right:Kill()
	PVPQueueFrame.CapTopFrame.StatusBar.Middle:Kill()
	PVPQueueFrame.CapTopFrame.StatusBar.Background:Kill()


	PVPQueueFrame.StepBottomFrame:StripTextures()
	PVPQueueFrame.StepBottomFrame:CreateBackdrop()
	PVPQueueFrame.StepBottomFrame.backdrop:SetInside(PVPQueueFrame.StepBottomFrame.ShadowOverlay)
--	PVPQueueFrame.StepBottomFrame.backdrop:SetOutside(PVPQueueFrame.StepBottomFrame.Step1.Background, nil, nil, PVPQueueFrame.StepBottomFrame.StepEnd.Background)

--[[
	for i = 1, 4 do
		local step = PVPQueueFrame.StepBottomFrame["Step"..i]
		step.Background:SetTexture(E.media.normTex)
		step.Background.SetAtlas = E.noop
		step.Background.SetDesaturated = E.noop
		step.Arrow:Kill()

		hooksecurefunc(step, "SetState", function(self, state)
			if state == 2 then
				self.Background:SetVertexColor(0, 1, 0)
			elseif state == 1 then
				self.Background:SetVertexColor(1, 0, 0)
			else
				self.Background:SetVertexColor(unpack(E.media.backdropcolor))
			end
		end)
	end

	PVPQueueFrame.StepBottomFrame.StepEnd.Background:SetTexture(E.media.normTex)
	PVPQueueFrame.StepBottomFrame.StepEnd.Background.SetAtlas = E.noop
	PVPQueueFrame.StepBottomFrame.StepEnd.Background.SetDesaturated = E.noop
]]

	PVPQueueFrame.StepBottomFrame.ShadowOverlay:StripTextures()

	ConquestFrame.BottomInset:StripTextures()

	S:HandleDropDownBox(ConquestFrameBottomInsetTypeDropDown)
	ConquestFrame.BottomInset.ShadowOverlay:StripTextures()

	local function StyleButton(button, icon)
		--S:HandleButton(button)
		button:StripTextures()
		button:SetTemplate("Default", true)
		button:StyleButton()
		--button.Icon:SetDrawLayer("BACKGROUND", 2)
		--button.Icon:SetTexCoord(unpack(E.TexCoords))
		--button.Icon:SetInside()
		--button.Cover:Hide()
		button:GetHighlightTexture():SetTexture(1, 1, 1, 0.1)
		button:GetHighlightTexture():SetInside()

		--button.SelectedTexture:SetTexture(.9, .8, .1, .3)
		--button.SelectedTexture:SetInside()
		button.SelectedTexture:SetAlpha(0)

		hooksecurefunc(button.SelectedTexture, "Show", function(self, state)
			button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		end)
		hooksecurefunc(button.SelectedTexture, "Hide", function(self, state)
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end)

		if icon then
			button.Icon:ClearAllPoints()
			button.Icon:Point("LEFT", 10, 0)
			button.Icon:SetTexCoord(unpack(E.TexCoords))
			button.Icon:CreateBackdrop()
			button.Icon:SetParent(button.Icon.backdrop)
			button.Icon.backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
		end
	end

	local function StyleRewardFrame(frame)
		frame.CurrencyReward:StripTextures()
		frame.CurrencyReward:SetTemplate()
		frame.LootReward.Background:SetAlpha(0)
	end

	ConquestFrame.BottomInset.ArenaContainer:StripTextures()
	ConquestFrame.BottomInset.ArenaContainer.Header:StripTextures()
	StyleRewardFrame(ConquestFrame.BottomInset.ArenaContainer.Header.RewardFrame)

	StyleButton(ConquestFrame.BottomInset.ArenaContainer.Arena2v2)
	ConquestFrame.BottomInset.ArenaContainer.Arena2v2:Point("TOP", ConquestFrame.BottomInset.ArenaContainer.Header, "BOTTOM", 0, -6)
	StyleButton(ConquestFrame.BottomInset.ArenaContainer.Arena3v3)
	ConquestFrame.BottomInset.ArenaContainer.Arena3v3:Point("TOP", ConquestFrame.BottomInset.ArenaContainer.Arena2v2, "BOTTOM", 0, -(E.Border*2))

	ConquestFrame.BottomInset.SoloArenaContainer:StripTextures()
	ConquestFrame.BottomInset.SoloArenaContainer.Header:StripTextures()
	StyleRewardFrame(ConquestFrame.BottomInset.SoloArenaContainer.Header.RewardFrame)

	StyleButton(ConquestFrame.BottomInset.SoloArenaContainer.ArenaSolo)

	ConquestFrame.BottomInset.ArenaSkirmishContainer:StripTextures()
	ConquestFrame.BottomInset.ArenaSkirmishContainer.Header:StripTextures()
	StyleRewardFrame(ConquestFrame.BottomInset.ArenaSkirmishContainer.Header.RewardFrame)

	StyleButton(ConquestFrame.BottomInset.ArenaSkirmishContainer.ArenaSkirmish2v2)
	StyleButton(ConquestFrame.BottomInset.ArenaSkirmishContainer.ArenaSkirmish3v3)

	S:HandleButton(ConquestFrame.JoinButton, true)

	S:HandleButton(PVPHonorFrame.SoloQueueButton, true)
	S:HandleButton(PVPHonorFrame.GroupQueueButton, true)

	PVPHonorFrame.BottomInset:StripTextures()

	S:HandleDropDownBox(PVPHonorFrameBottomInsetTypeDropDown)

	PVPHonorFrame.BottomInset.BonusBattlefieldContainer:StripTextures()
	PVPHonorFrame.BottomInset.BonusBattlefieldContainer.Header:StripTextures()
	StyleRewardFrame(PVPHonorFrame.BottomInset.BonusBattlefieldContainer.Header.RewardFrame)

	StyleButton(PVPHonorFrame.BottomInset.BonusBattlefieldContainer.RandomBGButton)
	PVPHonorFrame.BottomInset.BonusBattlefieldContainer.RandomBGButton:Point("TOP", PVPHonorFrame.BottomInset.BonusBattlefieldContainer.Header, "BOTTOM", 0, 10)
	StyleButton(PVPHonorFrame.BottomInset.BonusBattlefieldContainer.CallToArmsButton)
	PVPHonorFrame.BottomInset.BonusBattlefieldContainer.CallToArmsButton:Point("TOP", PVPHonorFrame.BottomInset.BonusBattlefieldContainer.RandomBGButton, "BOTTOM", 0, -(E.Border*2))

	PVPHonorFrame.BottomInset.WorldPVPContainer:StripTextures()
	PVPHonorFrame.BottomInset.WorldPVPContainer.Header:StripTextures()
	StyleRewardFrame(PVPHonorFrame.BottomInset.WorldPVPContainer.Header.RewardFrame)

	StyleButton(PVPHonorFrame.BottomInset.WorldPVPContainer.WorldPVP2Button)

	PVPHonorFrameSpecificFrame:StripTextures()
	S:HandleScrollBar(PVPHonorFrameSpecificFrameScrollBar)

	for i = 1, #PVPHonorFrameSpecificFrame.buttons do
		local button = PVPHonorFrameSpecificFrame.buttons[i]
		button:Width(309)
		if i == 1 then
			button:SetPoint("TOPLEFT", PVPHonorFrameSpecificFrame.scrollChild, "TOPLEFT", E.Border, -E.Border)
		else
			button:SetPoint("TOPLEFT", PVPHonorFrameSpecificFrame.buttons[i-1], "BOTTOMLEFT", 0, -E.Border)
		end

		StyleButton(button, true)
	end

	PVPHonorFrameSpecificFrame.buttonHeight = PVPHonorFrameSpecificFrame.buttonHeight - 4
	PVPHonorFrameSpecificFrame.scrollChild:SetHeight(#PVPHonorFrameSpecificFrame.buttons * PVPHonorFrameSpecificFrame.buttonHeight)
	PVPHonorFrameSpecificFrame.scrollBar:SetMinMaxValues(0, #PVPHonorFrameSpecificFrame.buttons * PVPHonorFrameSpecificFrame.buttonHeight)

	PVPHonorFrame.BottomInset.ShadowOverlay:StripTextures()

	RatedBattlegroundFrameInset:StripTextures()
	RatedBattlegroundFrame.Container:StripTextures()
	PVPUIHonorLabel:StripTextures()

	RatedBattlegroundStatisticsScrollFrame:StripTextures()
	S:HandleScrollBar(RatedBattlegroundStatisticsScrollFrameScrollBar)

--[[
	for i = 1, #RatedBattlegroundStatisticsScrollFrame.buttons do
		local button = RatedBattlegroundStatisticsScrollFrame.buttons[i]
	end
]]

	S:HandleButton(RatedBattlegroundFrame.SoloQueueButton, true)
	S:HandleButton(RatedBattlegroundFrame.GroupQueueButton, true)
	S:HandleButton(RatedBattlegroundFrame.StatisticsButton, true)

	ConquestTooltip:SetTemplate("Transparent")

	PVPUI_ArenaTeamDetails:StripTextures()
	PVPUI_ArenaTeamDetails:SetTemplate("Transparent")
	PVPUI_ArenaTeamDetailsHbar:StripTextures()

	S:HandleTab(PVPUI_ArenaTeamDetailsTab1)
	S:HandleTab(PVPUI_ArenaTeamDetailsTab2)

	S:HandleCloseButton(PVPUI_ArenaTeamDetailsCloseButton)
	S:HandleDropDownBox(PVPDropDown)

	for i = 1, 5 do
		_G["PVPUI_ArenaTeamDetailsColumnHeader"..i]:StripTextures()
	end
	for i = 1, 10 do
		_G["PVPUI_ArenaTeamDetailsButton"..i]:StripTextures()
	end

	S:HandleButton(PVPUI_ArenaTeamDetailsAddTeamMember)

	BattlegroundInviteFrame:SetTemplate("Transparent")
--	BattlegroundInviteFrame.Background:SetAlpha(0)

	S:HandleButton(BattlegroundInviteFrame.PopupFrame.EnterButton)
	S:HandleButton(BattlegroundInviteFrame.PopupFrame.CancelButton)

	S:HandlePortraitFrame(PVPLadderFrame)
	S:HandleCloseButton(PVPLadderFrameCloseButton)
	PVPLadderFrame:SetTemplate("Transparent")
	PVPLadderFrame.LeftInset:StripTextures()
	PVPLadderFrame.Shadows:StripTextures()

	for i = 1, PVPLadderFrame:GetNumChildren() do
		local child = select(i, PVPLadderFrame:GetChildren())
		if child and child:GetName() and find(child:GetName(), "Art") then
			child:StripTextures()
		end
	end

	for i = 1, 3 do
		S:HandleTab(_G["PVPLadderFrameTab"..i])
	end

	for i = 1, 4 do
		local b = _G["PVPLadderFrameCategoryButton"..i]
		b.Ring:Kill()
		b.Background:Kill()
		S:HandleButton(b)
		b.Icon:Size(45)
		b.Icon:ClearAllPoints()
		b.Icon:Point("LEFT", 10, 0)
		--b.Icon:SetTexCoord(unpack(E.TexCoords))
		b.Icon:CreateBackdrop()
		b.Icon:SetParent(b.Icon.backdrop)
		b.Icon.backdrop:SetFrameLevel(b:GetFrameLevel() + 2)
	end

	for i = 1, 2 do
		local tab = PVPLadderFrame.Container["RightBigTab"..i]
		tab:SetTemplate()
		tab:StyleButton()
		tab:GetRegions():Hide()
		tab.Icon:SetTexCoord(unpack(E.TexCoords))
		tab.Icon:SetInside()
	end
	PVPLadderFrame.Container.RightBigTab1:Point("TOPLEFT", PVPLadderFrame.Container, "TOPRIGHT", -E.Border, -34)
	for i = 1, 10 do
		local tab = PVPLadderFrame.Container["RightSmallTab"..i]
		tab:SetTemplate()
		tab:StyleButton()
		tab:GetRegions():Hide()
		tab.Icon:SetTexCoord(unpack(E.TexCoords))
		tab.Icon:SetInside()
	end
	PVPLadderFrame.Container.RightSmallTab1:Point("TOPLEFT", PVPLadderFrame.Container, "TOPRIGHT", -E.Border, -130)

	PVPLadderFrame.Container.RightContainer.BottomContainer:StripTextures()

	PVPLadderFrame.Container.RightContainer.CentralContainer:StripTextures(true)

	S:HandleScrollBar(PVPLadderFrameRightContainerCentralContainerScrollFrameScrollBar)
	local up = PVPLadderFrameRightContainerCentralContainerScrollFrameScrollBarScrollUpButton
	local upNormal, upDisabled, upPushed = up:GetNormalTexture(), up:GetDisabledTexture(), up:GetPushedTexture()
	upNormal:SetRotation(S.ArrowRotation.up)
	upPushed:SetRotation(S.ArrowRotation.up)
	upDisabled:SetRotation(S.ArrowRotation.up)
	local down = PVPLadderFrameRightContainerCentralContainerScrollFrameScrollBarScrollDownButton
	local downNormal, downDisabled, downPushed = down:GetNormalTexture(), down:GetDisabledTexture(), down:GetPushedTexture()
	downNormal:SetRotation(S.ArrowRotation.down)
	downPushed:SetRotation(S.ArrowRotation.down)
	downDisabled:SetRotation(S.ArrowRotation.down)

	PVPLadderFrame.Container.RightContainer.CentralContainer.ScrollFrame.ShadowOverlay:StripTextures()

	PVPLadderFrame.Container.RightContainer.TopContainer:StripTextures()
	PVPLadderFrame.Container.RightContainer.TopContainer.RegionMask.TextureMask:StripTextures()

	S:HandleEditBox(PVPLadderFrame.Container.RightContainer.TopContainer.SearchBox)
	S:HandleButton(PVPLadderFrame.Container.RightContainer.TopContainer.SearchButton)

	PVPLadderFrame.Container.RightContainer.TopContainer.ShadowOverlay:StripTextures()

	S:HandlePortraitFrame(PVPLadderInfoFrame)
	PVPLadderInfoFrame.CentralContainer:StripTextures()
	PVPLadderInfoFrame.CentralContainer.BackgroundOverlay:SetAlpha(0)
	S:HandleScrollBar(PVPLadderInfoFrame.CentralContainer.ScrollFrame.ScrollBar)
	PVPLadderInfoFrame.CentralContainer.ScrollFrame.ShadowOverlay:StripTextures()
	PVPLadderInfoFrame.TopContainer.ShadowOverlay:StripTextures()
	PVPLadderInfoFrame.TopContainer.StatisticsFrame:StripTextures()
end

S:RemoveCallback("LFD")
S:AddCallback("LFD", LoadSkin)