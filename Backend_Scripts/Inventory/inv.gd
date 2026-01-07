extends Resource

class_name inv

@export var slots: Array[invSlot] = []

signal update_UI

func insert(item: invItem, amnt: int):
	var itemSlots = slots.filter(func(slot): return slot.item == item) # item slots that contain the item just picked up
	if !itemSlots.is_empty(): # Item already exists in inventory
		itemSlots[0].amount += amnt
	else: # Item doesn't already exist in inventory
		var emptyslots = slots.filter(func(slot): return slot.item == null) # returns list of empty item slots
		if !emptyslots.is_empty(): # Checks that there are empty item slots
			emptyslots[0].item = item
			emptyslots[0].amount = amnt
	# update the UI
	update_UI.emit()
