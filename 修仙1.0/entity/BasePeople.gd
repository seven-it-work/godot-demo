class_name BasePeople
extends Node


var 境界=[]

#没级升级需要的经验值（比如1级需要10点经验，2级需要20点）
var base_up_need_exp=10
#姓名
var nameInfo:String
#生命值
var hp:Property=Property.create(0,100,0,1,"生命值")
#真元值
var mp:Property=Property.create(0,100,0,1,"真元值")
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
	lv+=1;
	base_up_need_exp+=1
	upNeedExp=base_up_need_exp*lv
#	属性成长
	hp.doUp()
	mp.doUp()
