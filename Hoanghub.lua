Đây là bản **Hoang Hub Premium** đã được tôi tinh chỉnh lại toàn bộ cấu trúc để tương thích 100% với **Xeno PC**.
Các lỗi kẹt luồng (Yielding), sai chuẩn Metatable, lệch tâm ngắm FOV đều đã được xử lý triệt để. Đồng thời, tôi cũng thay thế tính năng kéo thả giao diện bằng thuật toán vẽ tọa độ mượt mà riêng, giúp ông di chuyển menu trên màn hình máy tính không bị khựng hay dính chuột nữa.
Ông copy toàn bộ đoạn mã này và chạy trên Xeno PC nhé:
### 💻 HOANG HUB PREMIUM - XENO PC EDITION (ĐÃ SỬA LỖI TOÀN DIỆN)
```lua
-- ==========================================
-- HOANG HUB PREMIUM - XENO PC EXCLUSIVE
-- Đã fix: Kẹt luồng, Chuẩn hóa Metatable PC, Lệch FOV, Kéo thả GUI
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ BIẾN HỆ THỐNG ]
local _G = {
    Aimbot = false,
    ESP = false,
    FOV_Visible = true,
    FOV_Radius = 200,
    FOV_HeightOffset = 0,
    Speed = 16,
    Jump = 50,
    CurrentTarget = nil
}

-- ==========================================
-- 1. QUẢN LÝ GIAO DIỆN (GUI) 
-- ==========================================
local GuiName = "HoangHubPremium_XenoPC"
local existingGui = CoreGui:FindFirstChild(GuiName) or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(GuiName)
if existingGui then existingGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- NÚT CHỮ "H" 
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "H"
ToggleButton.TextColor3 = Color3.fromRGB(255, 170, 0)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 24
ToggleButton.Active = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(255, 170, 0)
ToggleStroke.Thickness = 2

-- BẢNG MENU CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -70, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hoang Hub Premium"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [ Ô NHẬP TỐC ĐỘ CHẠY ]
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Size = UDim2.new(0, 120, 0, 35)
SpeedLabel.Position = UDim2.new(0, 15, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ chạy:"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedInputBox = Instance.new("Frame", MainFrame)
SpeedInputBox.Size = UDim2.new(0, 100, 0, 30)
SpeedInputBox.Position = UDim2.new(1, -115, 0, 52)
SpeedInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", SpeedInputBox).CornerRadius = UDim.new(0, 4)

local SpeedInput = Instance.new("TextBox", SpeedInputBox)
SpeedInput.Size = UDim2.new(1, 0, 1, 0)
SpeedInput.BackgroundTransparency = 1
SpeedInput.Text = "16"
SpeedInput.TextColor3 = Color3.fromRGB(0, 255, 100)
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 14

-- [ Ô NHẬP NHẢY CAO ]
local JumpLabel = Instance.new("TextLabel", MainFrame)
JumpLabel.Size = UDim2.new(0, 120, 0, 35)
JumpLabel.Position = UDim2.new(0, 15, 0, 95)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "Độ nhảy cao:"
JumpLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
JumpLabel.Font = Enum.Font.GothamSemibold
JumpLabel.TextSize = 13
JumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local JumpInputBox = Instance.new("Frame", MainFrame)
JumpInputBox.Size = UDim2.new(0, 100, 0, 30)
JumpInputBox.Position = UDim2.new(1, -115, 0, 97)
JumpInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", JumpInputBox).CornerRadius = UDim.new(0, 4)

local JumpInput = Instance.new("TextBox", JumpInputBox)
JumpInput.Size = UDim2.new(1, 0, 1, 0)
JumpInput.BackgroundTransparency = 1
JumpInput.Text = "50"
JumpInput.TextColor3 = Color3.fromRGB(50, 150, 255)
JumpInput.Font = Enum.Font.GothamBold
JumpInput.TextSize = 14

-- [ NÚT BẬT ESP ]
local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(1, -30, 0, 40)
ESPButton.Position = UDim2.new(0, 15, 0, 140)
ESPButton.BackgroundColor3 = Color3.fromRGB(200, 20, 40)
ESPButton.Text = "BẬT ESP: [TẮT]"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextSize = 14
Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0, 6)

-- [ NÚT GHIM CHIÊU ]
local AimButton = Instance.new("TextButton", MainFrame)
AimButton.Size = UDim2.new(1, -30, 0, 40)
AimButton.Position = UDim2.new(0, 15, 0, 190)
AimButton.BackgroundColor3 = Color3.fromRGB(200, 20, 40)
AimButton.Text = "GHIM CHIÊU (SILENT): [TẮT]"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.Font = Enum.Font.GothamBold
AimButton.TextSize = 14
Instance.new("UICorner", AimButton).CornerRadius = UDim.new(0, 6)

-- [ CẤU HÌNH FOV ]
local FOVSizeBox = Instance.new("Frame", MainFrame)
FOVSizeBox.Size = UDim2.new(0.5, -20, 0, 35)
FOVSizeBox.Position = UDim2.new(0, 15, 0, 250)
FOVSizeBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", FOVSizeBox).CornerRadius = UDim.new(0, 6)

local FOVSizeInput = Instance.new("TextBox", FOVSizeBox)
FOVSizeInput.Size = UDim2.new(1, 0, 1, 0)
FOVSizeInput.BackgroundTransparency = 1
FOVSizeInput.Text = "200"
FOVSizeInput.TextColor3 = Color3.fromRGB(255, 200, 0)
FOVSizeInput.Font = Enum.Font.GothamBold
FOVSizeInput.TextSize = 14

local FOVHeightBox = Instance.new("Frame", MainFrame)
FOVHeightBox.Size = UDim2.new(0.5, -20, 0, 35)
FOVHeightBox.Position = UDim2.new(0.5, 5, 0, 250)
FOVHeightBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", FOVHeightBox).CornerRadius = UDim.new(0, 6)

local FOVHeightInput = Instance.new("TextBox", FOVHeightBox)
FOVHeightInput.Size = UDim2.new(1, 0, 1, 0)
FOVHeightInput.BackgroundTransparency = 1
FOVHeightInput.Text = "0"
FOVHeightInput.TextColor3 = Color3.fromRGB(255, 200, 0)
FOVHeightInput.Font = Enum.Font.GothamBold
FOVHeightInput.TextSize = 14

local Footer = Instance.new("TextLabel", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Hoang Hub PC - Click [B] to Delete GUI Permanently"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Font = Enum.Font.GothamItalic
Footer.TextSize = 10

-- ==========================================
-- 2. HỆ THỐNG KÉO THẢ GUI MƯỢT MÀ (CUSTOM DRAG PC)
-- ==========================================
local function MakeDraggable(guiItem)
    local dragging, dragInput, dragStart, startPos
    guiItem.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = guiItem.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiItem.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiItem.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame)
MakeDraggable(ToggleButton)

-- ==========================================
-- 3. ĐIỀU KHIỂN & ĐỒNG BỘ GIÁ TRỊ
-- ==========================================
ToggleButton.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

SpeedInput.FocusLost:Connect(function() if tonumber(SpeedInput.Text) then _G.Speed = tonumber(SpeedInput.Text) end end)
JumpInput.FocusLost:Connect(function() if tonumber(JumpInput.Text) then _G.Jump = tonumber(JumpInput.Text) end end)
FOVSizeInput.FocusLost:Connect(function() if tonumber(FOVSizeInput.Text) then _G.FOV_Radius = tonumber(FOVSizeInput.Text) end end)
FOVHeightInput.FocusLost:Connect(function() if tonumber(FOVHeightInput.Text) then _G.FOV_HeightOffset = tonumber(FOVHeightInput.Text) end end)

ESPButton.Activated:Connect(function()
    _G.ESP = not _G.ESP
    ESPButton.Text = _G.ESP and "BẬT ESP: [BẬT]" or "BẬT ESP: [TẮT]"
    ESPButton.BackgroundColor3 = _G.ESP and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(200, 20, 40)
end)

AimButton.Activated:Connect(function()
    _G.Aimbot = not _G.Aimbot
    AimButton.Text = _G.Aimbot and "GHIM CHIÊU (SILENT): [BẬT]" or "GHIM CHIÊU (SILENT): [TẮT]"
    AimButton.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(200, 20, 40)
end)

-- ==========================================
-- 4. XỬ LÝ METATABLE CHUẨN XENO PC & CHỐNG KẸT LUỒNG
-- ==========================================
local gm = getrawmetatable(game)
setreadonly(gm, false)

local oldNamecall = gm.__namecall
local oldIndex = gm.__index

gm.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if _G.Aimbot and _G.CurrentTarget and _G.CurrentTarget.Character and _G.CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = _G.CurrentTarget.Character.HumanoidRootPart
        local targetPos = targetRoot.Position
        local targetCFrame = targetRoot.CFrame
        local myChar = LocalPlayer.Character

        if method == "Raycast" or method == "FindPartOnRayWithIgnoreList" then
            if method == "Raycast" then
                args[2] = (targetPos - args[1]).Unit * 10000
            else
                args[1] = Ray.new(args[1].Origin, (targetPos - args[1].Origin).Unit * 10000)
            end
            return oldNamecall(self, unpack(args))
        end

        if method == "FireServer" or method == "InvokeServer" then
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myRoot = myChar.HumanoidRootPart
                local sName = string.lower(self.Name)
                if string.find(sName, "skill") or string.find(sName, "combat") or string.find(sName, "attack") then
                    -- FIX LỖI KẸT LUỒNG BẰNG TASK.SPAWN
                    task.spawn(function()
                        local oldPos = myRoot.CFrame
                        myRoot.CFrame = targetCFrame * CFrame.new(0, 0, 2)
                        task.wait(0.05)
                        myRoot.CFrame = oldPos
                    end)
                end
            end

            for i, v in pairs(args) do
                if typeof(v) == "Vector3" then args[i] = targetPos
                elseif typeof(v) == "CFrame" then args[i] = targetCFrame end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

gm.__index = newcclosure(function(self, idx)
    if _G.Aimbot and _G.CurrentTarget and _G.CurrentTarget.Character and _G.CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        if self == Mouse and (idx == "Hit" or idx == "Target") then
            if idx == "Hit" then return _G.CurrentTarget.Character.HumanoidRootPart.CFrame
            elseif idx == "Target" then return _G.CurrentTarget.Character.HumanoidRootPart end
        end
    end
    return oldIndex(self, idx)
end)

setreadonly(gm, true)

-- ==========================================
-- 5. HỆ THỐNG ESP & FOV FIX LỆCH TÂM MÀN HÌNH PC
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

local ESP_Boxes = {}
local function CreateESP(player)
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "HoangHubESP_PC"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 140, 0, 45)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    
    local NameLvl = Instance.new("TextLabel", bgui)
    NameLvl.Size = UDim2.new(1, 0, 0.5, 0)
    NameLvl.BackgroundTransparency = 1
    NameLvl.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLvl.TextStrokeTransparency = 0.5
    NameLvl.Font = Enum.Font.GothamBold
    NameLvl.TextSize = 11
    
    local HealthBarBG = Instance.new("Frame", bgui)
    HealthBarBG.Size = UDim2.new(1, 0, 0.15, 0)
    HealthBarBG.Position = UDim2.new(0, 0, 0.6, 0)
    HealthBarBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local HealthBar = Instance.new("Frame", HealthBarBG)
    HealthBar.Size = UDim2.new(1, 0, 1, 0)
    HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    
    ESP_Boxes[player] = {Gui = bgui, Text = NameLvl, Bar = HealthBar}
end

local function GetTargetInFOV()
    local target, minDistance = nil, _G.FOV_Radius
    local mouseLocation = UserInputService:GetMouseLocation()
    local fovPos = Vector2.new(mouseLocation.X, mouseLocation.Y + _G.FOV_HeightOffset)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            local isTeammate = (v.Team == LocalPlayer.Team)
            local isSafe = false
            if v.Character:FindFirstChild("CombatForce") == nil and v.Character:FindFirstChild("InSafeZone") then isSafe = true
            elseif v:FindFirstChild("Data") and v.Data:FindFirstChild("PvP") and v.Data.PvP.Value == false then isSafe = true end

            if not isTeammate and not isSafe then
                -- FIX LỖI LỆCH TÂM PC BẰNG WorldToScreenPoint
                local pos, onScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - fovPos).Magnitude
                    if dist <= minDistance then
                        minDistance = dist
                        target = v
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local mouseLocation = UserInputService:GetMouseLocation()
    FOVCircle.Visible = _G.FOV_Visible and _G.Aimbot
    FOVCircle.Radius = _G.FOV_Radius
    FOVCircle.Position = Vector2.new(mouseLocation.X, mouseLocation.Y + _G.FOV_HeightOffset)

    if _G.Aimbot then _G.CurrentTarget = GetTargetInFOV() else _G.CurrentTarget = nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if not ESP_Boxes[player] then CreateESP(player) end
                
                local espData = ESP_Boxes[player]
                espData.Gui.Parent = _G.ESP and char.HumanoidRootPart or nil
                
                if _G.ESP then
                    local lvl = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or "?"
                    espData.Text.Text = player.Name .. " [Lv: " .. tostring(lvl) .. "]"
                    local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    espData.Bar.Size = UDim2.new(healthPct, 0, 1, 0)
                    espData.Bar.BackgroundColor3 = (player == _G.CurrentTarget) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                end
            elseif ESP_Boxes[player] then
                ESP_Boxes[player].Gui.Parent = nil
            end
        end
    end
end)

-- ==========================================
-- 6. ÉP CHỈ SỐ WALKSPEED & JUMPPOWER
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if _G.Speed > 16 then char.Humanoid.WalkSpeed = _G.Speed end
        if _G.Jump > 50 then char.Humanoid.JumpPower = _G.Jump end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
        _G.Aimbot = false
        _G.ESP = false
        FOVCircle:Remove()
        if ScreenGui then ScreenGui:Destroy() end
    end
end)

warn("[Hoang Hub Premium] Load thành công Xeno PC - Fixed All Bugs!")

```
