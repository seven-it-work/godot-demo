extends BaseAiAction
class_name SmailAiAction

func do_ai_action(user:BasePeople,team:Array,enemy:Array):
	var skill=[]
	if user.skill_1 && user.skill_1.can_use_skilk(user,team,enemy):
		skill.append(user.skill_1)
	if user.skill_2 && user.skill_2.can_use_skilk(user,team,enemy):
		skill.append(user.skill_2)
	if user.skill_3 && user.skill_3.can_use_skilk(user,team,enemy):
		skill.append(user.skill_3)
	if user.skill_4 && user.skill_4.can_use_skilk(user,team,enemy):
		skill.append(user.skill_4)
	if skill.is_empty():
		print("没有技能可以使用")
	else:
		var skill_use=skill.pick_random() as BaseSkill
		print("我是简单ai,我随机使用技能:%s"%skill_use.nameInfo)
		skill_use.use_skill(user,team,enemy)
