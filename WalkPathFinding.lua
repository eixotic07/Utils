local lplr = game.Players.LocalPlayer

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
        PathCreated:ComputeAsync(lplr.Character.HumanoidRootPart.Position, CoordinateFrame)
    end)
    
    if Success and PathCreated.Status == Enum.PathStatus.Success then
        getgenv().CurrentlyPathing = true
        
        for i,v in pairs(PathCreated:GetWaypoints()) do
	    lplr.Character.Humanoid:MoveTo(v.Position)
        end
	
	    getgenv().CurrentlyPathing = false
	    Controls:Enable()
    end
end

return GoToPath
