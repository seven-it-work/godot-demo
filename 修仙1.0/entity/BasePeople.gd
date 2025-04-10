class_name BasePeople
extends Node


var 境界=[]
#没级升级需要的经验值（比如1级需要10点经验，2级需要20点）
var base_up_need_exp=10
#姓名
var nameInfo:String
# 进度条属性
var progress_property:Dictionary={
	"hp":
		Property.create(0,100,100,0,1,"生命值",Property.PropertyType.PROGRESS_BAR),
	"mp":
		Property.create(0,100,100,0,1,"真元值",Property.PropertyType.PROGRESS_BAR),
	"shield":
		Property.create(0,100,0,0,1,"护盾值",Property.PropertyType.NUM),
	"attack":
		Property.create(1,10,0,0,1,"攻击力",Property.PropertyType.RANDOM_RANGE),
	"defense":
		Property.create(1,5,0,0,1,"防御力",Property.PropertyType.RANDOM_RANGE),
	"gathering":
		Property.create(1,5,0,0,1,"集气速度",Property.PropertyType.RANDOM_RANGE),
}
#当前等级
var lv:int=0
#当前经验值
var exp:int=0
#升级经验值
var upNeedExp:int
#右手装备
var right_equip:BaseEquip
#左手装备
var left_equip:BaseEquip
#头装备
var head_equip:BaseEquip
#技能1
var skill_1:BaseSkill=BaseAttack.new()
#技能2
var skill_2:BaseSkill=BaseDefense.new()
#技能3
var skill_3:BaseSkill
#技能4
var skill_4:BaseSkill
var player_type:String="AI"
var ai_Callable:Callable=SmailAiAction.new().get_callable()

static func generate_by_excel_id(id:int)->BasePeople:
	var dic=Settings.怪物.data[id]
	var d={
		"@path":"res://entity/xiu/"+dic["修仙类型"]+".gd",
		"nameInfo":dic["名称"],
	}
	var entity:BasePeople=ObjectUtils.dict_2_inst(d)
	entity._init()
#	获取属性
	var property_name=entity.progress_property.values().map(func(t): return t.nameInfo)
	for index in property_name.size():
		var name=property_name[index]
		entity.progress_property.get(entity.progress_property.keys()[index]).random_init_up(dic[name])
#	等级
	for i in dic["等级"]:
		entity.update()
#	技能初始
	if dic["技能1"]:
		var skill=ObjectUtils.dict_2_inst({"@path":"res://entity/skill/"+dic["技能1"]+".gd"})
		skill._init();
		entity.skill_1=skill
	if dic["技能2"]:
		var skill=ObjectUtils.dict_2_inst({"@path":"res://entity/skill/"+dic["技能2"]+".gd"})
		skill._init();
		entity.skill_2=skill
	if dic["技能3"]:
		var skill=ObjectUtils.dict_2_inst({"@path":"res://entity/skill/"+dic["技能3"]+".gd"})
		skill._init();
		entity.skill_3=skill
	if dic["技能4"]:
		var skill=ObjectUtils.dict_2_inst({"@path":"res://entity/skill/"+dic["技能4"]+".gd"})
		skill._init();
		entity.skill_4=skill
	return entity

func is_dead()->bool:
	return progress_property.get("hp").current<=0
	
# 生命值计算（如果是加生命值则不走护盾处理逻辑了）
func change_hp(n:float,hp_true:bool=false):
	if n<0:
		if !hp_true:
			if progress_property.get("shield").current>0:
				if progress_property.get("shield").current>-n:
					progress_property.get("shield").current+=n;
					return
				else:
					n+=progress_property.get("shield").current
					progress_property.get("shield").current=0;
	progress_property.get("hp").current+=n

func _init() -> void:
	upNeedExp=base_up_need_exp*lv

func get_lv_str()->String:
	if 境界.size()<=0:
		return "%d级"%lv
	var index=lv/9
	var level=lv%9
	if index>=境界.size():
		index=境界.size()-1
		level=lv-(境界.size()-1)*9
	return self.境界[index]+"（第%d重）"%level

func can_update():
	return exp>=upNeedExp

func update():
	exp=0
	lv+=1;
	base_up_need_exp+=1
	upNeedExp=base_up_need_exp*lv
#	属性成长
	for i in progress_property.values():
		i.doUp()
