getgenv().Settings = {
	["ReachSettings"] = {
		["ReachEnabled"] = false,
		["ReachLungeOnly"] = false,
		["ReachRadius"] = 2,
		["Damage Amplifier"] = 1,
	},
	["VisualsSettings"] = {
		["VisualizerEnabled"] = false,
		["VisualizerType"] = "3D_Circle",
		["VisualizerColor"] = Color3.fromRGB(0,0,0)
	},
	["Misc"] = {
		["Spin"] = false,
		["SpoofedText"] = "SEB #1"
	}
}
getfenv().LPH_NO_VIRTUALIZE = function(f) return f end;

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local Titla = "Sebs Darkside V3"

local Settings = getgenv().Settings
local ReachSettings = Settings.ReachSettings
local VisualsSettings = Settings.VisualsSettings
local MiscSettings = Settings.Misc

local UI = Material.Load({
	Title = Titla,
	Style = 0,
	SizeX = 400,
	SizeY = 200,
	Theme = "Dark",
})

local ReachPage = UI.New({
    Title = "Reach"
})

local VisualsPage = UI.New({
	Title = "Visuals"
})

local MiscPage = UI.New({
	Title = "Misc"
})

-- Reach Page typa shit --

local Note = ReachPage.Label({
	Text = "#1 SECURITY, #1 SCRIPT, NO COMPETITION; SEBS DARKSIDE V3"
})

local ReachEnabled = ReachPage.Toggle({
	Text = "Reach Enabled",
	Callback = function(value)
		ReachSettings.ReachEnabled = value
	end,
})

local ReachLungeOnly = ReachPage.Toggle({
	Text = "Lunge Only",
	Callback = function(value)
		ReachSettings.ReachLungeOnly = value
	end,
})

local ReachRadius = ReachPage.Slider({
	Text = "Reach Radius",
	Callback = function(value)
		ReachSettings.ReachRadius = value
	end,
	Min = 1,
	Max = 25,
	Def = 2
})

local DamageAmplifier = ReachPage.Slider({
	Text = "Damage Amplifier",
	Callback = function(value)
		ReachSettings["Damage Amplifier"] = value
	end,
	Min = 1,
	Max = 25,
	Def = 1
})

-- visualizer typa shit --

local Note = VisualsPage.Label({
	Text = "Mainly a visualizer section"
})

local VisualizerVisible = VisualsPage.Toggle({
	Text = "Visualizer Enabled",
	Callback = function(Value)
		VisualsSettings.VisualizerEnabled = Value
	end
})

local VisualizerOptions = VisualsPage.Dropdown({
	Text = "3D Visualizers",
	Callback = function(Value)
		VisualsSettings.VisualizerType = Value
	end,
	Options = {"3D_Circle", "3D_Square"}
})

local VisualizerColor = VisualsPage.ColorPicker({
	Text = "Visualizer Color",
	Callback = function(Value)
		VisualsSettings.VisualizerColor = Color3.fromRGB(Value.R, Value.G, Value.B)
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "This changes the color of your Visualizer."
			})
		end
	}
})
-- MISC --

local a = MiscPage.Toggle({
	Text = "Spin",
	Callback = function(Value)
		MiscSettings.Spin = Value
	end,
})


-- main code --

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = PlayerService.LocalPlayer or PlayerService.PlayerAdded:Wait()
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()


local GetHandles = function(Character)
    local Handles = {}

	if not Character and not Character["Right Arm"] then return end

    if Character and Character["Right Arm"] then
        local TableOfParts = workspace:GetPartBoundsInBox(Character["Right Arm"].CFrame * CFrame.new(1,1,0), Vector3.new(4,4,4))

        for _, Handle in pairs(TableOfParts) do
            if Handle:FindFirstChildOfClass("TouchTransmitter") and
            Handle:IsDescendantOf(Character) then
                table.insert(Handles, Handle)
            end
        end
    end

    if #Handles <= 0 then
        for _,x in pairs(LocalPlayer.Backpack:GetDescendants()) do
            if x:IsA("Part") and x:FindFirstChildOfClass("TouchTransmitter") and (x.Parent:IsA("Tool") or x.Parent.Parent:IsA("Tool")) then
                table.insert(Handles, x)
            end
        end
    end

    return Handles
end


local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua'), true))()

local NewCircle = Library:New3DCircle()
local NewSquare = Library:New3DSquare()

NewCircle.Transparency = 0.9
NewCircle.Color = Color3.new(0, 0, 0)
NewCircle.Thickness = 1
NewCircle.ZIndex = 0
NewCircle.Visible = false

NewSquare.Transparency = 0.9
NewSquare.Color = Color3.new(0,0,0)
NewSquare.Filled = false
NewSquare.Thickness = 1
NewSquare.Visible = false
NewSquare.ZIndex = 0



