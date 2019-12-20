require "libs.gridconvert" --This contains my grid converter library

local mils = {} --This contains the data-points used to interperlate the mil readins
local handle = io.popen([[dir /b /a-d data]])
local result = handle:read("*a")
handle:close()

for s in result:gmatch("[^\r\n]+") do
    table.insert(mils, require("data\\"..s:gsub(".lua","")))
end

function mils.interp(l, u, t)
	
	if l == u then return l[2] end
	local interDistDelta = l[1] - u[1]
	local interdistMilDelta = u[2] - l[2]
	local milPerMeter = interdistMilDelta/interDistDelta
	local distAboveMin = t - l[1]
	local millmod = distAboveMin * milPerMeter
	local answer = l[2] - millmod
	return math.floor(answer+0.5)

end

function findRangeBracket(morta, dist)

	for k,v in pairs(morta) do
		if dist == v[1] then 
			return k, k 
		end
		if v[1] < dist and morta[math.min(k+1, #morta)][1] > dist and type(k) ~= "string" then
		
			return k, math.min(k+1, 20), v[1], morta[math.min(k+1, 20)][1]
		
		end
		
	end
	
end

os.execute("cls")

print("High precision mode? [Y/N]")
local a = io.input():read(2)
local highPrec = a:find("y") ~= nil
local precMod = 0
if highPrec then precMod = 2 end
again = true
print("Sellect which mortar:\n")
local mortarOptions = {}
local i = 1

for k,v in pairs(mils) do
	if type(k) == "number" then
		print(i..") ", v.niceName, v.minMax[1].."m to "..v.minMax[2].."m")
		mortarOptions[i] = k
		i = i + 1
	end
end
local mortar = io.read("*n")


print("What is your mortar position? I.e: "..string.char(math.random(65, 90))..""..math.random(0,1)..""..math.random(1,9).."-"..math.random(1,9).."-"..math.random(1,9))

local mortarPos = io.input():read(8+precMod)
mortarPosa = convertGridString(mortarPos, highPrec)
print("What is your target position? I.e: "..string.char(math.random(65, 90))..""..math.random(0,1)..""..math.random(1,9).."-"..math.random(1,9).."-"..math.random(1,9))

local clk = false
local bearing = 0
local dist = 0

mortarTargetPos = io.input():read(8+precMod)
mortarTargetPosa = convertGridString(mortarTargetPos, highPrec)
bearing, dist = 360-math.max(math.min(math.deg(mortarPosa:bearing2D(mortarTargetPosa))+180, 360), 0), mortarPosa:dist(mortarTargetPosa)
while again do
	os.execute("cls")
	
	print("You are shooting with a:", mils[mortarOptions[mortar]].niceName)
	
	if clk then 
		print("What is your target position? I.e: "..string.char(math.random(65, 90))..""..math.random(0,1)..""..math.random(1,9).."-"..math.random(1,9).."-"..math.random(1,9))
		mortarTargetPos = io.input():read(8+precMod)
		mortarTargetPosa = convertGridString(mortarTargetPos, highPrec)
		bearing, dist = 360-math.max(math.min(math.deg(mortarPosa:bearing2D(mortarTargetPosa))+180, 360), 0), mortarPosa:dist(mortarTargetPosa)
	end
	
	clk = true
	again = false
	
	if dist >= mils[mortarOptions[mortar]].minMax[1] and dist <= mils[mortarOptions[mortar]].minMax[2] then
		local lowerL, upperL = findRangeBracket(mils[mortarOptions[mortar]], dist)
		print("\n\nRange table for ", mils[mortarOptions[mortar]].niceName, "\n\n")
		print("#", "Meters", "Mils")
		for k,v in pairs(mils[mortarOptions[mortar]]) do
			if type(k) == "number" then
				print(k, v[1], v[2])
			end
			
		end
		print("_________________________________________________________________________")
		print("Shoting from:", mortarPos:sub(2,-1), "\nShooting at:", mortarTargetPos:sub(2,-1))
		print("\nSet mils to:", mils.interp(mils[mortarOptions[mortar]][lowerL], mils[mortarOptions[mortar]][upperL], dist), ", for distance of: ", math.round(dist, 2))
		print("Set bearing to:", math.round(bearing, 2))
		print("Always check that the range card is correct before fire missions!")
		print("_________________________________________________________________________")
	else
		print("That range is outside of this mortars range!")
	end
	
	print("Try another measurement? [Y/N]")
	local a = io.input():read(2)
	
	if a:find("y") then
		again = true
	end
	os.execute("cls")
end