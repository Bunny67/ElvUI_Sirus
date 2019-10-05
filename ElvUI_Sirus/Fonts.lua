local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = E.Libs.LSM

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

	if self.private.general.replaceBlizzFonts then
		SetFont(SystemFont_Med2, NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Outline, NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Outline_Small, NORMAL, self.db.general.fontSize)
	end
end)