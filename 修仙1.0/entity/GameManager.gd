extends RefCounted
class_name GameManager

var current_map:BaseMap

var current_player:BasePeople

var player_group:Array=[]

func get_player_group()->Array:
	var re=[current_player]
	re.append_array(player_group)
	return re;
