local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

local _G = _G
local pairs, ipairs, select = pairs, ipairs, select
local hooksecurefunc = hooksecurefunc
local unpack = unpack




local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse then return end
	--tab
	S:HandleTab(AuctionHouseFrameBuyTab)
	S:HandleTab(AuctionHouseFrameSellTab)
	S:HandleTab(AuctionHouseFrameAuctionsTab)

		--buy tab
			--frames
				AuctionHouseFrame:StripTextures()
				AuctionHouseFrame:CreateBackdrop("Transparent")
				--browseframe
					AuctionHouseFrameBrowseResultsFrameItemListScrollFrame:StripTextures()
					AuctionHouseFrameBrowseResultsFrameItemListScrollFrame:CreateBackdrop("Transparent")
					AuctionHouseFrameBrowseResultsFrameItemList:StripTextures()
					AuctionHouseFrameBrowseResultsFrameItemListNineSlice:StripTextures()
				--money
					AuctionHouseFrameMoneyFrame:StripTextures()	
					--AuctionHouseFrameMoneyFrame:CreateBackdrop("Transparent")
					AuctionHouseFrameMoneyFrameBorder:StripTextures()	
					AuctionHouseFrameMoneyFrameBorderMoneyFrame:StripTextures()	
				--category
					AuctionHouseFrameCategoriesListNineSlice:StripTextures()	
					AuctionHouseFrameCategoriesList:StripTextures()	
					--AuctionHouseFrameCategoriesListScrollFrameScrollChildFrame:StripTextures()	
					--AuctionHouseFrameCategoriesListScrollFrameScrollChildFrame:CreateBackdrop("Transparent")
					AuctionHouseFrameCategoriesListScrollFrame:StripTextures()
			--scrollbar
				AuctionHouseFrameCategoriesListScrollFrameScrollBar:StripTextures()	
				S:HandleScrollBar(AuctionHouseFrameBrowseResultsFrameItemListScrollFrameScrollBar)
				S:HandleScrollBar(AuctionHouseFrameCategoriesListScrollFrameScrollBar)
			--button
				S:HandleButton(AuctionHouseFrameSearchBarSearchButton, true)
				AuctionHouseFrameSearchBarFilterButton:StripTextures(true)
				S:HandleButton(AuctionHouseFrameSearchBarFilterButton, true)
				S:HandleCloseButton(AuctionHouseFrameCloseButton)
				S:HandleButton(AuctionHouseFrameSearchBarFavoritesSearchButton)
			--Search
				AuctionHouseFrameSearchBarSearchBox:StripTextures(true)
				S:HandleEditBox(AuctionHouseFrameSearchBarSearchBox)			
			--category buttons (не придумал как сделать по другому пока, он показывает только 20 кнопок на экране максимум и если гортаешь они обновляются) 
				for i = 1, 20, 1 do 
				S:HandleButton(_G["AuctionHouseFrameCategoriesListAuctionFilterButton"..i])
				end
		--sell tab
			--frames
				--right side
					--first look(next 1st)
					AuctionHouseFrameItemSellListScrollFrame:StripTextures()
					AuctionHouseFrameItemSellListScrollFrame:CreateBackdrop("Transparent")
					AuctionHouseFrameItemSellList:StripTextures()
					AuctionHouseFrameItemSellListNineSlice:StripTextures()
					-- when has item(next 2nd)
					AuctionHouseFrameCommoditiesSellListScrollFrame:StripTextures()
					AuctionHouseFrameCommoditiesSellListScrollFrame:CreateBackdrop("Transparent")
					AuctionHouseFrameCommoditiesSellList:StripTextures()
					AuctionHouseFrameCommoditiesSellListNineSlice:StripTextures()
				--leftside
					--1st			
						AuctionHouseFrameItemSellFrameOverlay:StripTextures()
						AuctionHouseFrameItemSellFrame:StripTextures()
						AuctionHouseFrameItemSellFrame:CreateBackdrop("Transparent")
						AuctionHouseFrameItemSellFrameNineSlice:StripTextures()
							--topleft
								AuctionHouseFrameItemSellFrameItemDisplay:StripTextures()
								AuctionHouseFrameItemSellFrameItemDisplay:CreateBackdrop("Transparent")
							--button								
								S:HandleButton(AuctionHouseFrameItemSellFrameItemDisplayItemButton)
					--2nd
						AuctionHouseFrameCommoditiesSellFrameOverlay:StripTextures()
						AuctionHouseFrameCommoditiesSellFrame:StripTextures()
						AuctionHouseFrameCommoditiesSellFrame:CreateBackdrop("Transparent")
						AuctionHouseFrameCommoditiesSellFrameNineSlice:StripTextures()
							--topleft
								AuctionHouseFrameCommoditiesSellFrameItemDisplay:StripTextures()
								AuctionHouseFrameCommoditiesSellFrameItemDisplay:CreateBackdrop("Transparent")
							--button								
								S:HandleButton(AuctionHouseFrameCommoditiesSellFrameItemDisplayItemButton)
			--scrollbar
				--1st
					S:HandleScrollBar(AuctionHouseFrameItemSellListScrollFrameScrollBar)
				--2nd
					S:HandleScrollBar(AuctionHouseFrameCommoditiesSellListScrollFrameScrollBar)
			--button
				S:HandleButton(AuctionHouseFrame.CommoditiesSellFrame.PostButton)
				S:HandleButton(AuctionHouseFrame.ItemSellFrame.PostButton)
				S:HandleButton(AuctionHouseFrameItemSellFrameQuantityInputMaxButton)
				S:HandleButton(AuctionHouseFrameCommoditiesSellFrameQuantityInputMaxButton)
				--refresh
					S:HandleButton(AuctionHouseFrameItemSellListRefreshFrameRefreshButton)
					S:HandleButton(AuctionHouseFrameCommoditiesSellListRefreshFrameRefreshButton)
			--dropdown
				S:HandleDropDownBox(AuctionHouseFrameItemSellFrameDurationDropDownDropDown)
				local dropdownArrowColor = {1, 0.8, 0}
				S:HandleNextPrevButton(AuctionHouseFrameItemSellFrameDurationDropDownDropDownButton, "down", dropdownArrowColor)
				AuctionHouseFrameItemSellFrameDurationDropDownDropDownButton:Size(23)
			--CommoditiesSellFrame
				S:HandleDropDownBox(AuctionHouseFrameCommoditiesSellFrameDurationDropDownDropDown)
				local dropdownArrowColor = {1, 0.8, 0}
				S:HandleNextPrevButton(AuctionHouseFrameCommoditiesSellFrameDurationDropDownDropDownButton, "down", dropdownArrowColor)
				AuctionHouseFrameCommoditiesSellFrameDurationDropDownDropDownButton:Size(23)
			--check
				S:HandleCheckBox(AuctionHouseFrameItemSellFrameBuyoutModeCheckButton)
			--editbox
				--1st
					S:HandleEditBox(AuctionHouseFrameItemSellFrameQuantityInputInputBox)
					S:HandleEditBox(AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameGoldBox)
					S:HandleEditBox(AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameSilverBox)
					--
					S:HandleEditBox(AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameGoldBox)
					S:HandleEditBox(AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameSilverBox)			
				--2nd
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFrameQuantityInputInputBox)
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameGoldBox)
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameSilverBox)
		--lot tab
			--tabs	
				S:HandleTab(AuctionHouseFrameAuctionsFrameAuctionsTab)
				S:HandleTab(AuctionHouseFrameAuctionsFrameBidsTab)
					--lots
						--scrollbar
							--left
								S:HandleScrollBar(AuctionHouseFrameAuctionsFrameSummaryListScrollFrameScrollBar)
							--right
								S:HandleScrollBar(AuctionHouseFrameAuctionsFrameAllAuctionsListScrollFrameScrollBar)
						--Button
							S:HandleButton(AuctionHouseFrameAuctionsFrameCancelAuctionButton)
							S:HandleButton(AuctionHouseFrameAuctionsFrameAllAuctionsListRefreshFrameRefreshButton)
							
						--frames
							--left
								AuctionHouseFrameAuctionsFrameSummaryListScrollFrameArtOverlay:StripTextures()
								AuctionHouseFrameAuctionsFrameSummaryListScrollFrameArtOverlay:CreateBackdrop("Transparent")
								AuctionHouseFrameAuctionsFrameSummaryList:StripTextures()
								AuctionHouseFrameAuctionsFrameSummaryListNineSlice:StripTextures()
							--right
								AuctionHouseFrameAuctionsFrameAllAuctionsListScrollFrame:StripTextures()
								AuctionHouseFrameAuctionsFrameAllAuctionsListScrollFrame:CreateBackdrop("Transparent")
								AuctionHouseFrameAuctionsFrameAllAuctionsList:StripTextures()
								AuctionHouseFrameAuctionsFrameAllAuctionsListNineSlice:StripTextures()
					--bids
						--scrolbar
							--only right
								S:HandleScrollBar(AuctionHouseFrameAuctionsFrameBidsListScrollFrameScrollBar)
						--Button
							S:HandleButton(AuctionHouseFrameAuctionsFrameBidsListRefreshFrameRefreshButton)
							S:HandleButton(AuctionHouseFrameAuctionsFrameBidFrameBidButton)
							S:HandleButton(AuctionHouseFrameAuctionsFrameBuyoutFrameBuyoutButton)
						--editbox
							S:HandleEditBox(AuctionHouseFrameAuctionsFrameBidFrameBidAmountGold)
							S:HandleEditBox(AuctionHouseFrameAuctionsFrameBidFrameBidAmountSilver)
							--frames
							AuctionHouseFrameAuctionsFrameBidsListScrollFrame:StripTextures()
							AuctionHouseFrameAuctionsFrameBidsListScrollFrame:CreateBackdrop("Transparent")
							AuctionHouseFrameAuctionsFrameBidsList:StripTextures()
							AuctionHouseFrameAuctionsFrameBidsListNineSlice:StripTextures()
	--hooksecurefunc

	
	
	
end

S:AddCallback('AuctionHouse', LoadSkin)