VERSION = "0.0.1"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")

function rg(bp, args)
	local cmd = "rg -l "
	local pattern = ""
	
	for i = 1, #args do
		pattern = args[i] .. " "
	end

	cmd = cmd .. pattern
	
    local output, err = shell.RunCommand(cmd)
    
    local strings = import("strings")
    local input = strings.Split(output, "\n")

	if #input < 2 then
		micro.InfoBar():Error("bad input format: ", input)
		return
	end

	-- micro.InfoBar():Message(input[1] .. " @ " .. input[2])
	for line = 1, #input do
		rgOpenLine(tostring(input[line]), bp, line)
	end
end


--function rgOpenLine(output, bp, line)
function rgOpenLine(output, bp, line)
    local strings = import("strings") 
    local strconv = import("strconv")
    file = strings.TrimSpace(output)

	if file ~= "" then
		--local buf, err = buffer.NewBufferFromFile(file)

		if err ~= nil then
			micro.InfoBar():Error(err)
		end

		local new_bp = bp:VSplitBuf(buf)

		--new_bp.Cursor.Y = tonumber(line)-1
		--new_bp.Cursor:Relocate()
	end
end

function init()
    config.MakeCommand("rg", function(bp, args)
    	rg(bp, args)
    end, config.NoComplete)
end
