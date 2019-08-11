local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack, assert, pairs, ipairs, select, type = unpack, assert, pairs, ipairs, select, type
local strfind = strfind
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded

S.allowBypass = {}
S.addonCallbacks = {}
S.nonAddonCallbacks = {["CallPriority"] = {}}

-- Depends on the arrow texture to be up by default.
S.ArrowRotation = {
	["up"] = 0,
	["down"] = 3.14,
	["left"] = 1.57,
	["right"] = -1.57,
}

function S:SetModifiedBackdrop()
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
end

function S:SetOriginalBackdrop()
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

function S:StatusBarColorGradient(bar, value, max, backdrop)
	local current = (not max and value) or (value and max and max ~= 0 and value/max)
	if not (bar and current) then return end
	local r, g, b = E:ColorGradient(current, 0.8,0,0, 0.8,0.8,0, 0,0.8,0)
	local bg = backdrop or bar.backdrop
	if bg then bg:SetBackdropColor(r*0.25, g*0.25, b*0.25) end
	bar:SetStatusBarColor(r, g, b)
end

function S:HandleButton(button, strip, isDeclineButton, useCreateBackdrop, noSetTemplate)
	if button.isSkinned then return end
	assert(button, "doesn't exist!")

	local buttonName = button.GetName and button:GetName()
	if buttonName then
		local left = _G[buttonName.."Left"]
		local middle = _G[buttonName.."Middle"]
		local right = _G[buttonName.."Right"]

		if left then left:Kill() end
		if middle then middle:Kill() end
		if right then right:Kill() end
	end

	if button.Left then button.Left:Kill() end
	if button.Middle then button.Middle:Kill() end
	if button.Right then button.Right:Kill() end

	if button.SetNormalTexture then button:SetNormalTexture("") end
	if button.SetHighlightTexture then button:SetHighlightTexture("") end
	if button.SetPushedTexture then button:SetPushedTexture("") end
	if button.SetDisabledTexture then button:SetDisabledTexture("") end

	if strip then button:StripTextures() end

	if useCreateBackdrop then
		button:CreateBackdrop(nil, true)
	elseif not noSetTemplate then
		button:SetTemplate(nil, true)
	end

	button:HookScript("OnEnter", S.SetModifiedBackdrop)
	button:HookScript("OnLeave", S.SetOriginalBackdrop)

	button.isSkinned = true
end

function S:HandleButtonHighlight(frame)
	if frame.SetHighlightTexture then
		frame:SetHighlightTexture("")
	end

	local leftGrad = frame:CreateTexture(nil, "HIGHLIGHT")
	leftGrad:Size(frame:GetWidth() * 0.5, frame:GetHeight() * 0.95)
	leftGrad:Point("LEFT", frame, "CENTER")
	leftGrad:SetTexture(E.media.blankTex)
	leftGrad:SetGradientAlpha("Horizontal", 0.9, 0.9, 0.9, 0.35, 0.9, 0.9, 0.9, 0)

	local rightGrad = frame:CreateTexture(nil, "HIGHLIGHT")
	rightGrad:Size(frame:GetWidth() * 0.5, frame:GetHeight() * 0.95)
	rightGrad:Point("RIGHT", frame, "CENTER")
	rightGrad:SetTexture(E.media.blankTex)
	rightGrad:SetGradientAlpha("Horizontal", 0.9, 0.9, 0.9, 0, 0.9, 0.9, 0.9, 0.35)
end

