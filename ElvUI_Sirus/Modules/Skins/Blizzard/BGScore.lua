local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

local function LoadSkin()

end

S:RemoveCallback("WorldStateScore")
S:AddCallback("WorldStateScore", LoadSkin)