local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rock Fruit", "DarkTheme")
local Tab = Window:NewTab("AutoBoss")
local Section = Tab:NewSection("AutoFarmBoss")

local autoFarmEnabled = false
local toolName = "SmellyV2"
local remoteBoss = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("NetworkFramework"):WaitForChild("NetworkEvent")
local remoteSkill = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action")
local player = game.Players.LocalPlayer

-- ฟังก์ชันถืออาวุธ
local function equipWeapon()
    local char = player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == toolName then
                tool.Parent = char
                break
            end
        end
    end
end

-- ฟังก์ชันเปิด Haki
local function activateHaki()
    local args = {"Misc", "buso"}
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Action"):FireServer(unpack(args))
    task.wait(0.5)
end

-- ฟังก์ชันใช้สกิล
local function useSkills(remoteSkill, toolName, skillOrder)
    for _, skill in ipairs(skillOrder) do
        remoteSkill:FireServer(toolName, skill)
        if skill == "z" then
            task.wait(3.5)
        elseif skill == "x" then
            task.wait(1.5)
        elseif skill == "v" then
            task.wait(1)
        elseif skill == "c" then
            task.wait(2.5)
        end
    end
end

-- ฟังก์ชันฟาร์มปกติ
local function farmNormal(remoteSkill, toolName)
    useSkills(remoteSkill, toolName, {"z", "x", "v", "c"})
end

-- ฟังก์ชันฟาร์ม Haki
local function farmWithHaki(remoteSkill, toolName)
    useSkills(remoteSkill, toolName, {"v", "c"})
end

-- ฟาร์มที่จุด 1
local function farmNormalPosition1(remoteSkill, toolName)
    useSkills(remoteSkill, toolName, {"z", "x"})
end

-- ฟาร์มที่จุด 2
local function farmNormalPosition2(remoteSkill, toolName)
    useSkills(remoteSkill, toolName, {"v"})
end

-- สลับจุดฟาร์ม
local function farmCycle(remoteSkill, toolName)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(1344.271240234375, 11.329935073852539, -2253.415283203125) -- จุด 1
    end
    farmNormalPosition1(remoteSkill, toolName)
    task.wait(1)

    if hrp then
        hrp.CFrame = CFrame.new(1334.16552734375, 11.329935073852539, -2285.587890625) -- จุด 2
    end
    farmNormalPosition2(remoteSkill, toolName)
    task.wait(4)
end

-- ระบบฟาร์มวนลูป
local function startFarm(isHaki)
    task.spawn(function()
        local hakiActivated = false

        while autoFarmEnabled do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            -- เปิด Haki แค่ครั้งเดียว
            if isHaki and not hakiActivated then
                activateHaki()
                hakiActivated = true
            end

            -- ฟาร์มบอส 10 รอบ
            for i = 1, 20 do
                remoteBoss:FireServer("fire", nil, "SummonBoss", "Vasto Hollow")

                if hrp then
                    hrp.CFrame = CFrame.new(-2201.386962890625, 16.510194778442383, -506.6521911621094)
                         task.wait(0.5125)
                end

                if isHaki then
                    farmWithHaki(remoteSkill, toolName)
                else
                    farmNormal(remoteSkill, toolName)
                end

                task.wait(3.5)
            end

            -- สลับฟาร์มจุด 1 และ 2 จำนวน 10 รอบ
            for i = 1, 10 do
                farmCycle(remoteSkill, toolName)
                task.wait(1)
            end
        end
    end)
end

-- Toggle เปิด/ปิดระบบ
Section:NewToggle("OpenAutoFarm Normal", "AutoFarmBoss (Normal)", function(state)
    autoFarmEnabled = state
    if state then
        equipWeapon()
        startFarm(false)
    end
end)

Section:NewToggle("OpenAutoFarm With Haki", "AutoFarmBoss (With Haki)", function(state)
    autoFarmEnabled = state
    if state then
        equipWeapon()
        startFarm(true)
    end
end)

-- Anti-AFK
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    print("[AntiAFK] VirtualUser activated.")
end)

-- ขยับตัวเบา ๆ ทุก 5 นาที
task.spawn(function()
    while true do
        task.wait(300)
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.1)
        end
    end
end)
