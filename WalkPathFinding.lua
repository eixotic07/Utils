local lplr = game.Players.LocalPlayer.Character

local Controls = require(lplr.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
function GoToPath(CoordinateFrame)
    getgenv().CurrentlyPathing = false
    
	Controls:Disable()
	
	local PathCreated = game:GetService("PathfindingService"):CreatePath({
        AgentRadius = 2,
        AgentHeight = 4,
        AgentCanJump = true,
        AgentCanClimb = true
    })

    local Success, errorMessage = pcall(function()
        PathCreated:ComputeAsync(lplr.Chacter.HumanoidRootPart.Position, CoordinateFrame.Position)
    end)
    
    if Success and PathCreated.Status == Enum.PathStatus.Success then
        getgenv().CurrentlyPathing = true
        
        for i,v in pairs(PathCreated:GetWaypoints()) do
            lplr.Character.Humanoid.WalkToPoint = v.Position
            
            if PathCreated:GetWaypoints()[i + 1] ~= nil and PathCreated:GetWaypoints()[i + 1].Action == Enum.PathWaypointAction.Jump then
				task.spawn(function()
					task.wait(0.1)
					lplr.Character.Humanoid.Jump = true
				end)
            end
        end
	
	    getgenv().CurrentlyPathing = false
	    Controls:Enable()
    end
end

return GoToPatH
