local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true then return end

	TaxiFrame:StripTextures()
	TaxiFrame:SetTemplate("Transparent")
	S:HandleCloseButton(TaxiFrame.CloseButton)

	TaxiRouteMap:CreateBackdrop()
end

S:RemoveCallback("Skin_Taxi")
S:AddCallback("Skin_Taxi", LoadSkin)