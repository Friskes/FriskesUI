function RunStartTimer()
-- Таймер до начала сражения
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameLevel(0)
frame:SetPoint("TOP", UIParent, "TOP", 0, -180)
frame:SetWidth(185)
frame:SetHeight(16)

local background = frame:CreateTexture(nil, "ARTWORK")
background:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
background:SetPoint("CENTER", frame, "CENTER")
background:SetSize(frame:GetWidth(), frame:GetHeight() )
background:SetVertexColor(0, 0, 0, 0.5)

local frame2 = CreateFrame("StatusBar", nil, frame)
frame2:SetFrameLevel(1)
frame2:SetStatusBarTexture("Interface\\Addons\\FriskesUI\\Media\\Textures\\RetailTimer\\Raid-Bar-Hp-Fill")
frame2:SetPoint("CENTER", frame, "CENTER")
frame2:SetSize(frame:GetWidth(), frame:GetHeight() )
frame2:SetOrientation("HORIZONTAL")
frame2:SetMinMaxValues(0, 1)
frame2:SetStatusBarColor(1, 0, 0, 1)

local border = frame2:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
border:SetPoint("CENTER", frame, "CENTER")
border:SetSize(frame:GetWidth() * 1.3, frame:GetHeight() * 4)
border:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)

local text = frame2:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetPoint("CENTER", frame, "CENTER")
text:SetTextHeight(12)

local frame3 = CreateFrame("Frame")
local Update2

local frame4 = CreateFrame("Frame")
local Update3 = 1 -- Update находиться снаружи функции что бы не перезаписывался через OnUpdate во время выполнения скрипта

local frame5 = CreateFrame("Frame")

local Update = 0
local time
local duration
local timeANDduration
local seconds

function frame:OnUpdate(elapsed)

    Update = Update + elapsed

    timeANDduration = time + duration -- time время начала отсчета GetTime, duration количество секунд которое нужно отсчитать

    seconds = math.floor(timeANDduration - GetTime() * 1)

    text:SetText(frame.Format_Text(seconds) )
    frame2:SetValue( (seconds / 60) % 1)

    if GetTime() >= timeANDduration - 11 then
        frame4:OnUpdate() -- запускаем анимацию исчезновения
	end

	if GetTime() >= timeANDduration - 10 then
        TimerTracker_OnEvent(TimerTracker, "START_TIMER", 1, 10, 60) -- запускаем анимированные цифры
		frame:Hide() -- если заканчивается отсчёт то отключаем OnUpdate
	end
end

function frame.Format_Text(seconds) -- форматируем секунды в минуты:секунды

	local minutes = (math.fmod(seconds, 3600) / 60)

	seconds = (math.fmod(seconds, 60) )

	return format("%01d:%02d", minutes, seconds)
end

function frame.MSG_ArenaStart(gettime) -- принимаем аргумент GetTime и делаем его переменной
	time = gettime
end

local function StartTimer_OnEvent(self, event, msg, ...)

    if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then

        if msg == "Одна минута до начала боя на арене!" or msg == "One minute until the Arena battle begins!" then
            self:Show()
            self:SetScript("OnUpdate", self.OnUpdate)
            duration = 60
            self.MSG_ArenaStart(GetTime() )
            frame3:OnUpdate() -- запускаем анимацию появления

        elseif msg == "Тридцать секунд до начала боя на арене!" or msg == "Thirty seconds until the Arena battle begins!" then
            self:Show()
            self:SetScript("OnUpdate", self.OnUpdate)
            duration = 30
            self.MSG_ArenaStart(GetTime() )
            frame3:OnUpdate()

        elseif msg == "Пятнадцать секунд до начала боя на арене!" or msg == "Fifteen seconds until the Arena battle begins!" then
            self:Show()
            self:SetScript("OnUpdate", self.OnUpdate)
            duration = 15
            self.MSG_ArenaStart(GetTime() )
            frame3:OnUpdate()
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        Update2 = 0 -- Update находиться внутри ивента что бы анимация срабатывала только при первом входе на арену а не при каждом msg
        self:Hide() -- если находимся вне арены то скрываем отсчёт
    end
end
frame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", StartTimer_OnEvent)

-- Анимация статус бара от 0% альфы до 100%
function frame3.OnUpdate(Frame)

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update2 = Update2 + elapsed

        frame:SetAlpha(Update2 / 1) -- больше число - дольше анимация

        if Update2 >= 1 then
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Анимация статус бара от 100% альфы до 0%
function frame4.OnUpdate(Frame)

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update3 = Update3 - elapsed

        frame:SetAlpha(Update3 / 1)

        if Update3 <= 0 then
            Update3 = 1 -- заного задаём значение Update после того как скрипт выполнился что бы следующая анимация началась с единицы
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Анимация больших цифр
local floor, fmod = math.floor, math.fmod
local PLAYER_FACTION_GROUP = PLAYER_FACTION_GROUP

