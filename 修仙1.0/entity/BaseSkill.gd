extends Node
class_name BaseSkill


var nameInfo:String=""

func get_desc()->String:
	return ""

func can_use_skilk(user:BasePeople,team:Array,enemy:Array)->bool:
#	判断是否能使用技能
	return true

func use_skill_before(user:BasePeople,team:Array,enemy:Array):
#	这里技能执行之前
#   扣除消耗(比如扣除真元等)
	pass

func do_use_skill(user:BasePeople,team:Array,enemy:Array):
#	这里执行技能逻辑
	pass

func use_skill_after(user:BasePeople,team:Array,enemy:Array):
#	这里技能执行完成
	pass


# 不建议重载这法
func use_skill(user:BasePeople,team:Array,enemy:Array):
	self.use_skill_before(user,team,enemy)
	self.do_use_skill(user,team,enemy)
	self.use_skill_after(user,team,enemy)
	pass
