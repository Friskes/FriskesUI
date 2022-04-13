function RunChangeSelfName()
-- Изменение своего никнейма
local frame = CreateFrame("FRAME", "NameChangeScripts")
frame:RegisterEvent("PLAYER_LOGIN")
local function eventHandler(self, event, ...)

    NewName = FuiDB.NewName

    PFNC = CreateFrame("Frame", "PlayerFrameNameChange")
    local function ChangePlayerName(self)
        local PN = GetUnitName("player")
            PlayerFrame.name:SetText(NewName)
		end
    PFNC:SetScript("OnUpdate", ChangePlayerName)

    TFNC = CreateFrame("Frame", "TargetFrameNameChange")
    local function ChangeTargetName(self)
        local PN = GetUnitName("player")
        local TN = GetUnitName("target")
        if PN == TN then
            TargetFrame.name:SetText(NewName)
        end
    end
    TFNC:SetScript("OnUpdate", ChangeTargetName)

    TFTNC = CreateFrame("Frame", "TargetFrameTargetNameChange")
    local function ChangeTargetofTargetName(self)
        local PN = GetUnitName("player")
        local TTN = GetUnitName("targettarget")
        if PN == TTN then
            TargetFrameToT.name:SetText(NewName)
        end
    end
    TFTNC:SetScript("OnUpdate", ChangeTargetofTargetName)

    FFNC = CreateFrame("Frame", "FocusFrameNameChange")
    local function ChangeFocusName(self)
        local PN = GetUnitName("player")
        local FN = GetUnitName("focus")
        if PN == FN then
            FocusFrame.name:SetText(NewName)
        end
    end
    FFNC:SetScript("OnUpdate", ChangeFocusName)

    FFTNC = CreateFrame("Frame", "FocusFrameTargetNameChange")
    local function ChangeFocusTargetName(self)
        local PN = GetUnitName("player")
        local FTN = GetUnitName("focustarget")
        if PN == FTN then
            FocusFrameToT.name:SetText(NewName)
        end
    end
    FFTNC:SetScript("OnUpdate", ChangeFocusTargetName)
end
frame:SetScript("OnEvent", eventHandler)
end
