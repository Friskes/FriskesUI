function RunFixBlizzardButtonBorders()
-- Регулировка окантовки на панелях заклинаний
hooksecurefunc("ActionButton_Update", function(self)
    if self:GetName():match("ExtraActionButton") then
        return
    end
    local bu = _G[self:GetName()]
    local ic = _G[self:GetName() .. "Icon"]
    local bo = _G[self:GetName() .. "NormalTexture"]
    bu:SetNormalTexture("Interface\\BUTTONS\\UI-Quickslot2")
    ic:SetTexCoord(0, 1, 0, 1); -- turn abilities (1, 0, 0, 1)
    ic:SetPoint("TOPLEFT", bu, 0, 0);
    ic:SetPoint("BOTTOMRIGHT", bu, 0, 0);
    bo:ClearAllPoints()
    bo:SetPoint("TOPLEFT", bu, -15, 14) -- left up
    bo:SetPoint("BOTTOMRIGHT", bu, 15, -16) -- right down
    bo:SetGradientAlpha("VERTICAL", FuiColor.bR, FuiColor.bG, FuiColor.bB, FuiColor.bA,
                                    FuiColor.tR, FuiColor.tG, FuiColor.tB, FuiColor.tA)
end);
hooksecurefunc("ActionButton_UpdateUsable", function(self)
    if self:GetName():match("ExtraActionButton") then
        return
    end
    (_G[self:GetName() .. "NormalTexture"]):SetGradientAlpha("VERTICAL", FuiColor.bR, FuiColor.bG, FuiColor.bB, FuiColor.bA,
                                                                         FuiColor.tR, FuiColor.tG, FuiColor.tB, FuiColor.tA)
end);

-- Регулировка окантовки на панели питомца, панели стоек и т.д.

hooksecurefunc("ActionButton_ShowGrid", function(self)
    if self:GetName():match("ExtraActionButton") then
        return
    end
    (_G[self:GetName() .. "NormalTexture"]):SetGradientAlpha("VERTICAL", FuiColor.bR, FuiColor.bG, FuiColor.bB, FuiColor.bA,
                                                                         FuiColor.tR, FuiColor.tG, FuiColor.tB, FuiColor.tA)
end);
hooksecurefunc("PetActionBar_Update", function()
    for i, v in pairs({"PetActionButton", "ShapeshiftButton", "PossessButton"}) do
        for i = 1, 12 do
            local bu = _G[v .. i]
            if bu then
                bu:SetNormalTexture("Interface\\BUTTONS\\UI-Quickslot2")
                local ic = _G[v .. i .. "Icon"];
                ic:SetTexCoord(0, 1, 0, 1);
                ic:SetPoint("TOPLEFT", bu, 0, 0);
                ic:SetPoint("BOTTOMRIGHT", bu, 0, 0);
                local bo = _G[v .. i .. "NormalTexture2"] or _G[v .. i .. "NormalTexture"]
                bo:ClearAllPoints()
                bo:SetPoint("TOPLEFT", bu, -12, 11)
                bo:SetPoint("BOTTOMRIGHT", bu, 12, -13)
                bo:SetGradientAlpha("VERTICAL", FuiColor.bR, FuiColor.bG, FuiColor.bB, FuiColor.bA,
                                                FuiColor.tR, FuiColor.tG, FuiColor.tB, FuiColor.tA)
            end
        end
    end
end)
end

