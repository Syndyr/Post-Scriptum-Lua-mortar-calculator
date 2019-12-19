require "libs.math"
require "libs.vector"
function getX(num)
	local ans = num%3
	if ans == 0 then ans = 3 end
	return ans-1
end

function getY(num)
	return (2-((num-1)-((num-1)%3))/3)
end
function convertGridString(gridref)
	--print(gridref)
	local gridMachineUsable = {}
	for i in string.gmatch(gridref, "[^-]+") do
		table.insert(gridMachineUsable, i)
	end

	local truePosition = Vector(0,0)

	local v = gridMachineUsable[1]:sub(-3)
	local gridLetter = v:lower():byte(1)-97 --X axis
	--print(gridLetter)
	local gridNumber = tonumber(v:sub(-2))-1 --Y axis
	--print(gridNumber)
	truePosition = truePosition + Vector(gridLetter*300, gridNumber*300)
	--print(truePosition:toString())

	v = gridMachineUsable[2]
	local num = tonumber(v)
	local gX = getX(num)*100 --X axis
	local gY = getY(num)*100 --Y Axis
	truePosition = truePosition + Vector(gX, gY)
	--print(truePosition:toString())

	v = gridMachineUsable[3]
	local num = tonumber(v)
	local gX = getX(num)*33 + 16.6665 --X axis
	local gY = getY(num) *33 + 16.6665 --Y Axis
	truePosition = truePosition + Vector(gX, gY)
	
	return truePosition
end
--print(truePosition:toString())
--[[

	[CNN-N-N] STRING
	
	Break to {CNN, N, N}
	Convert to {vec, vec, vec}
	Bring down to just [vec]
	
	
]]--