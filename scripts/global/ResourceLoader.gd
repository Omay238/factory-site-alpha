@tool
extends Node

var machines_dir: Array[Machine] = []
var items_dir = []

func load_machines() -> Array[Machine]:
	var machines: Array[Machine] = []
	var dir := DirAccess.open("res://machines")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var machine = load("res://machines/" + file)
		machines.append(machine)
		file = dir.get_next()
	dir.list_dir_end()
	machines.sort_custom(func(a, b): return a.id < b.id)
	return machines

func load_items() -> Array:
	var items := []
	var dir := DirAccess.open("res://items")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var item = load("res://items/" + file)
		items.append(item)
		file = dir.get_next()
	dir.list_dir_end()
	items.sort_custom(func(a, b): return a.id < b.id)
	return items

func _ready():
	machines_dir = load_machines()
	items_dir = load_items()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		machines_dir = load_machines()
