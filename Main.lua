function hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy(code)res=''for i in ipairs(code)do res=res..string.char(code[i]/105)end return res end 


-- ==========================================================
-- FLOW HUB V5 - BLADE BALL OPTIMIZED AUTO PARRY & STAFF ENGINE
-- ==========================================================

repeat task.wait() until game:IsLoaded()

-- Services
local UIS = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,12075,10605,11970,7665,11550,11760,12285,12180,8715,10605,11970,12390,11025,10395,10605}))
local TS  = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,12495,10605,10605,11550,8715,10605,11970,12390,11025,10395,10605}))
local Players = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,11340,10185,12705,10605,11970,12075}))
local CoreGui = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11655,11970,10605,7455,12285,11025}))
local RunService = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,12285,11550,8715,10605,11970,12390,11025,10395,10605}))
local Stats = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,12180,12075}))
local ReplicatedStorage = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11760,11340,11025,10395,10185,12180,10605,10500,8715,12180,11655,11970,10185,10815,10605}))
local Workspace = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9135,11655,11970,11235,12075,11760,10185,10395,10605}))

local LocalPlayer = Players.LocalPlayer

-- Configuration & State
local Config = {
    TextColor = Color3.fromRGB(0, 0, 0),
    AccentColor = Color3.fromRGB(255, 255, 255),
    UiTransparency = 0.2,
    
    -- AutoParry Config
    AutoParry = false,
    AntiDoubleParry = true,
    AutoSpam = false,
    ManualSpamActive = false,
    TPParry = false,
    
    -- Curve & Distance Settings
    CurveMode = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,10185,11445,10605,11970,10185}), -- Options: Camera, Random, High, Backwards, Slow, Accelerated, Target
    Prediction = 50,      -- Range 1 to 100
    ParryDistance = 25,   -- Range 1 to 100
    CPS = 20,             -- Range 5 to 250
    
    -- Staff Detection Config
    StaffDetection = false,
    StaffAction = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,12180,11025,10710,12705}), -- Options: Notify, Kick
    
    -- Movement & Hacks
    MovementBypass = false,
    WalkSpeed = 16,
    
    -- Visuals & Unlocks
    KorbloxHeadless = false,
    SkinChanger = false,
    UnlockEmotes = false,
    UnlockSkins = false,
    UnlockGamepasses = false,
    
    -- Others
    AntiAFK = false,
    FPSBooster = false
}

-- Ball / Game Cache
local BallInfo = {
    Object = nil,
    Type = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605}),
    Speed = 0,
    Target = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605}),
    Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,12180,11025,11655,11550,10185,11970,12705}),
    IsTarget = false,
    Distance = 0,
    PlayerPos = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9240,6090,3360,5040,4620,3360,9345,6090,3360,5040,4620,3360,9450,6090,3360,5040}),
    Ping = 0
}

local LastParryTime = 0
local LastSpamTime = 0
local hasParriedThisIncoming = false
local hasTPParriedThisTarget = false
local lastTargetName = nil
local lastBallInstance = nil

-- Staff Groups & Roles Database
local StaffGroupIds = {
    13359205, -- Blade Ball Official Group
    32392369  -- Staff / Developer Group
}

-- Network Ping Getter
local function GetPing()
    local ping = 0.05
    pcall(function()
        ping = Stats.Network.ServerStatsItem[hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7140,10185,12180,10185,3360,8400,11025,11550,10815})]:GetValue() / 1000
    end)
    return ping
end

-- ==================== STAFF DETECTION SYSTEM ====================
local function IsPlayerStaff(player)
    if not player or player == LocalPlayer then return false end
    
    for _, groupId in ipairs(StaffGroupIds) do
        local successRank, rank = pcall(function()
            return player:GetRankInGroup(groupId)
        end)
        if successRank and rank and rank >= 100 then
            return true, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10185,11550,11235,3360,7560,11025,10815,10920,3360,4200}) .. tostring(rank) .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({4305})
        end
        
        local successRole, role = pcall(function()
            return player:GetRoleInGroup(groupId)
        end)
        if successRole and role then
            local rLower = role:lower()
            if rLower:find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10185,10500,11445,11025,11550})) or rLower:find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11445,11655,10500})) or rLower:find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12075,12180,10185,10710,10710})) or rLower:find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10500,10605,12390})) or rLower:find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11655,12495,11550,10605,11970})) then
                return true, role
            end
        end
    end
    
    return false, nil
end

local function TriggerStaffAction(staffPlayer, roleInfo)
    if not Config.StaffDetection then return end
    
    if Config.StaffAction == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7875,11025,10395,11235}) then
        LocalPlayer:Kick(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9555,7350,7980,8295,9135,3360,7560,8925,6930,9765,3360,8715,12180,10185,10710,10710,3360,8610,11025,11340,10605,12390,10185,12180,11655,6090,3360}) .. staffPlayer.Name .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,4200}) .. (roleInfo or hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710})) .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({4305}))
    else
        pcall(function()
            game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,11970,12180,10605,11970,7455,12285,11025})):SetCore(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,11550,10500,8190,11655,12180,11025,10710,11025,10395,10185,12180,11025,11655,11550}), {
                Title = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({23730,16170,16800,25095,19320,15015,3360,8715,8820,6825,7350,7350,3360,8610,7665,7980,7245,9030,6825,8820,8295,3465}),
                Text = staffPlayer.Name .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,4200}) .. (roleInfo or hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710})) .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({4305,3360,20475,17640,3360,11550,10605,11340,3360,12075,10605,11970,12390,10605,11970,3465}),
                Duration = 6
            })
        end)
    end
end

local function ScanCurrentStaff()
    if not Config.StaffDetection then return end
    for _, p in ipairs(Players:GetPlayers()) do
        local isStaff, role = IsPlayerStaff(p)
        if isStaff then
            TriggerStaffAction(p, role)
            break
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if Config.StaffDetection then
        local isStaff, role = IsPlayerStaff(p)
        if isStaff then
            TriggerStaffAction(p, role)
        end
    end
end)

-- ==================== TOKEN CAPTURE & REMOTE HOOK ====================
local _token
for _, Function in getgc(true) do
    if type(Function) ~= hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10710,12285,11550,10395,12180,11025,11655,11550}) or not debug.info(Function, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12075})):find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,8610,9345}), 1, true) then
        continue
    end

    for _, value in debug.getupvalues(Function) do
        if type(value) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10710,12285,11550,10395,12180,11025,11655,11550}) then
            _token = value
            break
        end
    end

    if _token then break end
