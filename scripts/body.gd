extends Node
# Gives a person volume. Photo wraps the mesh. If a GLB later exists, replace the dummy.

static func make(ch):
	var root = Node3D.new()
	var gender = str(ch.get("gender", ""))
	var species = str(ch.get("species", "")).to_lower()
	var tall = 1.62
	if species.find("goliath") >= 0 or species.find("minotaur") >= 0 or species.find("bear") >= 0 or species.find("orc") >= 0 or species.find("dragon") >= 0:
		tall = 2.05
	elif species.find("gnome") >= 0 or species.find("halfling") >= 0 or species.find("goblin") >= 0:
		tall = 0.95
	elif species.find("dwarf") >= 0:
		tall = 1.15
	elif gender == "female":
		tall = 1.58
	var skin = Color(0.78, 0.62, 0.52)
	if gender == "female":
		skin = Color(0.86, 0.68, 0.62)
	if species.find("orc") >= 0 or species.find("goblin") >= 0:
		skin = Color(0.42, 0.58, 0.32)
	if species.find("elf") >= 0:
		skin = Color(0.72, 0.62, 0.88)
	if species.find("tiefling") >= 0:
		skin = Color(0.55, 0.22, 0.2)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = skin
	mat.roughness = 0.72
	# head
	var head = MeshInstance3D.new()
	var hs = SphereMesh.new()
	hs.radius = 0.13 * (tall / 1.6)
	hs.height = 0.26 * (tall / 1.6)
	head.mesh = hs
	head.material_override = mat
	head.position = Vector3(0, tall * 0.88, 0)
	head.name = "Head"
	root.add_child(head)
	# torso
	var torso = MeshInstance3D.new()
	var box = CapsuleMesh.new()
	box.radius = 0.16 if gender != "female" else 0.15
	box.height = tall * 0.42
	torso.mesh = box
	torso.material_override = mat.duplicate()
	torso.position = Vector3(0, tall * 0.58, 0)
	torso.name = "Torso"
	root.add_child(torso)
	# hips
	var hips = MeshInstance3D.new()
	var hp = SphereMesh.new()
	hp.radius = 0.17 if gender == "female" else 0.15
	hp.height = 0.28
	hips.mesh = hp
	hips.material_override = mat.duplicate()
	hips.position = Vector3(0, tall * 0.38, 0)
	root.add_child(hips)
	# legs
	var i = 0
	while i < 2:
		var leg = MeshInstance3D.new()
		var lm = CapsuleMesh.new()
		lm.radius = 0.055
		lm.height = tall * 0.38
		leg.mesh = lm
		leg.material_override = mat.duplicate()
		leg.position = Vector3(-0.07 + i * 0.14, tall * 0.2, 0)
		root.add_child(leg)
		i += 1
	# arms
	i = 0
	while i < 2:
		var arm = MeshInstance3D.new()
		var am = CapsuleMesh.new()
		am.radius = 0.04
		am.height = tall * 0.34
		arm.mesh = am
		arm.material_override = mat.duplicate()
		arm.rotation_degrees = Vector3(0, 0, -12 + i * 24)
		arm.position = Vector3(-0.22 + i * 0.44, tall * 0.62, 0)
		root.add_child(arm)
		i += 1
	# tail for anthro
	if species.find("fox") >= 0 or species.find("kitsune") >= 0 or species.find("wolf") >= 0 or species.find("cat") >= 0 or species.find("tabaxi") >= 0 or species.find("tiger") >= 0 or species.find("rabbit") >= 0:
		var tail = MeshInstance3D.new()
		var tm = CapsuleMesh.new()
		tm.radius = 0.045
		tm.height = tall * 0.55
		tail.mesh = tm
		var tmater = mat.duplicate()
		tmater.albedo_color = Color(0.92, 0.88, 0.82)
		tail.material_override = tmater
		tail.rotation_degrees = Vector3(55, 0, 18)
		tail.position = Vector3(0.02, tall * 0.36, -0.18)
		root.add_child(tail)
	# ears
	if species.find("elf") >= 0 or species.find("fox") >= 0 or species.find("kitsune") >= 0 or species.find("cat") >= 0 or species.find("tabaxi") >= 0:
		var e = 0
		while e < 2:
			var ear = MeshInstance3D.new()
			var em = PrismMesh.new()
			em.size = Vector3(0.06, 0.12, 0.03)
			ear.mesh = em
			ear.material_override = mat.duplicate()
			ear.position = Vector3(-0.07 + e * 0.14, tall * 0.98, 0)
			root.add_child(ear)
			e += 1
	# photo wrap on torso + head
	var wrap = Sprite3D.new()
	wrap.name = "Skin"
	wrap.pixel_size = 0.0026 * (tall / 1.6)
	wrap.billboard = 0
	wrap.position = Vector3(0, tall * 0.62, 0.17)
	root.add_child(wrap)
	var tag = Label3D.new()
	tag.text = str(ch.get("name", ""))
	tag.font_size = 22
	tag.position = Vector3(0, tall + 0.18, 0)
	tag.billboard = 1
	root.add_child(tag)
	return root

static func paint(root, tex):
	if root == null or tex == null:
		return
	var skin = root.get_node_or_null("Skin")
	if skin:
		skin.texture = tex
	var torso = root.get_node_or_null("Torso")
	if torso and torso.material_override:
		var m = torso.material_override.duplicate()
		m.albedo_texture = tex
		m.albedo_color = Color(1, 1, 1)
		torso.material_override = m
	var head = root.get_node_or_null("Head")
	if head and head.material_override:
		var hm = head.material_override.duplicate()
		hm.albedo_texture = tex
		hm.albedo_color = Color(1, 1, 1)
		head.material_override = hm
