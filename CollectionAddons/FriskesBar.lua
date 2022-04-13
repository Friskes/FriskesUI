function RunFriskesBar()
local config = {
    ShapeshiftBar = {
        offsetX = -0.2,
    },
    TotemBar = {
        offsetX = -4,
    },
    LeaveButton = {
        offsetX = -36,
    },
    PetBar = {
        offsetX = 127,
    },
    PossessBar = {
        offsetX = 0,
    },
}

local gridShown = false
local initTime = 0

FriskesBar = CreateFrame("Frame", "FriskesBar", UIParent)

function FriskesBar:Startup()
    hooksecurefunc("UIParent_ManageFramePositions", FriskesBar.UpdateUI);
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil

    MainMenuBarPageNumber:Hide();
    --ActionBarUpButton:Hide();
    --ActionBarDownButton:Hide();

    --ShapeshiftBarLeft:SetAlpha(0)
    --ShapeshiftBarMiddle:SetAlpha(0)
    --ShapeshiftBarRight:SetAlpha(0)

    --SlidingActionBarTexture0:SetAlpha(0)
    --SlidingActionBarTexture1:SetAlpha(0)

    --MainMenuXPBarTexture0:Hide();
    MainMenuXPBarTexture1:Hide();
    MainMenuXPBarTexture2:Hide();
    --MainMenuXPBarTexture3:Hide();

    --MainMenuBarTexture0:Hide();
    --MainMenuBarTexture1:Hide();
    MainMenuBarTexture2:Hide();
    MainMenuBarTexture3:Hide();

    --BonusActionBarTexture0:Hide();
    --BonusActionBarTexture1:Hide();

    --MainMenuMaxLevelBar0:Hide();
    --MainMenuMaxLevelBar1:Hide();
    MainMenuMaxLevelBar2:Hide();
    MainMenuMaxLevelBar3:Hide();

    --MainMenuBarLeftEndCap:Hide();
    --MainMenuBarRightEndCap:Hide();

    --ReputationWatchBarTexture0:SetTexture("");
    ReputationWatchBarTexture1:SetTexture("");
    ReputationWatchBarTexture2:SetTexture("");
    --ReputationWatchBarTexture3:SetTexture("");

    --ReputationXPBarTexture0:SetTexture("");
    ReputationXPBarTexture1:SetTexture("");
    ReputationXPBarTexture2:SetTexture("");
    --ReputationXPBarTexture3:SetTexture("");

    MainMenuBar:SetWidth(512);
    MainMenuExpBar:SetWidth(512);
    MainMenuExpBar:SetHeight(12);
    ReputationWatchBar:SetWidth(512);
    MainMenuBarMaxLevelBar:SetWidth(512);
    ReputationWatchStatusBar:SetWidth(512);

    MainMenuXPBarTexture0:SetPoint("BOTTOM", "MainMenuExpBar", "BOTTOM", -128, 2);
    MainMenuXPBarTexture3:SetPoint("BOTTOM", "MainMenuExpBar", "BOTTOM", 128, 2);
    ReputationWatchBarTexture3:ClearAllPoints();
    ReputationWatchBarTexture3:SetPoint("BOTTOM", "ReputationWatchBar", "BOTTOM", 128, 2);
    ReputationXPBarTexture3:ClearAllPoints();
    ReputationXPBarTexture3:SetPoint("BOTTOM", "ReputationWatchBar", "BOTTOM", 128, 1);
    MainMenuMaxLevelBar0:SetPoint("BOTTOM", "MainMenuBarMaxLevelBar", "TOP", -128, 0);
    MainMenuBarTexture0:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -128, 0);
    MainMenuBarTexture1:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 128, 0);
    MainMenuBarLeftEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -288, 0);
    MainMenuBarRightEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 289, 0);

    PetActionBarFrame:SetAttribute("unit", "pet")
    --RegisterUnitWatch(PetActionBarFrame)

    self:RegisterEvent("ACTIONBAR_SHOWGRID");
    self:RegisterEvent("ACTIONBAR_HIDEGRID");
    self:RegisterEvent("UNIT_EXITED_VEHICLE");
    self:RegisterEvent("UNIT_ENTERED_VEHICLE");
    self:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:SetScript("OnEvent", self.OnEvent);

    return true
end

function MakeInvisible(frame)
    frame:Hide()
    frame:SetAlpha(0)
end

