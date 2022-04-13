local L = LibStub('AceLocale-3.0'):GetLocale('FriskesUI')

function RunMoveFrames()

function StartMoveFrames()
    print(L.StartMoveFramesInfo)

    PlayerFrame:SetMovable(true)
    --PlayerFrame:SetClampedToScreen(true) -- багует анимация вехикла
    PlayerFrame:SetScript("OnMouseDown", function(self, button)
        PlayerFrame:StartMoving()
    end)
    PlayerFrame:SetScript("OnMouseUp", function(self, button)
        PlayerFrame:StopMovingOrSizing()
        FuiDB.position.PFx = PlayerFrame:GetLeft()
        FuiDB.position.PFy = PlayerFrame:GetBottom()
    end)

    TargetFrame:SetMovable(true)
    TargetFrame:SetClampedToScreen(true)
    TargetFrame:SetScript("OnMouseDown", function(self, button)
        TargetFrame:StartMoving()
    end)
    TargetFrame:SetScript("OnMouseUp", function(self, button)
        TargetFrame:StopMovingOrSizing()
        FuiDB.position.TFx = TargetFrame:GetLeft()
        FuiDB.position.TFy = TargetFrame:GetBottom()
    end)

    FocusFrame:SetMovable(true)
    FocusFrame:SetScript("OnMouseDown", function(self, button)
        FocusFrame:StartMoving()
    end)
    FocusFrame:SetScript("OnMouseUp", function(self, button)
        FocusFrame:StopMovingOrSizing()
        FuiDB.position.FFx = FocusFrame:GetLeft()
        FuiDB.position.FFy = FocusFrame:GetBottom()
    end)

    for i = 1, 4 do
        _G["PartyMemberFrame" ..i]:SetMovable(true)
        _G["PartyMemberFrame" ..i]:SetClampedToScreen(true)
    end

    PartyMemberFrame1:SetScript("OnMouseDown", function(self, button)
        PartyMemberFrame1:StartMoving()
    end)
    PartyMemberFrame1:SetScript("OnMouseUp", function(self, button)
        PartyMemberFrame1:StopMovingOrSizing()
        FuiDB.position.PMF1x = PartyMemberFrame1:GetLeft()
        FuiDB.position.PMF1y = PartyMemberFrame1:GetBottom()
    end)

    PartyMemberFrame2:SetScript("OnMouseDown", function(self, button)
        PartyMemberFrame2:StartMoving()
    end)
    PartyMemberFrame2:SetScript("OnMouseUp", function(self, button)
        PartyMemberFrame2:StopMovingOrSizing()
        FuiDB.position.PMF2x = PartyMemberFrame2:GetLeft()
        FuiDB.position.PMF2y = PartyMemberFrame2:GetBottom()
    end)

    PartyMemberFrame3:SetScript("OnMouseDown", function(self, button)
        PartyMemberFrame3:StartMoving()
    end)
    PartyMemberFrame3:SetScript("OnMouseUp", function(self, button)
        PartyMemberFrame3:StopMovingOrSizing()
        FuiDB.position.PMF3x = PartyMemberFrame3:GetLeft()
        FuiDB.position.PMF3y = PartyMemberFrame3:GetBottom()
    end)

    PartyMemberFrame4:SetScript("OnMouseDown", function(self, button)
        PartyMemberFrame4:StartMoving()
    end)
    PartyMemberFrame4:SetScript("OnMouseUp", function(self, button)
        PartyMemberFrame4:StopMovingOrSizing()
        FuiDB.position.PMF4x = PartyMemberFrame4:GetLeft()
        FuiDB.position.PMF4y = PartyMemberFrame4:GetBottom()
    end)
end

function StopMoveFrames()
    print(L.StopMoveFramesInfo)

    PlayerFrame:EnableMouse(false)
	PlayerFrame:SetMovable(false)

	TargetFrame:EnableMouse(false)
	TargetFrame:SetMovable(false)

    FocusFrame:EnableMouse(false)
	FocusFrame:SetMovable(false)

    for i = 1, 4 do
        _G["PartyMemberFrame" ..i]:EnableMouse(false)
        _G["PartyMemberFrame" ..i]:SetMovable(false)
    end
end

function SetMoveFrames()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.PFx, FuiDB.position.PFy)
    PlayerFrame:SetScale(1.1)
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("CENTER", UIParent, 0, -90)
    CastingBarFrame:SetScale(1.05)
    CastingBarFrame.SetPoint = function() end

    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.TFx, FuiDB.position.TFy)
    TargetFrame:SetScale(1.1)
    TargetFrameSpellBar:SetScale(1.1)

    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.FFx, FuiDB.position.FFy)
    FocusFrame:SetScale(1.1)
    FocusFrameSpellBar:SetScale(1.1)

    PartyMemberFrame1:ClearAllPoints()
    PartyMemberFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.PMF1x, FuiDB.position.PMF1y)
    PartyMemberFrame1:SetScale(1.55)

    PartyMemberFrame2:ClearAllPoints()
    PartyMemberFrame2:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.PMF2x, FuiDB.position.PMF2y)
    PartyMemberFrame2:SetScale(1.55)

    PartyMemberFrame3:ClearAllPoints()
    PartyMemberFrame3:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.PMF3x, FuiDB.position.PMF3y)
    PartyMemberFrame3:SetScale(1.55)

    PartyMemberFrame4:ClearAllPoints()
    PartyMemberFrame4:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", FuiDB.position.PMF4x, FuiDB.position.PMF4y)
    PartyMemberFrame4:SetScale(1.55)
end
end

-- Перемещаем тултип
function RunMoveTooltip()
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(GameTooltip)
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, -1, 12)
end)
end

-- ALWAYS ON --->

-- Фиксим кривую позицию близзов

BonusActionButton1:ClearAllPoints()
BonusActionButton1:SetPoint("BOTTOMLEFT", BonusActionBarFrame, "BOTTOMLEFT", 4, 4)

MultiBarLeftButton1:ClearAllPoints()
MultiBarLeftButton1:SetPoint("CENTER", MultiBarRightButton1, -42, 0)
MultiBarRightButton1:ClearAllPoints()
MultiBarRightButton1:SetPoint("RIGHT", -2.2, 230)

ActionBarUpButton:SetPoint("CENTER", MainMenuBarArtFrame, "BOTTOMLEFT", 521, 30.2)
ActionBarDownButton:SetPoint("CENTER", MainMenuBarArtFrame, "BOTTOMLEFT", 521, 11.1)
MainMenuBarPageNumber:SetPoint("CENTER", MainMenuBarArtFrame, "BOTTOMLEFT", 541, 21)

-- Перемещаем инфу о количестве игроков на арене

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, -56.5, -2.5)
WorldStateAlwaysUpFrame.ClearAllPoints = function() end
WorldStateAlwaysUpFrame.SetPoint = function() end

-- ALWAYS ON <---
