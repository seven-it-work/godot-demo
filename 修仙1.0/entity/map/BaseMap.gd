extends Node
class_name BaseMap
# 是否能退出信号
signal can_out
var nameInfo:String
# 已经走过的路径长度
var current_path_step:int=0
# 最大的路径长度（当到达最大路径长度时，则可以退出当前地图）
var max_path_step:int=10
# 当达到对应index的路径时，将会出现的路径{0:"BasePathId-BasePathId"}多个路径 通过-分割
var index_path:Dictionary={}
# 路径id:权重
var base_random:Dictionary={}
# 最多的路径节点
var max_path_size:int=5
var position_x:int=-1;
var position_y:int=-1;

func get_position_data()->Vector2:
	var v=Vector2()
	if position_x==-1:
		v.x=randf_range(0,DisplayServer.window_get_size().x)
	else:
		v.x=position_x
	if position_y==-1:
		v.y=randf_range(0,DisplayServer.window_get_size().y)
	else:
		v.y=position_y
	return v;
	
static func generate_by_excel_id(id:int)->BaseMap:
	var dic=Settings.地点.data[id]
	var map=BaseMap.new()
	map.nameInfo=dic["名称"]
	map.max_path_step=dic["最大的路径长度"]
	map.max_path_size=dic["最多路径节点个数"]
	if dic["固定路径"]:
		map.index_path=dic["固定路径"]
	if dic["随机路径"]:
		map.base_random=dic["随机路径"]
	return map

func random_path(size:int=1):
	var re=[]
	for key in ObjectUtils.weight_selector(base_random,size):
		re.append(BasePath.generate_by_excel_id(key))
	return re

func change_path(is_back:bool=false):
	var re=[]
	if is_back:
		if GameGlobal.is_debug:
			print("后退")
		if re.size()<max_path_size:
			re.append_array(random_path(max_path_size-re.size()))
		current_path_step-=1
	else:
		if index_path.has(current_path_step):
			if GameGlobal.is_debug:
				print("加载固定节点")
			for id in index_path.get(current_path_step).split("-"):
				if typeof(id)==TYPE_STRING:
					id=type_convert(id, TYPE_INT)
				re.append(BasePath.generate_by_excel_id(id))
		if re.size()<max_path_size:
			re.append_array(random_path(max_path_size-re.size()))
		current_path_step+=1;
	if current_path_step==0 || current_path_step==max_path_step:
		current_path_step=0
		if GameGlobal.is_debug:
			print("可以离开了")
		can_out.emit()
	return re
