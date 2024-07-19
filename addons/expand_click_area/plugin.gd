@tool
extends EditorPlugin



func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("ExpandClickArea", "ReferenceRect", preload("expand_click_area.gd"), preload("icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("ExpandClickArea")
