local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomGui"
    ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Draggable = true
    MainFrame.Active = true

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.Text = "C5 Customer"
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.Font = Enum.Font.SourceSans
    TitleBar.TextSize = 18
    TitleBar.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0, 30)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    StatusLabel.Text = "Status: Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -60)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 50)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ScrollingFrame.Parent = MainFrame
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local function createButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Button.Parent = ScrollingFrame
        Button.MouseButton1Click:Connect(callback)
    end

    createButton("Kill", function()
        StatusLabel.Text = "Status: Killing myself"
        game.Players.LocalPlayer.Character:BreakJoints()
    end)

    createButton("Kick", function()
        StatusLabel.Text = "Status: Kicking myself"
        game.Players.LocalPlayer:Kick("Cút mẹ m đi")
    end)

    local speed = 16
    createButton("Speed Up", function()
        if speed >= 101 then
            speed = 16
            StatusLabel.Text = "Status: Speed reset to default"
        else
            speed = (speed >= 96) and 101 or speed + 5
            StatusLabel.Text = "Status: Speed increased to " .. speed
        end
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = speed
    end)

    createButton("Boost FPS (error, upd soon)", function()
        local success, errorMessage = pcall(function()
            StatusLabel.Text = "Status: Boosting FPS"
            game:GetService("UserSettings"):GetService("GameSettings"):SetFpsCap(60)
        end)

        if success then
            StatusLabel.Text = "Status: FPS boosted"
        else
            StatusLabel.Text = "Error: " .. errorMessage
        end
    end)

    createButton("Reduce Graphics (error, upd soon)", function()
        local success, errorMessage = pcall(function()
            StatusLabel.Text = "Status: Reducing graphics"
            local gameSettings = game:GetService("UserSettings"):GetService("GameSettings")
            gameSettings.RenderingQuality = Enum.QualityLevel.Level00
        end)

        if success then
            StatusLabel.Text = "Status: Graphics reduced"
        else
            StatusLabel.Text = "Error: " .. errorMessage
        end
    end)

    local espEnabled = false
    createButton("ESP Player", function()
        espEnabled = not espEnabled
        if espEnabled then
            StatusLabel.Text = "Status: ESP activated"
        else
            StatusLabel.Text = "Status: ESP deactivated"
        end
    end)

    local function espPlayer()
        if espEnabled then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = character.HumanoidRootPart
                        local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)

                        if onScreen then
                            local health = character:FindFirstChild("Humanoid") and character.Humanoid.Health or 0
                            local distance = (workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
                            local name = player.Name

                            local espLabel = Instance.new("TextLabel")
                            espLabel.Size = UDim2.new(0, 150, 0, 20)
                            espLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
                            espLabel.BackgroundTransparency = 1
                            espLabel.Text = name .. " | HP: " .. math.floor(health) .. " | Dist: " .. math.floor(distance) .. " studs"
                            espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            espLabel.Font = Enum.Font.SourceSans
                            espLabel.TextSize = 14
                            espLabel.Parent = ScreenGui

                            game:GetService("RunService").Heartbeat:Connect(function()
                                if espEnabled and character and character:FindFirstChild("HumanoidRootPart") then
                                    local rootPart = character.HumanoidRootPart
                                    local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
                                    if onScreen then
                                        espLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
                                    else
                                        espLabel:Destroy()
                                    end
                                else
                                    espLabel:Destroy()
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        espPlayer()
    end)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 120, 0, 35)
    ToggleButton.Position = UDim2.new(0.5, -60, 0.9, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ToggleButton.Text = "Toggle GUI"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ScreenGui

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("CustomGui") then
        game.Players.LocalPlayer.PlayerGui:FindFirstChild("CustomGui"):Destroy()
    end
    createGui()
end)

createGui()
