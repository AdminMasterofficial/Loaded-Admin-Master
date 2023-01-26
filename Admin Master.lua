if game.PlaceId == 155615604 then

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Admin Master (Prison Life)", "DarkTheme")

    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")

    local Main = Window:NewTab("Main")
    local MainSection = Main:NewSection("Main")

    MainSection:NewDropdown("Give Gun", "Gives the localplayer a gun", {"M9", "Remington 870", "AK-47"}, function(v, abc)
        local A_1 = game:GetService("Workspace")["Prison_ITEMS"].giver[v].ITEMPICKUP
        local Event = game:GetService("Workspace").Remote.ItemHandler
        Event:InvokeServer(A_1)

        select = abc
    end)
 
    MainSection:NewDropdown("Gun Mod", "Makes the gun op", {"M9", "Taser", "Remington 870", "AK-47"}, function(v, abc)
        local module = nil
        if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(v) then
            module = require(game:GetService("Players").LocalPlayer.Backpack[v].GunStates)
        elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(v) then
            module = require(game:GetService("Players").LocalPlayer.Character[v].GunStates)
        end
        if module ~= nil then
            module["MaxAmmo"] = math.huge
            module["CurrentAmmo"] = math.huge
            module["StoredAmmo"] = math.huge
            module["FireRate"] = 0.000001
            module["Spread"] = 0
            module["Range"] = math.huge
            module["Bullets"] = 10
            module["ReloadTime"] = 0.000001
            module["AutoFire"] = true

            select = abc
        end
    end)


    local LocalPlayer = Window:NewTab("Local Player")
    local LocalPlayerSection = LocalPlayer:NewSection("Local Player")

    LocalPlayerSection:NewSlider("Fov", "Changes Fov", 120, 80, function(v)
        game.Workspace.CurrentCamera.FieldOfView = v
    end)

    LocalPlayerSection:NewSlider("WalkSpeed", "Makes your faster", 250, 120, function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end)

    LocalPlayerSection:NewToggle("Infinite Jump", "Toggle for infinite jump", function(state)
        if state then
            local InfiniteJumpEnabled = true
            game:GetService("UserInputService").JumpRequest:connect(function()
                if InfiniteJumpEnabled then
                    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
                end
            end)
            print("Infinite Jump: ON")
        else
            InfiniteJumpEnabled = false
            game:GetService("UserInputService").JumpRequest:connect(function()
                if InfiniteJumpEnabled then
                    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
                end
            end)
            print("Infinite Jump: OFF")
        end
    end)

    local ServerClient = Window:NewTab("Server Client")
    local ServerClientSection = ServerClient:NewSection("Server Client")

    ServerClientSection:NewButton("Server Crash", "Crashing Server", function(FireGun, target)
        local Gun = "Remington 870"
        local Player = game.Players.LocalPlayer.Name
        game.workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver[Gun].ITEMPICKUP)
        for i,v in pairs(game.Players[Player].Backpack:GetChildren()) do
            if v.name == (Gun) then
                v.Parent = game.Players.LocalPlayer.Character
            end
        end
        Gun = game.Players[Player].Character[Gun]
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()

        function FireGun()
            coroutine.resume(coroutine.create(function()
                local bulletTable = {}
                table.insert(bulletTable, {
                    Hit = target,
                    Distance = 100,
                    Cframe = CFrame.new(0,1,1),
                    RayObject = Ray.new(Vector3.new(0.1,0.2), Vector3.new(0.3,0.4))
                })
                game.ReplicatedStorage.ShootEvent:FireServer(bulletTable, Gun)
                wait()
            end))
        end
        while game:GetService("RunService").Stepped:wait() do
            for count = 0, 10, 10 do
                FireGun()
            end
        end
    end)

    ServerClientSection:NewButton("Open Gate", "Makes the gate open for you", function()
        Workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.buttons["Prison Gate"]["Prison Gate"])
 end)

 ServerClientSection:NewButton("Click Arrest", "Activate click arrest", function()
    local mouse = game.Players.LocalPlayer:GetMouse()

    local arrestEvent = game.Workspace.Remote.arrest
    mouse.Button1Down:connect(function()
        local obj = mouse.Target
		local response = arrestEvent:InvokeServer(obj)
    end)
 end)

   ServerClientSection:NewButton("Kill Aura", "Activate kill aura", function()
        local Plr = game.Players.LocalPlayer
        local Plrs = game:GetService("Players")

        while wait() do
            for i,v in pairs(Plrs:GetChildren()) do
                if v.UserId == Plr.UserId then
                    print("Activate")
                else
                    game:GetService("ReplicatedStorage").meleeEvent:FireServer(v)
                end
            end
        end
    end)

    ServerClientSection:NewButton("SuperPunch", "Activate super punch", function()
        mainRemotes = game.ReplicatedStorage meleeRemote = mainRemotes['meleeEvent'] mouse = game.Players.LocalPlayer:GetMouse() punching = false cooldown = false function punch() cooldown = true local part = Instance.new("Part", game.Players.LocalPlayer.Character) part.Transparency = 1 part.Size = Vector3.new(5, 2, 3) part.CanCollide = false local w1 = Instance.new("Weld", part) w1.Part0 = game.Players.LocalPlayer.Character.Torso w1.Part1 = part w1.C1 = CFrame.new(0,0,2) part.Touched:connect(function(hit) if game.Players:FindFirstChild(hit.Parent.Name) then local plr = game.Players:FindFirstChild(hit.Parent.Name) if plr.Name ~= game.Players.LocalPlayer.Name then part:Destroy() for i = 1,100 do meleeRemote:FireServer(plr) end end end end) wait(1) cooldown = false part:Destroy() end mouse.KeyDown:connect(function(key) if cooldown == false then if key:lower() == "f" then punch() end end end)
    end)

    ServerClientSection:NewLabel("Toggle")

    ServerClientSection:NewToggle("Doors", "Toggle for door", function()
        if Workspace:FindFirstChild("Doors") then
            Workspace.Doors.Parent = Lighting
            
            else
                Lighting.Doors.Parent = Workspace
            end
        end)

        ServerClientSection:NewToggle("Fences", "Toggle for fences", function()
        if Workspace:FindFirstChild("Prison_Fences") then
            Workspace.Prison_Fences.Parent = Lighting
            else
                Lighting.Prison_Fences.Parent = Workspace
            end
        end)

        ServerClientSection:NewToggle("Full Brightness", "Toggle for full brightness", function()
            if not _G.FullBrightExecuted then
        
                _G.FullBrightEnabled = false
            
                _G.NormalLightingSettings = {
                    Brightness = game:GetService("Lighting").Brightness,
                    ClockTime = game:GetService("Lighting").ClockTime,
                    FogEnd = game:GetService("Lighting").FogEnd,
                    GlobalShadows = game:GetService("Lighting").GlobalShadows,
                    Ambient = game:GetService("Lighting").Ambient
                }
            
                game:GetService("Lighting"):GetPropertyChangedSignal("Brightness"):Connect(function()
                    if game:GetService("Lighting").Brightness ~= 1 and game:GetService("Lighting").Brightness ~= _G.NormalLightingSettings.Brightness then
                        _G.NormalLightingSettings.Brightness = game:GetService("Lighting").Brightness
                        if not _G.FullBrightEnabled then
                            repeat
                                wait()
                            until _G.FullBrightEnabled
                        end
                        game:GetService("Lighting").Brightness = 1
                    end
                end)
            
                game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()
                    if game:GetService("Lighting").ClockTime ~= 12 and game:GetService("Lighting").ClockTime ~= _G.NormalLightingSettings.ClockTime then
                        _G.NormalLightingSettings.ClockTime = game:GetService("Lighting").ClockTime
                        if not _G.FullBrightEnabled then
                            repeat
                                wait()
                            until _G.FullBrightEnabled
                        end
                        game:GetService("Lighting").ClockTime = 12
                    end
                end)
            
                game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()
                    if game:GetService("Lighting").FogEnd ~= 786543 and game:GetService("Lighting").FogEnd ~= _G.NormalLightingSettings.FogEnd then
                        _G.NormalLightingSettings.FogEnd = game:GetService("Lighting").FogEnd
                        if not _G.FullBrightEnabled then
                            repeat
                                wait()
                            until _G.FullBrightEnabled
                        end
                        game:GetService("Lighting").FogEnd = 786543
                    end
                end)
            
                game:GetService("Lighting"):GetPropertyChangedSignal("GlobalShadows"):Connect(function()
                    if game:GetService("Lighting").GlobalShadows ~= false and game:GetService("Lighting").GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
                        _G.NormalLightingSettings.GlobalShadows = game:GetService("Lighting").GlobalShadows
                        if not _G.FullBrightEnabled then
                            repeat
                                wait()
                            until _G.FullBrightEnabled
                        end
                        game:GetService("Lighting").GlobalShadows = false
                    end
                end)
            
                game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()
                    if game:GetService("Lighting").Ambient ~= Color3.fromRGB(178, 178, 178) and game:GetService("Lighting").Ambient ~= _G.NormalLightingSettings.Ambient then
                        _G.NormalLightingSettings.Ambient = game:GetService("Lighting").Ambient
                        if not _G.FullBrightEnabled then
                            repeat
                                wait()
                            until _G.FullBrightEnabled
                        end
                        game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
                    end
                end)
            
                game:GetService("Lighting").Brightness = 1
                game:GetService("Lighting").ClockTime = 12
                game:GetService("Lighting").FogEnd = 786543
                game:GetService("Lighting").GlobalShadows = false
                game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
            
                local LatestValue = true
                spawn(function()
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                    while wait() do
                        if _G.FullBrightEnabled ~= LatestValue then
                            if not _G.FullBrightEnabled then
                                game:GetService("Lighting").Brightness = _G.NormalLightingSettings.Brightness
                                game:GetService("Lighting").ClockTime = _G.NormalLightingSettings.ClockTime
                                game:GetService("Lighting").FogEnd = _G.NormalLightingSettings.FogEnd
                                game:GetService("Lighting").GlobalShadows = _G.NormalLightingSettings.GlobalShadows
                                game:GetService("Lighting").Ambient = _G.NormalLightingSettings.Ambient
                            else
                                game:GetService("Lighting").Brightness = 1
                                game:GetService("Lighting").ClockTime = 12
                                game:GetService("Lighting").FogEnd = 786543
                                game:GetService("Lighting").GlobalShadows = false
                                game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
                            end
                            LatestValue = not LatestValue
                        end
                    end
                end)
            end
            _G.FullBrightExecuted = true
            _G.FullBrightEnabled = not _G.FullBrightEnabled
        end)

    local Scripts = Window:NewTab("Scripts")
    local ScriptsSection = Scripts:NewSection("Scripts")

    ScriptsSection:NewButton("FE Admin Commands", "Loaded FE Admin Commands", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RealErickDenisDavid/Fe-Admin-Commands/main/Fe%20Admin%20Commands.lua", true))()
    end)

    ScriptsSection:NewButton("Septex Admin Commands", "Loaded Septex Admin Commands", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/PrisonLife'),true))()
    end)

    local Credits = Window:NewTab("Credits")
    local CreditsSection = Credits:NewSection("Credits")

    CreditsSection:NewLabel("Erick Denis David#7317 for Developer")
    CreditsSection:NewLabel("Alex#9684 for Ideas")
    CreditsSection:NewLabel("Emmas#9481 for being owner of script")
end
