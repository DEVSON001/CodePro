local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Wisteria ByDevSon", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Auto Train")

-- ตัวแปรควบคุม
local running = false
local runningAgility = false
local renderConnection = nil
local mainLoopThread = nil
local agilityThread = nil

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Section:NewToggle("Train Strength", "Train strength automatically", function(state)
    running = state

    if state then
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

        renderConnection = RunService.RenderStepped:Connect(function()
            local prompt = getClosestPrompt()
            if prompt then
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
            end
        end)

        mainLoopThread = task.spawn(function()
            while running do
                local tween = TweenService:Create(humrp, TI, { CFrame = tweenTarget })
                tween:Play()
                tween.Completed:Wait()

                for i = 1, 20 do
                    humrp.CFrame = teleportTarget
                    task.wait(0.2)
                end

                task.wait(0.2)
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

Section:NewToggle("Train Agility", "Train agility automatically", function(state)
    runningAgility = state

    if state then
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humrp = character:WaitForChild("HumanoidRootPart")

        local point1 = CFrame.new(-3151.10, 86.40, 1540.92)
        local point2 = CFrame.new(11198.21, -46.00, 1956.98)
        local TI = TweenInfo.new(3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        agilityThread = task.spawn(function()
            while runningAgility do
                local tween1 = TweenService:Create(humrp, TI, { CFrame = point1 })
                tween1:Play()
                tween1.Completed:Wait()

                local tween2 = TweenService:Create(humrp, TI, { CFrame = point2 })
                tween2:Play()

                task.wait(4)
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

local Tab = Window:NewTab("Player Setting")
local Section = Tab:NewSection("Farm")

local originalRanges = {}

Section:NewToggle("Extra Range", "Extend Slayer Attack Range", function(state)
    local SetCombat = ReplicatedStorage.Styles.Katana["Auto Attacks"]
    local Sets = {SetCombat["1"], SetCombat["2"], SetCombat["3"], SetCombat["4"]}

    if state then
        for i, set in ipairs(Sets) do
            originalRanges[i] = set.Range.Value
            set.Range.Value = 100
        end
    else
        for i, set in ipairs(Sets) do
            if originalRanges[i] then
                set.Range.Value = originalRanges[i]
            end
        end
    end
end)

local originalCoolDown = nil
local originalResetTimer = nil

Section:NewToggle("No Cooldown", "Remove Slayer Cooldowns", function(state)
    local Setting = ReplicatedStorage.Styles.Katana.Settings
    local CoolDown = Setting.Cooldown
    local ResetTimer = Setting["Reset Timer"]

    if state then
        if originalCoolDown == nil then originalCoolDown = CoolDown.Value end
        if originalResetTimer == nil then originalResetTimer = ResetTimer.Value end

        CoolDown.Value = 0
        ResetTimer.Value = 0
    else
        if originalCoolDown ~= nil then CoolDown.Value = originalCoolDown end
        if originalResetTimer ~= nil then ResetTimer.Value = originalResetTimer end
    end
end)

local originalAttackSpeed = nil

Section:NewToggle("Fast Attack", "Increase Slayer Attack Speed", function(state)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local ATKspeed = workspace.Living[character.Name].Status.Attackspeed

    if ATKspeed then
        if state then
            if originalAttackSpeed == nil then
                originalAttackSpeed = ATKspeed.Value
            end
            ATKspeed.Value = 4
        else
            if originalAttackSpeed ~= nil then
                ATKspeed.Value = originalAttackSpeed
            end
        end
    end
end)

local Tab = Window:NewTab("Teleport")
local Section = Tab:NewSection("Point")

Section:NewButton("FarmDemonPoint1", "Click to Teleport", function()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humrp = character:WaitForChild("HumanoidRootPart")

    humrp.CFrame = CFrame.new(6443.8212890625, 122.01976776123047, -566.9907836914062)
end)
Section:NewButton("FarmDemonPoint2", "Click to Teleport", function()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humrp = character:WaitForChild("HumanoidRootPart")

    humrp.CFrame = CFrame.new(8617.9208984375, 349.66583251953125, -2962.0087890625)
end)
Section:NewButton("FarmDemonPoint3", "Click to Teleport", function()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humrp = character:WaitForChild("HumanoidRootPart")

    humrp.CFrame = CFrame.new(10321.28125, 25.039093017578125, -564.6642456054688)
end)