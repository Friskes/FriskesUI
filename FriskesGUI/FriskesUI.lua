FRISKESUI_GLOBAL_ADDON_NAME, FriskesUI = ...
local L = LibStub('AceLocale-3.0'):GetLocale('FriskesUI')

FUI_RELOAD_BUTTON_TEXT = L.ReloadButtonText
FUI_CHECK_BUTTON1_TEXT = L.CheckButton1Text
FUI_COLOR_SELECT_BUTTON1AND2_TEXT_TOOLTIP = L.ColorSelectButton1and2TextToolTip
FUI_CHECK_BUTTON2_TEXT = L.CheckButton2Text
FUI_CHECK_BUTTON3_TEXT = L.CheckButton3Text
FUI_CHECK_BUTTON4_TEXT = L.CheckButton4Text
FUI_CHECK_BUTTON5_TEXT = L.CheckButton5Text
FUI_CHECK_BUTTON5_TEXT_TOOLTIP = L.CheckButton5TextToolTip
FUI_CHECK_BUTTON6_TEXT = L.CheckButton6Text
FUI_CHECK_BUTTON7_TEXT = L.CheckButton7Text
FUI_CHECK_BUTTON8_TEXT = L.CheckButton8Text
FUI_CHECK_BUTTON9_TEXT = L.CheckButton9Text
FUI_CHECK_BUTTON10_TEXT = L.CheckButton10Text
FUI_CHECK_BUTTON11_TEXT = L.CheckButton11Text
FUI_CHECK_BUTTON12_TEXT = L.CheckButton12Text
FUI_CHECK_BUTTON13_TEXT = L.CheckButton13Text
FUI_CHECK_BUTTON14_TEXT = L.CheckButton14Text
FUI_CHECK_BUTTON15_TEXT = L.CheckButton15Text
FUI_CHECK_BUTTON16_TEXT = L.CheckButton16Text
FUI_CHECK_BUTTON17_TEXT = L.CheckButton17Text
FUI_CHECK_BUTTON17_TEXT_TOOLTIP = L.CheckButton17TextToolTip
FUI_CHECK_BUTTON18_TEXT = L.CheckButton18Text
FUI_CHECK_BUTTON19_TEXT = L.CheckButton19Text
FUI_CHECK_BUTTON20_TEXT = L.CheckButton20Text
FUI_CHECK_BUTTON20_TEXT_TOOLTIP = L.CheckButton20TextToolTip
FUI_CHECK_BUTTON21_TEXT = L.CheckButton21Text
FUI_CHECK_BUTTON22_TEXT = L.CheckButton22Text
FUI_CHECK_BUTTON23_TEXT = L.CheckButton23Text
FUI_CHECK_BUTTON24_TEXT = L.CheckButton24Text
FUI_CHECK_BUTTON25_TEXT = L.CheckButton25Text
FUI_CHECK_BUTTON26_TEXT = L.CheckButton26Text
FUI_CHECK_BUTTON27_TEXT = L.CheckButton27Text
FUI_CHECK_BUTTON28_TEXT = L.CheckButton28Text
FUI_CHECK_BUTTON28_TEXT_TOOLTIP = L.CheckButton28TextToolTip
FUI_CHECK_BUTTON29_TEXT = L.CheckButton29Text
FUI_CHECK_BUTTON30_TEXT = L.CheckButton30Text
FUI_CHECK_BUTTON31_TEXT = L.CheckButton31Text
FUI_CHECK_BUTTON32_TEXT = L.CheckButton32Text
FUI_CHECK_BUTTON33_TEXT = L.CheckButton33Text
FUI_CHECK_BUTTON34_TEXT = L.CheckButton34Text
FUI_CHECK_BUTTON35_TEXT = L.CheckButton35Text
FUI_CHECK_BUTTON36_TEXT = L.CheckButton36Text
FUI_CHECK_BUTTON37_TEXT = L.CheckButton37Text
FUI_CHECK_BUTTON38_TEXT = L.CheckButton38Text

