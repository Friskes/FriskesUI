function RunTasteForBloodTimer()
--Таймер вкуса крови вара
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetPoint("BOTTOMLEFT", FuiDB.position.TasteForBloodTimer_XPOS, FuiDB.position.TasteForBloodTimer_YPOS)
frame:SetSize(42, 42)
frame:Hide()

frame.texture = frame:CreateTexture(nil, "BORDER")
frame.texture:SetAllPoints()
frame.texture:SetTexture("Interface\\Icons\\Ability_Rogue_HungerforBlood")

frame.cooldown = CreateFrame("Cooldown", nil, frame)
frame.cooldown:SetAllPoints()
frame.cooldown:SetDrawEdge(true)

local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local duration = 6
local Update = 0

function frame.Hide_OnUpdate(Frame)

	Frame:SetScript("OnUpdate", function(self, elapsed)
        Update = Update - elapsed

        if self.timestamp - GetTime() < 0.05 then
            self:SetScript("OnUpdate", nil)
            self:Hide()
        end
        --print("OnUpdate", self.timestamp - GetTime())
	end)
end

local function TasteForBloodTimer_OnEvent(self, event, ...)

    if ( event == "COMBAT_LOG_EVENT_UNFILTERED" and ... ) then
        local _, subEvent, sourceGUID, _, srcFlags, _, _, _, spellID = ...

        if ( subEvent == "SPELL_AURA_APPLIED" and spellID == 60503 ) then

            if ( srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE ) ~=0 ) then
                self.sourceGUID = sourceGUID

                self.cooldown:SetCooldown(GetTime(), duration)
                self.timestamp = GetTime() + duration

                self:Show()
                self:SetAlpha(1)
                self.texture:SetDesaturated(false)
            end

        elseif ( subEvent == "SPELL_AURA_REMOVED" and spellID == 60503 ) then
            self.sourceGUID = sourceGUID

            self:Hide_OnUpdate()
            self:SetAlpha(0.6)
            self.texture:SetDesaturated(true)
        end

    elseif ( event == "PLAYER_ENTERING_WORLD" ) then
        self:Hide()
    end
end

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", TasteForBloodTimer_OnEvent)

function StartMoveTasteForBloodTimer()
    frame:Show()
    frame.timestamp = GetTime() + 10000
    frame.cooldown:SetCooldown(GetTime(), duration)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:SetScript("OnMouseDown", function(self, button)
    frame:StartMoving()
end)
    frame:SetScript("OnMouseUp", function(self, button)
    frame:StopMovingOrSizing()
    FuiDB.position.TasteForBloodTimer_XPOS = frame:GetLeft()
    FuiDB.position.TasteForBloodTimer_YPOS = frame:GetBottom()
end)
end

function StopMoveTasteForBloodTimer()
    frame:Hide()
    frame:EnableMouse(false)
    frame:SetMovable(false)
end
end
