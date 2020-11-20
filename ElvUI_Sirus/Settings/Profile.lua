local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P.auras.buffs.filter = ""
P.auras.debuffs.filter = ""

P.actionbar.microbar.buttonsPerRow = 12

P.chat.maxLines = 999

P.databars.honor = {
	enable = true,
	width = 10,
	height = 180,
	textFormat = "NONE",
	textSize = 11,
	font = "PT Sans Narrow",
	fontOutline = "NONE",
	mouseover = false,
	orientation = "VERTICAL",
	hideInVehicle = false,
	hideInCombat = false
}

-- Sirus
P.sirus = {
	case = true
}

P.datatexts.ArenaRating = {
	[1] = false,
	[2] = true,
	[3] = false,
	[4] = false,
}