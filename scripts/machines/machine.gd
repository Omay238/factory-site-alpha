@tool
extends Node2D

@export var id: int

func _update_machine():
	var machine = GlobalResourceLoader.machines_dir[id]
	
	for i in $Nodes.get_children():
		$Nodes.remove_child(i)
	
	$Sprite2D.texture = machine.texture
	$ActiveMachine.set_script(machine.machine_script)
	
	for i in machine.nodes:
		var node = load("res://io_node.tscn").instantiate()
		node.type = i.type
		node.position = i.position
		$Nodes.add_child(node)

func _ready():
	_update_machine()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if $Sprite2D.get_rect().has_point(to_local(event.position)):
			queue_free()
