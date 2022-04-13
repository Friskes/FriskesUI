function RunDispelBorder()
-- Диспел бордер
local function isStealable(index, unit)
    return select(5, UnitAura(unit, index, "HELPFUL")) == "Magic"
end
hooksecurefunc("TargetFrame_UpdateAuras", function(self)
    if not UnitCanAttack("player", self.unit) then
        return
    end
    local selfName = self:GetName();
    local playerIsTarget = UnitIsUnit(PlayerFrame.unit, self.unit);
    for i = 1, MAX_TARGET_BUFFS do
        local frameName = selfName .. "Buff" .. i
        local frameStealable = _G[frameName .. "Stealable"];
        if frameStealable then
            if (not playerIsTarget and isStealable(i, self.unit)) then
                frameStealable:Show();
                if FuiDB.defaults.scalingauras == true then
                    frameStealable:SetSize(29, 29)
                end
            else
                frameStealable:Hide();
            end
        end
    end
end)
end
