local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local ipairs = ipairs
local tremove = table.remove
--WoW API / Variables

function S:HandleInsetFrame(frame)
	assert(frame, "doesn't exist!")

	if frame.InsetBorderTop then frame.InsetBorderTop:Hide() end
	if frame.InsetBorderTopLeft then frame.InsetBorderTopLeft:Hide() end
	if frame.InsetBorderTopRight then frame.InsetBorderTopRight:Hide() end

	if frame.InsetBorderBottom then frame.InsetBorderBottom:Hide() end
	if frame.InsetBorderBottomLeft then frame.InsetBorderBottomLeft:Hide() end
	if frame.InsetBorderBottomRight then frame.InsetBorderBottomRight:Hide() end

	if frame.InsetBorderLeft then frame.InsetBorderLeft:Hide() end
	if frame.InsetBorderRight then frame.InsetBorderRight:Hide() end

	if frame.Bgs then frame.Bgs:Hide() end
end

-- All frames that have a Portrait
function S:HandlePortraitFrame(frame, setBackdrop)
	assert(frame, "doesn't exist!")

	local name = frame and frame.GetName and frame:GetName()
	local insetFrame = name and _G[name.."Inset"] or frame.Inset
	local portraitFrame = name and _G[name.."Portrait"] or frame.Portrait or frame.portrait
	local portraitFrameOverlay = name and _G[name.."PortraitOverlay"] or frame.PortraitOverlay
	local artFrameOverlay = name and _G[name.."ArtOverlayFrame"] or frame.ArtOverlayFrame
	local nineSliceFrame = name and _G[name.."NineSlice"] or frame.NineSlice

	frame:StripTextures()

	if portraitFrame then portraitFrame:SetAlpha(0) end
	if portraitFrameOverlay then portraitFrameOverlay:SetAlpha(0) end
	if artFrameOverlay then artFrameOverlay:SetAlpha(0) end
	if nineSliceFrame then nineSliceFrame:StripTextures() end

	if insetFrame then
		S:HandleInsetFrame(insetFrame)
	end

	if frame.CloseButton then
		S:HandleCloseButton(frame.CloseButton)
	end

	if setBackdrop then
		frame:CreateBackdrop("Transparent")
		frame.backdrop:SetAllPoints()
	else
		frame:SetTemplate("Transparent")
	end
end

function S:HandleMaxMinFrame(frame)
	if frame.isSkinned then return end
	assert(frame, "does not exist.")

	frame:StripTextures(true)

	for name, direction in pairs ({["MaximizeButton"] = "up", ["MinimizeButton"] = "down"}) do
		local button = frame[name]

		if button then
			button:Size(26, 26)
			button:ClearAllPoints()
			button:Point("CENTER")
			button:GetHighlightTexture():Kill()

			button:SetScript("OnEnter", function(self)
				self:GetNormalTexture():SetVertexColor(unpack(E.media.rgbvaluecolor))
				self:GetPushedTexture():SetVertexColor(unpack(E.media.rgbvaluecolor))
			end)

			button:SetScript("OnLeave", function(self)
				self:GetNormalTexture():SetVertexColor(1, 1, 1)
				self:GetPushedTexture():SetVertexColor(1, 1, 1)
			end)

			button:SetNormalTexture(E.Media.Textures.ArrowUp)
			button:GetNormalTexture():SetRotation(S.ArrowRotation[direction])

			button:SetPushedTexture(E.Media.Textures.ArrowUp)
			button:GetPushedTexture():SetRotation(S.ArrowRotation[direction])
		end
	end

	frame.isSkinned = true
end

function S:HandleRotateButton(btn)
	if btn.isSkinned then return end

	btn:SetTemplate()

	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)

	local normTex = btn:GetNormalTexture()
	local pushTex = btn:GetPushedTexture()
	local highlightTex = btn:GetHighlightTexture()

	normTex:SetInside()
	pushTex:SetAllPoints(normTex)

	local name = btn:GetName()
	if name then
		normTex:SetTexture("Interface\\Common\\UI-ModelControlPanel")
		pushTex:SetTexture("Interface\\Common\\UI-ModelControlPanel")

		if string.find(name, "Right") then
			normTex:SetTexCoord(0.57812500, 0.82812500, 0.28906250, 0.41406250)
			pushTex:SetTexCoord(0.57812500, 0.82812500, 0.28906250, 0.41406250)
		else
			normTex:SetTexCoord(0.01562500, 0.26562500, 0.28906250, 0.41406250)
			pushTex:SetTexCoord(0.01562500, 0.26562500, 0.28906250, 0.41406250)
		end
	else
		normTex:SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
		pushTex:SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	end

	local highlightTex = btn:GetHighlightTexture()
	highlightTex:SetAllPoints(normTex)
	highlightTex:SetTexture(1, 1, 1, 0.3)

	btn.isSkinned = true
end

function S:HandleControlButton(button)
	button:Size(18)

	S:HandleButton(button)

	button.bg:SetAlpha(0)
	button.icon:SetInside()
	select(3, button:GetRegions()):Hide()
end

function S:HandleControlFrame(frame)
	local name = frame:GetName()
	frame:StripTextures()
	frame:Width(58)

	local rightButton = _G[name.."RotateRightButton"]
	local resetButton = _G[name.."RotateResetButton"]

	S:HandleControlButton(_G[name.."RotateLeftButton"])
	S:HandleControlButton(rightButton)
	S:HandleControlButton(resetButton)

	rightButton:Point("LEFT", "$parentRotateLeftButton", "RIGHT", 2, 0)
	resetButton:Point("LEFT", "$parentRotateRightButton", "RIGHT", 2, 0)
end

function S:RemoveCallback(eventName)
	if not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #1 to S:RemoveCallback (string expected)")
		return
	elseif not self.nonAddonCallbacks[eventName] then
		E:Print("Invalid 'eventName' #1 to S:RemoveCallback ", eventName)
		return
	end

	self.nonAddonCallbacks[eventName] = nil
	for index, event in ipairs(self.nonAddonCallbacks.CallPriority) do
		if event == eventName then
			tremove(self.nonAddonCallbacks.CallPriority, index)
		end
	end
	E.UnregisterCallback(S, eventName)
end

function S:RemoveCallbackForAddon(addonName, eventName)
	if not addonName or type(addonName) ~= "string" then
		E:Print("Invalid argument #1 to S:RemoveCallbackForAddon (string expected)")
		return
	elseif not self.addonCallbacks[addonName] then
		E:Print("Invalid 'addonName' #1 to S:RemoveCallbackForAddon ", addonName)
		return
	end

	for index, event in ipairs(self.addonCallbacks[addonName].CallPriority) do
		if event == eventName then
			tremove(self.addonCallbacks[addonName].CallPriority, index)
		end
	end
	if #self.addonCallbacks[addonName].CallPriority == 0 then
		self.addonCallbacks[addonName] = nil
	end
	E.UnregisterCallback(S, eventName)
end