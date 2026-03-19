--// KP SPAMMER V3 (REAL CHAT SENDER)
--// Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

---------------------------------------------------
--// CHAT SEND FUNCTION (REAL)
---------------------------------------------------
local function sendChat(msg)
	
	-- NEW CHAT SYSTEM
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		
		local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if channel then
			channel:SendAsync(msg)
		end
		
	else
		-- OLD CHAT SYSTEM
		local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if chatEvent then
			chatEvent.SayMessageRequest:FireServer(msg, "All")
		end
	end
end

---------------------------------------------------
--// UI
---------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "KP HUB"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.BackgroundTransparency = 1

---------------------------------------------------
--// INPUTS
---------------------------------------------------
local customBox = Instance.new("TextBox", frame)
customBox.PlaceholderText = "Custom Message"
customBox.Size = UDim2.new(0.9,0,0,30)
customBox.Position = UDim2.new(0.05,0,0.2,0)

local targetBox = Instance.new("TextBox", frame)
targetBox.PlaceholderText = "Target Name"
targetBox.Size = UDim2.new(0.9,0,0,30)
targetBox.Position = UDim2.new(0.05,0,0.35,0)

local timeBox = Instance.new("TextBox", frame)
timeBox.PlaceholderText = "Interval (sec)"
timeBox.Size = UDim2.new(0.9,0,0,30)
timeBox.Position = UDim2.new(0.05,0,0.5,0)

---------------------------------------------------
--// BUTTONS
---------------------------------------------------
local function makeBtn(txt, x)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.25,0,0,35)
	b.Position = UDim2.new(x,0,0.7,0)
	b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(0,120,255)
	return b
end

local sendBtn = makeBtn("Send",0.05)
local startBtn = makeBtn("Start",0.37)
local stopBtn = makeBtn("Stop",0.69)

---------------------------------------------------
--// DRAG (FIXED)
---------------------------------------------------
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

---------------------------------------------------
--// LOOP SYSTEM
---------------------------------------------------

local running = false

local dashedLine = "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

local preset = {
    "TMKX MEIN ACID",
    "TMKX MEIN BEAST",
    "TMKX MEIN GAJJAR",
    "TMKX MEIN LION",
    "CUD GAYA HAI",
    "leave mar de"
}

local function formatMessage(message)
    local target = targetBox.Text
    if target == "" then
        return dashedLine .. " " .. message
    end
    return dashedLine .. " " .. target .. " " .. message
end

-- Example loop
local function startLoop(interval)
    if running then return end
    running = true
    task.spawn(function()
        while running do
            for _, msg in ipairs(preset) do
                if not running then break end
                sendChat(formatMessage(msg))
                task.wait(interval or 3)
            end
        end
    end)
end

local function stopLoop()
    running = false
end
---------------------------------------------------
--// BUTTON LOGIC
---------------------------------------------------
sendBtn.MouseButton1Click:Connect(function()
	local msg = customBox.Text ~= "" and customBox.Text or "Hello"
	sendChat(formatMessage(msg))
end)

startBtn.MouseButton1Click:Connect(function()
	if running then return end
	running = true
	
	local t = tonumber(timeBox.Text) or 3
	if t < 2 then t = 2 end
	
	task.spawn(function()
		while running do
			
			-- send custom first
			if customBox.Text ~= "" then
				sendChat(formatMessage(customBox.Text))
				task.wait(t)
			end
			
			-- send preset loop
			for _,m in ipairs(preset) do
				if not running then break end
				sendChat(formatMessage(m))
				task.wait(t)
			end
		end
		
	end)
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
end)