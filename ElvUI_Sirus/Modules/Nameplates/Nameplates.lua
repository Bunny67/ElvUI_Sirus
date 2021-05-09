local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local NP = E:GetModule("NamePlates")

local plateID = 0
function NP:OnCreated(frame)
	plateID = plateID + 1
	local Health, CastBar = frame:GetChildren()
	local Threat, Border, CastBarBorder, CastBarShield, CastBarIcon, Highlight, Name, Level, BossIcon, RaidIcon, EliteIcon = frame:GetRegions()

	local unitFrame = CreateFrame("Frame", format("ElvUI_NamePlate%d", plateID), frame)
	frame.UnitFrame = unitFrame
	unitFrame:Hide()
	unitFrame:SetAllPoints()
	unitFrame.plateID = plateID

	unitFrame.Health = self:Construct_HealthBar(unitFrame)
	unitFrame.Health.Highlight = self:Construct_Highlight(unitFrame)
	unitFrame.CutawayHealth = self:ConstructElement_CutawayHealth(unitFrame)
	unitFrame.Level = self:Construct_Level(unitFrame)
	unitFrame.Name = self:Construct_Name(unitFrame)
	unitFrame.CastBar = self:Construct_CastBar(unitFrame)
	unitFrame.Elite = self:Construct_Elite(unitFrame)
	unitFrame.Buffs = self:ConstructElement_Auras(unitFrame, "Buffs")
	unitFrame.Debuffs = self:ConstructElement_Auras(unitFrame, "Debuffs")
	unitFrame.HealerIcon = self:Construct_HealerIcon(unitFrame)
	unitFrame.CPoints = self:Construct_CPoints(unitFrame)
	unitFrame.IconFrame = self:Construct_IconFrame(unitFrame)
	self:Construct_Glow(unitFrame)

	self:QueueObject(Health)
	self:QueueObject(CastBar)
	self:QueueObject(Level)
	self:QueueObject(Name)
	self:QueueObject(Threat)
	self:QueueObject(Border)
	self:QueueObject(CastBarBorder)
	self:QueueObject(CastBarShield)
	self:QueueObject(Highlight)
	CastBarIcon:SetParent(E.HiddenFrame)
	BossIcon:SetAlpha(0)
	EliteIcon:SetAlpha(0)

	unitFrame.oldHealthBar = Health
	unitFrame.oldCastBar = CastBar
	unitFrame.oldCastBar.Shield = CastBarShield
	unitFrame.oldCastBar.Icon = CastBarIcon
	unitFrame.oldName = Name
	unitFrame.oldHighlight = Highlight
	unitFrame.oldLevel = Level

	unitFrame.Threat = Threat
	RaidIcon:SetParent(unitFrame)
	unitFrame.RaidIcon = RaidIcon

	unitFrame.BossIcon = BossIcon
	unitFrame.EliteIcon = EliteIcon

	self.OnShow(frame, true)
	self:SetSize(frame)

	frame:HookScript("OnShow", self.OnShow)
	frame:HookScript("OnHide", self.OnHide)
	Health:HookScript("OnValueChanged", self.Update_HealthOnValueChanged)
	CastBar:HookScript("OnShow", self.UpdateElement_CastBarOnShow)
	CastBar:HookScript("OnHide", self.UpdateElement_CastBarOnHide)
	CastBar:HookScript("OnValueChanged", self.UpdateElement_CastBarOnValueChanged)

	self.CreatedPlates[frame] = true
	self.VisiblePlates[unitFrame] = 1
end

NP.OnEvent = E.noop
NP.RegisterEvents = E.noop
NP.UnregisterAllEvents = E.noop

function NP:UpdateCVars()
	SetCVar("ShowClassColorInNameplate", "1")
	SetCVar("showVKeyCastbar", "1")
	SetCVar("nameplateAllowOverlap", self.db.motionType == "STACKED" and "0" or "1")
end