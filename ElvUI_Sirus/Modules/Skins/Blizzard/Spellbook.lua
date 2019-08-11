local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins");

--Cache global variables
--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true then return end

	SpellBookFrame:StripTextures(true)
	SpellBookFrame:SetTemplate("Transparent")

	S:HandleNextPrevButton(SpellBookPrevPageButton, nil, nil, true)
	S:HandleNextPrevButton(SpellBookNextPageButton, nil, nil, true)
end

S:AddCallback("Spellbook", LoadSkin)