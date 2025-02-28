@tool
class_name Property
extends Node

@export var min:float=0;
@export var max:float=0;
@export var current:float=0;
@export var upMin:float=0;
@export var upMax:float=0;
@export var nameInfo:String=""

func doUp():
	var up=randf_range(upMin,upMax)
	self.current+=up
	self.max+=up

static func create(
	min:float,
	max:float,
	upMin:float,
	upMax:float,
	nameInfo:String
)->Property:
	var re=Property.new()
	re.min=min
	re.max=max
	re.current=max
	re.upMin=upMin
	re.upMax=upMax
	re.nameInfo=nameInfo
	return re;
