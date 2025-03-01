extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var d:Dictionary={"nameInfo":"测试"}
	var t=DaoXiu.new()
	ObjectUtils.copyBean(d,t)
	print(t.nameInfo)
	t.update()
	print(ObjectUtils.inst_2_dict(t))
	t.update()
	t=ObjectUtils.dict_2_inst(ObjectUtils.inst_2_dict(t))
	for i in 100:
		t.update()
	print(t.get_lv_str())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
