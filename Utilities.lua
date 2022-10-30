repeat task.wait() until game:IsLoaded()

local lplr = game.Players.LocalPlayer

local SelectedPlayer
local NearbyPlayers = {}
local NearestRange = math.huge
local NearestPlayer
PlayerUtility = {
    getCharacter = function(Player)
        if Player then
            Player = Player
        else
            Player = lplr
        end
        return Player.Character
    end,
    isAlive = function(Player)
        if Player then
            SelectedPlayer = Player
        else
            SelectedPlayer = lplr
        end
        if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            return true
        else
            return false
        end
    end,
    canDamage = function(Character)
        if not Character:FindFirstChild("ForceField") and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("Humanoid").Health > 0 and Character:FindFirstChild("Head") and Character:FindFirstChild("HumanoidRootPart") then
            return true
        else
            return false
        end
    end,
    getTool = function(ToolName)
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                if ToolName then
                    if v.Name == ToolName then
                        return v
                    end
                else
                    return v
                end
            end
        end
    end,
    isPlayerTargetable = function(Player)
        if not Player.Team then
            return true
        end
        if Player.Team ~= lplr.Team then
            return true
        else
            return false
        end
    end,
    getHealth = function(Character)
        return tonumber(Character.Character.Health)
    end,
    getNearestCharacter = function(Range, Self, ReturnOne)
        if Range then
            Range = Range
        else
            Range = math.huge
        end
        if not ReturnOne then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character.PrimaryPart then
                    if (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= Range then
                        table.insert(NearbyPlayers, v)
                    end
                end
            end
        else
            if not Self then
                for i,v in pairs(game.Players:GetPlayers()) do
                    if v ~= lplr and v.Character and v.Character.PrimaryPart then
                        if (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= NearestRange then
                            NearestRange = (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude
                            NearestPlayer = v
                        end
                    end
                end
            else
                for i,v in pairs(game.Players:GetPlayers()) do
                    if v.Character and v.Character.PrimaryPart then
                        if (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= NearestRange then
                            NearestRange = (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude
                            NearestPlayer = v
                        end
                    end
                end
            end
            if NearestPlayer and NearestPlayer.Character:FindFirstChild("HumanoidRootPart") and (lplr.Character.HumanoidRootPart.Position - NearestPlayer.Character.HumanoidRootPart.Position).Magnitude < Range then
                return NearestPlayer
            end
        end
        if not ReturnOne and not Self then
            for i,v in pairs(NearbyPlayers) do
                if v == lplr then
                    table.remove(NearbyPlayers, i)
                end
            end
        end
        if not ReturnOne then
            return NearbyPlayers
        end
    end
}

return PlayerUtility

-- PlayerUtility.getCharacter(lplr) -- (Player)
-- PlayerUtility.isAlive(lplr) -- (Player)
-- PlayerUtility.canDamage(lplr) -- (Player)
-- PlayerUtility.isPlayerTargetable(lplr) -- (Player)
-- PlayerUtility.getHealth(lplr) -- (Player)
-- PlayerUtility.getNearestCharacter(1000, false, true) -- (Range, AddSelf, Return One Player) -- if Return One Player is false it will return a table else the player
