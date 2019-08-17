local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule("Chat")

local ElvBlue = E:TextureString(E.Media.ChatLogos.ElvBlue, ":13:25")
local specialChatIcons = {
	["Крельчонок-Scourge x2 - 3.3.5a+"] = ElvBlue,
}

local function GetChatIcon(_, name, realm)
	if not name then return end

	realm = realm ~= "" and realm or E.myrealm
	name = name.."-"..realm

	if specialChatIcons[name] then
		return specialChatIcons[name]
	end
end

CH:AddPluginIcons(GetChatIcon)

hooksecurefunc(CH, "StyleChat", function(_, frame)
	frame.buttonFrame:Kill()
	frame.buttonFrame2:Hide()
	frame.buttonFrame2.Show = E.noop
end)