extends Node2D

const path_node_tscn="res://场景/路径场景/path_node.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameGlobal.game_manager && GameGlobal.game_manager.current_map:
		change_path(GameGlobal.game_manager.current_map.change_path())
#	这里为debug展示
	if GameGlobal.is_debug:
		var l=Label.new()
		l.text=GameGlobal.game_manager.current_map.nameInfo
		$Debug/VBoxContainer.add_child(l)
		var l2=Label.new()
		l2.text="当前的长度:%s"%GameGlobal.game_manager.current_map.current_path_step
		$Debug/VBoxContainer.add_child(l2)
		$Debug.show()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choice_path(path:BasePath):
	path.click_func()

func change_path(pathList:Array):
	#	删除已有节点
	for i in $ScrollContainer/HBoxContainer.get_children():
		i.free()
	#	更新节点信息
	for i in pathList:
		var path_node = preload(path_node_tscn).instantiate()
		path_node.find_child("Button").pressed.connect(choice_path.bind(i))
		path_node.find_child("desc").text=i.desc
		path_node.find_child("title").text=i.nameInfo
		$ScrollContainer/HBoxContainer.add_child(path_node)
