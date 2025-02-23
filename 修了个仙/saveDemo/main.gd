extends Node2D

var game_manager=GameManager.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_save_file()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	$Control/Label.text=game_manager.player.name
	pass

func find_files_with_name(directory_path: String, pattern: String) -> Array:
	var file_list = []
	var dir = DirAccess.open(directory_path)
	if dir:
		for f in dir.get_files():
			if f.begins_with("savegame"):
				file_list.append(f) 
	else:
		print("尝试访问路径时出错。")
	return file_list

func load_save_file():
	var save_files=find_files_with_name("user://","savegame")
	for file in save_files:
		var l=Label.new()
		l.text=file.get_file()
		$Control/GridContainer.add_child(l)
	pass

func _on_save_button_pressed() -> void:
	# 保存游戏
	game_manager.save_game("user://savegame.json")


func _on_load_button_pressed() -> void:	
	# 加载游戏
	if game_manager.load_game("user://savegame.json"):
		print("Game loaded successfully.")
		start_game();
	else:
		print("Failed to load game.")


func _on_new_game_button_pressed() -> void:
	var player = Player.new()
	player.name = "PlayerOne2"
	player.equipment.append("Sword")
	player.skills = {"Fireball": 5}
	player.attributes = {"Health": 100, "Mana": 50}
	
	var path_choice = PathChoice.new()
	path_choice.monsters.append("Goblin")
	path_choice.rewards = {"Gold": 100}
	
	game_manager.player = player
	game_manager.path_choices.append(path_choice)
	start_game();
