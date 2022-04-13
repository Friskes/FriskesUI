function RunDalaranArenaEjectTimer()
-- Таймер выброса из трубы на арене даларана
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetPoint("BOTTOMLEFT", FuiDB.position.DalaranArenaEjectTimer_XPOS, FuiDB.position.DalaranArenaEjectTimer_YPOS)
frame:SetSize(40, 40)
frame:Hide()

frame.texture = frame:CreateTexture(nil, "BORDER")
frame.texture:SetAllPoints()
frame.texture:SetTexture("Interface\\Icons\\Spell_Frost_ArcticWinds")

frame.cooldown = CreateFrame("Cooldown", nil, frame)
frame.cooldown:SetAllPoints()
frame.cooldown:SetDrawEdge(true)

local duration = 10

frame:SetScript("OnUpdate", function(self, ...)
	if self.timestamp - GetTime() <= 0 then
		self:Hide()
	end
end)

local zone = "Dalaran Arena"
local message = "has begun!"

if GetLocale() == "ruRU" then
	zone = "Арена Даларана"
	message = "Битва на арене началась!"
end

local function DalaranArenaTimer_OnEvent(self, event, msg)
	if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" or event == "CHAT_MSG_RAID_BOSS_EMOTE" then
		if string.match(msg, message) and GetRealZoneText() == zone then
			frame:Show()
			frame.timestamp = GetTime() + duration
			CooldownFrame_SetTimer(frame.cooldown, GetTime(), duration, 1)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		frame:Hide()
	end
end

frame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", DalaranArenaTimer_OnEvent)

function StartMoveDalaranArenaEjectTimer()
	frame:Show()
	frame.timestamp = GetTime() + 10000
	CooldownFrame_SetTimer(frame.cooldown, GetTime(), duration, 1)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:SetScript("OnMouseDown", function(self, button)
    frame:StartMoving()
end)
    frame:SetScript("OnMouseUp", function(self, button)
    frame:StopMovingOrSizing()
    FuiDB.position.DalaranArenaEjectTimer_XPOS = frame:GetLeft()
    FuiDB.position.DalaranArenaEjectTimer_YPOS = frame:GetBottom()
end)
end

function StopMoveDalaranArenaEjectTimer()
    frame:Hide()
    frame:EnableMouse(false)
    frame:SetMovable(false)
end
end
