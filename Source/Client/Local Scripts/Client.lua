if not game.Loaded then
	game.Loaded:Wait()
end

--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local character = script.Parent

local modules = script.Modules
local core = modules.Core

local utility = require(core.Utility)
local pickable = workspace.PICKABLE

--// Core

userInputService.InputBegan:Connect(function(Input: InputObject, Processed: boolean)
	if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	
	local main = utility.New()
	local instance = main:Init()
	
	if not instance then
		return
	end
	
	main:Update(function()
		instance.P0.Align.Position = main:RayCast({pickable, character})
	end)
end)

userInputService.InputEnded:Connect(function(Input: InputObject)
	if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	
	player:SetAttribute("Grab", false)
end)