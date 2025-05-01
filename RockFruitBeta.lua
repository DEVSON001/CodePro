local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("RockFruit ByMrSon.", "DarkTheme")
local Tab = Window:NewTab("AutoFarm")
local Section = Tab:NewSection("Smelly AutoSkill")

-- สถานะสำหรับ AutoSkill และ AutoStat
local isAutoSkillEnabled = false
local isAutoStatEnabled = false

-- Toggle สำหรับ AutoSkill
Section:NewToggle("AutoSkill", "Beta", function(state)
    isAutoSkillEnabled = state

    if state then
        -- Skill Z
        task.spawn(function()
            while isAutoSkillEnabled do
                task.wait(6.5)
                local args = { "Smelly", "z" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action"):FireServer(unpack(args))
            end
        end)

        -- Skill X
        task.spawn(function()
            while isAutoSkillEnabled do
                task.wait(0.2)
                local args = { "Smelly", "x" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action"):FireServer(unpack(args))
            end
        end)

        -- Skill V
        task.spawn(function()
            while isAutoSkillEnabled do
                task.wait(0.2)
                local args = { "Smelly", "v" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action"):FireServer(unpack(args))
            end
        end)
    else
        print("AutoSkill Off")
    end
end)

Section:NewToggle("AutoMeleeStat", "Up Melee Stat", function(state)
    isAutoStatEnabled = state

    if state then
        task.spawn(function()
            while isAutoStatEnabled do
                task.wait(0.2)
                local args = { "UpStats", "Melee", 10000 }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("System"):FireServer(unpack(args))
            end
        end)
    else
        print("AutoStat Off")
    end
end)