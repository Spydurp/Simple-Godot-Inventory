extends ui_inventory

signal drop_item

func _process(_delta: float) -> void:
	super._process(_delta)
	if Input.is_action_just_pressed("Inventory_Item_Interact") and Inventory.mouse_in_Inv == false and Inventory.pickup_buffer != null:
		print("Drop Item")
		drop_item.emit()
	

func _check_open_action():
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()
	
	
