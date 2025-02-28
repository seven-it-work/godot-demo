extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t=DaoXiu.new()
	for i in 100:
		t.update()
	print(t.get_lv_str())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