function FriskesBar:UpdateUI()
    if InCombatLockdown() then
        return
    end

    MakeInvisible(SlidingActionBarTexture0)
    MakeInvisible(SlidingActionBarTexture1)
    MakeInvisible(ShapeshiftBarLeft)
    MakeInvisible(ShapeshiftBarMiddle)
    MakeInvisible(ShapeshiftBarRight)
    MakeInvisible(PossessBackground1)
    MakeInvisible(PossessBackground2)

    FriskesBar:UpdateActionBars()

    MainMenuBar:SetScale(FuiDB.ScaleBar)
    VehicleMenuBar:SetScale(FuiDB.ScaleBar)
    MultiBarBottomRight:SetScale(FuiDB.ScaleBar)
    MultiBarBottomLeft:SetScale(FuiDB.ScaleBar)
    MultiBarRight:SetScale(FuiDB.ScaleBar)
    MultiBarLeft:SetScale(FuiDB.ScaleBar)
    BagPackFrame:SetScale(FuiDB.ScaleBar)

    return true
end

function FriskesBar:UpdateActionBars()
    local anchor
    local anchorOffset = 4
    local repOffset = 0

    if MainMenuExpBar:IsShown() then
        repOffset = 5

        if ReputationWatchBar:IsShown() then
            repOffset = 9
        end
    end

    if ReputationWatchBar:IsShown() then
        repOffset = repOffset + 5
    end

    if MultiBarBottomLeft:IsShown() then
        anchor = MultiBarBottomLeft
        anchorOffset = 4
    else
        anchor = ActionButton1;
        anchorOffset = 12 + repOffset
    end

    if MultiBarBottomRight:IsShown() then
        MultiBarBottomRight:ClearAllPoints()
        MultiBarBottomRight:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset)
        anchor = MultiBarBottomRight
        anchorOffset = 4
    end

    if ShapeshiftButton1:IsShown() then
        ShapeshiftButton1:ClearAllPoints();
        ShapeshiftButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", config.ShapeshiftBar.offsetX, anchorOffset - 0.5);
        --anchor = ShapeshiftButton1
        --anchorOffset = 4
    end

    if MultiCastActionBarFrame:IsShown() then
        MultiCastActionBarFrame:ClearAllPoints();
        MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", config.TotemBar.offsetX, anchorOffset - 1.5);
        anchor = MultiCastActionBarFrame
        anchorOffset = 4
    end

    if MainMenuBarVehicleLeaveButton:IsShown() then
        MainMenuBarVehicleLeaveButton:ClearAllPoints();
        MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", config.LeaveButton.offsetX, anchorOffset);
        anchor = MainMenuBarVehicleLeaveButton
        anchorOffset = 4
    end

    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", config.PetBar.offsetX, anchorOffset - 0.5)
    --anchor = PetActionButton1
    --anchorOffset = 4

    PossessButton1:ClearAllPoints();
    PossessButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", config.PossessBar.offsetX, anchorOffset - 0.5);
end

MainMenuBarPageNumber:ClearAllPoints()
MainMenuBarPageNumber:SetPoint("CENTER", ActionButton12, 54, 0)

function FriskesBar:OnEvent(event, unit)
    if event == "ACTIONBAR_SHOWGRID" then
        gridShown = true
    elseif event == "ACTIONBAR_HIDEGRID" then
        gridShown = false
    elseif event == "UNIT_ENTERED_VEHICLE" and unit == "player" then
        self:UpdateUI()
    elseif event == "UNIT_EXITED_VEHICLE" and unit == "player" then
        self:UpdateUI()
    elseif event == "PLAYER_ENTERING_WORLD" then
        initTime = GetTime()
        self:SetScript("OnUpdate", function(self)
            if GetTime() > initTime + 5 then
                self:SetScript("OnUpdate", nil)
            end
            self:UpdateUI()
        end)
    else
        self:UpdateUI()
    end
end
FriskesBar:Startup()

-- Текстура под микро меню и сумки

local BagPackFrame_XPOS = 107
local BagPackFrame_YPOS = -84.3

BagPackFrame = CreateFrame("Frame", nil, UIParent)
BagPackFrame:SetFrameStrata("BACKGROUND")
BagPackFrame:SetWidth(512)
BagPackFrame:SetHeight(256)
BagPackTexture = BagPackFrame:CreateTexture(nil, "BACKGROUND")
BagPackTexture:SetTexture("Interface\\AddOns\\FriskesUI\\Media\\Textures\\bagpack.blp")
BagPackTexture:SetAllPoints(BagPackFrame)
BagPackFrame.texture = BagPackTexture
BagPackFrame:Show()
BagPackFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", BagPackFrame_XPOS, BagPackFrame_YPOS)

-- Перемещение микро меню

local MicroButtons = {CharacterMicroButton, SpellbookMicroButton, TalentMicroButton,
                      AchievementMicroButton, QuestLogMicroButton, SocialsMicroButton,
                      PVPMicroButton, LFDMicroButton, MainMenuMicroButton, HelpMicroButton}

