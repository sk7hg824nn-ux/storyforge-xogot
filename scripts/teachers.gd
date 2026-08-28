extends Node
# Live files on Render. Chat uploads are not in the repo.
# Until a named JPEG exists, we bind the closest live sheet so the walker never blanks.

const HOST = "https://storyforge-backend-5aj0.onrender.com"

const FILES = {
	"velmira": "/play/sprites/velmira.jpeg",
	"kitsune": "/play/sprites/kitsune.jpeg",
	"kitsune-body": "/play/sprites/kitsune-body.jpeg",
	"kitsune-back": "/play/sprites/kitsune-back.jpeg",
	"tamamo": "/play/sprites/tamamo.jpeg",
	"kagura": "/play/sprites/kagura.jpeg",
	"lyra": "/play/sprites/lyra.jpeg",
	"pippa": "/play/sprites/pippa.jpeg",
	"finnick": "/play/sprites/finnick.jpeg",
	"varun": "/play/sprites/varun.jpeg",
	"orc-berserker": "/play/sprites/orc-berserker.jpeg",
}

# name or species token -> live file key
const ALIAS = {
	"velmira": "velmira",
	"velmirae": "velmira",
	"ashentide": "velmira",
	"shadowveil": "velmira",
	"kitsune": "kitsune",
	"shiro": "kitsune",
	"fox": "kitsune",
	"foxfolk": "kitsune",
	"vexira": "kitsune",
	"tamamo": "tamamo",
	"kagura": "kagura",
	"tigerfolk": "kagura",
	"lyra": "lyra",
	"swiftfoot": "lyra",
	"varren": "lyra",
	"rabbitfolk": "lyra",
	"pippa": "pippa",
	"gearwhim": "pippa",
	"gnome": "pippa",
	"finnick": "finnick",
	"berrytoe": "finnick",
	"halfling": "finnick",
	"varun": "varun",
	"bronzeguard": "varun",
	"dragonborn": "varun",
	"vorzathar": "varun",
	"orc": "orc-berserker",
	"berserker": "orc-berserker",
	"grukkar": "orc-berserker",
	"grukk": "orc-berserker",
	"goblin": "orc-berserker",
	"shaman": "orc-berserker",
	"mira": "velmira",
	"noctis": "velmira",
	"rue": "velmira",
	"vesper": "velmira",
	"ashen": "velmira",
	"liryana": "velmira",
	"lunaris": "velmira",
	"fallen": "velmira",
	"vessara": "kitsune",
	"veshrae": "kitsune",
	"dark-elf": "kitsune",
	"drow": "kitsune",
	"rackett": "finnick",
	"raccoon": "finnick",
	"lira": "lyra",
	"otter": "lyra",
	"brusk": "orc-berserker",
	"boar": "orc-berserker",
	"vexkin": "finnick",
	"ratfolk": "finnick",
	"nyctea": "velmira",
	"owl": "velmira",
	"hart": "varun",
	"deer": "varun",
	"borgak": "orc-berserker",
	"bear": "orc-berserker",
	"nyxira": "tamamo",
	"satyr": "tamamo",
	"korvak": "orc-berserker",
	"minotaur": "orc-berserker",
	"bull": "orc-berserker",
	"grondar": "orc-berserker",
	"goliath": "orc-berserker",
	"ziraash": "kagura",
	"lizard": "kagura",
	"korzag": "orc-berserker",
	"hobgoblin": "orc-berserker",
	"veshka": "kagura",
	"tabaxi": "kagura",
	"gnoll": "orc-berserker",
	"kenku": "finnick",
	"bugbear": "orc-berserker",
	"coil": "tamamo",
	"yuan": "tamamo",
	"kael": "varun",
	"draven": "varun",
	"kragha": "kagura",
	"half-orc": "kagura",
	"grimkar": "varun",
	"brogar": "varun",
	"dwarf": "varun",
	"vorlith": "varun",
	"eliandor": "finnick",
	"bard": "finnick",
	"werewolf": "kitsune",
	"wolf": "kitsune",
	"angler": "tamamo",
	"kami": "tamamo",
	"origami": "tamamo",
	"ignivora": "kagura",
	"phoenix": "kagura",
	"dragon": "varun",
	"golem": "varun",
	"wraith": "velmira",
	"serpent": "varun",
	"tree": "varun",
	"cloud": "tamamo",
	"arachnarok": "orc-berserker",
}

const ROOMS = {
	"town": "/panels/village/001.png",
	"forest": "/panels/northern-forest/001.png",
	"farm": "/panels/farm/001.png",
	"beach": "/dna/places/palm-beach.jpeg",
	"tavern": "/panels/tavern/001.png",
	"ruins": "/dna/places/ruined-throne.jpeg",
	"crypt": "/dna/places/forgotten-depths-gothic-interiors.jpeg",
	"chapel": "/dna/places/autumn-shrine.jpeg",
	"tower": "/dna/places/star-throne.jpeg",
	"citadel": "/dna/places/lava-throne.jpeg",
	"caves": "/dna/places/crystal-cavern.jpeg",
	"deep": "/dna/places/jungle-lagoon.jpeg",
}

static func url_for_name(n):
	var raw = str(n).to_lower()
	var key = raw.replace(" ", "-").replace("_", "-")
	if FILES.has(key):
		return HOST + FILES[key]
	if ALIAS.has(key):
		return HOST + FILES[ALIAS[key]]
	var parts = key.split("-")
	var i = 0
	while i < parts.size():
		if ALIAS.has(parts[i]):
			return HOST + FILES[ALIAS[parts[i]]]
		i += 1
	return HOST + FILES["velmira"]

static func url_for_room(id):
	var key = str(id).to_lower()
	if ROOMS.has(key):
		return HOST + ROOMS[key]
	return HOST + ROOMS["town"]
