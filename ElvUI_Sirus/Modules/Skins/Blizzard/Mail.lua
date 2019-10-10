local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack, select = unpack, select
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
local GetInboxHeaderInfo = GetInboxHeaderInfo
local GetInboxItemLink = GetInboxItemLink
local GetItemInfo = GetItemInfo
local GetSendMailItem = GetSendMailItem
local GetItemQualityColor = GetItemQualityColor
local INBOXITEMS_TO_DISPLAY = INBOXITEMS_TO_DISPLAY
local ATTACHMENTS_MAX_SEND = ATTACHMENTS_MAX_SEND
local ATTACHMENTS_MAX_RECEIVE = ATTACHMENTS_MAX_RECEIVE

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mail ~= true then return end

	-- Inbox Frame
	S:HandlePortraitFrame(MailFrame)
	MailFrame.Inset:StripTextures()
	MailFrame.NineSlice:StripTextures()

	MailFrame:EnableMouseWheel(true)
	MailFrame:SetScript("OnMouseWheel", function(_, value)
		if value > 0 then
			if InboxPrevPageButton:IsEnabled() == 1 then
				InboxPrevPage()
			end
		else
			if InboxNextPageButton:IsEnabled() == 1 then
				InboxNextPage()
			end
		end
	end)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local mail = _G["MailItem"..i]
		local button = _G["MailItem"..i.."Button"]
		local icon = _G["MailItem"..i.."ButtonIcon"]

		mail:StripTextures(true)
		mail:CreateBackdrop("Default")
		--mail.backdrop:Point("TOPLEFT", 2, 1)
		--mail.backdrop:Point("BOTTOMRIGHT", -2, 2)

		button:StripTextures()
		button:SetTemplate("Default", true)
		button:StyleButton()

		icon:SetDrawLayer("BORDER")
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end

	InboxFrame.WaitFrame:StripTextures()
	InboxFrame.LeftContainer:StripTextures()
	InboxFrame.LeftContainer.ClassLogo:Kill()
	InboxFrame.LeftContainer.ShadowOverlay:StripTextures()
--	InboxFrame.LeftContainer.ShadowOverlay:SetTemplate("Transparent")
	S:HandleButton(OpenAllMailButton)
	S:HandleNextPrevButton(AdditionalMailFunctionalButton)
	AdditionalMailFunctionalButton:Size(28)
	AdditionalMailFunctionalButton:Point("LEFT", OpenAllMailButton, "RIGHT", 4, 0)

	InboxFrame.RightContainer:StripTextures()
	InboxFrame.RightContainer.FactionLogo:Kill()
	InboxFrame.RightContainer.ShadowOverlay:StripTextures()
