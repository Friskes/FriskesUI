-- ALWAYS ON --->

-- Масштаб миникарты колесом мыши

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

-- Имя игрока в тултипе при указании по миникарте

local select = select
local UnitName, UnitClass = UnitName, UnitClass

local MinimapPingTooltip = CreateFrame("GameTooltip", '$parentName', MinimapPing, 'GameTooltipTemplate')
MinimapPing:HookScript('OnEvent', function(self, event, unit)
  if event ~= "MINIMAP_PING" or not unit then
    return end
    local class = select(2, UnitClass(unit))
    local color = RAID_CLASS_COLORS[class]
    MinimapPingTooltip:SetOwner(MinimapPing, 'ANCHOR_BOTTOM', 0, 15)
    MinimapPingTooltip:SetText(UnitName(unit), color.r, color.g, color.b)
    MinimapPingTooltip:Show()
end)

-- Окрас игроков по цвету класса и отображение хп в тултипах при наведении мыши (На большой карте)

local SETTINGS = {
    BLIP_TEXTURE = 'Interface\\Minimap\\PartyRaidBlips.blp',
    WorldMap = {
        UnitButtonSize = 28, -- default 16
        CurrentHP = {
            show = true,
            format = '|cffffffff%.0f%%%%|r',
        },
    },
    BattlefieldMinimap = {
        UnitButtonSize = 15,8676, -- default 12
        CurrentHP = {
            show = true,
            format = '|cffffffff%.0f%%%%|r',
        },
    },
    Minimap = {
        ShowPingName = true,
    }
}

local select = select
local UnitIsPlayer, UnitClass, UnitName, UnitExists = UnitIsPlayer, UnitClass, UnitName, UnitExists
local GetNumRaidMembers, GetNumPartyMembers, UnitInParty, CreateFrame = GetNumRaidMembers, GetNumPartyMembers, UnitInParty, CreateFrame
local addon = CreateFrame('Frame')

addon:SetScript('OnEvent', function(self, event, ...)
    if not self[event] then return end
    self[event](self, ...)
end)

addon.CacheUnitData = {
    [UnitName('player')] = {select(2, UnitClass('player')), 'player'}
}

local BLIP_TEX_COORDS = {
    ['WARRIOR'] = { 0, 0.125, 0, 0.25 },
    ['PALADIN'] = { 0.125, 0.25, 0, 0.25 },
    ['HUNTER'] = { 0.25, 0.375, 0, 0.25 },
    ['ROGUE'] = { 0.375, 0.5, 0, 0.25 },
    ['PRIEST'] = { 0.5, 0.625, 0, 0.25 },
    ['DEATHKNIGHT'] = { 0.625, 0.75, 0, 0.25 },
    ['SHAMAN'] = { 0.75, 0.875, 0, 0.25 },
    ['MAGE'] = { 0.875, 1, 0, 0.25 },
    ['WARLOCK'] = { 0, 0.125, 0.25, 0.5 },
    ['DRUID'] = { 0.25, 0.375, 0.25, 0.5 }
}

local BLIP_RAID_Y_OFFSET = 0.5

for _, v in pairs(RAID_CLASS_COLORS) do
    v.colorStr = ("ff%.2x%.2x%.2x"):format(v.r * 255, v.g * 255, v.b * 255)
end

do
    addon:RegisterEvent('CHAT_MSG_SYSTEM')
    addon:RegisterEvent('RAID_ROSTER_UPDATE')
    addon:RegisterEvent('PARTY_MEMBERS_CHANGED')
    addon:RegisterEvent('PLAYER_ENTERING_WORLD')

function addon:CHAT_MSG_SYSTEM(msg)
    if msg ~= ERR_RAID_YOU_LEFT and msg ~= ERR_LEFT_GROUP_YOU and msg ~= ERR_GROUP_DISBANDED then return end
    self.CacheUnitData = {
        [UnitName('player')] = {select(2, UnitClass('player')), 'player'}
    }
end

