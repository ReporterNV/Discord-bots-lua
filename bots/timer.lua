--add save timers in table
--import/export tables
local token = require("token")
local discordia = require("discordia")
local timer = require('timer')
local client = discordia.Client()

local function threadFunc(message, note)
	message:reply(message.author.mentionString .. " \n" .. note);
end

client:on("messageCreate", function(message)
	if message.author.bot then return end;
	local content = message.content;

	if string.sub(content, 1, 6) == "!timer" then
		print("Get timer msgs: " .. content);
		local time_str = string.match(content, "%s(%w+)%s*");
		print("time: \""..time_str.."\"");
		local _, endtimer = content:find(time_str); --rewrite it with use #
		--local note = content:sub(endtimer+2);
		local note = content:sub(#"!timer" + #time_str);
		print("note: \""..note.."\"");

		IsSeconds = tonumber(time_str); --check if not symbol for time like s,m,h,d or w;

		if (IsSeconds) then
			time = IsSeconds;
		else
			--[[
			local years = string.match(timer, "%d+[y]")
			local month = string.match(timer, "%d+[M]")
			--]]
			local weeks = (string.match(time_str, "(%d+)[w]") or 0);
			local days  = (string.match(time_str, "(%d+)[d]") or 0);
			local hours = (string.match(time_str, "(%d+)[h]") or 0);
			local min = (string.match(time_str, "(%d+)[m]") or 0);
			local sec = (string.match(time_str, "(%d+)[s]") or 0);
			--[[
			print(years);
			print(month);
			--]]
			print(
			"weeks: " .. weeks .. "; " ..
			"days: " .. days .. "; " ..
			"hours: " .. hours .. "; " ..
			"min: " .. min .. "; " ..
			"sec: " .. sec .. "; "
			);
			time = sec +
			min*60 +
			hours*60*60 +
			days*24*60*60 +
			weeks*7*24*60*60
		end
		print("timer in sec: " .. time);

		message:addReaction("✅");
		timer.setTimeout(time * 1000, coroutine.wrap(threadFunc), message, note);--bcz message:reply works only in coroutine
	end
end)


client:run("Bot " .. token);
