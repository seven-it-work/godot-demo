extends Node
class_name BaseAiAction



func get_callable()->Callable:
	return Callable.create(self, "do_ai_action");

func do_ai_action(user:BasePeople,team:Array,enemy:Array):
	pass
