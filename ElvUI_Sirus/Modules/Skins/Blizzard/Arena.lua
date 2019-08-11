local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins");

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.arena ~= true then return end

	ArenaFrame:StripTextures()

	ArenaFrameNameHeader:SetPoint("TOPLEFT", 28, -55)
	ArenaFrameZoneDescription:SetTextColor(1, 1, 1)

	ArenaFrame:CreateBackdrop("Transparent")
	ArenaFrame.backdrop:Point("TOPLEFT", 11, -12)
	ArenaFrame.backdrop:Point("BOTTOMRIGHT", -34, 74)

	S:HandleButton(ArenaFrameCancelButton)
	S:HandleButton(ArenaFrameJoinButton)
	S:HandleButton(ArenaFrameGroupJoinButton)
	ArenaFrameGroupJoinButton:SetPoint("RIGHT", ArenaFrameJoinButton, "LEFT", -2, 0)

	S:HandleCloseButton(ArenaFrameCloseButton)
end

S:AddCallback("Arena", LoadSkin)