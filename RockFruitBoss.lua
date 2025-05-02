local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rock Fruit", "DarkTheme")
local Tab = Window:NewTab("AutoBoss")
local Section = Tab:NewSection("AutoFarmBoss")

local autoFarmEnabled = false
local toolName = "SmellyV2"
local skillRunning = false

Section:NewToggle("OpenAutoFarm", "AutoFarmBoss", function(state)
    autoFarmEnabled = state

    if state then
        local player = game.Players.LocalPlayer

        -- 🔁 ลูปวาร์ปทุก 0.1 วิ
        task.spawn(function()
            while autoFarmEnabled do
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(-2201.386962890625, 16.510194778442383, -506.6521911621094)
                end
                task.wait(0.1)
            end
        end)

        -- 🔁 ลูปเช็คการถือ Tool และเริ่มใช้สกิล
        task.spawn(function()
            while autoFarmEnabled do
                local char = player.Character
                if char and not char:FindFirstChildOfClass("Tool") then
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name == toolName then
                            tool.Parent = char
                            break
                        end
                    end
                end

                -- ✅ เริ่มใช้ Skill ทันทีเมื่อถือ Tool แล้ว และยังไม่ได้เริ่มลูป
                if not skillRunning and char and char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name == toolName then
                    skillRunning = true
                    task.spawn(function()
                        while autoFarmEnabled do
                            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action")

                            -- 🌀 z
                            remote:FireServer(toolName, "z")
                            task.wait(3.25)

                            -- ⚡ x
                            remote:FireServer(toolName, "x")
                            task.wait(1.35)

                            -- 🔥 v
                            remote:FireServer(toolName, "v")
                            task.wait(0.5)

                            -- 💥 c
                            remote:FireServer(toolName, "c")

                            -- 🕒 รอ 6 วิ ก่อนรอบถัดไป
                            task.wait(6)
                        end
                    end)
                end

                task.wait(0.1)
            end
        end)

    else
        print("AutoFarmBoss Disabled")
        skillRunning = false
    end
end)
