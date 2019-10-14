local AddOnName = ...
local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local addon = E:NewModule("ElvUI_Sirus")

local function GameMenuFrame_UpdateVisibleButtons()
	if not GameMenuFrame.isSirus then
		GameMenuFrame.isSirus = true
	else
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	end

	if ElvUI_ButtonAddons then
		ElvUI_ButtonAddons:ClearAllPoints()
		ElvUI_ButtonAddons:Point("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)

		GameMenuFrame.ElvUI:ClearAllPoints()
		GameMenuFrame.ElvUI:Point("TOP", ElvUI_ButtonAddons, "BOTTOM", 0, -1)

		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	end
end

SecureUIParentManageFramePositions = E.noop

function addon:Initialize()
	GameMenuFrame:HookScript("OnShow", GameMenuFrame_UpdateVisibleButtons)

	local function StaticPopup_OnShow(self)
		if self.ReplayInfoFrame then
			self.ReplayInfoFrame:Hide()
		end
	end

	for index = 1, 4 do
		E.StaticPopupFrames[index]:HookScript("OnShow", StaticPopup_OnShow)
	end

	EP:RegisterPlugin(AddOnName, self.GetOptions)

	-- Test
	local NUM_VISIBLE_BUTTONS = 5
	local BUTTON_SIZE = 52
	local BUTTON_SPACING = 3

	local MAX_BUTTONS = 50
	local CHILD_WIDTH = (BUTTON_SIZE * MAX_BUTTONS) + (BUTTON_SPACING * (MAX_BUTTONS - 1))

	local START_POINT = -((BUTTON_SIZE + BUTTON_SPACING) * 2)
	local END_POINT = CHILD_WIDTH - ((BUTTON_SIZE + BUTTON_SPACING) * 5)

	local faction = UnitFactionGroup("player")
	local honorIcon = "PVPCurrency-Honor-"..faction
	local arenaIcon = "PVPCurrency-Conquest-"..faction

	local ITEMS_TABLE = {
		{icon = honorIcon, name == "Очки чести", count = 100, quality = 3},
		{icon = arenaIcon, name == "Очки арены", count = 25, quality = 3},
		{icon = "pvecurrency-valor", name == "Очки доблести", count = 50, quality = 4},
		{icon = "INV_MISC_TRINKETPANDA_08", name == "Жетон запределья", count = 3, quality = 3},
		{icon = "Spell_Frost_FrozenCore", name == "Ледяной шар", count = 1, quality = 3},
		{icon = "spell_monk_diffusemagic", name == "Руна Лили", count = 1, quality = 4},

		{icon = honorIcon, name == "Очки чести", count = 500, quality = 3},
		{icon = arenaIcon, name == "Очки арены", count = 125, quality = 3},
		{icon = "pvecurrency-valor", name == "Очки доблести", count = 250, quality = 4},
		{icon = "INV_MISC_TRINKETPANDA_08", name == "Жетон запределья", count = 9, quality = 3},
		{icon = "INV_Elemental_Primal_Nether", name == "Изначальная пустота", count = 1, quality = 3},
		{icon = "ability_monk_touchofdeath", name == "Руна Сируса", count = 1, quality = 4},
		{icon = "INV_LEGENDARY_CHIMERAOFFEAR", name == "Черный бриллиант", count = 1, quality = 5},
	}

	local ITEMS_MSG = {
		["Поздравляем! Вы выиграли 100 очков чести!"] = 1,
		["Поздравляем! Вы выиграли 25 очков арены!"] = 2,
		["Поздравляем! Вы выиграли Очки доблести x50!"] = 3,
		["Поздравляем! Вы выиграли Жетон воина Запределья x3!"] = 4,
		["Поздравляем! Вы выиграли Ледяной шар x1!"] = 5,
		["Поздравляем! Вы выиграли Руна Лили x1!"] = 6,

		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли 500 очков чести!"] = 7,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли 125 очков арены!"] = 8,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли Очки доблести x250!"] = 9,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли Жетон воина Запределья x9!"] = 10,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли Изначальная Пустота x1!"] = 11,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли Руна Сируса x1!"] = 12,
		["|cFFC80046Д|r|cFFC80025Ж|r|cFFC80001Е|r|cFFC82100К|r|cFFC84000П|r|cFFC85C00О|r|cFFC87700Т|r|cFFC79400!|r Вы выиграли Черный бриллиант x1!"] = 13,
	}

	local function SetPrize(self, prizeID)
		self.Prize = prizeID
	end

	local function Reset(self)
		self:SetHorizontalScroll(START_POINT)
		self:UpdateScrollChildRect()

		for i = 1, MAX_BUTTONS do
			if i == (MAX_BUTTONS - 3) then
				self.Child[i]:AddItem(self.Prize) -- LOL
			elseif MAX_BUTTONS > 20 then
				self.Child[i]:AddItem(math.random(7, #ITEMS_TABLE)) -- Added the top items :D
			else
				self.Child[i]:AddItem(math.random(1, #ITEMS_TABLE))
			end

			self.Child[i]:Show()
		end
	end

	local function AddItem(self, id)
		local item = ITEMS_TABLE[id]
		self.Icon:SetTexture("Interface\\Icons\\"..item.icon)
		self.Count:SetText(item.count)
		self:SetBackdropBorderColor(GetItemQualityColor(item.quality))
	end

	local case = CreateFrame("ScrollFrame", nil, UIParent)
	case:Size((BUTTON_SIZE * NUM_VISIBLE_BUTTONS) + (BUTTON_SPACING * (NUM_VISIBLE_BUTTONS - 1)), BUTTON_SIZE)
	case:SetPoint("TOP", 0, -200)
	case:Hide()

	case.Line = CreateFrame("Frame", nil, case)
	case.Line:Size(3, BUTTON_SIZE + (8 * 2))
	case.Line:SetPoint("CENTER")
	case.Line.Texture = case.Line:CreateTexture()
	case.Line.Texture:SetTexture(0.8, 0, 0)
	case.Line.Texture:SetAllPoints()

	case:CreateBackdrop("Transparent")
	case.backdrop:SetOutside(nil, 15, 15)

	case.Reset = Reset
	case.SetPrize = SetPrize

	case.Child = CreateFrame("Frame", nil, case)
	case.Child:SetPoint("TOPLEFT")
	case.Child:Size(CHILD_WIDTH, BUTTON_SIZE)

	local function CreateButton(i, parent)
		local button = CreateFrame("Frame", nil, parent)
		button:Hide()
		button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
		button:SetID(i)

		button.AddItem = AddItem

		button:SetTemplate()

		if i == 1 then
			button:Point("TOPLEFT", 0, 0)
		else
			button:Point("LEFT", parent[i - 1], "RIGHT", BUTTON_SPACING, 0)
		end

		button.Icon = button:CreateTexture()
		button.Icon:SetTexCoord(unpack(E.TexCoords))
		button.Icon:SetInside()

		button.Count = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		button.Count:SetPoint("BOTTOMRIGHT", -5, 3)
		button.Count:SetTextColor(1, 1, 1)

		parent[i] = button
	end

	for i = 1, MAX_BUTTONS do
		CreateButton(i, case.Child)
	end

	case:SetScrollChild(case.Child)

	local function FadeClosure(frame)
		if frame.fadeInfo.mode == "OUT" then
			frame:Hide()
		end
	end

	local function UIFrameFadeOut(frame)
		if frame.IsPlaying then return end

		E:UIFrameFadeOut(frame, 1, 1, 0)
	end

	case.FadeObject = {
		finishedFuncKeep = true,
		finishedArg1 = case,
		finishedFunc = FadeClosure
	}

	local function InOutQuintic(t, b, c, d)
		t = t / d * 2

		if (t < 1) then
			return c / 2 * t ^ 5 + b
		else
			t = t - 2

			return c / 2 * (t ^ 5 + 2) + b
		end
	end

	local function OnUpdate(self, elapsed)
		self.Time = self.Time + elapsed
		if self.Time >= self.Duration then
			self:SetScript("OnUpdate", nil)
			self:SetHorizontalScroll(self.EndScroll)
			self.IsPlaying = nil
			E:Delay(1, UIFrameFadeOut, self)
		end

		self:SetHorizontalScroll(InOutQuintic(self.Time, START_POINT, self.EndScroll, self.Duration))
	end

	function OpenCase(prize)
		if case.IsPlaying then return end

		case:SetPrize(prize or 1)
		case:Reset()
		case:Show()

		case.Time = 0
		case.Duration = 3
		case.EndScroll = END_POINT + ((BUTTON_SIZE / 2) + (BUTTON_SPACING * 2) + math.random(1, (BUTTON_SIZE)))

		E:UIFrameFadeIn(case, 0.5, 0, 1)

		case.IsPlaying = true
		case:SetScript("OnUpdate", OnUpdate)
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_EMOTE", function(self, event, ...)
		local arg1, arg2, _, _, arg5 = ...
		if arg2 == E.myname and arg5 == E.myname and ITEMS_MSG[arg1] then
			return true
		end
	end)

	local oldScript = RaidBossEmoteFrame:GetScript("OnEvent")
	RaidBossEmoteFrame:SetScript("OnEvent", function(self, event, ...)
		local arg1, arg2, _, _, arg5 = ...
		if event == "CHAT_MSG_RAID_BOSS_EMOTE" and arg2 == E.myname and arg5 == E.myname and ITEMS_MSG[arg1] then
			OpenCase(ITEMS_MSG[arg1])
		else
			if oldScript then
				oldScript(self, event, ...)
			end
		end
	end)
end

local function InitializeCallback()
	addon:Initialize()
end

E:RegisterModule(addon:GetName(), InitializeCallback)