FuiDB = {
    defaults = {
        texturescolor1 = true,
        texturescolor2 = true,
        hideerrors = true,
        arenatrinkets = true,
        changeselfname = true,
        classcolorsonhealthbars = true,
        classicononportraits = true,
        combaticons = true,
        friskesbar = true,
        hidemicromenuandbags = false,
        hiderightpanels = false,
        showrightpanelsincombat = false,
        dispelborder = true,
        hidebindsandmacros = false,
        selltrash = true,
        ringofvalortimer = true,
        tremortotemtimer = true,
        eliteplayerframe = true,
        namescolor = true,
        improvedchat = true,
        hideglowonplayerframe = true,
        blacknamebackground = true,
        classcolorsonnamebackground = false,
        hidepvpicon = true,
        hideleadericon = true,
        hidepvptimertext = true,
        hidehitindicator = true,
        hidegroupindicator = true,
        moveframes = false,
        hideminimapbutton = false,
        dalaranarenaejecttimer = true,
        arenatimeremainingtimer = true,
        tasteforbloodtimer = false,
        retailtimer = true,
        hidegryphons = true,
        scalingauras = true,
        classcoloronnames = false,
        movetooltip = true,
    },
    HCB = {
        HCBxpos,
        HCBypos,
        HCBkeyable,
        HCBuseralpha,
    },
    position = {
        RingOfValorTimer_XPOS = 645.7,
        RingOfValorTimer_YPOS = 368.1,
        TremorTotemTimer_XPOS = 648.8,
        TremorTotemTimer_YPOS = 420.3,
        DalaranArenaEjectTimer_XPOS = 645.7,
        DalaranArenaEjectTimer_YPOS = 368.1,
        TasteForBloodTimer_XPOS = 622.8,
        TasteForBloodTimer_YPOS = 265.4,
        PFx = 140.1,
        PFy = 527.9,
        TFx = 369.3,
        TFy = 527.9,
        FFx = 369.3,
        FFy = 312.8,
        PMF1x = 110,
        PMF1y = 316,
        PMF2x = 110,
        PMF2y = 256,
        PMF3x = 110,
        PMF3y = 196,
        PMF4x = 110,
        PMF4y = 136,
    },
    ScaleBar = 1.0, -- макс 1.24
    NewName = "Friskes",
    BordersColor = {
        R = 0.4,
        G = 0.4,
        B = 0.4,
        A = 1.0,
    },
    TexturesColor = {
        R = 0.3,
        G = 0.3,
        B = 0.3,
        A = 1.0,
    },
}
FuiColor = {
    tR = 1.0,
    tG = 1.0,
    tB = 1.0,
    tA = 1.0,

    bR = 1.0,
    bG = 1.0,
    bB = 1.0,
    bA = 1.0,

    GTF = "|cff000000%d|r",

    PFT = {
        R = 1.0,
        G = 0.79,
        B = 0.04,
        A = 1.0,
    },

    Names = {
        R = 1.0,
        G = 1.0,
        B = 1.0,
        A = 1.0,
    },
}

local LDB = LibStub("LibDataBroker-1.1")
local LDBicon = LibStub("LibDBIcon-1.0")

local colorFrame = CreateFrame("frame");
local colorElapsed = 0;
local colorDelay = 1.5;
local r1, g1, b1 = 0.8, 0, 1;
local r2, g2, b2 = random(2)-1, random(2)-1, random(2)-1;

local Broker_FriskesUI
Broker_FriskesUI = LDB:NewDataObject("FriskesUI", {
type = "data source",
text = "FriskesUI",
icon = "Interface\\AddOns\\FriskesUI\\Media\\Textures\\peepoWoW",
OnClick = function(self, button)
    if (button == 'LeftButton') then
        if (IsShiftKeyDown() ) then
            --print("Shift+Left")
        else
            --print("Left")
        end
    elseif (button == 'MiddleButton') then
        --print("Center")
    else
        --print("Right")
    end

    OpenFriskesUI_Toggle()
end,
OnEnter = function(self)
    colorFrame:SetScript("OnUpdate", function(self, elaps)
        colorElapsed = colorElapsed + elaps;
        if ( colorElapsed > colorDelay ) then
            colorElapsed = colorElapsed - colorDelay;
            r1, g1, b1 = r2, g2, b2;
            r2, g2, b2 = random(2)-1, random(2)-1, random(2)-1;
        end
        Broker_FriskesUI.iconR = r1 + (r2 - r1) * colorElapsed / colorDelay;
        Broker_FriskesUI.iconG = g1 + (g2 - g1) * colorElapsed / colorDelay;
        Broker_FriskesUI.iconB = b1 + (b2 - b1) * colorElapsed / colorDelay;
      end);
end,
OnLeave = function(self)
    colorFrame:SetScript("OnUpdate", nil);
end,
iconR = 0.6,
iconG = 0,
iconB = 1
});

local function HideMinimapButton()
    FuiDB.minimap.hide = not FuiDB.minimap.hide

    if FuiDB.minimap.hide then
        LDBicon:Hide("FriskesUI")
        print(L.HideMinimapButtonInfo)
    else
        LDBicon:Show("FriskesUI")
    end
end

SLASH_FUI1 = "/fui"
SLASH_FUI2 = "/friskes"
SLASH_FUI3 = "/friskesui"
SlashCmdList["FUI"] = function()
    OpenFriskesUI_Toggle()
end

function CloseFriskesUI()
    SettingsFrame:Hide()

    if FuiDB.defaults.ringofvalortimer == true then
        StopMoveRingOfValorTimer()
    end

    if FuiDB.defaults.tremortotemtimer == true then
        StopMoveTremorTotemTimer()
    end

    if FuiDB.defaults.dalaranarenaejecttimer == true then
        StopMoveDalaranArenaEjectTimer()
    end

    if FuiDB.defaults.tasteforbloodtimer == true then
        StopMoveTasteForBloodTimer()
    end

    if FuiDB.defaults.moveframes == true then
        StopMoveFrames()
    end
