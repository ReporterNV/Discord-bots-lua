local token = require("token")
local discordia = require("discordia")
local client = discordia.Client()

local function sleep(seconds)
  os.execute("sleep " .. tonumber(seconds))
end

local function threadFunc(message, value, str)
	print(value)
	print(str)
  message:reply(message.author.mentionString .." Начало потока")
  sleep(value)
  message:reply("Таймер завершен! " .. str)
end

--[[
local str = "!timer 20h44m33s msg"

local timer = string.match(str, "[%s]%w+%s")
print("\""..timer.."\"")

local hours = string.match(timer, "%d+[h]")
local min = string.match(timer, "%d+[m]")
local sec = string.match(timer, "%d+[s]")

print(hours)
print(min)
print(sec)
--]]

client:on("messageCreate", function(message)
	if message.author.bot then return end
	local content = message.content

	if string.sub(content, 1, 6) == "!timer" then
		print(string.sub(content, 8, 9))
		if tonumber(string.sub(content, 8, 9)) then
			local thread = coroutine.create(threadFunc)
			coroutine.resume(
			    thread, 
			    message,
			    tonumber(string.sub(content, 8, 9)),
			    string.sub(content, 10)
			)
		else
			client:stop()
		end
	end
end)


client:run("Bot " .. token)
