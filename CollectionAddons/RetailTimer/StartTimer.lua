--[[
----- >> RU << -----
Вы можете запустить этот таймер самостоятельно с любого из ваших собственных аддонов. Для этого вам необходимо отправить событие:
RunFakeTestTimer:OnEvent("START_TIMER", timerType, timeSeconds, totalTime)

Где "timerType" это тип таймера:
1 = полоса прогресса (сверху) затем большие цифры (сначала сверху, потом в центре)
2 = большие цифры (только в центре)
3 = большие цифры (сначала сверху потом в центре)

"timeSeconds" это количество времени в секундах которое должен отсчитать таймер.
"totalTime" это максимальное количество времени в секундах.

Тестовый макрос: /script RunFakeTestTimer:OnEvent("START_TIMER", 1, 15, 60)

----- >> ENG << -----
You can start this timer yourself from any of your own addons. To do this, you need to send an event:
RunFakeTestTimer:OnEvent("START_TIMER", timerType, timeSeconds, totalTime)

Where "timerType" is the timer type:
1 = status bar (top) then big numbers (top first, then center)
2 = big numbers (only in the center)
3 = big numbers (first top then center)

"timeSeconds" is the amount of time in seconds that the timer should count down.
"totalTime" is the maximum amount of time in seconds.

Macro for test: /script RunFakeTestTimer:OnEvent("START_TIMER", 1, 15, 60)
]]

function RunStartTimer()
-- Таймер до начала сражения

local enableSound = false -- вкл/выкл звук

local ipairs = ipairs
local unpack = unpack
local select = select
local floor, fmod = math.floor, math.fmod
local format = format
local GetTime = GetTime
local UnitFactionGroup = UnitFactionGroup
local GetBattlefieldInstanceRunTime = GetBattlefieldInstanceRunTime
local GetWintergraspWaitTime = GetWintergraspWaitTime
local GetZoneText, GetMapInfo = GetZoneText, GetMapInfo
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local GetNumBattlefieldScores = GetNumBattlefieldScores
local UnitName = UnitName
local GetBattlefieldScore = GetBattlefieldScore
local PLAYER_FACTION_GROUP = PLAYER_FACTION_GROUP
local CreateFrame = CreateFrame
local UIParent = UIParent
local PlaySoundFile = PlaySoundFile

local Timer = CreateFrame("Frame")
RunFakeTestTimer = Timer

Timer.PVP = {}
local C_PVP = Timer.PVP
C_PVP["Низина Арати"] = true
C_PVP["Остров Завоеваний"] = true
C_PVP["Око Бури"] = true
C_PVP["Берег Древних"] = true
C_PVP["Альтеракская долина"] = true
C_PVP["Ущелье Песни Войны"] = true
C_PVP["Крепость Среброкрылых"] = true
C_PVP["Лесопилка Песни Войны"] = true
C_PVP["Озеро Ледяных Оков"] = true

C_PVP["Warsong Gulch"] = true
C_PVP["Arathi Basin"] = true
C_PVP["Alterac Valley"] = true
C_PVP["Eye of the Storm"] = true
C_PVP["Isle of Conquest"] = true
C_PVP["Strand of the Ancients"] = true
C_PVP["Wintergrasp"] = true

C_PVP["Руины Лордерона"] = true
C_PVP["Арена Острогорья"] = true
C_PVP["Арена Награнда"] = true
C_PVP["Арена Даларана"] = true
C_PVP["Арена Доблести"] = true
C_PVP["Ruins Of Lordaeron"] = true
C_PVP["Blade's Edge Arena"] = true
C_PVP["Nagrand Arena"] = true
C_PVP["Dalaran Arena"] = true
C_PVP["The Ring of Valor"] = true

local C_Map = {}
C_Map["AlteracValley"] = {}
C_Map["ArathiBasin"] = {}
C_Map["NetherstormArena"] = {}
C_Map["WarsongGulch"] = {}
C_Map["IsleofConquest"] = {}
C_Map["StrandoftheAncients"] = {}
C_Map["LakeWintergrasp"] = {}

