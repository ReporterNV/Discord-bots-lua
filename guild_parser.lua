local Indiscord = {};
local Ingame = {};
local WrongPrefix = {};

function FillTable (filename, Table)
	for line in io.lines(filename) do
			table.insert(Table, line)
	end
end

function CheckPrefix(nick)
	local err = nil
	local d_pref = "[WiT]"
	local n_pref = string.sub(nick, 1, 5)
	if d_pref ~= n_pref then
		err = ("Неверный префикс \'" .. nick .. "\'. Вместо " .. d_pref .. " указан " .. n_pref)
		return nick, err
	end

	local space_after_pref = string.sub(nick, 6, 6)
	if space_after_pref ~= " " then
		err = ("\'" .. nick .. "\' .. отсутствует пробел после приставки " .. d_pref)
		return nick, err
	end
	
	local check_after_pref = string.sub(nick, 7, 7)
	if not string.match(check_after_pref, "[A-Za-z1-9]") then
		err = ("\'" .. nick .. "\' .. после приставки и пробела невалидный символ:\'" .. check_after_pref .. "\'" )
		return ret, err
	end

	nick_without_prefix = string.sub(nick, 7)
	ret = string.match(nick_without_prefix, "%S+")
	return ret, nil
end


FillTable("indiscord.txt", Indiscord);
FillTable("ingame.txt", Ingame);
local err
local answer=""
for _, elem in pairs(Indiscord) do
	-- print(elem)
	nick, err = CheckPrefix(elem)
	if err ~= nil then
		answer = answer .. err .. "\n"
		--print (err)
	else
		i = 0
		for _, gamenick in pairs(Ingame) do
			i = i +1 
			_, last = string.find(nick, gamenick)
			if (last) and (last < #nick) then
				answer = answer .. ("\'" .. nick .. "\'" .. " После ника отсуствует разделительный пробел\n")
				--print("\'" .. nick .. "\'" .. " После ника отсуствует разделительный пробел")
			end
		end
	end
end

print(answer.."\b")

