local Library = loadstring(game:HttpGet("htps://pastebin.com/rawt/vff1bQ9F"))()
local Window = Library.CreateLib("Admin Master", "Ocean")

local MainTab = Window:NewTab("Main")
local MainTabSection = MainTab:NewSection("Main")

MainTab:NewButton("Inf Jumps", "Enables Inf Jumps", function()
    local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
end)

MainTab:NewToggle("Fov", "Changes Fov", function(state)
    if state then
        game.Workspace.CurrentCamera.FieldOfView = 120
    else
        game.Workspace.CurrentCamera.FieldOfView = 80
    end
end)

MainTab:NewSlider("WalkSpeed", "Makes your faster", 250, 120, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)