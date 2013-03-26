local UnitName, SendChatMessage = UnitName, SendChatMessage

local frame = CreateFrame("Frame",  nil, UIParent)

local tracking = false
local function update_tracking()
	local should_track = (GetMapInfo() == "ValeofEternalBlossoms")
	if should_track ~= tracking then
		if tracking then
			print "untraking"
			frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		else
			print "traking"
			frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		tracking = should_track
	end
end

function frame:OnEvent(ev, _, event, _, _, _, _, _, _, target, _, _, spellID, _, _, _, count)
--                         1    2    3  4  5  6  7  8    9    10 11    12    13 14 15   16
	if ev == "COMBAT_LOG_EVENT_UNFILTERED" then
		if spellID ~= 31803 then return end
		
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
		
		SendChatMessage("Life drain on " .. player .. "! " .. stacks, "YELL")
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
