--Already Running--
if getgenv()["Already Running"] then return else getgenv()["Already Running"] = "" end
--Services--
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
--Variables--
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local flags = {Auto_Clicking = false, Mouse_Locked = false}
--Mouse-- 
local Mouse = setmetatable({}, {
    __index = function(table, index)
        return UserInputService:GetMouseLocation()[index]
    end
})
--Get Keybind--
local getKeycode = function(bind)
    return (pcall(function() return (Enum.KeyCode[bind]) end) and Enum.KeyCode[bind] or bind)
end
--Draw--
local Draw = function(obj, props)
    local NewObj = Drawing.new(obj)

    for i, v in next, props do
        NewObj[i] = v
    end

    return NewObj
end
--Create GUI--
local Text = Draw("Text", {
    Size = 18,
    Outline = true,
    OutlineColor = Color3.fromRGB(255, 255, 255),
    Color = Color3.fromRGB(0, 0, 0),
    Text = "Auto Clicking : FALSE\nMouse Locked : FALSE",
    Visible = true,
})
--Key Bind--
UserInputService.InputBegan:Connect(function(inputObj, GPE)
    if (not GPE) then
        if (inputObj.KeyCode == getKeycode(Settings["Auto Click Keybind"])) then
            flags.Auto_Clicking = not flags.Auto_Clicking
        end
        
        if (inputObj.KeyCode == getKeycode(Settings["Lock Mouse Position Keybind"])) then
            flags.Mouse_Locked_Position = Vector2.new(Mouse.X, Mouse.Y)
            flags.Mouse_Locked = not flags.Mouse_Locked
        end

        Text.Text = ("Auto Clicking : %s\nMouse Locked : %s"):format(tostring(flags.Auto_Clicking):upper(), tostring(flags.Mouse_Locked):upper())
    end
end)
--Auto Click--
coroutine.wrap(function()
    while (true) do
        Text.Visible = Settings.GUI
        Text.Position = Vector2.new(Camera.ViewportSize.X - 133, Camera.ViewportSize.Y - 48)

        if (flags.Auto_Clicking) then
            for i = 1, 2 do
                if (flags.Mouse_Locked) then
                    VirtualInputManager:SendMouseButtonEvent(flags.Mouse_Locked_Position.X, flags.Mouse_Locked_Position.Y, Settings["Right Click"] and 1 or 0, i == 1, nil, 0)
                else
                    VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, Settings["Right Click"] and 1 or 0, i == 1, nil, 0)
                end
            end
        end

        if (Settings.Delay <= 0) then
            task.wait() -- This equals to Heartbeat:Wait()
        else
            task.wait(Settings.Delay)
        end
    end
end)()
