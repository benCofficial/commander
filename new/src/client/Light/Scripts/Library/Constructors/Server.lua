local module, Elements, Latte, Page = {}, nil, nil, nil
local Packages = {}

module.prepare = function()
	local Padding = Latte.Components.Padding.new(Page)
	Padding.Top = UDim.new(0, 24)
	Padding.Bottom = UDim.new(0, 24)
end

module.update = function()
	for i,v in pairs(Packages) do
		if v.Location:lower() == "server" then
			local Comp = Latte.Components.PackageButton.new(v.Name, v.Description, Page)
			Comp.Events.Clicked.Event:Connect(function()
				module.Remotes.RemoteFunction:InvokeServer("command", v.Protocol)
			end)
		end
	end
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	Page = Latte.Components.Page.new("Server", Elements.Panel.Container.Body)
	Page.UIListLayout.Padding = UDim.new(0, 0)
	Latte.Constructors.Menu.newButton("Server", 3)
	module.prepare()
	
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "fetchCommands" then
			Packages = Attachment
			module.update()
		end
	end)
end

return module