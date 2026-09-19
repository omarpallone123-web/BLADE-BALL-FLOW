function tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki(code)res=''for i in ipairs(code)do res=res..string.char(code[i]/105)end return res end 


--// FLOW HUB V4 - BLADE BALL CORE & MINI QUICK GUI
--// Safe UI for Delta / Roblox Executors

repeat task.wait() until game:IsLoaded()

--==================================================
-- SERVIZI E VARIABILI PRINCIPALI
--==================================================

local Players = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,11340,10185,12705,10605,11970,12075}))
local TweenService = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,12495,10605,10605,11550,8715,10605,11970,12390,11025,10395,10605}))
local UIS = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,12075,10605,11970,7665,11550,11760,12285,12180,8715,10605,11970,12390,11025,10395,10605}))
local CoreGui = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,11655,11970,10605,7455,12285,11025}))
local RunService = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,12285,11550,8715,10605,11970,12390,11025,10395,10605}))
local ReplicatedStorage = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11760,11340,11025,10395,10185,12180,10605,10500,8715,12180,11655,11970,10185,10815,10605}))
local Workspace = game:GetService(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11235,12075,11760,10185,10395,10605}))

local LocalPlayer = Players.LocalPlayer
local TargetParent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,11340,10185,12705,10605,11970,7455,12285,11025}))

-- State / Config Iniziale
local State = {
    AutoParry = false,
    AntiDoubleParry = true,
    TrainingAutoParry = false,
    TrainingAntiDoubleParry = true,
    ManualSpam = false,
    TPParry = false,
    MovementBypass = false,
    WalkSpeed = 16,
    CurveMode = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,10185,11445,10605,11970,10185}),
    KorbloxHeadless = false,
    Prediction = 0.55,
    ParryDistance = 25,
    CPS = 20,
    LastParry = 0,
    LastSpam = 0
}

local BallInfo = {
    Object = nil,
    Type = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,10185}),
    Speed = 0,
    Target = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,11655}),
    Trajectory = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,12180,10185,12810,11025,11655,11550,10185,11970,11025,10185}),
    IsTarget = false,
    Distance = 0,
    PlayerPos = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9240,6090,3360,5040,4620,3360,9345,6090,3360,5040,4620,3360,9450,6090,3360,5040})
}

local hasParriedThisIncoming = false
local hasTPParriedThisTarget = false
local lastTargetName = nil

--==================================================
-- TOKEN CAPTURE & REMOTE HOOKING
--==================================================

local _token
for _, Function in getgc(true) do
    if type(Function) ~= tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10710,12285,11550,10395,12180,11025,11655,11550}) or not debug.info(Function, tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12075})):find(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,8610,9345}), 1, true) then
        continue
    end

    for _, value in debug.getupvalues(Function) do
        if type(value) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10710,12285,11550,10395,12180,11025,11655,11550}) then
            _token = value
            break
        end
    end

    if _token then break end
end

local function _tokenize(_remote_uid)
    if not _token then return tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({}) end
    local time = tostring(math.floor(Workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,7665,8085,7245}))
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
        and type(args[2]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12075,12180,11970,11025,11550,10815}) 
        and type(args[3]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12075,12180,11970,11025,11550,10815}) 
        and type(args[4]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11550,12285,11445,10290,10605,11970}) 
        and typeof(args[5]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,7350,11970,10185,11445,10605}) 
        and type(args[6]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12180,10185,10290,11340,10605}) 
        and type(args[7]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12180,10185,10290,11340,10605}) 
        and type(args[8]) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10290,11655,11655,11340,10605,10185,11550})
end

local function _hook(remote)
    if not _reverted[remote] then
        local meta = getrawmetatable(remote)
        if meta and not _original[meta] then
            _original[meta] = true
            setreadonly(meta, false)

            local _old = meta.__index
            meta.__index = function(self, key)
                if (key == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11025,11970,10605,8715,10605,11970,12390,10605,11970}) and self:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180}))) or
                   (key == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,11550,12390,11655,11235,10605,8715,10605,11970,12390,10605,11970}) and self:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550}))) then
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
    if _remote:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180})) or _remote:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550})) then
        _hook(_remote)
    end
end

-- Spoof Metatable per WalkSpeed Anti-Cheat
local rawMeta = getrawmetatable(game)
if rawMeta then
    setreadonly(rawMeta, false)
    local oldIndex = rawMeta.__index
    local oldNewIndex = rawMeta.__newindex
    
    rawMeta.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500})) and key == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,10185,11340,11235,8715,11760,10605,10605,10500}) then
            return 16
        end
        return oldIndex(self, key)
    end)
    
    rawMeta.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and self:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500})) and key == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,10185,11340,11235,8715,11760,10605,10605,10500}) then
            return
        end
        return oldNewIndex(self, key, value)
    end)
    setreadonly(rawMeta, true)
end

--==================================================
-- TRACCIAMENTO CENTRO SCHERMO (XYZ TARGET) & CURVE
--==================================================

local function GetTargetNearCrosshair()
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closestChar = nil
    local shortestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
            local humanoid = player.Character:FindFirstChildOfClass(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500}))
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

    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11655,10500,10605,11340})) and v ~= LocalPlayer.Character and v:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
            local hum = v:FindFirstChildOfClass(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500}))
            if hum and hum.Health > 0 then
                local screenPos, onScreen = cam:WorldToViewportPoint(v.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestChar = v
                    end
                end
            end
        end
    end

    return closestChar
end

local function GetBallInfo()
    local ballObj = nil
    local ballType = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,10185})

    local ballsFolder = Workspace:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,11340,11340,12075}))
    if ballsFolder then
        for _, b in ipairs(ballsFolder:GetChildren()) do
            if b:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11970,10605,10185,11340,6930,10185,11340,11340})) or b:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815})) or b.Name:lower():find(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10290,10185,11340,11340})) then
                ballObj = b
                ballType = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,12180,10395,10920,3360,6930,10185,11340,11340})
                break
            end
        end
    end

    if not ballObj then
        local searchFolders = {
            Workspace:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,6930,10185,11340,11340,12075})),
            Workspace:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815})),
            Workspace:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,9975,6930,10185,11340,11340,12075})),
            Workspace:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,11550,12180,10605,11970,10185,10395,12180,11025,12390,10605}))
        }

        for _, folder in ipairs(searchFolders) do
            if folder then
                for _, b in ipairs(folder:GetChildren()) do
                    if b.Name:lower():find(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12180,11970,10185,11025,11550})) or b.Name:lower():find(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10500,12285,11445,11445,12705})) or b.Name:lower():find(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10290,10185,11340,11340})) then
                        ballObj = b:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,12075,10605,8400,10185,11970,12180})) and b or b:FindFirstChildWhichIsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,12075,10605,8400,10185,11970,12180})) or b
                        ballType = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,3360,6930,10185,11340,11340})
                        break
                    end
                end
            end
            if ballObj then break end
        end
    end

    return ballObj, ballType
