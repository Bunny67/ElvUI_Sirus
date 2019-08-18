local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule("DataTexts")

--Lua functions
--WoW API / Variables

local oldOnClick = DT.RegisteredDataTexts.Guild.onClick
DT.RegisteredDataTexts.Guild.onClick = function(_, btn)
	if btn == "RightButton" and IsInGuild() then
		oldOnClick(_, btn)
	else
		GuildFrame_Toggle()
	end
end