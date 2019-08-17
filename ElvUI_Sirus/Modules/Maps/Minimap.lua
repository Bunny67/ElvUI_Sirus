local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local M = E:GetModule("Minimap")

--Lua functions
--WoW API / Variables

local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() ToggleFrame(SpellBookFrame) end},
	{text = TALENTS_BUTTON,
	func = ToggleTalentFrame},
	{text = ACHIEVEMENT_BUTTON,
	func = ToggleAchievementFrame},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = L["Calendar"],
	func = function() GameTimeFrame:Click() end},
	{text = L["Farm Mode"],
	func = FarmMode},
	{text = BATTLEFIELD_MINIMAP,
	func = ToggleBattlefieldMinimap},
	{text = TIMEMANAGER_TITLE,
	func = ToggleTimeManager},
	{text = PLAYER_V_PLAYER,
	func = TogglePVPUIFrame},
	{text = LFG_TITLE,
	func = function() ToggleFrame(LFDParentFrame) end},
	{text = LOOKING_FOR_RAID,
	func = function() ToggleFrame(LFRParentFrame) end},
	{text = HELP_BUTTON,
	func = ToggleHelpFrame}
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
FarmModeMap:SetScript("OnMouseUp", M.Minimap_OnMouseUp)