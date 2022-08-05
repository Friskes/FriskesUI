local L = LibStub('AceLocale-3.0'):GetLocale('FriskesUI')

function RunInviteTimer()
-- Таймер приглашения на арену, поле боя

local enableModule_inviteTimer = true -- вкл/выкл модуль статусбар до блокировки входа на арену
local enableModule_timeInQueue = true -- вкл/выкл модуль время ожидания в очереди
local enableSound = true -- вкл/выкл звук

local frame = CreateFrame("Frame", nil, StaticPopup1)

local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetPoint("TOP", StaticPopup1, "BOTTOM", 0, 2)
text:SetTextHeight(11)

local text2 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text2:SetPoint("TOP", StaticPopup1, "TOP", 0, 20.5)
text2:SetTextHeight(21)
text2:SetShadowOffset(1.5, -1.5)

--[[local ReverseBar -- Инвертируем статусбар, теперь происходит не заполнение а опустошение.
do
    local UpdaterOnUpdate = function(Updater)
        Updater:Hide()
        local b = Updater:GetParent()
        local texture = b:GetStatusBarTexture()
        texture:ClearAllPoints()
        texture:SetPoint("BOTTOMRIGHT")
        texture:SetPoint("TOPLEFT", b, "TOPRIGHT", (b:GetValue() / select(2, b:GetMinMaxValues() ) - 1) * b:GetWidth(), 0)
    end

    local OnChanged = function(bar)
        bar.Updater:Show()
    end

    function ReverseBar(Frame)
        local bar = CreateFrame("StatusBar", nil, Frame)
        bar.Updater = CreateFrame("Frame", nil, bar)
        bar.Updater:Hide()
        bar.Updater:SetScript("OnUpdate", UpdaterOnUpdate)
        bar:SetScript("OnSizeChanged", OnChanged)
        bar:SetScript("OnValueChanged", OnChanged)
        bar:SetScript("OnMinMaxChanged", OnChanged)
        return bar
    end
end]]

--local frame2 = ReverseBar(frame) -- замена для CreateFrame("StatusBar")
local frame2 = CreateFrame("StatusBar", nil, frame)
frame2:SetFrameStrata("HIGH")
frame2:SetWidth(400)
frame2:SetHeight(12)
frame2:SetPoint("TOP", StaticPopup1, "BOTTOM", 0, 2)
frame2:SetOrientation("HORIZONTAL")
frame2:SetStatusBarTexture("Interface\\Addons\\FriskesUI\\Media\\Textures\\RetailTimer\\Raid-Bar-Hp-Fill")
frame2:SetStatusBarColor(1, 0, 0, 1)
frame2:Hide()

local background = frame2:CreateTexture(nil, "BACKGROUND")
background:SetPoint("TOPRIGHT", frame2, "TOPRIGHT", 0, 0)
background:SetPoint("BOTTOMLEFT", frame2, "BOTTOMLEFT", 0, 0)
background:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
background:SetVertexColor(0, 0, 0, 0.5)

local Backdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 9, edgeSize = 9,
	insets = { left = 2, right = 2, top = 3, bottom = 2 }
}

local border = CreateFrame("Frame", nil, frame2)
border:SetPoint("TOPRIGHT", frame2, "TOPRIGHT", 2, 2) -- право, верх
border:SetPoint("BOTTOMLEFT", frame2, "BOTTOMLEFT", -2, -1.5) -- лево, низ
border:SetBackdrop(Backdrop)
border:SetBackdropColor(0, 0, 0, 0.0) -- сделал отельный бэкграунд т.к. не смог вставить статус бар между слоями бэкдропа =|
border:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

local BattlefieldTime
local enabled

local function InviteTimer_OnEvent(self, event, ...)

    if event == "UPDATE_BATTLEFIELD_STATUS" then
        for index = 1, MAX_BATTLEFIELD_QUEUES do

            local status, name, teamSize = GetBattlefieldStatus(index)

            if status == "confirm" then
                if enableSound then
                    PlaySoundFile("Interface\\AddOns\\FriskesUI\\Media\\Sounds\\SndIncMsg.ogg", "Master")
                end
                BattlefieldTime = GetBattlefieldPortExpiration(1)
                if enabled then
                    enabled = false
                    frame2:SetMinMaxValues(0, GetBattlefieldPortExpiration(1) )
                end
                text2:SetText(string.format(name, GetBattlefieldStatus(index) ) )
                frame:Show()
                frame2:Show()
                frame2:OnUpdate()
            end
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        enabled = true
        frame:Hide()
    end
end
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
if enableModule_inviteTimer then
    frame:SetScript("OnEvent", InviteTimer_OnEvent)
end

local frame3 = CreateFrame("Frame")

function frame2.OnUpdate(Frame)
    Frame:SetScript("OnUpdate", function(self, elapsed)

        text:SetText(string.format("0:%.f", GetBattlefieldPortExpiration(1) ) )

        BattlefieldTime = BattlefieldTime - elapsed

        self:SetValue(BattlefieldTime)

        if GetBattlefieldPortExpiration(1) <= 0 then
            frame3:OnUpdate()
        end
    end)
end

-- Добавляем долбаную секунду..
function frame3.OnUpdate(Frame)

    local Update = 1

    Frame:SetScript("OnUpdate", function(self, elapsed)

        Update = Update - elapsed

        if Update <= 0 then
            frame:Hide()
            self:SetScript("OnUpdate", nil)
        end
    end)
end

StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].hideOnEscape = false -- отключаем скрытие окна при нажатии кнопки ESCape

--[[StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].OnShow = function(self) -- отключаем кликабельность кнопок
    --self.button1:Disable()
    self.button2:Disable()
    StaticPopup1CloseButton:Disable()
end]]

-- Время в очереди на сражение у кнопки на миникарте
local frame4 = CreateFrame("Frame", nil, MiniMapBattlefieldFrame)
local text3 = frame4:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text3:SetPoint("CENTER", MiniMapBattlefieldFrame, "LEFT", -12, 1)
text3:SetTextHeight(13)

local function TimeInQueue()
    for index = 1, MAX_BATTLEFIELD_QUEUES do
        local status = GetBattlefieldStatus(index)
        if status ~= "none" then
            if status == "queued" then
                local seconds = (GetBattlefieldTimeWaited(index) / 1000)
                local minutes = (math.fmod(seconds, 3600) / 60)
                seconds = (math.fmod(seconds, 60) )
                if minutes < 1 then
                    text3:SetText(string.format("%01d"..L.sec, seconds) )
                else
                    text3:SetText(string.format("%01d"..L.min.."\n%01d"..L.sec, minutes, seconds) )
                end
            else
                text3:SetText("")
            end
        end
    end
end

function frame4:OnUpdate()
    if enableModule_timeInQueue then
        TimeInQueue()
    end
end
frame4:SetScript("OnUpdate", frame4.OnUpdate)
end
