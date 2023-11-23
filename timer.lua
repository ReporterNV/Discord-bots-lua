local token = require("token")
local discordia = require("discordia")
local timer = require('timer')

local client = discordia.Client()
local function threadFunc(message, note)
	--print(value)
	--print(note)
	message:reply(message.author.mentionString .. note)
end


client:on("messageCreate", function(message)
	if message.author.bot then return end
	local content = message.content

	if string.sub(content, 1, 6) == "!timer" then
		print(content)
		local time_str = string.match(content, "%s(%w+)%s")
		print("time: \""..time_str.."\"")
		local _, endtimer = content:find(time_str)
		local note = content:sub(endtimer+2)
		print("note: \""..note.."\"")

		--[[
		local years = string.match(timer, "%d+[y]")
		local month = string.match(timer, "%d+[M]")
		--]]
		local weeks = (string.match(time_str, "(%d+)[w]") or 0)
		local days  = (string.match(time_str, "(%d+)[d]") or 0)
		local hours = (string.match(time_str, "(%d+)[h]") or 0)
		local min = (string.match(time_str, "(%d+)[m]") or 0)
		local sec = (string.match(time_str, "(%d+)[s]") or 0)
		--[[
		print(years)
		print(month)
		--]]
		print("weeks: "..weeks)
		print("days: "..days)
		print("hours: "..hours)
		print("min: "..min)
		print("sec: "..sec)	
		

		time = sec +
			min*60 +
			hours*60*60 +
			days*24*60*60 +
			weeks*7*24*60*60

		print("sec to timer: " .. time)
		message:addReaction("✅");
		print(message)
		print(time)
		print(note)
		local flag = 0
		timer.setTimeout(time * 1000, coroutine.wrap(threadFunc), message, note )

		--[[
		local thread = coroutine.create(threadFunc)
		coroutine.resume(
		    thread, 
		    message,
		    timer,
		    note
		)
		-]]
	end
end)


client:run("Bot " .. token)
