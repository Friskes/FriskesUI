function RunHideRightPanels()
  -- Отключение отображения панелей заклинаний справа
  local Core = CreateFrame("Frame")
  local bars = { MultiBarRight, MultiBarLeft }
  local zones, buttons = {}, {}

  local function collectButtons()
    wipe(buttons)
    for _, bar in ipairs(bars) do
      if bar and bar:GetName() then
        for i = 1, 12 do
          local b = _G[bar:GetName() .. "Button" .. i]
          if b then table.insert(buttons, b) end
        end
      end
    end
  end

  local function hideForeignOverlays()
    local success, kids = pcall(UIParent.GetChildren, UIParent)
    if not success or not kids then return end

    for _, child in ipairs(kids) do
      if child and type(child.IsShown) == "function" and child:IsShown() then
        local success2, p = pcall(child.GetParent, child)
        if success2 and p then
          for _, b in ipairs(buttons) do
            if p == b then
              pcall(child.Hide, child)
              break
            end
          end
        end
      end
    end
  end

  local function anyHover()
    local f = GetMouseFocus()
    while f do
      for _, bar in ipairs(bars) do
        if f == bar then return true end
      end
      for _, b in ipairs(buttons) do
        if f == b then return true end
      end
      f = f:GetParent()
    end
    return false
  end

  local function showBars()
    Core:SetScript("OnUpdate", nil); Core.hiding = nil
    for _, bar in ipairs(bars) do
      if bar then
        bar:SetFrameStrata("MEDIUM")
        bar:SetFrameLevel(10)
        bar:Show()
        bar:SetAlpha(1)
      end
    end
  end

  local function scheduleHide()
    if Core.hiding then return end
    Core.hiding = true
    local t, dur = 1.1, 1.1
    Core:SetScript("OnUpdate", function(self, elapsed)
      if anyHover() then
        for _, bar in ipairs(bars) do if bar then bar:SetAlpha(1) end end
        self:SetScript("OnUpdate", nil); self.hiding = nil
        return
      end
      t = t - elapsed
      local a = t > 0 and t / dur or 0
      for _, bar in ipairs(bars) do if bar then bar:SetAlpha(a) end end
      if t <= 0 then
        for _, bar in ipairs(bars) do if bar then bar:Hide() end end
        hideForeignOverlays()
        self:SetScript("OnUpdate", nil); self.hiding = nil
      end
    end)
  end

  local function makeHoverZone(anchorTo)
    if not anchorTo then return end
    local z = CreateFrame("Frame", nil, UIParent)
    z:SetPoint("TOPLEFT", anchorTo, -8, 8)
    z:SetPoint("BOTTOMRIGHT", anchorTo, 8, -8)
    z:SetFrameStrata("BACKGROUND")   -- ниже баров
    z:SetFrameLevel(0)
    z:EnableMouse(true)
    z:SetScript("OnEnter", showBars)
    z:SetScript("OnLeave", scheduleHide)
    table.insert(zones, z)
  end

  Core:RegisterEvent("PLAYER_ENTERING_WORLD")
  Core:SetScript("OnEvent", function()
    collectButtons()
    for _, bar in ipairs(bars) do
      if bar then
        bar:SetFrameStrata("MEDIUM")
        bar:SetFrameLevel(10)
        bar:SetAlpha(0)
        bar:Hide()
        -- чтобы ховеры кнопок будили бары и давали tooltips/drag
        for i = 1, 12 do
          local b = _G[bar:GetName() .. "Button" .. i]
          if b then
            b:HookScript("OnEnter", showBars)
            b:HookScript("OnLeave", scheduleHide)
          end
        end
      end
      makeHoverZone(bar)
    end
  end)

  -- прятать вспышки при нажатиях, если бары скрыты
  local function stopKeySpark()
    if bars[1] and not bars[1]:IsShown() then hideForeignOverlays() end
  end
  if ActionButtonDown then hooksecurefunc("ActionButtonDown", stopKeySpark) end
  if MultiActionButtonDown then hooksecurefunc("MultiActionButtonDown", stopKeySpark) end
end
