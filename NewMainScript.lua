if getgenv and not getgenv().shared then getgenv().shared = {} end
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end

local function displayErrorPopup(text, func)
	local oldidentity = getidentity()
	setidentity(8)
	local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
	local prompt = ErrorPrompt.new("Default")
	prompt._hideErrorCode = true
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	prompt:setErrorTitle("flava")
	prompt:updateButtons({{
		Text = "OK",
		Callback = function() 
			prompt:_close() 
			if func then func() end
		end,
		Primary = true
	}}, 'Default')
	prompt:setParent(gui)
	prompt:_open(text)
	setidentity(oldidentity)
end

local function flavaGithubRequest(scripturl)
	if not isfile("flava"..scripturl) then
		local suc, res
		task.delay(15, function()
			if not res and not errorPopupShown then 
				errorPopupShown = true
				displayErrorPopup("The connection to github is taking a while, Please be patient.")
			end
		end)
		suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/itzC9/FlavaV4Roblox/"..readfile("flavacommithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then
			if identifyexecutor and ({identifyexecutor()})[1] == 'Wave' then 
				displayErrorPopup('Stop using detected garbage, flava will not work on such garabge until they fix BOTH HttpGet & file functions.')
				error(res)
			end
			displayErrorPopup("Failed to connect to github : flava"..scripturl.." : "..res)
			error(res)
		end
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("flava"..scripturl, res)
	end
	return readfile("flava"..scripturl)
end

if not shared.flavaDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet("https://github.com/itzC9/FlavaV4Roblox"):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder("flava") then 
			if ((not isfile("flavacommithash.txt")) or (readfile("flavacommithash.txt") ~= commit or commit == "main")) then
				for i,v in pairs({"flavaUniversal.lua", "flavaMainScript.lua", "flavaGuiLibrary.lua"}) do 
					if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
						delfile(v)
					end 
				end
				if isfolder("flavaCustomModules") then 
					for i,v in pairs(listfiles("flavaCustomModules")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				if isfolder("flavaLibraries") then 
					for i,v in pairs(listfiles("flavaLibraries")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				writefile("flavacommithash.txt", commit)
			end
		else
			makefolder("flava")
			writefile("flavacommithash.txt", commit)
		end
	else
		displayErrorPopup("Failed to connect to github, please try using a VPN.")
		error("Failed to connect to github, please try using a VPN.")
	end
end

return loadstring(flavaGithubRequest("MainScript.lua"))()