--	InboxFrame.RightContainer.ShadowOverlay:SetTemplate("Transparent")
	S:HandleButton(UpdateMailButton)

	InboxTooMuchMail:StripTextures()

	hooksecurefunc("InboxFrame_Update", function()
		local numItems = GetInboxNumItems()
		local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1

		for i = 1, INBOXITEMS_TO_DISPLAY do
			if index <= numItems then
				local packageIcon, _, _, _, _, _, _, _, _, _, _, _, isGM = GetInboxHeaderInfo(index)
				local button = _G["MailItem"..i.."Button"]

				button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				if packageIcon and not isGM then
					local ItemLink = GetInboxItemLink(index, 1)

					if ItemLink then
						local quality = select(3, GetItemInfo(ItemLink))

						if quality then
							button:SetBackdropBorderColor(GetItemQualityColor(quality))
						else
							button:SetBackdropBorderColor(unpack(E.media.bordercolor))
						end
					end
				elseif isGM then
					button:SetBackdropBorderColor(0, 0.56, 0.94)
				end
			end

			index = index + 1
		end
	end)

	S:HandleNextPrevButton(InboxPrevPageButton, nil, nil, true)
	InboxPrevPageButton:Size(28)
	InboxPrevPageButton:Point("BOTTOMLEFT", 8, 8)
	S:HandleNextPrevButton(InboxNextPageButton, nil, nil, true)
	InboxNextPageButton:Size(28)
	InboxNextPageButton:Point("BOTTOMRIGHT", -8, 8)

	for i = 1, 2 do
		local tab = _G["MailFrameTab"..i]

		tab:StripTextures()
		S:HandleTab(tab)
	end

	-- Send Mail Frame
	SendMailFrame.Content:StripTextures()

	SendMailScrollFrame:StripTextures(true)
	SendMailScrollFrame:SetTemplate("Default")

	SendMailMoneyInset:StripTextures()
	SendMailMoneyBg:StripTextures()

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			local texture = button:GetNormalTexture()
			local itemName = GetSendMailItem(i)

			if not button.skinned then
				button:StripTextures()
				button:SetTemplate("Default", true)
				button:StyleButton(nil, true)

				button.skinned = true
			end

			if itemName then
				local quality = select(3, GetItemInfo(itemName))

				if quality then
					button:SetBackdropBorderColor(GetItemQualityColor(quality))
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end

				texture:SetTexCoord(unpack(E.TexCoords))
				texture:SetInside()
			else
				button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end)

	SendMailBodyEditBox:SetTextColor(1, 1, 1)

	S:HandleScrollBar(SendMailScrollFrameScrollBar)

	SendMailNameEditBox:Height(20)
	S:HandleEditBox(SendMailNameEditBox)

	S:HandleEditBox(SendMailSubjectEditBox)
	SendMailSubjectEditBox:Point("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -4)

	S:HandleEditBox(SendMailMoneyGold)
	S:HandleEditBox(SendMailMoneySilver)
	S:HandleEditBox(SendMailMoneyCopper)

	S:HandleButton(SendMailMailButton)
	SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -2, 0)

	S:HandleButton(SendMailCancelButton)

	for i = 1, 5 do
		_G["AutoCompleteButton"..i]:StyleButton()
	end

	-- Open Mail Frame
	S:HandlePortraitFrame(OpenMailFrame)
	OpenMailFrame.Inset:StripTextures()
	OpenMailFrame.NineSlice:StripTextures()
	OpenMailFrame.Content:StripTextures()

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["OpenMailAttachmentButton"..i]
		local icon = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		local count = _G["OpenMailAttachmentButton"..i.."Count"]

		button:StripTextures()
		button:SetTemplate("Default", true)
		button:StyleButton()

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetDrawLayer("ARTWORK")
			icon:SetInside()

			count:SetDrawLayer("OVERLAY")
		end
	end

	hooksecurefunc("OpenMailFrame_UpdateButtonPositions", function()
		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local ItemLink = GetInboxItemLink(InboxFrame.openMailID, i)
			local button = _G["OpenMailAttachmentButton"..i]

			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			if ItemLink then
				local quality = select(3, GetItemInfo(ItemLink))

				if quality then
					button:SetBackdropBorderColor(GetItemQualityColor(quality))
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end
		end
	end)

	S:HandleButton(OpenMailReportSpamButton)

	S:HandleButton(OpenMailReplyButton, true)
	OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)

	S:HandleButton(OpenMailDeleteButton, true)
	OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)

	S:HandleButton(OpenMailCancelButton, true)

	OpenMailScrollFrame:StripTextures(true)
	OpenMailScrollFrame:SetTemplate("Default")

	S:HandleScrollBar(OpenMailScrollFrameScrollBar)

	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetFont(E.media.normFont, 13)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailInvoiceBuyMode:SetTextColor(1, 0.80, 0.10)

	OpenMailArithmeticLine:Kill()

	OpenMailLetterButton:StripTextures()
	OpenMailLetterButton:SetTemplate("Default", true)
	OpenMailLetterButton:StyleButton()

	OpenMailLetterButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	OpenMailLetterButtonIconTexture:SetDrawLayer("ARTWORK")
	OpenMailLetterButtonIconTexture:SetInside()

	OpenMailLetterButtonCount:SetDrawLayer("OVERLAY")

	OpenMailMoneyButton:StripTextures()
	OpenMailMoneyButton:SetTemplate("Default", true)
	OpenMailMoneyButton:StyleButton()

	OpenMailMoneyButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	OpenMailMoneyButtonIconTexture:SetDrawLayer("ARTWORK")
	OpenMailMoneyButtonIconTexture:SetInside()

	OpenMailMoneyButtonCount:SetDrawLayer("OVERLAY")
end

S:RemoveCallback("Skin_Mail")
S:AddCallback("Skin_Mail", LoadSkin)