function S:HandleScrollBar(frame, thumbTrimY, thumbTrimX)
	if frame.backdrop then return end
	local name = frame:GetName()
	if _G[name.."BG"] then _G[name.."BG"]:SetTexture(nil) end
	if _G[name.."Track"] then _G[name.."Track"]:SetTexture(nil) end
	if _G[name.."Top"] then _G[name.."Top"]:SetTexture(nil) end
	if _G[name.."Bottom"] then _G[name.."Bottom"]:SetTexture(nil) end
	if _G[name.."Middle"] then _G[name.."Middle"]:SetTexture(nil) end

	if not (_G[name.."ScrollUpButton"] and _G[name.."ScrollDownButton"]) then return end

	frame:CreateBackdrop()
	frame.backdrop:Point("TOPLEFT", _G[name.."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
	frame.backdrop:Point("BOTTOMRIGHT", _G[name.."ScrollDownButton"], "TOPRIGHT", 0, 1)
	frame.backdrop:SetFrameLevel(frame.backdrop:GetFrameLevel() + 1)

	S:HandleNextPrevButton(_G[name.."ScrollUpButton"])
	S:HandleNextPrevButton(_G[name.."ScrollDownButton"])

	local Thumb = frame:GetThumbTexture()
	if Thumb and not Thumb.backdrop then
		Thumb:SetTexture()
		Thumb:CreateBackdrop(nil, true, true)
		if not thumbTrimY then thumbTrimY = 3 end
		if not thumbTrimX then thumbTrimX = 2 end
		Thumb.backdrop:Point("TOPLEFT", Thumb, "TOPLEFT", 2, -thumbTrimY)
		Thumb.backdrop:Point("BOTTOMRIGHT", Thumb, "BOTTOMRIGHT", -thumbTrimX, thumbTrimY)
		Thumb.backdrop:SetFrameLevel(Thumb.backdrop:GetFrameLevel() + 2)
		Thumb.backdrop:SetBackdropColor(0.6, 0.6, 0.6)

		frame.Thumb = Thumb
	end
end

local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right"
}

function S:HandleTab(tab, noBackdrop)
	if (not tab) or (tab.backdrop and not noBackdrop) then return end

	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture()
		end
	end

	local highlightTex = tab.GetHighlightTexture and tab:GetHighlightTexture()
	if highlightTex then
		highlightTex:SetTexture()
	else
		tab:StripTextures()
	end

	if not noBackdrop then
		tab:CreateBackdrop()
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
	end
end

function S:HandleRotateButton(btn)
	if btn.isSkinned then return end

	btn:SetTemplate()
	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)

	local normTex = btn:GetNormalTexture()
	local pushTex = btn:GetPushedTexture()
	local highlightTex = btn:GetHighlightTexture()

	normTex:SetInside()
	normTex:SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	pushTex:SetAllPoints(normTex)
	pushTex:SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	highlightTex:SetAllPoints(normTex)
	highlightTex:SetTexture(1, 1, 1, 0.3)

	btn.isSkinned = true
end

function S:HandleEditBox(frame)
	if frame.backdrop then return end

	frame:CreateBackdrop()
	frame.backdrop:SetFrameLevel(frame:GetFrameLevel())

	local EditBoxName = frame.GetName and frame:GetName()
	if EditBoxName then
		if _G[EditBoxName.."Left"] then _G[EditBoxName.."Left"]:SetAlpha(0) end
		if _G[EditBoxName.."Middle"] then _G[EditBoxName.."Middle"]:SetAlpha(0) end
		if _G[EditBoxName.."Right"] then _G[EditBoxName.."Right"]:SetAlpha(0) end
		if _G[EditBoxName.."Mid"] then _G[EditBoxName.."Mid"]:SetAlpha(0) end

		if strfind(EditBoxName, "Silver") or strfind(EditBoxName, "Copper") then
			frame.backdrop:Point("BOTTOMRIGHT", -12, -2)
		end
	end
end

function S:HandleDropDownBox(frame, width)
	if frame.backdrop then return end
	local FrameName = frame.GetName and frame:GetName()

	local button = FrameName and _G[FrameName.."Button"]
	if not button then return end

	local text = FrameName and _G[FrameName.."Text"]

	frame:StripTextures()
	frame:CreateBackdrop()
	frame.backdrop:SetFrameLevel(frame:GetFrameLevel())
	frame.backdrop:Point("TOPLEFT", 20, -3)
	frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)

	if width then
		frame:Width(width)
	end

	if text then
		text:ClearAllPoints()
		text:Point("RIGHT", button, "LEFT", -2, 0)
	end

	S:HandleNextPrevButton(button)
	button:ClearAllPoints()
	button:Point("RIGHT", frame, "RIGHT", -10, 3)
	button:Size(16, 16)
end

function S:HandleStatusBar(frame, color)
	frame:SetFrameLevel(frame:GetFrameLevel() + 1)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	frame:SetStatusBarTexture(E.media.normTex)
	frame:SetStatusBarColor(unpack(color or {.01, .39, .1}))
	E:RegisterStatusBar(frame)
end

