function RunElitePlayerFrame()
-- Золотой портрет игрока с драконом
local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
frame:RegisterEvent("UNIT_EXITED_VEHICLE")

local frame2 = _G["PlayerFrame"]
local texture = frame2:CreateTexture(nil, "BORDER")

--texture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
texture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
texture:SetAllPoints(frame2)
texture:SetTexCoord(1, .09375, 0, .78125)

local function OnEventHandler(self, event, unit, ...)

    if ( event == "UNIT_ENTERED_VEHICLE" and unit == "player" ) then -- ивент с окончанием на ING срабатывает ощутимо быстрее

        if ( MainMenuBar.state == "vehicle" ) then

            texture:Hide()
        end

    elseif ( event == "UNIT_EXITED_VEHICLE" and unit == "player" ) then

        if ( MainMenuBar.state ~= "player" ) then

            texture:Show()
        end
    end
end
frame:SetScript("OnEvent", OnEventHandler)

texture:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
PlayerFrameTexture:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
PlayerFrameVehicleTexture:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
PlayerFrameAlternateManaBarBorder:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
PetFrameTexture:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)

for i = 1, 4 do
    _G["CustomTotemBorder" .. i .. "Texture"]:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
end

for i = 1, 6 do
    _G["RuneButtonIndividual" .. i .. "BorderTexture"]:SetVertexColor(FuiColor.PFT.R, FuiColor.PFT.G, FuiColor.PFT.B, FuiColor.PFT.A)
end

frame:UnregisterEvent("PLAYER_LOGIN")
end
