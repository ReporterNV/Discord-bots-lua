token = require("token")
local discordia = require('discordia')
local client = discordia.Client()

client:on('ready', function()
    print('Bot is ready!')
end)

client:on('messageCreate', function(message)
	if message.content == '!ping' then
		print('get ping');
		--local everyoneRole = message.guild.roles:get('@everyone')
		local everyoneRole = message.guild.everyone

        	message.channel:send(everyoneRole.mentionString)
		message.channel:send(everyoneRole.mentionString)
	end

    if message.content == '!hello' then
		print('get hello');
	    reaction = '\u{2714}'--':thumbsup:'
		--'\u{1F44D}'
	message:addReaction(reaction)
	--local everyoneRole = message.guild.roles:get('@everyone')
        --message.channel:send(everyoneRole.mentionString)
        message.channel:send('Hello there!')
        --message:reply('HI')

	message.channel:send {
            content = message.author.mentionString .. ', Pong!',
            reference = message
        }
    end
end)

client:on('messageCreate', function(message)
    if message.content == '!роли' then -- Пример команды для получения списка ролей
        local roles = message.guild.roles -- Получаем коллекцию всех ролей на сервере
        
        for name, role in pairs(roles) do
            print(name .. role.id) -- Выводим идентификатор каждой роли
        end
    end

    if message.content == '!пингроли' then -- Пример команды для вызова отправки сообщения с пингом роли
        local roleName = 'Тестер' -- Замените на имя роли, которую вы хотите отметить
        
        local role = message.guild.roles:find(function(r) -- Поиск роли по имени
            return r.name == roleName
        end)

        if role then -- Если роль найдена
            message:reply('Пингую роль: <@&' .. role.id .. '>') -- Отправка сообщения с пингом роли
        else
            message:reply('Роль не найдена.') -- Сообщение, если роль не найдена
        end
    end

end)


client:run("Bot " .. token)
