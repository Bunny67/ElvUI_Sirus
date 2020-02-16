local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.store ~= true then return end

	local goldBorderList = {
		"TopLeft",
		"TopRight",
		"BottomLeft",
		"BottomRight",
		"Top",
		"Left",
		"Right",
		"Bottom",
	}

	local function RemoveGoldBorder(frame)
		for _, parentKey in pairs(goldBorderList) do
			local region = frame[parentKey]
			if region then
				region:Hide()
			end
		end
	end

	StoreFrame:SetParent(UIParent)
	StoreFrame:SetScale(1)

	StoreFrame:StripTextures()
	StoreFrame:SetTemplate("Transparent")
	StoreFrame:SetFrameStrata("DIALOG")

	StoreFrameLeftInset:StripTextures()
	StoreFrameLeftInset:SetTemplate("Transparent")

	StoreFrameRightInset:StripTextures()
	StoreFrameRightInset:SetTemplate("Transparent")

	StoreFrameTopInset:StripTextures()
	--StoreFrameTopInset:SetTemplate("Transparent")

	S:HandleCloseButton(StoreFrameCloseButton)

	--StoreSpecialOfferFrame
	StoreSpecialOfferTopFrame:StripTextures()
	StoreSpecialOfferBanner:SetTemplate()
	S:HandleButton(StoreSpecialOfferBanner.LeftPanel.BuyButton)

	for _, frame in pairs(SpecialOfferCustomBanners) do
		frame = _G[frame]
		if frame and frame.BuyButton then
			S:HandleButton(frame.BuyButton)
		end
	end

	S:HandleNextPrevButton(StoreSpecialOfferBanner.NavigationBar.PrevPageButton, nil, nil, true)
	StoreSpecialOfferBanner.NavigationBar.PrevPageButton:Size(32)
	S:HandleNextPrevButton(StoreSpecialOfferBanner.NavigationBar.NextPageButton, nil, nil, true)
	StoreSpecialOfferBanner.NavigationBar.NextPageButton:Size(32)

	StoreSpecialOfferBottomFrame:StripTextures()

