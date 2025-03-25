# random_int_editor.gd
extends EditorProperty

var load_convex_button: Button = Button.new()
var convex: ConvexPolygonShape2D

func _init():
	load_convex_button.text = "Load from convex"
	load_convex_button.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	load_convex_button.connect("pressed", Callable.create(self, "_on_load_button_pressed"))
	add_child(load_convex_button)

func _on_load_button_pressed():
	DisplayServer.file_dialog_show("open_file", "res://", "convex.res", false, int(FileDialog.FILE_MODE_OPEN_FILE), ["*.res"], Callable.create(self, "_on_load_file_selected"))

func _on_load_file_selected(success: bool, path_array: PackedStringArray, _p: int):
	if success:
		var path: String = "".join(path_array)
		print("Load convex: %s" % path)
		convex = ResourceLoader.load(path)
		if convex is ConvexPolygonShape2D:
			get_edited_object().polygon = convex.points