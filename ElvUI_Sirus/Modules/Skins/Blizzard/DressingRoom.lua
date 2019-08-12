local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	DressUpFrame:StripTextures()
	DressUpFrame:SetTemplate("Transparent")

	DressUpFramePortrait:Kill()

	S:HandleCloseButton(DressUpFrameCloseButton)

	S:HandleButton(DressUpFrameCancelButton)
	DressUpFrameCancelButton:Point("CENTER", DressUpFrame, "TOPLEFT", 306, -423)
	S:HandleButton(DressUpFrameResetButton)
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -3, 0)

	DressUpModel:CreateBackdrop("Default")
	DressUpModel.backdrop:SetOutside(DressUpBackgroundTopLeft, nil, nil, DressUpModel)
end

S:RemoveCallback("DressingRoom")
S:AddCallback("DressingRoom", LoadSkin)