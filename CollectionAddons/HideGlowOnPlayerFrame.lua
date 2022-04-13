function RunHideGlowOnPlayerFrame()
-- Отключение красного/желтого свечения на фрейме игрока во время боя/отдыха
hooksecurefunc("PlayerFrame_UpdateStatus", function()
    if IsResting("player") then
        PlayerStatusTexture:Hide()
        PlayerRestIcon:Hide()
        PlayerRestGlow:Hide()
        PlayerStatusGlow:Hide()
    elseif PlayerFrame.inCombat then
        PlayerStatusTexture:Hide()
        PlayerAttackIcon:Hide()
        PlayerRestIcon:Hide()
        PlayerAttackGlow:Hide()
        PlayerRestGlow:Hide()
        PlayerStatusGlow:Hide()
        PlayerAttackBackground:Hide()
    end
end)
end
