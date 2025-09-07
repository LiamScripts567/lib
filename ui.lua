local lib = {}
setmetatable(lib, {
__index = function(_, key)
    return function()
        warn("Function '" .. key .. "' not found, continuing...")
    end
end
})
local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local plr = plrs.LocalPlayer
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local function drag(frame, capture)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new(0,0,0,0)
    
    local function update()
        if dragging then
            local mousePos = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
            local delta = mousePos - dragStart
            ts:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
            )}):Play()
        end
    end
    
    capture.MouseButton1Down:Connect(function()
        dragging = true
        dragStart = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
        startPos = frame.Position
    end)
    
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    rs.RenderStepped:Connect(update)
end
 
local ui = gethui and gethui() or plr.PlayerGui
 
local ins = Instance.new
 
local gui = ins("ScreenGui", ui)
 
local window = ins("Frame")
window.Size = UDim2.new(0, 500, 0, 300)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.new(0.5, 0, -1, -150)
local windowcorner = ins("UICorner", window)
windowcorner.CornerRadius = UDim.new(0, 16)
local windowcapture = ins("TextButton", window)
windowcapture.ZIndex = -999
windowcapture.Size = UDim2.new(0, 600, 0, 400)
windowcapture.AnchorPoint = Vector2.new(0.5, 0.5)
windowcapture.Position = UDim2.new(0.5, 0, 0.5, 0)
windowcapture.Name = "capture"
windowcapture.Text = ""
windowcapture.BackgroundTransparency = 1
local windowtopline = ins("Frame", window)
windowtopline.Size = UDim2.new(1, 0, 0, 2)
windowtopline.Position = UDim2.new(0, 0, 0, 40)
windowtopline.BackgroundColor3 = Color3.new(0, 0, 0)
windowtopline.BorderSizePixel = 0
local windowtitle = ins("TextLabel", window)
windowtitle.Position = UDim2.new(0, 20, 0, 20)
windowtitle.AnchorPoint = Vector2.new(0, 0.5)
windowtitle.BackgroundTransparency = 1
windowtitle.Name = "title"
windowtitle.Font = "BuilderSansBold"
windowtitle.TextSize = 16
windowtitle.TextXAlignment = "Left"

function lib:Window(title)
    local v = window:Clone()
    v.title.Text = type(title) == "string" and title or "Title"
    v.Parent = gui
    local tween = ts:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.5, 0)})
    tween:Play()
    coroutine.wrap(function()
        task.wait(0.6)
        drag(v, v.capture)
    end)()
    local win = {}
    setmetatable(win, {
    __index = function(_, key)
        return function()
            warn("Function '" .. key .. "' of window not found, continuing...")
        end
    end
    })
    function win:Destroy()
        v:Destroy()
    end
    function win:Tab(name)
        --nothing yet
    end
end
 
return lib
