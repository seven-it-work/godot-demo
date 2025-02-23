# path_choice.gd
class_name PathChoice
extends RefCounted

var monsters: Array # 怪物列表
var rewards: Dictionary # 奖励信息


# path_choice.gd
func to_dict() -> Dictionary:
	return {
		"monsters": monsters,
		"rewards": rewards
	}

static func from_dict(data: Dictionary) -> PathChoice:
	var path_choice = PathChoice.new()
	path_choice.monsters = data.get("monsters", [])
	path_choice.rewards = data.get("rewards", {})
	return path_choice