local SpoofFunction = function(RBXSignal, NewFunction)
	for _, Connection in next, getconnections(RBXSignal) do
		local oldFunc = Connection.Function
		Connection.Function:Connect(NewFunction)
		return oldFunc
	end
end

local OldHandle = GetHandles(LocalCharacter)[1]

--SpoofFunction(OldHandle.Touched)

-- Main Code: --

--[[UIS.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.Insert then
		for _,v in pairs(game:GetDescendants()) do
			if v.Name == Titla then
				v.Enabled = not v.Enabled
			end
		end
	end
end)]]

local Whitelisted = {
	"Head",
	"Torso",
	"HumanoidRootPart",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

local IsWhitelisted = function(object)
	if object:IsA("Part") and table.find(Whitelisted, object.name) then
		return true
	end
	return false
end

local IsLunging = function(Handle)
	if (Handle.Parent.Parent.GripUp == Vector3.new(1,0,0)) or (Handle.Parent.GripUp == Vector3.new(1,0,0)) then
		return true
	end
	return false
end

local InstanceSpin = function(HumPart)
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = HumPart
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,50,0)
end


local Loop = LPH_NO_VIRTUALIZE(function()
	local Success, Response = pcall(function()
		local NewCharacter = LocalPlayer.Character or LocalCharacter.CharacterAdded:Wait()
		local HumPart = NewCharacter.HumanoidRootPart
		local NewHandle = GetHandles(NewCharacter)[1]
		NewCircle.Radius = ReachSettings.ReachRadius

		NewCircle.Color = VisualsSettings.VisualizerColor
		NewSquare.Color = VisualsSettings.VisualizerColor

		if VisualsSettings.VisualizerEnabled then
			if VisualsSettings.VisualizerType == "3D_Circle" then
				NewCircle.Position = NewHandle.Position
				NewCircle.Visible = true
			else
				NewCircle.Visible = false
			end

			if VisualsSettings.VisualizerType == "3D_Square" then
				NewSquare.Visible = true
				NewSquare.Position = NewHandle.Position
				NewSquare.Size = Vector2.new(ReachSettings.ReachRadius, ReachSettings.ReachRadius)
			else
				NewSquare.Visible = false
			end

			if NewHandle:IsDescendantOf(LocalPlayer.Backpack) then
				NewCircle.Visible = false
			end
		else
			NewCircle.Visible = false
		end

		if MiscSettings.Spin then

			if not HumPart:FindFirstChildOfClass("BodyAngularVelocity") then
				InstanceSpin(HumPart)
			end
		else
			if HumPart:FindFirstChildOfClass("BodyAngularVelocity") then HumPart:FindFirstChildOfClass("BodyAngularVelocity"):Destroy() end
		end

		for _, Player in pairs(PlayerService:GetPlayers()) do
			if Player ~= LocalPlayer then
				if Player.Character then
					for _, Limb in pairs(Player.Character:GetChildren()) do
						if Player.Character.Humanoid and Player.Character.Humanoid.Health ~= 0 then
							local Magnitude = (NewHandle.Position - Player.Character.HumanoidRootPart.Position).Magnitude
							if Magnitude <= ReachSettings.ReachRadius then
								local object = Limb-- transfered from otha function for optimization
								local touchwith = NewHandle -- transfered from otha function for optimization
								if IsWhitelisted(object) then
									if ReachSettings.ReachEnabled then
										if ReachSettings.ReachLungeOnly then
											if IsLunging(object) then
												local OldFunction = SpoofFunction(touchwith.Touched, newcclosure(function()end))
												-- print(object, touchwith)
												for i = 1, ReachSettings["Damage Amplifier"] do
													firetouchinterest(object, touchwith, 0)
													firetouchinterest(object, touchwith, 1)
													firetouchinterest(object, touchwith, 0)
													firetouchinterest(object, touchwith, 1)
												end
												local ResetFunction = SpoofFunction(touchwith.Touched, OldFunction)
											end
										else
											local OldFunction = SpoofFunction(touchwith.Touched, newcclosure(function()end))
											-- print(object, touchwith)
											for i = 1, ReachSettings["Damage Amplifier"] do
												firetouchinterest(object, touchwith, 0)
												firetouchinterest(object, touchwith, 1)
												firetouchinterest(object, touchwith, 0)
												firetouchinterest(object, touchwith, 1)
											end
											local ResetFunction = SpoofFunction(touchwith.Touched, OldFunction)
										end
									end
								end
								-- continue
							end
						end
					end
				end
			end
		end

		if NewHandle ~= OldHandle then
			-- SpoofFunction(NewHandle.Touched)
		end
	end)

	if not Success then
		warn(Response)
	end
end)

RunService.RenderStepped:Connect(Loop)
