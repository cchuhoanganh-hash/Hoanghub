-- ==========================================
-- HOANG HUB PREMIUM V15.4 - PC WINDOWS BUTTONS
-- TÍCH HỢP NÚT: THU NHỎ (-), PHÓNG TO (▢), XÓA SỔ (X)
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()

-- Đảm bảo PlayerGui đã sẵn sàng
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

-- Xóa bản cũ tránh trùng lặp
if PlayerGui:FindFirstChild("HoangHub_Fixed_Solara") then
    PlayerGui["HoangHub_Fixed_Solara"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoangHub_Fixed_Solara"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local EspEnabled = false
local SilentAimEnabled = false
local FOV_Radius = 200
local FOV_Y_Offset = 0
local TargetPlayer = nil
local IsMaximized = false -- Trạng thái phóng to của hình vuông

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Name = "HoangToggle"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 20, 0, 150)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "H"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 28
ToggleButton.Active = true
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "HoangMain"
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0, 100, 0, 150)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 180, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Hoang Hub Premium"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ==========================================
-- BỘ BA NÚT ĐIỀU HƯỚNG MỚI (PHẢI TIÊU ĐỀ)
-- ==========================================
local ButtonContainer = Instance.new("Frame", MainFrame)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(1, -105, 0, 7)
ButtonContainer.Size = UDim2.new(0, 95, 0, 26)

-- 1. NÚT DẤU TRỪ (-) ĐỂ ẨN MENU
local MinimizeBtn = Instance.new("TextButton", ButtonContainer)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 18
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

-- 2. NÚT HÌNH VUÔNG (▢) ĐỂ TĂNG KÍCH THƯỚC
local MaximizeBtn = Instance.new("TextButton", ButtonContainer)
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MaximizeBtn.Position = UDim2.new(0, 32, 0, 0)
MaximizeBtn.Size = UDim2.new(0, 26, 0, 26)
MaximizeBtn.Font = Enum.Font.SourceSansBold
MaximizeBtn.Text = "▢"
MaximizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MaximizeBtn.TextSize = 14
Instance.new("UICorner", MaximizeBtn).CornerRadius = UDim.new(0, 4)

-- 3. NÚT DẤU X ĐỂ XOÁ HOÀN TOÀN GUI
local CloseBtn = Instance.new("TextButton", ButtonContainer)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Position = UDim2.new(0, 64, 0, 0)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- ==========================================
-- THÀNH PHẦN LOGIC TÍNH NĂNG TRONG MENU
-- ==========================================
local SpeedSlider = Instance.new("Frame", MainFrame)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedSlider.Position = UDim2.new(0, 15, 0, 50)
SpeedSlider.Size = UDim2.new(0, 270, 0, 38)
Instance.new("UICorner", SpeedSlider).CornerRadius = UDim.new(0, 6)

local SpeedTitle = Instance.new("TextLabel", SpeedSlider)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Position = UDim2.new(0, 10, 0, 0)
SpeedTitle.Size = UDim2.new(0, 150, 0, 38)
SpeedTitle.Font = Enum.Font.Gotham
SpeedTitle.Text = "Tốc độ chạy:"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextSize = 13
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Left

local SpeedInput = Instance.new("TextBox", SpeedSlider)
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInput.Position = UDim2.new(1, -90, 0, 6)
SpeedInput.Size = UDim2.new(0, 80, 0, 26)
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.Text = "16"
SpeedInput.TextColor3 = Color3.fromRGB(0, 255, 128)
SpeedInput.TextSize = 13
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 4)

local JumpSlider = Instance.new("Frame", MainFrame)
JumpSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JumpSlider.Position = UDim2.new(0, 15, 0, 100)
JumpSlider.Size = UDim2.new(0, 270, 0, 38)
Instance.new("UICorner", JumpSlider).CornerRadius = UDim.new(0, 6)

local JumpTitle = Instance.new("TextLabel", JumpSlider)
JumpTitle.BackgroundTransparency = 1
JumpTitle.Position = UDim2.new(0, 10, 0, 0)
JumpTitle.Size = UDim2.new(0, 150, 0, 38)
JumpTitle.Font = Enum.Font.Gotham
JumpTitle.Text = "Độ nhảy cao:"
JumpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpTitle.TextSize = 13
JumpTitle.TextXAlignment = Enum.TextXAlignment.Left

