function RunHideMicroMenuAndBags()
-- Отключение отображения микро меню и сумок
local Core = CreateFrame("Frame");

Core:RegisterEvent("PLAYER_ENTERING_WORLD");

Core:SetScript("OnEvent", function(self, event, ...)

    return self[event](self, ...)
end);

local _G, select = _G, select;
local ArtFramePack = {};

function Core:OnLeave(Frame, Framelist)

    local Update = 1;

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update = Update - elapsed;

        BagPackTexture:SetAlpha(Update * 1.6);

        for i = 1, #Framelist do
            Framelist[i]:SetAlpha(Update * 1.6);
        end

        if Update <= 0 then
            self:SetScript("OnUpdate", nil);
        end
    end)
end

function Core:OnEnter(Frame, Framelist)

    Frame:SetScript("OnUpdate", nil);

    BagPackTexture:SetAlpha(1);

    for i = 1, #Framelist do
        Framelist[i]:SetAlpha(1);
    end
end

function Core:PLAYER_ENTERING_WORLD()

    self:SetScript("OnUpdate", nil);
    MainMenuBarArtFrame:SetScript("OnUpdate", nil);

    BagPackTexture:SetAlpha(0);

    for i = 1, #ArtFramePack do
        ArtFramePack[i]:SetAlpha(0);
    end
end

local BLFrame = {
    ["ActionBarUpButton"] = true,
    ["ActionBarDownButton"] = true,

    OnVehicle = { -- когда true включает видимость микроменю
        ["CharacterMicroButton"] = false,
        ["SpellbookMicroButton"] = false,
        ["TalentMicroButton"] = false,
        ["AchievementMicroButton"] = false,
        ["QuestLogMicroButton"] = false,
        ["SocialsMicroButton"] = false,
        ["PVPMicroButton"] = false,
        ["LFDMicroButton"] = false,
        ["MainMenuMicroButton"] = false,
        ["HelpMicroButton"] = false,
    },
}

for i = 1, select("#", MainMenuBarArtFrame:GetChildren()) do
    local frame = select(i, MainMenuBarArtFrame:GetChildren());

    if not frame:GetName():find("ActionButton") and not BLFrame[frame:GetName()] --[[and not BLFrame.OnVehicle[frame:GetName()]] then
        ArtFramePack[#ArtFramePack + 1] = frame;
    end
end

for i = 1, select("#", MainMenuBarArtFrame:GetRegions()) do

    if i == 3 or i == 4 or i == 7 then
        local frame = select(i, MainMenuBarArtFrame:GetRegions());
        ArtFramePack[#ArtFramePack + 1] = frame;
    end
end

local UDFrame = {
    ["ActionBarUpButton"] = true,
    ["ActionBarDownButton"] = true,

    OnVehicle = { -- когда true микроменю не реагирует на маусовер
        ["CharacterMicroButton"] = false,
        ["SpellbookMicroButton"] = false,
        ["TalentMicroButton"] = false,
        ["AchievementMicroButton"] = false,
        ["QuestLogMicroButton"] = false,
        ["SocialsMicroButton"] = false,
        ["PVPMicroButton"] = false,
        ["LFDMicroButton"] = false,
        ["MainMenuMicroButton"] = false,
        ["HelpMicroButton"] = false,
    },
}

for i = 1, select("#", MainMenuBarArtFrame:GetChildren()) do
    local frame = select(i, MainMenuBarArtFrame:GetChildren());

    if not frame:GetName():find("ActionButton") and not UDFrame[frame:GetName()] --[[and not UDFrame.OnVehicle[frame:GetName()]] then

        frame:HookScript("OnEnter", function(self)
            Core:OnEnter(MainMenuBarArtFrame, ArtFramePack);
        end)

        frame:HookScript("OnLeave", function(self)
            Core:OnLeave(MainMenuBarArtFrame, ArtFramePack);
        end)
    end
end

local MicroButtons = {CharacterMicroButton, SpellbookMicroButton, TalentMicroButton,
                      AchievementMicroButton, QuestLogMicroButton, SocialsMicroButton,
                      PVPMicroButton, LFDMicroButton, MainMenuMicroButton, HelpMicroButton}

local frame = CreateFrame("Frame")

frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
frame:RegisterEvent("UNIT_EXITED_VEHICLE")

local function OnEventHandler(self, event, unit, ...)

    if ( event == "UNIT_ENTERED_VEHICLE" and unit == "player" ) then

        if ( MainMenuBar.state == "vehicle" ) then

            for info, value in pairs(MicroButtons) do
                value:SetAlpha(1)
            end
        end

        --[[for key, value in pairs(UDFrame.OnVehicle) do
            UDFrame.OnVehicle[key] = true
        end

        BagPackTexture:SetAlpha(0);

        Core:OnEnter(MainMenuBarArtFrame, ArtFramePack)]]
    end

    if ( event == "UNIT_EXITED_VEHICLE" and unit == "player" ) then

        if ( MainMenuBar.state ~= "player" ) then

            frame:OnUpdate()
        end

        --[[for key, value in pairs(UDFrame.OnVehicle) do
            UDFrame.OnVehicle[key] = false
        end

        Core:OnLeave(MainMenuBarArtFrame, ArtFramePack)]]
    end
end
frame:SetScript("OnEvent", OnEventHandler)

-- Добавляем 0.2сек для красивой анимации
function frame.OnUpdate(Frame)

    local Update = 0.2

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update = Update - elapsed

        if Update <= 0 then
            for info, value in pairs(MicroButtons) do
                value:SetAlpha(0)
            end
            self:SetScript("OnUpdate", nil)
        end
    end)
end
end
