@tool
extends Node2D

@export var id: int

func _update_machine():
	var machine = GlobalResourceLoader.machines_dir[id]
	
	for i in $Nodes.get_children():
		$Nodes.remove_child(i)
	
	$Sprite2D.texture = machine.texture
	$MachineScript.set_script(machine.machine_script)
	
	for i in machine.nodes:
		var node = load("res://io_node.tscn").instantiate()
		node.type = i.type
		node.position = i.position
		$Nodes.add_child(node)

func _ready():
	_update_machine()
