local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local M = E:GetModule("Minimap")

--Lua functions
--WoW API / Variables

local menuList = {
	{
		text = CHARACTER_BUTTON,
		notCheckable = 1,
		func = function()
			ToggleCharacter("PaperDollFrame")
		end
	},
	{
		text = SPELLBOOK_ABILITIES_BUTTON,
		notCheckable = 1,
		func = function()
			ToggleFrame(SpellBookFrame)
		end
	},
	{
		text = TALENTS_BUTTON,
		notCheckable = 1,
		func = ToggleTalentFrame
	},
	{
		text = ACHIEVEMENT_BUTTON,
		notCheckable = 1,
		func = ToggleAchievementFrame
	},
	{
		text = QUESTLOG_BUTTON,
		notCheckable = 1,
		func = function()
			ToggleFrame(QuestLogFrame)
		end
	},
	{
		text = SOCIAL_BUTTON,
		notCheckable = 1,
		func = function()
			ToggleFriendsFrame(1)
		end
	},
	{
		text = L["Calendar"],
		notCheckable = 1,
		func = function()
			GameTimeFrame:Click()
		end
	},
	{
		text = L["Farm Mode"],
		notCheckable = 1,
		func = FarmMode
	},
	{
		text = BATTLEFIELD_MINIMAP,
		notCheckable = 1,
		func = ToggleBattlefieldMinimap
	},
	{
		text = TIMEMANAGER_TITLE,
		notCheckable = 1,
		func = ToggleTimeManager
	},
	{
		text = PLAYER_V_PLAYER,
		notCheckable = 1,
		func = TogglePVPUIFrame
	},
	{
		text = LFG_TITLE,
		notCheckable = 1,
		func = function()
			ToggleFrame(LFDParentFrame)
		end
	},
	{
		text = LOOKING_FOR_RAID,
		notCheckable = 1,
		func = function()
			ToggleFrame(LFRParentFrame)
		end
	},
	{
		text = MAINMENU_BUTTON,
		notCheckable = 1,
		func = function()
			if GameMenuFrame:IsShown() then
				PlaySound("igMainMenuQuit")
				HideUIPanel(GameMenuFrame)
			else
				PlaySound("igMainMenuOpen")
				ShowUIPanel(GameMenuFrame)
			end
		end
	},
	{
		text = HELP_BUTTON,
		notCheckable = 1,
		func = ToggleHelpFrame
	}
}

function M:Minimap_OnMouseUp(btn)
	local position = self:GetPoint()
	if btn == "MiddleButton" or (btn == "RightButton" and IsShiftKeyDown()) then
		if position:match("LEFT") then
			EasyMenu(menuList, MinimapRightClickMenu, "cursor", 0, 0, "MENU", 2)
		else
			EasyMenu(menuList, MinimapRightClickMenu, "cursor", -160, 0, "MENU", 2)
		end
	elseif btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor")
	else
		Minimap_OnClick(self)
	end
end

Minimap:SetScript("OnMouseUp", M.Minimap_OnMouseUp)
if FarmModeMap then
	FarmModeMap:SetScript("OnMouseUp", M.Minimap_OnMouseUp)
end