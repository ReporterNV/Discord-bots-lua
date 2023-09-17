token = require("token")
local discordia = require('discordia')
--local client = discordia.Client()
local client = discordia.Client {
	gatewayIntents = 3276799,
}
--client:enableAllIntents()
--[[
--Бот загружает доступные роли
--Проверяет есть ли роли которые надо пинговать
--Проверяет что может писать в канал
--Ловит события лива и пингует рекрутера
--]]

--role = '1142917198495617045'
local Guild_id = '1142916945570709514'
local RoleForCheck = 'Участник'
local RoleForPing  = 'Рекрутер'
local RoleForCheck_id
local RoleForPing_id

--channel = '1142917198495617045'

client:on('ready', function()
	print('Bot is ready!')
	local guild = client.guilds:get(Guild_id);
	local textChannels = guild.textChannels
	for _, channel in pairs(textChannels) do
        	print(channel.name)
	end

end)

client:on('messageCreate', function(message)
if message.content == '!status' then -- Пример команды для получения списка ролей
	RoleForPing_id = ""
	RoleForCheck_id = ""
	local roles = message.guild.roles -- Получаем коллекцию всех ролей на сервере
	--rewrite this part
		for _, role in pairs(roles) do
			--print(role.id, role.name) -- Выводим идентификатор и имя каждой роли
			if role.name == RoleForCheck then
				print("Find role ".. RoleForCheck .. role.id)
				RoleForCheck_id = role.id
			end
		end
		for _, role in pairs(roles) do
			--print(role.id, role.name) -- Выводим идентификатор и имя каждой роли
			if role.name == RoleForPing then
				print("Find role ".. RoleForPing .. role.id)
				RoleForPing_id = role.id
			end
		end
	end
	print("\n" .. RoleForCheck_id);
	print(RoleForPing_id);
end)

client:on('memberLeave', function(member)
	print("Catch leave")
	
	RoleForPing_id = ""
	RoleForCheck_id = ""
	local roles = member.guild.roles
	--rewrite this part
		for _, role in pairs(roles) do
			if role.name == RoleForCheck then
				print("Find role ".. RoleForCheck .. role.id)
				RoleForCheck_id = role.id
			end
		end
		for _, role in pairs(roles) do
			if role.name == RoleForPing then
				print("Find role ".. RoleForPing .. role.id)
				RoleForPing_id = role.id
			end
		end

    if member:hasRole(RoleForCheck_id) then
        -- Отправляем сообщение в определенный канал
        client:getChannel('1142917349792563272'):send(member.tag .. ' покинул сервер!')
    end
end)

client:run("Bot " .. token)
--[[
local discordia = require("discordia")
local client = discordia.Client()
local roleID = "ВАШ_ID_РОЛИ"

client:on("ready", function()
    print("Бот готов!")
end)

client:on("messageCreate", function(message)
    if message.content == "!пингроль" then
        local role = message.guild:getRole(roleID)
        if role then
            message.channel:send(role:mention() .. " Пинг роли!")
        else
            message.channel:send("Роль не найдена!")
        end
    end
end)

client:run("YOUR_BOT_TOKEN")
--]]
