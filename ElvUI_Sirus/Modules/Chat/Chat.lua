local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule("Chat")

local ElvMelon = E:TextureString(E.Media.ChatLogos.ElvMelon, ":13:25")
local specialChatIcons = {
	["Крельчонок-3.3.5a+"] = ElvMelon,
}

local function GetChatIcon(sender)
	if specialChatIcons[sender] then
		return specialChatIcons[sender]
	end
end

CH:AddPluginIcons(GetChatIcon)