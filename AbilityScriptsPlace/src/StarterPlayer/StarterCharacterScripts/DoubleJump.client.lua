-- About: A double jump script.
-- Developer/Creator: minhnormal
-- 3/15/2021

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local HUMANOID_FREE_FALLING_ENUM = Enum.HumanoidStateType.Freefall
local HUMANOID_JUMPING_ENUM = Enum.HumanoidStateType.Jumping
local HUMANOID_DEAD_ENUM = Enum.HumanoidStateType.Dead
local HUMANOID_LANDED_ENUM = Enum.HumanoidStateType.Landed

local TIME_BETWEEN_JUMPS = 0.2
-- Modifying from the article, we have these constants. :D
local POWER_OF_FIRST_JUMP = 55
local POWER_OF_SECOND_JUMP = 26

local localPlayer = Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local playerHumanoid = playerCharacter:WaitForChild("Humanoid")

playerHumanoid.JumpPower = POWER_OF_FIRST_JUMP

--[[ "When a player jumps, the state of their humanoid is set
    to Jumping, which applies an upwards force to the character model.
    A brief moment later, the humanoid is set to the Freefall state,
    which lets physics take over and pull the character back to the ground
    with gravity...

    A simple way to implement double jump is to force the character
    back into Jumping state" (Article on Developer Hub).
]]

-- States
local playerCanDoubleJump = false
local playerHadDoubleJumped = false

-- Let's start with the humanoid state changed event.

local function onStateChanged(_, newState)
    local playerHasLanded = newState == HUMANOID_LANDED_ENUM
    local playerIsReadyForDoubleJump = newState == HUMANOID_FREE_FALLING_ENUM

    if playerIsReadyForDoubleJump then
        wait(TIME_BETWEEN_JUMPS)

        --[[
            If playerHadDoubleJumped then player will not
            be able to jump.

            If player is free falling we would then consider
            this.

            This is more as a bug and glitch preventing
            mechanism.

            An add-on from the article.
        ]]
        playerCanDoubleJump = not playerHadDoubleJumped

    elseif playerHasLanded then
        -- Reset our double-jumping states
        playerCanDoubleJump = false
        playerHadDoubleJumped = false

        humanoid.JumpPower = POWER_OF_FIRST_JUMP
    end
end

playerHumanoid.StateChanged:Connect(onStateChanged)

--[[
    Look here, to make it easier on themselves, Roblox
    had already made a JumpRequest event property.
]]

local function onJumpRequest()
    if not playerHumanoid then return end
    
    --[[ We should not check if the player health is zero.
        There are some bugs in games that I see where
        a player is dead but they are still double jumping.
    ]]
    
    local playerIsDead = playerHumanoid:GetState() == HUMANOID_DEAD_ENUM
    if playerIsDead then return end

    if not playerCanDoubleJump then return end

    playerHadDoubleJumped = true
    humanoid.JumpPower = POWER_OF_SECOND_JUMP
    playerHumanoid:ChangeState(HUMANOID_JUMPING_ENUM)
end

UserInputService.JumpRequest:Connect(onJumpRequest)
