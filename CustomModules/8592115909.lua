local function FlavaGithubRequest(scripturl)
	if not isfile("Flava/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/itzc9/FlavaV4Roblox/"..readfile("Flava/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then return nil end
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("Flava/"..scripturl, res)
	end
	return readfile("Flava/"..scripturl)
end

shared.CustomSaveFlava = 8542275097
if isfile("Flava/CustomModules/8542275097.lua") then
	loadstring(readfile("Flava/CustomModules/8542275097.lua"))()
else
	local publicrepo = FlavaGithubRequest("CustomModules/8542275097.lua")
	if publicrepo then
		loadstring(publicrepo)()
	end
end