function addon:RAID_ROSTER_UPDATE()
    if GetNumRaidMembers() == 0 then return end
    for i=1, MAX_RAID_MEMBERS do
        local unit = 'raid'..i
        if UnitExists(unit) then
            local class = select(2, UnitClass(unit))
            self.CacheUnitData[UnitName(unit)] = {class, unit}
        end
    end
end

function addon:PARTY_MEMBERS_CHANGED()
    if GetNumRaidMembers() > 0 or GetNumPartyMembers() == 0 then return end
    for i=1, MAX_PARTY_MEMBERS do
        local unit = 'party'..i
        if UnitExists(unit) then
            local class = select(2, UnitClass(unit))
            self.CacheUnitData[UnitName(unit)] = {class, unit}
        end
    end
end

function addon:PLAYER_ENTERING_WORLD()
    self:PARTY_MEMBERS_CHANGED()
    self:RAID_ROSTER_UPDATE()
end
end

local function ColoringUnit(text, name)
local class = addon.CacheUnitData[name][1]
local coloredName = ('|c%s%s|r'):format(RAID_CLASS_COLORS[class].colorStr, name)
return text:gsub(name, coloredName)
end

local function AddCurrentHP(text, name, frame)
    if not SETTINGS[frame].CurrentHP.show then return text end
    local unit = addon.CacheUnitData[name][2]
    local HP = SETTINGS[frame].CurrentHP.format:format(UnitHealth(unit) / UnitHealthMax(unit) * 100)
    return text:gsub(name, '%1 '..HP)
end

local function OnLoad(frame)
local size = SETTINGS[frame].UnitButtonSize

for i=1,4 do
    local partyUnitButton = _G[frame..'Party'..i]
    partyUnitButton:SetSize(size, size)
    partyUnitButton.icon:SetTexture(SETTINGS.BLIP_TEXTURE)
end

for i=1,40 do
    local raidUnitButton = _G[frame..'Raid'..i]
    raidUnitButton:SetSize(size, size)
    raidUnitButton.icon:SetTexture(SETTINGS.BLIP_TEXTURE)
end
end

local function OnUpdate(self)
local unit = self.unit
if not UnitIsPlayer(unit) then return end
local class = select(2, UnitClass(unit))
local coord = BLIP_TEX_COORDS[class]
if GetNumRaidMembers() > 0 then
    if UnitInParty(unit) then
        self.icon:SetTexCoord(coord[1], coord[2], coord[3], coord[4])
    else
        self.icon:SetTexCoord(coord[1], coord[2], coord[3] + BLIP_RAID_Y_OFFSET, coord[4] + BLIP_RAID_Y_OFFSET)
    end
else
    self.icon:SetTexCoord(coord[1], coord[2], coord[3], coord[4])
end
end

local function OnEnter(self, frame)
local tooltip = frame == 'BattlefieldMinimap' and GameTooltip or WorldMapTooltip
local tooltipText = _G[tooltip:GetName()..'TextLeft1']:GetText()
for name in tooltipText:gmatch('%S+') do
    if addon.CacheUnitData[name] then
        tooltipText = AddCurrentHP(tooltipText, name, frame)
        tooltipText = ColoringUnit(tooltipText, name)
    end
end
tooltip:SetText(tooltipText)
tooltip:Show()
end

do
    OnLoad('WorldMap')
    hooksecurefunc('WorldMapUnit_Update', OnUpdate)
    hooksecurefunc('WorldMapUnit_OnEnter', function(self)
        OnEnter(self, 'WorldMap')
    end)
end

do
    addon:RegisterEvent('ADDON_LOADED')
    function addon:ADDON_LOADED(addon)
        if addon ~= 'Blizzard_BattlefieldMinimap' then return end
        OnLoad('BattlefieldMinimap')
        hooksecurefunc('BattlefieldMinimap_OnUpdate', OnUpdate)
        hooksecurefunc('BattlefieldMinimapUnit_OnEnter', function(self)
            OnEnter(self, 'BattlefieldMinimap')
        end)
    end
end

-- ALWAYS ON <---
