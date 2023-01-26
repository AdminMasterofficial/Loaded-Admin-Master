if game.PlaceId == 155615604 then

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Admin Master (Prison Life)", "Ocean")

    local Main = Window:NewTab("Main")
    local MainSection = Main:NewSection("Main")
    
    MainSection:NewToggle("Fov", "Changes Fov", function(state)
        if state then
            game.Workspace.CurrentCamera.FieldOfView = 120
        else
            game.Workspace.CurrentCamera.FieldOfView = 80
        end
    end)

    MainSection:NewSlider("WalkSpeed", "Makes your faster", 250, 120, function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end)

    MainSection:NewToggle("Infinite Jump", "Toggle for infinite jump", function(state)
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
end
