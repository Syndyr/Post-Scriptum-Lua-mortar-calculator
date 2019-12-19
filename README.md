# Post-Scriptum Lua mortar calculator
 Command line Lua mortar calculator, requires some DIY.
 
 First off: This should be compatible with most versions of Lua, verified on any 5.x (With or without LuaJIT) version.
 To use this just drag it onto your Lua.exe or launch it via command line. I am not supplying the exe, you will have to obtain that yourself. 
 
 
 
When you first load the program you'll be asked to select the mortar you're using. This expects a number entry.
Next you will set up your position, this expects the Post-Scriptum grid reference format, please note it expects three characters for the first entry so G1-2-3 should be formatted as G01-2-3.

Next the program will prompt for your target location, it expects the same format as your location.

Once a target location is provided, the program will calculate the mil reading and the bearing required to get your shots on target, unless the target co-ordinates is out of range or too close.

## Yo, did you know?
You can actually add extra mortars by copying the format within the existing files in ~/data/ and renaming the file.