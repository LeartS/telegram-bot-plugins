-- Spam / Procrastination check
-- Admonish someone if he sends more than N_MESSAGES messages in TIME_INTERVAL
-- Useful for group chats, particulary work chats and similar

local TIME_INTERVAL = 180 -- seconds
local N_MESSAGES = 4

function store_message(msg)
   key = 'chat:'..msg.to.id..':flood:'..msg.from.id..':'..msg.date
   redis:setex(key, TIME_INTERVAL, msg.text)
end

function run(msg, matches)
   if not msg.to.type == 'chat' then
      return nil
   end
   local datetime = os.date("*t", msg.date)
   if (datetime.wday-1) % 6 == 0 or datetime.hour >= 18 or datetime.hour < 9 or
      (datetime.hour >= 13 and datetime.hour < 14) then
      return nil
   end
   store_message(msg)
   key = 'chat:'..msg.to.id..':flood:'..msg.from.id
   messages = redis:keys(key..':*')

   if #messages >= N_MESSAGES then
      for i, key in ipairs(messages) do
         redis:del(key)
      end
      local sender = get_name(msg)
      return sender:gsub("^%l", string.upper) ..
         ' stop messaging and get back to work!'
   end
   return false
end

return {
   description = "Call out people sending too many messages in a short time",
   patterns = { "." },
   run = run
}
