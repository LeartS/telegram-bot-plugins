local SAVE_LUNCH_PATTERN = ".*[oO]ggi abbiamo mangiato ([^%.]*)"
local CAST_VOTE_PATTERN = ".*[vV]oto (%d+).*"

function cast_vote(lunch, vote, user)
   redis:hset(lunch..'votes', user.id, vote)
   return "Voto registrato per " .. user.first_name .. ": " .. vote .. "."
end

function set_lunch(lunch, lunch_description)
   redis:set(lunch..'description', lunch_description)
   return "Ah, quindi oggi avete mangiato "..lunch_description..". Beati voi,"..
      " io mi nutro solamente di corrente elettrica del server su cui giro.\n"
end

function run(msg, matches)
   local today = os.date('%Y-%m-%d')
   local key = 'lunch:'..today

   message = ""
   lunch_description = string.match(msg.text, SAVE_LUNCH_PATTERN)
   vote = string.match(msg.text, CAST_VOTE_PATTERN)
   if lunch_description then
      message = message .. set_lunch(key, lunch_description)
   end
   if vote then
      message = message .. cast_vote(key, vote, msg.from)
   end

   if string.len(message) > 0 then
      return message
   end
end

return {
   description = "Ricorda cosa abbiamo mangiato",
   patterns = { SAVE_LUNCH_PATTERN, CAST_VOTE_PATTERN },
   run = run
}
