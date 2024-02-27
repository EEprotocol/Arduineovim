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

--not only split by the \n but also show message 
local function splitString(inputString)
    local result = {}
		local i=0
		vim.api.nvim_command("redraw")
    for line in inputString:gmatch("[^\r\n]+") do
        table.insert(result, line)
				if line=="" then
					break
				end
				if i==0 then
					print("    "..line)
			  else
					print("["..i.."] "..line)
				end
				i=i+1
    end
		i=i-1
		if #result~=1 then
			print("Detected!")
			print("Choose board from [1] to ["..i.."]")
		end
    return result,i
end

local function spaceSplit(inputString)
	local result={}
	for token in string.gmatch(inputString,"%S+") do
		table.insert(result,token)
	end
	return result
end

-- パスの一番下以外の部分を取り出す関数
local function getFolderPath(path)
    local components = {}
    for component in path:gmatch("[^/\\]+") do
        table.insert(components, component)
    end
    table.remove(components)  -- 最後の要素を削除
    return table.concat(components, "/")  -- パスの区切り文字で結合して返す
end

--return list where words begin
local function wordstart(str)
	local indices={}
	local prevChar=" "
	local index=1
	for char in str:gmatch(".")do
		if char ~= " "and prevChar == " " then
			table.insert(indices,index)
		end
		index=index+1
		prevChar=char
	end
	return indices

end

--return list matching
local function findMatchingWord(str1,str2)
	local indices1 = wordstart(str1)
	local indices2 = wordstart(str2)
	local matching={}
	for _,index1 in ipairs(indices1) do
		for _,index2 in ipairs(indices2) do
			if index1==index2 then
				table.insert(matching,index1)
				break
			end
		end
	end
	return matching
end

-- return string and make the parameters
local fqbn, tipe, protocol, port, serial

local function parametasign(str1, str2)
	local indices=findMatchingWord(str1,str2)
	local index=1
	local paras={}
	while index <#indices+1 do
		if index ~= #indices then
			table.insert(paras,string.sub(str2,indices[index],indices[index+1]-1))
		else
			table.insert(paras,string.sub(str2,indices[index],#str2))
		end
		index=index+1
	end
	port=paras[1]:gsub("%s+$", "")
	protocol=paras[2]:gsub("%s+$", "")
	tipe=paras[3]:gsub("%s+$", "")
	fqbn=paras[4]:gsub("%s+$", "")

	return paras
end

local function wordSearcher(str,key)
	local i = 0
	for char in str:gmatch(".")do
		if char == key then
			i=1
			break
		end
	end
	return i
end
function M.setup()
	vim.api.nvim_create_user_command("ArduinoRead",function ()
		print("Checking Board...")
		local restr= vim.fn.system('arduino-cli board list')
		local result,i=splitString(restr)
		if #result~=1 then
			local s =vim.fn.input(">>>")
			s=s+0
			if s>i then
				vim.api.nvim_command("redraw")
			else
				vim.api.nvim_command("redraw")
				local paras = parametasign(result[1],result[s+1])
				print("Port:"..port..", FQBN:"..fqbn..", Protocol:"..protocol..", Type:"..tipe)
				local varset=spaceSplit(result[s+1])
				local path=getFolderPath(vim.api.nvim_buf_get_name(0))
				if wordSearcher(fqbn,":")==0 then
					print("It does not seems to be FQBN name. You have to set it MANUALLY!")
					print("Other parameters are resitered.")
				else
				print("Parameters are set!")
				end
			end
		end
	end,{})
	vim.api.nvim_create_user_command("ArduinoProp",function()
		if port~=nil then
			print("Port:"..port..", FQBN:"..fqbn..", Protocol:"..protocol..", Type:"..tipe)
		else
			print("Having set NOTHING!")
		end
	end,
	{})
end


--return table 
return M
