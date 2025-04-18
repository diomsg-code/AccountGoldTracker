local addonName, GCT = ...

local L = GCT.localization
local Utils = GCT.utils
local Options = GCT.options

----------------------
--- Local funtions ---
----------------------

local function SaveBalance()
    local realm, char = Utils:GetCharacterInfo()
    local today = Utils:GetToday()
    local currentGold = Utils:GetGold()

    GCT.data.balance["Warband"][today] = GCT.data.balance["Warband"][today] or {}
    GCT.data.balance[realm][char][today] = GCT.data.balance[realm][char][today] or {}

    GCT.data.balance[realm][char][today]["gold"] = currentGold

    for _, currencies in pairs(GCT.CHARACTER_CURRENCIES) do
        for _, currencyID in ipairs(currencies) do
            local key = "c-" .. tostring(currencyID)
            local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)

            if info then
                 GCT.data.balance[realm][char][today][key] = info.quantity
                 --Utils:PrintDebug(tostring(key) .. " - " .. tostring(info.quantity))
            end
        end
    end

    for _, currencies in pairs(GCT.WARBAND_CURRENCIES) do
        for _, currencyID in ipairs(currencies) do
            local key = "w-" .. tostring(currencyID)
            local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)

            if info then
                 GCT.data.balance["Warband"][today][key] = info.quantity
                 --Utils:PrintDebug(tostring(key) .. " - " .. tostring(info.quantity))
            end
        end
    end

    Utils:PrintDebug("Gold and curreny balance saved.")
end

local function SlashCommand(msg, editbox)
    if not msg or msg:trim() == "" then
        Settings.OpenToCategory("Gold & Currency Tracker")
    elseif msg:trim() == "overview" then
        GCT:ShowGoldCurrencyOverview()
	else
        Utils:PrintDebug("These arguments are not accepted.")
	end
end

--------------
--- Frames ---
--------------

local goldCurrencyTrackerFrame = CreateFrame("Frame", "GoldCurrencyTracker")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("GoldCurrencyTracker", {
    type     = "launcher",
    text     = "GoldTracker",
    icon     = "Interface\\AddOns\\GoldCurrencyTracker\\media\\iconRound.blp",
    OnClick  = function(self, button)
        if button == "LeftButton" then
            if GCT:IsShownGoldCurrencyOverview() then
                GCT:HideGoldCurrencyOverview()
            else
                GCT:ShowGoldCurrencyOverview()
            end
        elseif button == "RightButton" then
            Settings.OpenToCategory("Gold & Currency Tracker")
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Gold & Currency Tracker")
        tooltip:AddLine("Linksklick zum Öffnen und Rechtsklick für die Einstellungen", 1,1,1)
    end,
})

local zone = {}
zone.hide = false
zone.minimapPos = 225

local LDBIcon = LibStub("LibDBIcon-1.0")
LDBIcon:Register("GoldCurrencyTracker", LDB, zone)

---------------------
--- Main funtions ---
---------------------

function goldCurrencyTrackerFrame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function goldCurrencyTrackerFrame:ADDON_LOADED(_, addOnName)
    if addOnName == addonName then
        Utils:InitDatabase()
        Utils:BuildDateIndex(GCT.data.balance)

        Options:LoadOptions()

        Utils:PrintDebug("Addon fully loaded.")
    end
end

function goldCurrencyTrackerFrame:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
    Utils:PrintDebug("Event 'PLAYER_ENTERING_WORLD' fired. Payload: isInitialLogin=" .. tostring(isInitialLogin) .. ", isReloadingUi=" .. tostring(isReloadingUi))

    if (isInitialLogin or isReloadingUi) then
        C_Timer.After(10, function()
            SaveBalance()
        end)

        if GCT.data.options["QKywRlN7-open-on-login"]then
            GCT:ShowGoldCurrencyOverview()
        end
    end
end

function goldCurrencyTrackerFrame:PLAYER_MONEY(...)
    GCT.util:PrintDebug("Event 'PLAYER_MONEY' fired. No payload.")

    SaveBalance()
end

function goldCurrencyTrackerFrame:CURRENCY_DISPLAY_UPDATE(...)
    Utils:PrintDebug("Event 'CURRENCY_DISPLAY_UPDATE' fired. No payload.")

    SaveBalance()
end

goldCurrencyTrackerFrame:RegisterEvent("ADDON_LOADED")
goldCurrencyTrackerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
goldCurrencyTrackerFrame:RegisterEvent("PLAYER_MONEY")
goldCurrencyTrackerFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
goldCurrencyTrackerFrame:SetScript("OnEvent", goldCurrencyTrackerFrame.OnEvent)

SLASH_GoldCurrencyTracker1, SLASH_GoldCurrencyTracker2 = '/gct', '/GoldCurrencyTracker'

SlashCmdList["GoldCurrencyTracker"] = SlashCommand