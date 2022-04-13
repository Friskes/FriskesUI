function RunClassColorsOnHealthBars()
-- Включение цвета классов на полосах здоровья
local UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS = UnitIsPlayer, UnitIsConnected, UnitClass,
    RAID_CLASS_COLORS
local _, class, c
local function colour(statusbar, unit)
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(c.r, c.g, c.b)
    end
end
hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
    colour(self, self.unit)
end)
end
