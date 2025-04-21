local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Wisteria ByDevSon", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Auto Strength")

-- ตัวแปรควบคุม
local running = false
local renderConnection = nil
local mainLoopThread = nil

Section:NewToggle("Auto Train", "Open to Auto", function(state)
    running = state

    if state then
        local TS = game:GetService("TweenService")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humrp = character:WaitForChild("HumanoidRootPart")

        local tweenTarget = CFrame.new(-3394.195, 87.57, 1691.64)
        local teleportTarget = CFrame.new(-3431.76, 87.28, 1334.95)
        local TI = TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        local function getClosestPrompt()
            local closestPrompt, shortestDist = nil, math.huge
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local dist = (humrp.Position - obj.Parent.Position).Magnitude
                    if dist < shortestDist and dist <= obj.MaxActivationDistance then
                        closestPrompt = obj
                        shortestDist = dist
                    end
                end
            end
            return closestPrompt
        end

        -- Auto pressing the closest prompt
        renderConnection = RunService.RenderStepped:Connect(function()
            local prompt = getClosestPrompt()
            if prompt then
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
            end
        end)

        -- Looping every 5 sec
        mainLoopThread = task.spawn(function()
            while running do
                -- Tween to target position
                local tween = TS:Create(humrp, TI, { CFrame = tweenTarget })
                tween:Play()
                tween.Completed:Wait()

                -- Teleport multiple times
                for i = 1, 15 do
                    humrp.CFrame = teleportTarget
                    task.wait(0.2)
                end

                task.wait(2.5)
            end
        end)

    else
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
        running = false
    end
end)

Section:NewToggle("Auto Train Agility", "Open to Auto", function(state)
    runningAgility = state

    if state then
        local TS = game:GetService("TweenService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humrp = character:WaitForChild("HumanoidRootPart")

        local point1 = CFrame.new(11198.2119140625, -46.00084686279297, 1956.9853515625)
        local TI = TweenInfo.new(3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        agilityThread = task.spawn(function()
            while runningAgility do

                local tween2 = TS:Create(humrp, TI, { CFrame = point1 })
                tween2:Play()
                tween2.Completed:Wait()

                task.wait(2)
            end
        end)

    else
        runningAgility = false
        if agilityThread then
            task.cancel(agilityThread)
            agilityThread = nil
        end
    end
end)