@tool
extends Node2D

var node: String
@export var sprite: Sprite2D
@export var line_el: Line2D

var prev_dir := 0

signal send_item(item: CostItem)

var line: PackedVector2Array

@export_enum("Input:0", "Output:1") var type: int:
	set(value):
		type = value
		_update_texture()

var is_searching = false
var is_last_searching = false
var is_node_connected = false
var partner_node: Node2D

func _ready() -> void:
	var f := FileAccess.open("res://assets/node.svg", FileAccess.READ)
	if f:
		node = f.get_as_text()
		
		if type == 0:
			node = node.replace("gray", "black")
		else:
			node = node.replace("gray", "white")
		
		f.close()
	_update_texture()
	NodeSignal.begin_search.connect(_on_begin_search)
	NodeSignal.cancel_search.connect(_on_cancel_search)
	NodeSignal.successful_search.connect(_on_successful_search)

func _update_texture(sc: int = 16) -> void:
	if not sprite:
		return
	
	if len(node) > 0:
		var img = Image.new()
		
		img.load_svg_from_string(node, sc)
		
		sprite.texture = ImageTexture.create_from_image(img)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sprite.get_rect().has_point(to_local(event.position)):
			is_searching = true
			NodeSignal.begin_search.emit(type)
		elif is_searching:
			NodeSignal.cancel_search.emit(send_item, tree_exiting)
	if event is InputEventMouseMotion:
		if sprite.get_rect().has_point(to_local(event.position)):
			_update_texture(18)
		else:
			_update_texture()

func _process(_delta: float) -> void:
	#line_el.clear_points()
	if is_node_connected:
		line = PackedVector2Array()
		line.append(Vector2.ZERO)
		var mouse = to_local(partner_node.global_position)
		var mousea = mouse.abs()
		
		if mousea.x < 15 and mousea.y > 15:
			prev_dir = 1
		elif mousea.y < 15 and mousea.x > 15:
			prev_dir = 0
		
		if prev_dir == 0:
			line.append(Vector2(mouse.x * 0.5, 0))
			line.append(Vector2(mouse.x * 0.5, mouse.y))
		elif prev_dir == 1:
			line.append(Vector2(0, mouse.y * 0.5))
			line.append(Vector2(mouse.x, mouse.y * 0.5))
		
		line.append(mouse)
		line_el.points = line
	if is_searching:
		line = PackedVector2Array()
		line.append(Vector2.ZERO)
		var mouse = get_local_mouse_position()
		var mousea = mouse.abs()
		
		if mousea.x < 15 and mousea.y > 15:
			prev_dir = 1
		elif mousea.y < 15 and mousea.x > 15:
			prev_dir = 0
		
		if prev_dir == 0:
			line.append(Vector2(mouse.x * 0.5, 0))
			line.append(Vector2(mouse.x * 0.5, mouse.y))
		elif prev_dir == 1:
			line.append(Vector2(0, mouse.y * 0.5))
			line.append(Vector2(mouse.x, mouse.y * 0.5))
		
		line.append(mouse)
		line_el.points = line

func _on_begin_search(t: int):
	print('begin, ' + str(is_searching))
	if t == type and not is_searching:
		sprite.modulate.a = 0.5
	is_last_searching = false

func _on_cancel_search(signal_send: Signal, signal_remove: Signal):
	print('cancel')
	if sprite.get_rect().has_point(get_local_mouse_position()) and sprite.modulate.a == 1:
		NodeSignal.successful_search.emit(self)
		signal_send.connect(Callable($"../../ActiveMachine", "_recieve_item"))
		signal_remove.connect(Callable(line_el, "clear_points"))
	sprite.modulate.a = 1
	is_searching = false
	is_last_searching = true

func _on_successful_search(other: Node2D):
	print('success')
	if other.get_parent() == get_parent():
		return
	if is_searching and type == 0:
		send_item.connect(other._recieve_item)
		is_node_connected = true
		partner_node = other
	elif is_searching and type == 1:
		other.send_item.connect(_recieve_item)
		is_node_connected = true

func _recieve_item(item: CostItem):
	pass
