function RunHideChatButton()
-- HideChatButton : a button to hide your chat.
local HCBframe = nil -- our button frame
local HCBActivateChat = ChatEdit_ActivateChat -- chat box stealing

-- initialize the frame
if not HCBframe then
    -- make a  button frame
    HCBframe = CreateFrame("Button", "HCBframe", UIParent, "UIPanelButtonTemplate")
    -- make it movable
    HCBframe:SetClampedToScreen(true)
    HCBframe:SetMovable(true)
    HCBframe:EnableMouse(true)
    HCBframe:RegisterForDrag("RightButton")
    HCBframe:SetScript("OnDragStart", HCBframe.StartMoving)
    HCBframe:SetScript("OnDragStop", HCBframe.StopMovingOrSizing)
    -- size
    HCBframe:SetWidth(24)
    HCBframe:SetHeight(24)
    -- anchor it
    HCBframe:SetPoint("BOTTOMLEFT", FuiDB.HCB.HCBxpos or 0, FuiDB.HCB.HCBypos or 0)
    -- vars
    HCBframe.ChatIsShown = true
    HCBframe.ActiveTabs = {
        [1] = true
    }
    FuiDB.HCB.HCBkeyable = FuiDB.HCB.HCBkeyable or false
    FuiDB.HCB.HCBuseralpha = FuiDB.HCB.HCBuseralpha or .25
    -- mouse wheel
    HCBframe:EnableMouseWheel(true)
end

-- enter key or / key to show or not
-- either way you still get the edit frame
-- but chat may or may not show based on this
HCBframe.ToggleKeyable = function(frame)
    if FuiDB.HCB.HCBkeyable == false then
        FuiDB.HCB.HCBkeyable = true
    else
        FuiDB.HCB.HCBkeyable = false
    end
    HCBframe:Paint()
end

-- user alpha update
HCBframe.AlphaUpdate = function(frame, delta)
    if delta == 1 and FuiDB.HCB.HCBuseralpha < 1 then
        FuiDB.HCB.HCBuseralpha = FuiDB.HCB.HCBuseralpha + .05
    elseif delta == -1 and FuiDB.HCB.HCBuseralpha > 0 then
        FuiDB.HCB.HCBuseralpha = FuiDB.HCB.HCBuseralpha - .05
    end
    HCBframe:Paint()
end

-- painter for alpha paint based on keyablility
HCBframe.Paint = function(frame, text)
    HCBframe:SetAlpha(FuiDB.HCB.HCBkeyable and 1.0 or (FuiDB.HCB.HCBuseralpha or .25))
    HCBframe:SetText(text or "")
end

-- restore defaults
HCBframe.RestoreDefaults = function(frame)
    FuiDB.HCB.HCBkeyable = true
    FuiDB.HCB.HCBxpos = 0
    FuiDB.HCB.HCBypos = 0
    FuiDB.HCB.HCBuseralpha = .25
    HCBframe:ClearAllPoints()
    HCBframe:SetPoint("BOTTOMLEFT", FuiDB.HCB.HCBxpos, FuiDB.HCB.HCBypos)
    HCBframe:Paint()
end

-- hide chats
HCBframe.HideChat = function(frame)
    -- find visible windows
    for i = 1, NUM_CHAT_WINDOWS do
        local f = _G["ChatFrame" .. i]
        if f then
            if f.minimized then
                local fm = _G["ChatFrame" .. i .. "Minimized"]
                if fm then
                    fm.HCBOverrideShow = fm.Show
                    fm.Show = fm.Hide
                    fm:Hide()
                end
                -- minimized, so no visible tab
                frame.ActiveTabs[i] = false
            elseif f:IsVisible() then
                frame.ActiveTabs[i] = true
                f:Hide()
            else
                frame.ActiveTabs[i] = false
            end
            -- override :Show()
            f.HCBOverrideShow = f.Show
            f.Show = f.Hide
        end
    end
    -- override and hide main tab group
    GeneralDockManager.HCBOverrideShow = GeneralDockManager.Show
    GeneralDockManager.Show = GeneralDockManager.Hide
    -- hide floating window tabs
    for i = 1, NUM_CHAT_WINDOWS do
        local f = _G["ChatFrame" .. i .. "Tab"]
        if f then
            if frame.ActiveTabs[i] == true and f:IsVisible() then
                f:Hide()
            end
            -- override :Show()
            f.HCBOverrideShow = f.Show
            f.Show = f.Hide
        end
    end
    GeneralDockManager:Hide() -- tabs
    ChatFrameMenuButton:Hide() -- menu button
    FriendsMicroButton:Hide() -- friends micro button
    frame.ChatIsShown = false -- toggle shown state
