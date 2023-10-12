local Indiscord = {};
local WrongPrefix = {};

function FillTable (filename, Table)
	for line in io.lines(filename) do
			table.insert(Table, line)
	end
end

function CutPrefix (nick)
	local err = nil
	local d_pref = "[WiT]"
	local n_pref = string.sub(nick, 1, 5)

	if d_pref ~= n_pref then
		err = ("Неверный префикс гильдии у \'" .. nick .. "\'. Вместо " .. d_pref .. " указан " .. n_pref)
		return nick, err
	end

	local space_after_pref = string.sub(nick, 6, 6)
	if space_after_pref ~= " " then
		err = ("У \'" .. nick .. "\' .. отсутствует пробел после приставки " .. d_pref)
		return nick, err
	end



end




FillTable("indiscord.txt", Indiscord);
local err

for _, elem in pairs(Indiscord) do
	-- print(elem)
	nick, err = CutPrefix(elem)
	if err ~= nil then
		print (err)
	end

end


