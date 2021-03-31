local module, Latte, Elements = {}, nil, nil
local Buttons = {}
local isActive = false

module.Toggle = function()
	if isActive then
		Latte.Modules.Animator.Menu.animateOut(Elements.Panel.Container.Menu)
	else
		Latte.Modules.Animator.Menu.animateIn(Elements.Panel.Container.Menu)
	end
	
	isActive = not isActive
end

module.setActive = function(Name: string)
	if Buttons[Name] then
		for i,v in pairs(Buttons) do
			if i ~= Name then
				v.Toggle(false)
			else
				v.Toggle(true)
			end
		end
	end
end

module.newButton = function(Name: string, Position: number)
	if not Buttons[Name] then
		Buttons[Name] = {}
		
		local Comp = Latte.Components.MenuButton.new(Name, Name, Elements.Panel.Container.Menu.Container.List, function()
			module.Toggle()
			Latte.Constructors.Window.SwitchPage(Name)
			for i,v in pairs(Buttons) do
				if i ~= Name then
					v.Toggle(false)
				end
			end
		end)
		
		Buttons[Name].Toggle = Comp.setActive
		Comp.Object.LayoutOrder = Position
		Comp = nil
	end
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	local Exit = Latte.Components.RoundButton.new("Exit", "rbxassetid://6521420400", Elements.Panel.Container.Menu.Container.Top.Left, module.Toggle)
	Exit.Image.ImageColor3 = Latte.Modules.Stylesheet.Menu.ExitColor
	Exit.Image.Size = UDim2.new(0.3, 0, 0.3, 0)
	Elements.Panel.Container.Menu.Container.Top.Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
	Elements.Panel.Container.Menu.Container.BackgroundColor3 = Latte.Modules.Stylesheet.Menu.BackgroundColor
end

return module