end

local function SendParryPacket()
    if not next(_reverted) then return end
    
    local cameraCFrame = Workspace.CurrentCamera.CFrame
    local lookVector = cameraCFrame.LookVector
    
    if State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10185,11550,10500,11655,11445}) then
        lookVector = Vector3.new(math.random(-100, 100) / 100, math.random(-100, 100) / 100, math.random(-100, 100) / 100).Unit
    elseif State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11025,10815,10920}) then
        lookVector = Vector3.new(lookVector.X, 0.8, lookVector.Z).Unit
    elseif State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,10395,11235,12495,10185,11970,10500,12075}) then
        lookVector = -lookVector
    elseif State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11340,11655,12495}) then
        lookVector = Vector3.new(lookVector.X, -0.5, lookVector.Z).Unit
    elseif State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,10395,10395,10605,11340,10605,11970,10185,12180,10605,10500}) then
        lookVector = Vector3.new(lookVector.X * 1.5, 0.1, lookVector.Z * 1.5).Unit
    elseif State.CurveMode == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10185,11970,10815,10605,12180}) then
        local targetChar = GetTargetNearCrosshair()
        if targetChar and targetChar:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
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
            if _remote:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7245,12390,10605,11550,12180})) then
                _remote:FireServer(unpack(_packet))
            elseif _remote:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,7350,12285,11550,10395,12180,11025,11655,11550})) then
                _remote:InvokeServer(unpack(_packet))
            end
        end)
    end
end

--==================================================
-- KORBLOX & HEADLESS INTEGRATION
--==================================================

local HEADLESS_MESH_ID = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5145,5040,5985,5565,5775,5040,5880})
local KORBLOX_MESH_ID = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5145,5040,5145,5880,5565,5145,5670,5985,5670})

task.spawn(function()
    while task.wait(0.5) do
        if State.KorbloxHeadless and LocalPlayer.Character then
            pcall(function()
                local chr = LocalPlayer.Character
                local head = chr:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,10605,10185,10500}))

                if head then
                    head.Transparency = 1
                    head.CanCollide = false
                    local faceDecal = head:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10710,10185,10395,10605})) or head:FindFirstChildOfClass(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7140,10605,10395,10185,11340}))
                    if faceDecal then faceDecal.Transparency = 1 end

                    if not head:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7560,10605,10185,10500,11340,10605,12075,12075,8085,10605,12075,10920})) then
                        for _, child in ipairs(head:GetChildren()) do
                            if child:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920})) or child:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,10920,10185,11970,10185,10395,12180,10605,11970,8085,10605,12075,10920})) then child:Destroy() end
                        end
                        local mesh = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920}))
                        mesh.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7560,10605,10185,10500,11340,10605,12075,12075,8085,10605,12075,10920})
                        mesh.MeshType = Enum.MeshType.FileMesh
                        mesh.MeshId = HEADLESS_MESH_ID
                        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
                        mesh.Parent = head
                    end
                end

                if chr:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,11025,10815,10920,12180,7980,11655,12495,10605,11970,7980,10605,10815})) then
                    chr.RightLowerLeg.MeshId = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5985,5040,5250,5985,5460,5250,5040,5985,5355})
                    chr.RightLowerLeg.Transparency = 1
                    if chr:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,11025,10815,10920,12180,8925,11760,11760,10605,11970,7980,10605,10815})) then
                        chr.RightUpperLeg.MeshId = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10920,12180,12180,11760,6090,4935,4935,12495,12495,12495,4830,11970,11655,10290,11340,11655,12600,4830,10395,11655,11445,4935,10185,12075,12075,10605,12180,4935,6615,11025,10500,6405,5985,5040,5250,5985,5460,5250,5040,5985,5670})
                        chr.RightUpperLeg.TextureID = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10920,12180,12180,11760,6090,4935,4935,11970,11655,10290,11340,11655,12600,4830,10395,11655,11445,4935,10185,12075,12075,10605,12180,4935,6615,11025,10500,6405,5985,5040,5250,5880,5460,5355,5355,5985,5880})
                    end
                else
                    local rightLegR6 = chr:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,11025,10815,10920,12180,3360,7980,10605,10815})) or chr:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,11025,10815,10920,12180,7980,10605,10815}))
                    if rightLegR6 and not rightLegR6:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7875,11655,11970,10290,11340,11655,12600,8085,10605,12075,10920})) then
                        for _, child in ipairs(rightLegR6:GetChildren()) do
                            if child:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920})) or child:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,10920,10185,11970,10185,10395,12180,10605,11970,8085,10605,12075,10920})) then child:Destroy() end
                        end
                        local korbloxMesh = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10605,10395,11025,10185,11340,8085,10605,12075,10920}))
                        korbloxMesh.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7875,11655,11970,10290,11340,11655,12600,8085,10605,12075,10920})
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

--==================================================
-- LOOP PRINCIPALE (HEARTBEAT)
--==================================================

