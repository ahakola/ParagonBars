--[[----------------------------------------------------------------------------
	ParagonBars

	2017- 	Sanex @ EU-Arathor / ahak @ Curseforge

	Repurpose ReputationFrame elements of capped Legion factions to show Paragon
	reputations actual progress as progressbar and in numbers when hovering
	mouse over progressbar like they show on uncapped reputations.
----------------------------------------------------------------------------]]--

local color = { r = 0.26, g = 0.42, b = 1 } -- https://www.townlong-yak.com/framexml/7.2.0/GameTooltipTemplate.xml#497

local function hook_ReputationFrame_Update(factionRow, elementData)
	local factionIndex = elementData.index
	local factionContainer = factionRow.Container
	local factionBar = factionContainer.ReputationBar

	local _, _, standingID, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)

	if not standingID == MAX_REPUTATION_REACTION then return end

	if factionID and C_Reputation.IsFactionParagon(factionID) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		if currentValue then
			local value = mod(currentValue, threshold)
			if hasRewardPending then
				value = value + threshold
			end
			factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(value), BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE

			factionBar:SetMinMaxValues(0, threshold)
			factionBar:SetValue(value)
			factionBar:SetStatusBarColor(color.r, color.g, color.b)
		end
	end
end

--hooksecurefunc("ReputationFrame_Update", hook_ReputationFrame_Update) -- https://www.townlong-yak.com/framexml/7.2.0/ReputationFrame.lua#123
hooksecurefunc("ReputationFrame_InitReputationRow", hook_ReputationFrame_Update) -- https://www.townlong-yak.com/framexml/10.0.0/ReputationFrame.lua#129

--EOF