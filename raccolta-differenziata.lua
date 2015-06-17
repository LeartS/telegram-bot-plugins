local CHANNEL = 'chat#id13820496'
local DAYS = {
   nil, -- Sunday
   'l\' indifferenziata', -- Monday
   'umido e plastica', -- Tuesday
   'la carta', -- Wednesday
   'umido ed indifferenziata', -- Thursday
   'la plastica', -- Friday
   'umido e carta' -- Saturday
}

local function cron()
   local now = os.date("*t")
   -- the cron functions are called every 5 mins so theoretically this should
   -- evaluate to true exactly once a day
   if now.hour == 17 and now.min > 40 and now.min < 46 then
      if DAYS[now.wday] ~= nil then
         local m = 'Ragazzi ricordatevi che oggi bisogna portare fuori '
         if now.wday == 7 then
            -- Special message for saturday
            m = 'Se per caso qualcuno si trova in ufficio, ci sarebbe da' ..
               ' portare fuori '
         end
         send_large_msg(CHANNEL, m .. DAYS[now.wday])
      end
   end
end

return {
  description = "Evita l'accumulo di rifiuti",
  cron = cron,
  patterns = {},
}
