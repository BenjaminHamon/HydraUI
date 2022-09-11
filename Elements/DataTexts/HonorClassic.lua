local HydraUI, Language, Assets, Settings = select(2, ...):get()

local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local Label = HONOR

local OnEnter = function(self)
	self:SetTooltip()
	
	local HK, DK = GetPVPSessionStats()
	local Rank = UnitPVPRank("player")
	
	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")
		
		GameTooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
		GameTooltip:AddLine(" ")
	end
	
	if (HK > 0) then
		GameTooltip:AddLine(HONOR_TODAY)
		GameTooltip:AddDoubleLine(HONORABLE_KILLS, HydraUI:Comma(HK))
		GameTooltip:AddDoubleLine(DISHONORABLE_KILLS, HydraUI:Comma(DK))
	end
	
	HK, DK = GetPVPLifetimeStats()
	
	if (HK > 0) then
		GameTooltip:AddLine(HONOR_LIFETIME)
		GameTooltip:AddDoubleLine(HONORABLE_KILLS, HydraUI:Comma(HK), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(DISHONORABLE_KILLS, HydraUI:Comma(DK), 1, 1, 1, 1, 1, 1)
	end
	
	-- GetCurrentArenaSeason()
	
	
	--[[
		if IsInArenaTeam() then -- Inside OnEnable
			self:RegisterEvent("ARENA_TEAM_ROSTER_UPDATE")
			
			ArenaTeamRoster(1)
			ArenaTeamRoster(2)
			ArenaTeamRoster(3)
		end
		
		-- Inside tooltip
		local name, rank, level, class, online, played, win, seasonPlayed, seasonWin, personalRating = GetArenaTeamRosterInfo(teamindex, playerid); teamindex=1-3, playerid=1-5
	--]]
	
	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnMouseUp = function()
	if HydraUI.IsWrath then
	
	elseif HydraUI.IsClassic then
		ToggleCharacter("HonorFrame")
	else
		ToggleCharacter("PVPFrame")
	end
end

local Update = function(self)
	local Info = GetCurrencyInfo(1901)
	
	self.Text:SetFormattedText("|cFF%s%s:|r |cFF%s%s |r", Settings["data-text-label-color"], Label, Settings["data-text-value-color"], Info.quantity)
end

local OnEnable = function(self)
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:SetScript("OnEvent", Update)
	self:SetScript("OnMouseUp", OnMouseUp)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	
	self:Update()
end

local OnDisable = function(self)
	self:UnregisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:SetScript("OnEvent", nil)
	self:SetScript("OnMouseUp", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	
	self.Text:SetText("")
end

HydraUI:AddDataText("Honor", OnEnable, OnDisable, Update)