local M={}
local function configmake(port,protocol,type,fqbn,path)

	local M={
		FQBN=fqbn,
		Port=port,
		Serial_Rate=11520,
		Protocol=protocol,
		Type=type,
		Core="",
	}

end
return M
