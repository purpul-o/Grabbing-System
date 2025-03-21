--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = replicatedStorage.Modules
local remotes = replicatedStorage.Remotes

local pickable = workspace.PICKABLE

local network = remotes.Network

local configuration = require(modules.Configuration)
local shared = configuration.Shared

--// Core

network.OnServerInvoke = function(Player: Player, Object: Instance)
	--// Is the object not a BasePart?
	if not Object or not Object:IsA("BasePart") then
		return false
	end
	
	--// Is the object not Pickable?
	if not Object:IsDescendantOf(pickable) or not Object:FindFirstChild("P0") then
		return false
	end
	
	local character = Player.Character
	local humanoidRootPart = if character then character:FindFirstChild("HumanoidRootPart") else nil
	
	--// Is the character and humanoidRootPart not existent?
	if not humanoidRootPart then
		return false
	end
	
	--// Is the object far?
	local distance = (humanoidRootPart.Position - Object.Position).Magnitude
	local max = math.max(shared.Normal_Raycast_Distance, shared.Float_Raycast_Distance)
	
	if distance > max then
		return false
	end
	
	--// Verification complete, set network ownership!
	
	Object:SetNetworkOwner(Player)
	
	return true
end