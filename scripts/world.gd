extends Node3D

const API := "https://storyforge-backend-5faj0.onrender.com/api/sim"

@onready var cam: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $Player
@onready var http: HTTPRequest = $HTTPRequest
@onready var hud: Label = $HUD/Line
@onready var place: Label = $HUD/Place
@onready var clock: Label = $HUD/Clock

var yaw := 0.0
var pack: Dictionary = {}

func _ready() -> void:
	http.request_completed.connect(_on_http)
	_get("/scene")

func _get(path: String) -> void:
	http.request(API + path)

func _post(path: String, body: Dictionary) -> void:
	var payload := JSON.stringify(body)
	http.request(API + path, PackedStringArray(["Content-Type: application/json"]), HTTPClient.METHOD_POST, payload)

func _on_http(_result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if code != 200:
		hud.text = "Server %s — walk anyway." % str(code)
		return
	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	pack = parsed
	_paint()

func _paint() -> void:
	var loc: Dictionary = pack.get("location", {})
	var t: Dictionary = pack.get("time", {})
	place.text = str(loc.get("name", pack.get("scenery", {}).get("id", "Story Forge")))
	clock.text = "%s %s/%s · %02d:%02d" % [
		str(t.get("season", "")),
		str(t.get("month", "")),
		str(t.get("day", "")),
		int(t.get("hour", 0)),
		int(t.get("minute", 0)),
	]
	var line := str(pack.get("speech", pack.get("action", "")))
	if line.is_empty():
		line = "Walk. The hour is live."
	hud.text = line

func _physics_process(delta: float) -> void:
	var wish := Vector2.ZERO
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
	var forward := Vector3(-sin(yaw), 0.0, -cos(yaw))
	var right := Vector3(cos(yaw), 0.0, -sin(yaw))
	player.velocity = (forward * wish.y + right * wish.x) * 6.0
	player.velocity.y -= 12.0 * delta
	player.move_and_slide()
	var look := player.global_position + Vector3(0, 1.4, 0)
	var back := Vector3(sin(yaw), 0.0, cos(yaw)) * 5.0
	cam.global_position = look + back + Vector3(0, 1.6, 0)
	cam.look_at(look)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		yaw -= event.relative.x * 0.008
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		yaw -= event.relative.x * 0.008

func go_forest() -> void:
	_post("/act", {"action": "go:forest"})

func go_farm() -> void:
	_post("/act", {"action": "go:farm"})

func go_town() -> void:
	_post("/act", {"action": "go:town"})

func go_beach() -> void:
	_post("/act", {"action": "go:beach"})
