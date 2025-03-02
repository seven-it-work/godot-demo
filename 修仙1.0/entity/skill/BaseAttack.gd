extends BaseSkill
class_name BaseAttack

func _ready() -> void:
	self.nameInfo="普通攻击"
	
func get_desc(user:BasePeople,team:Array,enemy:Array)->String:
	return "对随机一个敌人造成你当前攻击力的伤害"

func do_use_skill(user:BasePeople,team:Array,enemy:Array):
#	这里执行技能逻辑
	var target=enemy[randi()%enemy.size()]
	var damage=(user.progress_property.get("attack") as Property).get_value()
	target.change_hp(-damage)
	print("{name}对{target}造成{num}点伤害".format({"name":user.nameInfo,"target":target.nameInfo,"num":damage}))
