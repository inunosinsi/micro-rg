VERSION = "0.0.1"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")

function rg(bp, args)
	local cmd = "sh -c 'rg -l "
	local pattern = ""
	
	for i = 1, #args do
		pattern = args[i] .. " "
	end

	cmd = cmd .. pattern .. "| fzf'"

	local output, err = shell.RunInteractiveShell(cmd, false, true)
    if err ~= nil then
    	micro.InfoBar():Error(err)
    else
        fzfOutput(output, {bp})
    end
end

function fzfOutput(output, args)
    local bp = args[1]
    local strings = import("strings")
    output = strings.TrimSpace(output)
    print(output)
    if output ~= "" then
        local buf, err = buffer.NewBufferFromFile(output)
        if err == nil then
            bp:OpenBuffer(buf)
        end
    end
end

function init()
    config.MakeCommand("rg", function(bp, args)
    	rg(bp, args)
    end, config.NoComplete)
end
