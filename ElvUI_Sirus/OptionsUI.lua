local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("ElvUI_Sirus")

function S:GetOptions()
	--ActionBars
	E.Options.args.actionbar.args.microbar.args.buttonsPerRow.max = #SHARED_MICROMENU_BUTTONS

	--Skins
	E.Options.args.skins.args.blizzard.args.deathRecap = {
		type = "toggle",
		name = DEATH_RECAP_TITLE_DONT_INFO,
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.guild = {
		type = "toggle",
		name = L["Guild"],
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.losscontrol = {
		type = "toggle",
		name = LOSS_OF_CONTROL,
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.store = {
		type = "toggle",
		name = "Магазин",
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.timer = {
		type = "toggle",
		name = "Таймер",
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.transmogrify = {
		type = "toggle",
		name = "Трансмогрификация",
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.collections = {
		type = "toggle",
		name = "Коллекции",
		desc = L["TOGGLESKIN_DESC"]
	}
	E.Options.args.skins.args.blizzard.args.encounterjournal = {
		type = "toggle",
		name = "Путеводитель",
		desc = L["TOGGLESKIN_DESC"]
	}
end

local EE = E:GetModule("ElvUI_Enhanced", true)
if EE then
	hooksecurefunc(EE, "GetOptions", function()
		local enhanced = E.Options.args.enhanced
		if enhanced then
			enhanced.args.blizzardGroup.args.deathRecap = nil
			enhanced.args.blizzardGroup.args.characterFrame.args.modelFrames = nil
			enhanced.args.blizzardGroup.args.characterFrame.args.paperdollBackgrounds = nil
			enhanced.args.blizzardGroup.args.dressingRoom = nil
			enhanced.args.blizzardGroup.args.timerTracker = nil
		end
	end)
end