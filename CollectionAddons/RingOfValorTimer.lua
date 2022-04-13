function RunRingOfValorTimer()
-- Таймер поднятия пиларов на арене доблести
-- /script RoV_Timer_Event(nil, nil, "test")
-- /script RoV_Timer_Event(nil, nil, "reset")
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetPoint("BOTTOMLEFT", FuiDB.position.RingOfValorTimer_XPOS, FuiDB.position.RingOfValorTimer_YPOS)
frame:SetSize(40, 40)

frame.cooldown = CreateFrame("Cooldown")
frame.cooldown:SetFrameLevel(1)
frame.cooldown:SetAllPoints(frame)
frame.cooldown:SetDrawEdge(true)
frame.texture = frame:CreateTexture(nil, "BORDER")
frame.texture:SetAllPoints()
frame.texture:SetTexture("Interface\\Icons\\Ability_Smash")
frame:Hide()

local pillar = 0
local timeElapsed = 0
local timeElapsed2 = 0
local RoV_Timer_Test = 1

local function RoV_Timer_Disable()
    frame:Hide()
    frame:SetScript("OnUpdate", nil)
    CooldownFrame_SetTimer(frame.cooldown, GetTime(), 0, 1)
    pillar = nil
    timeElapsed = 0
end

local function RoV_Timer_Update(self, elapsed)
    timeElapsed = timeElapsed + elapsed
    timeElapsed2 = timeElapsed2 + elapsed

    if (timeElapsed2 >= RoV_Timer_Test) then
        timeElapsed2 = 0
        if not IsActiveBattlefieldArena() then
            RoV_Timer_Disable()
        end
    end

    if not pillar then
        if (timeElapsed >= 45) then
            CooldownFrame_SetTimer(frame.cooldown, GetTime(), 25, 1)
            pillar = 25
            timeElapsed = 0
        end
    elseif pillar == 25 then
        if (timeElapsed >= 25) then
            CooldownFrame_SetTimer(frame.cooldown, GetTime(), 25, 1)
            pillar = 25
            timeElapsed = 0
        end
    end
end

function RoV_Timer_Event(self, event, msg)

    if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" or event == "CHAT_MSG_RAID_BOSS_EMOTE" then

        if msg == "Битва на арене началась!" or msg == "The battle in the arena has begun!" or msg == "The Arena battle has begun!" then

            if (GetRealZoneText() == "Арена Доблести" or GetRealZoneText() == "The Ring of Valor") then

                frame.texture:SetTexture("Interface\\Icons\\Ability_Smash")
                frame:Show()
                CooldownFrame_SetTimer(frame.cooldown, GetTime(), 45, 1)
                frame:SetScript("OnUpdate", RoV_Timer_Update)
            end
        end
    elseif msg == "test" then
        RoV_Timer_Test = 10000
        frame:Show()
        CooldownFrame_SetTimer(frame.cooldown, GetTime(), 45, 1)
        frame:SetScript("OnUpdate", RoV_Timer_Update)
    elseif msg == "reset" then
        RoV_Timer_Test = 1
        RoV_Timer_Disable()
    elseif event == "PLAYER_ENTERING_WORLD" then
        RoV_Timer_Disable()
    end
end

frame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", RoV_Timer_Event)

function StartMoveRingOfValorTimer()
    RoV_Timer_Event(nil, nil, "test")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:SetScript("OnMouseDown", function(self, button)
    frame:StartMoving()
end)
    frame:SetScript("OnMouseUp", function(self, button)
    frame:StopMovingOrSizing()
    FuiDB.position.RingOfValorTimer_XPOS = frame:GetLeft()
    FuiDB.position.RingOfValorTimer_YPOS = frame:GetBottom()
end)
end

function StopMoveRingOfValorTimer()
    RoV_Timer_Event(nil, nil, "reset")
    frame:EnableMouse(false)
    frame:SetMovable(false)
end
end
