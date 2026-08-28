extends Node3D

const API = "https://storyforge-backend-5faj0.onrender.com/api/sim"

var yaw = 0.0
var pack = {}

func _ready():
	$HTTPRequest.request_completed.connect(_on_http)
	$HTTPRequest.request(API + "/scene")

func _on_http(_result, code, _headers, body):
	if code != 200:
		$HUD/Line.text = "Server " + str(code) + " — walk anyway."
		return
	var text = body.get_string_from_utf8()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	pack = parsed
	_paint()

func _paint():
	var loc = pack.get("location", {})
	var t = pack.get("time", {})
	var scenery = pack.get("scenery", {})
	var title = "Story Forge"
	if typeof(loc) == TYPE_DICTIONARY and loc.has("name"):
		title = str(loc["name"])
	elif typeof(scenery) == TYPE_DICTIONARY and scenery.has("id"):
		title = str(scenery["id"])
	$HUD/Place.text = title
	var season = ""
	var month = ""
	var day = ""
	var hour = 0
	var minute = 0
	if typeof(t) == TYPE_DICTIONARY:
		season = str(t.get("season", ""))
		month = str(t.get("month", ""))
		day = str(t.get("day", ""))
		hour = int(t.get("hour", 0))
		minute = int(t.get("minute", 0))
	$HUD/Clock.text = season + " " + month + "/" + day + "  " + str(hour) + ":" + str(minute)
	var line = str(pack.get("speech", pack.get("action", "")))
	if line == "" or line == "<null>":
		line = "Walk. The hour is live."
	$HUD/Line.text = line

func _physics_process(delta):
	var wish = Vector2.ZERO
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		wish.y += 1.0
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		wish.y -= 1.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		wish.x -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		wish.x += 1.0
	if wish.length() > 1.0:
		wish = wish.normalized()
	var forward = Vector3(-sin(yaw), 0.0, -cos(yaw))
	var right = Vector3(cos(yaw), 0.0, -sin(yaw))
	$Player.velocity = (forward * wish.y + right * wish.x) * 6.0
	$Player.velocity.y -= 12.0 * delta
	$Player.move_and_slide()
	var look = $Player.global_position + Vector3(0, 1.4, 0)
	var back = Vector3(sin(yaw), 0.0, cos(yaw)) * 5.0
	$Camera3D.global_position = look + back + Vector3(0, 1.6, 0)
	$Camera3D.look_at(look)

func _unhandled_input(event):
	if event is InputEventScreenDrag:
		yaw -= event.relative.x * 0.008

func _go(where):
	var body = JSON.stringify({"action": "go:" + where})
	var headers = PackedStringArray(["Content-Type: application/json"])
	$HTTPRequest.request(API + "/act", headers, 2, body)

func go_forest():
	_go("forest")

func go_farm():
	_go("farm")

func go_town():
	_go("town")

func go_beach():
	_go("beach")