function S:HandleCheckBox(frame, noBackdrop, noReplaceTextures, forceSaturation)
	if frame.isSkinned then return end
	assert(frame, "does not exist.")
	frame:StripTextures()
	frame.forceSaturation = forceSaturation

	if noBackdrop then
		frame:SetTemplate()
		frame:Size(16)
	else
		frame:CreateBackdrop()
		frame.backdrop:SetInside(nil, 4, 4)
	end

	if not noReplaceTextures then
		if frame.SetCheckedTexture then
			if E.private.skins.checkBoxSkin then
				frame:SetCheckedTexture(E.Media.Textures.Melli)

				local checkedTexture = frame:GetCheckedTexture()
				checkedTexture:SetVertexColor(1, .82, 0, 0.8)
				checkedTexture:SetInside(frame.backdrop)
			else
				frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

				if noBackdrop then
					frame:GetCheckedTexture():SetInside(nil, -4, -4)
				end
			end
		end

		if frame.SetDisabledCheckedTexture then
			if E.private.skins.checkBoxSkin then
				frame:SetDisabledCheckedTexture(E.Media.Textures.Melli)

				local disabledCheckedTexture = frame:GetDisabledCheckedTexture()
				disabledCheckedTexture:SetVertexColor(0.6, 0.6, 0.6, 0.8)
				disabledCheckedTexture:SetInside(frame.backdrop)
			else
				frame:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")

				if noBackdrop then
					frame:GetDisabledCheckedTexture():SetInside(nil, -4, -4)
				end
			end
		end

		if frame.SetDisabledTexture then
			if E.private.skins.checkBoxSkin then
				frame:SetDisabledTexture(E.Media.Textures.Melli)

				local disabledTexture = frame:GetDisabledTexture()
				disabledTexture:SetVertexColor(.6, .6, .6, .8)
				disabledTexture:SetInside(frame.backdrop)
			else
				frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")

				if noBackdrop then
					frame:GetDisabledTexture():SetInside(nil, -4, -4)
				end
			end
		end

		frame:HookScript('OnDisable', function(checkbox)
			if not checkbox.SetDisabledTexture then return; end
			if checkbox:GetChecked() then
				if E.private.skins.checkBoxSkin then
					checkbox:SetDisabledTexture(E.Media.Textures.Melli)
				else
					checkbox:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
				end
			else
				checkbox:SetDisabledTexture("")
			end
		end)

		hooksecurefunc(frame, "SetNormalTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetNormalTexture("") end
		end)
		hooksecurefunc(frame, "SetPushedTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetPushedTexture("") end
		end)
		hooksecurefunc(frame, "SetHighlightTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetHighlightTexture("") end
		end)
		hooksecurefunc(frame, "SetCheckedTexture", function(checkbox, texPath)
			if texPath == E.Media.Textures.Melli or texPath == "Interface\\Buttons\\UI-CheckBox-Check" then return end
			if E.private.skins.checkBoxSkin then
				checkbox:SetCheckedTexture(E.Media.Textures.Melli)
			else
				checkbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
			end
		end)
	end

	frame.isSkinned = true
end

function S:HandleIcon(icon, parent)
	parent = parent or icon:GetParent()

	icon:SetTexCoord(unpack(E.TexCoords))
	parent:CreateBackdrop("Default")
	icon:SetParent(parent.backdrop)
	parent.backdrop:SetOutside(icon)
end

function S:HandleItemButton(b, shrinkIcon)
	if b.isSkinned then return end

	local icon = b.icon or b.IconTexture or b.iconTexture
	local texture
	if b:GetName() and _G[b:GetName().."IconTexture"] then
		icon = _G[b:GetName().."IconTexture"]
	elseif b:GetName() and _G[b:GetName().."Icon"] then
		icon = _G[b:GetName().."Icon"]
	end

	if icon and icon:GetTexture() then
		texture = icon:GetTexture()
	end

	b:StripTextures()
	b:CreateBackdrop("Default", true)
	b:StyleButton()

	if icon then
		icon:SetTexCoord(unpack(E.TexCoords))

		if shrinkIcon then
			b.backdrop:SetAllPoints()
			icon:SetInside(b)
		else
			b.backdrop:SetOutside(icon)
		end
		icon:SetParent(b.backdrop)

		if texture then
			icon:SetTexture(texture)
		end
	end
	b.isSkinned = true
end

local handleCloseButtonOnEnter = function(btn) if btn.Texture then btn.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor)) end end
local handleCloseButtonOnLeave = function(btn) if btn.Texture then btn.Texture:SetVertexColor(1, 1, 1) end end