end

local function _tokenize(_remote_uid)
    if not _token then return hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({}) end
    local time = tostring(math.floor(Workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,7665,8085,7245}))
    local characters = table.create(#time)

    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end

    return table.concat(characters)
end

local _reverted = {}
local _original = {}

local function _is_valid(args)
    return #args == 8 
        and type(args[2]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12075,12180,11970,11025,11550,10815}) 
        and type(args[3]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12075,12180,11970,11025,11550,10815}) 
        and type(args[4]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11550,12285,11445,10290,10605,11970}) 
        and typeof(args[5]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,7350,11970,10185,11445,10605}) 
        and type(args[6]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12180,10185,10290,11340,10605}) 
        and type(args[7]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12180,10185,10290,11340,10605}) 
        and type(args[8]) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10290,11655,11655,11340,10605,10185,11550})
end

local function _hook(remote)
    if not _reverted[remote] then
        local meta = getrawmetatable(remote)
        if meta and not _original[meta] then
            _original[meta] = true
            setreadonly(meta, false)

            local _old = meta.__index
            meta.__index = function(self, key)
                if (key == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11025,11970,10605,8715,10605,11970,12390,10605,11970}) and self:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180}))) or
                   (key == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11550,12390,11655,11235,10605,8715,10605,11970,12390,10605,11970}) and self:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550}))) then
                    return function(_, ...)
                        local _arguments = {...}
                        if _is_valid(_arguments) then
                            if not _reverted[self] then
                                _reverted[self] = _arguments
                            end
                        end
                        return _old(self, key)(_, unpack(_arguments))
                    end
                end
                return _old(self, key)
            end
            setreadonly(meta, true)
        end
    end
end

for _, _remote in pairs(ReplicatedStorage:GetDescendants()) do
    if _remote:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180})) or _remote:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550})) then
        _hook(_remote)
    end
end

-- Metatable WalkSpeed Spoof
local rawMeta = getrawmetatable(game)
if rawMeta then
    setreadonly(rawMeta, false)
    local oldIndex = rawMeta.__index
    local oldNewIndex = rawMeta.__newindex
    
    rawMeta.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500})) and key == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9135,10185,11340,11235,8715,11760,10605,10605,10500}) then
            return 16
        end
        return oldIndex(self, key)
    end)
    
    rawMeta.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and self:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500})) and key == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9135,10185,11340,11235,8715,11760,10605,10605,10500}) then
            return
        end
        return oldNewIndex(self, key, value)
    end)
    
    setreadonly(rawMeta, true)
end

-- ==================== TARGETING & PARRY PACKET ENGINE ====================
local function GetTargetNearCrosshair()
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closestChar = nil
    local shortestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
            local humanoid = player.Character:FindFirstChildOfClass(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500}))
            if humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestChar = player.Character
                    end
                end
            end
        end
    end

    return closestChar
end

local function SendParryPacket()
    if not next(_reverted) then return end
    
    local cameraCFrame = Workspace.CurrentCamera.CFrame
    local lookVector = cameraCFrame.LookVector
    
    if Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10185,11550,10500,11655,11445}) then
        lookVector = Vector3.new(math.random(-100, 100) / 100, math.random(-100, 100) / 100, math.random(-100, 100) / 100).Unit
    elseif Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,11025,10815,10920}) then
        lookVector = Vector3.new(lookVector.X, 0.8, lookVector.Z).Unit
    elseif Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,10395,11235,12495,10185,11970,10500,12075}) then
        lookVector = -lookVector
    elseif Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11340,11655,12495}) then
        lookVector = Vector3.new(lookVector.X, -0.5, lookVector.Z).Unit
    elseif Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,10395,10395,10605,11340,10605,11970,10185,12180,10605,10500}) then
        lookVector = Vector3.new(lookVector.X * 1.5, 0.1, lookVector.Z * 1.5).Unit
    elseif Config.CurveMode == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10185,11970,10815,10605,12180}) then
        local targetChar = GetTargetNearCrosshair()
        if targetChar and targetChar:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
            lookVector = (targetChar.HumanoidRootPart.Position - cameraCFrame.Position).Unit
        end
    end

    local parryCFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + lookVector)

    for _remote, _original_args in pairs(_reverted) do
        local _packet = {
            _original_args[1],
            _original_args[2],
            _tokenize(_original_args[2]),
            0.5,
            parryCFrame,
            {},
            {100, 100},
            false
        }
        
        pcall(function()
            if _remote:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180})) then
                _remote:FireServer(unpack(_packet))
            elseif _remote:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550})) then
                _remote:InvokeServer(unpack(_packet))
            end
        end)
    end
end

-- Cached Ball Finder Engine
local cachedBall = nil

local function GetBallInfo()
    if cachedBall and cachedBall.Parent and cachedBall:IsDescendantOf(Workspace) then
        return cachedBall, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,12180,10395,10920,3360,6930,10185,11340,11340})
    end

    cachedBall = nil
    local ballsFolder = Workspace:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,11340,11340,12075}))
    if ballsFolder then
        for _, b in ipairs(ballsFolder:GetChildren()) do
            if b:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10605,10185,11340,6930,10185,11340,11340})) or b:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815})) or b.Name:lower():find(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10290,10185,11340,11340})) then
                cachedBall = b
                return cachedBall, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,12180,10395,10920,3360,6930,10185,11340,11340})
            end
        end
    end

    return nil, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605})
end

-- ==================== UI SYSTEM ENGINE (FLOW HUB V5) ====================

local themeLeft = Color3.fromRGB(255, 255, 255)
local themeRight = Color3.fromRGB(255, 255, 255)

local trackingGradients = {}
local trackingTextLabels = {}

local img1 = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5145,5145,5460,5670,5880,5985,5250,5355,5460,5565,5145,5040,5460,5880,5460})

