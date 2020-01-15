local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:GetModule("Bags")

hooksecurefunc(B, "UpdateSlot", function(_, frame, bagID, slotID)
	if (frame.Bags[bagID] and frame.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not frame.Bags[bagID] or not frame.Bags[bagID][slotID] then return end

	local slot = frame.Bags[bagID][slotID]
	local clink = GetContainerItemLink(bagID, slotID)
	local found
	if clink then
		for i = 1, 3 do
			local _, glink = GetItemGem(clink, i)
			if glink then
				local _, _, itemRarity = GetItemInfo(glink)
				if itemRarity == 5 then
					if not slot.bagNewItemGlow then
						slot.bagNewItemGlow = slot:CreateTexture(nil, "OVERLAY")
						slot.bagNewItemGlow:SetInside()
						slot.bagNewItemGlow:SetTexture([[Interface\AddOns\ElvUI_Sirus\Media\Textures\BagNewItemGlow]])
						slot.bagNewItemGlow:SetVertexColor(GetItemQualityColor(5))
					end

					slot.bagNewItemGlow:Show()
					found = true
					break
				end
			end
		end
	end

	if not found and slot.bagNewItemGlow then
		slot.bagNewItemGlow:Hide()
	end
end)