C_Map["AlteracValley"].timeSeconds       = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["ArathiBasin"].timeSeconds         = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["NetherstormArena"].timeSeconds    = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["WarsongGulch"].timeSeconds        = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["IsleofConquest"].timeSeconds      = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["StrandoftheAncients"].timeSeconds = function() return GetBattlefieldInstanceRunTime() / 1000 end
C_Map["LakeWintergrasp"].timeSeconds     = function() return GetWintergraspWaitTime() end

C_PVP.IsPVPMap = function()
    return C_PVP[GetZoneText()]
end

C_PVP.GetRunTimeInfo = function()
    if not C_PVP[GetZoneText()] then
        return 0, 0
    end
    local timeSeconds, totalTime
    if ( not IsActiveBattlefieldArena() ) then
        if not C_Map[GetMapInfo()] then return end
        totalTime = 120
        timeSeconds = totalTime - C_Map[GetMapInfo()].timeSeconds()
    else
        totalTime = 60
        timeSeconds = totalTime - GetBattlefieldInstanceRunTime() / 1000
    end
    return timeSeconds, totalTime
end

local timerTypes = {
    ["30-120"]  = {1, 30, 120},
    ["60-120"]  = {1, 60, 120},
    ["120-120"] = {1, 120, 120},
    ["15-60"]   = {1, 15, 60},
    ["30-60"]   = {1, 30, 60},
    ["60-60"]   = {1, 60, 60},
}

