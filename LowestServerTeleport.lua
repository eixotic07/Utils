function ServerTeleport()
    if foundAnything ~= "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end

    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
    	foundAnything = Site.nextPageCursor
    end

    local LowestServerCap = 100
    for i,v in pairs(Site.data) do
        local Possible = true 
        ID = tostring(v.id)

        if v.playing and tonumber(v.maxPlayers) > tonumber(v.playing) then
            --if tonumber(v.playing) <= LowestServerCap then
                LowestServerCap = tonumber(v.playing)
                LowestId = ID
            --end
        end
    end

	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, LowestId, game.Players.LocalPlayer)
end

return ServerTeleport
