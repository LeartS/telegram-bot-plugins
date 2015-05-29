local TIME_INTERVAL = 180 -- seconds
local N_MESSAGES = 4

function store_message(msg)
   key = 'chat:'..msg.to.id..':flood:'..msg.from.id..':'..msg.date
   redis:setex(key, TIME_INTERVAL, msg.text)
end

function run(msg, matches)
   if not msg.to.type == 'chat' then
      return
   end
   store_message(msg)
   key = 'chat:'..msg.to.id..':flood:'..msg.from.id
   messages = redis:keys(key..':*')
   if #messages >= N_MESSAGES then
      for i, key in ipairs(messages) do
         redis:del(key)
      end
      return msg.from.first_name:gsub("^%l", string.upper) ..
         ' smettila di messaggiare e torna a lavorare!'
   end
   return false
end

return {
   description = "Tiene in riga i dipendenti",
   patterns = { "." },
   run = run
}