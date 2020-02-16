if not LBP_Data then return end

local tinsert = table.insert

-- PALADIN
-- 2 T5
tinsert(LBP_Data.ButtonProcs.PALADIN[1], 307927)

tinsert(SPELLOVERLAY_STORAGE, {nil, {307927}, {24239, 24274, 24275, 27180, 48805, 48806}})


--[[
for i = 307890, 309000 do
	local name = GetSpellInfo(i)
	if name then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffffd000\124Hspell:"..i.."\124h["..name.."]\124h\124r")
	end
end

-- Test

tinsert(LBP_Data.ButtonProcs.PRIEST[1], 48168)
]]
