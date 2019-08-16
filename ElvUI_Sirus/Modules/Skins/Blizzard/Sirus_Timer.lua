local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timer ~= true then return end

	hooksecurefunc("TimerTracker_OnEvent", function(self, event)
		if event == "START_TIMER" then
			for _, b in pairs(self.timerList) do
				if b.bar and not b.bar.isSkinned then
					b.bar:StripTextures()
					b.bar.timeText:FontTemplate(nil, 12, "OUTLINE")

					b.bar:SetStatusBarTexture(E.media.normTex)
					E:RegisterStatusBar(b.bar)

					b.bar.backdrop = CreateFrame("Frame", nil, b.bar)
					b.bar.backdrop:SetFrameLevel(0)
					b.bar.backdrop:SetTemplate("Transparent")
					b.bar.backdrop:SetOutside()

					b.bar.isSkinned = true
				end
			end
		end
	end)
end

S:AddCallback("Sirus_Timer", LoadSkin)