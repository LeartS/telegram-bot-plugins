luaunit = require('luaunit')

TestPlugins = {}

function TestPlugins:match_pattern(pattern, text)
   if text then
      local matches = {}
      matches = { string.match(text, pattern) }
      if next(matches) then
         return matches
      end
   end
   -- nil
end

function TestPlugins:matchPlugin(plugin, message)
   for k, pattern in pairs(plugin.patterns) do
      local matches = self:match_pattern(pattern, message)
      if matches then
         return matches
      end
   end
   return false
end

function TestPlugins:emulate(plugin, msg)
   local matches = self:matchPlugin(plugin, msg.text)
   if matches then
      return plugin.run(msg, matches)
   end
   return false
end

function TestPlugins:testProcrastination()
   -- We can't check if it really works because we would need redis and the
   -- lua redis library, but at least we can check that the time controls work

   -- Evening
   local plugin = loadfile("anti-procrastination.lua")()
   local msg = {
      date = os.time({year=2015, month=5, day=29, hour=19}),
      to = { type = 'chat', id = '4324234' },
      from = { id = '654645' },
      text = "sono su telegram al posto di lavorare",
   }
   luaunit.assertNil(self:emulate(plugin, msg))

   -- Weekend
   msg.date = os.time({year=2015, month=5, day=30, hour=11})
   luaunit.assertNil(self:emulate(plugin, msg))

   -- Lunch time
   msg.date = os.time({year=2015, month=5, day=29, hour=13})
   luaunit.assertNil(self:emulate(plugin, msg))

   -- Work hours
   msg.date = os.time({year=2015, month=5, day=29, hour=11})
   luaunit.assertErrorMsgContains('redis', TestPlugins.emulate,
                                  self, plugin, msg)
end
      

os.exit( luaunit.LuaUnit.run() )
