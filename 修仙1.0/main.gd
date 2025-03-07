extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var d:Dictionary={"nameInfo":"玩家", "player_type":"PLAYER"}
	var t=DaoXiu.new()
	ObjectUtils.copyBean(d,t)
	t.progress_property["attack"]=Property.create(100,200,0,0,1,"攻击力",Property.PropertyType.RANDOM_RANGE)
	t.progress_property["hp"].current=9999
	GameGlobal.game_manager.current_player=t;
	#$"路径场景".game_manager=game_manager
	#$"路径场景".change_path()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_战斗场景_fight_over(is_win: bool) -> void:
	print("战斗完成")
	pass # Replace with function body.

func _on_button_pressed() -> void:
	#$"路径场景".change_path()
	#var d2:Dictionary={"nameInfo":"测试2","player_type":"AI"}
	#var t2=DaoXiu.new()
	#ObjectUtils.copyBean(d2,t2)
	#
	#var mp=MonsterPath.new()
	#mp.monster_group.append(t2)
	#mp.click_func(game_manager)
	pass # Replace with function body.
