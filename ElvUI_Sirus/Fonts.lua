local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--Lua functions
--WoW API / Variables

local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
	if not obj then return end

	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb, sa) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

hooksecurefunc(E, "UpdateBlizzardFonts", function(self)
	local NORMAL = self.media.normFont
	local MONOCHROME = ""

	if self.db.general.font == "Homespun" then
		MONOCHROME = "MONOCHROME"
	end

	if self.private.general.replaceBlizzFonts then
		SetFont(GameFontNormal11, NORMAL, self.db.general.fontSize)
		SetFont(GameFontNormal12, NORMAL, self.db.general.fontSize)
		SetFont(GameFontNormal13, NORMAL, self.db.general.fontSize)
		SetFont(GameFontNormal17, NORMAL, 18)
		SetFont(SystemFont_Med2, NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Outline, NORMAL, self.db.general.fontSize, MONOCHROME.."OUTLINE")
		SetFont(SystemFont_Shadow_Med1, NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Shadow_Med2, NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Shadow_Med3, NORMAL, self.db.general.fontSize*1.1)
		SetFont(QuestFont_Super_Huge, NORMAL, 22)
		SetFont(Fancy15Font, NORMAL, 16)
		SetFont(Fancy16Font, NORMAL, 16)
		SetFont(Fancy17Font, NORMAL, 18)
		SetFont(QuestFont15, NORMAL, 16)
	end
end)