local function makeDraggable(gui, dragHandle)
    dragHandle = dragHandle or gui
    local dragging = false
    local dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function(input)
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function getGradientSequence(left, right)
    left = left or Color3.fromRGB(255,255,255)
    right = right or Color3.fromRGB(255,255,255)
    local midColor = Color3.fromRGB(
        math.clamp((left.R + right.R) * 0.5 * 255, 0, 255),
        math.clamp((left.G + right.G) * 0.5 * 255, 0, 255),
        math.clamp((left.B + right.B) * 0.5 * 255, 0, 255)
    )
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, left),
        ColorSequenceKeypoint.new(0.5, midColor),
        ColorSequenceKeypoint.new(1, right)
    })
end

local function applyThemeGradient(parent)
    local uiGradient = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7455,11970,10185,10500,11025,10605,11550,12180}))
    uiGradient.Color = getGradientSequence(themeLeft, themeRight)
    uiGradient.Parent = parent
    table.insert(trackingGradients, uiGradient)
    return uiGradient
end

local TargetGui = CoreGui or LocalPlayer:WaitForChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,11340,10185,12705,10605,11970,7455,12285,11025}))
if TargetGui:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8925,7665})) then 
    TargetGui[hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8925,7665})]:Destroy() 
end

local ScreenGui = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10395,11970,10605,10605,11550,7455,12285,11025}))
ScreenGui.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8925,7665})
ScreenGui.Parent = TargetGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}))
MainFrame.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550,7350,11970,10185,11445,10605})
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = Config.UiTransparency
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Active = true
MainFrame.BorderSizePixel = 0

Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), MainFrame).CornerRadius = UDim.new(0, 10)
applyThemeGradient(MainFrame)
makeDraggable(MainFrame)

local BackgroundImage = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11445,10185,10815,10605,7980,10185,10290,10605,11340}))
BackgroundImage.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,10395,11235,10815,11970,11655,12285,11550,10500,7665,11445,10185,10815,10605})
BackgroundImage.Parent = MainFrame
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.ZIndex = 1
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ImageTransparency = 0.35
BackgroundImage.Image = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,12180,10920,12285,11445,10290,6090,4935,4935,12180,12705,11760,10605,6405,6825,12075,12075,10605,12180,3990,11025,10500,6405,5775,5355,5145,5670,5775,5250,5670,5145,5460,3990,12495,6405,5460,5250,5040,3990,10920,6405,5460,5250,5040})
Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), BackgroundImage).CornerRadius = UDim.new(0, 10)

local LeftMenu = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}))
LeftMenu.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7980,10605,10710,12180,8085,10605,11550,12285})
LeftMenu.Parent = MainFrame
LeftMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LeftMenu.BackgroundTransparency = 0.95
LeftMenu.Position = UDim2.new(0, 6, 0, 6)
LeftMenu.Size = UDim2.new(0, 130, 0, 308)
LeftMenu.ZIndex = 2
LeftMenu.BorderSizePixel = 0
Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), LeftMenu).CornerRadius = UDim.new(0, 8)

local UIListLayout_Menu = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7980,11025,12075,12180,7980,10185,12705,11655,12285,12180}), LeftMenu)
UIListLayout_Menu.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Menu.Padding = UDim.new(0, 4)

local TitleHeader = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), LeftMenu)
TitleHeader.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,11025,12180,11340,10605,7560,10605,10185,10500,10605,11970})
TitleHeader.BackgroundTransparency = 1
TitleHeader.Size = UDim2.new(1, 0, 0, 44)

local AnimatedImage = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11445,10185,10815,10605,7980,10185,10290,10605,11340}), TitleHeader)
AnimatedImage.BackgroundTransparency = 1
AnimatedImage.Position = UDim2.new(0, 8, 0, 10)
AnimatedImage.Size = UDim2.new(0, 24, 0, 24)
AnimatedImage.Image = img1

local NameLabel = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), TitleHeader)
NameLabel.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,10185,11445,10605,7980,10185,10290,10605,11340})
NameLabel.BackgroundTransparency = 1
NameLabel.Position = UDim2.new(0, 38, 0, 0)
NameLabel.Size = UDim2.new(1, -38, 1, 0)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,7980,8295,9135,3360,7560,8925,6930,3360,9030,5565})
NameLabel.TextSize = 12
NameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

local function ChangeUITheme(col1, col2, textCol, imageAssetId)
    themeLeft = col1
    themeRight = col2
    local newSeq = getGradientSequence(themeLeft, themeRight)
    for _, grad in ipairs(trackingGradients) do
        if grad and grad.Parent then
            grad.Color = newSeq
        end
    end
    if textCol then
        NameLabel.TextColor3 = textCol
        for _, lbl in ipairs(trackingTextLabels) do
            if lbl and lbl.Parent then
                lbl.TextColor3 = textCol
            end
        end
    end
    if imageAssetId then
        BackgroundImage.Image = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,12180,10920,12285,11445,10290,6090,4935,4935,12180,12705,11760,10605,6405,6825,12075,12075,10605,12180,3990,11025,10500,6405}) .. tostring(imageAssetId) .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3990,12495,6405,5460,5250,5040,3990,10920,6405,5460,5250,5040})
    end
end

local TabContainers = {}
local CurrentTab = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550})

local function CreateTabFrame(tabName)
    local ContentFrame = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10395,11970,11655,11340,11340,11025,11550,10815,7350,11970,10185,11445,10605}))
    ContentFrame.Name = tabName .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9975,7035,11655,11550,12180,10605,11550,12180})
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 142, 0, 6)
    ContentFrame.Size = UDim2.new(0, 332, 0, 308)
    ContentFrame.ZIndex = 3
    ContentFrame.Visible = (tabName == CurrentTab)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 2
    ContentFrame.BorderSizePixel = 0
    
    local UIListLayout_Content = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7980,11025,12075,12180,7980,10185,12705,11655,12285,12180}), ContentFrame)
    UIListLayout_Content.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Content.Padding = UDim.new(0, 6)
    
    UIListLayout_Content:GetPropertyChangedSignal(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,10290,12075,11655,11340,12285,12180,10605,7035,11655,11550,12180,10605,11550,12180,8715,11025,12810,10605})):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Content.AbsoluteContentSize.Y + 15)
    end)
    
    TabContainers[tabName] = ContentFrame
    return ContentFrame
end

local UI = {}

