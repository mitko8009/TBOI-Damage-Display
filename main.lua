-- Register the mod
DamageDisplay = RegisterMod("Damage Display", 1)
local mod = DamageDisplay
DamageDisplay.MOD_NAME = "Damage Display"
DamageDisplay.VERSION = "1.0"
DamageDisplay.AUTHOR = "mitko8009"
DamageDisplay.SOCIAL = "@mitko8009_"

-- Load the json library
local json = require("json")

--------------
--- Config ---
--------------

settings_DamageDisplay = {
	-- HUD Settings
	enableText = true,
	fontalpha = 0.4,
	coords = Vector(10, 10), -- (!) The X is the horizontal position, (!) the Y is the vertical distance from the bottom of the screen
	flipPosition = false,
	format = 1
}

-----------------
--- Main Code ---
-----------------

if ModConfigMenu then
	require("scripts.mcm")
end

mod.font = Font()
mod.font:Load("font/luaminioutlined.fnt")

mod.totalDamageDealt = 0

function mod:GetTotalDamageDealt()
	return self.totalDamageDealt
end

function mod:SetTotalDamageDealt(value)
	self.totalDamageDealt = value
end

function mod:onRender(shaderName)
	local valueOutput = tostring(math.ceil(mod:GetTotalDamageDealt()))
	if settings_DamageDisplay.format == 1 then
		valueOutput = "Total Damage Dealt: " .. valueOutput
	elseif settings_DamageDisplay.format == 2 then
		valueOutput = "Damage Dealt: " .. valueOutput
	elseif settings_DamageDisplay.format == 3 then
		valueOutput = valueOutput
	end
	
	if settings_DamageDisplay.enableText then
		local screenHeight = Isaac.GetScreenHeight()
		local screenWidth = Isaac.GetScreenWidth()
		local hudOffset = Options.HUDOffset
		local hudOffsetVector = Vector(hudOffset * 10 * (settings_DamageDisplay.flipPosition and -1 or 1), hudOffset * 10 * -1)

		local basePosition = Vector(settings_DamageDisplay.coords.X, screenHeight - settings_DamageDisplay.coords.Y - 10)
		if settings_DamageDisplay.flipPosition then
			basePosition = Vector(screenWidth - settings_DamageDisplay.coords.X - mod.font:GetStringWidth(valueOutput), screenHeight - settings_DamageDisplay.coords.Y - 10)
		end

		local textCoords = basePosition + Game().ScreenShakeOffset + hudOffsetVector
		mod.font:DrawString(valueOutput, textCoords.X, textCoords.Y, KColor(1, 1, 1, settings_DamageDisplay.fontalpha), 0, true)
	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)

function mod:onDamage(entity, amount, flags, source, countdown)
	if entity:IsEnemy() and entity:IsVulnerableEnemy() then
		local damageToAdd = math.min(amount, entity.HitPoints)
		mod:SetTotalDamageDealt(mod:GetTotalDamageDealt() + damageToAdd)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onDamage)

function mod:restart()
	mod:SetTotalDamageDealt(0)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.restart)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.restart)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.restart)
