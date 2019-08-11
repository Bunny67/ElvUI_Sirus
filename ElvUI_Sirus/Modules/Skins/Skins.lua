local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local ipairs = ipairs
local tremove = table.remove
--WoW API / Variables

function S:RemoveCallback(eventName)
	if not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #1 to S:RemoveCallback (string expected)")
		return
	elseif not self.nonAddonCallbacks[eventName] then
		E:Print("Invalid 'eventName' #1 to S:RemoveCallback")
		return
	end

	self.nonAddonCallbacks[eventName] = nil
	for index, event in ipairs(self.nonAddonCallbacks.CallPriority) do
		if event == eventName then
			tremove(self.nonAddonCallbacks.CallPriority, index)
		end
	end
	E.UnregisterCallback(S, eventName)
end

S:RemoveCallback("LFD")
S:RemoveCallback("WatchFrame")