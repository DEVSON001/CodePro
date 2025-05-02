local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("RockFruit ByMrSon.", "DarkTheme")

-- แท็บและเซคชั่น
local Tab = Window:NewTab("AutoFarm")
local Section = Tab:NewSection("Smelly AutoSkill")

-- ตัวแปรสถานะ
local isAutoSkillEnabled = false
local isAutoStatEnabled = false
local isAutoSaleEnabled = false

-- AutoSkill
Section:NewToggle("AutoSkill", "Beta", function(state)
    isAutoSkillEnabled = state
    print("AutoSkill:", state and "On" or "Off")

    if state then
        task.spawn(function()
            while isAutoSkillEnabled do
                task.wait(0.1)
                local args = { "SmellyV2", "z" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action"):FireServer(unpack(args))
            end
        end)
    end
end)

-- AutoMeleeStat
Section:NewToggle("AutoMeleeStat", "Up Melee Stat", function(state)
    isAutoStatEnabled = state
    print("AutoMeleeStat:", state and "On" or "Off")

    if state then
        task.spawn(function()
            while isAutoStatEnabled do
                task.wait(0.2)
                local args = { "UpStats", "Melee", 10000 }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("System"):FireServer(unpack(args))
            end
        end)
    end
end)

-- AutoSale
Section:NewToggle("AutoSale", "Auto Fire Crowbar", function(state)
    isAutoSaleEnabled = state
    print("AutoSale:", state and "On" or "Off")

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
    end
end)

-- ปุ่มหยุดทั้งหมด
Section:NewButton("Stop All", "ปิด Auto ทั้งหมด", function()
    isAutoSkillEnabled = false
    isAutoStatEnabled = false
    isAutoSaleEnabled = false
    print("หยุดการทำงานทั้งหมดแล้ว")
end)