local TIMER_TYPE_PVP = 1
local TIMER_TYPE_CHALLENGE_MODE = 2
local TIMER_TYPE_PLAYER_COUNTDOWN = 3

local TIMER_DATA = {
    [1] = {mediumMarker = 11, largeMarker = 6, updateInterval = 10},
    [2] = {mediumMarker = 100, largeMarker = 100, updateInterval = 100},
    [3] = { mediumMarker = 31, largeMarker = 11, updateInterval = 10},
}

local TIMER_NUMBERS_SETS = {};
TIMER_NUMBERS_SETS["BigGold"]  = {    texture = "Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\BigTimerNumbers",
    w=256, h=170, texW=1024, texH=512,
    numberHalfWidths = {
        --0,      1,      2,      3,      4,      5,      6,      7,      8,      9,
        35/128, 14/128, 33/128, 32/128, 36/128, 32/128, 33/128, 29/128, 31/128, 31/128,
    }
}

local function GetPlayerFactionGroup()
    local factionGroup = UnitFactionGroup("player");
    if ( not IsActiveBattlefieldArena()) then
        factionGroup = PLAYER_FACTION_GROUP[GetBattlefieldArenaFaction()];
    end
    return factionGroup
end

frame5.timerList = {}
function frame5:SetTexNumbers(timer, ...)
    local digits = {...}
    local timeDigits = floor(timer.time)
    local style = timer.style
    
    local texCoW = style.w / style.texW
    local texCoH = style.h / style.texH
    local columns = floor(style.texW / style.w)
    
    local digit, l, r, t, b
    local numberOffset, numShown = 0, 0
    local i = 1
    
    while digits[i] do
        if timeDigits > 0 then
            digit = fmod(timeDigits, 10)
            
            digits[i].hw = style.numberHalfWidths[digit + 1] * digits[i].width
            numberOffset = numberOffset + digits[i].hw
            
            l = fmod(digit, columns) * texCoW
            r = l + texCoW
            t = floor(digit / columns) * texCoH
            b = t + texCoH
            
            digits[i]:SetTexCoord(l, r, t, b)
            digits[i].Glow:SetTexCoord(l, r, t, b)
            
            timeDigits = floor(timeDigits / 10)
            numShown = numShown + 1
        else
            digits[i]:SetTexCoord(0, 0, 0, 0)
            digits[i].Glow:SetTexCoord(0, 0, 0, 0)
        end
        
        i = i + 1
    end
    
    if numberOffset > 0 then
        digits[1]:ClearAllPoints()
        
        if timer.anchorCenter then
            digits[1]:SetPoint("CENTER", UIParent, "CENTER", numberOffset - digits[1].hw, 0)
            PlaySoundFile("Interface\\AddOns\\FriskesUI\\Media\\Sounds\\RetailTimer\\Countdown.ogg", "Master") -- звук больших цифр
        else
            digits[1]:SetPoint("CENTER", timer, "CENTER", numberOffset - digits[1].hw, 0)
            PlaySoundFile("Interface\\AddOns\\FriskesUI\\Media\\Sounds\\RetailTimer\\Countdown.ogg", "Master") -- звук больших цифр
        end
        
        for j = 2, numShown do
            digits[j]:ClearAllPoints()
            digits[j]:SetPoint("CENTER", digits[j - 1], "CENTER", -(digits[j].hw + digits[j - 1].hw), 0)
        end
    end
end

local function StartNumbers_OnPlay(self)
    local timer = self:GetParent():GetParent()
    frame5:SetTexNumbers(timer, timer.Digit1, timer.Digit2)
end

function frame5:SwitchToLargeDisplay(timer)
    timer.Digit1:SetSize(timer.style.w, timer.style.h)
    timer.Digit2:SetSize(timer.style.w, timer.style.h)
    timer.Digit1.width = timer.style.w
    timer.Digit2.width = timer.style.w
    timer.anchorCenter = true
end

local function StartNumbers_OnFinished(self)
    local timer = self:GetParent():GetParent()
    timer.time = timer.time - 1
    
    if timer.time > 0 then
        if timer.time < TIMER_DATA[timer.type].largeMarker and not timer.anchorCenter then
            frame5:SwitchToLargeDisplay(timer)
        end
        timer.StartNumbers:Play()
        timer.StartGlowNumbers:Play()
    else
        
        PlaySoundFile("Interface\\AddOns\\FriskesUI\\Media\\Sounds\\RetailTimer\\Finish.ogg", "Master")
        
        timer.anchorCenter = false
        timer.isFree = true
        timer.GoTextureAnim:Play()
        timer.GoTextureGlowAnim:Play()
    end
end

