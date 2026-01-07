extends Node2D
class_name world_item

@export var item: invItem
@export var amount: int
var player: CharacterBody2D = null
var player_in_area: bool = false

func _ready() -> void:
	if item != null:
		$Texture.texture = item.texture
		if item.texture == null:
			push_warning("Warning: Item " + item.name + " has no texture.")

func _process(_delta):
	if Input.is_action_just_pressed("Pickup_Item") and player_in_area:
		player.inventory.insert(item, amount)
		await get_tree().create_timer(0.1).timeout
		self.queue_free()


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = true
		player = body


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = false
		player = null