local JumpInput = Instance.new("TextBox", JumpSlider)
JumpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpInput.Position = UDim2.new(1, -90, 0, 6)
JumpInput.Size = UDim2.new(0, 80, 0, 26)
JumpInput.Font = Enum.Font.GothamBold
JumpInput.Text = "50"
JumpInput.TextColor3 = Color3.fromRGB(0, 128, 255)
JumpInput.TextSize = 13
Instance.new("UICorner", JumpInput).CornerRadius = UDim.new(0, 4)

local EspButton = Instance.new("TextButton", MainFrame)
EspButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
EspButton.Position = UDim2.new(0, 15, 0, 150)
EspButton.Size = UDim2.new(0, 270, 0, 38)
EspButton.Font = Enum.Font.GothamBold
EspButton.Text = "BẬT ESP: [TẮT]"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.TextSize = 13
Instance.new("UICorner", EspButton).CornerRadius = UDim.new(0, 6)

local AimbotButton = Instance.new("TextButton", MainFrame)
AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
AimbotButton.Position = UDim2.new(0, 15, 0, 200)
AimbotButton.Size = UDim2.new(0, 270, 0, 38)
AimbotButton.Font = Enum.Font.GothamBold
AimbotButton.Text = "GHIM CHIÊU (SILENT): [TẮT]"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 13
Instance.new("UICorner", AimbotButton).CornerRadius = UDim.new(0, 6)

local FovSettingFrame = Instance.new("Frame", MainFrame)
FovSettingFrame.BackgroundTransparency = 1
FovSettingFrame.Position = UDim2.new(0, 15, 0, 250)
FovSettingFrame.Size = UDim2.new(0, 270, 0, 60)

local FovSizeInput = Instance.new("TextBox", FovSettingFrame)
FovSizeInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FovSizeInput.Position = UDim2.new(0, 0, 0, 0)
FovSizeInput.Size = UDim2.new(0, 125, 0, 35)
FovSizeInput.Font = Enum.Font.GothamBold
FovSizeInput.Text = "200"
FovSizeInput.TextColor3 = Color3.fromRGB(255, 215, 0)
FovSizeInput.TextSize = 14
Instance.new("UICorner", FovSizeInput).CornerRadius = UDim.new(0, 5)

local FovSizeLabel = Instance.new("TextLabel", FovSettingFrame)
FovSizeLabel.BackgroundTransparency = 1
FovSizeLabel.Position = UDim2.new(0, 0, 0, 38)
FovSizeLabel.Size = UDim2.new(0, 125, 0, 15)
FovSizeLabel.Font = Enum.Font.Gotham
FovSizeLabel.Text = "Kích cỡ FOV"
FovSizeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FovSizeLabel.TextSize = 11

local FovHeightInput = Instance.new("TextBox", FovSettingFrame)
FovHeightInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FovHeightInput.Position = UDim2.new(1, -125, 0, 0)
FovHeightInput.Size = UDim2.new(0, 125, 0, 35)
FovHeightInput.Font = Enum.Font.GothamBold
FovHeightInput.Text = "0"
FovHeightInput.TextColor3 = Color3.fromRGB(255, 215, 0)
FovHeightInput.TextSize = 14
Instance.new("UICorner", FovHeightInput).CornerRadius = UDim.new(0, 5)

local FovHeightLabel = Instance.new("TextLabel", FovSettingFrame)
FovHeightLabel.BackgroundTransparency = 1
FovHeightLabel.Position = UDim2.new(1, -125, 0, 38)
FovHeightLabel.Size = UDim2.new(0, 125, 0, 15)
FovHeightLabel.Font = Enum.Font.Gotham
FovHeightLabel.Text = "Chiều cao FOV"
FovHeightLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FovHeightLabel.TextSize = 11

local Footer = Instance.new("TextLabel", MainFrame)
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Font = Enum.Font.SourceSansItalic
Footer.Text = "Hoang Hub - Click [✕] to Delete GUI Permanently"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.TextSize = 11

-- Đồ họa vẽ vòng tròn FOV & Line bằng Drawing API PC
local FovCircle = Drawing.new("Circle")
FovCircle.Color = Color3.fromRGB(255, 215, 0)
FovCircle.Thickness = 1.5
FovCircle.NumSides = 64
FovCircle.Filled = false 
FovCircle.Visible = false

