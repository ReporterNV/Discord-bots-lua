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
local RoleForCheck_id

local RoleForPing  = 'Рекрутер'
local RoleForPing_id

local ChannelForPing = "тестовый-канал"
local ChannelForPing_id


client:on('ready', function()
	print('Bot is ready!')
end)

client:on('messageCreate', function(message)
if message.content == '!status' then -- Пример команды для получения списка ролей
	RoleForPing_id = ""
	RoleForCheck_id = ""
	if message.guild == nil then
		message:addReaction("✅");
		return;
	end

	local roles = message.guild.roles -- Получаем коллекцию всех ролей на сервере

	--rewrite this part
	for _, role in pairs(roles) do
		--print(role.id, role.name) -- Выводим идентификатор и имя каждой роли
		if role.name == RoleForCheck then
			print("Find role ".. RoleForCheck .. " " .. role.id)
			RoleForCheck_id = role.id
		end
	end
	for _, role in pairs(roles) do
		--print(role.id, role.name) -- Выводим идентификатор и имя каждой роли
		if role.name == RoleForPing then
			print("Find role ".. RoleForPing .. " " .. role.id)
			RoleForPing_id = role.id
		end
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

	--[[
	local role = message.guild:getRole(RoleForPing_id)
        client:getChannel(ChannelForPing_id):send(role.mentionString .. " Участник: " .. message.member.tag .. ' покинул сервер!')
	--]]
end
end)

client:on('memberLeave', function(member)
	print("Catch leave")
	
	RoleForPing_id = nil
	RoleForCheck_id = nil
	local roles = member.guild.roles
	--rewrite this part
		for _, role in pairs(roles) do
			if role.name == RoleForCheck then
				print("Find role ".. RoleForCheck .. " " .. role.id)
				RoleForCheck_id = role.id
			end
		end
		if RoleForCheck_id == nil then
			print("ERROR: Role:".. RoleForCheck.." not found!!")
		end

		for _, role in pairs(roles) do
			if role.name == RoleForPing then
				print("Find role ".. RoleForPing .. " " .. role.id)
				RoleForPing_id = role.id
			end
		if RoleForPing_id == nil then
			print("ERROR: Role:".. RoleForPing.." not found!!")
		end

	end

	local guild = member.guild
	local textChannels = guild.textChannels
	ChannelForPing_id = ""
	for _, channel in pairs(textChannels) do
		if channel.name == ChannelForPing then
			ChannelForPing_id = channel.id
			print("Find channel " .. ChannelForPing .. " " .. channel.id)
		end
		if ChannelForPing_id == nil then
			print("ERROR: Channel:".. ChannelForPing.." not found!!")
		end
	end



    if member:hasRole(RoleForCheck_id) then
	print("Catch leave server with role");
	--rewrite part with check. I no need ping if member without role
	local role = member.guild:getRole(RoleForPing_id)
        client:getChannel(ChannelForPing_id):send(role.mentionString .. " Участник: " .. member.tag .. ' покинул сервер!')
    end
end)

client:run("Bot " .. token)
