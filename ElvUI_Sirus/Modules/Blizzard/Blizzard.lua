local items = {
	["QuestInfoItem"] = MAX_NUM_ITEMS,
	["QuestProgressItem"] = MAX_REQUIRED_ITEMS
}

QuestFrame:HookScript("OnShow", function(self)
	local frameLevel = self:GetFrameLevel()

	if QuestInfoItem1:GetFrameLevel() <= frameLevel or QuestProgressItem1:GetFrameLevel() <= frameLevel then
		for frame, numItems in pairs(items) do
			for i = 1, numItems do
				_G[frame..i]:SetFrameLevel(frameLevel + 5)
			end
		end
	end
end)