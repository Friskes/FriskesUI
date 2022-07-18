function RunClassIconOnPortraits()
-- Классовая иконка вместо портретов игроков
hooksecurefunc("UnitFramePortrait_Update", function(self)
    if self.portrait then
        if UnitIsPlayer(self.unit) then
            local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
            if t then
                self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                -- self.portrait:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
                self.portrait:SetTexCoord(unpack(t))

                if self.unit == 'targettarget' then
                    self.portrait:ClearAllPoints()
                    self.portrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 3.5, -0.5)
                    self.portrait:SetSize(TargetFrameToT:GetHeight() - 6.3, TargetFrameToT:GetHeight() - 6.3)
                end
                if self.unit == 'focus-target' then
                    self.portrait:ClearAllPoints()
                    self.portrait:SetPoint("LEFT", FocusFrameToT, "LEFT", 3.5, -0.5)
                    self.portrait:SetSize(FocusFrameToT:GetHeight() - 6.3, FocusFrameToT:GetHeight() - 6.3)
                end
            end
        else
            self.portrait:SetTexCoord(0, 1, 0, 1)
        end
    end
end)
end
