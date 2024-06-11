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
KittyHistoryFilename = "KittyHistory.txt"
KittyTable = {}
KittyHistoryTable = {}

local function getPrintedName(member)
	return member.nickname or member.username._global_name or member.username
end

local function getRoleId(guild, RoleName)
	local roles = guild.roles
	for _, role in pairs(roles) do
		if role.name == RoleName then
			RoleID = role.id
		end
	end
	if RoleID == nil then
		print("Role not found: " .. RoleName)
	end

	return RoleID
end

local function disp_time(time)
  local days = math.floor(time/86400)
  local hours = math.floor(math.fmod(time, 86400)/3600)
  local minutes = math.floor(math.fmod(time, 3600)/60)
  local seconds = math.floor(math.fmod(time, 60))
  return string.format("DAY:%d; HOURS:%02d; MIN:%02d; SEC:%02d", days, hours, minutes, seconds)
end

local function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

local function KittyPrint(KittyTable)
	for id, date in pairs(KittyTable) do
		print("ID:"..id.." | ".. disp_time(os.time()-date))
	end
end

local function KittyImport(KittyTable)
	local f = io.open(KittyFilename, "r")
	if f ~= nil then
		for line in io.lines(KittyFilename) do
			print("line: "..line)
			local args = {}
			args = split(line, " | ")
			local id = args[1]
			local time = args[2]
			KittyTable[id] = time
		end
		f:close()
	end

end

function KittyExport(KittyTable)
	local f = io.open(KittyFilename, "w")
	for id, date in pairs(KittyTable) do
		f:write(id .. " | " .. date .. "\n")
	end
	f:close()
end

function KittyHistoryPrint(KittyHistoryTable)
	for id, dates in pairs(KittyHistoryTable) do
		print("ID:"..id.." | ".. dates.start .. " | " .. dates.finish)
	end
end

function KittyHistoryAdd(KittyHistoryTable, id, start, finish)
	local f = io.open(KittyHistoryFilename, "a")
		f:write(id .. " | " .. start .. " | " .. finish .. "\n")
	f:close()
end

function KittyHistoryImport(KittyHistoryTable)
	local f = io.open(KittyHistoryFilename, "r")
	if f ~= nil then
		for line in io.lines(KittyHistoryFilename) do
			local args = {}
			args = split(line, " | ")
			local id = args[1]
			local start = args[2]
			local finish = args[3]

			KittyHistoryTable[id] = {}
			KittyHistoryTable[id].start = start
			KittyHistoryTable[id].finish = finish
		end
	end
	f:close()
end

client:on('ready', function()
	print('Bot is ready!')
	print("Try import kitty")
	KittyImport(KittyTable)
	print("Try import kittys history")
	KittyHistoryImport(KittyHistoryTable)
end)

client:on("memberUpdate", function(member)
	local guild = member.guild
	local id = member.id
	print("Catch event for " .. id)
	rc = getRoleId(guild, RoleName)
	if rc == nil then
		print("ERROR!!")
	end
	if KittyTable[id] == nil then
		if member:hasRole(RoleID) then
			print("Add role: " .. id)
			KittyTable[id] = os.time()
			KittyExport(KittyTable)
		end
	else
		if not(member:hasRole(RoleID)) then
			print("Remove role: " .. id)
			KittyHistoryTable[id] = {}
			KittyHistoryTable[id].start = KittyTable[id]
			KittyHistoryTable[id].finish = os.time()
			KittyTable[id] = nil
			KittyExport(KittyTable)
			KittyHistoryAdd(KittyHistoryTable, id, KittyHistoryTable[id].start, KittyHistoryTable[id].finish)
		end

	end

	KittyPrint(KittyTable)
	KittyHistoryPrint(KittyHistoryTable)

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
		for id, dates in pairs(KittyHistoryTable) do
			mention = client:getUser(id).mentionString
			print("\n\n"..KittyHistoryTable[id].start.."\n\n")
			output = output.."Участник: " .. mention ..
				" был котенком-учеником с: "..
				os.date("!%x %X", KittyHistoryTable[id].start) ..
				" по ".. os.date("!%x %X", KittyHistoryTable[id].finish)..
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
