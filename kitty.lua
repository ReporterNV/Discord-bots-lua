local token = require("token")
local discordia = require("discordia")
local timer = require('timer')
local math = require('math')
local client = discordia.Client {
	gatewayIntents = 3276799,
	cacheAllMembers = true,
	logFile = logFile,
}

RoleName = "котик-ученик"
RoleID = nil
KittyFilename = "Kitty.txt"
KittyFilenameHistory = "KittyHistory.txt"
KittyTable = {}
KittyHistory = {}

function getPrintedName(member)
	return member.nickname or member.username._global_name or member.username
end

function getRoleId(guild, roleName)
	local roles = guild.roles
	
	for _, role in pairs(roles) do
		if role.name == RoleName then
			print("Find role ".. RoleName .. " " .. role.id)
			RoleID = role.id
		end
	end

	return RoleID
end


client:on('ready', function()
	print('Bot is ready!')
end)

function disp_time(time)
  local days = math.floor(time/86400)
  local hours = math.floor(math.fmod(time, 86400)/3600)
  local minutes = math.floor(math.fmod(time, 3600)/60)
  local seconds = math.floor(math.fmod(time, 60))
  return string.format("DAY:%d; HOURS:%02d; MIN:%02d; SEC:%02d", days, hours, minutes, seconds)
end

function KittyPrint(KittyTable)
	for id, date in pairs(KittyTable) do
		print("ID:"..id.." | ".. disp_time(os.time()-date))
	end
end

function KittyImport(KittyTable)
	local f = io.open(KittyFilename, "r")
	if f ~= nil then
	
		for line in io.lines(KittyFilename) do
			local args  = line:split("|")
			KittyTable.args[1] = args[2]
		end
		
		f:close()
	end

end

function KittyExport(KittyTable)
	local f = io.open(KittyFilename, "w")
	for id, date in pairs(KittyTable) do
		f:write(id .. " | " .. date)
	end
	f:close()
end

function KittyHistoryAdd(KittyHistory, id, start, finish)
	local f = io.open(KittyFilenameHistory, "a")
		f:write(id .. " | " .. start .. " | " .. finish)
	f:close()
end


function KittyHistoryImport(KittyHistoryTable)
	local f = io.open(KittyFilenameHistory, "a")
	for id, date in pairs(KittyTable) do
		file:write(id .. " | " .. date)
	end
	f:close()
end



function KittyHistoryPrint(KittyHistoryTable)
	for id, dates in pairs(KittyHistoryTable) do
		print("ID:"..id.." | ".. dates.start .. " | " .. dates.finish)
	end
end


client:on("memberUpdate", function(member)
	local guild = member.guild
	local id = member.id
	print("Catch event for " .. id)
	getRoleId(guild, RoleName)
	if KittyTable[id] == nil then
		if member:hasRole(RoleID) then
			print("Add role: " .. id)
			KittyTable[id] = os.time()
			KittyExport(KittyTable)
		end
	else
		if not(member:hasRole(RoleID)) then
			print("Remove role: " .. id)
			KittyHistory[id] = {}
			KittyHistory[id].start = KittyTable[id]
			KittyHistory[id].finish = os.time()
			KittyTable[id] = nil
			KittyExport(KittyTable)
			KittyHistoryAdd(KittyHistory, id, KittyHistory[id].start, KittyHistory[id].finish)
		end

	end

	KittyPrint(KittyTable)--change to export
	KittyHistoryPrint(KittyHistory)

end)


client:on("messageCreate", function(message)
	if message.author.bot then return end
		
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end

	local mention
	local output = ""
	
	if message.content == "!kitty" then
	
		for id, date in pairs(KittyTable) do
			mention = client:getUser(id).mentionString
			print("ID:".. id .." | ".. disp_time(os.time()-date))

			output = output.."Котенок: ".. mention ..
				" ученик уже: " .. disp_time(os.time()-date) .. "\n"

			
		end

		if output == "" then
			print("Output is nil")
			message:reply("У нас только опытные коты!");
		else
			print(output); --add split msg
			message:reply(output);
		end
	end
end)


client:on("messageCreate", function(message)
	if message.author.bot then return end
		
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end

	local output = ""
	local mention

	if message.content == "!kittyhistory" then
		for id, dates in pairs(KittyHistory) do
			mention = client:getUser(id).mentionString
			print("\n\n"..KittyHistory[id].start.."\n\n")
			output = output.."Участник: " .. mention ..
				" был котенком-учеником с: "..
				os.date("%x %X", KittyHistory[id].start) ..
				" по ".. os.date("%x %X", KittyHistory[id].finish)..
				"\n"
		end

		if output == "" then
			print("Output is nil")
			message:reply("История пуста.");
		else
			print(output);
			message:reply(output);
		end

	end
end)


client:run("Bot " .. token)
