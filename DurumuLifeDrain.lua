local frame = CreateFrame("Frame",  nil, UIParent);

local UnitName, SendChatMessage = UnitName, SendChatMessage

----------------------------  1    2    3  4  5  6  7  8    9    10 11    12    13 14 15   16
function frame:OnEvent(event, _, event, _, _, _, _, _, _, target, _, _, spellID, _, _, _, count)
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
end

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", frame.OnEvent)