local chatMessage = {
    -- Ущелье Песни Войны
    ["Битва за Ущелье Песни Войны начнется через 30 секунд. Приготовьтесь!"] = timerTypes["30-120"],
    ["Битва за Ущелье Песни Войны начнется через 1 минуту."] = timerTypes["60-120"],
    ["Сражение в Ущелье Песни Войны начнется через 2 минуты."] = timerTypes["120-120"],
    -- Низина Арати
    ["Битва за Низину Арати начнется через 30 секунд. Приготовьтесь!"] = timerTypes["30-120"],
    ["Битва за Низину Арати начнется через 1 минуту."] = timerTypes["60-120"],
    ["Сражение в Низине Арати начнется через 2 минуты."] = timerTypes["120-120"],
    -- Око Бури
    ["Битва за Око Бури начнется через 30 секунд."] = timerTypes["30-120"],
    ["Битва за Око Бури начнется через 1 минуту."] = timerTypes["60-120"],
    ["Сражение в Око Бури начнется через 2 минуты."] = timerTypes["120-120"],
    -- Альтеракская долина
    ["Сражение на Альтеракской долине начнется через 30 секунд. Приготовьтесь!"] = timerTypes["30-120"],
    ["Сражение на Альтеракской долине начнется через 1 минуту."] = timerTypes["60-120"],
    ["Сражение на Альтеракской долине начнется через 2 минуты."] = timerTypes["120-120"],
    ["30 секунд до начала битвы в Альтеракской долине."] = timerTypes["30-120"],
    ["До начала сражения за Альтеракскую долину остается 1 минута."] = timerTypes["60-120"],
    ["До начала сражения за Альтеракскую долину остается 2 минута."] = timerTypes["120-120"],
    -- Берег Древних
    ["Битва за Берег Древних начнется через 30 секунд. Приготовьтесь!"] = timerTypes["30-120"],
    ["Битва за Берег Древних начнется через 1 минуту."] = timerTypes["60-120"],
    ["Битва за Берег Древних начнется через 2 минуты."] = timerTypes["120-120"],
    -- Берег древних 2-й раунд
    ["Второй раунд начнется через 30 секунд. Приготовьтесь!"] = timerTypes["30-60"],
    ["Второй раунд битвы за Берег Древних начнется через 1 минуту."] = timerTypes["60-60"],
    -- Другие
    ["Битва начнется через 30 секунд!"] = timerTypes["30-120"],
    ["Битва начнется через 1 минуту."] = timerTypes["60-120"],
    ["Битва начнется через минуту!"] = timerTypes["60-120"],
    ["Битва начнется через 2 минуты."] = timerTypes["120-120"],
    -- Арена
    ["15 секунд до начала боя на арене!"] = timerTypes["15-60"],
    ["30 секунд до начала боя на арене!"] = timerTypes["30-60"],
    ["1 минута до начала боя на арене!"] = timerTypes["60-60"],
    ["Пятнадцать секунд до начала боя на арене!"] = timerTypes["15-60"],
    ["Тридцать секунд до начала боя на арене!"] = timerTypes["30-60"],
    ["Одна минута до начала боя на арене!"] = timerTypes["60-60"],
    -- WSG
    ["The battle for Warsong Gulch begins in 30 seconds. Prepare yourselves!"] = timerTypes["30-120"],
    ["The battle for Warsong Gulch begins in 1 minute."] = timerTypes["60-120"],
    ["The battle for Warsong Gulch begins in 2 minutes."] = timerTypes["120-120"],
    -- AB
    ["The Battle for Arathi Basin begins in 30 seconds. Prepare yourselves!"] = timerTypes["30-120"],
    ["The Battle for Arathi Basin begins in 1 minute."] = timerTypes["60-120"],
    ["The battle for Arathi Basin begins in 2 minutes."] = timerTypes["120-120"],
    -- EotS
    ["The Battle for Eye of the Storm begins in 30 seconds."] = timerTypes["30-120"],
    ["The Battle for Eye of the Storm begins in 1 minute."] = timerTypes["60-120"],
    ["The battle for Eye of the Storm begins in 2 minutes."] = timerTypes["120-120"],
    -- AV
    ["The Battle for Alterac Valley begins in 30 seconds. Prepare yourselves!"] = timerTypes["30-120"],
    ["The Battle for Alterac Valley begins in 1 minute."] = timerTypes["60-120"],
    ["The Battle for Alterac Valley begins in 2 minutes."] = timerTypes["120-120"],
    -- SotA
    ["The battle for Strand of the Ancients begins in 30 seconds. Prepare yourselves!."] = timerTypes["30-120"],
    ["The battle for Strand of the Ancients begins in 1 minute."] = timerTypes["60-120"],
    ["The battle for Strand of the Ancients begins in 2 minutes."] = timerTypes["120-120"],
    -- SotA 2 round
    ["Round 2 begins in 30 seconds. Prepare yourselves!"] = timerTypes["30-60"],
    ["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute."] = timerTypes["60-60"],
    -- Other
    ["The battle will begin in 30 seconds!"] = timerTypes["30-120"],
    ["The battle will begin in 1 minute."] = timerTypes["60-120"],
    ["The battle will begin in two minutes."] = timerTypes["120-120"],
    ["The battle begins in 30 seconds!"] = timerTypes["30-120"],
    ["The battle begins in 1 minute!"] = timerTypes["60-120"],
    ["The battle begins in 2 minutes!"] = timerTypes["120-120"],
    -- Arena
    ["Fifteen seconds until the Arena battle begins!"] = timerTypes["15-60"],
    ["Thirty seconds until the Arena battle begins!"] = timerTypes["30-60"],
    ["One minute until the Arena battle begins!"] = timerTypes["60-60"],
}

local TIMER_TYPE_PVP = 1
local TIMER_TYPE_CHALLENGE_MODE = 2
local TIMER_TYPE_PLAYER_COUNTDOWN = 3

local SOUNDKIT = {
    UI_COUNTDOWN_TIMER = "Interface\\AddOns\\FriskesUI\\Media\\Sounds\\RetailTimer\\Countdown.ogg",
    UI_COUNTDOWN_FINISHED = "Interface\\AddOns\\FriskesUI\\Media\\Sounds\\RetailTimer\\Finish.ogg",
}

local TIMER_DATA = {
    [1] = { mediumMarker = 11, largeMarker = 6, updateInterval = 10 },
    [2] = { mediumMarker = 100, largeMarker = 100, updateInterval = 100 },
    [3] = { mediumMarker = 31, largeMarker = 11, updateInterval = 10,

        finishedSoundKitID = SOUNDKIT.UI_COUNTDOWN_FINISHED,
        bigNumberSoundKitID = SOUNDKIT.UI_COUNTDOWN_TIMER,
    },
}

