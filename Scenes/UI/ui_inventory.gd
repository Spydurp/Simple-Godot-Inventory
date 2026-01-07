extends Control
class_name ui_inventory
@export var inventory: inv

@onready var ui_Slots = $MarginContainer/Section_Margin/VBoxContainer/Grid_Margin/GridContainer.get_children()
const slot_size = 60

var is_open: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect_inventory()
	#inventory.update_UI.connect(update_slots)
	close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_check_open_action()

func _check_open_action():
	pass

func open():
	visible = true
	is_open = true
# TODO: make it so that when there's an item in the buffer when the inventory is closed, its dropped
# on the ground
func close():
	visible = false
	is_open = false
	# If there is an item sitting in the buffer while closing, drop it on the ground

# TODO Allow for an individual slot to be updated instead of updating every slot every time
func update_slots():
	for i in range(min(inventory.slots.size(), ui_Slots.size())):
		ui_Slots[i].update(inventory.slots[i]) # Update the visual of each UI slot

func on_inv_interact(s : invSlot):
	if s.item != null and Inventory.pickup_buffer == null and Inventory.pickup_buffer_num == 0:
		# pick up item from slot
		Inventory.pickup_buffer = s.item
		Inventory.pickup_buffer_num = s.amount
		s.item = null
		s.amount = 0
		update_slots()
	elif s.item == null and Inventory.pickup_buffer != null and Inventory.pickup_buffer_num != 0:
		# put item in empty slot
		s.item = Inventory.pickup_buffer
		s.amount = Inventory.pickup_buffer_num
		Inventory.pickup_buffer = null
		Inventory.pickup_buffer_num = 0
		update_slots()
	elif s.item != null and Inventory.pickup_buffer != null and Inventory.pickup_buffer_num != 0:
		# put item in occupied slot. 
		if s.item == Inventory.pickup_buffer:
			# merge item amounts
			s.amount += Inventory.pickup_buffer_num
			Inventory.clear_pickup_buffer()
		else:
			#Swap item in slot with item in buffer
			var temp : invItem = s.item
			var temp_amnt : int = s.amount
			s.item = Inventory.pickup_buffer
			s.amount = Inventory.pickup_buffer_num
			Inventory.pickup_buffer = temp
			Inventory.pickup_buffer_num = temp_amnt
		update_slots()
		

func on_inv_right_click(s : invSlot):
	if s.item != null and Inventory.pickup_buffer == null and Inventory.pickup_buffer_num == 0:
		# pick up half of the items from slot
		Inventory.pickup_item(s.item, ceil(s.amount/2.0))
		s.amount = floor(s.amount/2)
		if s.amount == 0:
			s.item = null
		update_slots()
	elif Inventory.pickup_buffer != null: # deposit one into slot
		if s.item == Inventory.pickup_buffer or s.item == null:
			s.item = Inventory.pickup_buffer
			s.amount += 1
			Inventory.deduct_pickup_buffer(1)
			update_slots()

func connect_inventory(): # Connects the backend inventory slots to each slot in the UI component
	# Check if there is an inventory attached
	if inventory == null:
		push_error("Error: Backend inventory object is not connected to UI inventory")
	# Check if there are an equal number of ui slots as there are in the inventory
	if ui_Slots.size() != inventory.slots.size():
		push_warning("Error: Backend inventory size and number of UI inventory slots do not match")
	# Loop through inventory and connect backend slots to UI
	for i in range(min(inventory.slots.size(), ui_Slots.size())):
		ui_Slots[i].inv_slot = inventory.slots[i]
		ui_Slots[i].inv_interact.connect(on_inv_interact)
		ui_Slots[i].inv_interact_right.connect(on_inv_right_click)



func _on_margin_container_mouse_entered() -> void:
	Inventory.mouse_in_Inv = true
	


func _on_margin_container_mouse_exited() -> void:
	Inventory.mouse_in_Inv = false
