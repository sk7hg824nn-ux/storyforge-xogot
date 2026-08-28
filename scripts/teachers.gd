extends Node
# Teachers live on the backend as /play/sprites and /panels.
# Chat uploads are gone from RAM. These files are the surviving pack.

const HOST = "https://storyforge-backend-5aj0.onrender.com"

const SPRITES = {
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

const ROOMS = {
	"town": "/panels/village/001.png",
	"forest": "/panels/northern-forest/001.png",
	"farm": "/panels/farm/001.png",
	"beach": "/dna/places/palm-beach.jpeg",
	"tavern": "/panels/tavern/001.png",
}

static func url_for_name(n):
	var key = str(n).to_lower()
	if SPRITES.has(key):
		return HOST + SPRITES[key]
	if key.find("kitsune") >= 0 or key.find("fox") >= 0:
		return HOST + SPRITES["kitsune"]
	if key.find("orc") >= 0:
		return HOST + SPRITES["orc-berserker"]
	return HOST + SPRITES["velmira"]

static func url_for_room(id):
	if ROOMS.has(id):
		return HOST + ROOMS[id]
	return HOST + ROOMS["town"]