local TIMER_NUMBERS_SETS = {};
TIMER_NUMBERS_SETS["BigGold"] = { texture = "Interface\\AddOns\\FriskesUI\\Media\\Textures\\RetailTimer\\BigTimerNumbers",
    w=256, h=170, texW=1024, texH=512,
    numberHalfWidths = {
    --    0       1       2       3       4       5       6       7       8       9
        35/128, 14/128, 33/128, 32/128, 36/128, 32/128, 33/128, 29/128, 31/128, 31/128,
    },
}

local function GetBattlefieldArenaFaction()
    for index = 1, GetNumBattlefieldScores() do
        local name = GetBattlefieldScore(index);
        local playerName = UnitName("player")
        local faction = select(6, GetBattlefieldScore(index));
        if playerName == name then
            return faction
        end
    end
end

local function GetPlayerFactionGroup()
    local factionGroup = UnitFactionGroup("player");
    if ( not IsActiveBattlefieldArena() ) then
        factionGroup = PLAYER_FACTION_GROUP[GetBattlefieldArenaFaction()];
    end
    return factionGroup
end

----------------- >> Block for Create BigNumbers << -----------------

Timer.timerList = {}
function Timer:SetTexNumbers(timer, ...)
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
            if enableSound then
                PlaySoundFile(SOUNDKIT.UI_COUNTDOWN_TIMER)
            end
        else
            digits[1]:SetPoint("CENTER", timer, "CENTER", numberOffset - digits[1].hw, 0)
            if enableSound then
                PlaySoundFile(SOUNDKIT.UI_COUNTDOWN_TIMER)
            end
        end

        for j = 2, numShown do
            digits[j]:ClearAllPoints()
            digits[j]:SetPoint("CENTER", digits[j - 1], "CENTER", -(digits[j].hw + digits[j - 1].hw), 0)
        end
    end
end

local function StartNumbers_OnPlay(self)
    local timer = self:GetParent():GetParent()
    Timer:SetTexNumbers(timer, timer.Digit1, timer.Digit2)
end

function Timer:SwitchToLargeDisplay(timer)
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
            Timer:SwitchToLargeDisplay(timer)
        end
        timer.StartNumbers:Play()
        timer.StartGlowNumbers:Play()
    else
        if enableSound then
            PlaySoundFile(SOUNDKIT.UI_COUNTDOWN_FINISHED)
        end

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

Timer.CreateTimerTexture = function(self)
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

function Timer:SetGoTexture(timer)
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

Timer.CreateTimer = function(self, timerType, timeSeconds, totalTime)
    if not timerType then return end
    local timer
    local isTimerRunning = false
    for _, value in ipairs(self.timerList) do
        if value.type == timerType and not value.isFree then
            timer = value
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
        for _, value in ipairs(self.timerList) do
            if value.isFree then
                timer = value
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

function Timer:ReleaseTimers()
    for _, timer in ipairs(self.timerList) do
        if timer.StartNumbers:IsPlaying() then
            timer.StartNumbers:Finish()
            timer.StartGlowNumbers:Finish()
        end
        timer.isFree = true
    end
end

----------------------------- >> Create Status Bar << -----------------------------

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

local Update = 0
local time
local Duration
local timeANDduration
local seconds
local TimeForStartBigNumbers = 10

local dur
local exp
local expiration
local enabled

function frame:OnUpdate(elapsed)

    Update = Update + elapsed

    timeANDduration = time + Duration -- time время начала отсчета GetTime, Duration количество секунд которое нужно отсчитать

    seconds = floor(timeANDduration - GetTime() * 1)

    text:SetText(frame.Format_Text(seconds) )

    expiration = expiration - elapsed

    frame2:SetValue(expiration)

    if GetTime() >= timeANDduration - ( TimeForStartBigNumbers + 1 ) then
        frame4:OnUpdate() -- запускаем анимацию исчезновения
	end

	if GetTime() >= timeANDduration - TimeForStartBigNumbers then
        enabled = true
        Timer:CreateTimer(1, exp - GetTime(), dur) -- запускаем анимированные цифры

		frame:Hide() -- если заканчивается отсчёт то отключаем OnUpdate
	end