function S:HandleCloseButton(f, point)
	f:StripTextures()

	if f:GetNormalTexture() then f:SetNormalTexture(""); f.SetNormalTexture = E.noop end
	if f:GetPushedTexture() then f:SetPushedTexture(""); f.SetPushedTexture = E.noop end

	if not f.Texture then
		f.Texture = f:CreateTexture(nil, "OVERLAY")
		f.Texture:Point("CENTER")
		f.Texture:SetTexture(E.Media.Textures.Close)
		f.Texture:Size(12, 12)
		f:HookScript("OnEnter", handleCloseButtonOnEnter)
		f:HookScript("OnLeave", handleCloseButtonOnLeave)
		f:SetHitRectInsets(6, 6, 7, 7)
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

function S:HandleSliderFrame(frame)
	local orientation = frame:GetOrientation()
	local SIZE = 12

	frame:StripTextures()
	frame:SetThumbTexture(E.Media.Textures.Melli)
	frame:SetTemplate()

	local thumb = frame:GetThumbTexture()
	thumb:SetVertexColor(1, .82, 0, 0.8)
	thumb:Size(SIZE-2,SIZE-2)

	if orientation == "VERTICAL" then
		frame:Width(SIZE)
	else
		frame:Height(SIZE)

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region and region:IsObjectType("FontString") then
				local point, anchor, anchorPoint, x, y = region:GetPoint()
				if strfind(anchorPoint, "BOTTOM") then
					region:Point(point, anchor, anchorPoint, x, y - 4)
				end
			end
		end
	end
end

function S:HandleIconSelectionFrame(frame, numIcons, buttonNameTemplate, frameNameOverride)
	assert(frame, "HandleIconSelectionFrame: frame argument missing")
	assert(numIcons and type(numIcons) == "number", "HandleIconSelectionFrame: numIcons argument missing or not a number")
	assert(buttonNameTemplate and type(buttonNameTemplate) == "string", "HandleIconSelectionFrame: buttonNameTemplate argument missing or not a string")

	local frameName = frameNameOverride or frame:GetName(); --We need override in case Blizzard fucks up the naming (guild bank)
	local scrollFrame = _G[frameName.."ScrollFrame"];
	local editBox = _G[frameName.."EditBox"];
	local okayButton = _G[frameName.."OkayButton"] or _G[frameName.."Okay"]
	local cancelButton = _G[frameName.."CancelButton"] or _G[frameName.."Cancel"]

	frame:StripTextures()
	scrollFrame:StripTextures()
	editBox:DisableDrawLayer("BACKGROUND") --Removes textures around it

	frame:CreateBackdrop("Transparent")
	frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", 10, -12)
	frame.backdrop:Point("BOTTOMRIGHT", cancelButton, "BOTTOMRIGHT", 5, -5)

	S:HandleButton(okayButton)
	S:HandleButton(cancelButton)
	S:HandleEditBox(editBox)

	for i = 1, numIcons do
		local button = _G[buttonNameTemplate..i]
		local icon = _G[button:GetName().."Icon"]
		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton(nil, true)
		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))
	end
end

function S:HandleNextPrevButton(btn, arrowDir, color, noBackdrop, stipTexts)
	if btn.isSkinned then return end

	if not arrowDir then
		arrowDir = "down"
		local ButtonName = btn:GetName() and btn:GetName():lower()

		if ButtonName then
			if (strfind(ButtonName, "left") or strfind(ButtonName, "prev") or strfind(ButtonName, "decrement") or strfind(ButtonName, "promote")) then
				arrowDir = "left"
			elseif (strfind(ButtonName, "right") or strfind(ButtonName, "next") or strfind(ButtonName, "increment")) then
				arrowDir = "right"
			elseif (strfind(ButtonName, "scrollup") or strfind(ButtonName, "upbutton") or strfind(ButtonName, "top")) then
				arrowDir = "up"
			end
		end
	end

	btn:StripTextures()
	if not noBackdrop then
		S:HandleButton(btn)
	end

	if stipTexts then
		btn:StripTexts()
	end

	btn:SetNormalTexture(E.Media.Textures.ArrowUp)
	btn:SetPushedTexture(E.Media.Textures.ArrowUp)
	btn:SetDisabledTexture(E.Media.Textures.ArrowUp)

	local Normal, Disabled, Pushed = btn:GetNormalTexture(), btn:GetDisabledTexture(), btn:GetPushedTexture()

	if noBackdrop then
		btn:Size(20, 20)
		Disabled:SetVertexColor(.5, .5, .5)
		btn.Texture = Normal
		btn:HookScript("OnEnter", handleCloseButtonOnEnter)
		btn:HookScript("OnLeave", handleCloseButtonOnLeave)
	else
		btn:Size(18, 18)
		Disabled:SetVertexColor(.3, .3, .3)
	end

	Normal:SetInside()
	Pushed:SetInside()
	Disabled:SetInside()

	Normal:SetTexCoord(0, 1, 0, 1)
	Pushed:SetTexCoord(0, 1, 0, 1)
	Disabled:SetTexCoord(0, 1, 0, 1)

	Normal:SetRotation(S.ArrowRotation[arrowDir])
	Pushed:SetRotation(S.ArrowRotation[arrowDir])
	Disabled:SetRotation(S.ArrowRotation[arrowDir])

	Normal:SetVertexColor(unpack(color or {1, 1, 1}))

	btn.isSkinned = true
