local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local RB = E:GetModule("ReminderBuffs")

--Lua functions
--WoW API / Variables

RB.Spell1Buffs = {
	67016, -- Flask of the North (SP)
	67017, -- Flask of the North (AP)
	67018, -- Flask of the North (STR)
	53755, -- Flask of the Frost Wyrm
	53758, -- Flask of Stoneblood
	53760, -- Flask of Endless Rage
	54212, -- Flask of Pure Mojo
	53752, -- Lesser Flask of Toughness (50 Resilience)
	17627, -- Flask of Distilled Wisdom
	270006, -- Настой сопротивления
	270007, -- Настой Драконьего разума
	270008, -- Настой Сила титана
	270009, -- Настой Текущей воды
	270010, -- Настой Стальной Кожи
	270011, -- Настой Крепости

	33721, -- Spellpower Elixir
	53746, -- Wrath Elixir
	28497, -- Elixir of Mighty Agility
	53748, -- Elixir of Mighty Strength
	60346, -- Elixir of Lightning Speed
	60344, -- Elixir of Expertise
	60341, -- Elixir of Deadly Strikes
	60345, -- Elixir of Armor Piercing
	60340, -- Elixir of Accuracy
	53749, -- Guru's Elixir

	60343, -- Elixir of Mighty Defense
	53751, -- Elixir of Mighty Fortitude
	53764, -- Elixir of Mighty Mageblood
	60347, -- Elixir of Mighty Thoughts
	53763, -- Elixir of Protection
	53747, -- Elixir of Spirit
}

RB.Spell2Buffs = {
	57325, -- 80 AP
	57327, -- 46 SP
	57329, -- 40 Critical Strike Rating
	57332, -- 40 Haste Rating
	57334, -- 20 MP5
	57356, -- 40 Expertise Rating
	57358, -- 40 ARP
	57360, -- 40 Hit Rating
	57363, -- Tracking Humanoids
	57365, -- 40 Spirit
	57367, -- 40 AGI
	57371, -- 40 STR
	57373, -- Tracking Beasts
	57399, -- 80 AP, 46 SP
	59230, -- 40 Dodge Rating
	65247, -- 20 STR
}

RB.Spell3Buffs = {
	72588, -- Gift of the Wild
	48469, -- Mark of the Wild
}

RB.Spell4Buffs = {
	25898, -- Greater Blessing of Kings
	20217, -- Blessing of Kings
	72586, -- Blessing of Forgotten Kings
}

RB.CasterSpell5Buffs = {
	61316, -- Dalaran Brilliance
	43002, -- Arcane Brilliance
	42995, -- Arcane Intellect
}

RB.MeleeSpell5Buffs = {
	48162, -- Prayer of Fortitude
	48161, -- Power Word: Fortitude
	72590, -- Fortitude
}

RB.CasterSpell6Buffs = {
	48938, -- Greater Blessing of Wisdom
	48936, -- Blessing of Wisdom
	58777, -- Mana Spring
}

RB.MeleeSpell6Buffs = {
	48934, -- Greater Blessing of Might
	48932, -- Blessing of Might
	47436, -- Battle Shout
}