--	for i = 1, 4 do
--		local button = _G["StoreSpecialOfferCardButton"..i]
--		if button then
--
--		end
--	end

	-- StoreItemCardFrame
	S:HandleNextPrevButton(StoreItemCardFrameNavigationBarPrevPageButton, nil, nil, true)
	StoreItemCardFrameNavigationBarPrevPageButton:Size(32)
	S:HandleNextPrevButton(StoreItemCardFrameNavigationBarNextPageButton, nil, nil, true)
	StoreItemCardFrameNavigationBarNextPageButton:Size(32)

	S:HandleButton(StoreRefreshMountListButton)

	-- StoreModelPreviewFrame
	StoreModelPreviewFrame:StripTextures()
	StoreModelPreviewFrame.Inset:StripTextures()
	StoreModelPreviewFrame:SetTemplate("Transparent")

	StoreModelPreviewFrame.Display:StripTextures()
	StoreModelPreviewFrame.Display.ShadowOverlay:SetAlpha(0)
	StoreModelPreviewFrame.Display:SetTemplate()

	S:HandleRotateButton(StorePreviewModelFrameRotateLeftButton)
	S:HandleRotateButton(StorePreviewModelFrameRotateRightButton)
	StorePreviewModelFrameRotateRightButton:SetPoint("TOPLEFT", StorePreviewModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	S:HandleCloseButton(StoreModelPreviewFrameCloseButton) -- WTF?
	S:HandleButton(StoreModelPreviewFrame.CloseButton, true) -- WTF?

	--StoreConfirmationFrame
	RemoveGoldBorder(StoreConfirmationFrame)
	S:HandleCloseButton(StoreConfirmationFrame.CloseButton)

	S:HandleIcon(StoreConfirmationFrame.Art.Icon)
	StoreConfirmationFrame.Art.IconBorder:SetAlpha(0)
	StoreConfirmationFrame.Art.backdrop:SetFrameLevel(StoreConfirmationFrame.Art:GetFrameLevel() + 5)
	StoreConfirmationFrame.Art.Icon:SetDrawLayer("OVERLAY")

	S:HandleCheckBox(StoreConfirmationSendGiftCheckButton)
	StoreConfirmationSendGiftCheckButton.Text:Point("LEFT", StoreConfirmationSendGiftCheckButton, "RIGHT", -2, 0)

	StoreConfirmationGiftFrameCharacterName:Height(18)
	S:HandleEditBox(StoreConfirmationGiftFrameCharacterName)
	StoreConfirmationGiftFrame.CharacterName.Left:SetAlpha(0)
	StoreConfirmationGiftFrame.CharacterName.Right:SetAlpha(0)
	StoreConfirmationGiftFrame.CharacterName.Middle:SetAlpha(0)
	select(10, StoreConfirmationGiftFrame.CharacterName:GetRegions()):SetAlpha(0)

	S:HandleDropDownBox(StoreConfirmationGiftFrameSelectedStyleDropDown)

	StoreConfirmationGiftFrame.MessageFrame:StripTextures()
	StoreConfirmationGiftFrame.MessageFrame:CreateBackdrop()

	StoreConfirmationFrame:CreateBackdrop("Transparent")
	StoreConfirmationFrame.backdrop:SetOutside(StoreConfirmationFrame.ParchmentTop, nil, nil, StoreConfirmationFrame.BlueGlow)

	S:HandleButton(StoreConfirmationFrame.BuyButton)
	S:HandleButton(StoreConfirmationFrame.BackButton)

	StoreConfirmationFrame:HookScript("OnShow", function(self)
		SetPortraitToTexture(self.Art.Icon, "")
		self.Art.Icon:SetTexture(self.data.Texture)
	end)

	-- StoreErrorFrame
	RemoveGoldBorder(StoreErrorFrame)
	StoreErrorFrame:CreateBackdrop("Transparent")
	StoreErrorFrame.backdrop:SetOutside(StoreErrorFrame.ParchmentMiddle)

	S:HandleButton(StoreErrorFrame.AcceptButton)

	-- StoreBuyPremiumFrame
	RemoveGoldBorder(StoreBuyPremiumFrame)
	S:HandleCloseButton(StoreBuyPremiumFrame.CloseButton)

	StoreBuyPremiumFrame:CreateBackdrop("Transparent")
	StoreBuyPremiumFrame.backdrop:SetOutside(StoreBuyPremiumFrame.ParchmentTop, nil, nil, StoreBuyPremiumFrame.BlueGlow)

	for i = 1, 4 do
		local button = _G["SelectPremiumButton"..i]
		if button then
			button:Size(24)
			button:SetFrameLevel(StoreBuyPremiumFrame:GetFrameLevel() + 5)
			S:HandleCheckBox(button)
		end
	end

	S:HandleButton(StoreBuyPremiumFrame.BuyButton)

	-- StoreSubscribeFrame
	StoreSubscribeContainer.HeaderBackground:SetAlpha(0)
	StoreSubscribeContainer.BackgroundColor:SetAlpha(0)
	StoreSubscribeContainer.HeaderBackgroundAlpha:SetAlpha(0)
	StoreSubscribeContainer.HeaderText:SetTextColor(1, 1, 1)

	local function StoreSubscribeItemTemplate(button)
		button:SetTemplate()
		button:StyleButton()

		button.iconTexture:SetDrawLayer("BORDER")
		button.iconTexture:SetTexCoord(unpack(E.TexCoords))
		button.iconTexture:SetInside()

		button.slotFrameCollected:Kill()
		button.glow:Kill()
		button.glow2:Kill()
		button.CountBackground:Kill()
		button.count:FontTemplate(nil, nil, "OUTLINE")
		button.count:ClearAllPoints()
		button.count:SetPoint("BOTTOMRIGHT", button, 5, 0)
	end

	for i = 1, 3 do
		local button = _G["StoreSubscribeItemButton"..i]
		StoreSubscribeItemTemplate(button)
	end

	StoreSubscribeItemTemplate(StoreSubscribeSubItemButton1)

	hooksecurefunc("StoreSubscribeSetup", function()
		for i = 1, 3 do
			local button = _G["StoreSubscribeItemButton"..i]
			if button and button.Link then
				local _, _, quality = GetItemInfo(button.Link)

				if quality then
					button:SetBackdropBorderColor(GetItemQualityColor(quality))
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end
		end
		
		local subItemButton = StoreSubscribeSubItemButton1
		if subItemButton and subItemButton.Link then
			local _, _, quality = GetItemInfo(subItemButton.Link)

			if quality then
				subItemButton:SetBackdropBorderColor(GetItemQualityColor(quality))
			else
				subItemButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end)

	S:HandleButton(StoreSubscribeContainer.BuyButton1)
	S:HandleButton(StoreSubscribeContainer.BuyButton2)
	S:HandleButton(StoreSubscribeContainer.BuyButton3)

	hooksecurefunc("StoreFrame_UpdateCategories", function(self)
		for i, button in pairs(self.CategoryFrames) do
			if not button.isElvUI then
				button:SetTemplate()
				button:StyleButton()

				button.SelectedTexture:SetTexture(.9, .8, .1, .3)
				button.SelectedTexture:SetInside()
				button.HighlightTexture:SetTexture(1, 1, 1, .3)
				button.HighlightTexture:SetInside()
				button.ColoredTexture:SetTexture(.9, .1, .1, .3)
				button.ColoredTexture:SetInside()

				button.Category:Hide()
				button.PulseTexture:Hide()
				button.NewItems:Hide()

				button.Icon:Point("LEFT", 7, 0)
				button.Icon:Size(24)
				S:HandleIcon(button.Icon)
				button.backdrop:SetFrameLevel(button:GetFrameLevel() + 1)
				button.Icon:SetTexCoord(0.38, 0.60, 0.38, 0.60)

				if i == 1 then
					button:Point("TOP", 0, -9)
				else
					button:Point("TOPLEFT", self.CategoryFrames[i - 1], "BOTTOMLEFT", 0, -3)
				end

				button.isElvUI = true
			end
		end
	end)
end

S:AddCallback("Sirus_Store", LoadSkin)