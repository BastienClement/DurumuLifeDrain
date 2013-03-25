local frame = CreateFrame("Frame",  nil, UIParent);

function frame:OnEvent(event, ...)
	local args = {...}
	if args[12] ~= 31803 then
		return
	end
	
	local player = UnitName("player")
	if player ~= args[9] then
		return
	end
	
	local event = args[2]
	local stacks
	
	if event == "SPELL_AURA_APPLIED" then
		stacks = "1 stack"
	elseif event == "SPELL_AURA_APPLIED_DOSE" then
		stacks = args[16] .. " stacks"
	else
		return
	end
	
	local message = "Life drain on ".. player .."! ".. stacks
	SendChatMessage(message, "YELL")
end

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", frame.OnEvent)
