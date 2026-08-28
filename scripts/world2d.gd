extends Node2D
# xogot-2d-v1  cotl + anime panel

var host = "https://storyforge-backend-5aj0.onrender.com"
var dusk = false
var pack = {}
var room = "town"

func api():
	if dusk:
		return host + "/api/sim/after-dark"
	return host + "/api/sim"

func _ready():
	$HTTPRequest.request_completed.connect(_on_http)
	_paint_room("town")
	$HTTPRequest.request(api() + "/scene")

func _on_http(_result, code, _headers, body):
	if int(code) != 200:
		$HUD/Line.text = "Server " + str(code)
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	pack = parsed
	_hud()
	var loc = pack.get("location", {})
	var name = ""
	if typeof(loc) == TYPE_DICTIONARY:
		name = str(loc.get("name", "")).to_lower()
	if name.find("forest") >= 0:
		_paint_room("forest")
	elif name.find("farm") >= 0:
		_paint_room("farm")
	elif name.find("beach") >= 0:
		_paint_room("beach")
	else:
		_paint_room("town")

func _hud():
	var loc = pack.get("location", {})
	var title = "Story Forge"
	if typeof(loc) == TYPE_DICTIONARY:
		title = str(loc.get("name", title))
	if dusk:
		title = title + "  18+"
	$HUD/Place.text = title
	var t = pack.get("time", {})
	if typeof(t) == TYPE_DICTIONARY:
		$HUD/Clock.text = str(t.get("season", "")) + " " + str(t.get("hour", ""))
	var line = str(pack.get("speech", ""))
	if line == "" or line == "<null>":
		line = str(pack.get("action", "The village keeps moving."))
	$HUD/Line.text = line
	$Panel/Text.text = line

func _paint_room(id):
	room = id
	var floor = $Stage/Floor
	if id == "forest":
		floor.color = Color(0.12, 0.22, 0.12)
	elif id == "farm":
		floor.color = Color(0.28, 0.32, 0.14)
	elif id == "beach":
		floor.color = Color(0.72, 0.62, 0.38)
	else:
		floor.color = Color(0.22, 0.16, 0.14)
	$Stage/Accent.visible = (id == "beach" or id == "forest")
	if id == "beach":
		$Stage/Accent.color = Color(0.18, 0.4, 0.62)
	else:
		$Stage/Accent.color = Color(0.08, 0.18, 0.08)

func _process(_d):
	var v = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		v.y -= 1
	if Input.is_action_pressed("ui_down"):
		v.y += 1
	if Input.is_action_pressed("ui_left"):
		v.x -= 1
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if v.length() > 0:
		$Player.position += v.normalized() * 220 * _d
		$Player.position.x = clamp($Player.position.x, 40, 350)
		$Player.position.y = clamp($Player.position.y, 180, 620)

func _headers():
	return PackedStringArray(["Content-Type: application/json"])

func _go(where):
	$HTTPRequest.request(api() + "/act", _headers(), 2, JSON.stringify({"action": "go:" + where}))

func _say(text):
	$HTTPRequest.request(api() + "/say", _headers(), 2, JSON.stringify({"text": text}))

func go_forest():
	_go("forest")

func go_farm():
	_go("farm")

func go_town():
	_go("town")

func go_beach():
	_go("beach")

func go_dusk():
	dusk = not dusk
	$Panel.visible = dusk
	$HTTPRequest.request(api() + "/scene")

func go_talk():
	_say("hello")

func go_yes():
	$Panel.visible = true
	_say("yes")
