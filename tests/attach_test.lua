-- Test: Anhaenge mit Luecken, einzeln nehmen, "Alle nehmen" fuer einen Brief (Mail.lua 0.3.0)   texlua tests/attach_test.lua
local clock = 0
_G.GetTime = function() return clock end
local function Obj() return setmetatable({}, { __index = function() return function() end end }) end
_G.CreateFrame = function() return Obj() end
_G.C_Timer = { After = function() end }
local modules = {}
local FW = { L = setmetatable({}, { __index = function(_, k) return k end }), Util = {}, UI = Obj() }
function FW:NewModule(name, def) local m = def or {} m.db = { settings = { cleanup = false }, char = {} } modules[name] = m return m end
function FW:Fire() end
function FW:Print() end
function FW:On() end
function FW:RegisterEvent() end
function FW:RequireAPI() return true end
_G.Freewood = FW
-- Postfach: Brief 1 mit Luecke (Platz 2 leer), Brief 2 mit einem Item
local inbox = {
    { sender = "Pinky Silberrücken", subject = "Beulengras (20)", items = { [1] = { "Beulengras", 2449, 20 }, [3] = { "Silberblatt", 765, 20 }, [16] = { "Erdwurzel", 2449, 5 } } },
    { sender = "Pinky Freewood", subject = "daaaaa", items = { [1] = { "Schultern", 1234, 1 } } },
}
_G.GetInboxNumItems = function() return #inbox, #inbox end
_G.GetInboxHeaderInfo = function(i)
    local m = inbox[i]
    local n = 0 for _ in pairs(m.items) do n = n + 1 end
    return nil, nil, m.sender, m.subject, 0, 0, 30, n > 0 and n or nil, true, false, false, true
end
_G.GetInboxItem = function(i, a)
    local it = inbox[i] and inbox[i].items[a]
    if not it then return nil end
    return it[1], it[2], 133000 + a, it[3], 1
end
local taken = {}
_G.TakeInboxItem = function(i, a) taken[#taken + 1] = i .. ":" .. tostring(a) if inbox[i] then inbox[i].items[a] = nil end end
_G.TakeInboxMoney = function() end
_G.C_Container = { GetContainerNumFreeSlots = function(bag) return bag == 0 and 10 or 0, 0 end }
_G.NUM_BAG_SLOTS = 4
assert(loadfile("Mail.lua"))("Freewood-Mail", {})
local Mail = modules.Mail or FW.Mail
assert(Mail and Mail.ReadAttachments, "Mail geladen")

-- 1) alle Plaetze, auch hinter der Luecke
local list = Mail.ReadInbox()
local m = list[1]
assert(#m.items == 3, "drei Anhaenge trotz Luecke: " .. #m.items)
assert(m.items[1].slot == 1 and m.items[2].slot == 3 and m.items[3].slot == 16, "Platznummern")
assert(m.items[2].name == "Silberblatt")

-- 2) einzeln nehmen: genau dieser Platz
Mail.open = true
local ok = Mail:TakeAttachment(m, 3)
assert(ok and taken[#taken] == "1:3", "Platz 3 einzeln genommen")
list = Mail.ReadInbox()
assert(#list[1].items == 2 and list[1].items[2].slot == 16, "Rest bleibt sichtbar")
local cod = { i = 1, cod = 100, items = list[1].items }
local ok2, why = Mail:TakeAttachment(cod, 1)
assert(not ok2 and why == "codsingle", "Nachnahme nicht einzeln")

-- 3) erstes vorhandenes Item, wenn Platz 1 leer ist
inbox[1].items[1] = nil
list = Mail.ReadInbox()
assert(Mail.FirstSlot(list[1]) == 16, "erster vorhandener Platz")

-- 4) Alle nehmen nur fuer diesen Brief
inbox[1].items[1] = { "Beulengras", 2449, 20 }
inbox[1].items[5] = { "Wilddornrose", 2452, 20 }
list = Mail.ReadInbox()
taken = {}
Mail.driver = Mail.driver or Obj()
assert(Mail:StartTakeMail(list[1]), "gestartet")
for _ = 1, 40 do
    clock = clock + 1
    if Mail.busy ~= "inbox" then break end
    Mail:StepOpen()
end
for _, t in ipairs(taken) do assert(t:sub(1, 2) == "1:", "nur Brief 1: " .. t) end
assert(#taken == 3, "drei Items aus Brief 1 genommen: " .. #taken)
assert(next(inbox[1].items) == nil and inbox[2].items[1], "Brief 1 leer, Brief 2 unberuehrt")
-- 5) viele gleiche Stapel (frueher blieb nach 3 gleichen Zustaenden der Rest liegen)
inbox[1].items = {}
for a = 1, 6 do inbox[1].items[a] = { "Silberblatt", 765, 20 } end
list = Mail.ReadInbox()
taken = {}
Mail.busy = nil
assert(Mail:StartTakeMail(list[1]), "gestartet (gleiche Stapel)")
for _ = 1, 80 do
    clock = clock + 1
    if Mail.busy ~= "inbox" then break end
    Mail:StepOpen()
end
assert(#taken == 6 and next(inbox[1].items) == nil, "alle 6 gleichen Stapel genommen: " .. #taken)
print("attach_test OK")
