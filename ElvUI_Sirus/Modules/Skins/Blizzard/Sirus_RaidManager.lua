local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

	local frameManager = CompactRaidFrameManager
	local displayFrame = frameManager.displayFrame

	frameManager:StripTextures()
	frameManager:CreateBackdrop("Transparent")
	frameManager.backdrop:Point("TOPLEFT", 0, 0)
	frameManager.backdrop:Point("BOTTOMRIGHT", 0, 0)

	S:HandleButton(frameManager.toggleButton)
	frameManager.toggleButton:ClearAllPoints()
	frameManager.toggleButton:Point("RIGHT", 5, 0)

	S:HandleButton(frameManager.resizer)
	frameManager.resizer:ClearAllPoints()
	frameManager.resizer:Point("BOTTOM", 0, -5)

	displayFrame:StripTextures()

	displayFrame.convertToRaid:StripTextures(true)
	S:HandleButton(displayFrame.convertToRaid)

	displayFrame.readyCheckButton:StripTextures(true)
	S:HandleButton(displayFrame.readyCheckButton)

	displayFrame.RaidWorldMarkerButton:StripTextures(true)
	S:HandleButton(displayFrame.RaidWorldMarkerButton)
	displayFrame.RaidWorldMarkerButton:Point("TOPLEFT", displayFrame.readyCheckButton, "TOPRIGHT", 2, 0)
	displayFrame.RaidWorldMarkerButton:SetNormalTexture(E.Media.Textures.Leader)
	displayFrame.RaidWorldMarkerButton:SetPushedTexture(nil)
	displayFrame.RaidWorldMarkerButton.SetPushedTexture = E.noop

end

S:AddCallback("Skin_RaidManager", LoadSkin)