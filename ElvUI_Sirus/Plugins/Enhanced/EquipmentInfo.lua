if not IsAddOnLoaded("ElvUI_Enhanced") then return end

local E, L, V, P, G = unpack(ElvUI)
local EI = E:GetModule("Enhanced_EquipmentInfo")

local _G = _G
local format = string.format
local pairs = pairs

local slots = {
	["HeadSlot"] = true,
	["NeckSlot"] = false,
	["ShoulderSlot"] = true,
	["BackSlot"] = false,
	["ChestSlot"] = true,
--	["ShirtSlot"] = false,
--	["TabardSlot"] = false,
	["WristSlot"] = true,
	["HandsSlot"] = true,
	["WaistSlot"] = true,
	["LegsSlot"] = true,
	["FeetSlot"] = true,
	["Finger0Slot"] = false,
	["Finger1Slot"] = false,
	["Trinket0Slot"] = false,
	["Trinket1Slot"] = false,
	["MainHandSlot"] = true,
	["SecondaryHandSlot"] = true,
	["RangedSlot"] = true,
--	["AmmoSlot"] = false,
}

function EI:UpdatePaperDoll(unit)
	if not self.initialized then return end

	if unit == "player" and InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
		return
	elseif unit ~= "player" then
		if InspectFrame then
			unit = InspectFrame.unit

			if not unit then return end
		else
			return
		end
	end

	local baseName = unit == "player" and "Character" or "Inspect"
	local frame, slotID, itemLink
	local _, rarity, itemLevel
	local current, maximum, r, g, b

	for slotName, durability in pairs(slots) do
		frame = _G[format("%s%s", baseName, slotName)]

		if frame then
			slotID = GetInventorySlotInfo(slotName)

			frame.ItemLevel:SetText()

			if E.db.enhanced.equipment.itemlevel.enable then
				itemLink = GetInventoryItemLink(unit, slotID)
print(itemLink)
				if itemLink then
					_, _, rarity, itemLevel = GetItemInfo(itemLink)

					if itemLevel then
						frame.ItemLevel:SetText(itemLevel)

						if E.db.enhanced.equipment.itemlevel.qualityColor then
							frame.ItemLevel:SetTextColor()
							if rarity and rarity > 1 then
								frame.ItemLevel:SetTextColor(GetItemQualityColor(rarity))
							else
								frame.ItemLevel:SetTextColor(1, 1, 1)
							end
						else
							frame.ItemLevel:SetTextColor(1, 1, 1)
						end
					end
				end
			end

			if unit == "player" and durability then
				frame.DurabilityInfo:SetText()

				if E.db.enhanced.equipment.durability.enable then
					current, maximum = GetInventoryItemDurability(slotID)

					if current and maximum and (not E.db.enhanced.equipment.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end
			end
		end
	end
end