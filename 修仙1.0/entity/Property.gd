@tool
class_name Property
extends Node

enum PropertyType {
#	进度条，有最大 最小 当前值
   PROGRESS_BAR,
#	范围值，最小，最大 在这个范围随机生成
   RANDOM_RANGE,
#	精确值 current
   NUM,
};

@export var min:float=0;
@export var max:float=0;
@export var current:float=0;
@export var upMin:float=0;
@export var upMax:float=0;
@export var nameInfo:String=""
@export var propertyType:PropertyType=PropertyType.NUM

func _to_string() -> String:
	return JSON.stringify(inst_to_dict(self))

func get_value()->float:
	if self.propertyType==PropertyType.PROGRESS_BAR:
		return current;
	elif self.propertyType==PropertyType.RANDOM_RANGE:
		return randf_range(min,max);
	elif self.propertyType==PropertyType.NUM:
		return current
	print("暂时不支持该型")
	return 0

func doUp():
	if self.propertyType==PropertyType.PROGRESS_BAR:
		var up=randf_range(upMin,upMax)
		self.current+=up
		self.max+=up
	elif self.propertyType==PropertyType.RANDOM_RANGE:
		var tempMin=min+randf_range(upMin,upMax)
		var tempMax=max+randf_range(upMin,upMax)
		if tempMin>tempMax:
			min=tempMax
			max=tempMin
		else:
			max=tempMax
			min=tempMin
	elif self.propertyType==PropertyType.NUM:
		var up=randf_range(upMin,upMax)
		self.current+=up

static func create(
	min:float,
	max:float,
	current:float,
	upMin:float,
	upMax:float,
	nameInfo:String,
	propertyType:PropertyType,
)->Property:
	var re=Property.new()
	re.min=min
	re.max=max
	re.current=current
	re.upMin=upMin
	re.upMax=upMax
	re.nameInfo=nameInfo
	re.propertyType=propertyType
	return re;
