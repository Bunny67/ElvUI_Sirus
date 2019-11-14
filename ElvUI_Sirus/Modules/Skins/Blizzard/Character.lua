local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local find = string.find
--WoW API / Variables

local function ColorizeStatPane(frame)
	if frame.leftGrad then return end

	local r, g, b = 0.8, 0.8, 0.8
	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:Width(frame:GetWidth() * .5)
	frame.leftGrad:Height(frame:GetHeight())
	frame.leftGrad:Point("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradientAlpha("Horizontal", r, g, b, 0.35, r, g, b, 0)

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:Width(frame:GetWidth() * .5)
	frame.rightGrad:Height(frame:GetHeight())
	frame.rightGrad:Point("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.Media.Textures.White8x8)
	frame.rightGrad:SetGradientAlpha("Horizontal", r, g, b, 0, r, g, b, 0.35)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true then return; end

	S:HandlePortraitFrame(CharacterFrame)

	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tab = _G["CharacterFrameTab"..i]
		S:HandleTab(tab)
	end

	GearManagerDialog:StripTextures()
	GearManagerDialog:CreateBackdrop("Transparent")
	GearManagerDialog.backdrop:Point("TOPLEFT", 5, -2)
	GearManagerDialog.backdrop:Point("BOTTOMRIGHT", -1, 4)

	S:HandleCloseButton(GearManagerDialogClose)

	for i = 1, 10 do
		_G["GearSetButton"..i]:StripTextures()
		_G["GearSetButton"..i]:StyleButton()
		_G["GearSetButton"..i]:CreateBackdrop("Default")
		_G["GearSetButton"..i].backdrop:SetAllPoints()
		_G["GearSetButton"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords))
		_G["GearSetButton"..i.."Icon"]:SetInside()
	end

	S:HandleButton(GearManagerDialogDeleteSet)
	S:HandleButton(GearManagerDialogEquipSet)
	S:HandleButton(GearManagerDialogSaveSet)

	PaperDollFrameItemFlyoutHighlight:Kill()
	local function SkinItemFlyouts(button)
		if not button.isSkinned then
			button.icon = _G[button:GetName().."IconTexture"]

			button:GetNormalTexture():SetTexture(nil)
			button:SetTemplate("Default")
			button:StyleButton(false)

			button.icon:SetInside()
			button.icon:SetTexCoord(unpack(E.TexCoords))
		end

		local cooldown = _G[button:GetName() .."Cooldown"]
		if cooldown then
			E:RegisterCooldown(cooldown)
		end

		local location = button.location
		if not location then return end
		if location >= PDFITEMFLYOUT_FIRST_SPECIAL_LOCATION then return end

		local id = EquipmentManager_GetItemInfoByLocation(location)
		local _, _, quality = GetItemInfo(id)
		local r, g, b = GetItemQualityColor(quality)

		button:SetBackdropBorderColor(r, g, b)
	end
	hooksecurefunc("PaperDollFrameItemFlyout_DisplayButton", SkinItemFlyouts)

	GearManagerDialogPopup:StripTextures()
	GearManagerDialogPopup:CreateBackdrop("Transparent")
	GearManagerDialogPopup.backdrop:Point("TOPLEFT", 5, -2)
	GearManagerDialogPopup.backdrop:Point("BOTTOMRIGHT", -4, 8)

	S:HandleEditBox(GearManagerDialogPopupEditBox)

	GearManagerDialogPopupScrollFrame:StripTextures()
	S:HandleScrollBar(GearManagerDialogPopupScrollFrameScrollBar)

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local button = _G["GearManagerDialogPopupButton"..i]
		local icon = button.icon

		if button then
			button:StripTextures()
			button:StyleButton(true)

			icon:SetTexCoord(unpack(E.TexCoords))
			_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)

			icon:SetInside()
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBackdrop("Default")
				button.backdrop:SetAllPoints()
			end
		end
	end

	S:HandleButton(GearManagerDialogPopupOkay)
	S:HandleButton(GearManagerDialogPopupCancel)

	PaperDollFrame:StripTextures(true)

	PaperDollFrame.NewPanel:StripTextures()
	ColorizeStatPane(PaperDollFrameStrengthenFrame.StrengthenTittle)
	PaperDollFrameStrengthenFrame.StrengthenTittle.tittleBackground:SetAlpha(0)

	PaperDollSidebarTabs:StripTextures()
	PaperDollFrame.StatsInset:StripTextures()
	PaperDollFrame.EquipInset:StripTextures()
	CharacterModelFrame:CreateBackdrop()
	CharacterModelFrame.backdrop:SetOutside(CharacterModelFrameBackgroundOverlay)
	CharacterModelFrame:DisableDrawLayer("OVERLAY")

	S:HandleControlFrame(CharacterModelFrame.controlFrame)

	ColorizeStatPane(CharacterItemLevelFrame)
	CharacterItemLevelFrame.ilvlbackground:SetAlpha(0)

	PlayerTitleFrame:StripTextures()
	PlayerTitleFrame:CreateBackdrop("Default")
	PlayerTitleFrame.backdrop:Point("TOPLEFT", 20, 3)
	PlayerTitleFrame.backdrop:Point("BOTTOMRIGHT", -16, 14)
	PlayerTitleFrame.backdrop:SetFrameLevel(PlayerTitleFrame:GetFrameLevel())
	S:HandleNextPrevButton(PlayerTitleFrameButton)
	PlayerTitleFrameButton:ClearAllPoints()
	PlayerTitleFrameButton:Point("RIGHT", PlayerTitleFrame.backdrop, "RIGHT", -2, 0)

	PlayerTitlePickerFrame:StripTextures()
	PlayerTitlePickerFrame:CreateBackdrop("Transparent")
	PlayerTitlePickerFrame.backdrop:Point("TOPLEFT", 6, -10)
	PlayerTitlePickerFrame.backdrop:Point("BOTTOMRIGHT", -10, 6)
	PlayerTitlePickerFrame.backdrop:SetFrameLevel(PlayerTitlePickerFrame:GetFrameLevel())

	for i = 1, #PlayerTitlePickerScrollFrame.buttons do
		PlayerTitlePickerScrollFrame.buttons[i].text:FontTemplate()
	end

	S:HandleScrollBar(PlayerTitlePickerScrollFrameScrollBar)

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]
		if tab then
			tab:CreateBackdrop()
			tab.Icon:SetAllPoints()
			tab.Highlights:SetTexture(1, 1, 1, .3)
			tab.Highlights:SetAllPoints()
			tab.TabBg:Kill()
		end
	end

	_G["GearManagerToggleButton"]:Size(26, 32)
	_G["GearManagerToggleButton"]:CreateBackdrop("Default")

	GearManagerToggleButton:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.125, 0.90625)
	GearManagerToggleButton:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.125, 0.90625)
	GearManagerToggleButton:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	GearManagerToggleButton:GetHighlightTexture():SetAllPoints()

	local popoutButtonOnEnter = function(btn) btn.icon:SetVertexColor(unpack(E.media.rgbvaluecolor)) end
	local popoutButtonOnLeave = function(btn) btn.icon:SetVertexColor(1, 1, 1) end

	local slots = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
		"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
		"MainHandSlot", "SecondaryHandSlot", "RangedSlot", "AmmoSlot"
	}

	for _, slot in pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local cooldown = _G["Character"..slot.."Cooldown"]
		local popout = _G["Character"..slot.."PopoutButton"]

		slot = _G["Character"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot:SetTemplate("Default", true, true)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		slot:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 2)

		if cooldown then
			E:RegisterCooldown(cooldown)
		end

		if popout then
			popout:StripTextures()
			popout:HookScript("OnEnter", popoutButtonOnEnter)
			popout:HookScript("OnLeave", popoutButtonOnLeave)

			popout.icon = popout:CreateTexture(nil, "ARTWORK")
			popout.icon:Size(24)
			popout.icon:Point("CENTER")
			popout.icon:SetTexture(E.Media.Textures.ArrowUp)

			if slot.verticalFlyout then
				popout.icon:SetRotation(S.ArrowRotation.down)
				popout.icon:SetRotation(S.ArrowRotation.down)
				popout.icon:SetRotation(S.ArrowRotation.down)
			else
				popout.icon:SetRotation(S.ArrowRotation.right)
				popout.icon:SetRotation(S.ArrowRotation.right)
				popout.icon:SetRotation(S.ArrowRotation.right)
			end
		end
	end

	hooksecurefunc("PaperDollFrameItemFlyout_Show", function()
		PaperDollFrameItemFlyoutButtons:StripTextures()
	end)

	hooksecurefunc("PaperDollFrameItemPopoutButton_SetReversed", function(self, isReversed)
		if self:GetParent().verticalFlyout then
			if isReversed then
				self.icon:SetRotation(S.ArrowRotation.up)
				self.icon:SetRotation(S.ArrowRotation.up)
				self.icon:SetRotation(S.ArrowRotation.up)
			else
				self.icon:SetRotation(S.ArrowRotation.down)
				self.icon:SetRotation(S.ArrowRotation.down)
				self.icon:SetRotation(S.ArrowRotation.down)
			end
		else
			if isReversed then
				self.icon:SetRotation(S.ArrowRotation.left)
				self.icon:SetRotation(S.ArrowRotation.left)
				self.icon:SetRotation(S.ArrowRotation.left)
			else
				self.icon:SetRotation(S.ArrowRotation.right)
				self.icon:SetRotation(S.ArrowRotation.right)
				self.icon:SetRotation(S.ArrowRotation.right)
			end
		end
	end)

	local function ColorItemBorder()
		for _, slot in pairs(slots) do
			local target = _G["Character"..slot]
			local slotId = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID("player", slotId)

			if itemId then
				local rarity = GetInventoryItemQuality("player", slotId)
				if rarity then
					target:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				target:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
	CharacterFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()

	local function HandleResistanceFrame(frameName)
		for i = 1, 5 do
			local frame = _G[frameName..i]
			frame:Size(24)
			frame:SetTemplate("Default")

			if i ~= 1 then
				frame:ClearAllPoints()
				frame:Point("TOP", _G[frameName..i-1], "BOTTOM", 0, -(E.Border + E.Spacing))
			end

			select(1, _G[frameName..i]:GetRegions()):SetInside()
			select(1, _G[frameName..i]:GetRegions()):SetDrawLayer("ARTWORK")
			select(2, _G[frameName..i]:GetRegions()):SetDrawLayer("OVERLAY")
		end
	end

	HandleResistanceFrame("MagicResFrame")

	select(1, MagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875) --Arcane
	select(1, MagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625) --Fire
	select(1, MagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375) --Nature
	select(1, MagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375) --Frost
	select(1, MagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125) --Shadow

	S:HandleDropDownBox(PlayerStatFrameLeftDropDown, 140, "down")
	S:HandleDropDownBox(PlayerStatFrameRightDropDown, 140, "down")
	CharacterAttributesFrame:StripTextures()

	PetPaperDollFrame:StripTextures(true)

	S:HandleRotateButton(PetModelFrameRotateLeftButton)
	S:HandleRotateButton(PetModelFrameRotateRightButton)
	PetModelFrameRotateRightButton:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	HandleResistanceFrame("PetMagicResFrame")

	select(1, PetMagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875) --Arcane
	select(1, PetMagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625) --Fire
	select(1, PetMagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375) --Nature
	select(1, PetMagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375) --Frost
	select(1, PetMagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125) --Shadow

	PetAttributesFrame:StripTextures()

	PetPaperDollFrameExpBar:StripTextures()
	PetPaperDollFrameExpBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(PetPaperDollFrameExpBar)
	PetPaperDollFrameExpBar:CreateBackdrop("Default")

	local function updHappiness(self)
		local happiness = GetPetHappiness()
		local _, isHunterPet = HasPetUI()
		if not happiness or not isHunterPet then return end

		local texture = self:GetRegions()
		if happiness == 1 then
			texture:SetTexCoord(0.41, 0.53, 0.06, 0.30)
		elseif happiness == 2 then
			texture:SetTexCoord(0.22, 0.345, 0.06, 0.30)
		elseif happiness == 3 then
			texture:SetTexCoord(0.04, 0.15, 0.06, 0.30)
		end
	end

	PetPaperDollPetInfo:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "BOTTOMLEFT", 9, -3)
	PetPaperDollPetInfo:GetRegions():SetTexCoord(0.04, 0.15, 0.06, 0.30)
	PetPaperDollPetInfo:SetFrameLevel(PetModelFrame:GetFrameLevel() + 2)
	PetPaperDollPetInfo:CreateBackdrop("Default")
	PetPaperDollPetInfo:Size(24, 24)
	updHappiness(PetPaperDollPetInfo)

	PetPaperDollPetInfo:RegisterEvent("UNIT_HAPPINESS")
	PetPaperDollPetInfo:SetScript("OnEvent", updHappiness)
	PetPaperDollPetInfo:SetScript("OnShow", updHappiness)

	PetPaperDollFrameCompanionFrame:StripTextures()

	S:HandleRotateButton(CompanionModelFrameRotateLeftButton)
	S:HandleRotateButton(CompanionModelFrameRotateRightButton)
	CompanionModelFrameRotateRightButton:SetPoint("TOPLEFT", CompanionModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	S:HandleButton(CompanionSummonButton)

--[[
	hooksecurefunc("PetPaperDollFrame_UpdateCompanions", function()
		local Button, IconNormal, IconDisabled, ActiveTexture

		for i = 1, NUM_COMPANIONS_PER_PAGE do
			Button = _G["CompanionButton"..i]
			IconNormal = Button:GetNormalTexture()
			IconDisabled = Button:GetDisabledTexture()
			ActiveTexture = _G["CompanionButton"..i.."ActiveTexture"]

			Button:StyleButton(nil, true)
			Button:SetTemplate("Default", true)

			if IconNormal then
				IconNormal:SetTexCoord(unpack(E.TexCoords))
				IconNormal:SetInside()
			end

			IconDisabled:SetTexture(nil)

			ActiveTexture:SetInside(Button)
			ActiveTexture:SetTexture(1, 1, 1, .15)
		end
	end)
]]

	S:HandleNextPrevButton(CompanionPrevPageButton)
	S:HandleNextPrevButton(CompanionNextPageButton)

	ReputationFrame:StripTextures(true)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

		factionRow:StripTextures(true)

		factionBar:StripTextures()
		factionBar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(factionBar)
		factionBar:CreateBackdrop("Default")

		factionButton:SetNormalTexture(E.Media.Textures.Minus)
		factionButton.SetNormalTexture = E.noop
		factionButton:GetNormalTexture():Size(15)
		factionButton:SetHighlightTexture(nil)
	end

	local function UpdateFaction()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		local factionIndex, factionRow, factionButton
		local numFactions = GetNumFactions()
		for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
			factionRow = _G["ReputationBar"..i]
			factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			factionIndex = factionOffset + i
			if factionIndex <= numFactions then
				if factionRow.isCollapsed then
					factionButton:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
				else
					factionButton:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
				end
			end
		end
	end
	hooksecurefunc("ReputationFrame_Update", UpdateFaction)

	ReputationListScrollFrame:StripTextures()
	S:HandleScrollBar(ReputationListScrollFrameScrollBar)

	ReputationDetailFrame:StripTextures()
	ReputationDetailFrame:SetTemplate("Transparent")
	ReputationDetailFrame.TextContainer:StripTextures()
	ReputationDetailFrame.TextContainer.ShadowOverlay:StripTextures()

	S:HandleCloseButton(ReputationDetailCloseButton)
	ReputationDetailCloseButton:Point("TOPRIGHT", 3, 4)

	S:HandleCheckBox(ReputationDetailAtWarCheckBox)
	ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	S:HandleCheckBox(ReputationDetailInactiveCheckBox)
	S:HandleCheckBox(ReputationDetailMainScreenCheckBox)

	SkillFrame:StripTextures(true)

	S:HandleNextPrevButton(SkillDetailStatusBarUnlearnButton)
	--S:SquareButton_SetIcon(SkillDetailStatusBarUnlearnButton, "DELETE")
	SkillDetailStatusBarUnlearnButton:Size(24)
	SkillDetailStatusBarUnlearnButton:Point("LEFT", SkillDetailStatusBarBorder, "RIGHT", 5, 0)
	SkillDetailStatusBarUnlearnButton:SetHitRectInsets(0, 0, 0, 0)

	SkillFrameExpandButtonFrame:StripTextures()

	SkillFrameCollapseAllButton:SetNormalTexture(E.Media.Textures.Plus)
	SkillFrameCollapseAllButton.SetNormalTexture = E.noop
	SkillFrameCollapseAllButton:GetNormalTexture():Size(16)
	SkillFrameCollapseAllButton:Point("LEFT", SkillFrameExpandTabLeft, "RIGHT", -40, -3)
	SkillFrameCollapseAllButton:SetHighlightTexture(nil)

	hooksecurefunc(SkillFrameCollapseAllButton, "SetNormalTexture", function(_, texture)
		if find(texture, "MinusButton") then
			SkillFrameCollapseAllButton:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
		else
			SkillFrameCollapseAllButton:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
		end
	end)

	for i = 1, SKILLS_TO_DISPLAY do
		local statusBar = _G["SkillRankFrame"..i]
		local statusBarBorder = _G["SkillRankFrame"..i.."Border"]
		local statusBarBackground = _G["SkillRankFrame"..i.."Background"]

		statusBar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(statusBar)
		statusBar:CreateBackdrop("Default")

		statusBarBorder:StripTextures()
		statusBarBackground:SetTexture(nil)

		local skillTypeLabelText = _G["SkillTypeLabel"..i]
		skillTypeLabelText:SetNormalTexture(E.Media.Textures.Plus)
		skillTypeLabelText.SetNormalTexture = E.noop
		skillTypeLabelText:GetNormalTexture():Size(16)
		skillTypeLabelText:SetHighlightTexture(nil)

		hooksecurefunc(skillTypeLabelText, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
			else
				self:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
			end
		end)
	end

	SkillDetailStatusBar:StripTextures()
	SkillDetailStatusBar:SetParent(SkillDetailScrollFrame)
	SkillDetailStatusBar:CreateBackdrop("Default")
	SkillDetailStatusBar:SetStatusBarTexture(E.media.normTex)
	SkillDetailStatusBar:SetParent(SkillDetailScrollFrame)
	E:RegisterStatusBar(SkillDetailStatusBar)

	SkillListScrollFrame:StripTextures()
	S:HandleScrollBar(SkillListScrollFrameScrollBar)

	SkillDetailScrollFrame:StripTextures()
	S:HandleScrollBar(SkillDetailScrollFrameScrollBar)

	TokenFrame:StripTextures(true)

	hooksecurefunc("TokenFrame_Update", function()
		local scrollFrame = TokenFrameContainer
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local numButtons = #buttons
		local _, name, isHeader, isExpanded, extraCurrencyType, icon
		local button, index

		for i = 1, numButtons do
			index = offset+i
			name, isHeader, isExpanded, _, _, _, extraCurrencyType, icon = GetCurrencyListInfo(index)
			button = buttons[i]

			if not button.isSkinned then
				button.categoryLeft:Kill()
				button.categoryRight:Kill()
				button.highlight:Kill()

				button.expandIcon:SetTexture(E.Media.Textures.Plus)
				button.expandIcon:SetTexCoord(0, 1, 0, 1)
				button.expandIcon:Size(16)

				button.isSkinned = true
			end

			if name or name == "" then
				if isHeader then
					if isExpanded then
						button.expandIcon:SetTexture(E.Media.Textures.Minus)
					else
						button.expandIcon:SetTexture(E.Media.Textures.Plus)
					end
					button.expandIcon:SetTexCoord(0, 1, 0, 1)
				else
					if extraCurrencyType == 1 then
						button.icon:SetTexCoord(unpack(E.TexCoords))
					elseif extraCurrencyType == 2 then
						local factionGroup = UnitFactionGroup("player")
						if factionGroup then
							button.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)
							button.icon:SetTexCoord(0.03125, 0.59375, 0.03125, 0.59375)
						else
							button.icon:SetTexCoord(unpack(E.TexCoords))
						end
					else
						button.icon:SetTexture(icon)
						button.icon:SetTexCoord(unpack(E.TexCoords))
					end
				end
			end
		end
	end)

	S:HandleScrollBar(TokenFrameContainerScrollBar)

	TokenFramePopup:StripTextures()
	TokenFramePopup:SetTemplate("Transparent")

	S:HandleCloseButton(TokenFramePopupCloseButton)

	S:HandleCheckBox(TokenFramePopupInactiveCheckBox)
	S:HandleCheckBox(TokenFramePopupBackpackCheckBox)
end

S:RemoveCallback("Skin_Character")
S:AddCallback("Skin_Character", LoadSkin)