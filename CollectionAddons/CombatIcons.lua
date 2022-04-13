function RunCombatIcons()
-- Иконка комбата возле фреймов плеера, таргета и фокуса
CPT = CreateFrame("Frame")
CPT:SetParent(PlayerFrame)
CPT:SetPoint("Left", PlayerFrame, 15.7, 5)
CPT:SetSize(25, 25)
CPT.t = CPT:CreateTexture(nil, "BORDER")
CPT.t:SetAllPoints()
CPT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CPT:Hide()

local function FrameOnUpdate(self)
    if UnitAffectingCombat("player") then
        self:Show()
        PlayerPVPIcon:SetAlpha(0)
    else
        self:Hide()
        PlayerPVPIcon:SetAlpha(1)
    end
end

local g = CreateFrame("Frame")
g:SetScript("OnUpdate", function(self)
    --FrameOnUpdate(CPT)
end)

CTT = CreateFrame("Frame")
CTT:SetParent(TargetFrame)
CTT:SetPoint("Right", TargetFrame, -14.5, 5)
CTT:SetSize(26, 26)
CTT.t = CTT:CreateTexture(nil, "BORDER")
CTT.t:SetAllPoints()
CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CTT:Hide()

local function FrameOnUpdate(self)
    if UnitAffectingCombat("target") then
        self:Show()
        TargetFrameTextureFramePVPIcon:SetAlpha(0)
    else
        self:Hide()
        TargetFrameTextureFramePVPIcon:SetAlpha(1)
    end
end

local g = CreateFrame("Frame")
g:SetScript("OnUpdate", function(self)
    FrameOnUpdate(CTT)
end)

CFT = CreateFrame("Frame")
CFT:SetParent(FocusFrame)
CFT:SetPoint("Right", FocusFrame, -14.5, 5)
CFT:SetSize(26, 26)
CFT.t = CFT:CreateTexture(nil, "BORDER")
CFT.t:SetAllPoints()
CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CFT:Hide()

local function FrameOnUpdate(self)
    if UnitAffectingCombat("focus") then
        self:Show()
        FocusFrameTextureFramePVPIcon:SetAlpha(0)
    else
        self:Hide()
        FocusFrameTextureFramePVPIcon:SetAlpha(1)
    end
end

local g = CreateFrame("Frame")
g:SetScript("OnUpdate", function(self)
    FrameOnUpdate(CFT)
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
end
