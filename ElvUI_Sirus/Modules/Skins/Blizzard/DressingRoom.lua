local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	S:HandlePortraitFrame(DressUpFrame)

	MaximizeMinimizeFrame:StripTextures(true)
	S:HandleMaxMinFrame(DressUpFrame.MaxMinButtonFrame)

	S:HandleButton(DressUpFrameCancelButton)
	S:HandleButton(DressUpFrameResetButton)

	DressUpModel:CreateBackdrop("Default")

	S:HandleControlFrame(DressUpModel.controlFrame)
end

S:RemoveCallback("Skin_DressingRoom")
S:AddCallback("Skin_DressingRoom", LoadSkin)