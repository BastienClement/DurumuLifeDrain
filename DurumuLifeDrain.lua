--[[

	Copyright (c) 2013 Bastien Clément

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

local UnitName, SendChatMessage = UnitName, SendChatMessage

local frame = CreateFrame("Frame",  nil, UIParent)

local tracking = false
local function update_tracking()
	local should_track = (GetMapInfo() == "ThunderKingRaid")
	if should_track ~= tracking then
		if tracking then
			frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		else
			frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		tracking = should_track
	end
end

function frame:OnEvent(ev, _, event, _, _, _, _, _, _, target, _, _, spellID, _, _, _, count)
--                         1    2    3  4  5  6  7  8    9    10 11    12    13 14 15   16
	if ev == "COMBAT_LOG_EVENT_UNFILTERED" then
		if spellID ~= 133798 then return end
		
		local player = UnitName("player")
		if player ~= target then return end
		
		local stacks
		if event == "SPELL_AURA_APPLIED" then
			stacks = "1 stack"
		elseif event == "SPELL_AURA_APPLIED_DOSE" then
			stacks = count .. " stacks"
		else
			return
		end
		
		SendChatMessage(stacks, "YELL")
	else
		-- ZONE_CHANGED / ZONE_CHANGED_INDOORS / ZONE_CHANGED_NEW_AREA
		update_tracking()
	end
end

frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

update_tracking()

frame:SetScript("OnEvent", frame.OnEvent)
