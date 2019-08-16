local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	-- Static Popups
	for i = 1, 4 do
		local staticPopup = _G["StaticPopup"..i]
		staticPopup.bar:StripTextures()
		staticPopup.bar:CreateBackdrop("Transparent")


		staticPopup.bar:Point("TOP", staticPopup, "BOTTOM", 0, -4)
		staticPopup.bar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(staticPopup.bar)
	end
end

S:AddCallback("Sirus_Misc", LoadSkin)