local function CreateScaleAnim(group, order, duration, scale, delay, smoothing)
    local anim = group:CreateAnimation("Scale")
    anim:SetOrder(order)
    anim:SetDuration(duration)
    anim:SetScale(scale, scale)
    
    if delay then
        anim:SetStartDelay(delay)
    end
    if smoothing then
        anim:SetSmoothing(smoothing)
    end
end

local function CreateAlphaAnim(group, order, duration, change, delay, smoothing)
    local anim = group:CreateAnimation("Alpha")
    anim:SetOrder(order)
    anim:SetDuration(duration)
    anim:SetChange(change)
    
    if delay then
        anim:SetStartDelay(delay)
    end
    if smoothing then
        anim:SetSmoothing(smoothing)
    end
end

local function Timer_OnShow(self)
    self.time = self.endTime - GetTime()
    
    if self.time <= 0 then
        self:Hide()
        self.isFree = true
    elseif self.StartNumbers:IsPlaying() then
        self.StartNumbers:Stop()
        self.StartNumbers:Play()
        self.StartGlowNumbers:Stop()
        self.StartGlowNumbers:Play()
    end
end

frame5.CreateTimerTexture = function(self)
    local timer = CreateFrame("Frame", "TimerTrackerTimer"..(#self.timerList + 1), UIParent)
    timer:SetSize(206, 26)
    
    timer.GoFrame = CreateFrame("Frame", "$parentGoFrame", timer)
    timer.GoFrame:SetFrameLevel(1)
    timer.GoFrame:SetAlpha(0)
    timer.GoFrame:SetSize(256, 256)
    timer.GoFrame:SetPoint("CENTER", UIParent)
    timer.GoTextureAnim = timer.GoFrame:CreateAnimationGroup()
    CreateScaleAnim(timer.GoTextureAnim, 1, 0, 0.25)
    CreateAlphaAnim(timer.GoTextureAnim, 1, 0, 1)
    CreateScaleAnim(timer.GoTextureAnim, 2, 0.4, 4, nil, "OUT")
    CreateScaleAnim(timer.GoTextureAnim, 3, 0.2, 1.4, 0.6, "OUT")
    CreateAlphaAnim(timer.GoTextureAnim, 3, 0.2, -1, 0.6, "OUT")
    
    timer.GoTexture = timer.GoFrame:CreateTexture()
    timer.GoTexture:SetAllPoints()
    
    timer.GoGlowFrame = CreateFrame("Frame", "$parentGoGlowFrame", timer)
    timer.GoGlowFrame:SetFrameLevel(2)
    timer.GoGlowFrame:SetAlpha(0)
    timer.GoGlowFrame:SetAllPoints(timer.GoFrame)
    timer.GoTextureGlowAnim = timer.GoGlowFrame:CreateAnimationGroup()
    CreateScaleAnim(timer.GoTextureGlowAnim, 1, 0, 0.25)
    CreateAlphaAnim(timer.GoTextureGlowAnim, 1, 0, 1)
    CreateScaleAnim(timer.GoTextureGlowAnim, 2, 0.4, 4, nil, "OUT")
    CreateAlphaAnim(timer.GoTextureGlowAnim, 2, 0.4, -1, nil, "IN")
    
    timer.GoTextureGlow = timer.GoGlowFrame:CreateTexture()
    timer.GoTextureGlow:SetAllPoints()
    
    timer.DigitFrame = CreateFrame("Frame", "$parentDigitFrame", timer)
    timer.DigitFrame:SetFrameLevel(1)
    timer.DigitFrame:SetAlpha(0)
    timer.StartNumbers = timer.DigitFrame:CreateAnimationGroup()
    CreateScaleAnim(timer.StartNumbers, 1, 0, 0.25)
    CreateAlphaAnim(timer.StartNumbers, 1, 0, -1)
    CreateAlphaAnim(timer.StartNumbers, 2, 0, 1)
    CreateScaleAnim(timer.StartNumbers, 3, 0.3, 4, nil, "OUT")
    CreateScaleAnim(timer.StartNumbers, 4, 0.1, 1.2, 0.6)
    CreateAlphaAnim(timer.StartNumbers, 4, 0.1, -1, 0.6)
    timer.StartNumbers:SetScript("OnPlay", StartNumbers_OnPlay)
    timer.StartNumbers:SetScript("OnFinished", StartNumbers_OnFinished)
    
    timer.Digit1 = timer.DigitFrame:CreateTexture()
    timer.Digit2 = timer.DigitFrame:CreateTexture()
    
    timer.DigitGlowFrame = CreateFrame("Frame", "$parentDigitGlowFrame", timer)
    timer.DigitGlowFrame:SetFrameLevel(2)
    timer.DigitGlowFrame:SetAlpha(0)
    timer.StartGlowNumbers = timer.DigitGlowFrame:CreateAnimationGroup()
    CreateScaleAnim(timer.StartGlowNumbers, 1, 0, 0.25)
    CreateAlphaAnim(timer.StartGlowNumbers, 1, 0, 1)
    CreateScaleAnim(timer.StartGlowNumbers, 2, 0.3, 4, nil, "OUT")
    CreateAlphaAnim(timer.StartGlowNumbers, 2, 0.3, -1, nil, "IN")
    
    timer.Digit1.Glow = timer.DigitGlowFrame:CreateTexture()
    timer.Digit1.Glow:SetAllPoints(timer.Digit1)
    timer.Digit2.Glow = timer.DigitGlowFrame:CreateTexture()
    timer.Digit2.Glow:SetAllPoints(timer.Digit2)
    
    timer:SetScript("OnShow", Timer_OnShow)
    
    return timer
end

function frame5:SetGoTexture(timer)
    if ( timer.type == TIMER_TYPE_PVP ) then
        local factionGroup = GetPlayerFactionGroup()
        if factionGroup and factionGroup ~= "Neutral" then
            timer.GoTexture:SetTexture("Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\"..factionGroup.."-Logo")
            timer.GoTextureGlow:SetTexture("Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\"..factionGroup.."Glow-Logo")
        end
    elseif timer.type == TIMER_TYPE_CHALLENGE_MODE then
        timer.GoTexture:SetTexture("Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\Challenges-Logo")
        timer.GoTextureGlow:SetTexture("Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\ChallengesGlow-Logo")
    elseif timer.type == TIMER_TYPE_PLAYER_COUNTDOWN then 
        timer.GoTexture:SetTexture("")
        timer.GoTextureGlow:SetTexture("")
    end
end

frame5.CreateTimer = function(self, timerType, timeSeconds, totalTime)
    if not timerType then return end
    local timer
    local isTimerRunning = false
    for _, frame5 in ipairs(self.timerList) do
        if frame5.type == timerType and not frame5.isFree then
            timer = frame5
            isTimerRunning = true
            break
        end
    end
    if isTimerRunning and timer.type == TIMER_TYPE_PVP then
        if not timer.StartNumbers:IsPlaying() then
            timer.time = timeSeconds
            timer.endTime = GetTime() + timeSeconds
            
            timer.StartNumbers:Play()
            timer.StartGlowNumbers:Play()
        end
    else
        for _, frame5 in ipairs(self.timerList) do
            if frame5.isFree then
                timer = frame5
                break
            end
        end
        if not timer then
            timer = self:CreateTimerTexture()
            self.timerList[#self.timerList + 1] = timer
        end
        
        timer:ClearAllPoints()
        timer:SetPoint("TOP", 0, -155 - (24 * #self.timerList))
        
        timer.isFree = false
        timer.type = timerType
        timer.time = timeSeconds
        timer.endTime = GetTime() + timeSeconds
        timer.totalTime = totalTime
        timer.style = TIMER_NUMBERS_SETS["BigGold"]
        
        timer.Digit1:SetSize(timer.style.w / 2, timer.style.h / 2)
        timer.Digit2:SetSize(timer.style.w / 2, timer.style.h / 2)
        timer.Digit1.width = timer.style.w / 2
        timer.Digit2.width = timer.style.w / 2
        timer.Digit1:SetTexture(timer.style.texture)
        timer.Digit2:SetTexture(timer.style.texture)
        timer.Digit1.Glow:SetTexture(timer.style.texture.."Glow")
        timer.Digit2.Glow:SetTexture(timer.style.texture.."Glow")
        timer.updateTime = TIMER_DATA[timer.type].updateInterval
        timer:Show()
        
        self:SetGoTexture(timer)
        
        if ( timer.time < TIMER_DATA[timer.type].mediumMarker ) then
            timer.anchorCenter = false;
            if timer.time < TIMER_DATA[timer.type].largeMarker then
                self:SwitchToLargeDisplay(timer);
            end
            timer.StartNumbers:Play()
            timer.StartGlowNumbers:Play()
            if timer.updateTime <= 0 then
                timer.updateTime = TIMER_DATA[timer.type].updateInterval;
            end
        end
    end
end

function frame5:ReleaseTimers()
    for _, timer in ipairs(self.timerList) do
        if timer.StartNumbers:IsPlaying() then
            timer.StartNumbers:Finish()
            timer.StartGlowNumbers:Finish()
        end
        timer.isFree = true
    end
end

function TimerTracker_OnEvent(self, event, ...) --/script TimerTracker_OnEvent(TimerTracker, "START_TIMER", 1, 10, 60)
    if event == "START_TIMER" and ... then
        local timerType, timeSeconds, totalTime = ...
        frame5:CreateTimer(timerType, timeSeconds, totalTime)
    end
end
frame5:RegisterEvent("START_TIMER")
frame5:SetScript("OnEvent", TimerTracker_OnEvent)
end
