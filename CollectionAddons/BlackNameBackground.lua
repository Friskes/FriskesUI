function RunBlackNameBackground()
-- Изменяет бэкграунд на фреймах таргета и фокуса
hooksecurefunc("TargetFrame_CheckFaction",
function(self)
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.01);
end)
end