end

function frame.Format_Text(seconds) -- форматируем секунды в минуты:секунды

	local minutes = (fmod(seconds, 3600) / 60)

	seconds = (fmod(seconds, 60) )

	return format("%d:%02d", minutes, seconds) -- "%01d:%02d"
end

function frame.MSG_ArenaStart(gettime) -- принимаем аргумент GetTime и делаем его переменной
	time = gettime
end

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

Timer.CreateTimerBar = function(self, timerType, timeSeconds, totalTime)
    if not timerType or not timeSeconds then return end

    if timeSeconds < TIMER_DATA[timerType].mediumMarker then
        return self:CreateTimer(timerType, timeSeconds, totalTime)
    end

    if enabled then
        enabled = false
        frame2:SetMinMaxValues(0, timeSeconds)
    end
    frame:Show()
    frame:SetScript("OnUpdate", frame.OnUpdate)
    Duration = timeSeconds - 1 -- для того что бы большие цифры стартовали с 10сек
    frame.MSG_ArenaStart(GetTime() )
    frame3:OnUpdate()

    dur = totalTime
    exp = timeSeconds + GetTime() - 0.01
    expiration = timeSeconds
end

Timer.newZone = GetZoneText()
Timer.lastZone = Timer.newZone

Timer.UpdateStates = function(self)
    if exp and dur then
        local timeSeconds = exp - GetTime()
        local totalTime = dur
        if ( timeSeconds < 0 ) then
        elseif ( timeSeconds < TIMER_DATA[TIMER_TYPE_PVP].mediumMarker ) then
            return self:CreateTimer(TIMER_TYPE_PVP, timeSeconds, totalTime)
        else
            return self:CreateTimerBar(TIMER_TYPE_PVP, timeSeconds, totalTime)
        end
    end

    if C_PVP.IsPVPMap() then
        local timeSeconds, totalTime = C_PVP.GetRunTimeInfo()
        if timeSeconds and timeSeconds < 0 then return end
        if timeSeconds and timeSeconds < TIMER_DATA[TIMER_TYPE_PVP].mediumMarker then
            return self:CreateTimer(TIMER_TYPE_PVP, timeSeconds, totalTime)
        else
            return self:CreateTimerBar(TIMER_TYPE_PVP, timeSeconds, totalTime)
        end
    end
end

----------------- >>>>>>> MAIN EVENT <<<<<<< -----------------

function Timer:OnEvent(event, ...)
    if event == "ZONE_CHANGED_NEW_AREA" then
        local newZone = GetZoneText()
        if not ( newZone == self.lastZone ) then
            self.lastZone = newZone
            self:ReleaseTimers()
            return self:UpdateStates()
        else
            self.lastZone = newZone
            return self:UpdateStates()
        end
    elseif event == "START_TIMER" and ... then
        local timerType, timeSeconds, totalTime = ...
        if timerType == TIMER_TYPE_PVP then
            return self:CreateTimerBar(timerType, timeSeconds, totalTime)
        elseif  ( timerType == TIMER_TYPE_CHALLENGE_MODE or timerType == TIMER_TYPE_PLAYER_COUNTDOWN ) then
            self:CreateTimer(timerType, timeSeconds, totalTime)
        end
    elseif event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" and ... then
        local msg = ...
        if msg and chatMessage[msg] then
            return self:CreateTimerBar(unpack(chatMessage[msg]))
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        enabled = true
        Update2 = 0 -- Update находиться внутри ивента что бы анимация срабатывала только при первом входе на арену а не при каждом msg
        frame:Hide() -- если находимся вне арены то скрываем отсчёт
        --dur = 0
        exp = 0 -- если выходим со сражения то скрываем активный отсчёт
    end
end
Timer:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Timer:RegisterEvent("START_TIMER")
Timer:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
Timer:RegisterEvent("PLAYER_ENTERING_WORLD")
Timer:SetScript("OnEvent", Timer.OnEvent)
end