RunService.Heartbeat:Connect(function(deltaTime)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180}))
    local humanoid = char and char:FindFirstChildOfClass(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,12285,11445,10185,11550,11655,11025,10500}))

    if hrp then
        local pos = hrp.Position
        BallInfo.PlayerPos = string.format(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9240,6090,3360,3885,10500,3360,13020,3360,9345,6090,3360,3885,10500,3360,13020,3360,9450,6090,3360,3885,10500}), math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
    end

    if State.MovementBypass and hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
        if State.WalkSpeed > 16 then
            local speedDelta = State.WalkSpeed - 16
            local moveVector = humanoid.MoveDirection
            local extraDistance = (moveVector * speedDelta * deltaTime)
            hrp.CFrame = hrp.CFrame + extraDistance
        end
    end

    local ball, ballType = GetBallInfo()
    if not ball or not hrp then
        BallInfo.Object = nil
        BallInfo.Type = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,10185})
        BallInfo.Speed = 0
        BallInfo.Distance = 0
        BallInfo.Target = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,11655})
        BallInfo.Trajectory = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,12075,12075,10605,11550,12180,10605})
        BallInfo.IsTarget = false
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
        return
    end

    BallInfo.Object = ball
    BallInfo.Type = ballType

    local ballPos = ball.Position or (ball:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11655,10500,10605,11340})) and ball:GetPivot().Position) or hrp.Position
    local ballToPlayerVec = (hrp.Position - ballPos)
    local distance = ballToPlayerVec.Magnitude
    BallInfo.Distance = math.floor(distance)

    local vel = (ball:IsA(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,12075,10605,8400,10185,11970,12180})) and ball.AssemblyLinearVelocity) or Vector3.zero
    local speed = vel.Magnitude
    BallInfo.Speed = math.floor(speed)

    local targetAttr = ball:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12180,10185,11970,10815,10605,12180})) or ball:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10185,11970,10815,10605,12180})) or ball:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815}))
    if type(targetAttr) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({12075,12180,11970,11025,11550,10815}) then
        BallInfo.Target = targetAttr
        BallInfo.IsTarget = (targetAttr == LocalPlayer.Name)
    elseif type(targetAttr) == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10290,11655,11655,11340,10605,10185,11550}) then
        BallInfo.IsTarget = targetAttr
        BallInfo.Target = targetAttr and LocalPlayer.Name or tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,11340,12180,11970,11655})
    else
        BallInfo.Target = (ballType == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,3360,6930,10185,11340,11340})) and tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815}) or tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8190,10605,12075,12075,12285,11550,11655})
        BallInfo.IsTarget = (ballType == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,3360,6930,10185,11340,11340}))
    end

    local dirToPlayer = distance > 0 and ballToPlayerVec.Unit or Vector3.zero
    local ballDir = speed > 0.1 and vel.Unit or Vector3.zero
    local dot = ballDir:Dot(dirToPlayer)

    if BallInfo.Target ~= lastTargetName then
        lastTargetName = BallInfo.Target
        hasParriedThisIncoming = false
        hasTPParriedThisTarget = false
    end

    if State.TPParry then
        local isLuminousTarget = (ball:GetAttribute(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,12075,8820,10185,11970,10815,10605,12180,11025,11550,10815})) == true) or BallInfo.IsTarget or (distance <= 35 and dot > 0)
        if isLuminousTarget then
            if not hasTPParriedThisTarget then
                SendParryPacket()
                hasTPParriedThisTarget = true
            end
            return
        end
    end

    if State.ManualSpam then
        local interval = 1 / math.clamp(State.CPS, 1, 500)
        if (tick() - State.LastSpam) >= interval then
            SendParryPacket()
            State.LastSpam = tick()
        end
        return
    end

    local activeAutoParry = false
    local activeAntiDouble = false
    local shouldParry = false

    if ballType == tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11025,11550,11025,11550,10815,3360,6930,10185,11340,11340}) then
        activeAutoParry = State.TrainingAutoParry
        activeAntiDouble = State.TrainingAntiDoubleParry
        local timeToHit = speed > 1 and (distance / speed) or 999
        local isHeadingToPlayer = (dot > 0 or distance <= 18)
        shouldParry = activeAutoParry and (distance <= State.ParryDistance or timeToHit <= State.Prediction) and isHeadingToPlayer
    else
        activeAutoParry = State.AutoParry
        activeAntiDouble = State.AntiDoubleParry
        local timeToHit = speed > 1 and (distance / speed) or 999
        shouldParry = activeAutoParry 
            and (BallInfo.IsTarget or distance <= State.ParryDistance) 
            and (timeToHit <= State.Prediction or distance <= State.ParryDistance)
            and (dot > 0 or distance <= 12)
    end

    if shouldParry then
        if activeAntiDouble and hasParriedThisIncoming then return end
        if (tick() - State.LastParry) >= 0.08 then
            SendParryPacket()
            State.LastParry = tick()
            if activeAntiDouble then hasParriedThisIncoming = true end
        end
    end
end)

--==================================================
-- FLOW HUB V4 CONFIG & COLORS
--==================================================

local CAT_ICON_ID = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({11970,10290,12600,10185,12075,12075,10605,12180,11025,10500,6090,4935,4935,5670,5040,5355,5145,5040,5985,5460,5670,5775,5880})
local AccentColor = Color3.fromRGB(255, 215, 0)
local TransparentUI = false
local Opened = true

local BG = Color3.fromRGB(245, 245, 247)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(15, 15, 18)
local GRAY = Color3.fromRGB(125, 125, 135)
local LIGHT = Color3.fromRGB(225, 225, 230)

-- Clean Old Gui
local Old = TargetParent:FindFirstChild(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7560,12285,10290,9030,5460}))
if Old then Old:Destroy() end

-- Screen Gui
local Gui = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10395,11970,10605,10605,11550,7455,12285,11025}))
Gui.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,7560,12285,10290,9030,5460})
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = TargetParent

--==================================================
-- MINI GUI BIANCA (QUICK CONTROLS FOR TP & SPAM)
--==================================================

local MiniGuiFrame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
MiniGuiFrame.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11025,11550,11025,8505,12285,11025,10395,11235,7035,11655,11550,12180,11970,11655,11340,12075})
MiniGuiFrame.Size = UDim2.new(0, 150, 0, 85)
MiniGuiFrame.Position = UDim2.new(0.5, -75, 0.12, 0)
MiniGuiFrame.BackgroundColor3 = WHITE
MiniGuiFrame.BorderSizePixel = 0
MiniGuiFrame.ZIndex = 40
MiniGuiFrame.Parent = Gui

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), MiniGuiFrame).CornerRadius = UDim.new(0, 10)