hooksecurefunc("VehicleMenuBar_MoveMicroButtons", function(skinName)

    if (not skinName) then

        for _, frame in pairs(MicroButtons) do
            frame:SetParent(MainMenuBarArtFrame);
            frame:Show();
        end

        CharacterMicroButton:ClearAllPoints();
        CharacterMicroButton:SetPoint("CENTER", BagPackFrame, -93.5, -11.8);

        SocialsMicroButton:ClearAllPoints();
        SocialsMicroButton:SetPoint("BOTTOMLEFT", QuestLogMicroButton, "BOTTOMRIGHT", -3, 0);

        UpdateMicroButtons();

    elseif (skinName == "Mechanical") then

        for _, frame in pairs(MicroButtons) do
            frame:SetParent(VehicleMenuBarArtFrame);
            frame:Show();
        end

        CharacterMicroButton:ClearAllPoints();
        CharacterMicroButton:SetPoint("BOTTOMLEFT", VehicleMenuBar, "BOTTOMRIGHT", -340, 41);

        SocialsMicroButton:ClearAllPoints();
        SocialsMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 20);

        UpdateMicroButtons();

    elseif (skinName == "Natural") then

        for _, frame in pairs(MicroButtons) do
            frame:SetParent(VehicleMenuBarArtFrame);
            frame:Show();
        end

        CharacterMicroButton:ClearAllPoints();
        CharacterMicroButton:SetPoint("BOTTOMLEFT", VehicleMenuBar, "BOTTOMRIGHT", -365, 41);

        SocialsMicroButton:ClearAllPoints();
        SocialsMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, 20);

        UpdateMicroButtons();
    end
end)
CharacterMicroButton:ClearAllPoints();
CharacterMicroButton:SetPoint("CENTER", BagPackFrame, -93.5, -11.8);

-- Параметры сумок

MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint("CENTER", BagPackFrame, 124.8, 21.8)

CharacterBag0Slot:ClearAllPoints()
CharacterBag0Slot:SetPoint("CENTER", MainMenuBarBackpackButton, -39, -5.1);
CharacterBag0Slot:SetScale(0.98)

CharacterBag1Slot:ClearAllPoints()
CharacterBag1Slot:SetPoint("CENTER", MainMenuBarBackpackButton, -72.3, -5.1);
CharacterBag1Slot:SetScale(0.98)

CharacterBag2Slot:ClearAllPoints()
CharacterBag2Slot:SetPoint("CENTER", MainMenuBarBackpackButton, -105, -5.1);
CharacterBag2Slot:SetScale(0.98)

CharacterBag3Slot:ClearAllPoints()
CharacterBag3Slot:SetPoint("CENTER", MainMenuBarBackpackButton, -137.9, -5.1);
CharacterBag3Slot:SetScale(0.98)

KeyRingButton:ClearAllPoints()
KeyRingButton:SetPoint("CENTER", MainMenuBarBackpackButton, -177, -5.9);
KeyRingButton:SetScale(0.91)

-- Анимация для микроменю и сумок

local frame = CreateFrame("Frame")

local SLIDETIME = 0.25 -- время работы анимации в секундах
local GONE_YPOS = -90 -- смещаем фрейм, на этой дистанции фрейм полностью уходит за экран

local function GetAnimPos(self, fraction)
    return "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", BagPackFrame_XPOS, (sin (fraction * 90 + 90) --[[- 1]]) * GONE_YPOS + BagPackFrame_YPOS
end

local AnimDataTable = {
    totalTime = SLIDETIME,
    updateFunc = "SetPoint", -- может принимать "SetPoint", "SetAlpha" и т.д.
    getPosFunc = GetAnimPos,
}

local enabled = false

local function BagPackFrame_Animation_OnEvent(self, event, unit, ...)

    if ( ( event == "UNIT_ENTERING_VEHICLE" ) and ( unit == "player" ) ) then

        if ( MainMenuBar.state == "vehicle" ) then -- проверка на реальный транспорт, а не маунт игроков

            SetUpAnimation(BagPackFrame, AnimDataTable, nil, true) -- вместо nil можно вызвать любую функцию после завершения анимации
        end

    elseif ( ( event == "UNIT_EXITING_VEHICLE" ) and ( unit == "player" ) ) then

        if ( MainMenuBar.state ~= "player" ) then

            self:OnUpdate()
        end

    elseif ( event == "PLAYER_ENTERING_WORLD" ) then
        if enabled then -- стартуем анимацию только на второй по счёту ивент
            SetUpAnimation(BagPackFrame, AnimDataTable, nil, false)
        end
        enabled = true
    end
end
frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
frame:RegisterEvent("UNIT_EXITING_VEHICLE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", BagPackFrame_Animation_OnEvent)

-- Добавляем задержку 0.3сек для красивой анимации
function frame.OnUpdate(Frame)

    local Update = 0.3

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update = Update - elapsed

        if Update <= 0 then
            SetUpAnimation(BagPackFrame, AnimDataTable, nil, false) -- frame, animTable, postFunc, reverse
            self:SetScript("OnUpdate", nil)
        end
    end)
end
end
