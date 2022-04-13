function RunHideBindsAndMacros()
-- Удаляем бинды и названия макросов
hooksecurefunc("ActionButton_UpdateHotkeys", function(self)

    local macro, hotkey = _G[self:GetName() .. "Name"], _G[self:GetName() .. "HotKey"]

    --hotkey:SetPoint("BOTTOMRIGHT", self, 0, 0) -- Перемещаем бинды

    if macro and hotkey then
        macro:Hide()
        hotkey:Hide()
    end
end)
end
