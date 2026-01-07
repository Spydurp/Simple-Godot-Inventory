extends Node2D
class_name container

@export var inventory: inv
@onready var container_UI_scene : PackedScene = preload("res://Scenes/UI/ui_container_inventory.tscn")
var container_UI : ui_container_inventory

var player: CharacterBody2D = null
var player_in_area: bool = false

func _ready() -> void:
	create_inv()
	container_UI = container_UI_scene.instantiate()
	container_UI.inventory = inventory
	$".".add_child(container_UI)
	container_UI.connect_inventory()
	inventory.update_UI.connect(container_UI.update_slots)
	container_UI.update_slots()
	container_UI.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and player_in_area:
		if container_UI.is_open:
			container_UI.close()
		else:
			container_UI.open()

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		player_in_area = true


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
		player_in_area = false
		container_UI.close()

# Temp function. Creates new inventory for chest for testing
# TODO: Replace this function with one that loads existing inventories or 
# creates new inventories if an existing one can't be found, for all objects with
# inventories.
func create_inv():
	inventory = inv.new()
	# fill new inventory object with 32 slots
	for i in range(32):
		inventory.slots.append(invSlot.new())
