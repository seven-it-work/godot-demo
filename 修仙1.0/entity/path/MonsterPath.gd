extends BasePath
class_name MonsterPath

var monster_group:Array=[]

# 随机生成怪兽（怪物id:权重）
var random_g_monster={}
# 必定生成的野兽（怪物id:数量）
var must_g_monster={}
var g_min:int=0;
var g_max:int=1;


func _init() -> void:
	path_type="monster"

func g_monster():
	if !must_g_monster.is_empty():
		for key in must_g_monster:
			for i in must_g_monster[key]:
				monster_group.append(BasePeople.generate_by_excel_id(key))
	var count=randi_range(g_min,g_max)-monster_group.size()
	if count>0:
		for key in ObjectUtils.weight_selector(random_g_monster,count):
			monster_group.append(BasePeople.generate_by_excel_id(key))

func click_func():
	self.g_monster()
#	改变场景，进入战斗
	await SceneManager.change_scene('res://场景/战斗场景/战斗场景.tscn', {
	  "on_tree_enter": func(s): on_tree_enter(s)
	})

func on_tree_enter(scene):
	scene.init_data(GameGlobal.game_manager.get_player_group(),monster_group)
	scene.fight_over.connect(fight_over.bind())
	
func fight_over(is_win):
	print("战斗结束了")
#	todo 后续弄一个战斗结算场景
	SceneManager.change_scene('res://场景/路径场景/路径场景.tscn')