end

-- show chats
HCBframe.ShowChat = function(frame)
    -- revert override functionality while we're visible
    GeneralDockManager.Show = GeneralDockManager.HCBOverrideShow
    GeneralDockManager:Show() -- the tabs
    ChatFrameMenuButton:Show() -- menu button
    FriendsMicroButton:Show() -- friends micro button

    for i = 1, NUM_CHAT_WINDOWS do
        -- chats
        local f = _G["ChatFrame" .. i]
        if f then
            -- restore overrides
            f.Show = f.HCBOverrideShow
            if f.minimized then
                local fm = _G["ChatFrame" .. i .. "Minimized"]
                if fm then
                    fm.Show = fm.HCBOverrideShow
                    fm:Show()
                end
            elseif frame.ActiveTabs[i] == true then
                f:Show()
            end
        end
        -- tabs
        local f = _G["ChatFrame" .. i .. "Tab"]
        if f then
            -- restore overrides
            f.Show = f.HCBOverrideShow
            if frame.ActiveTabs[i] == true then
                f:Show()
            end
        end
    end
    frame.ChatIsShown = true -- toggle shown state
end

-- toggle visible
HCBframe.ToggleVisible = function(frame)
    if HCBframe.ChatIsShown == false then
        HCBframe:ShowChat()
    else
        HCBframe:HideChat()
    end
    HCBframe:Paint()
end

-- clicker
HCBframe:SetScript("OnMouseUp", function(frame, button)
    if IsControlKeyDown() then
        HCBframe:RestoreDefaults()
    elseif IsShiftKeyDown() then
        HCBframe:ToggleKeyable()
    elseif button == "LeftButton" then
        HCBframe:ToggleVisible()
    end
end)

-- mouse wheel
HCBframe:SetScript("OnMouseWheel", function(frame, delta)
    if IsShiftKeyDown() then
        HCBframe.ToggleKeyable()
    elseif IsAltKeyDown() then
        HCBframe.AlphaUpdate(frame, delta)
    else
        HCBframe.ToggleVisible()
    end
end)

-- hook chat show
function ChatEdit_ActivateChat(frame) -- thanks Treader of Cenarion Circle
    if FuiDB.HCB.HCBkeyable == true and HCBframe.ChatIsShown == false then
        HCBframe:ToggleVisible()
    end
    HCBActivateChat(frame) -- run the original function
end

-- events
HCBframe:RegisterEvent("CHAT_MSG_BATTLEGROUND")
HCBframe:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER")
HCBframe:RegisterEvent("CHAT_MSG_GUILD")
HCBframe:RegisterEvent("CHAT_MSG_OFFICER")
HCBframe:RegisterEvent("CHAT_MSG_PARTY")
HCBframe:RegisterEvent("CHAT_MSG_PARTY_LEADER")
HCBframe:RegisterEvent("CHAT_MSG_RAID")
HCBframe:RegisterEvent("CHAT_MSG_RAID_LEADER")
HCBframe:RegisterEvent("CHAT_MSG_WHISPER")
HCBframe:RegisterEvent("ADDON_LOADED")

HCBframe.OnEvent = function(frame, event, ...)
    local eventcolors = {
        -- registered event name           RRGGBB+letter
        CHAT_MSG_BATTLEGROUND = "cc6633B",
        CHAT_MSG_BATTLEGROUND_LEADER = "cc6633B",
        CHAT_MSG_GUILD = "66cc00G",
        CHAT_MSG_GUILD_OFFICER = "66cc00O",
        CHAT_MSG_PARTY = "6666FFP",
        CHAT_MSG_PARTY_LEADER = "6666FFP",
        CHAT_MSG_RAID = "cc6600R",
        CHAT_MSG_RAID_LEADER = "cc6600R",
        CHAT_MSG_WHISPER = "ff00ffW"
        -- we don't make one for ADDON_LOADED
    }
    if HCBframe.ChatIsShown == false and eventcolors[event] then
        HCBframe:Paint("|cff" .. eventcolors[event] .. "|r")
    elseif event == "ADDON_LOADED" then
        HCBframe:Paint()
        -- I don't like to do this here, but without it we have paint issues.
        -- Making it an else should save on wasted if checks though.
    end
end

HCBframe:SetScript("OnEvent", HCBframe.OnEvent);

-- Slash Command
SLASH_HCB1 = "/hcb"
SlashCmdList["HCB"] = function(arg)
    if arg == "default" or arg == "reset" then
        HCBframe:RestoreDefaults()
    else
        HCBframe:ToggleVisible()
    end
end
end
