extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var imgTextureName = "res://assets/allSprites_default.png" 
	var itex = load(imgTextureName)
	var file = File.new()
	file.open("res://allSprites_default.json", File.READ)
	var json_str = file.get_as_text()
	var p = JSON.parse(json_str)

	for e in p.result.TextureAtlas.SubTexture:
		var subPath = ""
		var region = Rect2(e._x, e._y, e._width, e._height)
		
		var my_sprite = Sprite.new()
		my_sprite.texture = itex
		my_sprite.region_rect = region
		my_sprite.region_enabled = true
		my_sprite.rotate(my_sprite.transform.get_rotation()-PI/2)
		
		var name = e._name.rsplit(".", true, 1)[0]
		
		var regexOo = RegEx.new()
		regexOo.compile("^(barrel|barricade|crate|fence|oilSpill|sandbag|tree|wire|tracks).*")
		
		var tmpNames = e._name.split("_", true, 2)

		if regexOo.search(e._name):
			my_sprite.name = "object"
			subPath = "otherObjects"
		elif tmpNames[0].begins_with("tank") && tmpNames[1].begins_with("barrel"):
			my_sprite.name = "turret"
			subPath = "turret"
			print(tmpNames[-1])
			if tmpNames[-1] == "outline.png" :
				my_sprite.set_offset(Vector2(0,int(e._height)-20))
			else:
				my_sprite.set_offset(Vector2(0,int(e._height)-17))
			#if tmpNames[-1] != "outline.png" :
			var position = Position2D.new()
			position.name = "Muzzle"
			position.set_position(Vector2(0,int(e._height)))
			position.rotate(position.transform.get_rotation()-PI/2)
			my_sprite.add_child(position)
			position.set_owner(my_sprite)
		elif e._name.begins_with("bullet"):
			my_sprite.rotate(my_sprite.transform.get_rotation()+PI)
			my_sprite.name = "bullet"
			subPath = "bullet"
		elif e._name.begins_with("explosion") || e._name.begins_with("shot"):
			my_sprite.name = "explosion"
			subPath = "explosion"
		elif e._name.begins_with("tankBody"):
			my_sprite.name = "tankBody"
			subPath = "tankBody" 
			#var collision_body = CollisionShape2D.new()
			#var rect_shape = RectangleShape2D.new()
			#rect_shape.set_extents(Vector2(e._height,e._width))
			#collision_body.set_shape(rect_shape)
			#my_sprite.add_child(collision_body)
			#collision_body.set_owner(my_sprite)
		elif e._name.begins_with("tank") && !tmpNames[1].begins_with("barrel"):
			my_sprite.name = "fixedTurretTank"
			subPath = "fixedTurretTank"
		else:
			 subPath = "misc"
		
		var dir = Directory.new()
		var err = dir.make_dir_recursive("res://scenes/"+subPath)
		
		
		var packed_scene = PackedScene.new()
		packed_scene.pack(my_sprite)

		ResourceSaver.save("res://scenes/"+subPath+"/"+name+".tscn", packed_scene)

		
		
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
