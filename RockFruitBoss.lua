local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rock Fruit", "DarkTheme")
local Tab = Window:NewTab("AutoBoss")
local Section = Tab:NewSection("AutoFarmBoss")

local autoFarmEnabled = false  -- เปิด/ปิด AutoFarm

Section:NewToggle("OpenAutoFarm", "AutoFarmBoss", function(state)
    autoFarmEnabled = state

    if state then
        task.spawn(function()
            while autoFarmEnabled do
                -- 🌀 ใช้สกิล z
                local startTime = tick()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remote")
                    :WaitForChild("Action")
                    :FireServer("SmellyV2", "z")

                task.wait(3.25)

                -- ⚡ ใช้สกิล x
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remote")
                    :WaitForChild("Action")
                    :FireServer("SmellyV2", "x")

                task.wait(1.35)

                -- 🔥 ใช้สกิล v
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remote")
                    :WaitForChild("Action")
                    :FireServer("SmellyV2", "v")

                task.wait(0.5)

                -- 💥 ใช้สกิล c
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remote")
                    :WaitForChild("Action")
                    :FireServer("SmellyV2", "c")

                local endTime = tick()
                local totalTime = endTime - startTime
                print("Total time to use all skills: " .. totalTime .. " seconds")

                task.wait(5) -- รอ 5 วินาทีก่อนวนรอบใหม่
            end
        end)
    else
        print("AutoFarmBoss Disabled")
    end
end)