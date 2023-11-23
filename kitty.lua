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
KittyTable = {}
KittyHistory = {}

function getPrintedName(member)
	--[[
	print("member.nickname"..(member.nickname or ""))
	print("member.username._global_name"..(member.username._global_name or ""))
	print("member.username"..(member.username or ""))
	--]]
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
  local minutes = math.floor(math.fmod(time,3600)/60)
  local seconds = math.floor(math.fmod(time,60))
  return string.format("DAY:%d; HOURS:%02d; MIN:%02d; SEC:%02d",days,hours,minutes,seconds)
end

function KittyPrint(KittyTable)
	for id, date in pairs(KittyTable) do
		print("ID:"..id.." | ".. disp_time(os.time()-date))
	end
end

function KittyPrint(KittyTable)
	for id, date in pairs(KittyTable) do
		print("ID:"..id.." | ".. disp_time(os.time()-date))
	end
end


function KittyHistoryPrint(KittyHistoryTable)
	for id, dates in pairs(KittyHistoryTable) do
		print("ID:"..id.." | ".. dates.start .. " | " .. dates.finish)
	end
end




client:on("memberUpdate", function(member)
	local guild = member.guild
	local id = member.id
	print("Catch event for "..getPrintedName(member))
	print("ID: "..id)
	print("ret: "..getPrintedName(guild:getMember(id)))
	getRoleId(guild, RoleName)
	if KittyTable[id] == nil then
		if member:hasRole(RoleID) then
			KittyTable[id] = os.time()
		end
	else
		print("remove kiity")
		print(member:hasRole(RoleID))
		print(not(member:hasRole(RoleID)))
		if not(member:hasRole(RoleID)) then
			print("remove kiity")
			KittyHistory[id] = {}
			KittyHistory[id].start = KittyTable[id]
			KittyHistory[id].finish = os.time()
			KittyTable[id] = nil
		end

	end


	--[[
	print(os.time())
	print(os.date("%Y-%M-%d %H:%M:%S"))
	--]]
	
	KittyPrint(KittyTable) --change to export
	KittyHistoryPrint(KittyHistory)

end)


client:on("messageCreate", function(message)
	if message.author.bot then return end
		
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end

	local mention
	local output = "" --RNV change it for default msg is empty
	
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
