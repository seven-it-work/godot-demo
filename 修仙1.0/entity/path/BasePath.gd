extends Node
class_name BasePath
#路径名称
var nameInfo:String=""
#描述
var desc:String=""
#路线类型： monster （怪物）、adventure （奇遇）、tavern （客栈）、 store （商店）
var path_type:String=""

#点击选择路线
func click_func():
	pass

static func generate_by_excel_id(id:int)->BasePath:
	var dic=Settings.路径.data[id]
	var path:BasePath=ObjectUtils.dict_2_inst({"@path":"res://entity/path/"+dic["类型"]+".gd"})
	path._init()
	path.nameInfo=dic["名称"]
	path.desc=dic["名称"]
	if dic["生成野兽字段"]:
		path.random_g_monster=dic["生成野兽字段"]
	if dic["必定生成的野兽"]:
		path.must_g_monster=dic["必定生成的野兽"]
	if dic["最少生产怪物数量"]:
		path.g_min=dic["最少生产怪物数量"]
	if dic["最多生产怪物数量"]:
		path.g_max=dic["最多生产怪物数量"]
	return path
