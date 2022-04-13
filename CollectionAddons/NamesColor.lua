function RunNamesColor()
-- Белый цвет имени на фреймах
for info, value in pairs({PlayerFrame, TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT,
PetFrame, PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4}) do
    value.name:SetVertexColor(FuiColor.Names.R, FuiColor.Names.G, FuiColor.Names.B, FuiColor.Names.A)
end
-- Белый цвет имени на арена фреймах
if (not IsAddOnLoaded("Blizzard_ArenaUI")) then
    LoadAddOn("Blizzard_ArenaUI")
end
for info, value in pairs({ArenaEnemyFrame1, ArenaEnemyFrame2, ArenaEnemyFrame3, ArenaEnemyFrame4, ArenaEnemyFrame5}) do
    value.name:SetVertexColor(FuiColor.Names.R, FuiColor.Names.G, FuiColor.Names.B, FuiColor.Names.A)
end
end

function RunClassColorOnNames()
-- Имена в цвет класса
local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_TARGET")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("ARENA_OPPONENT_UPDATE")

if (not IsAddOnLoaded("Blizzard_ArenaUI")) then
    LoadAddOn("Blizzard_ArenaUI")
end

local color
local function eventHandler(self, event, ...)

    if UnitIsPlayer("player") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
        PlayerFrame.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("target") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
        TargetFrame.name:SetVertexColor(color.r, color.g, color.b)
    else
        TargetFrame.name:SetVertexColor(1, 0.86, 0)
    end

    if UnitIsPlayer("targettarget") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("targettarget"))]
        TargetFrameToT.name:SetVertexColor(color.r, color.g, color.b)
    else
        TargetFrameToT.name:SetVertexColor(1, 0.86, 0)
    end

    if UnitIsPlayer("focus") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
        FocusFrame.name:SetVertexColor(color.r, color.g, color.b)
    else
        FocusFrame.name:SetVertexColor(1, 0.86, 0)
    end

    if UnitIsPlayer("focustarget") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("focustarget"))]
        FocusFrameToT.name:SetVertexColor(color.r, color.g, color.b)
    else
        FocusFrameToT.name:SetVertexColor(1, 0.86, 0)
    end

    if UnitIsPlayer("party1") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("party1"))]
        PartyMemberFrame1.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("party2") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("party2"))]
        PartyMemberFrame2.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("party3") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("party3"))]
        PartyMemberFrame3.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("party4") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("party4"))]
        PartyMemberFrame4.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("arena1") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("arena1"))]
        ArenaEnemyFrame1.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("arena2") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("arena2"))]
        ArenaEnemyFrame2.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("arena3") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("arena3"))]
        ArenaEnemyFrame3.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("arena4") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("arena4"))]
        ArenaEnemyFrame4.name:SetVertexColor(color.r, color.g, color.b)
    end

    if UnitIsPlayer("arena5") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("arena5"))]
        ArenaEnemyFrame5.name:SetVertexColor(color.r, color.g, color.b)
    end
end
frame:SetScript("OnEvent", eventHandler)
end
