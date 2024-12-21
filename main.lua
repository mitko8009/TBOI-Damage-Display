-- Register the mod
DamageDisplay = RegisterMod("Damage Display", 1)
local mod = DamageDisplay

-- Load the json library
local json = require("json")

--------------
--- Config ---
--------------

settings_DamageDisplay = {
    -- HUD Settings
    enableText = true,
    fontalpha = 2.9,
    coords = Vector(0, 0)
}

-----------------
--- Main Code ---
-----------------

mod.font = Font()
mod.font:Load("font/luaminioutlined.fnt")

function mod:onRender(shaderName)
    local valueOutput = "Test Text"
    
    if settings_DamageDisplay.enableText then
        mod:updatePosition()
        local textCoords = settings_DamageDisplay.coords + Game().ScreenShakeOffset
        valueOutput = tostring(textCoords.X) .. ", " .. tostring(textCoords.Y)
        mod.font:DrawString(valueOutput, textCoords.X, textCoords.Y, KColor(1, 1, 1, 0.5), 0, true)
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)

function mod:updatePosition() -- isaac-planetarium-chance | https://github.com/Sectimus/isaac-planetarium-chance?tab=readme-ov-file
	local TrueCoopShift = false
	local BombShift = false
	local PoopShift = false
	local RedHeartShift = false
	local SoulHeartShift = false
	local DualityShift = false

	local ShiftCount = 0

	settings_DamageDisplay.coords = Vector(0, 168)

	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()

		if player:GetBabySkin() == -1 then
			if i > 0 and player.Parent == nil and playerType == player:GetMainTwin():GetPlayerType() and not TrueCoopShift then
				TrueCoopShift = true
			end

			if playerType ~= PlayerType.PLAYER_BLUEBABY_B and not BombShift then BombShift = true end
		end
		if playerType == PlayerType.PLAYER_BLUEBABY_B and not PoopShift then PoopShift = true end
		if playerType == PlayerType.PLAYER_BETHANY_B and not RedHeartShift then RedHeartShift = true end
		if playerType == PlayerType.PLAYER_BETHANY and not SoulHeartShift then SoulHeartShift = true end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) and not DualityShift then DualityShift = true end
	end

	if BombShift then ShiftCount = ShiftCount + 1 end
	if PoopShift then ShiftCount = ShiftCount + 1 end
	if RedHeartShift then ShiftCount = ShiftCount + 1 end
	if SoulHeartShift then ShiftCount = ShiftCount + 1 end
	ShiftCount = ShiftCount - 1
	if ShiftCount > 0 then settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, (11 * ShiftCount) - 2) end

	if Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_JACOB then
		settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, 30)
	elseif TrueCoopShift then
		settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, 16)
		if DualityShift then
			settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, -2) -- I hate this
		end
	end
	if DualityShift then
		settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, -12)
	end

	if Game().Difficulty == Difficulty.DIFFICULTY_HARD or Game():IsGreedMode() or not CanRunUnlockAchievements() then
		settings_DamageDisplay.coords = settings_DamageDisplay.coords + Vector(0, 16)
	end

	settings_DamageDisplay.coords = settings_DamageDisplay.coords + (Options.HUDOffset * Vector(20, 12))
end



-- function mod:DisplayText()
--     local basePos = Vector(80, 270) -- Base position on the bottom of the screen

--     -- Get the HUD offset
--     local hudOffset = Options.HUDOffset
--     local hudOffsetVector = Vector(0, hudOffset * 10)

--     -- Adjust the position with the HUD offset
--     local pos = basePos - hudOffsetVector

--     -- Create a text object
--     Isaac.RenderText("Damage: " .. tostring(damage), pos.X, pos.Y, 1, 1, 1, 1)
-- end



-- -- Add a callback to render the text every frame
-- mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.DisplayText)
