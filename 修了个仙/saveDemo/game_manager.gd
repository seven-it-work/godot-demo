# game_manager.gd
class_name GameManager
extends RefCounted

var player:Player
var path_choices: Array = []

func save_game(file_path: String) -> void:
	var save_data = {
		"player": player.to_dict(),
		"path_choices": []
	}
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file.file_exists(file_path):
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved successfully.")
	else:
		push_error("Failed to open file for saving.")

func load_game(file_path: String) -> bool:
	if not FileAccess.file_exists(file_path):
		return false
	var file =FileAccess.open(file_path, FileAccess.READ)
	var json_str = file.get_as_text()
	file.close()
	var save_data = JSON.parse_string(json_str)
	if not save_data:
		return false
	
	player = Player.from_dict(save_data["player"])
	path_choices.clear()
	for pc_dict in save_data["path_choices"]:
		var pc = PathChoice.from_dict(pc_dict)
		path_choices.append(pc)
	print("Game loaded successfully.")
	return true
