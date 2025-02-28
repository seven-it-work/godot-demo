#成长系数
@tool
class_name  UpFactor

@export var min:int=0
@export var max:int=1

func get_up_value()->int:
	return randi_range(min,max)

static func upFactor(min:int,max:int)->UpFactor:
	var temp=UpFactor.new()
	temp.min=min;
	temp.max=max;
	return temp
