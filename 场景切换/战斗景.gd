extends Node2D
var palyer_obj={}
var monster_obj={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text="攻击者:"+palyer_obj.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
