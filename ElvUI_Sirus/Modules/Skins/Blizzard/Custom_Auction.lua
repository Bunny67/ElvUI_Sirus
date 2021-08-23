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

		--category buttons (не придумал как сделать по другому пока, он показывает только 20 кнопок на экране максимум и если гортаешь они обновляются) 				
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
	
			--							
--			aucfpanel12:HookScript("OnShow", function(self)
--					S:HandleButton(AuctionHouseFrameBrowseResultsFrameItemListHeaderContainerPoolFrameAuctionHouseTableHeaderStringTemplate4)
--					end)
 

end

S:AddCallback('AuctionHouse', LoadSkin)


--[=[
local function SkinEditBoxes(Frame)
	S:HandleEditBox(Frame.MinLevel)
	S:HandleEditBox(Frame.MaxLevel)
end

local function SkinFilterButton(Button)
	SkinEditBoxes(Button.LevelRangeFrame)

	S:HandleCloseButton(Button.ClearFiltersButton)
	S:HandleButton(Button)
end

local function HandleSearchBarFrame(Frame)
	SkinFilterButton(Frame.FilterButton)

	S:HandleButton(Frame.SearchButton)
	S:HandleEditBox(Frame.SearchBox)
	S:HandleButton(Frame.FavoritesSearchButton)
	Frame.FavoritesSearchButton:Size(22)
end

local function HandleListIcon(frame)
	if not frame.tableBuilder then return end

	for i = 1, 22 do
		local row = frame.tableBuilder.rows[i]
		if row then
			for j = 1, 4 do
				local cell = row.cells and row.cells[j]
				if cell and cell.Icon then
					if not cell.IsSkinned then
						S:HandleIcon(cell.Icon)

						if cell.IconBorder then
							cell.IconBorder:Kill()
						end

						cell.IsSkinned = true
					end
				end
			end
		end
	end
end

local function HandleSummaryIcons(frame)
	for i = 1, 23 do
		local child = select(i, frame.ScrollFrame.scrollChild:GetChildren())

		if child and child.Icon then
			if not child.IsSkinned then
				S:HandleIcon(child.Icon)

				if child.IconBorder then
					child.IconBorder:Kill()
				end

				child.IsSkinned = true
			end
		end
	end
end

local function SkinItemDisplay(frame)
	local ItemDisplay = frame.ItemDisplay
	ItemDisplay:StripTextures()
	ItemDisplay:CreateBackdrop('Transparent')
	ItemDisplay.backdrop:Point('TOPLEFT', 3, -3)
	ItemDisplay.backdrop:Point('BOTTOMRIGHT', -3, 0)

	local ItemButton = ItemDisplay.ItemButton
	ItemButton.CircleMask:Hide()

	-- We skin the new IconBorder from the AH, it looks really cool tbh.
	ItemButton.Icon:SetTexCoord(.08, .92, .08, .92)
	ItemButton.Icon:Size(44)
	ItemButton.IconBorder:SetTexCoord(.08, .92, .08, .92)
end

local function HandleHeaders(frame)
	local maxHeaders = frame.HeaderContainer:GetNumChildren()
	for i = 1, maxHeaders do
		local header = select(i, frame.HeaderContainer:GetChildren())
		if header and not header.IsSkinned then
			header:DisableDrawLayer('BACKGROUND')

			if not header.backdrop then
				header:CreateBackdrop('Transparent')
			end

			header.IsSkinned = true
		end

		if header.backdrop then
			header.backdrop:Point('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
		end
	end

	HandleListIcon(frame)
end

local function HandleAuctionButtons(button)
	S:HandleButton(button)
	button:Size(22)
end

local function HandleSellFrame(frame)
	frame:StripTextures()

	local ItemDisplay = frame.ItemDisplay
	ItemDisplay:StripTextures()
	ItemDisplay:SetTemplate('Transparent')

	local ItemButton = ItemDisplay.ItemButton
	if ItemButton.IconMask then ItemButton.IconMask:Hide() end
	if ItemButton.IconBorder then ItemButton.IconBorder:Kill() end

	ItemButton.EmptyBackground:Hide()
	ItemButton:SetPushedTexture('')
	ItemButton.Highlight:SetColorTexture(1, 1, 1, .25)
	ItemButton.Highlight:SetAllPoints(ItemButton.Icon)

	S:HandleIcon(ItemButton.Icon, true)
	S:HandleEditBox(frame.QuantityInput.InputBox)
	S:HandleButton(frame.QuantityInput.MaxButton)
	S:HandleEditBox(frame.PriceInput.MoneyInputFrame.GoldBox)
	S:HandleEditBox(frame.PriceInput.MoneyInputFrame.SilverBox)

	if frame.SecondaryPriceInput then
		S:HandleEditBox(frame.SecondaryPriceInput.MoneyInputFrame.GoldBox)
		S:HandleEditBox(frame.SecondaryPriceInput.MoneyInputFrame.SilverBox)
	end

	S:HandleDropDownBox(frame.DurationDropDown.DropDown)
	S:HandleButton(frame.PostButton)

	if frame.BuyoutModeCheckButton then
		S:HandleCheckBox(frame.BuyoutModeCheckButton)
		frame.BuyoutModeCheckButton:Size(20)
	end
end

local function HandleTokenSellFrame(frame)
	frame:StripTextures()

	local ItemDisplay = frame.ItemDisplay
	ItemDisplay:StripTextures()
	ItemDisplay:SetTemplate('Transparent')

	local ItemButton = ItemDisplay.ItemButton
	if ItemButton.IconMask then ItemButton.IconMask:Hide() end
	if ItemButton.IconBorder then ItemButton.IconBorder:Kill() end

	ItemButton.EmptyBackground:Hide()
	ItemButton:SetPushedTexture('')
	ItemButton.Highlight:SetColorTexture(1, 1, 1, .25)
	ItemButton.Highlight:SetAllPoints(ItemButton.Icon)

	S:HandleIcon(ItemButton.Icon, true)

	S:HandleButton(frame.PostButton)
	HandleAuctionButtons(frame.DummyRefreshButton)

	frame.DummyItemList:StripTextures()
	frame.DummyItemList:SetTemplate('Transparent')
	HandleAuctionButtons(frame.DummyRefreshButton)
	S:HandleScrollBar(frame.DummyItemList.DummyScrollBar)
end

local function HandleSellList(frame, hasHeader, fitScrollBar)
	frame:StripTextures()

	if frame.RefreshFrame then
		HandleAuctionButtons(frame.RefreshFrame.RefreshButton)
	end

	S:HandleScrollBar(frame.ScrollFrame.scrollBar)

	if fitScrollBar then
		frame.ScrollFrame.scrollBar:ClearAllPoints()
		frame.ScrollFrame.scrollBar:Point('TOPLEFT', frame.ScrollFrame, 'TOPRIGHT', 1, -16)
		frame.ScrollFrame.scrollBar:Point('BOTTOMLEFT', frame.ScrollFrame, 'BOTTOMRIGHT', 1, 16)
	end

	if hasHeader then
		frame.ScrollFrame:SetTemplate('Transparent')
		hooksecurefunc(frame, 'RefreshScrollFrame', HandleHeaders)
	else
		hooksecurefunc(frame, 'RefreshListDisplay', HandleSummaryIcons)
	end
end

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.auctionhouse) then return end

	--[[ Main Frame | TAB 1
	local Frame = _G.AuctionHouseFrame
	S:HandlePortraitFrame(Frame)

	local AuctionHouseTabs = {
		_G.AuctionHouseFrameBuyTab,
		_G.AuctionHouseFrameSellTab,
		_G.AuctionHouseFrameAuctionsTab,
	}

	for _, tab in pairs(AuctionHouseTabs) do
		if tab then
			S:HandleTab(tab)
		end
	end

	_G.AuctionHouseFrameBuyTab:ClearAllPoints()
	_G.AuctionHouseFrameBuyTab:SetPoint('BOTTOMLEFT', Frame, 'BOTTOMLEFT', 0, -30)

	-- SearchBar Frame
	HandleSearchBarFrame(Frame.SearchBar)
	Frame.MoneyFrameBorder:StripTextures()
	Frame.MoneyFrameInset:StripTextures()

	--[[ Categorie List ]]--
	local Categories = Frame.CategoriesList
	Categories.ScrollFrame:StripTextures()
	Categories.Background:Hide()
	Categories.NineSlice:Hide()
	Categories:SetTemplate('Transparent')

	S:HandleScrollBar(_G.AuctionHouseFrameScrollBar)
	_G.AuctionHouseFrameScrollBar:ClearAllPoints()
	_G.AuctionHouseFrameScrollBar:Point('TOPRIGHT', Categories, -5, -22)
	_G.AuctionHouseFrameScrollBar:Point('BOTTOMRIGHT', Categories, -5, 22)

	for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
		local button = Categories.FilterButtons[i]

		button:StripTextures(true)
		button:StyleButton()

		button.SelectedTexture:SetInside(button)
	end

	hooksecurefunc('AuctionFrameFilters_UpdateCategories', function(categoriesList, _)
		for _, button in ipairs(categoriesList.FilterButtons) do
			button.SelectedTexture:SetAtlas(nil)
			button.SelectedTexture:SetColorTexture(0.7, 0.7, 0.7, 0.4)
		end
	end)

	--[[ Browse Frame ]]--
	local Browse = Frame.BrowseResultsFrame

	local BrowseList = Browse.ItemList
	BrowseList:StripTextures()
	hooksecurefunc(BrowseList, 'RefreshScrollFrame', HandleHeaders)
	BrowseList.ResultsText:SetParent(BrowseList.ScrollFrame)
	S:HandleScrollBar(BrowseList.ScrollFrame.scrollBar)
	BrowseList.ScrollFrame:SetTemplate('Transparent')
	BrowseList.ScrollFrame.scrollBar:ClearAllPoints()
	BrowseList.ScrollFrame.scrollBar:Point('TOPLEFT', BrowseList.ScrollFrame, 'TOPRIGHT', 1, -16)
	BrowseList.ScrollFrame.scrollBar:Point('BOTTOMLEFT', BrowseList.ScrollFrame, 'BOTTOMRIGHT', 1, 16)

	--[[ BuyOut Frame]]
	local CommoditiesBuyFrame = Frame.CommoditiesBuyFrame
	CommoditiesBuyFrame.BuyDisplay:StripTextures()
	S:HandleButton(CommoditiesBuyFrame.BackButton)

	local CommoditiesBuyList = Frame.CommoditiesBuyFrame.ItemList
	CommoditiesBuyList:StripTextures()
	CommoditiesBuyList:SetTemplate('Transparent')
	S:HandleButton(CommoditiesBuyList.RefreshFrame.RefreshButton)
	S:HandleScrollBar(CommoditiesBuyList.ScrollFrame.scrollBar)

	local BuyDisplay = Frame.CommoditiesBuyFrame.BuyDisplay
	S:HandleEditBox(BuyDisplay.QuantityInput.InputBox)
	S:HandleButton(BuyDisplay.BuyButton)

	SkinItemDisplay(BuyDisplay)

	--[[ ItemBuyOut Frame]]
	local ItemBuyFrame = Frame.ItemBuyFrame
	S:HandleButton(ItemBuyFrame.BackButton)
	S:HandleButton(ItemBuyFrame.BuyoutFrame.BuyoutButton)

	SkinItemDisplay(ItemBuyFrame)

	local ItemBuyList = ItemBuyFrame.ItemList
	ItemBuyList:StripTextures()
	ItemBuyList:SetTemplate('Transparent')
	S:HandleScrollBar(ItemBuyList.ScrollFrame.scrollBar)
	S:HandleButton(ItemBuyList.RefreshFrame.RefreshButton)
	hooksecurefunc(ItemBuyList, 'RefreshScrollFrame', HandleHeaders)

	local EditBoxes = {
		_G.AuctionHouseFrameGold,
		_G.AuctionHouseFrameSilver,
	}

	for _, EditBox in pairs(EditBoxes) do
		S:HandleEditBox(EditBox)
		--EditBox:SetTextInsets(1, 1, -1, 1)
	end

	S:HandleButton(ItemBuyFrame.BidFrame.BidButton)
	ItemBuyFrame.BidFrame.BidButton:ClearAllPoints()
	ItemBuyFrame.BidFrame.BidButton:Point('LEFT', ItemBuyFrame.BidFrame.BidAmount, 'RIGHT', 2, -2)
	S:HandleButton(ItemBuyFrame.BidFrame.BidButton)

	--[[ Item Sell Frame | TAB 2 ]]--
	local SellFrame = Frame.ItemSellFrame
	HandleSellFrame(SellFrame)
	Frame.ItemSellFrame:SetTemplate('Transparent')

	local ItemSellList = Frame.ItemSellList
	HandleSellList(ItemSellList, true, true)

	local CommoditiesSellFrame = Frame.CommoditiesSellFrame
	HandleSellFrame(CommoditiesSellFrame)

	local CommoditiesSellList = Frame.CommoditiesSellList
	HandleSellList(CommoditiesSellList, true)

	local TokenSellFrame = Frame.WoWTokenSellFrame
	HandleTokenSellFrame(TokenSellFrame)

	--[[ Auctions Frame | TAB 3 ]]--
	local AuctionsFrame = _G.AuctionHouseFrameAuctionsFrame
	AuctionsFrame:StripTextures()
	SkinItemDisplay(AuctionsFrame)
	S:HandleButton(AuctionsFrame.BuyoutFrame.BuyoutButton)

	local CommoditiesList = AuctionsFrame.CommoditiesList
	HandleSellList(CommoditiesList, true)
	S:HandleButton(CommoditiesList.RefreshFrame.RefreshButton)

	local AuctionsList = AuctionsFrame.ItemList
	HandleSellList(AuctionsList, true)
	S:HandleButton(AuctionsList.RefreshFrame.RefreshButton)

	local AuctionsFrameTabs = {
		_G.AuctionHouseFrameAuctionsFrameAuctionsTab,
		_G.AuctionHouseFrameAuctionsFrameBidsTab,
	}

	for _, tab in pairs(AuctionsFrameTabs) do
		if tab then
			S:HandleTab(tab)
		end
	end

	local SummaryList = AuctionsFrame.SummaryList
	HandleSellList(SummaryList)
	SummaryList:SetTemplate('Transparent')
	S:HandleButton(AuctionsFrame.CancelAuctionButton)

	SummaryList.ScrollFrame.scrollBar:ClearAllPoints()
	SummaryList.ScrollFrame.scrollBar:Point('TOPRIGHT', SummaryList, -3, -20)
	SummaryList.ScrollFrame.scrollBar:Point('BOTTOMRIGHT', SummaryList, -3, 20)

	local AllAuctionsList = AuctionsFrame.AllAuctionsList
	HandleSellList(AllAuctionsList, true, true)
	S:HandleButton(AllAuctionsList.RefreshFrame.RefreshButton)
	AllAuctionsList.ResultsText:SetParent(AllAuctionsList.ScrollFrame)

	SummaryList:Point('BOTTOM', AuctionsFrame, 0, 0) -- normally this is anchored to the cancel button.. ? lol
	AuctionsFrame.CancelAuctionButton:ClearAllPoints()
	AuctionsFrame.CancelAuctionButton:Point('TOPRIGHT', AllAuctionsList, 'BOTTOMRIGHT', -6, 1)

	local BidsList = AuctionsFrame.BidsList
	HandleSellList(BidsList, true, true)
	BidsList.ResultsText:SetParent(BidsList.ScrollFrame)
	S:HandleButton(BidsList.RefreshFrame.RefreshButton)
	S:HandleEditBox(_G.AuctionHouseFrameAuctionsFrameGold)
	S:HandleEditBox(_G.AuctionHouseFrameAuctionsFrameSilver)
	S:HandleButton(AuctionsFrame.BidFrame.BidButton)

	--[[ ProgressBars ]]--

	--[[ WoW Token Category ]]--
	local TokenFrame = Frame.WoWTokenResults
	TokenFrame:StripTextures()
	S:HandleButton(TokenFrame.Buyout)
	S:HandleScrollBar(TokenFrame.DummyScrollBar) --MONITOR THIS

	local Token = TokenFrame.TokenDisplay
	Token:StripTextures()
	Token:SetTemplate('Transparent')

	local ItemButton = Token.ItemButton
	S:HandleIcon(ItemButton.Icon, true)
	ItemButton.Icon.backdrop:SetBackdropBorderColor(0, .8, 1)
	ItemButton.IconBorder:Kill()

	--WoW Token Tutorial Frame
	local WowTokenGameTimeTutorial = Frame.WoWTokenResults.GameTimeTutorial
	WowTokenGameTimeTutorial.NineSlice:Hide()
	WowTokenGameTimeTutorial.TitleBg:SetAlpha(0)
	WowTokenGameTimeTutorial:SetTemplate('Transparent')
	S:HandleCloseButton(WowTokenGameTimeTutorial.CloseButton)
	S:HandleButton(WowTokenGameTimeTutorial.RightDisplay.StoreButton)
	WowTokenGameTimeTutorial.Bg:SetAlpha(0)
	WowTokenGameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
	WowTokenGameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, 0, 0)
	WowTokenGameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
	WowTokenGameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, 0, 0)

	--[[ Dialogs ]]--
	Frame.BuyDialog:StripTextures()
	Frame.BuyDialog:SetTemplate('Transparent')
	S:HandleButton(Frame.BuyDialog.BuyNowButton)
	S:HandleButton(Frame.BuyDialog.CancelButton)

	--[[ Multisell thing]]
	local multisellFrame = _G.AuctionHouseMultisellProgressFrame
	multisellFrame:StripTextures()
	multisellFrame:SetTemplate('Transparent')

	local progressBar = multisellFrame.ProgressBar
	progressBar:StripTextures()
	S:HandleIcon(progressBar.Icon)
	progressBar:SetStatusBarTexture(E.Media.normTex)
	progressBar:SetTemplate()

	local close = multisellFrame.CancelButton
	S:HandleCloseButton(close)
end



]=]--