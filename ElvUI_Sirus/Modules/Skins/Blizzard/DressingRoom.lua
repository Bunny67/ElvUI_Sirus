local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	DressUpFrame:StripTextures(true)
	DressUpFrame:SetTemplate("Transparent")
	DressUpFrameInset:StripTextures()

	MaximizeMinimizeFrame:StripTextures(true)

	S:HandleCloseButton(DressUpFrameCloseButton)

	S:HandleButton(DressUpFrameCancelButton)
	S:HandleButton(DressUpFrameResetButton)

	DressUpModel:CreateBackdrop("Default")
end

S:RemoveCallback("DressingRoom")
S:AddCallback("DressingRoom", LoadSkin)