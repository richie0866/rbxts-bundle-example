local TEMP_FILE = "dist/temp.lua"

---Minifies the given source text.
---@param source string
---@return string
local function minify(source)
	remodel.writeFile(TEMP_FILE, source)
	
	os.execute("darklua minify " .. TEMP_FILE .. " " .. TEMP_FILE .. " --column-span 1000000")

	return remodel.readFile(TEMP_FILE)
end

return minify