local MiniStroke = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8715,12180,11970,11655,11235,10605}))
MiniStroke.Color = LIGHT
MiniStroke.Thickness = 1
MiniStroke.Parent = MiniGuiFrame

local MiniTitle = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
MiniTitle.Size = UDim2.new(1, 0, 0, 20)
MiniTitle.Position = UDim2.new(0, 0, 0, 3)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8505,12285,11025,10395,11235,3360,7035,11655,11550,12180,11970,11655,11340,12075})
MiniTitle.TextColor3 = BLACK
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 10
MiniTitle.Parent = MiniGuiFrame

-- Pulsante Mini TP Parry
local MiniTPBtn = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
MiniTPBtn.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11025,11550,11025,8820,8400,6930,12285,12180,12180,11655,11550})
MiniTPBtn.Size = UDim2.new(1, -16, 0, 24)
MiniTPBtn.Position = UDim2.new(0, 8, 0, 26)
MiniTPBtn.BackgroundColor3 = LIGHT
MiniTPBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,8400,3360,8400,10185,11970,11970,12705,6090,3360,8295,7350,7350})
MiniTPBtn.TextColor3 = BLACK
MiniTPBtn.Font = Enum.Font.GothamSemibold
MiniTPBtn.TextSize = 9
MiniTPBtn.AutoButtonColor = false
MiniTPBtn.Parent = MiniGuiFrame

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), MiniTPBtn).CornerRadius = UDim.new(0, 6)

-- Pulsante Mini Manual Spam
local MiniSpamBtn = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
MiniSpamBtn.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11025,11550,11025,8715,11760,10185,11445,6930,12285,12180,12180,11655,11550})
MiniSpamBtn.Size = UDim2.new(1, -16, 0, 24)
MiniSpamBtn.Position = UDim2.new(0, 8, 0, 54)
MiniSpamBtn.BackgroundColor3 = LIGHT
MiniSpamBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,11550,12285,10185,11340,3360,8715,11760,10185,11445,6090,3360,8295,7350,7350})
MiniSpamBtn.TextColor3 = BLACK
MiniSpamBtn.Font = Enum.Font.GothamSemibold
MiniSpamBtn.TextSize = 9
MiniSpamBtn.AutoButtonColor = false
MiniSpamBtn.Parent = MiniGuiFrame

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), MiniSpamBtn).CornerRadius = UDim.new(0, 6)

local function UpdateMiniUI()
    if State.TPParry then
        MiniTPBtn.BackgroundColor3 = AccentColor
        MiniTPBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,8400,3360,8400,10185,11970,11970,12705,6090,3360,8295,8190})
    else
        MiniTPBtn.BackgroundColor3 = LIGHT
        MiniTPBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,8400,3360,8400,10185,11970,11970,12705,6090,3360,8295,7350,7350})
    end

    if State.ManualSpam then
        MiniSpamBtn.BackgroundColor3 = AccentColor
        MiniSpamBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,11550,12285,10185,11340,3360,8715,11760,10185,11445,6090,3360,8295,8190})
    else
        MiniSpamBtn.BackgroundColor3 = LIGHT
        MiniSpamBtn.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,11550,12285,10185,11340,3360,8715,11760,10185,11445,6090,3360,8295,7350,7350})
    end
end

MiniTPBtn.MouseButton1Click:Connect(function()
    State.TPParry = not State.TPParry
    UpdateMiniUI()
end)

MiniSpamBtn.MouseButton1Click:Connect(function()
    State.ManualSpam = not State.ManualSpam
    UpdateMiniUI()
end)

-- Sistema Dragging Mini Gui
local MiniDragging, MiniDragStart, MiniStartPos = false, nil, nil

MiniGuiFrame.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        MiniDragging = true
        MiniDragStart = Input.Position
        MiniStartPos = MiniGuiFrame.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                MiniDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)
    if not MiniDragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - MiniDragStart
        MiniGuiFrame.Position = UDim2.new(
            MiniStartPos.X.Scale, MiniStartPos.X.Offset + Delta.X,
            MiniStartPos.Y.Scale, MiniStartPos.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
Main.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,11025,11550,9135,11025,11550,10500,11655,12495})
Main.Size = UDim2.new(0, 390, 0, 300)
Main.Position = UDim2.new(0.5, -195, 0.5, -150)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.ZIndex = 5
Main.Parent = Gui

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8715,12180,11970,11655,11235,10605}))
MainStroke.Color = LIGHT
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- Header
local Header = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
Title.Size = UDim2.new(1, -25, 0, 25)
Title.Position = UDim2.new(0, 15, 0, 7)
Title.BackgroundTransparency = 1
Title.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,12495,3360,7560,12285,10290,3360,9030,5460})
Title.TextColor3 = BLACK
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
Subtitle.Size = UDim2.new(1, -25, 0, 16)
Subtitle.Position = UDim2.new(0, 16, 0, 29)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,11340,10185,10500,10605,3360,6930,10185,11340,11340,3360,7035,11655,11970,10605,3360,23730,13440,17010,3360,8820,10185,11970,10815,10605,12180,3360,9240,9345,9450,3360,3990,3360,8505,12285,11025,10395,11235,3360,7035,11655,11550,12180,11970,11655,11340,12075})
Subtitle.TextColor3 = GRAY
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Sidebar
local Sidebar = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
Sidebar.Size = UDim2.new(0, 100, 1, -62)
Sidebar.Position = UDim2.new(0, 9, 0, 55)
Sidebar.BackgroundColor3 = WHITE
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Sidebar).CornerRadius = UDim.new(0, 10)

local SidePadding = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8400,10185,10500,10500,11025,11550,10815}))
SidePadding.PaddingTop = UDim.new(0, 6)
SidePadding.PaddingLeft = UDim.new(0, 5)
SidePadding.PaddingRight = UDim.new(0, 5)
SidePadding.Parent = Sidebar

