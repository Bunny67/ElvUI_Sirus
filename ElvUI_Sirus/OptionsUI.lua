local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("ElvUI_Sirus")

function S:GetOptions()
	E.Options.args.actionbar.args.microbar.args.buttonsPerRow.max = #SHARED_MICROMENU_BUTTONS
end