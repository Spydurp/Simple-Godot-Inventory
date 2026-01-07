extends Node2D

@onready var inv_UI = $UI_elements/Inventory_Layer/UI_player_inventory
@onready var mira = $Mira
@onready var dropped_items = $Items
@onready var world_item_scene : PackedScene = preload("res://Scenes/objects/items/world_item.tscn")
@onready var Dragged_Item : PanelContainer = $UI_elements/Dragged_Item_Layer/Dragged_Item
@onready var Dragged_Item_Texture : Sprite2D = $UI_elements/Dragged_Item_Layer/Dragged_Item/Dragged_Item_Texture
@onready var Dragged_Item_Amount : Label = $UI_elements/Dragged_Item_Layer/Dragged_Item/Dragged_Item_Amount

var slot_size = 60

func _ready() -> void:
	inv_UI.inventory = mira.inventory
	inv_UI.connect_inventory()
	inv_UI.inventory.update_UI.connect(inv_UI.update_slots)
	inv_UI.drop_item.connect(create_dropped_item)

func _process(delta: float) -> void:
	if Inventory.pickup_buffer != null:
		Dragged_Item_Texture.scale = Vector2(slot_size/Inventory.pickup_buffer.texture.get_size().x, slot_size/Inventory.pickup_buffer.texture.get_size().y)
		Dragged_Item_Amount.text = str(Inventory.pickup_buffer_num)
		if Inventory.pickup_buffer_num > 1:
			Dragged_Item_Amount.visible = true
		else:
			Dragged_Item_Amount.visible = false
		Dragged_Item_Texture.texture = Inventory.pickup_buffer.texture
		Dragged_Item.visible = true
		Dragged_Item.position = get_global_mouse_position()
	else:
		Dragged_Item.visible = false

func create_dropped_item():
	var item : world_item = world_item_scene.instantiate()
	item.item = Inventory.pickup_buffer
	item.amount = Inventory.pickup_buffer_num
	item.position = get_global_mouse_position()
	Inventory.clear_pickup_buffer()
	dropped_items.add_child(item)
