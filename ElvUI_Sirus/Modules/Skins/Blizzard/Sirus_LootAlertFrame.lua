local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.alertframes then return end

	for i = 1, 4 do
		local button = _G["LootAlertButton"..i]
		button:DisableDrawLayer("OVERLAY")
		button.Background:SetAlpha(0)

		button:CreateBackdrop("Transparent")
		button.backdrop:Point("TOPLEFT", 8, -12)
		button.backdrop:Point("BOTTOMRIGHT", -5, 8)

		local iconBackdrop = CreateFrame("Frame", nil, button)
		iconBackdrop:SetTemplate()
		button.Icon:SetTexCoord(unpack(E.TexCoords))
		button.Icon:SetParent(iconBackdrop)
		button.Count:SetParent(iconBackdrop)
		iconBackdrop:SetOutside(button.Icon)

		button.IconBorder:SetAlpha(0)
		hooksecurefunc(button.ItemName, "SetTextColor", function(_, r, g, b) iconBackdrop:SetBackdropBorderColor(r, g, b) end)
	end
end

S:AddCallback("Sirus_LootAlertFrame", LoadSkin)