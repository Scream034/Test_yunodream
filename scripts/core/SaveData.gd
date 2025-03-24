extends Object
class_name SaveData

var type: StringName
var data: Dictionary
var path: NodePath

static func from_dictionary(p_data: Dictionary) -> SaveData:
	return SaveData.new(p_data["type"], p_data["data"], p_data["path"])

func _init(p_type: StringName, p_data: Dictionary, p_path: NodePath) -> void:
	type = p_type
	data = p_data
	path = p_path


func as_dictionary() -> Dictionary:
	return {
		"type": type,
		"data": data,
		"path": path
	}