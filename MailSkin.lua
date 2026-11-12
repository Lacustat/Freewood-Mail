-- Freewood-Mail: Postfach-Design "Legion der Affen".
-- Ein fertiger Holzrahmen (feste Form 3:2) mit Lederhintergrund, die Reiter als Dropdown oben im Rahmen, Pergament hinter dem
-- Lesefenster, farbige Zeilen (gold = geoeffnet, rot = Maus darueber), roter Schliessen-Knopf im Ring oben rechts.
-- Wahl in den Einstellungen: "Postfach-Design" = Automatisch (folgt dem Gesamtdesign Legion der Affen) / Normal / Legion der Affen.
-- Alles ist umkehrbar: Apply() stellt das normale Fenster wieder her. Bilder: Media/Legion/*.tga

local FW = _G.Freewood
local Mail = FW and FW.Mail
if not FW or not Mail then return end

local UI = FW.UI
local S = {}
Mail.Skin = S

local PATH = "Interface\\AddOns\\Freewood-Mail\\Media\\Legion\\"

-- Fenster in Einheiten: Bild 1536x1024 wird auf 1100x733 gebracht
local WL = 1100
local KS = WL / 1536
local HL = 1024 * KS
-- freie Innenflaeche im Rahmenbild (Pixel): links 126, rechts 1407, oben 218, unten 893
local IN_L, IN_T = 126 * KS, 218 * KS
local IN_R, IN_B = WL - 1407 * KS, HL - 893 * KS
-- Ring fuer den Schliessen-Knopf (Pixel, Mitte)
local RING_X, RING_Y = 1443 * KS, 153 * KS

local parts          -- unsere Zusatzteile
local active = false

function S.Wanted()
    local mode = Mail.db and Mail.db.settings and Mail.db.settings.skin or "auto"
    if mode == "legion" then return true end
    if mode == "normal" then return false end
    return FW.Design and FW.Design.IsTheme and FW.Design.IsTheme("legion") and true or false
end

local function Show(obj, on)
    if not obj then return end
    if on then obj:Show() else obj:Hide() end
end

local function BorderShown(frame, on)
    local b = frame and frame.fwBorder
    if not b then return end
    for _, k in ipairs({ "top", "bottom", "left", "right" }) do Show(b[k], on) end
end

local function Build(ui)
    local w = ui.window
    parts = {}
    -- Leder: nur in der Innenflaeche, Hoehe passend beschnitten (kein Verzerren)
    local leather = w:CreateTexture(nil, "BACKGROUND")
    leather:SetTexture(PATH .. "leather.tga")
    leather:SetPoint("TOPLEFT", w, "TOPLEFT", IN_L, -IN_T)
    leather:SetPoint("BOTTOMRIGHT", w, "BOTTOMRIGHT", -IN_R, IN_B)
    local iw, ih = WL - IN_L - IN_R, HL - IN_T - IN_B
    leather:SetTexCoord(0, 1, 0, math.min(1, ih / iw))
    parts.leather = leather
    -- Rahmen ueber dem Leder
    local art = w:CreateTexture(nil, "ARTWORK")
    art:SetTexture(PATH .. "frame.tga")
    art:SetAllPoints(w)
    art:SetTexCoord(0, 0.75, 0, 1)        -- Bild 1536x1024 links in 2048x1024
    parts.art = art

    -- Reiter als Dropdown oben im Rahmen
    local dd
    dd = UI.CreateDropdown(w, 250, 30, {
        getOptions = function()
            local list = {}
            for _, def in ipairs(ui.tabDefs) do list[#list + 1] = { value = def.id, text = FW.L[def.label] or def.label } end
            return list
        end,
        textOf = function(v)
            for _, def in ipairs(ui.tabDefs) do
                if def.id == v then return FW.L[def.label] or def.label end
            end
            return tostring(v)
        end,
        onChange = function(v) if v then ui.select(v) end end,
    })
    dd:SetValue(ui.current())
    parts.dropdown = dd

    -- Schliessen-Knopf im roten Ring
    local close = CreateFrame("Button", nil, w)
    close:SetSize(52, 52)
    close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
    close:SetScript("OnClick", function()
        local fn = ui.close and ui.close.GetScript and ui.close:GetScript("OnClick")
        if fn then fn(ui.close) end
    end)
    close:SetFrameLevel((w:GetFrameLevel() or 1) + 8)
    parts.close = close

    -- Pergament hinter dem Lesefenster
    local d = ui.panes.inbox and ui.panes.inbox.detail
    if d then
        local pg = d:CreateTexture(nil, "BACKGROUND")
        pg:SetTexture(PATH .. "parchment.tga")
        pg:SetTexCoord(0, 1, 0, 0.75)
        pg:SetPoint("TOPLEFT", d, "TOPLEFT", -10, 8)
        pg:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", 14, -2)
        parts.parchment = pg
    end
end

local function Layout(on)
    local ui = Mail.ui
    if not ui then return end
    local w = ui.window
    if on then
        w:SetSize(WL, HL)
        local screen = UIParent and UIParent.GetHeight and UIParent:GetHeight() or 0
        if screen > 0 then w:SetScale(math.min(1, screen * 0.92 / HL)) end
        ui.title:Hide()
        ui.divider:Hide()
        ui.close:Hide()
        for _, b in pairs(ui.tabs) do b:Hide() end
        ui.archive:ClearAllPoints()
        ui.archive:SetPoint("TOPRIGHT", w, "TOPRIGHT", -IN_R - 10, -IN_T - 6)
        parts.dropdown:ClearAllPoints()
        parts.dropdown:SetPoint("TOPLEFT", w, "TOPLEFT", IN_L + 12, -IN_T - 6)
        parts.dropdown:SetValue(ui.current())
        parts.close:ClearAllPoints()
        parts.close:SetPoint("CENTER", w, "TOPLEFT", RING_X, -RING_Y)
        ui.content:ClearAllPoints()
        ui.content:SetPoint("TOPLEFT", w, "TOPLEFT", IN_L + 14, -IN_T - 46)
        ui.content:SetPoint("BOTTOMRIGHT", w, "BOTTOMRIGHT", -IN_R - 14, IN_B + 28)
        ui.footer:ClearAllPoints()
        ui.footer:SetPoint("BOTTOMLEFT", w, "BOTTOMLEFT", IN_L + 14, IN_B + 8)
        ui.footer:SetPoint("BOTTOMRIGHT", w, "BOTTOMRIGHT", -IN_R - 14, IN_B + 8)
    else
        w:SetSize(ui.W, ui.H)
        w:SetScale(1)
        ui.title:Show()
        ui.divider:Show()
        ui.close:Show()
        local prev
        for _, def in ipairs(ui.tabDefs) do
            local b = ui.tabs[def.id]
            b:Show()
            b:ClearAllPoints()
            if prev then b:SetPoint("LEFT", prev, "RIGHT", 4, 0) else b:SetPoint("TOPLEFT", w, "TOPLEFT", 12, -44) end
            prev = b
        end
        ui.archive:ClearAllPoints()
        ui.archive:SetPoint("TOPRIGHT", w, "TOPRIGHT", -42, -10)
        ui.content:ClearAllPoints()
        ui.content:SetPoint("TOPLEFT", w, "TOPLEFT", 16, -86)
        ui.content:SetPoint("BOTTOMRIGHT", w, "BOTTOMRIGHT", -16, 32)
        ui.footer:ClearAllPoints()
        ui.footer:SetPoint("BOTTOMLEFT", w, "BOTTOMLEFT", 16, 10)
        ui.footer:SetPoint("BOTTOMRIGHT", w, "BOTTOMRIGHT", -16, 10)
    end
    Show(w.bg, not on)
    BorderShown(w, not on)
    Show(parts.leather, on)
    Show(parts.art, on)
    Show(parts.dropdown, on)
    Show(parts.close, on)
    Show(parts.parchment, on)
    local d = ui.panes.inbox and ui.panes.inbox.detail
    if d then
        Show(d.bg, not on)
        BorderShown(d, not on)
    end
end

function S.Apply()
    local ui = Mail.ui
    if not ui or not ui.window then return end
    if not parts then Build(ui) end
    local on = S.Wanted()
    -- Holzknoepfe/Rollbalken im Postfach: Legion erzwungen = immer, Normal = nie, Automatisch = folgt dem Gesamtdesign
    local mode = Mail.db and Mail.db.settings and Mail.db.settings.skin or "auto"
    ui.window.fwPlankMode = (mode == "legion") and "on" or (mode == "normal") and "off" or nil
    if UI.LegionSkin then UI.LegionSkin.Refresh() end
    if on == active and ui.window:GetWidth() == (on and WL or ui.W) then return end
    active = on
    pcall(Layout, on)
    if ui.window:IsShown() and ui.panes[ui.current()] and ui.panes[ui.current()].Refresh then
        pcall(ui.panes[ui.current()].Refresh)
    end
end

function S.OnBuilt()
    pcall(S.Apply)
end

function S.OnTab(id)
    if parts and parts.dropdown and active then parts.dropdown:SetValue(id) end
end

-- Zeilen: rote Leiste bei Mausberuehrung, goldene fuer den geoeffneten Brief (nur im Legion-Design)
function S.StyleRow(row)
    local gold = row:CreateTexture(nil, "BORDER")
    gold:SetTexture(PATH .. "rows.tga")
    gold:SetTexCoord(0, 1, 0, 0.5)
    gold:SetAllPoints(row)
    gold:SetAlpha(0.5)
    gold:Hide()
    local red = row:CreateTexture(nil, "BORDER")
    red:SetTexture(PATH .. "rows.tga")
    red:SetTexCoord(0, 1, 0.5, 1)
    red:SetAllPoints(row)
    red:SetAlpha(0.5)
    red:Hide()
    local viewed = false
    function row.fwSkinState(v)
        viewed = v and true or false
        Show(gold, active and viewed)
        if not active then red:Hide() end
    end
    row:HookScript("OnEnter", function() if active and not viewed then red:Show() end end)
    row:HookScript("OnLeave", function() red:Hide() end)
end

FW:On("DESIGN_CHANGED", function() pcall(S.Apply) end, S)
