local function run(msg, matches)
	messages = {
		"Tocca a Saro!",
		"Secondo i miei calcoli, tocca a Saro",
		"Sono abbastanza sicuro tocchi a Saro",
		"Oggi li deve fare Saro",
		"Saro",
		"Oggi tocca a Ciccio. Ah, no, scusate, tocca a Saro!"
	}
	return "Piatti? " .. messages[math.random(#messages)]
end

return {
	description = "Tiene traccia dei turni piatti",
	usage = "Basta nominare i piatti",
	patterns = { "%f[%a][pP]iatti%f[%A]" },
	run = run
}
