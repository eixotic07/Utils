
-- Loading Stuff
local Remotes = loadstring(readfile("Meteor/Bloxburg/Remotes.lua"))()

-- Waits for game to load
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character 

-- Services
local LS = game:GetService("LocalizationService")
local PFS = game:GetService("PathfindingService")

-- locals
local lplr = game:GetService("Players").LocalPlayer

-- shared
shared.BlockedParts = false

-- functions

CreateVisualPoint = function(Position)
    if not game.Workspace:FindFirstChild("VisualFolder") then
        VF = Instance.new("SelectionSphere")
        VF.Name = "VisualFolder"
        VF.Parent = game.Workspace
    end

    Part = Instance.new("Part")
    Part.Anchored = true
    Part.CanCollide = false
    Part.Size = Vector3.new(0.001,0.001,0.001)
    Part.Position = Position + Vector3.new(0,2.5,0)
    Part.Transparency = 1
    Part.Parent = game.Workspace:FindFirstChild("VisualFolder")
    Part.Name = tostring(Position)

    Sphere = Instance.new("SelectionSphere")
    Sphere.Transparency = 1
    Sphere.Parent = Part
    Sphere.Adornee = Part
    Sphere.Color3 = Color3.new(1,0,0.0156863)
	game:GetService("TweenService"):Create(Sphere, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{ Transparency = 0}):Play()
end

UpdateVisualPoint = function(Point, Remove, Color)
    if Remove then
        game:GetService("TweenService"):Create(Point, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{ Color3 = Color3.new(0,255,0)}):Play()
    	game:GetService("TweenService"):Create(Point, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{ Transparency = 1}):Play()
		Point.Parent:Destroy()
	end
end

WalkTween = function(Root, Target, Speed)
    local Dist = (Root.Position - Target.p).magnitude
    local Tween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Dist / Speed, Enum.EasingStyle.Linear), { CFrame = Target})
    Tween:Play()
    Tween.Completed:wait()
    Root.Velocity = Vector3.zero
end

GetRelativeComponents = function(vec)
    if lplr.Character.PrimaryPart then
        local newCF = CFrame.new(lplr.Character.PrimaryPart.Position, vec)
        local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = newCF:components()
        return {r00, r01, r02, r10, r11, r12, r20, r21, r22}
    end
end