local TracerLine = Drawing.new("Line")
TracerLine.Color = Color3.fromRGB(255, 215, 0)
TracerLine.Thickness = 1.5
TracerLine.Visible = false

-- ==========================================
-- SỰ KIỆN XỬ LÝ CHO 3 NÚT ĐIỀU HƯỚNG MỚI
-- ==========================================

-- 1. Xử lý nút Dấu trừ (-): Ẩn Menu chính đi
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 2. Xử lý nút Hình vuông (▢): Co giãn tăng/giảm kích thước GUI
MaximizeBtn.MouseButton1Click:Connect(function()
    IsMaximized = not IsMaximized
    if IsMaximized then
        MainFrame.Size = UDim2.new(0, 420, 0, 450) -- Tăng to rộng rãi ra
        SpeedSlider.Size = UDim2.new(0, 390, 0, 42)
        JumpSlider.Size = UDim2.new(0, 390, 0, 42)
        EspButton.Size = UDim2.new(0, 390, 0, 42)
        AimbotButton.Size = UDim2.new(0, 390, 0, 42)
        FovSettingFrame.Size = UDim2.new(0, 390, 0, 60)
        FovSizeInput.Size = UDim2.new(0, 180, 0, 38)
        FovHeightInput.Size = UDim2.new(0, 180, 0, 38)
        MaximizeBtn.Text = "⧉" -- Đổi icon biểu thị thu nhỏ lại dạng cũ
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 380) -- Về lại kích thước gốc
        SpeedSlider.Size = UDim2.new(0, 270, 0, 38)
        JumpSlider.Size = UDim2.new(0, 270, 0, 38)
        EspButton.Size = UDim2.new(0, 270, 0, 38)
        AimbotButton.Size = UDim2.new(0, 270, 0, 38)
        FovSettingFrame.Size = UDim2.new(0, 270, 0, 60)
        FovSizeInput.Size = UDim2.new(0, 125, 0, 35)
        FovHeightInput.Size = UDim2.new(0, 125, 0, 35)
        MaximizeBtn.Text = "▢"
    end
end)

-- Biến kiểm soát trạng thái hoạt động của Script
local ScriptRunning = true

-- 3. Xử lý nút Dấu X (✕): XOÁ SỔ HOÀN TOÀN KHÔNG ĐỂ LẠI DẤU VẾT
CloseBtn.MouseButton1Click:Connect(function()
    ScriptRunning = false -- Dừng các tác vụ lặp ngầm
    
    -- Tắt và xoá bỏ toàn bộ ESP đang gắn trên nhân vật người chơi khác
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local b = p.Character.Head:FindFirstChild("EspBillboard")
            if b then b:Destroy() end
        end
    end
    
    -- Xoá bỏ thư viện vẽ FOV và Snapline ngoài màn hình
    if FovCircle then FovCircle:Remove() end
    if TracerLine then TracerLine:Remove() end
    
    -- Huỷ hoàn toàn bộ giao diện ScreenGui khỏi PlayerGui của Roblox
    ScreenGui:Destroy()
end)

-- Nút chữ H bên ngoài vẫn giữ nguyên để kích hoạt hiện lại sau khi bấm nút (-) trừ
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Phím tắt K dự phòng
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K and ScriptRunning then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ==========================================
-- LOGIC GAMEPLAY CHẠY NGẦM (GIỮ NGUYÊN)
-- ==========================================
local function getBloxFruitLevel(player)
    local success, lvl = pcall(function() return player.Data.Level.Value end)
    return success and lvl or "Loading..."
end

local function isValidTarget(player)
    if not ScriptRunning then return false end
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then return false end

    local pvpSuccess, pvpDisabled = pcall(function()
        return player.Character:FindFirstChild("PVPDisabled") or (player:FindFirstChild("Data") and player.Data:FindFirstChild("PVP") and player.Data.PVP.Value == false)
    end)
    if pvpSuccess and pvpDisabled then return false end
    return true
end

local function getClosestPlayerInFov(customCenter)
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - customCenter).Magnitude
                if distance < shortestDistance and distance <= FOV_Radius then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Hook Metatable chặn đạn / chiêu thức ghim vào mục tiêu
