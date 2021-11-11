local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local NP = E:GetModule("NamePlates")

--Lua functions
local unpack = unpack
local abs = math.abs
--WoW API / Variables
local CreateFrame = CreateFrame

function NP:UpdateElement_CastBarOnValueChanged(value)
	local frame = self:GetParent()
	local min, max = self:GetMinMaxValues()
	local unitFrame = frame.UnitFrame
	local isChannel = value < unitFrame.CastBar:GetValue()

	unitFrame.CastBar.value = value
	unitFrame.CastBar.max = max
	unitFrame.CastBar:SetMinMaxValues(min, max)
	unitFrame.CastBar:SetValue(value)

	if isChannel then
		if unitFrame.CastBar.channelTimeFormat == "CURRENT" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f", abs(unitFrame.CastBar.value - unitFrame.CastBar.max))
		elseif unitFrame.CastBar.channelTimeFormat == "CURRENTMAX" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f / %.2f", abs(unitFrame.CastBar.value - unitFrame.CastBar.max), unitFrame.CastBar.max)
		elseif unitFrame.CastBar.channelTimeFormat == "REMAINING" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f", unitFrame.CastBar.value)
		elseif unitFrame.CastBar.channelTimeFormat == "REMAININGMAX" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f / %.2f", unitFrame.CastBar.value, unitFrame.CastBar.max)
		end
	else
		if unitFrame.CastBar.castTimeFormat == "CURRENT" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f", unitFrame.CastBar.value)
		elseif unitFrame.CastBar.castTimeFormat == "CURRENTMAX" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f / %.2f", unitFrame.CastBar.value, unitFrame.CastBar.max)
		elseif unitFrame.CastBar.castTimeFormat == "REMAINING" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f", abs(unitFrame.CastBar.value - unitFrame.CastBar.max))
		elseif unitFrame.CastBar.castTimeFormat == "REMAININGMAX" then
			unitFrame.CastBar.Time:SetFormattedText("%.1f / %.2f", abs(unitFrame.CastBar.value - unitFrame.CastBar.max), unitFrame.CastBar.max)
		end
	end

	local unit = unitFrame.unit or unitFrame.UnitName
	if unit then
		local spell, _, spellName = UnitCastingInfo(unit)
		if not spell then
			_, _, spellName = UnitChannelInfo(unit)
		end
		unitFrame.CastBar.Name:SetText(spellName)
		
	else
		unitFrame.CastBar.Name:SetText("")
	end

	unitFrame.CastBar.Icon.texture:SetTexture(self.Icon:GetTexture())

	if not self.Shield:IsShown() then
		unitFrame.CastBar:SetStatusBarColor(NP.db.colors.castColor.r, NP.db.colors.castColor.g, NP.db.colors.castColor.b)
		unitFrame.CastBar.Icon.texture:SetDesaturated(false)
	else
		unitFrame.CastBar:SetStatusBarColor(NP.db.colors.castNoInterruptColor.r, NP.db.colors.castNoInterruptColor.g, NP.db.colors.castNoInterruptColor.b)

		if NP.db.colors.castbarDesaturate then
			unitFrame.CastBar.Icon.texture:SetDesaturated(true)
		end
	end

	NP:StyleFilterUpdate(unitFrame, "FAKE_Casting")
end

function NP:UpdateElement_CastBarOnShow()
	local parent = self:GetParent()
	local unitFrame = parent.UnitFrame
	if not unitFrame.UnitType then
		return
	end

	if NP.db.units[unitFrame.UnitType].castbar.enable ~= true then return end
	if not unitFrame.Health:IsShown() then return end

	if unitFrame.CastBar then
		unitFrame.CastBar:Show()

		NP:StyleFilterUpdate(unitFrame, "FAKE_Casting")
	end
end

function NP:UpdateElement_CastBarOnHide()
	local parent = self:GetParent()
	if parent.UnitFrame.CastBar then
		parent.UnitFrame.CastBar:Hide()

		NP:StyleFilterUpdate(parent.UnitFrame, "FAKE_Casting")
	end
end

function NP:Construct_CastBar(parent)
	local frame = CreateFrame("StatusBar", "$parentCastBar", parent)
	NP:StyleFrame(frame)

	frame.Icon = CreateFrame("Frame", nil, frame)
	frame.Icon.texture = frame.Icon:CreateTexture(nil, "BORDER")
	frame.Icon.texture:SetAllPoints()
	frame.Icon.texture:SetTexCoord(unpack(E.TexCoords))
	NP:StyleFrame(frame.Icon)

	frame.Time = frame:CreateFontString(nil, "OVERLAY")
	frame.Time:SetJustifyH("RIGHT")
	frame.Time:SetWordWrap(false)

	frame.Name = frame:CreateFontString(nil, "OVERLAY")
	frame.Name:SetJustifyH("LEFT")
	frame.Name:SetWordWrap(false)

	frame.Spark = frame:CreateTexture(nil, "OVERLAY")
	frame.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	frame.Spark:SetBlendMode("ADD")
	frame.Spark:SetSize(15, 15)

	frame.holdTime = 0
	frame.interrupted = nil

	frame.scale = CreateAnimationGroup(frame)
	frame.scale.width = frame.scale:CreateAnimation("Width")
	frame.scale.width:SetDuration(0.2)
	frame.scale.height = frame.scale:CreateAnimation("Height")
	frame.scale.height:SetDuration(0.2)

	frame.Icon.scale = CreateAnimationGroup(frame.Icon)
	frame.Icon.scale.width = frame.Icon.scale:CreateAnimation("Width")
	frame.Icon.scale.width:SetDuration(0.2)
	frame.Icon.scale.height = frame.Icon.scale:CreateAnimation("Height")
	frame.Icon.scale.height:SetDuration(0.2)

	frame:Hide()

	return frame
end