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

end

S:AddCallback("Sirus_EncounterJournal", LoadSkin)