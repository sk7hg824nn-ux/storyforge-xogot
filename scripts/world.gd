extends Node3D
# xogot46-v2

const API = "https://storyforge-backend-5faj0.onrender.com/api/sim"

var yaw = 0.0
var pack = {}

func _ready():
	$HTTPRequest.request_completed.connect(_on_http)
	$HTTPRequest.request(API + "/scene")

func _on_http(_result, code, _headers, body):
	if int(code) != 200:
		$HUD/Line.text = "Server " + str(code) + " - walk anyway."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		$HUD/Line.text = "Walk. The hour is live."
		return
	pack = parsed
	_paint()

func _paint():
	var title = "Story Forge"
	var loc = pack.get("location", {})
	if typeof(loc) == TYPE_DICTIONARY and loc.get("name", "") != "":
		title = str(loc.get("name"))
	$HUD/Place.text = title
	$HUD/Clock.text = "Story Forge 4.6"
	var line = str(pack.get("speech", ""))
	if line == "" or line == "<null>":
		line = "Walk. The hour is live."
	$HUD/Line.text = line

func _physics_process(delta):
	var wish = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		wish.y += 1.0
	if Input.is_action_pressed("ui_down"):
		wish.y -= 1.0
	if Input.is_action_pressed("ui_left"):
		wish.x -= 1.0
	if Input.is_action_pressed("ui_right"):
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

func go_forest():
	$HTTPRequest.request(API + "/scene")

func go_farm():
	$HTTPRequest.request(API + "/scene")

func go_town():
	$HTTPRequest.request(API + "/scene")

func go_beach():
	$HTTPRequest.request(API + "/scene")
