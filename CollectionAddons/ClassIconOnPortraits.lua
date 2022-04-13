function RunClassIconOnPortraits()
-- Классовая иконка вместо портретов игроков
hooksecurefunc("UnitFramePortrait_Update", function(self)
    if self.portrait then
        if UnitIsPlayer(self.unit) then
            local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
            if t then
                self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                --self.portrait:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
                self.portrait:SetTexCoord(unpack(t))
            end
        else
            self.portrait:SetTexCoord(0, 1, 0, 1)
        end
    end
end)
end
