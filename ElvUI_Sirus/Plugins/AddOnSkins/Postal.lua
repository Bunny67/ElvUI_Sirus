local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- Postal r299
-- https://www.wowace.com/projects/postal/files/454610

local function LoadSkin()
	if not E.private.addOnSkins.Postal then return end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local mail = _G["MailItem"..i]
		local button = _G["MailItem"..i.."Button"]
		local expire = _G["MailItem"..i.."ExpireTime"]
		local inboxCB = _G["PostalInboxCB"..i]

		button:SetScale(1)
		mail:Size(302, 45)

		if i == 1 then
			mail:Point("TOPLEFT", 25, -8)
		elseif i == 7 then
			mail:Point("TOPLEFT", InboxFrameRightContainer, 22, -8)
		end

		if expire then
			expire:Point("TOPRIGHT", -4, -2)

			if expire.returnicon then
				expire.returnicon:StripTextures(true)
				S:HandleCloseButton(expire.returnicon)
				expire.returnicon:ClearAllPoints()
				expire.returnicon:Point("BOTTOMRIGHT", mail, -4, 2)
				expire.returnicon:Size(16)
			end
		end

		if inboxCB then
			S:HandleCheckBox(inboxCB)
			inboxCB:ClearAllPoints()
			inboxCB:Point("RIGHT", mail, "LEFT", -2, 0)
		end
	end

	if PostalSelectOpenButton then
		S:HandleButton(PostalSelectOpenButton, true)
		PostalSelectOpenButton:ClearAllPoints()
		PostalSelectOpenButton:Point("TOPLEFT", InboxFrame, "TOPLEFT", 21, 28)
	end

	if PostalSelectReturnButton then
		S:HandleButton(PostalSelectReturnButton, true)
		PostalSelectReturnButton:ClearAllPoints()
		PostalSelectReturnButton:Point("LEFT", PostalSelectOpenButton, "RIGHT", 77, 0)
	end

	if Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(Postal_OpenAllMenuButton)
		Postal_OpenAllMenuButton:ClearAllPoints()
		Postal_OpenAllMenuButton:Point("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
		Postal_OpenAllMenuButton:Size(25)
	end

	if PostalOpenAllButton then
		S:HandleButton(PostalOpenAllButton, true)
	end

	if Postal_ModuleMenuButton then
		S:HandleNextPrevButton(Postal_ModuleMenuButton, nil, nil, true)
		Postal_ModuleMenuButton:Point("TOPRIGHT", MailFrame, -20, 2)
		Postal_ModuleMenuButton:Size(25)
	end

	if Postal_BlackBookButton then
		S:HandleNextPrevButton(Postal_BlackBookButton)
		Postal_BlackBookButton:ClearAllPoints()
		Postal_BlackBookButton:Point("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
		Postal_BlackBookButton:Size(20)
	end

	hooksecurefunc(Postal, "CreateAboutFrame", function()
		if PostalAboutFrame then
			PostalAboutFrame:StripTextures()
			PostalAboutFrame:SetTemplate("Transparent")

			if PostalAboutScroll then
				S:HandleScrollBar(PostalAboutScrollScrollBar)
			end

			local closeButton = select(2, PostalAboutFrame:GetChildren())
			if closeButton then
				S:HandleCloseButton(closeButton)
			end
		end
	end)
end

S:RemoveCallbackForAddon("Postal", "Postal")
S:AddCallbackForAddon("Postal", "Postal", LoadSkin)