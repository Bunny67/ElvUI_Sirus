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
					AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameGoldBox:Width(70)
					AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameGoldBox:Height(20)

					S:HandleEditBox(AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameSilverBox)
					AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameSilverBox:Width(70)
					AuctionHouseFrameItemSellFramePriceInputMoneyInputFrameSilverBox:Height(20)
					--
					S:HandleEditBox(AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameGoldBox)
					AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameGoldBox:Width(70)
					AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameGoldBox:Height(20)

					S:HandleEditBox(AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameSilverBox)	
					AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameSilverBox:Width(70)
					AuctionHouseFrameItemSellFrameSecondaryPriceInputMoneyInputFrameSilverBox:Height(20)
					
				--2nd
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFrameQuantityInputInputBox)
					AuctionHouseFrameCommoditiesSellFrameQuantityInputInputBox:Width(70)
					AuctionHouseFrameCommoditiesSellFrameQuantityInputInputBox:Height(20)
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameGoldBox)
					AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameGoldBox:Width(70)
					AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameGoldBox:Height(20)
					S:HandleEditBox(AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameSilverBox)
					AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameSilverBox:Width(70)
					AuctionHouseFrameCommoditiesSellFramePriceInputMoneyInputFrameSilverBox:Height(20)
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

		--category buttons (�� �������� ��� ������� �� ������� ����, �� ���������� ������ 20 ������ �� ������ �������� � ���� �������� ��� �����������) 				
			local function buttonsleft_OnShow(self)
				for i = 1,20 do
					S:HandleButton(_G["AuctionHouseFrameCategoriesListAuctionFilterButton"..i])
				end
			end
			AuctionHouseFrameCategoriesListScrollFrame:HookScript("OnShow", buttonsleft_OnShow)
		--hooksecurefunc
		local function firtab_OnShow(self)
			for i = 1,4 do
				S:HandleButton(_G["AuctionHouseFrameBrowseResultsFrameItemListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate"..i])		
			end			
		end

		local function secftab_OnShow(self)
			for i = 1,2 do
				S:HandleButton(_G["AuctionHouseFrameItemSellListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate"..i])		
			end	
		end

		local function secstab_OnShow(self)
			for i = 1,2 do
				S:HandleButton(_G["AuctionHouseFrameCommoditiesSellListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate"..i])		
			end	
		end

		local function thtab_OnShow(self)
			for i = 1,4 do
				S:HandleButton(_G["AuctionHouseFrameAuctionsFrameAllAuctionsListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate"..i])		
			end	
		end

		local function fortab_OnShow(self)
			for i = 1,3 do
				S:HandleButton(_G["AuctionHouseFrameAuctionsFrameBidsListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate"..i])		
			end	
		end		
		
		local aucfpanel1 =	AuctionHouseFrame 
			aucfpanel1:HookScript("OnShow", firtab_OnShow)			
		local aucfpanel2 = AuctionHouseFrameItemSellListHeaderContainer
			aucfpanel2:SetScript("OnShow", secftab_OnShow)
			--aucfpanel2:HookScript("OnShow", secftab_OnShow)
		local aucfpanel3 = AuctionHouseFrameCommoditiesSellFrame
			aucfpanel3:HookScript("OnShow", secstab_OnShow)
		local aucfpanel4 = AuctionHouseFrameAuctionsFrameAllAuctionsListHeaderContainer
			aucfpanel4:HookScript("OnShow", thtab_OnShow)
		local aucfpanel5 = AuctionHouseFrameAuctionsFrameBidsListHeaderContainer
			aucfpanel5:HookScript("OnShow", fortab_OnShow)	
end

S:AddCallback('AuctionHouse', LoadSkin)

