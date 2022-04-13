function RunArenaTrinkets()
-- Пвп тринкет рядом с арена фреймами
local PVP_TRINKET_ICON_SIZE = 26
local XOFFSET, YOFFSET = -0.5, -2

local PVP_TRINKET_FACTION = {
    ["Alliance"] = "Interface\\Icons\\inv_jewelry_trinketpvp_01",
    ["Horde"] = "Interface\\Icons\\inv_jewelry_trinketpvp_02",
}
local trinket_spells = {
    [GetSpellInfo(42292)] = 120,
    [GetSpellInfo(7744)] = 45,
    [GetSpellInfo(59752)] = 120,
}
local PLAYER_TRINKET_CD = {}

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function()
    wipe(PLAYER_TRINKET_CD)
end)
frame:RegisterEvent("PLAYER_LEAVING_WORLD")

local OnEvent = function(self, event, unit, spell)

    if ( unit == self.unit ) then
        local cooldown = trinket_spells[spell]

        if cooldown then
            local curTime = GetTime()
            PLAYER_TRINKET_CD[UnitGUID(self.unit)] = curTime + cooldown
            self.cooldown:Show()
            self.cooldown:SetCooldown(curTime, cooldown)
        end
    end
end

local OnShow = function(self)

    if ( UnitExists(self.unit) ) then
        local faction = UnitFactionGroup(self.unit)

        if faction then
            self.texture:SetTexture(PVP_TRINKET_FACTION[faction])
        end

        local curTime = GetTime()
        local expiration = PLAYER_TRINKET_CD[UnitGUID(self.unit)]

        if ( expiration and expiration > curTime ) then
            self.cooldown:Show()
            self.cooldown:SetCooldown(curTime, expiration)
        else
            self.cooldown:Hide()
        end
    end
end

local loaded
local function OnLoad()
    if loaded then
        return
    end
    loaded = true

    for i = 1, 3 do
        local parent = _G["ArenaEnemyFrame" .. i]

        local trinketFrame = CreateFrame("Frame", "$parentTrinketFrame", parent)
        trinketFrame:SetPoint("LEFT", parent, "RIGHT", XOFFSET, YOFFSET)
        trinketFrame:SetSize(PVP_TRINKET_ICON_SIZE, PVP_TRINKET_ICON_SIZE)

        local unit = "arena" .. i
        trinketFrame.unit = unit

        trinketFrame.texture = trinketFrame:CreateTexture("$parentTexture", "ARTWORK")
        trinketFrame.texture:SetTexture(PVP_TRINKET_FACTION.Alliance)
        trinketFrame.texture:SetAllPoints(trinketFrame)

        trinketFrame.cooldown = CreateFrame("Cooldown", "$parentCooldown", trinketFrame)
        trinketFrame.cooldown:SetFrameLevel(trinketFrame:GetFrameLevel() + 20)
        trinketFrame.cooldown:SetAllPoints(trinketFrame)
        trinketFrame.cooldown:SetDrawEdge(true)

        trinketFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        trinketFrame:SetScript("OnShow", OnShow)
        trinketFrame:SetScript("OnEvent", OnEvent)
    end
end

if ( not IsAddOnLoaded("Blizzard_ArenaUI") ) then
    LoadAddOn("Blizzard_ArenaUI")
end
OnLoad()
end
