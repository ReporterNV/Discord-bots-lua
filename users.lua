token = require("token")
local discordia = require('discordia')
--local client = discordia.Client()
local client = discordia.Client {
	gatewayIntents = 3276799,
}
--[[
--Бот загружает доступные роли
--Проверяет есть ли роли которые надо пинговать
--Проверяет что может писать в канал
--Ловит события лива и пингует рекрутера
--]]

local RoleForCheck = 'Участник'
local RoleForCheck_id = nil

local RoleForPing  = 'Рекрутер'
local RoleForPing_id = nil

local ChannelForPing = "тестовый-канал"
local ChannelForPing_id = nil

local SaveFilename = "indiscord.txt"
local ImportFilename = "ingame.txt"


client:on('ready', function()
	print('Bot is ready!')
end)

local function saveMembers(members)
   local file = io.open(SaveFilename, 'w')
   for _, member in ipairs(members) do
	if member.nickname then
		file:write(member.nickname .. '\n')
	else
--		log("Not found nickname for: " .. member.user.username);
	end
   end
   file:close()
end

local function importNames()
	ImportedNames = {};
	local file = io.open(ImportFilename, 'r') -- add check for exist
	for line in file:lines() do
		table.insert(ImportedNames, line);
	end
	
	file:close()
	return ImportedNames
end


log = print

client:on('messageCreate', function(message)
if message.content == '!checkmembers' then
	print("catch checkmembers")
	RoleForPing_id = ""
	RoleForCheck_id = ""
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end

	local roles = message.guild.roles
	
	for _, role in pairs(roles) do
		if role.name == RoleForCheck then
			print("Find role ".. RoleForCheck .. " " .. role.id)
			RoleForCheck_id = role.id
		end
	end

	if RoleForCheck_id == nil then
		log("Not found role: " .. RoleForCheck);
		return;
	end

	for _, role in pairs(roles) do
		if role.name == RoleForPing then
			print("Find role ".. RoleForPing .. " " .. role.id)
			RoleForPing_id = role.id
		end
	end

	if RoleForPing_id == nil then
		log("Not found role: " .. RoleForPing);
		return;
	end

	local guild = message.guild
	local textChannels = guild.textChannels

	ChannelForPing_id = ""
	for _, channel in pairs(textChannels) do
		if channel.name == ChannelForPing then
			ChannelForPing_id = channel.id
			print("Find channel " .. ChannelForPing .. " " .. channel.id)
			if message.channel.id == channel.id then
				message:addReaction("✅");
			end

		end
	end
	
	local role = guild.roles:get(RoleForCheck_id)
	local membersWithRole = {}

	local allMembers = guild.members:toArray()
	for _, guildMember in ipairs(allMembers) do
		if guildMember:hasRole(role) then
			table.insert(membersWithRole, guildMember)
			if guildMember.nickname == nil then
				log("No nickname for: " .. guildMember.name );
			end

		end
 		
	end
	
	saveMembers(membersWithRole)
	
	inGame = importNames()
	if importNames == nil then
		log("ERROR");
	end
	
	NotFoundMembers = {}
	for _, GameNick in ipairs(inGame) do
		--print(GameNick);
		local found = false

		for _, DiscordNick in ipairs(membersWithRole) do
			if string.find(string.lower(DiscordNick.name), string.lower(GameNick)) then
				-- print("Find member: " .. GameNick); 
				found = true
				break;
			end
		end
		if found == false then
			print("Dont find member in discrod: " .. GameNick)
			table.insert(NotFoundMembers, GameNick);
		end
	end

	answer = "Не удалось найти в discord:\n"
	for _, Nick in ipairs(NotFoundMembers) do
		answer = answer .. Nick .. "\n"
	end

	message:reply("" .. answer)

	answer = ""
	for _, DiscordNick in ipairs(membersWithRole) do
		print(DiscordNick.name);
		local found = false
		local SP, EP = string.find(DiscordNick.name, "]") -- remove ]
		local EditedNickname = ""
		if SP ~= nil then
			EditedNickname = string.sub(DiscordNick.name, SP+1) -- find word after ]
			print(EditedNickname)
			EditedNickname = string.match(EditedNickname or DiscordNick.name, "%w+")
			local EditedNickname_low = string.lower(EditedNickname or DiscordNick.name)
			for _, GameNick in ipairs(inGame) do
				print(string.lower(GameNick).." and "..EditedNickname_low);
				if string.find(string.lower(GameNick), EditedNickname_low) then
					-- print("Find member: " .. GameNick); 
					found = true
					break;
				end
			end
			if found == false then
				print("Dont find member in game: " .. DiscordNick.name)
				answer = answer .. DiscordNick.name .. "\n"
				message:reply("Не удалось найти в игре: " .. DiscordNick.name .. "\n")
			end
		end
	end


	--[[
	REWRITEE!!!!!!!
	
	I DONT WANT SEEE CODE LIKE THIS

	]]--


end
end)

client:run("Bot " .. token)
