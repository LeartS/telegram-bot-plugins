-- Sends a random submissions from /r/educationalgif
-- with at least MIN_SUBMISSION_SCORE points.
-- Retries until the gif size is less than MAX_GIF_SIZE

local MIN_SUBMISSION_SCORE = 5 -- If less, ignore and try another submission
local MAX_GIF_SIZE = 10485760 -- In bytes. If bigger, try another submission

function get_random_submission()
   local r, s = http.request(
      "http://api.reddit.com/r/educationalgifs/random.json?t=" .. os.time()
   )
   return json:decode(r)[1]['data']['children'][1]['data']
end

-- Adapt some known problematic urls to make them work
function fix_url(url)
   if url:match(".*imgur.com.*%.gifv") then
      -- the same url .gif should work
      return url:sub(1, -2)
   elseif url:match("^.*gfycat.com/(%a+)$") then
      local gfyid = string.match(url, "^.*gfycat.com/(%a+)$")
      return 'http://giant.gfycat.com/' .. gfyid ..'.gif'
   end
   return url
end

function run(msg, matches)
   local submission, url
   repeat
      repeat
         submission = get_random_submission()
      until submission['score'] >= MIN_SUBMISSION_SCORE
      url = fix_url(submission['url'])
      print(submission['url'])
      print(url)
      -- Download the gif initally to check its size.
      -- Wasteful as it will redownload it later inside send_document_from_url
      -- But I couldn't find any better way to check for the gif size without
      -- downloading it, and we really want to avoid sending 70MB gifs.
      -- Downloading them multiple times on the server is not much of a problem
      local gif, status = http.request(url)
      print(#gif)
   until status == 200 and gif:len() <= MAX_GIF_SIZE

   send_large_msg(get_receiver(msg), submission['title'])
   send_document_from_url(get_receiver(msg), url)
end

return {
	description = "Educational Gif",
	usage = "!edugif",
	patterns = { "^!edugif$" },
	run = run
}
