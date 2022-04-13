local L = LibStub('AceLocale-3.0'):GetLocale('FriskesUI')

function RunArenaTimeRemainingTimer()
-- Таймер до завершения арены
local frame = CreateFrame("Frame", nil, WorldStateAlwaysUpFrame)
frame:SetPoint("TOPLEFT", WorldStateAlwaysUpFrame, "TOPLEFT", 59, -63)
frame:SetSize(1, 1)

local Update = 0
local time
local duration = 1800
local timeANDduration
local text

local text2 = frame:CreateFontString(frame, "OVERLAY", "GameFontNormal")
text2:SetPoint("TOP")
text2:SetTextHeight(10)

function frame:OnUpdate(elapsed)

	Update = Update + elapsed

	timeANDduration = time + duration -- time время начала отсчета GetTime, duration количество секунд которое нужно отсчитать

	text = math.floor(timeANDduration - GetTime() * 1)

	text2:SetText(frame.Format_Text(text))

	if GetTime() >= timeANDduration then
		frame:Hide() -- если заканчивается отсчёт то скрываем его
	end
end

function frame.Format_Text(text) -- форматируем секунды в минуты

	local minutes = (math.fmod(text, 3600) / 60)

	text = (math.fmod(text, 60))

	return format(L.ArenaTimeRemainingTimerInfo .. tostring "%02d:%02d", minutes, text)
end

function frame.MSG_ArenaStart(gettime) -- принимаем аргумент GetTime и делаем его переменной
	time = gettime
end

local function ArenaTimeRemainingTimer_OnEvent(self, event, msg)

	if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" and msg == "The battle in the arena has begun!" or msg == "Битва на арене началась!" then
		frame:Show()
		frame:SetScript("OnUpdate", frame.OnUpdate)
		frame.MSG_ArenaStart(GetTime()) -- начинаем отсчёт цирк

	elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" and msg == "The Arena battle has begun!" then
		frame:Show()
		frame:SetScript("OnUpdate", frame.OnUpdate)
		frame.MSG_ArenaStart(GetTime() + 900) -- начинаем отсчёт вармейн + 900сек к 1800сек

	elseif event == "PLAYER_ENTERING_WORLD" then
		if not IsActiveBattlefieldArena() then
			frame:Hide() -- если находимся вне арены то скрываем отсчёт
		end
	end
end

frame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", ArenaTimeRemainingTimer_OnEvent)
end
