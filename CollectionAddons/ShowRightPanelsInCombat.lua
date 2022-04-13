function RunShowRightPanelsInCombat()
-- Включение отображения панелей заклинаний справа в бою
do
    local r, l, c = MultiBarRight, MultiBarLeft
    r:RegisterEvent("PLAYER_ENTERING_WORLD")
    r:RegisterEvent("PLAYER_REGEN_ENABLED")
    r:RegisterEvent("PLAYER_REGEN_DISABLED")
    r:SetScript("OnEvent", function(r, e)
        if (e == "PLAYER_ENTERING_WORLD" and not UnitAffectingCombat("player")) or e == "PLAYER_REGEN_ENABLED" then
            e, c = 0, false
        else
            e, c = 1, true
        end
        r:SetAlpha(e)
        l:SetAlpha(e)
    end)
    for _, v in ipairs {"Left", "Right"} do
        local f = _G["MultiBar" .. v]
        f:SetAlpha(0)
        for i = 1, 12 do
            local b = _G["MultiBar" .. v .. "Button" .. i]
            b:HookScript("OnEnter", function()
                r:SetScript("OnUpdate", nil)
                r:SetAlpha(1)
                l:SetAlpha(1)
            end)
            b:HookScript("OnLeave", function()
                if not c then
                    local d = 1
                    r:SetScript("OnUpdate", function(s, e)
                        d = d - e
                        r:SetAlpha(d * 1.6)
                        l:SetAlpha(d * 1.6)
                        if d < 0 then
                            s:SetScript("OnUpdate", nil)
                        end
                    end)
                end
            end)
        end
    end
end
end
