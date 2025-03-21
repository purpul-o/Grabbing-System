--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local character = player.Character

local humanoidRootPart = character.HumanoidRootPart

local modules = replicatedStorage.Modules
local remotes = replicatedStorage.Remotes

local network = remotes.Network

local configuration = require(modules.Configuration)
local shared = configuration.Shared

local mouse = player:GetMouse()

local utility, main = {}, {}
main.__index = main

--// Functions

function main:Raycast(Exclude: {Instance}): Vector3
	table.insert(Exclude, character)
	
	local direction = (mouse.Hit.Position - humanoidRootPart.Position).Unit

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = Exclude

	local result = workspace:Raycast(humanoidRootPart.Position, direction * shared.Normal_Raycast_Distance, params)
	local position

	if result then
		position = result.Position
	else
		position = humanoidRootPart.Position + (direction * shared.Float_Raycast_Distance)
	end

	return position
end

function main:Update(Callback: () -> ())
	self.Target.P0.WorldCFrame = self.Hit
	
	local created = coroutine.create(function()
		local align = self.Target.P0.Align
		align.Enabled = true

		while player:GetAttribute("Grab") do
			Callback()
			runService.Heartbeat:Wait()
		end

		align.Enabled = false
	end)
	
	coroutine.resume(created)
end

function main:Init(): Instance?
	local target, hit = mouse.Target, mouse.Hit
	local status = network:InvokeServer(target)

	if not status then
		return
	end

	player:SetAttribute("Grab", true)
	
	self.Target = target
	self.Hit = hit
	
	return self.Target
end

function utility.New()
	local self = setmetatable({}, main)
	return self
end

return utility