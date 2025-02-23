# player.gd
class_name Player
extends RefCounted

var name: String
var equipment: Array # 假设装备是一个数组
var skills: Dictionary # 技能是一个字典
var attributes: Dictionary # 属性也是一个字典


func to_dict() -> Dictionary:
	return {
		"name": name,
		"equipment": equipment,
		"skills": skills,
		"attributes": attributes
	}

static func from_dict(data: Dictionary) -> Player:
	var player = Player.new()
	player.name = data.get("name", "")
	player.equipment = data.get("equipment", [])
	player.skills = data.get("skills", {})
	player.attributes = data.get("attributes", {})
	return player
