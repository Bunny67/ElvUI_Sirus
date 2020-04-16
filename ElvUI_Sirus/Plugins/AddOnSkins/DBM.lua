if DBM and DBM.Version then return end

local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local find, gsub = string.find, string.gsub

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

-- Deadly Boss Mods 4.52 r4442
-- https://www.curseforge.com/wow/addons/deadly-boss-mods/files/447605

local function LoadSkin()
	if not E.private.addOnSkins or not E.private.addOnSkins.DBM then return end

	local function createIconOverlay(id, parent)
		local frame = CreateFrame("Frame", "$parentIcon" .. id .. "Overlay", parent)
		frame:SetTemplate()

		if id == 1 then
			frame:Point("RIGHT", parent, "LEFT", -(E.Border + E.Spacing), 0)
		else
			frame:Point("LEFT", parent, "RIGHT", (E.Border + E.Spacing), 0)
		end

		local backdroptex = frame:CreateTexture(nil, "BORDER")
		backdroptex:SetTexture("Interface\\Icons\\Spell_Nature_WispSplode")
		backdroptex:SetInside(frame)
		backdroptex:SetTexCoord(unpack(E.TexCoords))

		return frame
	end

	local function applyStyle(self)
		local db = E.db.addOnSkins

		local frame = self.frame
		local frameName = frame:GetName()
		local bar = _G[frameName .. "Bar"]
		local background = _G[frameName .. "BarBackground"]
		local icon1 = _G[frameName .. "BarIcon1"]
		local icon2 = _G[frameName .. "BarIcon2"]
		local name = _G[frameName .. "BarName"]
		local timer = _G[frameName .. "BarTimer"]
		local spark = _G[frameName .. "BarSpark"]

		local barOptions = self.owner.options
		local barScale = self.enlarged and barOptions.HugeScale or barOptions.Scale
		local barHeight, barWidth = barOptions.Height * barScale, (self.enlarged and barOptions.HugeWidth or barOptions.Width) * barScale
		local barFont, barFontSize, barFontFlag = barOptions.Font, barOptions.FontSize * barScale, barOptions.FontFlag

		background:Hide()
		spark:Kill()

		if not icon1.overlay then
			icon1.overlay = createIconOverlay(1, frame)
			icon1:SetTexCoord(unpack(E.TexCoords))
			icon1:SetParent(icon1.overlay)
			icon1:SetInside(icon1.overlay)
		end
		if not icon2.overlay then
			icon2.overlay = createIconOverlay(2, frame)
			icon2:SetTexCoord(unpack(E.TexCoords))
			icon2:SetParent(icon2.overlay)
			icon2:SetInside(icon2.overlay)
		end

		frame:SetScale(1)
		frame:SetTemplate(db.dbmTemplate)

		bar:SetInside(frame)

		frame:Size(barWidth, barHeight)

		icon1.overlay:Size(barHeight)
		icon2.overlay:Size(barHeight)

		name:Point("LEFT", 5, 0)
		name:SetFont(barFont, barFontSize, barFontFlag)

		timer:Point("RIGHT", -5, 0)
		timer:SetFont(barFont, barFontSize, barFontFlag)

		if barOptions.IconLeft then
			icon1.overlay:Show()
		else
			icon1.overlay:Hide()
		end

		if barOptions.IconRight then
			icon2.overlay:Show()
		else
			icon2.overlay:Hide()
		end
	end

	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				hooksecurefunc(bar, "ApplyStyle", applyStyle)

				bar.injected = true

				bar:ApplyStyle()
			end
		end
	end

	local function SkinBoss()
		local db = E.db.addOnSkins

		local count = 1
		local bar = _G["DBM_BossHealth_Bar_" .. count]
		local barName, background, progress, name, timer
		local point1, anchor, point2

		while bar do
			point1, anchor, point2 = bar:GetPoint()
			if not point1 then return end

			barName = bar:GetName()
			background = _G[barName .. "BarBorder"]
			progress = _G[barName .. "Bar"]
			name = _G[barName .. "BarName"]
			timer = _G[barName .. "BarTimer"]

			bar:ClearAllPoints()

			bar:Height(db.dbmBarHeight)
			bar:SetTemplate("Transparent")

			background:SetNormalTexture(nil)

			progress:SetStatusBarTexture(E["media"].normTex)
			progress:ClearAllPoints()
			progress:SetInside(bar)

			name:ClearAllPoints()
			name:Point("LEFT", bar, "LEFT", 4, 0)
			name:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline)

			timer:ClearAllPoints()
			timer:Point("RIGHT", bar, "RIGHT", -4, 0)
			timer:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline)

			if DBM.Options.HealthFrameGrowUp then
				bar:Point(point1, anchor, point2, 0, count == 1 and 8 or 4)
			else
				bar:Point(point1, anchor, point2, 0, -(count == 1 and 8 or 4))
			end

			count = count + 1
			bar = _G["DBM_BossHealth_Bar_" .. count]
		end
	end

	hooksecurefunc(DBT, "CreateBar", SkinBars)
	hooksecurefunc(DBM.BossHealth, "Show", SkinBoss)
	hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)

	S:SecureHook(DBM.RangeCheck, "Show", function(self)
		DBMRangeCheck:SetTemplate("Transparent")
	end)
end

local function LoadOptionsSkin()
	if not E.private.addOnSkins or not E.private.addOnSkins.DBM then return end

	DBM_GUI_OptionsFrame:HookScript("OnShow", function(self)
		self:StripTextures()
		self:SetTemplate("Transparent")
		DBM_GUI_OptionsFrameBossMods:StripTextures()
		DBM_GUI_OptionsFrameBossMods:SetTemplate("Transparent")
		DBM_GUI_OptionsFrameDBMOptions:StripTextures()
		DBM_GUI_OptionsFrameDBMOptions:SetTemplate("Transparent")
		DBM_GUI_OptionsFramePanelContainer:SetTemplate("Transparent")
	end)

	S:HandleButton(DBM_GUI_OptionsFrameOkay)
	S:HandleScrollBar(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)

	S:HandleTab(DBM_GUI_OptionsFrameTab1)
	S:HandleTab(DBM_GUI_OptionsFrameTab2)
end

S:RemoveCallbackForAddon("DBM-Core", "DBM-Core")
S:RemoveCallbackForAddon("DBM-GUI", "DBM-GUI")
S:AddCallbackForAddon("DBM-Core", "DBM-Core", LoadSkin)
S:AddCallbackForAddon("DBM-GUI", "DBM-GUI", LoadOptionsSkin)