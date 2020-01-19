local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.roulette ~= true then return end

	Custom_RouletteFrame:SetParent(UIParent)
	Custom_RouletteFrame:SetScale(1)
	Custom_RouletteFrame:SetFrameStrata("HIGH")

	Custom_RouletteFrame:StripTextures(true)
	Custom_RouletteFrame:SetTemplate("Transparent")

	S:HandleCloseButton(Custom_RouletteFrame.closeButton)

	Custom_RouletteFrame.HeaderFrame:StripTextures()
	Custom_RouletteFrame.HeaderFrame:SetPoint("TOP", 0, 0)
	Custom_RouletteFrame.HeaderFrame.TitleText:FontTemplate(nil, 16, "NONE")

	for i = 1, #Custom_RouletteFrame.itemButtons do
		local button = Custom_RouletteFrame.itemButtons[i]
		button.OverlayFrame.ChildFrame.ItemName:FontTemplate(nil, 12, "NONE")
	end

	for i = 1, #Custom_RouletteFrame.rewardButtons do
		local button = Custom_RouletteFrame.rewardButtons[i]
		button.Background:SetDrawLayer("BORDER")
		button.Background:SetInside()
		button.Border:SetAlpha(0)
		button:SetTemplate()
		button.OverlayFrame.ChildFrame.ItemName:FontTemplate(nil, 12, "NONE")

		local r, g, b = button.Border:GetVertexColor()
		button:SetBackdropBorderColor(r, g, b)
	end
end

S:AddCallback("Custom_Roulette", LoadSkin)