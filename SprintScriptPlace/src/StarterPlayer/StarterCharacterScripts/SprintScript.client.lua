-- About: A sprinting script. Very easy
-- Developer: Minhnormal
-- Date started 3/13/2021

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local localPlayer = Players.LocalPlayer

local SPRINT_ACTION_NAME = "Sprinting"

local SPEED_WHEN_SPRINTING = 20
local SPEED_WHEN_WALKING = 16

local sprintKeybind = {
    Enum.KeyCode.LeftShift
}


local function handleSprinting(_, inputState, _)
    -- Declare the player character again because the player will respawn
    -- and the character will be new

    local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local playerHumanoid = playerCharacter:WaitForChild("Humanoid")

    if inputState == Enum.UserInputState.Begin then
        playerHumanoid.WalkSpeed = SPEED_WHEN_SPRINTING
    elseif inputState == Enum.UserInputState.End then
        playerHumanoid.WalkSpeed = SPEED_WHEN_WALKING
    end
end


local function setupSprinting()
    -- I have made some changes as you can see.
    -- anything you put in sprintKeybind, it will be the sprinting's keybind.
    -- And yes, you can have multiple keybinds.
    ContextActionService:BindAction(SPRINT_ACTION_NAME, handleSprinting, true, table.unpack(sprintKeybind))
end

setupSprinting()
