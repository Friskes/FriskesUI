function RunTremorTotemTimer()
-- Тик тотема трепета
local frame = CreateFrame("StatusBar", nil, UIParent)
frame:SetPoint("BOTTOMLEFT", FuiDB.position.TremorTotemTimer_XPOS, FuiDB.position.TremorTotemTimer_YPOS)
frame:SetSize(33, 33)
frame:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
frame:SetStatusBarColor(0, 0, 0, 0.80)
frame:SetOrientation("VERTICAL")
frame:SetMinMaxValues(0, 3)

local icon = frame:CreateTexture(nil, "BORDER")
icon:SetAllPoints()
icon:SetTexCoord(0, 1, 0, 1)
icon:SetTexture([[Interface\Icons\Spell_Nature_TremorTotem]])

local background = frame:CreateTexture(nil, "BACKGROUND")
background:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
background:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
background:SetTexture([[Interface\Buttons\WHITE8X8]])
background:SetVertexColor(0, 0, 0)

local GetTime = GetTime
local summonTime
frame:SetScript("OnUpdate", function(self)
    self:SetValue( (GetTime() - summonTime) % 3)
end)

local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local band = bit.band
local totemGUID
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, _, subEvent, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:Hide()
    else
        if subEvent == "SPELL_SUMMON" and IsActiveBattlefieldArena() then
            local _, _, srcFlags, objGUID, _, _, spellid = ...
            if band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 and spellid == 8143 then
                summonTime, totemGUID = GetTime(), objGUID
                self:Show()
            end
        elseif subEvent == "UNIT_DIED" then
            local _, _, _, objGUID = ...
            if objGUID == totemGUID then
                self:Hide()
            end
        end
    end
end)

function StartMoveTremorTotemTimer()
    frame:SetScript("OnUpdate", function(self)
        self:SetValue( (GetTime() - summonTime) % 3)
    end)
    summonTime = GetTime()
    frame:Show()
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:SetScript("OnMouseDown", function(self, button)
    frame:StartMoving()
end)
    frame:SetScript("OnMouseUp", function(self, button)
    frame:StopMovingOrSizing()
    FuiDB.position.TremorTotemTimer_XPOS = frame:GetLeft()
    FuiDB.position.TremorTotemTimer_YPOS = frame:GetBottom()
end)
end

function StopMoveTremorTotemTimer()
    frame:Hide()
    frame:EnableMouse(false)
    frame:SetMovable(false)
end
end