end

local function StartMoveIcons()
    if FuiDB.defaults.ringofvalortimer == true then
        StartMoveRingOfValorTimer()
    end

    if FuiDB.defaults.tremortotemtimer == true then
        StartMoveTremorTotemTimer()
    end

    if FuiDB.defaults.dalaranarenaejecttimer == true then
        StartMoveDalaranArenaEjectTimer()
    end

    if FuiDB.defaults.tasteforbloodtimer == true then
        StartMoveTasteForBloodTimer()
    end

    if FuiDB.defaults.moveframes == true then
        StartMoveFrames()
    end
end

function OpenFriskesUI_Toggle()
    if (SettingsFrame:IsShown() ) then
        CloseFriskesUI()
    else
        SettingsFrame:Show()
        StartMoveIcons()
    end
end

-- Скрываем окно настроек эскейпом
hooksecurefunc("ToggleGameMenu", function()
    if (SettingsFrame:IsShown() ) then
        if (GameMenuFrame:IsShown() ) then
            HideUIPanel(GameMenuFrame)
        end
        CloseFriskesUI()
    end
end)

local friskesui = CreateFrame("Frame", friskesui, UIParent)

friskesui:RegisterEvent("ADDON_LOADED")

function friskesui:OnEvent(event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == "FriskesUI" then

            -- фиксим несовместимость с лорти
            if not IsAddOnLoaded("Lorti UI") then
                local _, _, _, _, reason = GetAddOnInfo("Lorti UI")
                if reason ~= "MISSING" and reason ~= "DISABLED" then
                    if reason == nil then
                        RunFixBlizzardButtonBorders()
                    end
                end
            end

            SettingsFrameCheckButton1:SetChecked(FuiDB.defaults.texturescolor1)
            friskesui.texturescolor1()
            SettingsFrameColorSelectButton1Texture:SetTexture(FuiDB.BordersColor.R, FuiDB.BordersColor.G, FuiDB.BordersColor.B, FuiDB.BordersColor.A)

            SettingsFrameCheckButton2:SetChecked(FuiDB.defaults.texturescolor2)
            friskesui.texturescolor2()
            SettingsFrameColorSelectButton2Texture:SetTexture(FuiDB.TexturesColor.R, FuiDB.TexturesColor.G, FuiDB.TexturesColor.B, FuiDB.TexturesColor.A)

            SettingsFrameCheckButton3:SetChecked(FuiDB.defaults.hideerrors)
            friskesui.hideerrors()
            SettingsFrameCheckButton4:SetChecked(FuiDB.defaults.retailtimer)
            friskesui.retailtimer()
            SettingsFrameCheckButton5:SetChecked(FuiDB.defaults.changeselfname)
            friskesui.changeselfname()
            SettingsFrameCheckButton6:SetChecked(FuiDB.defaults.classcolorsonhealthbars)
            friskesui.classcolorsonhealthbars()
            SettingsFrameCheckButton7:SetChecked(FuiDB.defaults.classicononportraits)
            friskesui.classicononportraits()
            SettingsFrameCheckButton8:SetChecked(FuiDB.defaults.combaticons)
            friskesui.combaticons()

            SettingsFrameCheckButton9:SetChecked(FuiDB.defaults.friskesbar)
            friskesui.friskesbar()
            SettingsFrameScaleSlider:SetValue(FuiDB.ScaleBar)

            SettingsFrameCheckButton10:SetChecked(FuiDB.defaults.hidemicromenuandbags)
            friskesui.hidemicromenuandbags()
            SettingsFrameCheckButton11:SetChecked(FuiDB.defaults.hiderightpanels)
            friskesui.hiderightpanels()
            SettingsFrameCheckButton12:SetChecked(FuiDB.defaults.showrightpanelsincombat)
            friskesui.showrightpanelsincombat()
            SettingsFrameCheckButton13:SetChecked(FuiDB.defaults.dispelborder)
            friskesui.dispelborder()
            SettingsFrameCheckButton14:SetChecked(FuiDB.defaults.hidebindsandmacros)
            friskesui.hidebindsandmacros()
            SettingsFrameCheckButton15:SetChecked(FuiDB.defaults.selltrash)
            friskesui.selltrash()
            SettingsFrameCheckButton16:SetChecked(FuiDB.defaults.ringofvalortimer)
            friskesui.ringofvalortimer()
            SettingsFrameCheckButton17:SetChecked(FuiDB.defaults.tremortotemtimer)
            friskesui.tremortotemtimer()
            SettingsFrameCheckButton18:SetChecked(FuiDB.defaults.eliteplayerframe)
            friskesui.eliteplayerframe()
            SettingsFrameCheckButton19:SetChecked(FuiDB.defaults.namescolor)
            friskesui.namescolor()
            SettingsFrameCheckButton37:SetChecked(FuiDB.defaults.classcoloronnames)
            friskesui.classcoloronnames()
            SettingsFrameCheckButton20:SetChecked(FuiDB.defaults.improvedchat)
            friskesui.improvedchat()
            SettingsFrameCheckButton21:SetChecked(FuiDB.defaults.hideglowonplayerframe)
            friskesui.hideglowonplayerframe()
            SettingsFrameCheckButton22:SetChecked(FuiDB.defaults.blacknamebackground)
            friskesui.blacknamebackground()
            SettingsFrameCheckButton36:SetChecked(FuiDB.defaults.classcolorsonnamebackground)
            friskesui.classcolorsonnamebackground()
            SettingsFrameCheckButton23:SetChecked(FuiDB.defaults.hidepvpicon)
            friskesui.hidepvpicon()
            SettingsFrameCheckButton24:SetChecked(FuiDB.defaults.hideleadericon)
            friskesui.hideleadericon()
            SettingsFrameCheckButton25:SetChecked(FuiDB.defaults.hidepvptimertext)
            friskesui.hidepvptimertext()
            SettingsFrameCheckButton26:SetChecked(FuiDB.defaults.hidehitindicator)
            friskesui.hidehitindicator()
            SettingsFrameCheckButton27:SetChecked(FuiDB.defaults.hidegroupindicator)
            friskesui.hidegroupindicator()
            SettingsFrameCheckButton28:SetChecked(FuiDB.defaults.moveframes)
            friskesui.moveframes()

            SettingsFrameCheckButton29:SetChecked(FuiDB.defaults.hideminimapbutton)
            FuiDB.minimap = FuiDB.minimap or { minimapPos = 303, hide = false }
            LDBicon:Register("FriskesUI", Broker_FriskesUI, FuiDB.minimap)

            SettingsFrameCheckButton30:SetChecked(FuiDB.defaults.dalaranarenaejecttimer)
            friskesui.dalaranarenaejecttimer()
            SettingsFrameCheckButton31:SetChecked(FuiDB.defaults.arenatimeremainingtimer)
            friskesui.arenatimeremainingtimer()
            SettingsFrameCheckButton32:SetChecked(FuiDB.defaults.tasteforbloodtimer)
            friskesui.tasteforbloodtimer()
            SettingsFrameCheckButton33:SetChecked(FuiDB.defaults.arenatrinkets)
            friskesui.arenatrinkets()
            SettingsFrameCheckButton34:SetChecked(FuiDB.defaults.hidegryphons)
            friskesui.hidegryphons()
            SettingsFrameCheckButton35:SetChecked(FuiDB.defaults.scalingauras)
            friskesui.scalingauras()
            SettingsFrameCheckButton38:SetChecked(FuiDB.defaults.movetooltip)
            friskesui.movetooltip()

            if FuiDB.defaults.moveframes == true then
                SetMoveFrames()
            end
        end
    end
end
friskesui:SetScript("OnEvent", friskesui.OnEvent)

function friskesui.texturescolor1()
    if FuiDB.defaults.texturescolor1 == true then
        FuiColor.tR = FuiDB.BordersColor.R
        FuiColor.tG = FuiDB.BordersColor.G
        FuiColor.tB = FuiDB.BordersColor.B
        FuiColor.tA = FuiDB.BordersColor.A

        FuiColor.bR = FuiDB.BordersColor.R
        FuiColor.bG = FuiDB.BordersColor.G
        FuiColor.bB = FuiDB.BordersColor.B
        FuiColor.bA = FuiDB.BordersColor.A
        SettingsFrameColorSelectButton1:Enable()
    else
        FuiColor.tR = 1.0
        FuiColor.tG = 1.0
        FuiColor.tB = 1.0
        FuiColor.tA = 1.0

        FuiColor.bR = 1.0
        FuiColor.bG = 1.0
        FuiColor.bB = 1.0
        FuiColor.bA = 1.0
        SettingsFrameColorSelectButton1:Disable()
    end
end

function SwitchTexturesColor1()
    if SettingsFrameCheckButton1:GetChecked() == 1 then
        FuiDB.defaults.texturescolor1 = true
        SettingsFrameColorSelectButton1:Enable()
    else
        FuiDB.defaults.texturescolor1 = false
        SettingsFrameColorSelectButton1:Disable()
    end
end

function friskesui.texturescolor2()
    if FuiDB.defaults.texturescolor2 == true then
        FuiColor.GTF = "|cffffffff%d|r"

        FuiColor.R = FuiDB.TexturesColor.R
        FuiColor.G = FuiDB.TexturesColor.G
        FuiColor.B = FuiDB.TexturesColor.B
        FuiColor.A = FuiDB.TexturesColor.A

        FuiColor.PFT.R = FuiDB.TexturesColor.R
        FuiColor.PFT.G = FuiDB.TexturesColor.G
        FuiColor.PFT.B = FuiDB.TexturesColor.B
        FuiColor.PFT.A = FuiDB.TexturesColor.A
        SettingsFrameColorSelectButton2:Enable()
    else
        FuiColor.R = 1.0
        FuiColor.G = 1.0
        FuiColor.B = 1.0
        FuiColor.A = 1.0

        FuiColor.PFT.R = 1.0
        FuiColor.PFT.G = 0.79
        FuiColor.PFT.B = 0.04
        FuiColor.PFT.A = 1.0
        SettingsFrameColorSelectButton2:Disable()
    end
end

function SwitchTexturesColor2()
    if SettingsFrameCheckButton2:GetChecked() == 1 then
        FuiDB.defaults.texturescolor2 = true
        SettingsFrameColorSelectButton2:Enable()
    else
        FuiDB.defaults.texturescolor2 = false
        SettingsFrameColorSelectButton2:Disable()
    end
end

function friskesui.hideerrors()
    if FuiDB.defaults.hideerrors == true then
        UIErrorsFrame:Hide()
    end
end

function SwitchHideErrors()
    if SettingsFrameCheckButton3:GetChecked() == 1 then
        FuiDB.defaults.hideerrors = true
    else
        FuiDB.defaults.hideerrors = false
    end
end

function friskesui.retailtimer()
    if FuiDB.defaults.retailtimer == true then
        RunInviteTimer()
        RunStartTimer()
    end
end

function SwitchRetailTimer()
    if SettingsFrameCheckButton4:GetChecked() == 1 then
        FuiDB.defaults.retailtimer = true
    else
        FuiDB.defaults.retailtimer = false
    end
end

function friskesui.changeselfname()
    if FuiDB.defaults.changeselfname == true then
        RunChangeSelfName()
    end
end

function SwitchChangeSelfName()
    if SettingsFrameCheckButton5:GetChecked() == 1 then
        FuiDB.defaults.changeselfname = true
    else
        FuiDB.defaults.changeselfname = false
    end
end

function friskesui.classcolorsonhealthbars()
    if FuiDB.defaults.classcolorsonhealthbars == true then
        RunClassColorsOnHealthBars()
    end
end

function SwitchClassColorsOnHealthBars()
    if SettingsFrameCheckButton6:GetChecked() == 1 then
        FuiDB.defaults.classcolorsonhealthbars = true
    else
        FuiDB.defaults.classcolorsonhealthbars = false
    end
end

function friskesui.classicononportraits()
    if FuiDB.defaults.classicononportraits == true then
        RunClassIconOnPortraits()
    end
end

function SwitchClassIconOnPortraits()
    if SettingsFrameCheckButton7:GetChecked() == 1 then
        FuiDB.defaults.classicononportraits = true
    else
        FuiDB.defaults.classicononportraits = false
    end
end

function friskesui.combaticons()
    if FuiDB.defaults.combaticons == true then
        RunCombatIcons()
    end
end

function SwitchCombatIcons()
    if SettingsFrameCheckButton8:GetChecked() == 1 then
        FuiDB.defaults.combaticons = true
    else
        FuiDB.defaults.combaticons = false
    end
end

local enabled = false
function FriskesBarUpdateScale(value)
    FuiDB.ScaleBar = SettingsFrameScaleSlider:GetValue()
    SettingsFrameScaleSliderTextCurrent:SetText(string.format("%.2f", value) )

    if FuiDB.defaults.friskesbar == true then
        if enabled then -- игнорируем первый вызов при загрузке интерфейса
            FriskesBar.UpdateUI()
        end
    end
    enabled = true
end

local enabled2
function friskesui.friskesbar()
    if FuiDB.defaults.friskesbar == true then
        RunFriskesBar()
        enabled2 = true
        SettingsFrameCheckButton10:Enable()
        SettingsFrameScaleSlider:Enable()
    else
        enabled2 = false
        SettingsFrameCheckButton10:Disable()
        SettingsFrameScaleSlider:Disable()
        SettingsFrameScaleSliderTextMin:SetFontObject(GameFontDisable)
        SettingsFrameScaleSliderTextCurrent:SetFontObject(GameFontDisable)
        SettingsFrameScaleSliderTextMax:SetFontObject(GameFontDisable)
        SettingsFrameCheckButton10Text:SetFontObject(GameFontDisable)
    end
end

function SwitchFriskesBar()
    if SettingsFrameCheckButton9:GetChecked() == 1 then
        FuiDB.defaults.friskesbar = true
        enabled2 = true
        SettingsFrameCheckButton10:Enable()
        --SettingsFrameScaleSlider:Enable()
        SettingsFrameScaleSliderTextMin:SetFontObject(GameFontHighlight)
        SettingsFrameScaleSliderTextCurrent:SetFontObject(GameFontNormal)
        SettingsFrameScaleSliderTextMax:SetFontObject(GameFontHighlight)
        SettingsFrameCheckButton10Text:SetFontObject(GameFontHighlight)
    else
        FuiDB.defaults.friskesbar = false
        enabled2 = false
        SettingsFrameCheckButton10:Disable()
        --SettingsFrameScaleSlider:Disable()
        SettingsFrameScaleSliderTextMin:SetFontObject(GameFontDisable)
        SettingsFrameScaleSliderTextCurrent:SetFontObject(GameFontDisable)
        SettingsFrameScaleSliderTextMax:SetFontObject(GameFontDisable)
        SettingsFrameCheckButton10Text:SetFontObject(GameFontDisable)
        --FuiDB.defaults.hidemicromenuandbags = false
    end
end

function friskesui.hidemicromenuandbags()
    if FuiDB.defaults.hidemicromenuandbags == true then
        if enabled2 == true then
            RunHideMicroMenuAndBags()
        end
    end
end

function SwitchHideMicroMenuAndBags()
    if SettingsFrameCheckButton10:GetChecked() == 1 then
        FuiDB.defaults.hidemicromenuandbags = true
    else
        FuiDB.defaults.hidemicromenuandbags = false
    end
end

function friskesui.hiderightpanels()
    if FuiDB.defaults.hiderightpanels == true then
        RunHideRightPanels()
    end
end

function SwitchHideRightPanels()
    if SettingsFrameCheckButton11:GetChecked() == 1 then
        FuiDB.defaults.hiderightpanels = true
        FuiDB.defaults.showrightpanelsincombat = false
        SettingsFrameCheckButton12:SetChecked(false)
    else
        FuiDB.defaults.hiderightpanels = false
    end
end

function friskesui.showrightpanelsincombat()
    if FuiDB.defaults.showrightpanelsincombat == true then
        RunShowRightPanelsInCombat()
    end
end

function SwitchShowRightPanelsInCombat()
    if SettingsFrameCheckButton12:GetChecked() == 1 then
        FuiDB.defaults.showrightpanelsincombat = true
        FuiDB.defaults.hiderightpanels = false
        SettingsFrameCheckButton11:SetChecked(false)
    else
        FuiDB.defaults.showrightpanelsincombat = false
    end
end

function friskesui.dispelborder()
    if FuiDB.defaults.dispelborder == true then
        RunDispelBorder()
    end
end

function SwitchDispelBorder()
    if SettingsFrameCheckButton13:GetChecked() == 1 then
        FuiDB.defaults.dispelborder = true
    else
        FuiDB.defaults.dispelborder = false
    end
end

function friskesui.hidebindsandmacros()
    if FuiDB.defaults.hidebindsandmacros == true then
        RunHideBindsAndMacros()
    end
end

function SwitchHideBindsAndMacros()
    if SettingsFrameCheckButton14:GetChecked() == 1 then
        FuiDB.defaults.hidebindsandmacros = true
    else
        FuiDB.defaults.hidebindsandmacros = false
    end
end

function friskesui.selltrash()
    if FuiDB.defaults.selltrash == true then
        RunSellTrash()
    end
end

function SwitchSellTrash()
    if SettingsFrameCheckButton15:GetChecked() == 1 then
        FuiDB.defaults.selltrash = true
    else
        FuiDB.defaults.selltrash = false
    end
end

function friskesui.ringofvalortimer()
    if FuiDB.defaults.ringofvalortimer == true then
        RunRingOfValorTimer()
    end
end

function SwitchRingOfValorTimer()
    if SettingsFrameCheckButton16:GetChecked() == 1 then
        FuiDB.defaults.ringofvalortimer = true
    else
        FuiDB.defaults.ringofvalortimer = false
    end
end

function friskesui.tremortotemtimer()
    if FuiDB.defaults.tremortotemtimer == true then
        RunTremorTotemTimer()
    end
end

function SwitchTremorTotemTimer()
    if SettingsFrameCheckButton17:GetChecked() == 1 then
        FuiDB.defaults.tremortotemtimer = true
    else
        FuiDB.defaults.tremortotemtimer = false
    end
end

function friskesui.eliteplayerframe()
    if FuiDB.defaults.eliteplayerframe == true then
        RunElitePlayerFrame()
    end
end

function SwitchElitePlayerFrame()
    if SettingsFrameCheckButton18:GetChecked() == 1 then
        FuiDB.defaults.eliteplayerframe = true
    else
        FuiDB.defaults.eliteplayerframe = false
    end
end

function friskesui.namescolor()
    if FuiDB.defaults.namescolor == true then
        RunNamesColor()
    end
end

function SwitchNamesColor()
    if SettingsFrameCheckButton19:GetChecked() == 1 then
        FuiDB.defaults.namescolor = true
        FuiDB.defaults.classcoloronnames = false
        SettingsFrameCheckButton37:SetChecked(false)
    else
        FuiDB.defaults.namescolor = false
    end
end

function friskesui.classcoloronnames()
    if FuiDB.defaults.classcoloronnames == true then
        RunClassColorOnNames()
    end
end

function SwitchClassColorOnNames()
    if SettingsFrameCheckButton37:GetChecked() == 1 then
        FuiDB.defaults.classcoloronnames = true
        FuiDB.defaults.namescolor = false
        SettingsFrameCheckButton19:SetChecked(false)
    else
        FuiDB.defaults.classcoloronnames = false
    end
end

function friskesui.improvedchat()
    if FuiDB.defaults.improvedchat == true then
        RunHideChatButton()
        RunImprovedChat()
    end
end

function SwitchImprovedChat()
    if SettingsFrameCheckButton20:GetChecked() == 1 then
        FuiDB.defaults.improvedchat = true
    else
        FuiDB.defaults.improvedchat = false
    end
end

function friskesui.hideglowonplayerframe()
    if FuiDB.defaults.hideglowonplayerframe == true then
        RunHideGlowOnPlayerFrame()
    end
end

function SwitchHideGlowOnPlayerFrame()
    if SettingsFrameCheckButton21:GetChecked() == 1 then
        FuiDB.defaults.hideglowonplayerframe = true
    else
        FuiDB.defaults.hideglowonplayerframe = false
    end
end

function friskesui.blacknamebackground()
    if FuiDB.defaults.blacknamebackground == true then
        RunBlackNameBackground()
    end
end

function SwitchBlackNameBackground()
    if SettingsFrameCheckButton22:GetChecked() == 1 then
        FuiDB.defaults.blacknamebackground = true
        FuiDB.defaults.classcolorsonnamebackground = false
        SettingsFrameCheckButton36:SetChecked(false)
    else
        FuiDB.defaults.blacknamebackground = false
    end
end

function friskesui.classcolorsonnamebackground()
    if FuiDB.defaults.classcolorsonnamebackground == true then
        RunClassColorsOnNameBackground()
    end
end

function SwitchClassColorsOnNameBackground()
    if SettingsFrameCheckButton36:GetChecked() == 1 then
        FuiDB.defaults.classcolorsonnamebackground = true
        FuiDB.defaults.blacknamebackground = false
        SettingsFrameCheckButton22:SetChecked(false)
    else
        FuiDB.defaults.classcolorsonnamebackground = false
    end
end

function friskesui.hidepvpicon()
    if FuiDB.defaults.hidepvpicon == true then
        PlayerPVPIcon:SetSize(0.01, 0.01) -- Скрывает иконку фракции на фреймах
        TargetFrameTextureFramePVPIcon:SetSize(0.01, 0.01)
        FocusFrameTextureFramePVPIcon:SetSize(0.01, 0.01)
    end
end

function SwitchHidePVPIcon()
    if SettingsFrameCheckButton23:GetChecked() == 1 then
        FuiDB.defaults.hidepvpicon = true
    else
        FuiDB.defaults.hidepvpicon = false
    end
end

function friskesui.hideleadericon()
    if FuiDB.defaults.hideleadericon == true then
        --PlayerLeaderIcon:SetAlpha(0) -- Скрывает иконку лидера на фреймах
        TargetFrameTextureFrameLeaderIcon:SetAlpha(0)
        FocusFrameTextureFrameLeaderIcon:SetAlpha(0)
    end
end

function SwitchHideLeaderIcon()
    if SettingsFrameCheckButton24:GetChecked() == 1 then
        FuiDB.defaults.hideleadericon = true
    else
        FuiDB.defaults.hideleadericon = false
    end
end

function friskesui.hidepvptimertext()
    if FuiDB.defaults.hidepvptimertext == true then
        PlayerPVPTimerText:SetAlpha(0) -- Скрывает текстовый пвп таймер на фрейме игрока
    end
end

function SwitchHidePVPTimerText()
    if SettingsFrameCheckButton25:GetChecked() == 1 then
        FuiDB.defaults.hidepvptimertext = true
    else
        FuiDB.defaults.hidepvptimertext = false
    end
end

function friskesui.hidehitindicator()
    if FuiDB.defaults.hidehitindicator == true then
        PlayerHitIndicator.Show = function() -- Отключает цифры хила/урона на портретах игрока и питомца
        end
        PetHitIndicator.Show = function()
        end
    end
end

function SwitchHideHitIndicator()
    if SettingsFrameCheckButton26:GetChecked() == 1 then
        FuiDB.defaults.hidehitindicator = true
    else
        FuiDB.defaults.hidehitindicator = false
    end
end

function friskesui.hidegroupindicator()
    if FuiDB.defaults.hidegroupindicator == true then
        PlayerFrameGroupIndicator.Show = function() -- Отключает индикатор номера группы на фрейме игрока
        end
    end
end

function SwitchHideGroupIndicator()
    if SettingsFrameCheckButton27:GetChecked() == 1 then
        FuiDB.defaults.hidegroupindicator = true
    else
        FuiDB.defaults.hidegroupindicator = false
    end
end

function friskesui.moveframes()
    if FuiDB.defaults.moveframes == true then
        RunMoveFrames()
    end
end

function SwitchMoveFrames()
    if SettingsFrameCheckButton28:GetChecked() == 1 then
        FuiDB.defaults.moveframes = true
    else
        FuiDB.defaults.moveframes = false
    end
end

function SwitchHideMinimapButton()
    if SettingsFrameCheckButton29:GetChecked() == 1 then
        FuiDB.defaults.hideminimapbutton = true
        HideMinimapButton()
    else
        FuiDB.defaults.hideminimapbutton = false
        HideMinimapButton()
    end
end

function friskesui.dalaranarenaejecttimer()
    if FuiDB.defaults.dalaranarenaejecttimer == true then
        RunDalaranArenaEjectTimer()
    end
end

function SwitchDalaranArenaEjectTimer()
    if SettingsFrameCheckButton30:GetChecked() == 1 then
        FuiDB.defaults.dalaranarenaejecttimer = true
    else
        FuiDB.defaults.dalaranarenaejecttimer = false
    end
end

function friskesui.arenatimeremainingtimer()
    if FuiDB.defaults.arenatimeremainingtimer == true then
        RunArenaTimeRemainingTimer()
    end
end

function SwitchArenaTimeRemainingTimer()
    if SettingsFrameCheckButton31:GetChecked() == 1 then
        FuiDB.defaults.arenatimeremainingtimer = true
    else
        FuiDB.defaults.arenatimeremainingtimer = false
    end
end

function friskesui.tasteforbloodtimer()
    if FuiDB.defaults.tasteforbloodtimer == true then
        RunTasteForBloodTimer()
    end
end

function SwitchTasteForBloodTimer()
    if SettingsFrameCheckButton32:GetChecked() == 1 then
        FuiDB.defaults.tasteforbloodtimer = true
    else
        FuiDB.defaults.tasteforbloodtimer = false
    end
end

function friskesui.arenatrinkets()
    if FuiDB.defaults.arenatrinkets == true then
        RunArenaTrinkets()
    end
end

function SwitchArenaTrinkets()
    if SettingsFrameCheckButton33:GetChecked() == 1 then
        FuiDB.defaults.arenatrinkets = true
    else
        FuiDB.defaults.arenatrinkets = false
    end
end

function friskesui.hidegryphons()
    if FuiDB.defaults.hidegryphons == true then
        MainMenuBarLeftEndCap:Hide() -- скрываем грифонов
        MainMenuBarRightEndCap:Hide()
    end
end

function SwitchHideGryphons()
    if SettingsFrameCheckButton34:GetChecked() == 1 then
        FuiDB.defaults.hidegryphons = true
    else
        FuiDB.defaults.hidegryphons = false
    end
end

function friskesui.scalingauras()
    if FuiDB.defaults.scalingauras == true then
        RunScalingAuras()
    end
end

function SwitchScalingAuras()
    if SettingsFrameCheckButton35:GetChecked() == 1 then
        FuiDB.defaults.scalingauras = true
    else
        FuiDB.defaults.scalingauras = false
    end
end

function friskesui.movetooltip()
    if FuiDB.defaults.movetooltip == true then
        RunMoveTooltip()
    end
end

function SwitchMoveTooltip()
    if SettingsFrameCheckButton38:GetChecked() == 1 then
        FuiDB.defaults.movetooltip = true
    else
        FuiDB.defaults.movetooltip = false
    end
end

-- Функции выбора цвета

function FriskesUI.ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame.opacity = 1 - a
    ColorPickerFrame.hasOpacity = true
    ColorPickerFrame.previousValues = {r, g, b, a}
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
    ColorPickerFrame:SetColorRGB(r, g, b)
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
end

function FriskesUI.myColorCallback1(restore)
    local RED1, GREEN1, BLUE1, ALPHA1
    if restore then
        RED1, GREEN1, BLUE1, ALPHA1 = unpack(restore)
    else
        RED1, GREEN1, BLUE1 = ColorPickerFrame:GetColorRGB()
        ALPHA1 = 1 - OpacitySliderFrame:GetValue()
    end
    FuiDB.BordersColor.R, FuiDB.BordersColor.G, FuiDB.BordersColor.B, FuiDB.BordersColor.A = RED1, GREEN1, BLUE1, ALPHA1
    SettingsFrameColorSelectButton1Texture:SetTexture(FuiDB.BordersColor.R, FuiDB.BordersColor.G, FuiDB.BordersColor.B, FuiDB.BordersColor.A)
end

function FriskesUI.myColorCallback2(restore)
    local RED2, GREEN2, BLUE2, ALPHA2
    if restore then
        RED2, GREEN2, BLUE2, ALPHA2 = unpack(restore)
    else
        RED2, GREEN2, BLUE2 = ColorPickerFrame:GetColorRGB()
        ALPHA2 = 1 - OpacitySliderFrame:GetValue()
    end
    FuiDB.TexturesColor.R, FuiDB.TexturesColor.G, FuiDB.TexturesColor.B, FuiDB.TexturesColor.A = RED2, GREEN2, BLUE2, ALPHA2
    SettingsFrameColorSelectButton2Texture:SetTexture(FuiDB.TexturesColor.R, FuiDB.TexturesColor.G, FuiDB.TexturesColor.B, FuiDB.TexturesColor.A)
end
