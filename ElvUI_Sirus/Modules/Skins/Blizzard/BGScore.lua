local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bgscore ~= true then return; end

	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:SetTemplate("Transparent")

	BattlegroundBalanceProgressBar:CreateBackdrop()
	BattlegroundBalanceProgressBar.backdrop:SetOutside(BattlegroundBalanceProgressBar.Alliance, nil, nil, BattlegroundBalanceProgressBar.Horde)
	BattlegroundBalanceProgressBar.Border:SetAlpha(0)

	WorldStateScoreFrame.Container.FactionGlow:SetPoint("TOPLEFT", 1, 12)
	WorldStateScoreFrame.Container.Separator:SetAlpha(0)
	WorldStateScoreFrame.Container.Bg:SetAlpha(0)
	WorldStateScoreFrame.Container.TopRightCorner:SetAlpha(0)
	WorldStateScoreFrame.Container.TopLeftCorner:SetAlpha(0)
	WorldStateScoreFrame.Container.TopBorder:SetAlpha(0)
	WorldStateScoreFrame.Container.BotLeftCorner:SetAlpha(0)
	WorldStateScoreFrame.Container.BotRightCorner:SetAlpha(0)
	WorldStateScoreFrame.Container.BottomBorder:SetAlpha(0)
	WorldStateScoreFrame.Container.LeftBorder:SetAlpha(0)
	WorldStateScoreFrame.Container.RightBorder:SetAlpha(0)
	WorldStateScoreFrame.Container.Inset:StripTextures()

	WorldStateScoreScrollFrame:StripTextures()
	S:HandleScrollBar(WorldStateScoreScrollFrameScrollBar)

	S:HandleCloseButton(WorldStateScoreFrameCloseButton)

	for i = 1, 3 do
		S:HandleTab(_G["WorldStateScoreFrameTab"..i])
	end

	S:HandleButton(WorldStateScoreFrameLeaveButton)

	WorldStateScoreFrame.EfficiencyFrame.EfficiencyBar:CreateBackdrop()
	WorldStateScoreFrame.EfficiencyFrame.EfficiencyBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(WorldStateScoreFrame.EfficiencyFrame.EfficiencyBar)
	WorldStateScoreFrame.EfficiencyFrame.EfficiencyBar.Border:SetAlpha(0)

	WorldStateScoreFrame.EfficiencyFrame.EfficiencyBar:HookScript("OnValueChanged", function(self, value)
		local r, g, b = E:ColorGradient(value / 1, .65,0,0, .65,.65,0, 0,.65,0)
		self:SetStatusBarColor(r, g, b)
		self.Background:SetTexture(r * 0.25, g * 0.25, b * 0.25)
	end)
end

S:RemoveCallback("Skin_WorldStateScore")
S:AddCallback("Skin_WorldStateScore", LoadSkin)