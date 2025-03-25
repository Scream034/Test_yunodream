extends EditorInspectorPlugin

var button_load = preload("button_load.gd")
var button_save = preload("button_save.gd")

func _can_handle(object: Object) -> bool:
	if object is CollisionPolygon2D:
		add_custom_control(button_save.new())
		add_custom_control(button_load.new())
		return true
	
	return false