--declare table 
local M={}

--call module 
local  testModule = require('arduineovim/testModule')

--declare function
function M.test()
	print('hello world');
end

--call function in Module 
function M.callModule(str)
	testModule.test(str)
end

local function splitString(inputString)
    local result = {}
		local i=0
		if #result~=1 then
			print("detected!")
		end
    for line in inputString:gmatch("[^\r\n]+") do
        table.insert(result, line)
				if line=="" then
					break
				end
				if i==0 then
					print("   "..line)
			  else
					print("["..i.."]"..line)
				end
				i=i+1
    end
    return result
end

function M.setup()
	vim.api.nvim_create_user_command("ArduinoRead",function ()
		print("Board checking...")
		local restr= vim.fn.system('arduino-cli board list')
		local result=splitString(restr)
	end,{})
end

--return table 
return M
