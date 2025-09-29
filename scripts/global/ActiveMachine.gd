class_name ActiveMachine
extends Node

var inventory: Array[CostItem]
var interval: int

func _recieve_item():
	pass

func _send_item():
	pass

func _tick():
	pass

func start():
	var timer = Timer.new()
	add_child(timer)
	timer.start(interval)
	timer.timeout.connect(_tick)