CheckPath = function(Part, Target)
	if not shared.BlockedParts then
		shared.BlockedParts = {}
		for i, v in pairs(game.Workspace.Environment.Locations:GetChildren()) do
			if v.Name ~= "PizzaPlanet" and v.Name ~= "Pier_LOD" and v.Name ~= "Pier" then
				for i, v in pairs(v:GetChildren()) do
					if v:IsA("Part") or v:IsA("BasePart") then
						v.CanCollide = false
						shared.BlockedParts[i] = Instance.new("PathfindingModifier")
						shared.BlockedParts[i].Parent = v
						shared.BlockedParts[i].Label = "BlockedArea"
					end
				end
			end
		end
		for i, v in pairs(game.Workspace.Environment.MainObjects:GetChildren()) do
			if v.Name ~= "Street" and v.Name ~= "Intersection" then
				for i, v in pairs(v:GetDescendants()) do
					if v:IsA("Part") or v:IsA("BasePart") then
						v.CanCollide = false
						shared.BlockedParts[i] = Instance.new("PathfindingModifier")
						shared.BlockedParts[i].Parent = v
						shared.BlockedParts[i].Label = "BlockedArea"
					end
				end
			end
		end
		for i, v in pairs(game.Workspace.Plots:GetChildren()) do
			for i,v in pairs(v.House:GetDescendants()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.CanCollide = false
					shared.BlockedParts[i] = Instance.new("PathfindingModifier")
					shared.BlockedParts[i].Parent = v
					shared.BlockedParts[i].Label = "BlockedArea"
				end
			end
		end
	end

    CurrentyPath = false
    CurrentWaypoint = nil


    if not game.Workspace:FindFirstChild("VisualFolder") then
    	VF = Instance.new("SelectionSphere")
        VF.Name = "VisualFolder"
        VF.Parent = game.Workspace
    end

    local BoundingBox = Part.Parent:GetBoundingBox()

    local CurrentPath = PFS:CreatePath({
        AgentRadius = 2.25,
        AgentHeight = 2,
        Costs = {
            Water = math.huge,
            BlockedArea = math.huge
		}
	})

    CurrentPath:ComputeAsync(lplr.Character.PrimaryPart.Position, Target.Position)

    if CurrentPath.Status == Enum.PathStatus.Success then
        return true
    else
        return false
    end
end

GoToPath = function(Part, Target, Speed, Status)
      if not shared.BlockedParts then
		shared.BlockedParts = {}
        for i, v in pairs(game.Workspace.Environment.Locations:GetChildren()) do
            if v.Name ~= "PizzaPlanet" and v.Name ~= "Pier_LOD" and v.Name ~= "Pier" then
                for i, v in pairs(v:GetChildren()) do
                    if v:IsA("Part") or v:IsA("BasePart") then
                        v.CanCollide = false
                        shared.BlockedParts[i] = Instance.new("PathfindingModifier")
                        shared.BlockedParts[i].Parent = v
                        shared.BlockedParts[i].Label = "BlockedArea"
                    end
                end
            end
        end
        for i, v in pairs(game.Workspace.Environment.MainObjects:GetChildren()) do
            if v.Name ~= "Street" and v.Name ~= "Intersection" then
                for i, v in pairs(v:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("BasePart") then
                        v.CanCollide = false
                        shared.BlockedParts[i] = Instance.new("PathfindingModifier")
                        shared.BlockedParts[i].Parent = v
                        shared.BlockedParts[i].Label = "BlockedArea"
                    end
                end
            end
        end
        for i, v in pairs(game.Workspace.Plots:GetChildren()) do
            for i,v in pairs(v.House:GetDescendants()) do
                if v:IsA("Part") or v:IsA("BasePart") then
                    v.CanCollide = false
                    shared.BlockedParts[i] = Instance.new("PathfindingModifier")
                    shared.BlockedParts[i].Parent = v
                    shared.BlockedParts[i].Label = "BlockedArea"
                end
            end
        end
    end

    CurrentyPath = false
    CurrentWaypoint = nil


    if not game.Workspace:FindFirstChild("VisualFolder") then
        VF = Instance.new("SelectionSphere")
        VF.Name = "VisualFolder"
        VF.Parent = game.Workspace
    end

    local BoundingBox = Part.Parent:GetBoundingBox()

    local CurrentPath = PFS:CreatePath({
        AgentRadius = 2.25,
        AgentHeight = 2,
        WaypointSpacing = 0.5,
        Costs = {
            Water = math.huge,
            BlockedArea = math.huge
        }
    })

    CurrentPath:ComputeAsync(lplr.Character.PrimaryPart.Position, Target.Position)

    if CurrentPath.Status == Enum.PathStatus.Success then
        CurrentlyPathing = true

        for i, v in pairs(CurrentPath:GetWaypoints()) do
			
            WalkTween(Part, CFrame.new(v.Position.X, v.Position.Y + 2.3, v.Position.Z, unpack(GetRelativeComponents(v.Position + Vector3.new(0, 4.5, 0)))), Speed)

            local Waypoints = 0
            for i, v in pairs(CurrentPath:GetWaypoints()) do
                Waypoints = Waypoints + 1
            end
            Status:Set("Status : " .. i .. "/" .. Waypoints)
        end
        Status:Set("Pathing complete!")
        CurrentlyPathing = false
    end
end

function GetNearestSpawn()
    ClosestDistance, ClosestPosition = math.huge, nil
    local Positions = { Vector3.new(1081, 14, 248), Vector3.new(1170, 17, 275), Vector3.new(1165, 15, 316), Vector3.new(1235, 14, 325) }

    for i, v in pairs(Positions) do
        if (lplr.Character.HumanoidRootPart.Position - v).Magnitude < ClosestDistance then
            ClosestDistance = (lplr.Character.HumanoidRootPart.Position - v).Magnitude
            ClosestPosition = v
        end
    end

    return ClosestPosition
end

function ReturnHome(Vehicle, Speed, Status)
    if GetNearestSpawn() == Vector3.new(1081, 14, 248) then
        GoToPath(Vehicle, { Position = Vector3.new(1081, 14, 248) }, Speed, Status)
        GoToPath(Vehicle, { Position = Vector3.new(1170, 17, 275) }, Speed, Status)
    elseif GetNearestSpawn() == Vector3.new(1170, 17, 275) then
        GoToPath(Vehicle, { Position = Vector3.new(1170, 17, 275) }, Speed, Status)
    elseif GetNearestSpawn() == Vector3.new(1165, 15, 316) then
        GoToPath(Vehicle, { Position = Vector3.new(1165, 15, 316) }, Speed, Status)
        GoToPath(Vehicle, { Position = Vector3.new(1170, 17, 275) }, Speed, Status)
    else
        GoToPath(Vehicle, { Position = Vector3.new(1235, 14, 325) }, Speed, Status)
        GoToPath(Vehicle, { Position = Vector3.new(1165, 15, 316) }, Speed, Status)
        GoToPath(Vehicle, { Position = Vector3.new(1170, 17, 275) }, Speed, Status)
    end
end

return {GoToPath = GoToPath, CheckPath = CheckPath, WalkTween = WalkTween, ReturnHome = ReturnHome}
