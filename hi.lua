token = require("token")
local discordia = require('discordia')
<<<<<<< HEAD
local client = discordia.Client()

=======
--local client = discordia.Client()
local client = discordia.Client {
	gatewayIntents = 3276799,
}
client:enableAllIntents()


role = '1142917198495617045'
>>>>>>> 871747b (add first examples)
client:on('ready', function()
    print('Bot is ready!')
end)

<<<<<<< HEAD
client:on('messageCreate', function(message)
    if message.content == '!hello' then
=======
client:on('memberLeave', function(member)
	print("Catch leave")
    -- Проверяем, имеет ли пользователь определенную роль
    if member:hasRole('1142917198495617045') then
        -- Отправляем сообщение в определенный канал
        client:getChannel('1142917349792563272'):send(member.tag .. ' покинул сервер!')
    end
end)

client:on('memberJoin', function(member)
	print("GetJoin")
	print("Join member:" .. member.username)
end)

client:on('voiceConnect', function(member)
	print("Connect")
	print("Join member:" .. member.username)
end)

client:on('messageCreate', function(message)
	print(message.content);
    if message.content == '!hello' then
	message:reply {
        content = message.author.mentionString .. "HI!",
        allowedMentions = {reply = true}
    }
>>>>>>> 871747b (add first examples)
        message.channel:send('Hello there!')
    end
end)

client:run("Bot " .. token)