end

function S:ADDON_LOADED(_, addon)
	S:SkinAce3()

	if self.allowBypass[addon] then
		if self.addonCallbacks[addon] then
			--Fire events to the skins that rely on this addon
			for index, event in ipairs(self.addonCallbacks[addon].CallPriority) do
				self.addonCallbacks[addon][event] = nil
				self.addonCallbacks[addon].CallPriority[index] = nil
				E.callbacks:Fire(event)
			end
		end
		return
	end

	if not E.Initialized then return end

	if self.addonCallbacks[addon] then
		for index, event in ipairs(self.addonCallbacks[addon].CallPriority) do
			self.addonCallbacks[addon][event] = nil
			self.addonCallbacks[addon].CallPriority[index] = nil
			E.callbacks:Fire(event)
		end
	end
end

--Add callback for skin that relies on another addon.
--These events will be fired when the addon is loaded.
function S:AddCallbackForAddon(addonName, eventName, loadFunc, forceLoad, bypass)
	if not addonName or type(addonName) ~= "string" then
		E:Print("Invalid argument #1 to S:AddCallbackForAddon (string expected)")
		return
	elseif not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #2 to S:AddCallbackForAddon (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		E:Print("Invalid argument #3 to S:AddCallbackForAddon (function expected)")
		return
	end

	if bypass then
		self.allowBypass[addonName] = true
	end

	--Create an event registry for this addon, so that we can fire multiple events when this addon is loaded
	if not self.addonCallbacks[addonName] then
		self.addonCallbacks[addonName] = {["CallPriority"] = {}}
	end

	if self.addonCallbacks[addonName][eventName] or E.ModuleCallbacks[eventName] or E.InitialModuleCallbacks[eventName] then
		--Don't allow a registered callback to be overwritten
		E:Print("Invalid argument #2 to S:AddCallbackForAddon (event name:", eventName, "is already registered, please use a unique event name)")
		return
	end

	--Register loadFunc to be called when event is fired
	E.RegisterCallback(E, eventName, loadFunc)

	if forceLoad then
		E.callbacks:Fire(eventName)
	else
		--Insert eventName in this addons' registry
		self.addonCallbacks[addonName][eventName] = true
		self.addonCallbacks[addonName].CallPriority[#self.addonCallbacks[addonName].CallPriority + 1] = eventName
	end
end

--Add callback for skin that does not rely on a another addon.
--These events will be fired when the Skins module is initialized.
function S:AddCallback(eventName, loadFunc)
	if not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #1 to S:AddCallback (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		E:Print("Invalid argument #2 to S:AddCallback (function expected)")
		return
	end

	if self.nonAddonCallbacks[eventName] or E.ModuleCallbacks[eventName] or E.InitialModuleCallbacks[eventName] then
		--Don't allow a registered callback to be overwritten
		E:Print("Invalid argument #1 to S:AddCallback (event name:", eventName, "is already registered, please use a unique event name)")
		return
	end

	--Add event name to registry
	self.nonAddonCallbacks[eventName] = true
	self.nonAddonCallbacks.CallPriority[#self.nonAddonCallbacks.CallPriority + 1] = eventName

	--Register loadFunc to be called when event is fired
	E.RegisterCallback(E, eventName, loadFunc)
end