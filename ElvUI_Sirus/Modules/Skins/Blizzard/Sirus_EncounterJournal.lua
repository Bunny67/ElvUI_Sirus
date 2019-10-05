local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

local function LoadSkin()
	local EncounterJournal = EncounterJournal
	S:HandlePortraitFrame(EncounterJournal)

	S:HandleEditBox(EncounterJournal.searchBox)

	EncounterJournal.searchBox.searchPreviewContainer:StripTextures()

	for i = 1, 5 do
		local button = EncounterJournal.searchBox["sbutton"..i]
		S:HandleButton(button)
		button.icon:SetTexCoord(unpack(E.TexCoords))

		if i ~= 1 then
			button:Point("TOPLEFT",  EncounterJournal.searchBox["sbutton"..i-1], "BOTTOMLEFT", 0, -E.Border)
			button:Point("TOPRIGHT", EncounterJournal.searchBox["sbutton"..i-1] , "BOTTOMRIGHT", 0, -E.Border)
		end
	end

	S:HandleButton(EncounterJournalSearchBox.showAllResults)
	EncounterJournalSearchBox.showAllResults:Point("TOP", EncounterJournal.searchBox.sbutton5, "BOTTOM", 0, -E.Border)
--	EncounterJournalSearchBox.searchProgress
--	EncounterJournalSearchBox.searchProgress.bar

	EncounterJournal.searchResults:StripTextures()
	EncounterJournal.searchResults:CreateBackdrop()
	S:HandleCloseButton(EncounterJournalSearchResultsCloseButton)
	S:HandleScrollBar(EncounterJournal.searchResults.scrollFrame.scrollBar)

	EncounterJournal.navBar:StripTextures()
	EncounterJournal.navBar.overlay:StripTextures()

	S:HandleButton(EncounterJournal.navBar.home, true)
	EncounterJournal.navBar.home.xoffset = 1

	EncounterJournal.inset:StripTextures()

	EncounterJournal.instanceSelect:StripTextures(true)

	local function SkinTierTab(tab)
		tab:StripTextures(nil, true)
		tab.grayBox:SetAlpha(0)

		tab:SetTemplate("Default", true)

		tab:HookScript("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	SkinTierTab(EncounterJournal.instanceSelect.suggestTab)
	SkinTierTab(EncounterJournal.instanceSelect.dungeonsTab)
	SkinTierTab(EncounterJournal.instanceSelect.raidsTab)
	SkinTierTab(EncounterJournal.instanceSelect.LootJournalTab)

	S:HandleDropDownBox(EncounterJournal.instanceSelect.tierDropDown)

	S:HandleScrollBar(EncounterJournal.instanceSelect.scroll.ScrollBar)

	S:HandleScrollBar(EncounterJournal.encounter.instance.loreScroll.ScrollBar)
	EncounterJournal.encounter.instance.loreScroll.child.lore:SetTextColor(1, 1, 1)

	EncounterJournal.encounter.info:StripTextures(nil, true)

	local function SkinEncounterTab(tab)
		tab:Size(48)
		tab:SetTemplate("Default", true)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetHighlightTexture("")
		tab:SetDisabledTexture("")

		tab.unselected:SetAllPoints()
		tab.selected:SetAllPoints()

		tab:HookScript("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	SkinEncounterTab(EncounterJournal.encounter.info.overviewTab)
	EncounterJournal.encounter.info.overviewTab:Point("TOPLEFT", EncounterJournal.encounter.info, "TOPRIGHT", 9, -35)
	SkinEncounterTab(EncounterJournal.encounter.info.lootTab)
	EncounterJournal.encounter.info.lootTab:Point("TOP", EncounterJournal.encounter.info.overviewTab, "BOTTOM", 0, -1)
	SkinEncounterTab(EncounterJournal.encounter.info.bossTab)
	EncounterJournal.encounter.info.bossTab:Point("TOP", EncounterJournal.encounter.info.lootTab, "BOTTOM", 0, -1)
	SkinEncounterTab(EncounterJournal.encounter.info.modelTab)
	EncounterJournal.encounter.info.modelTab:Point("TOP", EncounterJournal.encounter.info.bossTab, "BOTTOM", 0, -1)

	hooksecurefunc("EncounterJournal_DisplayInstance", function(instanceID)
		local self = EncounterJournal.encounter
		if EncounterJournal_SearchForOverview(instanceID) then
			self.info.modelTab:SetPoint("TOP", self.info.bossTab, "BOTTOM", 0, -1)
		else
			self.info.modelTab:SetPoint("TOP", self.info.lootTab, "BOTTOM", 0, -1)
		end
	end)

	S:HandleScrollBar(EncounterJournal.encounter.info.bossesScroll.ScrollBar)
	EncounterJournal.encounter.info.bossesScroll.child.description:SetTextColor(1, 1, 1)

	S:HandleButton(EncounterJournal.encounter.info.difficulty, true)
	S:HandleButton(EncounterJournal.encounter.info.reset)

	S:HandleScrollBar(EncounterJournal.encounter.info.detailsScroll.ScrollBar)
	EncounterJournal.encounter.info.detailsScroll.child.description:SetTextColor(1, 1, 1)
	S:HandleScrollBar(EncounterJournal.encounter.info.overviewScroll.ScrollBar)
	EncounterJournal.encounter.info.overviewScroll.child.loreDescription:SetTextColor(1, 1, 1)

	S:HandleButton(EncounterJournal.encounter.info.lootScroll.filter, true)
	S:HandleButton(EncounterJournal.encounter.info.lootScroll.slotFilter, true)

	S:HandleScrollBar(EncounterJournal.encounter.info.lootScroll.scrollBar)

	EncounterJournal.LootJournal:StripTextures()
	S:HandleButton(EncounterJournal.LootJournal.ItemSetsScrollFrame.ClassButton, true)
	S:HandleScrollBar(EncounterJournalLootJournalScrollFrameScrollBar)
end

S:AddCallback("Sirus_EncounterJournal", LoadSkin)