function UI:CreateSection(tabName, titleText)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return end
    local SecLabel = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), targetFrame)
    SecLabel.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,10395,7980,10185,10290,10605,11340})
    SecLabel.BackgroundTransparency = 1
    SecLabel.Size = UDim2.new(1, -14, 0, 20)
    SecLabel.Font = Enum.Font.GothamBold
    SecLabel.Text = titleText:upper()
    SecLabel.TextSize = 10
    SecLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
    SecLabel.TextXAlignment = Enum.TextXAlignment.Left
    SecLabel.ZIndex = 4
end

function UI:CreateLabel(tabName, text)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return nil end
    local Lbl = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), targetFrame)
    Lbl.Size = UDim2.new(1, -14, 0, 22)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamSemibold
    Lbl.Text = text
    Lbl.TextSize = 11
    Lbl.TextColor3 = Color3.fromRGB(30, 30, 40)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 5
    table.insert(trackingTextLabels, Lbl)
    return Lbl
end

function UI:CreateToggle(tabName, text, configKey, callback)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return end
    
    local ToggleRow = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), targetFrame)
    ToggleRow.Name = text .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9975,8820,11655,10815,10815,11340,10605})
    ToggleRow.Size = UDim2.new(1, -14, 0, 28)
    ToggleRow.BackgroundTransparency = 1
    ToggleRow.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({})
    ToggleRow.AutoButtonColor = false
    ToggleRow.ZIndex = 5
    
    local Label = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), ToggleRow)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(20, 20, 20)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    table.insert(trackingTextLabels, Label)
    
    local ToggleBg = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), ToggleRow)
    ToggleBg.Position = UDim2.new(1, -38, 0, 5)
    ToggleBg.Size = UDim2.new(0, 34, 0, 18)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
    ToggleBg.BorderSizePixel = 0
    ToggleBg.ZIndex = 5
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), ToggleBg).CornerRadius = UDim.new(1, 0)
    
    local ToggleBall = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), ToggleBg)
    ToggleBall.Size = UDim2.new(0, 12, 0, 12)
    ToggleBall.BorderSizePixel = 0
    ToggleBall.ZIndex = 6
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), ToggleBall).CornerRadius = UDim.new(1, 0)
    
    local function updateView(animate)
        local enabled = Config[configKey]
        local targetPos = enabled and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3)
        local targetBallColor = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 105)
        local targetBgColor = enabled and Color3.fromRGB(20, 20, 25) or Color3.fromRGB(220, 220, 225)
        
        if animate then
            TS:Create(ToggleBall, TweenInfo.new(0.18), {Position = targetPos, BackgroundColor3 = targetBallColor}):Play()
            TS:Create(ToggleBg, TweenInfo.new(0.18), {BackgroundColor3 = targetBgColor}):Play()
        else
            ToggleBall.Position = targetPos
            ToggleBall.BackgroundColor3 = targetBallColor
            ToggleBg.BackgroundColor3 = targetBgColor
        end
    end
    
    ToggleRow.Activated:Connect(function()
        Config[configKey] = not Config[configKey]
        updateView(true)
        if callback then callback(Config[configKey]) end
    end)
    
    updateView(false)
end

function UI:CreateButton(tabName, text, callback)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return end
    local Btn = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), targetFrame)
    Btn.Size = UDim2.new(1, -14, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(30, 30, 40)
    Btn.TextSize = 11
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 5
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.Activated:Connect(function()
        if callback then callback() end
    end)
    return Btn
end

function UI:CreateCycleButton(tabName, title, options, defaultVal, callback)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return end
    
    local currentIndex = 1
    for i, v in ipairs(options) do
        if v == defaultVal then currentIndex = i break end
    end

    local Btn = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), targetFrame)
    Btn.Size = UDim2.new(1, -14, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = title .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6090,3360}) .. tostring(options[currentIndex])
    Btn.TextColor3 = Color3.fromRGB(30, 30, 40)
    Btn.TextSize = 11
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 5
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), Btn).CornerRadius = UDim.new(0, 6)

    Btn.Activated:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        local selected = options[currentIndex]
        Btn.Text = title .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6090,3360}) .. tostring(selected)
        if callback then callback(selected) end
    end)
end

function UI:CreateSlider(tabName, text, min, max, defaultVal, configKey, callback)
    local targetFrame = TabContainers[tabName]
    if not targetFrame then return end

    Config[configKey] = Config[configKey] or defaultVal

    local SliderContainer = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), targetFrame)
    SliderContainer.Name = text .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9975,8715,11340,11025,10500,10605,11970})
    SliderContainer.Size = UDim2.new(1, -14, 0, 38)
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.ZIndex = 5

    local Label = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), SliderContainer)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6090,3360}) .. tostring(math.floor(Config[configKey]))
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(20, 20, 20)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    table.insert(trackingTextLabels, Label)

    local SliderBg = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), SliderContainer)
    SliderBg.Position = UDim2.new(0, 0, 0, 22)
    SliderBg.Size = UDim2.new(1, 0, 0, 10)
    SliderBg.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
    SliderBg.BorderSizePixel = 0
    SliderBg.ZIndex = 5
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), SliderBg).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11970,10185,11445,10605}), SliderBg)
    local relPercent = math.clamp((Config[configKey] - min) / (max - min), 0, 1)
    SliderFill.Size = UDim2.new(relPercent, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 6
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), SliderFill).CornerRadius = UDim.new(1, 0)

    local isDragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local rawVal = min + (max - min) * pos
        local val = math.floor(rawVal)
        Config[configKey] = val
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6090,3360}) .. tostring(val)
        if callback then callback(val) end
    end

    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

local TabButtons = {}
local function AddTab(name)
    CreateTabFrame(name)
    local TabBtn = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), LeftMenu)
    TabBtn.Size = UDim2.new(1, -12, 0, 28)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,3360,3360}) .. name
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.TextSize = 11
    TabBtn.BorderSizePixel = 0
    TabBtn.ZIndex = 4
    Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), TabBtn).CornerRadius = UDim.new(0, 4)
    
    local function renderTabState()
        if CurrentTab == name then
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            TabBtn.BackgroundTransparency = 0.9
            TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            TabBtn.BackgroundTransparency = 1
            TabBtn.TextColor3 = Color3.fromRGB(120, 120, 130)
        end
    end
    
    TabBtn.Activated:Connect(function()
        CurrentTab = name
        for tName, frame in pairs(TabContainers) do
            frame.Visible = (tName == CurrentTab)
        end
        for _, btnUpdate in pairs(TabButtons) do pcall(btnUpdate) end
    end)
    
    table.insert(TabButtons, renderTabState)
    renderTabState()
