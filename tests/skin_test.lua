-- Test Postfach-Design Legion: Wahl (auto/normal/legion), Fenstergroesse, Umschalten hin und zurueck (texlua tests/skin_test.lua)
local fails, n = 0, 0
local function eq(a, b, m) n = n + 1; if a ~= b then fails = fails + 1; print("FEHLER " .. m, a, b) end end

local function Obj()
    local o = { shown = true, w = 0, h = 0, scripts = {} }
    return setmetatable(o, { __index = function(t, k)
        if k == "Show" then return function(self) self.shown = true end
        elseif k == "Hide" then return function(self) self.shown = false end
        elseif k == "IsShown" then return function(self) return self.shown end
        elseif k == "SetSize" then return function(self, w, h) self.w, self.h = w, h end
        elseif k == "GetWidth" then return function(self) return self.w end
        elseif k == "SetScale" then return function(self, s) self.scale = s end
        elseif k == "SetScript" then return function(self, e, f) self.scripts[e] = f end
        elseif k == "GetScript" then return function(self, e) return self.scripts[e] end
        elseif k == "HookScript" then return function(self, e, f) self.scripts["hook" .. e] = f end
        elseif k == "CreateTexture" or k == "CreateFontString" then return function() return Obj() end
        elseif k == "GetFrameLevel" then return function() return 1 end
        elseif k == "SetValue" then return function(self, v) self.value = v end
        elseif type(k) == "string" and (k:find("^Set") or k:find("^Clear") or k:find("^Get")) then return function() end
        end
        return nil
    end })
end

_G.CreateFrame = function() return Obj() end
_G.UIParent = Obj(); UIParent.GetHeight = function() return 1080 end
local handlers = {}
local theme = "default"
local FW = { L = setmetatable({}, { __index = function(_, k) return k end }),
    On = function(_, e, f) handlers[e] = f end,
    Design = { IsTheme = function(name) return theme == name end },
    UI = { CreateDropdown = function() return Obj() end, CreateLabel = function() return Obj() end } }
_G.Freewood = FW
local Mail = { db = { settings = { skin = "auto" } } }
FW.Mail = Mail
assert(loadfile("MailSkin.lua"))()
local S = Mail.Skin

eq(S.Wanted(), false, "auto, anderes Design: normal")
theme = "legion"
eq(S.Wanted(), true, "auto, Legion: an")
Mail.db.settings.skin = "normal"
eq(S.Wanted(), false, "normal bleibt normal auch bei Legion")
Mail.db.settings.skin = "legion"; theme = "default"
eq(S.Wanted(), true, "legion erzwungen")

-- Fenster
local function Panel() local p = Obj(); p.bg = Obj(); p.fwBorder = { top = Obj(), bottom = Obj(), left = Obj(), right = Obj() }; return p end
local w = Panel(); w.w, w.h = 660, 560
local d = Panel()
local pane = { detail = d, Refresh = function() end }
Mail.ui = { window = w, title = Obj(), divider = Obj(), close = Obj(), archive = Obj(), tabs = { inbox = Obj(), send = Obj() },
    content = Obj(), footer = Obj(), panes = { inbox = pane }, W = 660, H = 560,
    tabDefs = { { id = "inbox", label = "A" }, { id = "send", label = "B" } },
    select = function() end, current = function() return "inbox" end }
S.OnBuilt()
eq(w.w, 1100, "Legion: Breite 1100")
eq(math.floor(w.h), 733, "Legion: Hoehe 733")
eq(w.bg.shown, false, "Legion: normaler Grund aus")
eq(w.fwBorder.top.shown, false, "Legion: Rand aus")
eq(d.bg.shown, false, "Lesefenster ohne Grund (Pergament)")
eq(Mail.ui.tabs.inbox.shown, false, "Reiterknoepfe aus")
eq(Mail.ui.title.shown, false, "Titel aus")

-- zurueck
Mail.db.settings.skin = "normal"
S.Apply()
eq(w.w, 660, "normal: Breite 660")
eq(w.h, 560, "normal: Hoehe 560")
eq(w.bg.shown, true, "normal: Grund an")
eq(Mail.ui.tabs.inbox.shown, true, "normal: Reiterknoepfe an")
eq(d.bg.shown, true, "normal: Lesefenster mit Grund")

-- Design folgt
Mail.db.settings.skin = "auto"; theme = "legion"
handlers.DESIGN_CHANGED()
eq(w.w, 1100, "auto folgt Legion")
theme = "default"
handlers.DESIGN_CHANGED()
eq(w.w, 660, "auto zurueck")

-- Zeilen
local row = Obj(); S.StyleRow(row)
eq(type(row.fwSkinState), "function", "Zeile hat Zustand")
row.fwSkinState(true)
theme = "legion"; handlers.DESIGN_CHANGED()
print(string.format("skin_test: %d Pruefungen, %d Fehler", n, fails))
os.exit(fails == 0 and 0 or 1)
