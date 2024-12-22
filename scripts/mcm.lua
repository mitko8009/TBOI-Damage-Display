local function addSpace(catergory)
    ModConfigMenu.AddSpace(DamageDisplay.MOD_NAME, catergory)
end

local function getTableIndex(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return i
        end
    end
    return 0
end

local function getNumberRowInList(start, finish, step)
    local list = {}
    for i = start, finish, step do
        table.insert(list, i)
    end
    return list
end

local screenWidth = Isaac.GetScreenWidth()
local screenHeight = Isaac.GetScreenHeight()

local mc_fontalpha = getNumberRowInList(0.1, 1, 0.1)
local mc_width = getNumberRowInList(0, screenWidth, 5)
local mc_height = getNumberRowInList(0, screenHeight, 5)
local mc_format = {"Long", "Regular", "Only Number"}

------------
--- Info ---
------------

ModConfigMenu.UpdateCategory(DamageDisplay.MOD_NAME, {
    Info = "View settings for " .. DamageDisplay.MOD_NAME .. "."
})

ModConfigMenu.AddTitle(DamageDisplay.MOD_NAME, "Info", DamageDisplay.MOD_NAME)
ModConfigMenu.AddText(DamageDisplay.MOD_NAME, "Info", "Version: " .. DamageDisplay.VERSION)
addSpace("Info")
ModConfigMenu.AddTitle(DamageDisplay.MOD_NAME, "Info", "Developer")
ModConfigMenu.AddText(DamageDisplay.MOD_NAME, "Info", "Author: " .. DamageDisplay.AUTHOR)
ModConfigMenu.AddText(DamageDisplay.MOD_NAME, "Info", "Follow me on Instagram: " .. DamageDisplay.SOCIAL)
addSpace("Info")
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Info",{
    Type = ModConfigMenu.OptionType.TEXT,
    Display = function()
        return "Total Damage Dealt: " .. DamageDisplay.totalDamageDealt
    end,
})
----------------
--- Settings ---
----------------

ModConfigMenu.AddTitle(DamageDisplay.MOD_NAME, "Settings", "Mod Settings")

ModConfigMenu.AddText(DamageDisplay.MOD_NAME, "Settings", "HUD Settings")
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- Enable or disable the text that shows the total damage dealt.
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings_DamageDisplay.enableText
    end,
    Display = function()
        return "Show Text: " .. (settings_DamageDisplay.enableText and "Enabled" or "Disabled")
    end,
    OnChange = function(currentValue)
        settings_DamageDisplay.enableText = currentValue
    end,
    Info = {
        "Enable or disable the text that shows the total damage dealt."
    }
})
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- The alpha value of the font.
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_fontalpha, settings_DamageDisplay.fontalpha)
    end,
    Minimum = 0.1,
    Maximum = #mc_fontalpha,
    Display = function()
        return "Font Alpha: " .. settings_DamageDisplay.fontalpha
    end,
    OnChange = function(n)
        settings_DamageDisplay.fontalpha = mc_fontalpha[n]
    end,
    Info = {
        "The alpha value of the font."
    }
})
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- The position of the text.
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_width, settings_DamageDisplay.coords.X)
    end,
    Minimum = 1,
    Maximum = #mc_width,
    Display = function()
        return "X Position: " .. settings_DamageDisplay.coords.X
    end,
    OnChange = function(n)
        settings_DamageDisplay.coords.X = mc_width[n]
    end,
    Info = {
        "The horizontal position of the text."
    }
})
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- The position of the text.
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_height, settings_DamageDisplay.coords.Y)
    end,
    Minimum = 1,
    Maximum = #mc_height,
    Display = function()
        return "Y Position: " .. settings_DamageDisplay.coords.Y
    end,
    OnChange = function(n)
        settings_DamageDisplay.coords.Y = mc_height[n]
    end,
    Info = {
        "The vertical position of the text."
    }
})
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- Flip the position of the text.
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings_DamageDisplay.flipPosition
    end,
    Display = function()
        return "Flip Position: " .. (settings_DamageDisplay.flipPosition and "Enabled" or "Disabled")
    end,
    OnChange = function(currentValue)
        settings_DamageDisplay.flipPosition = currentValue
    end,
    Info = {
        "Flip the position of the text."
    }
})
ModConfigMenu.AddSetting(DamageDisplay.MOD_NAME, "Settings", -- The format of the text.
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return settings_DamageDisplay.format
    end,
    Minimum = 1,
    Maximum = #mc_format,
    Display = function()
        local formatIndex = math.max(1, math.min(#mc_format, settings_DamageDisplay.format))
        return "Format: " .. mc_format[formatIndex] .. " (" .. formatIndex .. ")"
    end,
    OnChange = function(n)
        settings_DamageDisplay.format = n
    end,
    Info = {
        "The format of the text."
    }
})