end

local tabList = {hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,12180,12180,11025,11550,10815,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075})}
for _, name in ipairs(tabList) do AddTab(name) end

-- TAB 1: MAIN
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,3360,7560,12285,10290,3360,7140,10185,12075,10920,10290,11655,10185,11970,10500}))
local StatusHookLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,11655,11655,11235,3360,8715,12180,10185,12180,12285,12075,6090,3360,9135,10185,11025,12180,11025,11550,10815,3360,10710,11655,11970,3360,11445,10185,11550,12285,10185,11340,3360,11760,10185,11970,11970,12705,4830,4830,4830}))
local TargetLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10185,11970,10815,10605,12180,6090,3360,8190,11655,11550,10605}))
local BallSpeedLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,11340,11340,3360,8715,11760,10605,10605,10500,6090,3360,5040,3360,12075,12180,12285,10500,12075,4935,12075}))
local BallDistLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,11340,11340,3360,7140,11025,12075,12180,10185,11550,10395,10605,6090,3360,5040,3360,12075,12180,12285,10500,12075}))
local PingLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,11025,11550,10815,6090,3360,5040,3360,11445,12075}))
local TrajectoryLbl = UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,10185,11025,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,11970,10185,11130,10605,10395,12180,11655,11970,12705,6090,3360,8715,12180,10185,12180,11025,11655,11550,10185,11970,12705}))

-- TAB 2: AUTOPARRY & CURVES
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,10185,11970,11970,12705,3360,6825,12285,12180,11655,11445,10185,12180,11025,11655,11550}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,3360,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,11550,12180,11025,3360,7140,11655,12285,10290,11340,10605,3360,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,11550,12180,11025,7140,11655,12285,10290,11340,10605,8400,10185,11970,11970,12705}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,3360,8715,11760,10185,11445,3360,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8715,11760,10185,11445}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11025,11550,10815,11340,10605,4725,7035,11340,11025,10395,11235,3360,8820,8400,3360,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,8400,8400,10185,11970,11970,12705}))

UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,12285,11970,12390,10605,3360,8085,11655,10500,10605}))
UI:CreateCycleButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,12285,11970,12390,10605,3360,8085,11655,10500,10605}), {
    hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,10185,11445,10605,11970,10185}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10185,11550,10500,11655,11445}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,11025,10815,10920}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,10395,11235,12495,10185,11970,10500,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11340,11655,12495}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,10395,10395,10605,11340,10605,11970,10185,12180,10605,10500}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10185,11970,10815,10605,12180})
}, Config.CurveMode, function(selected)
    Config.CurveMode = selected
end)

UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11340,11025,10500,10605,11970,12075,3360,4200,7980,11025,11550,11235,10605,10500,3360,12180,11655,3360,8085,10185,11550,12285,10185,11340,3360,3990,3360,6825,12285,12180,11655,3360,7035,8400,8715,4305}))
UI:CreateSlider(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,10185,11970,11970,12705,3360,8400,11970,10605,10500,11025,10395,12180,11025,11655,11550}), 1, 100, Config.Prediction, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,11970,10605,10500,11025,10395,12180,11025,11655,11550}))
UI:CreateSlider(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,10185,11970,11970,12705,3360,7140,11025,12075,12180,10185,11550,10395,10605}), 1, 100, Config.ParryDistance, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,10185,11970,11970,12705,7140,11025,12075,12180,10185,11550,10395,10605}))
UI:CreateSlider(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12285,12180,11655,8400,10185,11970,11970,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11760,10185,11445,3360,7035,8400,8715}), 5, 250, Config.CPS, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,8400,8715}))

-- TAB 3: STAFF DETECTION
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,8715,10185,10710,10605,12180,12705,3360,8715,12705,12075,12180,10605,11445}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7245,11550,10185,10290,11340,10605,3360,8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180,11025,11655,11550}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,7140,10605,12180,10605,10395,12180,11025,11655,11550}), function(val)
    if val then ScanCurrentStaff() end
end)
UI:CreateCycleButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,10395,12180,11025,11655,11550,3360,8085,11655,10500,10605}), {hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,12180,11025,10710,12705}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7875,11025,10395,11235})}, Config.StaffAction, function(sel)
    Config.StaffAction = sel
    if Config.StaffDetection then ScanCurrentStaff() end
end)
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,10710,10710,3360,7140,10605,12180,10605,10395,12180}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,10920,10605,10395,11235,3360,8715,10605,11970,12390,10605,11970,3360,8190,11655,12495}), function()
    ScanCurrentStaff()
end)

-- TAB 4: UNLOCK ALL
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,12075,3360,3990,3360,9030,11025,12075,12285,10185,11340,12075}))
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7245,12600,10605,10395,12285,12180,10605,3360,7350,12285,11340,11340,3360,8925,11550,11340,11655,10395,11235,3360,8715,10395,11970,11025,11760,12180}), function()
    pcall(function() loadstring(game:HttpGet(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10920,12180,12180,11760,12075,6090,4935,4935,11760,10185,12075,12180,10605,10290,11025,11550,4830,10395,11655,11445,4935,11970,10185,12495,4935,12495,8715,12285,10920,8925,7350,8820,11970})))() end)
end)
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7875,11655,11970,10290,11340,11655,12600,3360,3990,3360,7560,10605,10185,10500,11340,10605,12075,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7875,11655,11970,10290,11340,11655,12600,7560,10605,10185,10500,11340,10605,12075,12075}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11235,11025,11550,3360,7035,10920,10185,11550,10815,10605,11970}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11235,11025,11550,7035,10920,10185,11550,10815,10605,11970}), function(val)
    getgenv().skinChanger = val
end)

