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
         return true
      end
   end
end

function TestPlugins:testPiatti()
   local t = loadfile("piatti.lua")()
   luaunit.assertTrue(self:matchPlugin(t, 'Piatti?'))
   luaunit.assertTrue(self:matchPlugin(t, 'A chi tocca fare i piatti?'))
   luaunit.assertFalse(self:matchPlugin(t, 'Lavapiatti'))
   luaunit.assertFalse(self:matchPlugin(t, 'Appiattito'))
   luaunit.assertFalse(self:matchPlugin(t, 'Accalappiapiatti'))
   luaunit.assertFalse(self:matchPlugin(t, 'Piattivendolo'))
end
   

os.exit( luaunit.LuaUnit.run() )
