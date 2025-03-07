extends BaseSkill
class_name BaseAttack

func _init() -> void:
	self.nameInfo="普通攻击"
	
func get_desc()->String:
	return "对随机一个敌人造成你当前攻击力的伤害"

func do_use_skill(user:BasePeople,team:Array,enemy:Array):
#	这里执行技能逻辑
	var target:BasePeople=enemy[randi()%enemy.size()]
	var damage=(user.progress_property.get("attack") as Property).get_value()
	target.change_hp(-damage)
	if GameGlobal.is_debug:
		print("{name}对{target}造成{num}点伤害.{target}还剩余{hp}生命值".format(
			{"name":user.nameInfo,"target":target.nameInfo,"num":damage,"hp":target.progress_property["hp"].get_value()}
		))
