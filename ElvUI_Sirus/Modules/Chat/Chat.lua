local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule("Chat")

local ElvBlue = E:TextureString(E.Media.ChatLogos.ElvBlue, ":13:25")
local ElvRainbow = E:TextureString(E.Media.ChatLogos.ElvRainbow, ":13:25")
local specialChatIcons = {
	["Крольчонок-Scourge x2 - 3.3.5a+"] = ElvBlue,
	["Vakh-Scourge x2 - 3.3.5a+"] = ElvRainbow,
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

function ChatUrlHyperlink_OnClick(link, text)
	if IsModifiedClick() then
		HandleModifiedItemClick(text)
		return
	end

	local linkData = C_Split(link, ":")
	if linkData then
		local id, arg1, arg2, arg3 = unpack(linkData, 2)

		if linkData then
			if id and arg1 and arg2 and arg3 then
				C_SendOpcode(CMSG_SIRUS_OPEN_URL, tonumber(id), arg1, arg2, arg3)
			else
				local currentLink = strsub(link, 5)
				if currentLink and currentLink ~= "" then
					CH:SetChatEditBoxMessage(currentLink)
				end
			end
		end
	end
end