-- TAB 5: OTHERS
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,12180,11025,11340,11025,12180,11025,10605,12075,3360,3990,3360,8085,11655,12390,10605,11445,10605,11550,12180}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,11655,12390,10605,11445,10605,11550,12180,3360,8715,11760,10605,10605,10500,3360,6930,12705,11760,10185,12075,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,11655,12390,10605,11445,10605,11550,12180,6930,12705,11760,10185,12075,12075}))
UI:CreateSlider(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9135,10185,11340,11235,8715,11760,10605,10605,10500}), 16, 250, Config.WalkSpeed, hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9135,10185,11340,11235,8715,11760,10605,10605,10500}))
UI:CreateToggle(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,11550,12180,11025,4725,6825,7350,7875}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,11550,12180,11025,6825,7350,7875}), function(val)
    if val then
        local vu = game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9030,11025,11970,12180,12285,10185,11340,8925,12075,10605,11970}))
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    end
end)
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,8400,8715,3360,6930,11655,11655,12075,12180,10605,11970}), function()
    pcall(function() loadstring(game:HttpGet(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10920,12180,12180,11760,12075,6090,4935,4935,11970,10185,12495,12075,10395,11970,11025,11760,12180,12075,4830,11550,10605,12180,4935,11970,10185,12495,4935,8925,11550,11025,12390,10605,11970,12075,10185,11340,4725,8715,10395,11970,11025,11760,12180,4725,7350,11760,12075,6930,11655,11655,12075,12180,4725,5985,5250,5670,5040})))() end)
end)
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,10605,11130,11655,11025,11550,3360,8715,10605,11970,12390,10605,11970}), function()
    game:GetService(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,11340,10605,11760,11655,11970,12180,8715,10605,11970,12390,11025,10395,10605})):Teleport(game.PlaceId, LocalPlayer)
end)

-- TAB 6: SETTINGS
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,12180,12180,11025,11550,10815,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10920,10605,11445,10605,12075,3360,3990,3360,8820,11970,10185,11550,12075,11760,10185,11970,10605,11550,10395,12705}))
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,12180,12180,11025,11550,10815,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,11025,10185,11550,10395,11655,3360,4200,9135,10920,11025,12180,10605,4305}), function()
    ChangeUITheme(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(20, 20, 20), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({5775,5355,5145,5670,5775,5250,5670,5145,5460}))
end)
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,12180,12180,11025,11550,10815,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11655,12075,10185,3360,4200,8400,11025,11550,11235,4305}), function()
    ChangeUITheme(Color3.fromRGB(255, 182, 193), Color3.fromRGB(255, 105, 180), Color3.fromRGB(255, 255, 255), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({5145,5250,5250,5880,5985,5775,5880,5250,5250,5985}))
end)
UI:CreateButton(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,10605,12180,12180,11025,11550,10815,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7140,10185,11970,11235,3360,8085,11655,10500,10605}), function()
    ChangeUITheme(Color3.fromRGB(35, 35, 42), Color3.fromRGB(20, 20, 25), Color3.fromRGB(240, 240, 245), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({5775,5355,5145,5670,5775,5250,5670,5145,5460}))
end)

-- TAB 7: CREDITS
UI:CreateSection(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075,3360,3990,3360,6825,12285,12180,10920,11655,11970,12075}))
UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,11025,3360,10290,12705,3360,6825,12075,10395,10605,11550,10500}))
UI:CreateLabel(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075}), hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,11970,10605,10500,11025,12180,12075,3360,12075,10920,11025,12180,10185,11760,12075}))

-- Floating Toggle
local ToggleButton = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11445,10185,10815,10605,6930,12285,12180,12180,11655,11550}))
ToggleButton.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8820,11655,10815,10815,11340,10605,6930,12285,12180,12180,11655,11550})
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Image = img1
ToggleButton.Active = true
ToggleButton.ZIndex = 10
Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), ToggleButton).CornerRadius = UDim.new(0, 12)

local ToggleStroke = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,8715,12180,11970,11655,11235,10605}), ToggleButton)
ToggleStroke.Thickness = 1.5
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Transparency = 0.5

makeDraggable(ToggleButton)

local startPosToggle = nil
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startPosToggle = input.Position
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and startPosToggle then
        local distance = (input.Position - startPosToggle).Magnitude
        if distance < 10 then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- Quick Manual Spam Button (CPS Sync)
local QuickSpamBtn = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11445,10185,10815,10605,6930,12285,12180,12180,11655,11550}))
QuickSpamBtn.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8505,12285,11025,10395,11235,8715,11760,10185,11445})
QuickSpamBtn.Parent = ScreenGui
QuickSpamBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
QuickSpamBtn.BackgroundTransparency = 0.2
QuickSpamBtn.Position = UDim2.new(0, 20, 0.5, 30)
QuickSpamBtn.Size = UDim2.new(0, 36, 0, 36)
QuickSpamBtn.Image = img1
QuickSpamBtn.Active = true
QuickSpamBtn.ZIndex = 10
Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), QuickSpamBtn).CornerRadius = UDim.new(0, 10)

local SpamStroke = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,8715,12180,11970,11655,11235,10605}), QuickSpamBtn)
SpamStroke.Thickness = 1.5
SpamStroke.Color = Color3.fromRGB(255, 80, 80)
SpamStroke.Transparency = 0.3

local SpamBadge = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), QuickSpamBtn)
SpamBadge.Size = UDim2.new(1, 0, 1, 0)
SpamBadge.BackgroundTransparency = 1
SpamBadge.Font = Enum.Font.GothamBold
SpamBadge.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,8400,6825,8085})
SpamBadge.TextSize = 8
SpamBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamBadge.ZIndex = 11

makeDraggable(QuickSpamBtn)

local startPosSpam = nil
QuickSpamBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startPosSpam = input.Position
        Config.ManualSpamActive = true
    end
end)

QuickSpamBtn.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        Config.ManualSpamActive = false
        if startPosSpam then
            local distance = (input.Position - startPosSpam).Magnitude
            if distance < 10 then
                Config.AutoSpam = not Config.AutoSpam
            end
        end
    end
end)

-- Quick TP Parry
local QuickTPBtn = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,11445,10185,10815,10605,6930,12285,12180,12180,11655,11550}))
QuickTPBtn.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,12285,10290,9030,5565,9975,8505,12285,11025,10395,11235,8820,8400})
QuickTPBtn.Parent = ScreenGui
QuickTPBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
QuickTPBtn.BackgroundTransparency = 0.2
QuickTPBtn.Position = UDim2.new(0, 20, 0.5, 72)
QuickTPBtn.Size = UDim2.new(0, 36, 0, 36)
QuickTPBtn.Image = img1
QuickTPBtn.Active = true
QuickTPBtn.ZIndex = 10
Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,7035,11655,11970,11550,10605,11970}), QuickTPBtn).CornerRadius = UDim.new(0, 10)

