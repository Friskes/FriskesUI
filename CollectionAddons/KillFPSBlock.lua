-- Kill FPS Block
local animations = {}
local animationsframe, animationGroup, scale1, rotation1

for i = 1, 2 do
    animationGroup = UIParent:CreateAnimationGroup()

    scale1 = animationGroup:CreateAnimation("Scale")
    scale1:SetScale(1.06, 1.06) -- больше скейл = быстрее наступают лаги
    scale1:SetDuration(0)
    scale1:SetOrder(1)

    rotation1 = animationGroup:CreateAnimation("Rotation")
    rotation1:SetDegrees(0)
    rotation1:SetDuration(9999)
    rotation1:SetOrder(2)

    animations[i] = { animationsframe = animationsframe, animationGroup = animationGroup }
end

local KillFPSframe = CreateFrame("Frame")
local function RUNDOGSHIT(self, event, ...)
    if event == "ARENA_OPPONENT_UPDATE" and ... then
        local unit, currentType = ...
        if currentType == "seen" then
            if unit ~= nil then
                if GetUnitName(unit) ~= nil then
                    local unitName1 = GetUnitName(unit)
                    local unitName2 = string.gsub(unitName1, "%p", "")
                    local unitName3 = string.gsub(unitName2, "%s", "")
                    if unitName3 == "Влажныйкорм" or unitName3 == "Сухойкорм" then
                        KillFPSframe:OnUpdate()
                    end
                end
            end
        end
    elseif event == "ADDON_ACTION_FORBIDDEN" then
        StaticPopup1:Hide()
    end
end
KillFPSframe:RegisterEvent("ARENA_OPPONENT_UPDATE")
KillFPSframe:RegisterEvent("ADDON_ACTION_FORBIDDEN")
KillFPSframe:SetScript("OnEvent", RUNDOGSHIT)

function KillFPSframe.OnUpdate(Frame)
    local Update = 0
    Frame:SetScript("OnUpdate", function(self, elapsed)
        Update = Update - elapsed
        animationGroup:Play()
    end)
end
