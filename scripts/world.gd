extends Node3D
# Bodies are built from parts + teacher photo. GLB swap comes when Meshy files exist.

var host = "https://storyforge-backend-5aj0.onrender.com"
var dusk = false
var yaw = 0.0
var pack = {}
var places
var folk
var Teachers = load("res://scripts/teachers.gd")
var Body = load("res://scripts/body.gd")

func api():
	if dusk:
		return host + "/api/sim/after-dark"
	return host + "/api/sim"

func _ready():
	places = Node3D.new()
	places.name = "Places"
	places.set_script(load("res://scripts/places.gd"))
	add_child(places)
	folk = Node3D.new()
	folk.name = "Folk"
	add_child(folk)
	var pmesh = $Player.get_node_or_null("Mesh")
	if pmesh:
		pmesh.visible = false
	$HTTPRequest.request_completed.connect(_on_http)
	$HTTPRequest.request(api() + "/scene")

func _on_http(_result, code, _headers, body):
	if int(code) != 200:
		$HUD/Line.text = "Server " + str(code) + " - walk anyway."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	pack = parsed
	_paint()

func _paint():
	var title = "Story Forge"
	var loc = pack.get("location", {})
	if typeof(loc) == TYPE_DICTIONARY and str(loc.get("name", "")) != "":
		title = str(loc.get("name"))
	if dusk:
		title = title + "  18+"
	$HUD/Place.text = title
	var t = pack.get("time", {})
	if typeof(t) == TYPE_DICTIONARY:
		$HUD/Clock.text = str(t.get("season", "")) + " " + str(t.get("hour", ""))
	var line = str(pack.get("speech", ""))
	if line == "" or line == "<null>":
		line = str(pack.get("action", ""))
	if line == "" or line == "<null>":
		line = "Walk. The hour is live."
	$HUD/Line.text = line
	if places and places.has_method("rebuild"):
		places.rebuild(pack)
	_folk()

func _folk():
	for c in folk.get_children():
		c.queue_free()
	var list = pack.get("characters", [])
	if typeof(list) != TYPE_ARRAY:
		return
	var n = 0
	for ch in list:
		if typeof(ch) != TYPE_DICTIONARY:
			continue
		if str(ch.get("id", "")) == "player":
			continue
		var name = str(ch.get("name", ch.get("id", "folk")))
		var card = Body.make(ch)
		var a = float(n) * 1.2
		card.position = Vector3(sin(a) * 2.8, 0.0, 1.6 + cos(a) * 2.2)
		var req = HTTPRequest.new()
		req.name = "Pull"
		card.add_child(req)
		req.request_completed.connect(_on_skin.bind(card))
		req.request(Teachers.url_for_name(name))
		folk.add_child(card)
		n += 1
		if n > 8:
			break

func _on_skin(_result, code, _headers, body, card):
	if int(code) != 200:
		return
	var img = Image.new()
	var err = img.load_jpg_from_buffer(body)
	if err != OK:
		err = img.load_png_from_buffer(body)
	if err != OK:
		return
	var tex = ImageTexture.create_from_image(img)
	Body.paint(card, tex)

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
	$HTTPRequest.request(api() + "/scene")

func go_talk():
	_say("hello")

func go_yes():
	_say("yes")
