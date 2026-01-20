
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
	Title = "Liber Sactum",
	Text = "Loading Script...",
	Duration = 6,
})

-- UI library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Executor detection from Script #1
local function getExecutor()
	if identifyexecutor then
		return identifyexecutor()
	elseif getexecutorname then
		return getexecutorname()
	else
		return "Unknown"
	end
end

local executor = string.lower(getExecutor())
local isPC = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled

if string.find(executor, "xeno") or string.find(executor, "solara") then
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Ass Executor Detected",
			Text = "Terrible Executor detected.\nPlease use a better executor.",
			Duration = 6,
		})
	end)
	return
end

if isPC then
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Note :",
			Text = "PC executor is not widely supported.\nUse a good executor and don't using Xeno or solara executor.",
			Duration = 5,
		})
	end)
end

-- Theme (keep Script #2 base but can be themed later)
WindUI:AddTheme({
	Name = "My Theme",
	Accent = Color3.fromHex("#18181b"),
	Background = Color3.fromHex("#101010"),
	Outline = Color3.fromHex("#FFFFFF"),
	Text = Color3.fromHex("#FFFFFF"),
	Placeholder = Color3.fromHex("#7a7a7a"),
	Button = Color3.fromHex("#52525b"),
	Icon = Color3.fromHex("#a1a1aa"),
})
WindUI:SetTheme("My Theme")

local Window = WindUI:CreateWindow({
	Title = "Liber Sactum",
	Icon = "door-open",
	Author = "discord.gg/hWmdVSzU",
	Folder = "Liber Hub",
	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(560, 350),
	MaxSize = Vector2.new(850, 560),
	Transparent = true,
	Theme = "Dark",
	Resizable = true,
	SideBarWidth = 200,
	BackgroundImageTransparency = 0.42,
	HideSearchBar = true,
	ScrollBarEnabled = false,
	Background = "rbxassetid://",
})

Window:SetToggleKey(Enum.KeyCode.RightControl)

local Notify = function(t, c, d)
	WindUI:Notify({ Title = t, Content = c, Duration = d or 5 })
end

-- =========================================================
-- Tabs (ported structure from Script #1)
-- =========================================================
local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local LocalPlayerTab = Window:Tab({ Title = "LocalPlayer", Icon = "user" })
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- Character update handler
player.CharacterAdded:Connect(function(char)
	character = char
end)

-- =========================================================
-- Script #1 functionality moved in (EXCEPT Anti Void)
-- =========================================================

-- ============================================
-- MONEY FARM FUNCTIONALITY
-- ============================================
getgenv().MoneyFarmEnabled = false
local moneyFarmConnection = nil

local function touchPart(part)
	if not part or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local hrp = player.Character.HumanoidRootPart
	firetouchinterest(hrp, part, 0)
	task.wait(0.1)
	firetouchinterest(hrp, part, 1)
end

local function startMoneyFarm()
	if moneyFarmConnection then
		moneyFarmConnection:Disconnect()
	end

	moneyFarmConnection = RunService.Heartbeat:Connect(function()
		if not getgenv().MoneyFarmEnabled then
			return
		end

		local trophy = Workspace:FindFirstChild("Trophy")
		if trophy then
			touchPart(trophy)
		end
	end)
end

local function stopMoneyFarm()
	if moneyFarmConnection then
		moneyFarmConnection:Disconnect()
		moneyFarmConnection = nil
	end
end

-- ============================================
-- ANTI-KNOCKBACK FUNCTIONALITY
-- ============================================
getgenv().AntiKnockbackEnabled = false
local antiKnockbackConnection = nil
local lastHorizontalVelocity = Vector3.new()

local akFreezeUntil = 0
local akFreezeCooldownUntil = 0
local AK_FREEZE_TIME = 0.12
local AK_FREEZE_COOLDOWN = 0.20
local AK_SPEED_MULTIPLIER = 1.35

local function startAntiKnockback()
	if antiKnockbackConnection then
		antiKnockbackConnection:Disconnect()
	end

	antiKnockbackConnection = RunService.Heartbeat:Connect(function()
		if not getgenv().AntiKnockbackEnabled then
			return
		end

		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local vel = hrp.Velocity
			local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
			local hum = char:FindFirstChildOfClass("Humanoid")

			local now = tick()
			if now < akFreezeUntil then
				hrp.Velocity = Vector3.new(0, vel.Y, 0)
				lastHorizontalVelocity = Vector3.new()
				return
			end

			if hum and hum.PlatformStand then
				return
			end

			local walkSpeed = (hum and hum.WalkSpeed) or 16
			local speedThreshold = math.max(22, walkSpeed * AK_SPEED_MULTIPLIER)
			if horizontalVel.Magnitude > speedThreshold and now > akFreezeCooldownUntil then
				akFreezeUntil = now + AK_FREEZE_TIME
				akFreezeCooldownUntil = akFreezeUntil + AK_FREEZE_COOLDOWN
				hrp.Velocity = Vector3.new(0, vel.Y, 0)
				lastHorizontalVelocity = Vector3.new()
				return
			end

			if hum and (hum:GetState() == Enum.HumanoidStateType.Freefall or hum.FloorMaterial == Enum.Material.Air) then
				if horizontalVel.Magnitude > 30 then
					hrp.Velocity = Vector3.new(0, vel.Y, 0)
					lastHorizontalVelocity = Vector3.new()
					return
				end
			end

			if horizontalVel.Magnitude > 30 then
				lastHorizontalVelocity = lastHorizontalVelocity:Lerp(horizontalVel.Unit * 25, 0.3)
			else
				lastHorizontalVelocity = horizontalVel
			end

			hrp.Velocity = Vector3.new(lastHorizontalVelocity.X, vel.Y, lastHorizontalVelocity.Z)
		end
	end)
end

local function stopAntiKnockback()
	if antiKnockbackConnection then
		antiKnockbackConnection:Disconnect()
		antiKnockbackConnection = nil
	end
	lastHorizontalVelocity = Vector3.new()
end

-- ============================================
-- AUTO AIM FUNCTIONALITY (LOCK-ON)
-- ============================================
getgenv().AutoAimEnabled = false
local autoAimThread

local function getShootNumberValue(playerName)
	local shootNumberFolder = Workspace:FindFirstChild("ShootNumberLineUp") or Workspace:FindFirstChild("jogadoresVivos")
	if not shootNumberFolder then
		return nil
	end
	local playerData = shootNumberFolder:FindFirstChild(playerName)
	if not playerData then
		return nil
	end
	if typeof(playerData.Value) ~= "nil" then
		return tonumber(playerData.Value)
	end
	return nil
end

local function getMyShootNumber()
	return getShootNumberValue(player.Name) or 0
end

local function getClosestPlayer()
	local closestPlayer
	local shortestDistance = math.huge
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character.Parent then
			local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
			if targetHrp and humanoid and humanoid.Health > 0 then
				local distance = (hrp.Position - targetHrp.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = plr.Character
				end
			end
		end
	end

	return closestPlayer
end

local function getAimThreatTarget()
	local myChar = player.Character
	if not myChar then
		return nil
	end
	local myHrp = myChar:FindFirstChild("HumanoidRootPart")
	if not myHrp then
		return nil
	end

	local myShoot = getMyShootNumber()
	local myPos = myHrp.Position
	local bestThreat
	local bestThreatDist = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character.Parent then
			local enemyChar = plr.Character
			local enemyHrp = enemyChar:FindFirstChild("HumanoidRootPart")
			local enemyTorso = enemyChar:FindFirstChild("Torso") or enemyChar:FindFirstChild("UpperTorso") or enemyHrp
			local enemyHum = enemyChar:FindFirstChildOfClass("Humanoid")

			if enemyHrp and enemyTorso and enemyHum and enemyHum.Health > 0 then
				local enemyShoot = getShootNumberValue(plr.Name) or 0
				if enemyShoot > myShoot then
					local look = enemyTorso.CFrame.LookVector
					local origin = enemyHrp.Position
					local toMe = myPos - origin
					local projection = toMe:Dot(look)
					if projection > 0 then
						local closestPoint = origin + (look * projection)
						local missDist = (myPos - closestPoint).Magnitude
						if missDist <= 3 then
							local dist = (myPos - enemyHrp.Position).Magnitude
							if dist < bestThreatDist then
								bestThreatDist = dist
								bestThreat = enemyChar
							end
						end
					end
				end
			end
		end
	end

	return bestThreat
end

local function aimAtTarget(targetChar)
	local myChar = player.Character
	if not myChar then
		return
	end
	local hrp = myChar:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHrp then
		return
	end

	local targetPos = targetHrp.Position
	local flatTarget = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
	local desired = CFrame.lookAt(hrp.Position, flatTarget)
	hrp.CFrame = desired
end

local function aimLogic()
	local threat = getAimThreatTarget()
	if threat then
		aimAtTarget(threat)
		return
	end
	local closest = getClosestPlayer()
	if closest then
		aimAtTarget(closest)
	end
end

local function startAutoAim()
	if autoAimThread then
		return
	end
	autoAimThread = RunService.Heartbeat:Connect(aimLogic)
end

local function stopAutoAim()
	getgenv().AutoAimEnabled = false
	if autoAimThread then
		autoAimThread:Disconnect()
		autoAimThread = nil
	end
end

-- ============================================
-- ESP (Script #1 respawn-safe Billboard ESP)
-- ============================================
local espContainer
local function ensureESPContainer()
	if espContainer and espContainer.Parent then
		return
	end
	espContainer = Workspace:FindFirstChild("FoxnameESPContainer")
	if not espContainer then
		espContainer = Instance.new("Folder")
		espContainer.Name = "FoxnameESPContainer"
	end
	espContainer.Parent = Workspace
end

getgenv().ESPNameEnabled = false
getgenv().ESPShootNumberEnabled = false
getgenv().ShowAllPlayerEnabled = false

local Event = game:GetService("ReplicatedStorage"):FindFirstChild("invisivel")
if Event then
	Event.OnClientEvent:Connect(function(value)
		if getgenv().ShowAllPlayerEnabled and value == true then
			task.defer(function()
				firesignal(Event.OnClientEvent, false)
			end)
		end
	end)
end

local espObjects = {}
local espMonitorConnection
ensureESPContainer()

local function isESPActive()
	return getgenv().ESPNameEnabled or getgenv().ESPShootNumberEnabled
end

local function removeESPEntry(plr)
	local entry = espObjects[plr.UserId]
	if not entry then
		return
	end
	if entry.connection then
		entry.connection:Disconnect()
	end
	if entry.billboard then
		entry.billboard:Destroy()
	end
	espObjects[plr.UserId] = nil
end

local function createESPEntry(plr)
	if plr == player then
		return
	end
	local currentChar = plr.Character
	if not currentChar then
		return
	end
	local humanoid = currentChar:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = currentChar:FindFirstChild("HumanoidRootPart")
	if not humanoid or not humanoidRootPart then
		return
	end

	local existing = espObjects[plr.UserId]
	if existing then
		if existing.character ~= currentChar then
			removeESPEntry(plr)
		else
			return
		end
	end

	ensureESPContainer()

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = humanoidRootPart
	billboard.Size = UDim2.new(0, 120, 0, 45)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = espContainer

	local shootNumberLabel = Instance.new("TextLabel")
	shootNumberLabel.Size = UDim2.new(1, 0, 0.33, 0)
	shootNumberLabel.Position = UDim2.new(0, 0, 0, 0)
	shootNumberLabel.BackgroundTransparency = 1
	shootNumberLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	shootNumberLabel.TextStrokeTransparency = 0.2
	shootNumberLabel.TextScaled = true
	shootNumberLabel.Font = Enum.Font.SourceSansBold
	shootNumberLabel.Parent = billboard
	shootNumberLabel.Visible = getgenv().ESPShootNumberEnabled

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
	nameLabel.Position = UDim2.new(0, 0, 0.33, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = plr.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0.2
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.Parent = billboard
	nameLabel.Visible = getgenv().ESPNameEnabled

	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
	distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	distanceLabel.TextStrokeTransparency = 0.2
	distanceLabel.TextScaled = true
	distanceLabel.Font = Enum.Font.SourceSans
	distanceLabel.Parent = billboard
	distanceLabel.Visible = getgenv().ESPNameEnabled

	local connection = RunService.RenderStepped:Connect(function()
		if plr.Character ~= currentChar then
			removeESPEntry(plr)
			return
		end
		if not currentChar.Parent or not humanoidRootPart.Parent then
			removeESPEntry(plr)
			return
		end

		local hum = currentChar:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			removeESPEntry(plr)
			return
		end

		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
			distanceLabel.Text = string.format("%.1f", distance)
		end

		if getgenv().ESPShootNumberEnabled then
			local shootNumberFolder = Workspace:FindFirstChild("ShootNumberLineUp") or Workspace:FindFirstChild("jogadoresVivos")
			if shootNumberFolder then
				local playerData = shootNumberFolder:FindFirstChild(plr.Name)
				if playerData and playerData.Value then
					shootNumberLabel.Text = tostring(playerData.Value)
				else
					shootNumberLabel.Text = "N/A"
				end
			else
				shootNumberLabel.Text = "N/A"
			end
		end

		shootNumberLabel.Visible = getgenv().ESPShootNumberEnabled
		local nameVisible = getgenv().ESPNameEnabled
		nameLabel.Visible = nameVisible
		distanceLabel.Visible = nameVisible
	end)

	espObjects[plr.UserId] = {
		character = currentChar,
		billboard = billboard,
		shootNumberLabel = shootNumberLabel,
		nameLabel = nameLabel,
		distanceLabel = distanceLabel,
		connection = connection,
	}
end

local function enableESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			createESPEntry(plr)
		end
	end
end

local function disableESP()
	for userId, _ in pairs(espObjects) do
		local plr = Players:GetPlayerByUserId(userId)
		if plr then
			removeESPEntry(plr)
		end
	end
	espObjects = {}
end

local function startESPMonitoring()
	if espMonitorConnection then
		return
	end

	espMonitorConnection = RunService.Heartbeat:Connect(function()
		if not isESPActive() and not getgenv().ShowAllPlayerEnabled then
			return
		end

		for userId, entry in pairs(espObjects) do
			local plr = Players:GetPlayerByUserId(userId)
			if (not plr) or plr == player then
				if plr then
					removeESPEntry(plr)
				end
				espObjects[userId] = nil
			else
				local c = plr.Character
				local hum = c and c:FindFirstChildOfClass("Humanoid")
				local hrp = c and c:FindFirstChild("HumanoidRootPart")
				if (not c) or (entry.character ~= c) or (not hum) or (hum.Health <= 0) or (not hrp) then
					removeESPEntry(plr)
				end
			end
		end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not espObjects[plr.UserId] then
					createESPEntry(plr)
				end
			end
		end
	end)
end

local function stopESPMonitoring()
	if espMonitorConnection then
		espMonitorConnection:Disconnect()
		espMonitorConnection = nil
	end
end

Players.PlayerAdded:Connect(function(plr)
	if plr == player then
		return
	end
	plr.CharacterAdded:Connect(function()
		if isESPActive() or getgenv().ShowAllPlayerEnabled then
			task.wait(0.35)
			removeESPEntry(plr)
			createESPEntry(plr)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	removeESPEntry(plr)
end)

-- ============================================
-- LOCALPLAYER: Fly, WalkSpeed, JumpPower
-- ============================================
local flyActive = false
local flyConnection
local flyBodyGyro, flyBodyVelocity
local flySpeed = 50

local function startFly()
	if flyActive then
		return
	end
	local char = player.Character
	if not char then
		return
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then
		return
	end

	flyActive = true
	humanoid.PlatformStand = true

	flyBodyGyro = Instance.new("BodyGyro")
	flyBodyGyro.P = 9e4
	flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBodyGyro.CFrame = hrp.CFrame
	flyBodyGyro.Parent = hrp

	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBodyVelocity.Velocity = Vector3.new()
	flyBodyVelocity.Parent = hrp

	flyConnection = RunService.Heartbeat:Connect(function()
		if not flyActive then
			return
		end
		if not player.Character or not hrp.Parent then
			return
		end

		local camera = Workspace.CurrentCamera
		local function isDown(key)
			return UserInputService:IsKeyDown(key)
		end

		local camCF = camera.CFrame
		local camForward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
		if camForward.Magnitude < 0.001 then
			camForward = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
		end
		camForward = camForward.Magnitude > 0 and camForward.Unit or Vector3.new(0, 0, -1)
		local camRight = Vector3.new(-camForward.Z, 0, camForward.X)

		local desired = Vector3.new()
		if humanoid.MoveDirection.Magnitude > 0 then
			desired = humanoid.MoveDirection.Unit
		else
			if isDown(Enum.KeyCode.W) then
				desired += camForward
			end
			if isDown(Enum.KeyCode.S) then
				desired -= camForward
			end
			if isDown(Enum.KeyCode.A) then
				desired -= camRight
			end
			if isDown(Enum.KeyCode.D) then
				desired += camRight
			end
			desired = desired.Magnitude > 0 and desired.Unit or Vector3.new()
		end

		local velocity = desired * flySpeed

		-- Repaired from Script #1's corrupted line
		if desired.Magnitude > 0 then
			local camLook = camCF.LookVector
			local verticalFromLook = camLook.Y * flySpeed * desired:Dot(camForward)
			velocity = Vector3.new(velocity.X, verticalFromLook, velocity.Z)
		end

		if isDown(Enum.KeyCode.Space) then
			velocity += Vector3.new(0, flySpeed * 0.5, 0)
		end
		if isDown(Enum.KeyCode.LeftShift) then
			velocity -= Vector3.new(0, flySpeed * 0.5, 0)
		end

		flyBodyVelocity.Velocity = velocity
		flyBodyGyro.CFrame = camera.CFrame
	end)
end

local function stopFly()
	flyActive = false
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	if flyBodyGyro then
		flyBodyGyro:Destroy()
		flyBodyGyro = nil
	end
	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end

	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end
end

-- =========================================================
-- UI: Main Tab
-- =========================================================
MainTab:Divider()
MainTab:Section({ Title = "Main Function", TextXAlignment = "Center", TextSize = 20, Opened = true })
MainTab:Divider()

MainTab:Toggle({
	Title = "Money Farm",
	Value = false,
	Callback = function(v)
		getgenv().MoneyFarmEnabled = v
		if v then
			Notify("Money Farm", "Money farm enabled", 2)
			startMoneyFarm()
		else
			Notify("Money Farm", "Money farm disabled", 2)
			stopMoneyFarm()
		end
	end,
})

MainTab:Divider()

MainTab:Toggle({
	Title = "Anti-Knockback",
	Value = false,
	Callback = function(v)
		getgenv().AntiKnockbackEnabled = v
		if v then
			Notify("Anti-Knockback", "Anti-knockback enabled", 2)
			startAntiKnockback()
		else
			Notify("Anti-Knockback", "Anti-knockback disabled", 2)
			stopAntiKnockback()
		end
	end,
})

MainTab:Divider()

MainTab:Toggle({
	Title = "Auto Aim",
	Value = false,
	Callback = function(v)
		getgenv().AutoAimEnabled = v
		if v then
			Notify("Auto Aim", "Auto aim enabled", 2)
			startAutoAim()
		else
			Notify("Auto Aim", "Disabled", 2)
			stopAutoAim()
		end
	end,
})

MainTab:Divider()

-- =========================================================
-- UI: LocalPlayer Tab
-- =========================================================
LocalPlayerTab:Divider()

LocalPlayerTab:Slider({
	Title = "Walk Speed",
	Step = 1,
	Value = { Min = 16, Max = 200, Default = 16 },
	Callback = function(v)
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
		end
	end,
})

LocalPlayerTab:Slider({
	Title = "Jump Power",
	Step = 1,
	Value = { Min = 50, Max = 300, Default = 50 },
	Callback = function(v)
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
		end
	end,
})

LocalPlayerTab:Button({
	Title = "Reset Character",
	Callback = function()
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:BreakJoints()
			Notify("Reset", "Character reset", 2)
		end
	end,
})

LocalPlayerTab:Divider()

LocalPlayerTab:Toggle({
	Title = "Fly",
	Value = false,
	Callback = function(v)
		if v then
			Notify("Fly", "Fly enabled", 2)
			startFly()
		else
			Notify("Fly", "Fly disabled", 2)
			stopFly()
		end
	end,
})

LocalPlayerTab:Slider({
	Title = "Fly Speed",
	Step = 1,
	Value = { Min = 10, Max = 200, Default = 50 },
	Callback = function(v)
		flySpeed = v
	end,
})

LocalPlayerTab:Divider()

-- =========================================================
-- UI: ESP Tab
-- =========================================================
ESPTab:Divider()
ESPTab:Section({ Title = "ESP Options", TextXAlignment = "Center", TextSize = 20, Opened = true })
ESPTab:Divider()

ESPTab:Toggle({
	Title = "Show All Player",
	Value = false,
	Callback = function(v)
		getgenv().ShowAllPlayerEnabled = v
		if v then
			Notify("Show All Player", "Enabled", 2)
			if Event then
				firesignal(Event.OnClientEvent, false)
			end
			if next(espObjects) == nil then
				enableESP()
			end
			startESPMonitoring()
		else
			Notify("Show All Player", "Disabled", 2)
			if not getgenv().ESPNameEnabled and not getgenv().ESPShootNumberEnabled then
				disableESP()
				stopESPMonitoring()
			end
		end
	end,
})

ESPTab:Toggle({
	Title = "Name & Distance",
	Value = false,
	Callback = function(v)
		getgenv().ESPNameEnabled = v
		if v then
			Notify("ESP", "Names enabled", 2)
			if next(espObjects) == nil then
				enableESP()
			end
			startESPMonitoring()
		else
			Notify("ESP", "Names disabled", 2)
			if not getgenv().ShowAllPlayerEnabled and not getgenv().ESPShootNumberEnabled then
				disableESP()
				stopESPMonitoring()
			end
		end
	end,
})

ESPTab:Toggle({
	Title = "Shoot Number Line Up",
	Value = false,
	Callback = function(v)
		getgenv().ESPShootNumberEnabled = v
		if v then
			Notify("ESP", "Shoot Number enabled", 2)
			if next(espObjects) == nil then
				enableESP()
			end
			startESPMonitoring()
		else
			Notify("ESP", "Shoot Number disabled", 2)
			if not getgenv().ShowAllPlayerEnabled and not getgenv().ESPNameEnabled then
				disableESP()
				stopESPMonitoring()
			end
		end
	end,
})

ESPTab:Divider()

-- =========================================================
-- Info Tab (Discord link updated + credits updated)
-- =========================================================
InfoTab:Divider()
InfoTab:Section({ Title = "Discord", TextXAlignment = "Center", TextSize = 17, Opened = true })
InfoTab:Divider()
InfoTab:Section({ Title = "report bug at Discord", TextXAlignment = "Center", TextSize = 17, Opened = true })
InfoTab:Divider()

InfoTab:Button({
	Title = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/hWmdVSzU")
	end,
})

InfoTab:Divider()
InfoTab:Section({ Title = "Developer", TextXAlignment = "Center", TextSize = 17, Opened = true })
InfoTab:Divider()

InfoTab:Paragraph({
	Title = "Afkar",
	Desc = "Dex and owner script",
	Image = "https://raw.githubusercontent.com/afkar-gg/bot-proxy/refs/heads/main/IMG-20250523-WA0002.jpg",
	ImageSize = 30,
	Thumbnail = "",
	ThumbnailSize = 0,
	Locked = false,
})

InfoTab:Paragraph({
	Title = "Duck",
	Desc = "Owner",
	Image = "https://media.discordapp.net/attachments/1457750095431991359/1463199427383525418/Server_Avatar-1.png",
	ImageSize = 30,
	Thumbnail = "",
	ThumbnailSize = 0,
	Locked = false,
})

-- =========================================================
-- Settings Tab (ported from Script #1: theme + background + keybind)
-- =========================================================
local themeValues = {}
for name in pairs(WindUI:GetThemes()) do
	table.insert(themeValues, name)
end

SettingsTab:Dropdown({
	Title = "Select Theme",
	Values = themeValues,
	Value = themeValues[1],
	Callback = function(option)
		_G.ThemeSelect = option
	end,
})

SettingsTab:Button({
	Title = "Apply Theme",
	Locked = false,
	Callback = function()
		if _G.ThemeSelect then
			WindUI:SetTheme(_G.ThemeSelect)
			Notify("Theme Applied", "Now using theme: " .. _G.ThemeSelect, 2)
		else
			Notify("Error", "No theme selected!", 2)
		end
	end,
})

SettingsTab:Divider()
SettingsTab:Section({ Title = "Background Select", TextXAlignment = "Center", TextSize = 17, Opened = true })
SettingsTab:Divider()

getgenv().BVaildSelect = {
	["No Background"] = "rbxassetid://0",
	["Furina"] = "rbxassetid://80115246253301",
	["Furina1"] = "rbxassetid://84672393253807",
	["Furina2"] = "rbxassetid://133222171266319",
}

local firstRun = true
SettingsTab:Dropdown({
	Title = "Select Background",
	Values = { "No Background", "Furina", "Furina1", "Furina2" },
	Value = "No Background",
	Callback = function(option)
		if firstRun then
			firstRun = false
			return
		end
		_G.BackgroundImage = getgenv().BVaildSelect[option]
		Window:SetBackgroundImage(_G.BackgroundImage)
	end,
})

SettingsTab:Divider()
SettingsTab:Section({ Title = "Custom Background", TextXAlignment = "Center", TextSize = 17, Opened = true })
SettingsTab:Divider()

SettingsTab:Input({
	Title = "Background ID",
	Type = "Input",
	Placeholder = "135163165559760",
	Callback = function(input)
		if input ~= "" then
			_G.BackgroundImage = "rbxassetid://" .. input
			Window:SetBackgroundImage(_G.BackgroundImage)
		end
	end,
})

SettingsTab:Keybind({
	Title = "Keybind off gui",
	Value = "G",
	Callback = function(v)
		Window:SetToggleKey(Enum.KeyCode[v])
	end,
})

MainTab:Select()
