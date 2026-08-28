extends Node3D
# builds forest farm town beach from primitives

var last_id = ""

func key_of(pack):
	var loc = pack.get("location", {})
	var sc = pack.get("scenery", {})
	var bits = []
	if typeof(loc) == TYPE_DICTIONARY:
		bits.append(str(loc.get("id", "")))
		bits.append(str(loc.get("name", "")))
		bits.append(str(loc.get("biome", "")))
	if typeof(sc) == TYPE_DICTIONARY:
		bits.append(str(sc.get("id", "")))
		bits.append(str(sc.get("biome", "")))
	return " ".join(bits).to_lower()

func rebuild(pack):
	var id = key_of(pack)
	if id == last_id and get_child_count() > 0:
		return
	last_id = id
	for c in get_children():
		c.queue_free()
	if id.find("farm") >= 0 or id.find("barn") >= 0 or id.find("pasture") >= 0:
		_farm()
	elif id.find("forest") >= 0 or id.find("woods") >= 0 or id.find("grove") >= 0:
		_forest()
	elif id.find("beach") >= 0 or id.find("coast") >= 0 or id.find("shore") >= 0:
		_beach()
	else:
		_town()

func _mat(color):
	var m = StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.85
	return m

func _box(pos, size, color):
	var mi = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = _mat(color)
	mi.position = pos
	add_child(mi)
	return mi

func _cyl(pos, r, h, color):
	var mi = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = r * 0.7
	mesh.bottom_radius = r
	mesh.height = h
	mi.mesh = mesh
	mi.material_override = _mat(color)
	mi.position = pos
	add_child(mi)
	return mi

func _cone(pos, r, h, color):
	var mi = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = 0.02
	mesh.bottom_radius = r
	mesh.height = h
	mi.mesh = mesh
	mi.material_override = _mat(color)
	mi.position = pos
	add_child(mi)

func _ground(color):
	var mi = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = Vector3(90, 0.2, 90)
	mi.mesh = mesh
	mi.material_override = _mat(color)
	mi.position = Vector3(0, -0.1, 0)
	add_child(mi)

func _forest():
	_ground(Color(0.18, 0.28, 0.14))
	for i in range(36):
		var a = (float(i) / 36.0) * TAU
		var r = 7.0 + float(i % 6) * 1.4
		var x = cos(a) * r
		var z = sin(a) * r
		var h = 2.4 + float(i % 4) * 0.35
		_cyl(Vector3(x, h * 0.5, z), 0.16, h, Color(0.25, 0.16, 0.08))
		_cone(Vector3(x, h * 0.95, z), 0.95, h * 0.7, Color(0.12, 0.32, 0.14))

func _farm():
	_ground(Color(0.32, 0.38, 0.16))
	_box(Vector3(-6, 1.05, -3.2), Vector3(3.4, 2.1, 2.6), Color(0.42, 0.28, 0.18))
	_box(Vector3(-6, 2.3, -3.2), Vector3(3.8, 0.35, 3.0), Color(0.35, 0.14, 0.1))
	for i in range(10):
		var x = -8.0 + float(i % 5) * 1.3
		var z = 7.0 + float(i / 5) * 1.4
		_cyl(Vector3(x, 1.1, z), 0.14, 2.2, Color(0.25, 0.16, 0.08))
		_cone(Vector3(x, 2.2, z), 0.8, 1.6, Color(0.16, 0.34, 0.14))
	for i in range(9):
		_cyl(Vector3(-4.4 + float(i) * 1.1, 0.45, 3.2), 0.05, 0.9, Color(0.35, 0.22, 0.12))

func _beach():
	_ground(Color(0.78, 0.68, 0.42))
	for i in range(5):
		var mi = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		mesh.size = Vector3(90, 0.08, 4.2)
		mi.mesh = mesh
		var m = StandardMaterial3D.new()
		m.albedo_color = Color(0.16, 0.38, 0.62, 0.75)
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mi.material_override = m
		mi.position = Vector3(0, 0.06, -8.0 - float(i) * 2.2)
		add_child(mi)

func _town():
	_ground(Color(0.38, 0.32, 0.24))
	_shop(-5.5, -4.2, Color(0.42, 0.28, 0.18))
	_shop(-1.2, -4.6, Color(0.28, 0.22, 0.32))
	_shop(3.4, -4.0, Color(0.22, 0.32, 0.22))
	_shop(6.6, -1.2, Color(0.32, 0.2, 0.16))
	_cyl(Vector3(0, 0.25, 1.2), 0.55, 0.5, Color(0.45, 0.45, 0.48))

func _shop(x, z, color):
	_box(Vector3(x, 1.1, z), Vector3(3.0, 2.2, 2.4), color)
	_box(Vector3(x, 2.35, z), Vector3(3.4, 0.3, 2.8), Color(0.28, 0.12, 0.1))
