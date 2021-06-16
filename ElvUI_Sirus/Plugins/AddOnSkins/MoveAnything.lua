local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins", true)
if not AS then return end

if not AS:IsAddonLODorEnabled("MoveAnything") then return end

local _G = _G
local unpack = unpack

-- MoveAnything 3.3.5-10
-- https://www.curseforge.com/wow/addons/move-anything/files/434496

S:RemoveCallbackForAddon("MoveAnything", "MoveAnything")
S:AddCallbackForAddon("MoveAnything", "MoveAnything", function()
	if not E.private.addOnSkins.MoveAnything then return end

	local SPACING = 1 + (E.Spacing * 2)

	local function moverOnShow(self)
		_G[self:GetName() .. "Backdrop"]:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end
	local function moverOnEnter(self)
		_G[self:GetName() .. "BackdropMovingFrameName"]:SetTextColor(1, 1, 1)
	end
	local function moverOnLeave(self)
		_G[self:GetName() .. "BackdropMovingFrameName"]:SetTextColor(unpack(E.media.rgbvaluecolor))
	end

	local function skinMover(frameName)
		_G[frameName .. "Backdrop"]:SetTemplate("Transparent")

		_G[frameName]:HookScript("OnShow", moverOnShow)
		_G[frameName]:SetScript("OnEnter", moverOnEnter)
		_G[frameName]:SetScript("OnLeave", moverOnLeave)
	end

	for i = 1, #MovAny.movers do
		skinMover(MovAny.movers[i]:GetName())
	end

	local numSkinnedMovers = #MovAny.movers
	hooksecurefunc(MovAny, "GetAvailableMover", function(self)
		local numMovers = #self.movers
		if numMovers > numSkinnedMovers then
			skinMover(self.movers[numMovers]:GetName())
			numSkinnedMovers = numMovers
		end
	end)

	MAOptions:StripTextures()
	MAOptions:SetTemplate("Transparent")
	MAOptions:Size(420, 500 + (16 * SPACING))

	S:HandleCheckBox(MAOptionsToggleModifiedFramesOnly)
	S:HandleCheckBox(MAOptionsToggleCategories)
	S:HandleCheckBox(MAOptionsToggleFrameEditors)
	S:HandleCheckBox(MAOptionsToggleFrameStack)

	S:HandleButton(MAOptionsClose)
	S:HandleButton(MAOptionsSync)
	S:HandleButton(MAOptionsOpenBlizzardOptions)

	S:HandleEditBox(MA_Search)
	MA_Search:Width(388)

	MAScrollFrame:Size(380, 442 + (16 * SPACING))
	S:HandleScrollBar(MAScrollFrameScrollBar)
	MAScrollBorder:StripTextures()

	MANudger:SetTemplate("Transparent")
	S:HandleButton(MANudger_NudgeUp)
	MANudger_NudgeUp:Point("CENTER", 0, 24 + SPACING)
	S:HandleButton(MANudger_CenterMe)
	MANudger_CenterMe:Point("TOP", MANudger_NudgeUp, "BOTTOM", 0, -SPACING)
	S:HandleButton(MANudger_NudgeDown)
	MANudger_NudgeDown:Point("TOP", MANudger_CenterMe, "BOTTOM", 0, -SPACING)
	S:HandleButton(MANudger_NudgeLeft)
	MANudger_NudgeLeft:Point("RIGHT", MANudger_CenterMe, "LEFT", -SPACING, 0)
	S:HandleButton(MANudger_NudgeRight)
	MANudger_NudgeRight:Point("LEFT", MANudger_CenterMe, "RIGHT", SPACING, 0)
	S:HandleButton(MANudger_CenterH)
	S:HandleButton(MANudger_CenterV)
	S:HandleButton(MANudger_Detach)
	S:HandleButton(MANudger_Hide)
	S:HandleButton(MANudger_MoverPlus)
	S:HandleButton(MANudger_MoverMinus)

	S:HandleButton(GameMenuButtonMoveAnything)
end)