local SideList = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7980,11025,12075,12180,7980,10185,12705,11655,12285,12180}))
SideList.Padding = UDim.new(0, 2)
SideList.Parent = Sidebar

-- Content
local Content = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
Content.Size = UDim2.new(1, -119, 1, -62)
Content.Position = UDim2.new(0, 114, 0, 55)
Content.BackgroundColor3 = WHITE
Content.BorderSizePixel = 0
Content.Parent = Main

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Content).CornerRadius = UDim.new(0, 10)

local ContentPadding = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8400,10185,10500,10500,11025,11550,10815}))
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 11)
ContentPadding.PaddingRight = UDim.new(0, 11)
ContentPadding.Parent = Content

-- Tabs System
local Tabs = {}
local TabButtons = {}

local function CreateTab(Name)
	local Button = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	Button.Name = Name .. tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,12285,12180,12180,11655,11550})
	Button.Size = UDim2.new(1, 0, 0, 31)
	Button.BackgroundTransparency = 1
	Button.Text = Name
	Button.TextColor3 = GRAY
	Button.Font = Enum.Font.GothamSemibold
	Button.TextSize = 10
	Button.AutoButtonColor = false
	Button.Parent = Sidebar

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Button).CornerRadius = UDim.new(0, 7)

	local Page = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10395,11970,11655,11340,11340,11025,11550,10815,7350,11970,10185,11445,10605}))
	Page.Name = Name
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 2
	Page.Visible = false
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.Parent = Content

	local Layout = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7980,11025,12075,12180,7980,10185,12705,11655,12285,12180}))
	Layout.Padding = UDim.new(0, 6)
	Layout.Parent = Page

	Layout:GetPropertyChangedSignal(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,10290,12075,11655,11340,12285,12180,10605,7035,11655,11550,12180,10605,11550,12180,8715,11025,12810,10605})):Connect(function()
		Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 15)
	end)

	Tabs[Name] = Page
	TabButtons[Name] = Button

	Button.MouseButton1Click:Connect(function()
		for TabName, PageObject in pairs(Tabs) do
			PageObject.Visible = TabName == Name
		end

		for TabName, ButtonObject in pairs(TabButtons) do
			if TabName == Name then
				ButtonObject.BackgroundTransparency = 0.9
				ButtonObject.BackgroundColor3 = AccentColor
				ButtonObject.TextColor3 = BLACK
			else
				ButtonObject.BackgroundTransparency = 1
				ButtonObject.TextColor3 = GRAY
			end
		end
	end)
end

for _, Name in ipairs({tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11655,11445,10605}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10185,11445}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11340,10500}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10605,12180,12180,11025,11550,10815,12075})}) do
	CreateTab(Name)
end

--==================================================
-- UI HELPERS
--==================================================

local function Section(Tab, Text)
	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(1, 0, 0, 20)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = BLACK
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 11
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Tabs[Tab]
end

local function Info(Tab, Text)
	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(1, 0, 0, 38)
	Label.BackgroundColor3 = BG
	Label.Text = Text
	Label.TextColor3 = GRAY
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 9
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Tabs[Tab]

	local Padding = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8400,10185,10500,10500,11025,11550,10815}))
	Padding.PaddingLeft = UDim.new(0, 8)
	Padding.PaddingRight = UDim.new(0, 8)
	Padding.Parent = Label

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Label).CornerRadius = UDim.new(0, 8)
    return Label
end

local function Toggle(Tab, Text, Callback)
	local Frame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Frame.Size = UDim2.new(1, 0, 0, 32)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.Parent = Tabs[Tab]

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(1, -55, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = BLACK
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 9
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local Button = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	Button.Size = UDim2.new(0, 32, 0, 18)
	Button.Position = UDim2.new(1, -41, 0.5, -9)
	Button.BackgroundColor3 = LIGHT
	Button.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
	Button.AutoButtonColor = false
	Button.Parent = Frame

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Button).CornerRadius = UDim.new(1, 0)

	local Dot = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Dot.Size = UDim2.new(0, 14, 0, 14)
	Dot.Position = UDim2.new(0, 2, 0.5, -7)
	Dot.BackgroundColor3 = WHITE
	Dot.BorderSizePixel = 0
	Dot.Parent = Button

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Dot).CornerRadius = UDim.new(1, 0)

	local Enabled = false

	Button.MouseButton1Click:Connect(function()
		Enabled = not Enabled

		TweenService:Create(Button, TweenInfo.new(0.15), {
			BackgroundColor3 = Enabled and AccentColor or LIGHT
		}):Play()

		TweenService:Create(Dot, TweenInfo.new(0.15), {
			Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
		}):Play()

		if Callback then Callback(Enabled) end
		UpdateMiniUI()
	end)
end

local function Button(Tab, Text, Callback)
	local Frame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Frame.Size = UDim2.new(1, 0, 0, 32)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.Parent = Tabs[Tab]

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Frame).CornerRadius = UDim.new(0, 8)

	local Btn = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundTransparency = 1
	Btn.Text = Text
	Btn.TextColor3 = BLACK
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 10
	Btn.Parent = Frame

	Btn.MouseButton1Click:Connect(function()
		if Callback then Callback() end
	end)
end

local function Slider(Tab, Text, Min, Max, Default, Callback)
	local Frame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Frame.Size = UDim2.new(1, 0, 0, 42)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.Parent = Tabs[Tab]

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(1, -60, 0, 18)
	Label.Position = UDim2.new(0, 10, 0, 2)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = BLACK
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 9
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local ValLabel = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	ValLabel.Size = UDim2.new(0, 50, 0, 18)
	ValLabel.Position = UDim2.new(1, -55, 0, 2)
	ValLabel.BackgroundTransparency = 1
	ValLabel.Text = tostring(Default)
	ValLabel.TextColor3 = GRAY
	ValLabel.Font = Enum.Font.GothamBold
	ValLabel.TextSize = 9
	ValLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValLabel.Parent = Frame

	local SlideBar = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	SlideBar.Size = UDim2.new(1, -20, 0, 8)
	SlideBar.Position = UDim2.new(0, 10, 0, 24)
	SlideBar.BackgroundColor3 = LIGHT
	SlideBar.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
	SlideBar.AutoButtonColor = false
	SlideBar.Parent = Frame

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), SlideBar).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	local startScale = (Default - Min) / (Max - Min)
	Fill.Size = UDim2.new(startScale, 0, 1, 0)
	Fill.BackgroundColor3 = AccentColor
	Fill.BorderSizePixel = 0
	Fill.Parent = SlideBar

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Fill).CornerRadius = UDim.new(1, 0)

	local dragging = false
	local function Update(input)
		local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
		local value = math.floor(Min + (Max - Min) * pos)
		Fill.Size = UDim2.new(pos, 0, 1, 0)
		ValLabel.Text = tostring(value)
		if Callback then Callback(value) end
	end

	SlideBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			Update(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			Update(input)
		end
	end)
