local SAVE_LUNCH_PATTERN = ".*[oO]ggi abbiamo mangiato ([^%.]*)"
local CAST_VOTE_PATTERN = ".*[vV]oto (%d+).*"

function cast_vote(lunch, vote, user)
   redis:hset(lunch .. ':votes', user.id, vote)
   return "Voto registrato per " .. user.first_name .. ": " .. vote .. "."
end

function set_lunch(lunch, lunch_description)
   redis:set(lunch .. ':description', lunch_description)
   return "Ah, quindi oggi avete mangiato " .. lunch_description ..
      ". Beati voi, io mi nutro solamente di corrente elettrica del" ..
      " server su cui giro.\n"
end

function run(msg, matches)
   local today = os.date('%Y-%m-%d')
   local key = 'chat:' .. msg.to.id .. ':lunch:' .. today

   lunch_description = string.match(msg.text, SAVE_LUNCH_PATTERN)
   if lunch_description then
      local response = set_lunch(key, lunch_description)
      send_large_msg(get_receiver(msg), response)
   end

   vote = string.match(msg.text, CAST_VOTE_PATTERN)
   if vote then
      local response = cast_vote(key, vote, msg.from)
      send_large_msg(get_receiver(msg), response)
   end
end

return {
   description = "Ricorda cosa abbiamo mangiato",
   patterns = { SAVE_LUNCH_PATTERN, CAST_VOTE_PATTERN },
   run = run
}
