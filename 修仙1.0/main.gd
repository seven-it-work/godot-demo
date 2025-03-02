extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var d:Dictionary={"nameInfo":"测试"}
	var t=DaoXiu.new()
	ObjectUtils.copyBean(d,t)
	
	
	var d2:Dictionary={"nameInfo":"测试2"}
	var t2=DaoXiu.new()
	ObjectUtils.copyBean(d2,t2)
	
	print(t2.progress_property)
	
	t.skill_1.use_skill(t,[t],[t2])
	print(t2.progress_property)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