local Meta = mt or getrawmetatable(game)
if Meta and setreadonly then
    setreadonly(Meta, false)
    local OldIndex = Meta.__index

    Meta.__index = newcclosure(function(self, index)
        if ScriptRunning and SilentAimEnabled and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if tostring(self) == "Mouse" or self == Mouse then
                if index == "Hit" then
                    return TargetPlayer.Character.HumanoidRootPart.CFrame
                elseif index == "Target" then
                    return TargetPlayer.Character.HumanoidRootPart
                end
            end
        end
        return OldIndex(self, index)
    end)
    setreadonly(Meta, true)
end

-- Vòng lặp RenderStepped cập nhật vẽ liên tục
RunService.RenderStepped:Connect(function()
    if not ScriptRunning then return end

    local customRadius = tonumber(FovSizeInput.Text)
    if customRadius then 
        FOV_Radius = customRadius 
        FovCircle.Radius = customRadius
    end
    
    local customHeight = tonumber(FovHeightInput.Text)
    if customHeight then FOV_Y_Offset = customHeight end

    local baseCenterX = Camera.ViewportSize.X / 2
    local baseCenterY = Camera.ViewportSize.Y / 2
    local customCenterY = baseCenterY - FOV_Y_Offset
    local targetCenter = Vector2.new(baseCenterX, customCenterY)
    
    if SilentAimEnabled then
        FovCircle.Position = targetCenter
        FovCircle.Visible = true
        
        TargetPlayer = getClosestPlayerInFov(targetCenter)
        
        if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = TargetPlayer.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                TracerLine.From = targetCenter
                TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                TracerLine.Visible = true
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    else
        TargetPlayer = nil
        FovCircle.Visible = false
        TracerLine.Visible = false
    end

    -- Đồng bộ WalkSpeed và JumpPower
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local targetSpeed = tonumber(SpeedInput.Text)
        if targetSpeed then Humanoid.WalkSpeed = targetSpeed end
        local targetJump = tonumber(JumpInput.Text)
        if targetJump then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = targetJump
        end
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    if not ScriptRunning then return end
    SilentAimEnabled = not SilentAimEnabled
    if SilentAimEnabled then
        AimbotButton.Text = "GHIM CHIÊU (SILENT): [BẬT]"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        AimbotButton.Text = "GHIM CHIÊU (SILENT): [TẮT]"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

-- Tạo ESP
local function createEsp(player)
    if player == LocalPlayer then return end
    local function applyEsp(character)
        local head = character:WaitForChild("Head", 5)
        if not head or head:FindFirstChild("EspBillboard") then return end

        local billboard = Instance.new("BillboardGui", head)
        billboard.Name = "EspBillboard"
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)

        local infoLabel = Instance.new("TextLabel", billboard)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Size = UDim2.new(1, 0, 0, 35)
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 12
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.TextStrokeTransparency = 0

        local healthBackground = Instance.new("Frame", billboard)
        healthBackground.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        healthBackground.Position = UDim2.new(0.15, 0, 0.65, 0)
        healthBackground.Size = UDim2.new(0, 140, 0, 5)
        healthBackground.BorderSizePixel = 0

        local healthBar = Instance.new("Frame", healthBackground)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BorderSizePixel = 0

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not ScriptRunning or not EspEnabled or not character:IsDescendantOf(workspace) or not character:FindFirstChild("Humanoid") then
                billboard:Destroy()
                connection:Disconnect()
                return
            end
            local humanoid = character.Humanoid
            local lvl = getBloxFruitLevel(player)
            infoLabel.Text = string.format("%s \n[Lvl: %s]", player.Name, tostring(lvl))
            local healthRatio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            healthBar.Size = UDim2.new(healthRatio, 0, 1, 0)
        end)
    end
    if player.Character then applyEsp(player.Character) end
    player.CharacterAdded:Connect(applyEsp)
end

EspButton.MouseButton1Click:Connect(function()
    if not ScriptRunning then return end
    EspEnabled = not EspEnabled
    if EspEnabled then
        EspButton.Text = "BẬT ESP: [BẬT]"
        EspButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        for _, p in ipairs(Players:GetPlayers()) do createEsp(p) end
    else
        EspButton.Text = "BẬT ESP: [TẮT]"
        EspButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local b = p.Character.Head:FindFirstChild("EspBillboard")
                if b then b:Destroy() end
            end
        end
    end
end)
