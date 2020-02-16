if not LBP_Data then return end

local tinsert = table.insert

-- PALADIN
-- 2 T5
tinsert(LBP_Data.ButtonProcs.PALADIN[1], 307927)
LBP_Data.OverlayProcs.PALADIN[307927] = 4

tinsert(SPELLOVERLAY_STORAGE, {nil, {307927}, {24239, 24274, 24275, 27180, 48805, 48806}})

-- Test
--[[
tinsert(LBP_Data.ButtonProcs.PRIEST[1], 48168)
LBP_Data.OverlayProcs.PRIEST[48168] = 3
LBP_Data.OverlayTextures.PRIEST[3] = {10}
]]