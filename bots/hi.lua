token = require("token")
local discordia = require('discordia')
--local client = discordia.Client()
local client = discordia.Client {
	gatewayIntents = 3276799,
}
client:enableAllIntents()


role = '1142917198495617045'
client:on('ready', function()
    print('Bot is ready!')
end)

client:on('messageCreate', function(message)
    if message.content == '!hello' then
       message.channel:send('Hello there!')
    end
end)

client:run("Bot " .. token)

