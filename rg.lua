VERSION = "0.0.1"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")
local os = import("os")

local rg_view = nil

function rg(bp, args)
	local cmd = "rg -l "
	local pattern = ""
	
	for i = 1, #args do
		pattern = args[i] .. " "
	end

	cmd = cmd .. pattern
	
        local output, err = shell.RunCommand(cmd)
        
	if output ~= "" then
	    local buf, err = buffer.NewBuffer(output, "/")
	    if err == nil then
	    	micro.CurPane():VSplitIndex(buffer.NewBuffer("", "rg"), false)
	    	rg_view = micro.CurPane()
	    	rg_view:ResizePane(30)
	    	rg_view.Buf.Type.Scratch = true
	    	rg_view.Buf.Type.Readonly = true
	    	rg_view:VSplitBuf(buf)
	    end
	end
end

function init()
    config.MakeCommand("rg", function(bp, args)
    	rg(bp, args)
    end, config.NoComplete)
end
