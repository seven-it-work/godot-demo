extends BaseSkill
class_name BaseDefense

func _init() -> void:
	self.nameInfo="普通防御"
	
func get_desc()->String:
	return "对自己施加对应防御力的护盾"

func do_use_skill(user:BasePeople,team:Array,enemy:Array):
#	这里执行技能逻辑
	var def=user.progress_property.get("defense") as Property
	user.progress_property.get("shield").current+=def.get_value()
