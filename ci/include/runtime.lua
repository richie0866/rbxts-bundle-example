local instances = {}
local modules = {}
local currentlyLoading = {}

local function runModule(object, context)
	currentlyLoading[context] = object

	local currentModule = object
	local depth = 0

	while currentModule do
		depth = depth + 1
		currentModule = currentlyLoading[currentModule]

		if currentModule == object then
			local str = currentModule.Name -- Get the string traceback

			for _ = 1, depth do
				currentModule = currentlyLoading[currentModule]
				str = str .. "  ⇒ " .. currentModule.Name
			end

			error("Failed to load '" .. object.Name .. "'; Detected a circular dependency chain: " .. str, 2)
		end
	end

	local module = modules[object]
	local data = module.callback()

	if currentlyLoading[context] == object then -- Thread-safe cleanup!
		currentlyLoading[context] = nil
	end

	return data
end

local function requireModule(object, context)
	local module = modules[object]

	if module.loaded then
		return module.result
	else
		module.result = runModule(object, context)
		module.loaded = true
		return module.result
	end
end

local function __rbx(name, className, path, parentPath)
	local rbx = Instance.new(className)
	rbx.Name = name
	rbx.Parent = instances[parentPath]
	instances[path] = rbx
	return rbx
end

local function __lua(name, className, path, parentPath, callback)
	local rbx = __rbx(name, className, path, parentPath)

	modules[rbx] = {
		callback = callback,
		result = nil,
		loaded = false,
		globals = {
			script = rbx,
			require = function(object)
				if modules[object] then
					return requireModule(object, path)
				else
					return require(object)
				end
			end,
		},
	}
end

local function __env(path)
	return modules[instances[path]].globals
end

local function __start()
	for rbx, module in pairs(modules) do
		if rbx.ClassName == "LocalScript" and not rbx.Disabled then
			task.spawn(module.callback)
		end
	end
end
