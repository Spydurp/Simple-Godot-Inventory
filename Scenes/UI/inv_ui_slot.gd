extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_Texture
@onready var amount_text: Label = $Amount
@onready var background : Sprite2D = $Background
@export var inv_slot : invSlot

const slot_size = 60

var mouse_hover : bool = false

signal inv_interact(slot : invSlot)
signal inv_interact_right(slot : invSlot)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory_Item_Interact") and mouse_hover:
		inv_interact.emit(inv_slot)
	elif Input.is_action_just_pressed("Inventory_Item_Right_Click") and mouse_hover:
		inv_interact_right.emit(inv_slot)

func update(slot: invSlot):
	inv_slot = slot
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		item_visual.scale = Vector2(60/item_visual.texture.get_size().x, 60/item_visual.texture.get_size().y)
		if slot.amount > 1:
			amount_text.visible = true
		else:
			amount_text.visible = false
		amount_text.text = str(slot.amount)



func _on_mouse_entered() -> void:
	mouse_hover = true


func _on_mouse_exited() -> void:
	mouse_hover = false
