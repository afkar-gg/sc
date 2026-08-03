-- https://www.roblox.com/games/18667984660/Flex-Your-FPS-And-Ping
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")

local meow = ReplicatedStorage:WaitForChild("meow", 10)
local nya  = ReplicatedStorage:WaitForChild("nya",  10)

if not meow or not nya then
    warn("[fakestats] Could not find remotes")
    return
end

local FAKE_FPS = 9999        -- FPS to display on your head (max is 3500, lowest is 1)
local FAKE_MEM = 9000000         -- Memory in MB shown on your head (max is 8GB, lowest is 512MB) 
local FAKE_GFX = Enum.SavedQualitySetting.Automatic  -- graphics quality level (not sure what's for but its there)
-- Resolution and device info are passed through real values (not shown on head label), change it urself lol
local disconnected = 0
if getconnections then
    local ok, conns = pcall(getconnections, meow.OnClientEvent)
    if ok then
        for _, c in ipairs(conns) do
            local ok2, fn = pcall(function() return c.Function end)
            if ok2 and fn then
                local ok3, src = pcall(debug.info, fn, "s")
                if ok3 and src and src:find("ReplicatedFirst") then
                    c:Disconnect()
                    disconnected += 1
                    print("[fakestats] Disconnected real handler from", src)
                end
            end
        end
    end
end

if disconnected == 0 then
    warn("[fakestats] Could not find/disconnect the real meow handler, fake values will still be sent but real ones may also fire")
end

meow.OnClientEvent:Connect(function(p)
    if type(p) ~= "table" then return end
    local token = p.token
    if type(token) ~= "number" then return end

    if p.t == "metrics" then
        nya:FireServer({
            t     = "metrics",
            token = token,
            fps   = FAKE_FPS,
            gfx   = UserSettings():GetService("UserGameSettings").SavedQualityLevel,
            mem   = FAKE_MEM,
            res   = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0),
        })
        print("[fakestats] Sent fake metrics — fps:", FAKE_FPS, "mem:", FAKE_MEM)

    elseif p.t == "device" then
        local v6 = TextService:GetTextSize(utf8.char(65535), 16, "SourceSans", Vector2.one * 1000)
        local v7 = TextService:GetTextSize(utf8.char(63743), 16, "SourceSans", Vector2.one * 1000)
        nya:FireServer({
            t     = "device",
            token = token,
            tbl   = {
                A = UserInputService.VREnabled,
                B = GuiService:IsTenFootInterface(),
                C = GuiService.IsWindows,
                D = getfenv().version(),
                E = UserInputService.GyroscopeEnabled or UserInputService.AccelerometerEnabled,
                F = UserInputService.TouchEnabled,
                G = UserInputService.KeyboardEnabled,
                H = UserInputService.MouseEnabled,
                I = v6 ~= v7,
            },
        })
        print("[fakestats] Sent device info")
    end
end)

print("[fakestats] Active! faking FPS=" .. FAKE_FPS .. " MEM=" .. FAKE_MEM .. "MB")
