function RunHideRightPanels()
-- Отключение отображения панелей заклинаний справа
local Core = CreateFrame("Frame");
Core:RegisterEvent("PLAYER_ENTERING_WORLD");
Core:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end);
local _G = _G;
function Core:OnLeave()
    local Update = 1;
    self:SetScript("OnUpdate", function(self, elapsed)
        Update = Update - elapsed;
        MultiBarLeft:SetAlpha(Update * 1.6);
        MultiBarRight:SetAlpha(Update * 1.6);
        if Update <= 0 then
            self:SetScript("OnUpdate", nil);
        end
    end);
end
function Core:OnEnter()
    self:SetScript("OnUpdate", nil);
    MultiBarRight:SetAlpha(1);
    MultiBarLeft:SetAlpha(1);
end
function Core:PLAYER_ENTERING_WORLD()
    self:SetScript("OnUpdate", nil);
    MultiBarLeft:SetAlpha(0);
    MultiBarRight:SetAlpha(0);
end
local function MBarAlpha(frameName)
    local frame = _G[frameName];
    frame:SetAlpha(0);
    frame:EnableMouse(true);
    frame:SetScript("OnEnter", function(self)
        Core:OnEnter();
    end);
    frame:SetScript("OnLeave", function(self)
        Core:OnLeave();
    end);
    frame:SetFrameLevel(0);
    for i = 1, 12 do
        _G[frameName .. "Button" .. i]:HookScript("OnEnter", function(self)
            Core:OnEnter();
        end);
        _G[frameName .. "Button" .. i]:HookScript("OnLeave", function(self)
            Core:OnLeave();
        end);
    end
end
MBarAlpha("MultiBarRight");
MBarAlpha("MultiBarLeft");
end
