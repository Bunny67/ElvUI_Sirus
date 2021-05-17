local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local M = E:GetModule("Minimap")
local Reminder = E:GetModule("ReminderBuffs")

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

function M:UpdateSettings()
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	E.MinimapSize = E.private.general.minimap.enable and E.db.general.minimap.size or Minimap:GetWidth() + 10
	E.MinimapWidth, E.MinimapHeight = E.MinimapSize, E.MinimapSize

	if E.db.general.reminder.enable then
		E.RBRWidth = (E.MinimapHeight + ((E.Border - E.Spacing*3) * 5) + E.Border*2) / 6
	else
		E.RBRWidth = 0
	end

	if E.private.general.minimap.enable then
		Minimap:Size(E.MinimapSize, E.MinimapSize)
	end

	if LeftMiniPanel and RightMiniPanel then
		if E.db.datatexts.minimapPanels and E.private.general.minimap.enable then
			LeftMiniPanel:Show()
			RightMiniPanel:Show()
		else
			LeftMiniPanel:Hide()
			RightMiniPanel:Hide()
		end
	end

	if BottomMiniPanel then
		if E.db.datatexts.minimapBottom and E.private.general.minimap.enable then
			BottomMiniPanel:Show()
		else
			BottomMiniPanel:Hide()
		end
	end

	if BottomLeftMiniPanel then
		if E.db.datatexts.minimapBottomLeft and E.private.general.minimap.enable then
			BottomLeftMiniPanel:Show()
		else
			BottomLeftMiniPanel:Hide()
		end
	end

	if BottomRightMiniPanel then
		if E.db.datatexts.minimapBottomRight and E.private.general.minimap.enable then
			BottomRightMiniPanel:Show()
		else
			BottomRightMiniPanel:Hide()
		end
	end

	if TopMiniPanel then
		if E.db.datatexts.minimapTop and E.private.general.minimap.enable then
			TopMiniPanel:Show()
		else
			TopMiniPanel:Hide()
		end
	end

	if TopLeftMiniPanel then
		if E.db.datatexts.minimapTopLeft and E.private.general.minimap.enable then
			TopLeftMiniPanel:Show()
		else
			TopLeftMiniPanel:Hide()
		end
	end

	if TopRightMiniPanel then
		if E.db.datatexts.minimapTopRight and E.private.general.minimap.enable then
			TopRightMiniPanel:Show()
		else
			TopRightMiniPanel:Hide()
		end
	end

	if MMHolder then
		MMHolder:Width((Minimap:GetWidth() + E.Border*2 + E.Spacing*3) + E.RBRWidth)

		if E.db.datatexts.minimapPanels then
			MMHolder:Height(Minimap:GetHeight() + (LeftMiniPanel and (LeftMiniPanel:GetHeight() + E.Border) or 24) + E.Spacing*3)
		else
			MMHolder:Height(Minimap:GetHeight() + E.Border + E.Spacing*3)
		end
	end

	if Minimap.location then
		Minimap.location:Width(E.MinimapSize)

		if E.db.general.minimap.locationText ~= "SHOW" or not E.private.general.minimap.enable then
			Minimap.location:Hide()
		else
			Minimap.location:Show()
		end
	end

	if MinimapMover then
		MinimapMover:Size(MMHolder:GetSize())
	end

	if GameTimeFrame then
		if E.private.general.minimap.hideCalendar then
			GameTimeFrame:Hide()
		else
			local pos = E.db.general.minimap.icons.calendar.position or "TOPRIGHT"
			local scale = E.db.general.minimap.icons.calendar.scale or 1
			GameTimeFrame:ClearAllPoints()
			GameTimeFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.calendar.xOffset or 0, E.db.general.minimap.icons.calendar.yOffset or 0)
			GameTimeFrame:SetScale(scale)
			GameTimeFrame:Show()
		end
	end

	if MiniMapMailFrame then
		local pos = E.db.general.minimap.icons.mail.position or "TOPRIGHT"
		local scale = E.db.general.minimap.icons.mail.scale or 1
		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.mail.xOffset or 3, E.db.general.minimap.icons.mail.yOffset or 4)
		MiniMapMailFrame:SetScale(scale)
	end

	if MiniMapLFGFrame then
		local pos = E.db.general.minimap.icons.lfgEye.position or "BOTTOMRIGHT"
		local scale = E.db.general.minimap.icons.lfgEye.scale or 1
		MiniMapLFGFrame:ClearAllPoints()
		MiniMapLFGFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.lfgEye.xOffset or 3, E.db.general.minimap.icons.lfgEye.yOffset or 0)
		MiniMapLFGFrame:SetScale(scale)
		LFDSearchStatus:SetScale(scale)
	end

	if QueueStatusMinimapButton then
		local pos = E.db.general.minimap.icons.battlefield.position or "BOTTOMRIGHT"
		local scale = E.db.general.minimap.icons.battlefield.scale or 1
		QueueStatusMinimapButton:ClearAllPoints()
		QueueStatusMinimapButton:Point(pos, Minimap, pos, E.db.general.minimap.icons.battlefield.xOffset or 3, E.db.general.minimap.icons.battlefield.yOffset or 0)
		QueueStatusMinimapButton:SetScale(scale)
		QueueStatusFrame:SetScale(scale)
	end

	if MiniMapBattlefieldFrame then
		local pos = E.db.general.minimap.icons.battlefield.position or "BOTTOMRIGHT"
		local scale = E.db.general.minimap.icons.battlefield.scale or 1
		MiniMapBattlefieldFrame:ClearAllPoints()
		MiniMapBattlefieldFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.battlefield.xOffset or 3, E.db.general.minimap.icons.battlefield.yOffset or 0)
		MiniMapBattlefieldFrame:SetScale(scale)
	end

	if MiniMapInstanceDifficulty then
		local pos = E.db.general.minimap.icons.difficulty.position or "TOPLEFT"
		local scale = E.db.general.minimap.icons.difficulty.scale or 1
		local x = E.db.general.minimap.icons.difficulty.xOffset or 0
		local y = E.db.general.minimap.icons.difficulty.yOffset or 0
		MiniMapInstanceDifficulty:ClearAllPoints()
		MiniMapInstanceDifficulty:Point(pos, Minimap, pos, x, y)
		MiniMapInstanceDifficulty:SetScale(scale)
	end

	if ElvConfigToggle then
		if E.db.general.reminder.enable and E.db.datatexts.minimapPanels and E.private.general.minimap.enable then
			ElvConfigToggle:Show()
			ElvConfigToggle:Width(E.RBRWidth)
		else
			ElvConfigToggle:Hide()
		end
	end

	if ElvUI_ReminderBuffs then
		Reminder:UpdateSettings()
	end
end