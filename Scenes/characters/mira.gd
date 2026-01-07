extends CharacterBody2D

@export var max_speed: int = 500
@export var inventory: inv
var speed: int = max_speed

func _ready() -> void:
	create_inv()

func _process(_delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()

# Temp function. Creates new inventory for mira for testing
# TODO: Replace this function with one that loads exisiting inventories or 
# creates new inventories if an existing one can't be found, for all objects with
# inventories.
func create_inv():
	inventory = inv.new()
	# fill new inventory object with 32 slots
	for i in range(32):
		inventory.slots.append(invSlot.new())