end

local function Dropdown(Tab, Text, Options, Default, Callback)
	local Frame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Frame.Size = UDim2.new(1, 0, 0, 32)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.Parent = Tabs[Tab]

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = BLACK
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 9
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local SelectedBtn = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	SelectedBtn.Size = UDim2.new(0.45, -10, 0, 22)
	SelectedBtn.Position = UDim2.new(0.55, 0, 0.5, -11)
	SelectedBtn.BackgroundColor3 = LIGHT
	SelectedBtn.Text = Default or Options[1]
	SelectedBtn.TextColor3 = BLACK
	SelectedBtn.Font = Enum.Font.GothamBold
	SelectedBtn.TextSize = 9
	SelectedBtn.AutoButtonColor = false
	SelectedBtn.Parent = Frame

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), SelectedBtn).CornerRadius = UDim.new(0, 6)

	local currentIndex = table.find(Options, Default) or 1

	SelectedBtn.MouseButton1Click:Connect(function()
		currentIndex = (currentIndex % #Options) + 1
		local chosen = Options[currentIndex]
		SelectedBtn.Text = chosen
		if Callback then Callback(chosen) end
	end)
end

local function Input(Tab, Text, Placeholder, Callback)
	local Frame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
	Frame.Size = UDim2.new(1, 0, 0, 32)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.Parent = Tabs[Tab]

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
	Label.Size = UDim2.new(0.4, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = BLACK
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 9
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local TextBox = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,11655,12600}))
	TextBox.Size = UDim2.new(0.55, -10, 0, 22)
	TextBox.Position = UDim2.new(0.43, 0, 0.5, -11)
	TextBox.BackgroundColor3 = WHITE
	TextBox.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
	TextBox.PlaceholderText = Placeholder or tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
	TextBox.TextColor3 = BLACK
	TextBox.Font = Enum.Font.Gotham
	TextBox.TextSize = 9
	TextBox.Parent = Frame

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), TextBox).CornerRadius = UDim.new(0, 6)

	TextBox.FocusLost:Connect(function()
		if Callback then Callback(TextBox.Text) end
	end)
end

--==================================================
-- BUILD TABS & CONTENT
--==================================================

-- TAB: HOME
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11655,11445,10605}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7140,10185,12075,10920,10290,11655,10185,11970,10500,3360,8715,12180,10185,12180,12285,12075}))

local HookStatusInfo = Info(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11655,11445,10605}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,3360,8820,11655,11235,10605,11550,6090,3360,7665,11550,3360,6825,12180,12180,10605,12075,10185,3360,10500,10605,11340,3360,5145,20370,18480,3360,8400,10185,11970,11970,12705,4830,4830,4830}))
local BallStatusInfo = Info(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11655,11445,10605}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11340,11340,10185,6090,3360,8190,10605,12075,12075,12285,11550,10185,3360,13020,3360,7140,11025,12075,12180,10185,11550,12810,10185,6090,3360,5040,3360,12075,12180,12285,10500,12075}))

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if next(_reverted) then
                HookStatusInfo.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,3360,3990,3360,8820,11655,11235,10605,11550,3360,7035,10185,11760,12180,12285,11970,10605,10500,3360,23730,16380,15435})
                HookStatusInfo.TextColor3 = Color3.fromRGB(40, 180, 80)
            else
                HookStatusInfo.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,11445,11655,12180,10605,3360,8820,11655,11235,10605,11550,6090,3360,7350,10185,11025,3360,5145,3360,11760,10185,11970,11970,12705,3360,11445,10185,11550,12285,10185,11340,10605,3360,11760,10605,11970,3360,10395,10185,12180,12180,12285,11970,10185,11970,10605})
                HookStatusInfo.TextColor3 = GRAY
            end

            BallStatusInfo.Text = string.format(
                tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11025,11760,11655,6090,3360,3885,12075,3360,13020,3360,7140,11025,12075,12180,6090,3360,3885,10500,3360,12075,12180,12285,10500,12075,3360,13020,3360,9030,10605,11340,6090,3360,3885,10500,9660,11550,8820,10185,11970,10815,10605,12180,6090,3360,3885,12075,3360,13020,3360,8820,11970,10185,11025,10605,12180,12180,11655,11970,11025,10185,6090,3360,3885,12075}),
                BallInfo.Type, BallInfo.Distance, BallInfo.Speed, BallInfo.Target, BallInfo.Trajectory
            )
        end)
    end
end)

-- TAB: PARRY
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,12285,12180,11655,3360,8400,10185,11970,11970,12705,3360,8715,10605,12180,12180,11025,11550,10815,12075}))

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,12285,12180,11655,3360,8400,10185,11970,11970,12705,3360,4200,8085,10185,12180,10395,10920,4305}), function(v) State.AutoParry = v end)
Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,11550,12180,11025,3360,7140,11655,12285,10290,11340,10605,3360,4200,8085,10185,12180,10395,10920,4305}), function(v) State.AntiDoubleParry = v end)
Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,12285,12180,11655,3360,8400,10185,11970,11970,12705,3360,4200,8820,11970,10185,11025,11550,11025,11550,10815,4305}), function(v) State.TrainingAutoParry = v end)
Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,11550,12180,11025,3360,7140,11655,12285,10290,11340,10605,3360,4200,8820,11970,10185,11025,11550,11025,11550,10815,4305}), function(v) State.TrainingAntiDoubleParry = v end)
Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,8400,3360,8400,10185,11970,11970,12705,3360,4200,7980,12285,11445,11025,11550,11655,12285,12075,4305}), function(v) State.TPParry = v end)

