local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DeadRail ByDevSon", "DarkTheme")

local Tab = Window:NewTab("ITEM")
local Section = Tab:NewSection("ITEM")

local highlightConnection
local highlightsEnabled = false

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

Section:NewToggle("Highlight", "Open to Highlight all items", function(state) 
	highlightsEnabled = state

	local function safeWait(path)
		local current = workspace
		for _, name in ipairs(path) do
			current = current:FindFirstChild(name)
			if not current then return nil end
		end
		return current
	end

	local generalStoreZombiesFolder = nil
	local randomBuildings = workspace:FindFirstChild("RandomBuildings")
	if randomBuildings then
		local generalStore = randomBuildings:FindFirstChild("GeneralStore")
		if generalStore then
			local zombiePart = generalStore:FindFirstChild("StandaloneZombiePart")
			if zombiePart then
				generalStoreZombiesFolder = zombiePart:FindFirstChild("Zombies")
			end
		end
	end

	local baseplateAnimalsFolder = nil
	local baseplates = workspace:FindFirstChild("Baseplates")
	if baseplates then
		local children = baseplates:GetChildren()
		if #children >= 2 then
			local second = children[2]
			if second:FindFirstChild("CenterBaseplate") then
				baseplateAnimalsFolder = second.CenterBaseplate:FindFirstChild("Animals")
			end
		end
	end

	local nightEnemiesFolder = safeWait({"NightEnemies"})

	local folders = {
		{folder = safeWait({"RuntimeItems"}), forceRefresh = true},
		{folder = safeWait({"RuntimeEnemies"}), forceRefresh = false},
		{folder = safeWait({"RuntimeEntities"}), forceRefresh = false},
		{folder = safeWait({"RandomBuildings", "GunsmithDestroyed", "StandaloneZombiePart", "Zombies"}), forceRefresh = false},
		{folder = generalStoreZombiesFolder, forceRefresh = false},
		{folder = baseplateAnimalsFolder, forceRefresh = false},
		{folder = nightEnemiesFolder, forceRefresh = false}
	}

	local connections = {}
	local highlightThread

	local function applyHighlight(model, force)
		if not model:IsA("Model") then return end
		if not model:FindFirstChildOfClass("Humanoid") then return end

		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
		if not part then return end

		local distance = (hrp.Position - part.Position).Magnitude
		if distance > 50 then
			removeHighlight(model)
			return
		end

		local existing = model:FindFirstChildOfClass("Highlight")
		if existing and force then
			existing:Destroy()
			existing = nil
		end

		if not existing then
			local highlight = Instance.new("Highlight")
			highlight.FillColor = Color3.fromRGB(255, 255, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.5
			highlight.Parent = model
		end
	end

	local function removeHighlight(model)
		local highlight = model:FindFirstChildOfClass("Highlight")
		if highlight then
			highlight:Destroy()
		end
	end

	if state then
		for _, entry in ipairs(folders) do
			local folder = entry.folder
			local force = entry.forceRefresh
			if folder then
				for _, model in ipairs(folder:GetDescendants()) do
					applyHighlight(model, force)
				end

				local connection = folder.DescendantAdded:Connect(function(model)
					if highlightsEnabled and model:IsA("Model") then
						applyHighlight(model, force)
					end
				end)

				table.insert(connections, connection)
			end
		end

		-- เพิ่ม loop ตรวจสอบตลอดเวลา
		highlightThread = task.spawn(function()
			while highlightsEnabled do
				local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp then
					for _, entry in ipairs(folders) do
						local folder = entry.folder
						local force = entry.forceRefresh
						if folder then
							for _, model in ipairs(folder:GetDescendants()) do
								if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
									applyHighlight(model, force)
								end
							end
						end
					end
				end
				task.wait(0.5)
			end
		end)

	else
		for _, entry in ipairs(folders) do
			if entry.folder then
				for _, model in ipairs(entry.folder:GetDescendants()) do
					removeHighlight(model)
				end
			end
		end

		for _, conn in ipairs(connections) do
			conn:Disconnect()
		end
		connections = {}

		if highlightThread then
			task.cancel(highlightThread)
			highlightThread = nil
		end
	end
end)

local autoPickupEnabled = false
local autoPickupThread
local itemAddedConnection

Section:NewToggle("Auto Pickup", "Open to Automatically collect items nearby", function(state)
	autoPickupEnabled = state

	if state then
		local PICKUP_RADIUS = 50
		local CHECK_INTERVAL = 0.2

		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")

		local player = Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")

		local RuntimeItems = workspace:WaitForChild("RuntimeItems")
		local StoreItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem")

		local function tryPickup(item)
			if not item:IsA("Model") then return end

			local function getUsablePart(model)
				return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
			end

			local timeout = 3
			local timer = 0
			local part = getUsablePart(item)
			while not part and timer < timeout do
				task.wait(0.1)
				timer += 0.1
				part = getUsablePart(item)
			end

			if part then
				local distance = (hrp.Position - part.Position).Magnitude
				if distance <= PICKUP_RADIUS then
					local args = {
						[1] = item
					}
					StoreItemRemote:FireServer(unpack(args))
				end
			end
		end

		autoPickupThread = task.spawn(function()
			while autoPickupEnabled do
				for _, item in ipairs(RuntimeItems:GetChildren()) do
					tryPickup(item)
				end
				task.wait(CHECK_INTERVAL)
			end
		end)

		itemAddedConnection = RuntimeItems.ChildAdded:Connect(function(item)
			task.spawn(function()
				tryPickup(item)
			end)
		end)

	else
		autoPickupEnabled = false
		print("Auto Pickup: OFF")

		if itemAddedConnection then
			itemAddedConnection:Disconnect()
			itemAddedConnection = nil
		end
	end
end)

local Tab = Window:NewTab("Display")
local Section = Tab:NewSection("FOG")

local lighting = game:GetService("Lighting")
local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")

atmosphere.Density = 0.25

Section:NewSlider("FOG", "0 = NOFOG", 25, 0, function(value)
	local actualDensity = value / 100

	local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
		atmosphere.Density = actualDensity
	end
end)

local Section = Tab:NewSection("Brightness")

local Light = game:GetService("Lighting").ColorCorrection

Light.Brightness = 0
Light.Contrast = 0

Section:NewSlider("Lighting Value", "0 = Normal", 100, 0, function(value)
	local actualLight = value / 100

	if Light then
		Light.Brightness = actualLight
		Light.Contrast = actualLight
	end
end)