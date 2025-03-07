extends Node2D

# 所有人员信息（index，people）
var index_people:Array[BasePeople]=[]

const fight_skill_tscn=preload("res://场景/战斗场景/fight_skill.tscn")
const fight_itme_tscn=preload("res://场景/战斗场景/fight_item.tscn")
const 属性progress组件=preload("res://场景/战斗场景/属性progress组件.tscn")

var player_group:Array=[]
var monster_group:Array=[]
var is_over:bool=true
signal fight_over(is_win:bool)

func init_data(player_group:Array,monster_group:Array)->void:
	is_over=false;
	self.player_group=player_group;
	self.monster_group=monster_group
	for people:BasePeople in player_group:
		var index=index_people.size()
		$玩家阵营/playerContainer.add_child(fight_itme_init(people))
		$集气进度.add_child(集气_labe_init(people))
		index_people.append(people)
	for people:BasePeople in monster_group:
		$敌人阵营/monsterContainer.add_child(fight_itme_init(people))
		$集气进度.add_child(集气_labe_init(people))
		index_people.append(people)

static func create属性progress组件(p:Property):
		var hp组件=属性progress组件.instantiate()
		hp组件.find_child("Label").text=p.nameInfo
		hp组件.p=p
		return hp组件

func fight_itme_init(people:BasePeople):
		var fight_itme=fight_itme_tscn.instantiate()
		fight_itme.find_child("战斗人员名称").text=people.nameInfo
		var v_box_container=fight_itme.find_child("VBoxContainer")
#		展示的属性设定
		v_box_container.add_child(create属性progress组件(people.progress_property.get("hp")))
		v_box_container.add_child(create属性progress组件(people.progress_property.get("mp")))
		v_box_container.add_child(create属性progress组件(people.progress_property.get("shield")))
		return fight_itme;
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"技能组/GridContainer/技能1/Button".pressed.connect(use_skill.bind(1))
	$"技能组/GridContainer/技能2/Button".pressed.connect(use_skill.bind(2))
	$"技能组/GridContainer/技能3/Button".pressed.connect(use_skill.bind(3))
	$"技能组/GridContainer/技能4/Button".pressed.connect(use_skill.bind(4))
	$"技能组/GridContainer/技能1/Button".disabled=true
	$"技能组/GridContainer/技能2/Button".disabled=true
	$"技能组/GridContainer/技能3/Button".disabled=true
	$"技能组/GridContainer/技能4/Button".disabled=true
	pass # Replace with function body.

var wait_queues=[]
var ji_qi_速度=10
var is_wait:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_over:
		return
	self.player_group=self.player_group.filter(func(p:BasePeople): return !p.is_dead());
	self.monster_group=self.monster_group.filter(func(p:BasePeople): return !p.is_dead());
	if self.player_group.is_empty():
		is_over=true
		print("战斗结束，失败")
		fight_over.emit(false)
		return
	if self.monster_group.is_empty():
		is_over=true
		print("战斗结束，成功")
		fight_over.emit(true)
		return
#	todo 如果所有敌人 或者 玩家 死亡，则接受战斗
	if !is_wait:
		if wait_queues.is_empty():
			for index in index_people.size():
				var jiQi=index_people[index].progress_property.get("gathering") as Property
				$集气进度.get_child(index).position.x=$集气进度.get_child(index).position.x+jiQi.get_value()*ji_qi_速度
				if $集气进度.get_child(index).position.x>=$集气进度.size.x:
					$集气进度.get_child(index).position.x=0;
#					todo 这里改为 人员类型：AI、PLAYER
					if index_people[index].player_type=="PLAYER":
						wait_queues.append(index)
					else:
						index_people[index].ai_Callable.call(index_people[index],self.monster_group,self.player_group)
		else:
			is_wait=true
			skill_change()

func skill_change():
	var people_index=wait_queues.front()
	var p=index_people[people_index] as BasePeople
	if p.skill_1:
		$"技能组/GridContainer/技能1".find_child("Label").text=p.skill_1.get_desc()
		$"技能组/GridContainer/技能1".find_child("Button").text=p.skill_1.nameInfo
		$"技能组/GridContainer/技能1/Button".disabled=false
	if p.skill_2:
		$"技能组/GridContainer/技能2".find_child("Label").text=p.skill_2.get_desc()
		$"技能组/GridContainer/技能2".find_child("Button").text=p.skill_2.nameInfo
		$"技能组/GridContainer/技能2/Button".disabled=false
	if p.skill_3:
		$"技能组/GridContainer/技能2".find_child("Label").text=p.skill_3.get_desc()
		$"技能组/GridContainer/技能2".find_child("Button").text=p.skill_3.nameInfo
		$"技能组/GridContainer/技能3/Button".disabled=false
	if p.skill_4:
		$"技能组/GridContainer/技能2".find_child("Label").text=p.skill_4.get_desc()
		$"技能组/GridContainer/技能2".find_child("Button").text=p.skill_4.nameInfo
		$"技能组/GridContainer/技能4/Button".disabled=false

func use_skill(skill_index:int):
	if wait_queues.is_empty():
		return
#	使用完成技能后 将当前玩家栈弹出
	is_wait=false
	var people_index=wait_queues.pop_front()
	var user=index_people[people_index] as BasePeople
	var skill:BaseSkill
	if skill_index==1:
		skill=user.skill_1
	elif skill_index==2:
		skill=user.skill_2
	elif skill_index==3:
		skill=user.skill_3
	elif skill_index==4:
		skill=user.skill_4
	else:
		print("暂时未开发")
		return
	if self.player_group.find(user)==-1:
#		当前人不在玩家阵营中
		skill.use_skill(user,self.monster_group,self.player_group)
	else:
		skill.use_skill(user,self.player_group,self.monster_group)
	$"技能组/GridContainer/技能1/Button".disabled=true
	$"技能组/GridContainer/技能2/Button".disabled=true
	$"技能组/GridContainer/技能3/Button".disabled=true
	$"技能组/GridContainer/技能4/Button".disabled=true

func 集气_labe_init(item:BasePeople)->Label:
	var l=Label.new()
	l.text=item.nameInfo
	l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	l.custom_minimum_size.y=40
	return l;