-- Регулировка параметров текстур

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)

    if ( addon == "Blizzard_TimeManager" ) then

        for _, value in pairs({
            select(1, TimeManagerClockButton:GetRegions() ),
        }) do
            value:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        end

        for _, value in pairs({
            select(2, TimeManagerClockButton:GetRegions() ),
        }) do
            value:SetVertexColor(1.0, 1.0, 1.0, 1.0) -- Цвет цифр времени на миникарте
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:SetScript("OnEvent", nil)
    end

    for _, value in pairs({
        BagPackTexture, BonusActionBarTexture0, BonusActionBarTexture1, BonusActionBarFrameTexture0,
        BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3, BonusActionBarFrameTexture4,
        MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, ReputationWatchBarTexture0,
        ReputationWatchBarTexture1, ReputationWatchBarTexture2, ReputationWatchBarTexture3, ReputationXPBarTexture0,
        ReputationXPBarTexture1, ReputationXPBarTexture2, ReputationXPBarTexture3, MainMenuXPBarTexture0, MainMenuXPBarTexture1,
        MainMenuXPBarTexture2, MainMenuXPBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
        MainMenuMaxLevelBar3, MainMenuBarLeftEndCap, MainMenuBarRightEndCap, ShapeshiftBarLeft, ShapeshiftBarMiddle,
        ShapeshiftBarRight, PossessBackground1, PossessBackground2, SlidingActionBarTexture0, SlidingActionBarTexture1,

        VehicleMenuBarArtFrameBACKGROUND1, VehicleMenuBarArtFrameBACKGROUND2, VehicleMenuBarArtFrameBACKGROUND3,
        VehicleMenuBarArtFrameBORDER1, VehicleMenuBarArtFrameBORDER2, VehicleMenuBarArtFrameBORDER3, VehicleMenuBarArtFrameBORDER4,
        VehicleMenuBarArtFrameBORDER5, VehicleMenuBarArtFrameBORDER6, VehicleMenuBarArtFrameBORDER7, VehicleMenuBarArtFrameARTWORK1,
        VehicleMenuBarArtFrameARTWORK2, VehicleMenuBarArtFrameARTWORK3, VehicleMenuBarArtFrameARTWORK4, VehicleMenuBarArtFrameARTWORK5,
        VehicleMenuBarArtFrameARTWORK6, VehicleMenuBarArtFrameARTWORK7, VehicleMenuBarArtFrameARTWORK8, VehicleMenuBarArtFrameARTWORK9,
        VehicleMenuBarArtFrameARTWORK10, VehicleMenuBarArtFrameOVERLAY1, VehicleMenuBarArtFrameOVERLAY2, VehicleMenuBarArtFrameOVERLAY3,
        VehicleMenuBarArtFrameOVERLAY4,

        MinimapBorder, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder, MiniMapMailBorder,
        MinimapBorderTop, MiniMapWorldBorder, MinimapZoomIn:Hide(), MinimapZoomOut:Hide(),
        select(6, GameTimeFrame:GetRegions() ),
        select(7, GameTimeFrame:GetRegions() ),

        TargetFrameTextureFrameTexture, FocusFrameTextureFrameTexture,
        PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
        PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture,
        PartyMemberFrame4PetFrameTexture, TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture,
        CastingBarFrameBorder, PetCastingBarFrameBorder, Boss1TargetFrameTextureFrameTexture,
        Boss2TargetFrameTextureFrameTexture, Boss3TargetFrameTextureFrameTexture, Boss4TargetFrameTextureFrameTexture,
        Boss5TargetFrameTextureFrameTexture, Boss1TargetFrameSpellBarBorder, Boss2TargetFrameSpellBarBorder,
        Boss3TargetFrameSpellBarBorder, Boss4TargetFrameSpellBarBorder, Boss5TargetFrameSpellBarBorder,
        TargetFrameSpellBarBorder, TargetFrameSpellBarBorderShield, FocusFrameSpellBarBorder, FocusFrameSpellBarBorderShield,
        select(1, ComboPoint1:GetRegions() ),
        select(1, ComboPoint2:GetRegions() ),
        select(1, ComboPoint3:GetRegions() ),
        select(1, ComboPoint4:GetRegions() ),
        select(1, ComboPoint5:GetRegions() ),
    }) do
        value:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
    end

    if FuiDB.defaults.eliteplayerframe == false then

        PlayerFrameTexture:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        PlayerFrameVehicleTexture:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        PlayerFrameAlternateManaBarBorder:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        PetFrameTexture:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)

        for i = 1, 4 do
            _G["CustomTotemBorder" .. i .. "Texture"]:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        end

        for i = 1, 6 do
            _G["RuneButtonIndividual" .. i .. "BorderTexture"]:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        end
    end
end)

-- Создаём кастомные текстуры для тотемов для дальнейшей покраски

local CustomTotemBorder1 = CreateFrame("Frame", "CustomTotemBorder1", TotemFrameTotem1)
CustomTotemBorder1Texture = CustomTotemBorder1:CreateTexture(nil, "OVERLAY")
CustomTotemBorder1Texture:SetPoint("CENTER", TotemFrameTotem1)

local CustomTotemBorder2 = CreateFrame("Frame", "CustomTotemBorder2", TotemFrameTotem2)
CustomTotemBorder2Texture = CustomTotemBorder2:CreateTexture(nil, "OVERLAY")
CustomTotemBorder2Texture:SetPoint("CENTER", TotemFrameTotem2)

local CustomTotemBorder3 = CreateFrame("Frame", "CustomTotemBorder3", TotemFrameTotem3)
CustomTotemBorder3Texture = CustomTotemBorder3:CreateTexture(nil, "OVERLAY")
CustomTotemBorder3Texture:SetPoint("CENTER", TotemFrameTotem3)

local CustomTotemBorder4 = CreateFrame("Frame", "CustomTotemBorder4", TotemFrameTotem4)
CustomTotemBorder4Texture = CustomTotemBorder4:CreateTexture(nil, "OVERLAY")
CustomTotemBorder4Texture:SetPoint("CENTER", TotemFrameTotem4)

for i = 1, 4 do
    _G["CustomTotemBorder" .. i]:SetFrameLevel(11)
    _G["CustomTotemBorder" .. i .. "Texture"]:SetTexture("Interface\\CharacterFrame\\TotemBorder")
    _G["CustomTotemBorder" .. i .. "Texture"]:SetSize(38, 38)
end

local frame2 = CreateFrame("Frame")
frame2:RegisterEvent("ADDON_LOADED")
frame2:SetScript("OnEvent", function(self, event, addon)

    if (addon == "Blizzard_ArenaUI") then

        for i = 1, 5 do
            _G["ArenaEnemyFrame" ..i.. "Texture"]:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
            _G["ArenaEnemyFrame" ..i.. "PetFrameTexture"]:SetVertexColor(FuiColor.R, FuiColor.G, FuiColor.B, FuiColor.A)
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:SetScript("OnEvent", nil)
    end
end)

-- Цвет текста на кнопке календаря

hooksecurefunc("GameTimeFrame_SetDate", function()
    local _, _, day = CalendarGetDate();
    local text = string.format(FuiColor.GTF, day)
    GameTimeFrame:SetText(text)
end)
