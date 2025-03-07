extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m1=BaseMap.generate_by_excel_id(1)
	var b=Button.new()
	b.text=m1.nameInfo;
	b.position=m1.get_position_data()
	b.pressed.connect(enter_map.bind(m1))
	add_child(b)
	pass

func enter_map(m:BaseMap):
	if GameGlobal.game_manager:
		GameGlobal.game_manager.current_map=m
		SceneManager.change_scene('res://场景/路径场景/路径场景.tscn')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