local TPStroke = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8925,7665,8715,12180,11970,11655,11235,10605}), QuickTPBtn)
TPStroke.Thickness = 1.5
TPStroke.Color = Color3.fromRGB(0, 180, 255)
TPStroke.Transparency = 0.3

local TPBadge = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10605,12600,12180,7980,10185,10290,10605,11340}), QuickTPBtn)
TPBadge.Size = UDim2.new(1, 0, 1, 0)
TPBadge.BackgroundTransparency = 1
TPBadge.Font = Enum.Font.GothamBold
TPBadge.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,8400})
TPBadge.TextSize = 9
TPBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBadge.ZIndex = 11

makeDraggable(QuickTPBtn)

local startPosTP = nil
QuickTPBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startPosTP = input.Position
    end
end)

QuickTPBtn.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and startPosTP then
        local distance = (input.Position - startPosTP).Magnitude
        if distance < 10 then
            SendParryPacket()
        end
    end
end)

-- ==================== KORBLOX & HEADLESS LOOP ====================
local HEADLESS_MESH_ID = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5145,5040,5985,5565,5775,5040,5880})
local KORBLOX_MESH_ID = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5145,5040,5145,5880,5565,5145,5670,5985,5670})

task.spawn(function()
    while task.wait(1) do
        if Config.KorbloxHeadless and LocalPlayer.Character then
            pcall(function()
                local chr = LocalPlayer.Character
                local head = chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,10605,10185,10500}))

                if head then
                    head.Transparency = 1
                    head.CanCollide = false
                    local faceDecal = head:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10710,10185,10395,10605})) or head:FindFirstChildOfClass(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7140,10605,10395,10185,11340}))
                    if faceDecal then faceDecal.Transparency = 1 end

                    if not head:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,10605,10185,10500,11340,10605,12075,12075,8085,10605,12075,10920})) then
                        for _, child in ipairs(head:GetChildren()) do
                            if child:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920})) or child:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,10920,10185,11970,10185,10395,12180,10605,11970,8085,10605,12075,10920})) then child:Destroy() end
                        end
                        local mesh = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920}))
                        mesh.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7560,10605,10185,10500,11340,10605,12075,12075,8085,10605,12075,10920})
                        mesh.MeshType = Enum.MeshType.FileMesh
                        mesh.MeshId = HEADLESS_MESH_ID
                        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
                        mesh.Parent = head
                    end
                end

                if chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11025,10815,10920,12180,7980,11655,12495,10605,11970,7980,10605,10815})) then
                    chr.RightLowerLeg.MeshId = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5985,5040,5250,5985,5460,5250,5040,5985,5355})
                    chr.RightLowerLeg.Transparency = 1
                    if chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11025,10815,10920,12180,8925,11760,11760,10605,11970,7980,10605,10815})) then
                        chr.RightUpperLeg.MeshId = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10920,12180,12180,11760,6090,4935,4935,12495,12495,12495,4830,11970,11655,10290,11340,11655,12600,4830,10395,11655,11445,4935,10185,12075,12075,10605,12180,4935,6615,11025,10500,6405,5985,5040,5250,5985,5460,5250,5040,5985,5670})
                        chr.RightUpperLeg.TextureID = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10920,12180,12180,11760,6090,4935,4935,11970,11655,10290,11340,11655,12600,4830,10395,11655,11445,4935,10185,12075,12075,10605,12180,4935,6615,11025,10500,6405,5985,5040,5250,5880,5460,5355,5355,5985,5880})
                    end
                    if chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11025,10815,10920,12180,7350,11655,11655,12180})) then
                        chr.RightFoot.MeshId = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5985,5040,5250,5985,5460,5250,5040,5880,5985})
                        chr.RightFoot.Transparency = 1
                    end
                else
                    local rightLegR6 = chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11025,10815,10920,12180,3360,7980,10605,10815})) or chr:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8610,11025,10815,10920,12180,7980,10605,10815}))
                    if rightLegR6 and not rightLegR6:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7875,11655,11970,10290,11340,11655,12600,8085,10605,12075,10920})) then
                        for _, child in ipairs(rightLegR6:GetChildren()) do
                            if child:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920})) or child:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7035,10920,10185,11970,10185,10395,12180,10605,11970,8085,10605,12075,10920})) then child:Destroy() end
                        end
                        rightLegR6.BrickColor = BrickColor.new(Color3.fromRGB(128, 128, 128))
                        local korbloxMesh = Instance.new(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920}))
                        korbloxMesh.Name = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7350,11340,11655,12495,7875,11655,11970,10290,11340,11655,12600,8085,10605,12075,10920})
                        korbloxMesh.MeshType = Enum.MeshType.FileMesh
                        korbloxMesh.MeshId = KORBLOX_MESH_ID
                        korbloxMesh.Scale = Vector3.new(1, 1, 1)
                        korbloxMesh.Parent = rightLegR6
                    end
                end
            end)
        end
    end
end)

