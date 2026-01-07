extends Node

var pickup_buffer : invItem
var pickup_buffer_num: int
var mouse_in_Inv : bool = false

func clear_pickup_buffer() -> void:
	pickup_buffer = null
	pickup_buffer_num = 0

func deduct_pickup_buffer(amnt : int) -> void:
	if pickup_buffer_num > 0:
		if amnt > pickup_buffer_num:
			push_error("Error: Amount deducted from buffer greater than amount in buffer")
		else:
			pickup_buffer_num -= amnt
			if pickup_buffer_num == 0:
				pickup_buffer = null
	else:
		push_warning("Warning: Pickup buffer empty, cannot further decrement amount")

func pickup_item(i: invItem, amnt: int) -> void:
	if pickup_buffer != null:
		push_warning("Warning: Pickup buffer is not empty. Did not complete pickup operation")
	else:
		pickup_buffer = i
		pickup_buffer_num = amnt
