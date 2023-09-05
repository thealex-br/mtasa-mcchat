function RGBToHex(red, green, blue, alpha)
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end

local defaultColor = "#d9d9d9" -- white

local defaultColors = {"#E7D9B0", "#EBDDB2", "#ff9664", "#ebddb2", "#acd5fe"}
-- workaround to fix some hardcoded colors, works most of the time

local allowedChats = {
    [0] = true, -- normal message
    [1] = true, -- action message (/me)
    [2] = true, -- team message
}

local colorCodes = {
    ["0"] = "#000000", -- Black
    ["1"] = "#0000AA", -- Dark Blue
    ["2"] = "#00AA00", -- Dark Green
    ["3"] = "#00AAAA", -- Dark Aqua
    ["4"] = "#AA0000", -- Dark Red
    ["5"] = "#AA00AA", -- Dark Purple
    ["6"] = "#FFAA00", -- Gold
    ["7"] = "#AAAAAA", -- Gray
    ["8"] = "#555555", -- Dark Gray
    ["9"] = "#5555FF", -- Blue
    ["a"] = "#55FF55", -- Green
    ["b"] = "#55FFFF", -- Aqua
    ["c"] = "#FF5555", -- Red
    -- no support to '&k' ? :[
    ["d"] = "#FF55FF", -- Light Purple
    ["e"] = "#FFFF55", -- Yellow
    ["f"] = "#FFFFFF", -- White
    ["r"] = defaultColor,
}

local function parseColors(str, r, g, b)
    local defaultHex = RGBToHex(r, g, b)

    local defaultColors = defaultColors
    table.insert(defaultColors, defaultHex)
    for _, default in pairs(defaultColors) do
        str = string.gsub(str, default, colorCodes['r']) -- workaround, but works :)
    end

    if not string.find(str, "&") then
        return str
    end

    return string.gsub(str, "&([0-9a-fr])", function(code)
        local color = colorCodes[code]
        if color then
            return color
        else
            return ""
        end
    end)
end

local function message(rawText, r, g, b, theType)
    if not allowedChats[theType] then return end
    if not overflow then
        overflow = true
        if not wasEventCancelled() then
            local r, g, b = getColorFromString(defaultColor) -- possible minimize errors by forcing a new default color
            local newText = parseColors(rawText, r, g, b)
            cancelEvent()
            outputChatBox(newText, r, g, b, true)
        end
        overflow = false
    end
end
addEventHandler("onClientChatMessage", root, message)