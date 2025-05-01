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
                task.wait(0.1)
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
local args = {
	"fire",
	[3] = "economy",
	[4] = "Crowbar",
	[5] = 50
}

local isAutoSaleEnabled = false

-- Toggle สำหรับ AutoSale
Section:NewToggle("AutoSale", "Auto Fire Crowbar", function(state)
    isAutoSaleEnabled = state

    if state then
        task.spawn(function()
            while isAutoSaleEnabled do
                task.wait(0.1)
                local args = {
                    "fire",
                    [3] = "economy",
                    [4] = "Crowbar",
                    [5] = 50
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("NetworkFramework"):WaitForChild("NetworkEvent"):FireServer(unpack(args))
            end
        end)
    else
        print("AutoSale Off")
    end
end)
