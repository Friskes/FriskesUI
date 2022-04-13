function RunClassColorsOnNameBackground()
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")

local color
local function eventHandler(self, event, ...)
    if UnitIsPlayer("player") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
        PlayerFrameBackground:SetSize(119, 18.9)
        PlayerFrameBackground:SetVertexColor(color.r, color.g, color.b)
    end
    if UnitIsPlayer("target") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
        TargetFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
    end
    if UnitIsPlayer("focus") then
        color = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
        FocusFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
    end
end
frame:SetScript("OnEvent", eventHandler)

for _, BarTextures in pairs({PlayerFrameBackground, TargetFrameNameBackground, FocusFrameNameBackground}) do
    BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
end
end
