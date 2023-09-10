token = require("token")
local discordia = require('discordia')
local client = discordia.Client()

client:on('ready', function()
    print('Bot is ready!')
end)

client:on('messageCreate', function(message)
    if message.content == '!hello' then
        message.channel:send('Hello there!')
    end
end)

client:run("Bot " .. token)

