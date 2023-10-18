local discordia = require('discordia')

local token = require("token")
local DEBUG = 1
local logFile = "my.log"

--local client = discordia.Client()
local client = discordia.Client {
	gatewayIntents = 3276799,
	cacheAllMembers = true,
	logFile = logFile,
}
local RoleForCheck = 'Участник'
local RoleForCheck_id = nil

local RoleForPing  = 'Рекрутер'
local RoleForPing_id = nil

local ChannelForPing = "тестовый-канал"
local ChannelForPing_id = nil

local SaveFilename = "indiscord.txt"
local ImportFilename = "ingame.txt"

function log(str) --SEE Logger and log in discordia
	if DEBUG then
		local date = os.date("%Y-%M-%d %H:%M:%S")
		print(date .. " | \27[34m[LOG]    \27[0m | " .. str)

		local file = io.open(logFile, "a");
		file:write(date .. " | [LOG]     | " .. str .. "\n")
		file:close()
		return
	else
		str = ""
		return;
	end
end

function FillTable (filename, Table)
	for line in io.lines(filename) do
			table.insert(Table, line)
	end
end

local function exportDiscrodNicknames(members)
   local file = io.open(SaveFilename, 'w')
   NickNameTable = {}
   for _, member in ipairs(members) do
	if (member.nickname ~= nil) then
		file:write(member.nickname .. '\n')
		log("Found discord nickname for: " .. member.username .. " (" .. member.nickname .. ")")
		table.insert(NickNameTable, member.nickname)
	elseif (member.user._global_name  ~= nil) then
		file:write(member.user._global_name .. '\n')
		log("Found global_name for: " .. member.username .. " (" .. member.user._global_name .. ")")
		table.insert(NickNameTable, member.user._global_name)
	else -- member.username should be exist
		file:write(member.user.username .. '\n')
		log("member.username: " .. member.username)
		table.insert(NickNameTable, member.username)
	end
   end
   file:close()
   return NickNameTable
end

function CheckPrefix(nick)
	local err = nil
	local d_pref = "[WiT]"
	local n_pref = string.sub(nick, 1, 5)
	if d_pref ~= n_pref then
		if string.find(n_pref, '%[') and string.find(n_pref, '%]') then
			err = ("Неверный префикс \'" .. nick .. "\'. Вместо " .. d_pref .. " указан " .. n_pref)
		else
			err = ("\'" .. nick .. "\'" .. " не указан префикс гильдии.")
		end
		return nick, err
	end

	local space_after_pref = string.sub(nick, 6, 6)
	if space_after_pref ~= " " then
		err = ("\'" .. nick .. "\' .. отсутствует пробел после приставки " .. d_pref)
		return nick, err
	end
	
	local check_after_pref = string.sub(nick, 7, 7)
	if not string.match(check_after_pref, "[A-Za-z1-9]") then
		
		--err = ("\'" .. nick .. "\' .. после приставки и пробела невалидный символ:\'" .. check_after_pref .. "\'" ) -- sometimes generate error	
		err = ("\'" .. nick .. "\' .. после приставки и пробела невалидный символ\'" .. "".. "\'" ) 
		return ret, err
	end


	nick_without_prefix = string.sub(nick, 7)
	ret = string.match(nick_without_prefix, "%S+")
	return ret, nil
end

client:on('ready', function()
	print('Bot is ready!')
end)

client:on('messageCreate', function(message)
	if message.content == '!checkmembers' then
		log("Catch !checkmembers:" .. message.author.name)

		RoleForPing_id = ""
		RoleForCheck_id = ""
		if message.guild == nil then
			message:addReaction("✅");
			return;
		end
	
		local guild = message.guild
		local roles = guild.roles
		
		for _, role in pairs(roles) do
			if role.name == RoleForCheck then
				log("Find role ".. RoleForCheck .. " " .. role.id)
				RoleForCheck_id = role.id
			end
		end
	
		if RoleForCheck_id == nil then
			log("Not found role: " .. RoleForCheck);
			return;
		end
	
		for _, role in pairs(roles) do
			if role.name == RoleForPing then
				log("Find role ".. RoleForPing .. " " .. role.id)
				RoleForPing_id = role.id
			end
		end
	
		if RoleForPing_id == nil then
			log("Not found role: " .. RoleForPing);
			return;
		end
	
		local textChannels = guild.textChannels
	
		ChannelForPing_id = ""
		for _, channel in pairs(textChannels) do
			if channel.name == ChannelForPing then
				ChannelForPing_id = channel.id
				log("Find channel " .. ChannelForPing .. " " .. channel.id)
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
			end
	 		
		end
		
		DiscordNicknames = exportDiscrodNicknames(membersWithRole)

		inGameNicknames = {}
		FillTable(ImportFilename, inGameNicknames)
		if inGameNicknames == nil then
			log("Nicknames from game not load");
		end
		
		-- Try find ingame members in discord
		NotFoundInDiscord = {}
		for _, GameNick in ipairs(inGameNicknames) do
			local found = false
			for _, DiscordNick in ipairs(DiscordNicknames) do
				if string.find(string.lower(DiscordNick), string.lower(GameNick)) then
					found = true
					break;
				end
			end
			if found == false then
				log("Don't find member in discord: " .. GameNick)
				table.insert(NotFoundInDiscord, GameNick);
			end
		end


		local answer = ""
		isHeadPrinted = false
		table.sort(NotFoundInDiscord)
		
		--Send msgs with nicknames
		for _, Nick in ipairs(NotFoundInDiscord) do
			answer = answer .. Nick .. "\n"
			if #answer > 1000 then
				if isHeadPrinted == false then
					message:reply("Не удалось найти в discord:\n" .. answer)
					answer = ""
					isHeadPrinted = true
				else
					message:reply(answer)
					answer = ""
				end
			end
		end

		if isHeadPrinted == false then
			message:reply("Не удалось найти в discord:\n" .. answer)
		else
			message:reply(answer)
		end
		answer = ""
		for _, DiscordNick in ipairs(DiscordNicknames) do
			local WithoutPrefixNick
			local err
			WithoutPrefixNick, err = CheckPrefix(DiscordNick)
			if err ~= nil then
				log(err)
				answer = answer .. err .. "\n"
				if #answer > 1000 then
					message:reply(answer)
					answer = ""
				end
			else
				for _, gamenick in ipairs(inGameNicknames) do --rewrite
					_, last = string.find(WithoutPrefixNick, gamenick)
					if (last) and (last < #WithoutPrefixNick) then
						answer = answer .. ("\'" .. DiscordNick .. "\'" .. " После ника отсуствует разделительный пробел\n")
					end
				end
			end

		end
		
	end
end)

client:run("Bot " .. token)
