local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("ElvUI_Sirus")

function S:GetOptions()
	--ActionBars
	E.Options.args.actionbar.args.microbar.args.buttonsPerRow.max = #SHARED_MICROMENU_BUTTONS

	-- Auras
	E.Options.args.auras.args.general.args.spacer = {
		order = 9,
		type = "description",
		name = ""
	}
	E.Options.args.auras.args.general.args.hideCategoryIcon = {
		order = 10,
		type = "toggle",
		name = E.NewSign.."Скрывать категорию"
	}
	E.Options.args.auras.args.general.args.hideVIPIcon = {
		order = 11,
		type = "toggle",
		name = E.NewSign.."Скрывать VIP статус"
	}
	E.Options.args.auras.args.general.args.hidePremiumIcon = {
		order = 12,
		type = "toggle",
		name = E.NewSign.."Скрывать Premium статус"
	}
	E.Options.args.auras.args.general.args.lbf.order = 13

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