-- ==================== MAIN GAME HEARTBEAT LOOP ====================
RunService.Heartbeat:Connect(function(deltaTime)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180}))
    local humanoid = char and char:FindFirstChildOfClass(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,12285,11445,10185,11550,11655,11025,10500}))

    if hrp then
        local pos = hrp.Position
        BallInfo.PlayerPos = string.format(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({9240,6090,3360,3885,10500,3360,13020,3360,9345,6090,3360,3885,10500,3360,13020,3360,9450,6090,3360,3885,10500}), math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
    end

    -- Movement Speed Bypass
    if Config.MovementBypass and hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
        if Config.WalkSpeed > 16 then
            local speedDelta = Config.WalkSpeed - 16
            local moveVector = humanoid.MoveDirection
            local extraDistance = (moveVector * speedDelta * deltaTime)
            hrp.CFrame = hrp.CFrame + extraDistance
        end
    end

    -- Manual / Auto Spam con frequenza CPS esatta
    if Config.AutoSpam or Config.ManualSpamActive then
        SpamStroke.Color = Color3.fromRGB(80, 255, 80)
        local spamInterval = 1 / math.clamp(Config.CPS, 1, 500)
        if (tick() - LastSpamTime) >= spamInterval then
            SendParryPacket()
            LastSpamTime = tick()
        end
        return
    else
        SpamStroke.Color = Color3.fromRGB(255, 80, 80)
    end

    -- Auto Parry & Ball Processing
    local ball, ballType = GetBallInfo()
    local ping = GetPing()
    BallInfo.Ping = ping

    if not ball or not hrp then
        BallInfo.Object = nil
        BallInfo.Type = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605})
        BallInfo.Speed = 0
        BallInfo.Distance = 0
        BallInfo.Target = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605})
        BallInfo.Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,12180,11025,11655,11550,10185,11970,12705})
        BallInfo.IsTarget = false
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
        lastBallInstance = nil
        return
    end

    if ball ~= lastBallInstance then
        lastBallInstance = ball
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
    end

    BallInfo.Object = ball
    BallInfo.Type = ballType

    local ballPos = ball.Position or (ball:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8085,11655,10500,10605,11340})) and ball:GetPivot().Position) or hrp.Position
    local ballToPlayerVec = (hrp.Position - ballPos)
    local distance = ballToPlayerVec.Magnitude
    BallInfo.Distance = math.floor(distance)

    local vel = (ball:IsA(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,12075,10605,8400,10185,11970,12180})) and ball.AssemblyLinearVelocity) or Vector3.zero
    local speed = vel.Magnitude
    BallInfo.Speed = math.floor(speed)

    local targetAttr = ball:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12180,10185,11970,10815,10605,12180})) or ball:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10185,11970,10815,10605,12180})) or ball:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815}))
    if type(targetAttr) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({12075,12180,11970,11025,11550,10815}) then
        BallInfo.Target = targetAttr
        BallInfo.IsTarget = (targetAttr == LocalPlayer.Name)
    elseif type(targetAttr) == hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({10290,11655,11655,11340,10605,10185,11550}) then
        BallInfo.IsTarget = targetAttr
        BallInfo.Target = targetAttr and LocalPlayer.Name or hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8295,12180,10920,10605,11970})
    else
        BallInfo.Target = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8190,11655,11550,10605})
        BallInfo.IsTarget = false
    end

    local dirToPlayer = distance > 0 and ballToPlayerVec.Unit or Vector3.zero
    local ballDir = speed > 0.1 and vel.Unit or Vector3.zero
    local dot = ballDir:Dot(dirToPlayer)

    if speed < 2 then
        BallInfo.Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8715,12180,10185,12180,11025,11655,11550,10185,11970,12705})
    elseif dot > 0.1 then
        BallInfo.Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,11655,12495,10185,11970,10500,12075,3360,9345,11655,12285})
    elseif dot < -0.1 then
        BallInfo.Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6825,12495,10185,12705})
    else
        BallInfo.Trajectory = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,11970,10185,11550,12075,12390,10605,11970,12075,10185,11340})
    end

    if BallInfo.Target ~= lastTargetName then
        lastTargetName = BallInfo.Target
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
    end

    if dot <= 0 and not BallInfo.IsTarget then
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
    end

    -- Single-Click TP Parry
    if Config.TPParry then
        local isLuminousTarget = (ball:GetAttribute(hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815})) == true) or BallInfo.IsTarget or (distance <= 35 and dot > 0)
        if isLuminousTarget then
            if not hasTPParriedThisTarget then
                SendParryPacket()
                hasTPParriedThisTarget = true
            end
            return
        else
            hasTPParriedThisTarget = false
        end
    end

    -- AutoParry Calibrato & Anti-Double Parry
    local mappedPredictionSec = (Config.Prediction / 45) + (ping * 1.1)
    local mappedDistanceThreshold = Config.ParryDistance

    local incomingSpeed = math.max(vel:Dot(dirToPlayer), 0)
    local timeToHit = incomingSpeed > 1 and (distance / incomingSpeed) or (speed > 1 and distance / speed or 999)
    
    local shouldParry = Config.AutoParry 
        and (BallInfo.IsTarget or distance <= mappedDistanceThreshold) 
        and (timeToHit <= mappedPredictionSec or distance <= mappedDistanceThreshold)
        and (dot > 0 or distance <= 12)

    if shouldParry then
        if Config.AntiDoubleParry and hasParriedThisIncoming then
            return
        end

        if (tick() - LastParryTime) >= 0.05 then
            SendParryPacket()
            LastParryTime = tick()
            if Config.AntiDoubleParry then
                hasParriedThisIncoming = true
            end
        end
    end
end)

-- Update HUD Text
task.spawn(function()
    while task.wait(0.25) do
        pcall(function()
            if next(_reverted) then
                StatusHookLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,11655,11655,11235,3360,8715,12180,10185,12180,12285,12075,6090,3360,8820,11655,11235,10605,11550,3360,7035,10185,11760,12180,12285,11970,10605,10500,3360,23730,16380,15435})
            else
                StatusHookLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({7560,11655,11655,11235,3360,8715,12180,10185,12180,12285,12075,6090,3360,9135,10185,11025,12180,11025,11550,10815,3360,10710,11655,11970,3360,11445,10185,11550,12285,10185,11340,3360,11760,10185,11970,11970,12705,4830,4830,4830})
            end

            TargetLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,10185,11970,10815,10605,12180,6090,3360}) .. BallInfo.Target .. (BallInfo.IsTarget and hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,4200,9345,8295,8925,3465,4305}) or hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({}))
            BallSpeedLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,11340,11340,3360,8715,11760,10605,10605,10500,6090,3360}) .. BallInfo.Speed .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,12075,12180,12285,10500,12075,4935,12075})
            BallDistLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({6930,10185,11340,11340,3360,7140,11025,12075,12180,10185,11550,10395,10605,6090,3360}) .. BallInfo.Distance .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,12075,12180,12285,10500,12075})
            PingLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8400,11025,11550,10815,6090,3360}) .. math.floor(BallInfo.Ping * 1000) .. hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({3360,11445,12075})
            TrajectoryLbl.Text = hFumIWudVRzkOGUiqVrtHvRkIlAPngrTooeEtJvEhGvCwrQLSxrZNTKcETKCKPNJOowHlniaCmtipcPCbgVHqQUFMzTavAhDZOy({8820,11970,10185,11130,10605,10395,12180,11655,11970,12705,6090,3360}) .. BallInfo.Trajectory
        end)
    end
end)
    
