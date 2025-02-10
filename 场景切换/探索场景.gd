extends Node2D

var palyer_obj={"name":"123"}
var monster_obj={"name":"怪物"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
#	这里假设碰撞到了 敌人
	print("开始战斗")
	var battle_scene=preload("res://场景切换/战斗景.tscn").instantiate()
	battle_scene.palyer_obj=palyer_obj
	battle_scene.monster_obj=monster_obj
	get_tree().root.add_child(battle_scene)
	get_tree().current_scene=battle_scene
	queue_free()
	
