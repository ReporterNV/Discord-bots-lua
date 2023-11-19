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

--[[
--[ ]Проверить что есть роль котик ученик.
--[ ]Проверить что нет в таблице котико-учеников
--[ ]Если есть, то внести, иначе это другое изменение
--[ ]По команде выводить время прошедшее с выдачи роли котик-ученик
--[ ]
--]]

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
  return string.format("DAY:%d;HOURS:%02d;MIN:%02d;SEC:%02d",days,hours,minutes,seconds)
end

function KittyPrint(KittyTable)
	for id, date in pairs(KittyTable) do
		print("ID:"..id.." | ".. disp_time(os.time()-date))
	end
end

client:on("memberUpdate", function(member)
	local guild = member.guild
	print("Catch event for "..getPrintedName(member))
	print("ID: "..member.id)
	print("ret: "..getPrintedName(guild:getMember(member.id)))
	getRoleId(guild, RoleName)
	if member:hasRole(RoleID) then
		if KittyTable[member.id] == nil then
			KittyTable[member.id] = os.time()
		end
	end
	--[[
	print(os.time())
	print(os.date("%Y-%M-%d %H:%M:%S"))
	--]]
	KittyPrint(KittyTable)

end)


client:on("messageCreate", function(message)
	if message.author.bot then return end
		
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end
	local guild = message.guild
	local output = ""

	if message.content == "!kitty" then
	
		for id, date in pairs(KittyTable) do
			print("ID:"..guild:getMember(id).username.." | ".. disp_time(os.time()-date))

			output = output.."Котенок: "..guild:getMember(id).nickname..
				" Ученик уже: "..disp_time(os.time()-date).."\n"
		end
		print(output);
		message:reply(output);
	end
end)




client:run("Bot " .. token)
