if not IsAddOnLoaded("ElvUI_Enhanced") then return end

local E, L, V, P, G = unpack(ElvUI)
local MBG = E:GetModule("Enhanced_MinimapButtonGrabber")

local ignoreButtons = {
	["QueueStatusMinimapButton"] = true,
}

local old_SkinMinimapButton = MBG.SkinMinimapButton
function MBG:SkinMinimapButton(button)
	if not button or button.isSkinned then return end

	local name = button:GetName()
	if not name then return end

	if button:IsObjectType("Button") and ignoreButtons[name] then
		return
	end

	return old_SkinMinimapButton(self, button)
end