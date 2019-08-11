local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local ipairs = ipairs
local tremove = table.remove
--WoW API / Variables

function S:RemoveCallback(eventName)
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