Dropdown(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,12285,11970,12390,10605,3360,8085,11655,10500,10605}), {tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,10185,11445,10605,11970,10185}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10185,11970,10815,10605,12180}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11025,10815,10920}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10185,11550,10500,11655,11445}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,10185,10395,11235,12495,10185,11970,10500,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11340,11655,12495}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,10395,10395,10605,11340,10605,11970,10185,12180,10605,10500})}, tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,10185,11445,10605,11970,10185}), function(v)
    State.CurveMode = v
end)

Slider(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705,3360,7140,11025,12075,12180,10185,11550,10395,10605}), 5, 60, 25, function(v) State.ParryDistance = v end)
Slider(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,11970,10605,10500,11025,10395,12180,11025,11655,11550}), 10, 120, 55, function(v) State.Prediction = v / 100 end)

-- TAB: SPAM
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10185,11445}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,10185,11970,11970,12705,3360,8715,11760,10185,11445,11445,11025,11550,10815}))

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10185,11445}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,10185,11550,12285,10185,11340,3360,8715,11760,10185,11445}), function(v) State.ManualSpam = v end)
Slider(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11760,10185,11445}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,8400,8715,3360,8715,11760,10605,10605,10500}), 1, 500, 20, function(v) State.CPS = v end)

-- TAB: WORLD
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11340,10500}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,11340,10185,12705,10605,11970,3360,3990,3360,9135,11655,11970,11340,10500}))

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11340,10500}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8085,11655,12390,10605,11445,10605,11550,12180,3360,6930,12705,11760,10185,12075,12075}), function(v) State.MovementBypass = v end)
Slider(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11340,10500}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,10185,11340,11235,3360,8715,11760,10605,10605,10500}), 16, 250, 16, function(v) State.WalkSpeed = v end)
Button(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9135,11655,11970,11340,10500}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,8400,8715,3360,6930,11655,11655,12075,12180}), function()
    pcall(function() loadstring(game:HttpGet(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10920,12180,12180,11760,12075,6090,4935,4935,11970,10185,12495,12075,10395,11970,11025,11760,12180,12075,4830,11550,10605,12180,4935,11970,10185,12495,4935,8925,11550,11025,12390,10605,11970,12075,10185,11340,4725,8715,10395,11970,11025,11760,12180,4725,7350,11760,12075,6930,11655,11655,12075,12180,4725,5985,5250,5670,5040})))() end)
end)

-- TAB: EXCLUSIVES
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7035,11655,12075,11445,10605,12180,11025,10395,12075,3360,3990,3360,8925,11550,11340,11655,10395,11235,12075}))

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7875,11655,11970,10290,11340,11655,12600,3360,3990,3360,7560,10605,10185,10500,11340,10605,12075,12075}), function(v) State.KorbloxHeadless = v end)
Button(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,11550,11340,11655,10395,11235,3360,6825,11340,11340}), function()
    pcall(function() loadstring(game:HttpGet(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10920,12180,12180,11760,12075,6090,4935,4935,11760,10185,12075,12180,10605,10290,11025,11550,4830,10395,11655,11445,4935,11970,10185,12495,4935,12495,8715,12285,10920,8925,7350,8820,11970})))() end)
end)
Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,11235,11025,11550,3360,7035,10920,10185,11550,10815,10605,11970}), function(v) getgenv().skinChanger = v end)

Input(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,12495,11655,11970,10500,3360,8190,10185,11445,10605}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10605,12075,6090,3360,7035,11340,10185,12075,12075,11025,10395,8715,12495,11655,11970,10500}), function(v) getgenv().swordModel = v end)
Input(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,12495,11655,11970,10500,3360,7350,9240}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({10605,12075,6090,3360,7350,9240,8190,10185,11445,10605}), function(v) getgenv().swordFX = v end)

Button(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7245,12600,10395,11340,12285,12075,11025,12390,10605,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10185,12390,10605,3360,7035,11655,12075,11445,10605,12180,11025,10395,3360,7035,11655,11550,10710,11025,10815}), function()
    if getgenv().saveLastEquippedSword and getgenv().swordModel ~= tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({}) then getgenv().saveLastEquippedSword(getgenv().swordModel) end
    if getgenv().saveLastEquippedExplosion and getgenv().explosionFX ~= tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({}) then getgenv().saveLastEquippedExplosion(getgenv().explosionFX) end
end)

-- TAB: SETTINGS
Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10605,12180,12180,11025,11550,10815,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,11550,12180,10605,11970,10710,10185,10395,10605}))

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10605,12180,12180,11025,11550,10815,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,11970,10185,11550,12075,11760,10185,11970,10605,11550,12180,3360,8925,7665}), function(Value)
	TransparentUI = Value
	local MainTransparency = Value and 0.25 or 0
	local ContentTransparency = Value and 0.25 or 0
	local SidebarTransparency = Value and 0.25 or 0

	TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundTransparency = MainTransparency}):Play()
	TweenService:Create(Content, TweenInfo.new(0.2), {BackgroundTransparency = ContentTransparency}):Play()
	TweenService:Create(Sidebar, TweenInfo.new(0.2), {BackgroundTransparency = SidebarTransparency}):Play()
end)

Toggle(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10605,12180,12180,11025,11550,10815,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,11550,11025,11445,10185,12180,11025,11655,11550,12075}))

Section(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8715,10605,12180,12180,11025,11550,10815,12075}), tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,3360,7035,11655,11340,11655,11970}))

local ColorFrame = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
ColorFrame.Size = UDim2.new(1, 0, 0, 42)
ColorFrame.BackgroundColor3 = BG
ColorFrame.BorderSizePixel = 0
ColorFrame.Parent = Tabs.Settings

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), ColorFrame).CornerRadius = UDim.new(0, 8)

