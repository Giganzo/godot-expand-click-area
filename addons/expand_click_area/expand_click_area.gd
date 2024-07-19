@tool
extends ReferenceRect
## Setup:
## Add click_area_left/top/right/bottom to the constant of the item type in the [theme] used for the parent control of this node.
## Set the desired value for each side in these constants to expand the click area.


enum click_area {
	click_area_left,
	click_area_top,
	click_area_right,
	click_area_bottom,
}


@export_group("Click Area Overrides", "click_area_")
@export var click_area_left: int = -1:
	set(v):
		click_area_left = v
		_click_area_overrides[0] = v
		call_deferred("_setup_click_area")
@export var click_area_top: int = -1:
	set(v):
		click_area_top = v
		_click_area_overrides[1] = v
		call_deferred("_setup_click_area")
@export var click_area_right: int = -1:
	set(v):
		click_area_right = v
		_click_area_overrides[2] = v
		call_deferred("_setup_click_area")
@export var click_area_bottom: int = -1:
	set(v):
		click_area_bottom = v
		_click_area_overrides[3] = v
		call_deferred("_setup_click_area")

var _click_area_overrides: Array[int] = [
	click_area_left,
	click_area_top,
	click_area_right,
	click_area_bottom,
]
var _click_area_left: int
var _click_area_top: int
var _click_area_right: int
var _click_area_bottom: int


func _ready() -> void:
	visible = true
	if Engine.is_editor_hint():
		set_meta("_edit_lock_", true)
		await draw
	mouse_default_cursor_shape = get_parent_control().mouse_default_cursor_shape
	layout_mode = 1
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_PASS
	get_parent_control().theme_changed.connect(_setup_click_area)
	get_parent_control().theme_changed.connect(_connect_theme_changed)
	_setup_click_area()
	

func _setup_click_area() -> void:
	for i in click_area.size():
		var side = click_area.keys()[i]
		if _click_area_overrides[i] > -1:
			#set(side, _click_area_overrides[i])
			_update_side_offset(i, _click_area_overrides[i])
			continue
		var theme_type: String = get_parent_control().theme_type_variation
		if not get_parent_control().has_theme_constant(side, theme_type):
			theme_type = get_parent_control().get_class()
		if get_parent_control().has_theme_constant(side, theme_type):
			#set(side, get_parent_control().get_theme_constant(side, theme_type) )
			_update_side_offset(i, get_parent_control().get_theme_constant(side, theme_type))
		else:
			#set(side, 0)
			_update_side_offset(i, 0)
			
	#for side in click_area.keys():
		#var theme_type: String = get_parent_control().theme_type_variation
		#if not get_parent_control().has_theme_constant(side, theme_type):
			#theme_type = get_parent_control().get_class()
		#if get_parent_control().has_theme_constant(side, theme_type):
			#set(side, get_parent_control().get_theme_constant(side, theme_type) )
		#else:
			#set(side, 0)
func _update_side_offset(side: Side, amount: int) -> void:
	set_offset(side, -amount if side == SIDE_LEFT or side == SIDE_TOP else amount)
	#set_offset(SIDE_LEFT, -_click_area_left)
	#set_offset(SIDE_TOP, -_click_area_top)
	#set_offset(SIDE_RIGHT, _click_area_right)
	#set_offset(SIDE_BOTTOM, _click_area_bottom)
	
	
func _connect_theme_changed() -> void:
	if get_parent_control().theme:
		get_parent_control().theme.changed.connect(_setup_click_area)
	
