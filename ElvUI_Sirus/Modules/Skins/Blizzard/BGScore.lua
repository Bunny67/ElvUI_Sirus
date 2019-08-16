local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables


local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bgscore ~= true then return; end

	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:SetTemplate("Transparent")


	BattlegroundBalanceProgressBar:CreateBackdrop()
	BattlegroundBalanceProgressBar.backdrop:SetOutside(BattlegroundBalanceProgressBar.Horde, nil, nil, BattlegroundBalanceProgressBar.Alliance)
	BattlegroundBalanceProgressBar.Border:SetAlpha(0)

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
end

S:RemoveCallback("WorldStateScore")
S:AddCallback("WorldStateScore", LoadSkin)