local ColorLabel = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,7980,10185,10290,10605,11340}))
ColorLabel.Size = UDim2.new(0, 70, 1, 0)
ColorLabel.Position = UDim2.new(0, 8, 0, 0)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6825,10395,10395,10605,11550,12180})
ColorLabel.TextColor3 = BLACK
ColorLabel.Font = Enum.Font.GothamSemibold
ColorLabel.TextSize = 9
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.Parent = ColorFrame

local ColorButtons = {
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({9345,10605,11340,11340,11655,12495}), Color3.fromRGB(255, 215, 0)},
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,11340,12285,10605}), Color3.fromRGB(60, 140, 255)},
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,12285,11970,11760,11340,10605}), Color3.fromRGB(160, 90, 255)},
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8610,10605,10500}), Color3.fromRGB(255, 75, 75)},
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7455,11970,10605,10605,11550}), Color3.fromRGB(70, 200, 120)},
	{tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8400,11025,11550,11235}), Color3.fromRGB(255, 90, 170)}
}

-- Floating Button Principal
local Float = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
Float.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11340,11655,10185,12180,11025,11550,10815,6930,12285,12180,12180,11655,11550})
Float.Size = UDim2.new(0, 52, 0, 52)
Float.Position = UDim2.new(1, -68, 0.5, -26)
Float.BackgroundColor3 = WHITE
Float.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
Float.AutoButtonColor = false
Float.ZIndex = 50
Float.Parent = Gui

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Float).CornerRadius = UDim.new(1, 0)

local FloatStroke = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,8715,12180,11970,11655,11235,10605}))
FloatStroke.Color = AccentColor
FloatStroke.Thickness = 2
FloatStroke.Parent = Float

local Cat = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7665,11445,10185,10815,10605,7980,10185,10290,10605,11340}))
Cat.Name = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({6930,11340,10185,10395,11235,7035,10185,12180,7665,10395,11655,11550})
Cat.Size = UDim2.new(0, 30, 0, 30)
Cat.Position = UDim2.new(0.5, -15, 0.5, -15)
Cat.BackgroundTransparency = 1
Cat.Image = CAT_ICON_ID
Cat.ImageColor3 = Color3.fromRGB(0, 0, 0)
Cat.ScaleType = Enum.ScaleType.Fit
Cat.ZIndex = 51
Cat.Parent = Float

local AccentDot = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7350,11970,10185,11445,10605}))
AccentDot.Size = UDim2.new(0, 7, 0, 7)
AccentDot.Position = UDim2.new(1, -10, 0, 4)
AccentDot.BackgroundColor3 = AccentColor
AccentDot.BorderSizePixel = 0
AccentDot.ZIndex = 52
AccentDot.Parent = Float

Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), AccentDot).CornerRadius = UDim.new(1, 0)

for Index, Data in ipairs(ColorButtons) do
	local Name = Data[1]
	local Color = Data[2]

	local Button = Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
	Button.Name = Name
	Button.Size = UDim2.new(0, 22, 0, 22)
	Button.Position = UDim2.new(0, 82 + ((Index - 1) * 27), 0.5, -11)
	Button.BackgroundColor3 = Color
	Button.Text = tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({})
	Button.AutoButtonColor = false
	Button.Parent = ColorFrame

	Instance.new(tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({8925,7665,7035,11655,11970,11550,10605,11970}), Button).CornerRadius = UDim.new(1, 0)

	Button.MouseButton1Click:Connect(function()
		AccentColor = Color
		FloatStroke.Color = AccentColor
		AccentDot.BackgroundColor3 = AccentColor
		UpdateMiniUI()

		for TabName, TabButton in pairs(TabButtons) do
			if Tabs[TabName].Visible then
				TabButton.BackgroundColor3 = AccentColor
			end
		end
	end)
end

-- Seleziona il Tab iniziale tjHaIQljQdkPdaNXpHcQRzgVdbGijCUerGxjyirJoKDzcwltHaBEogfnnZTLBxaAKzsntXgsREEiFMNkOVHQmTuGJzpRki({7560,11655,11445,10605})
Tabs.Home.Visible = true
TabButtons.Home.BackgroundTransparency = 0.9
TabButtons.Home.BackgroundColor3 = AccentColor
TabButtons.Home.TextColor3 = BLACK

-- Animazione Icona Gatto
task.spawn(function()
	while Float and Float.Parent do
		TweenService:Create(Cat, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = -7}):Play()
		task.wait(0.55)
		TweenService:Create(Cat, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 7}):Play()
		task.wait(0.55)
	end
end)

-- Dragging Bottone Fluttuante
local Dragging, DragStart, StartPosition, Moved = false, nil, nil, false

Float.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true
		Moved = false
		DragStart = Input.Position
		StartPosition = Float.Position

		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
				if not Moved then
					Opened = not Opened
					if Opened then
						Main.Visible = true
						Main.Size = UDim2.new(0, 1, 0, 1)
						TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 390, 0, 300)}):Play()
					else
						local CloseTween = TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 1, 0, 1)})
						CloseTween:Play()
						CloseTween.Completed:Connect(function()
							if not Opened then Main.Visible = false end
						end)
					end
				end
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(Input)
	if not Dragging then return end
	if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
		local Delta = Input.Position - DragStart
		if math.abs(Delta.X) > 5 or math.abs(Delta.Y) > 5 then Moved = true end
		Float.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
	end
end)

-- Dragging Finestra Principale
local MainDragging, MainDragStart, MainStartPosition = false, nil, nil

Header.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		MainDragging = true
		MainDragStart = Input.Position
		MainStartPosition = Main.Position

		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then MainDragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(Input)
	if not MainDragging then return end
	if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
		local Delta = Input.Position - MainDragStart
		Main.Position = UDim2.new(MainStartPosition.X.Scale, MainStartPosition.X.Offset + Delta.X, MainStartPosition.Y.Scale, MainStartPosition.Y.Offset + Delta.Y)
	end
end)

-- Ottimizzazione per Dispositivi Mobile
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
	Main.Size = UDim2.new(0.88, 0, 0, 280)
	Main.Position = UDim2.new(0.06, 0, 0.5, -140)
	Float.Size = UDim2.new(0, 50, 0, 50)
	Float.Position = UDim2.new(1, -62, 0.5, -25)
end
    
