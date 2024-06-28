local function FlavaGithubRequest(scripturl)
	if not isfile("Flava/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/itzC9/FlavaV4Roblox/"..readfile("Flava/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then return nil end
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("Flava/"..scripturl, res)
	end
	return readfile("Flava/"..scripturl)
end

shared.CustomSaveFlava = 292439477
if pcall(function() readfile("Flava/CustomModules/292439477.lua") end) then
	loadstring(readfile("Flava/CustomModules/292439477.lua"))()
else
	local publicrepo = FlavaGithubRequest("CustomModules/292439477.lua")
	if publicrepo then
		loadstring(publicrepo)()
	end
end