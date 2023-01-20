local instances = {}
local modules = {}
local currentlyLoading = {}

---Gets the globals table for a module. Stored globally to be accessed by
---a chunk loaded in `loadstring`.
---@param path string
---@return table
function _G.__getGlobals(path)
	return modules[instances[path]].globals
end

---Throws an error if the module may cause a circular dependency. Returns a
---cleanup function to run if the module is loaded successfully.
---@param module ModuleScript
---@param callerPath string
---@return nil | fun():void cleanup
local function validateRequire(module, callerPath)
	currentlyLoading[callerPath] = module

	local currentModule = module
	local depth = 0

	-- If the module is loaded, requiring it will not cause a circular dependency.
	if not modules[module] then
		while currentModule do
			depth = depth + 1
			currentModule = currentlyLoading[currentModule]

			if currentModule == module then
				local str = currentModule.Name -- Get the string traceback

				for _ = 1, depth do
					currentModule = currentlyLoading[currentModule]
					str = str .. "  ⇒ " .. currentModule.Name
				end

				error("Failed to load '" .. module.Name .. "'; Detected a circular dependency chain: " .. str, 2)
			end
		end
	end

	return function()
		if currentlyLoading[callerPath] == module then -- Thread-safe cleanup!
			currentlyLoading[callerPath] = nil
		end
	end
end

---Requires a module and returns the result.
---@param object ModuleScript
---@param callerPath string
---@return any
local function requireModule(object, callerPath)
	local module = modules[object]

	if module.loaded then
		return module.result
	else
		local cleanup = validateRequire(object, callerPath)
		module.result = module.callback()
		module.loaded = true
		cleanup()
		return module.result
	end
end

---Creates a new instance and adds it to the instances table. Called by
---the generated code.
---@param name string
---@param className string
---@param path string
---@param parentPath string
---@return Instance
function __instance(name, className, path, parentPath)
	local rbx = Instance.new(className)
	rbx.Name = name
	rbx.Parent = instances[parentPath]
	instances[path] = rbx
	return rbx
end

---Creates a new module and adds it to the modules table. Called by
---the generated code.
---@param name string
---@param className string
---@param path string
---@param parentPath string
function __lua(name, className, path, parentPath, callback)
	local rbx = __instance(name, className, path, parentPath)

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

---Starts the project.
function __start()
	for rbx, module in pairs(modules) do
		if rbx.ClassName == "LocalScript" and not rbx.Disabled then
			task.spawn(module.callback)
		end
	end
end
