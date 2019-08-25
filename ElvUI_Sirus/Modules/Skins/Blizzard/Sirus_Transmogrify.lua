local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.transmogrify ~= true then return end

	S:HandlePortraitFrame(TransmogrifyFrame)
	S:HandleCloseButton(TransmogrifyFrameCloseButton)
	TransmogrifyFrameArt:StripTextures()

	S:HandleRotateButton(TransmogrifyModelFrameRotateLeftButton)
	S:HandleRotateButton(TransmogrifyModelFrameRotateRightButton)
	TransmogrifyModelFrameRotateRightButton:Point("TOPLEFT", TransmogrifyModelFrameRotateLeftButton, "TOPRIGHT", 5, 0)

	local slots = {
		"HeadSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot"
	}

	for i, slot in pairs(slots) do
		local button = _G["TransmogrifyFrame"..slot]
		button:SetTemplate()
		button:StyleButton()

		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:SetInside()
		button.icon:SetDrawLayer("BORDER")
		button.altTexture:SetAlpha(0)

		_G["TransmogrifyFrame"..slot.."Border"]:SetAlpha(0)
		_G["TransmogrifyFrame"..slot.."Grabber"]:SetAlpha(0)
	end

	S:HandleButton(TransmogrifyApplyButton, true)
	TransmogrifyFrameButtonFrame:StripTextures()
end

S:AddCallback("Sirus_Transmogrify", LoadSkin)