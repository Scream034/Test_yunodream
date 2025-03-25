# random_int_editor.gd
extends EditorProperty

var save_convex_button: Button = Button.new()
var convex: ConvexPolygonShape2D

func _init():
	save_convex_button.text = "Save as convex"
	save_convex_button.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	save_convex_button.connect("pressed", Callable.create(self, "_on_save_button_pressed"))
	add_child(save_convex_button)

func _on_save_button_pressed():
	var cp = get_edited_object()
	if cp is CollisionPolygon2D:
		if cp.polygon.size() == 0:
			OS.alert("Invalid collision polygon")
			push_error("Invalid collision polygon")
			return
	
		convex = ConvexPolygonShape2D.new()
		convex.points = cp.polygon
		DisplayServer.file_dialog_show("save_file", "res://", "convex.res", false, int(FileDialog.FILE_MODE_SAVE_FILE), ["*.res"], Callable.create(self, "_on_save_file_selected"))
	
func _on_save_file_selected(success: bool, path_array: PackedStringArray, _p: int):
	if success:
		var path: String = "".join(path_array)
		print("Save convex: %s" % path)
		ResourceSaver.save(convex, path)