extends Node

var stages = [
	"apartment_balcony.tscn",
	"stage_apartment.tscn",
	"stage_ash.tscn",
	"stage_background.tscn",
	"stage_beach.tscn",
	"stage_bedroom.tscn",
	"stage_blocks.tscn",
	"stage_bryce_day.tscn",
	"stage_canyon.tscn",
	"stage_chess.tscn",
	"stage_clocks.tscn",
	"stage_dandelion.tscn",
	"stage_end.tscn",
	"stage_fog.tscn",
	"stage_garage_block.tscn",
	"stage_here.tscn",
	"stage_hills.tscn",
	"stage_kasei.tscn",
	"stage_maze.tscn",
	"stage_normal.tscn",
	"stage_overlook.tscn",
	"stage_park.tscn",
	"stage_parking_lot.tscn",
	"stage_pipedream.tscn",
	"stage_quarters.tscn",
	"stage_realistic_outside.tscn",
	"stage_sewer.tscn",
	"stage_snowy_quarters.tscn",
	"stage_snowy_street.tscn",
	"stage_spider_lily.tscn",
	"stage_sunflower.tscn",
	"stage_swing.tscn",
	"stage_tvs.tscn",
	"stage_underwater.tscn",
	"stage_vision.tscn",
	"stage_warehouse.tscn",
	"stage_waterpark.tscn",
	"upwards_metro.tscn"
]

var in_game_names = {
	"here": "lavender",
	"upwards_metro": "train_station",
	"snowy_street": "snowy_residence",
	"sewer": "gutter",
	"overlook": "rainy_homeside",
	"blocks": "cubic_meadows",
	"apartment_balcony": "apartment_overlook",
	"garage_block": "garage_settlement",
	"parking_lot": "murky_lot",
	"beach": "shore",
	"underwater": "depths",
	"kasei": "red_moon",
	"canyon": "desert",
	"clocks": "time",
	"tvs": "digital_nurture",
	"bryce_day": "astral_frequency",
	"normal": "normal_tree",
	"homeside": "apartment",
	"swing": "rose_swing",
	"spider_lily": "spider_lilies",
	"ash": "red_ash"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("teleport")
	var ui_scene_path = get_script().resource_path.get_base_dir() + "/resources/TeleportUi.tscn"
	var ui_scene = load(ui_scene_path).instantiate()
	add_child(ui_scene)
	var teleport_ui = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui")
	teleport_ui.visible = false
	var stages_container = teleport_ui.find_child("stages_container")
	var search_bar = teleport_ui.find_child("line_edit")
	search_bar.text_changed.connect(_search_stages)
	search_bar.text_submitted.connect(_stage_to_first_result)
	for _stage in stages:
		if _stage.get_extension() != "tscn": continue
		_add_stage_button(_stage, stages_container)
	var check_button = teleport_ui.find_child("check_box")
	check_button.connect("toggled", _toggle_title)
	_load_config()
	check_button.button_pressed = tp_cfg.instant_tp
	_skip_title_screen()

@warning_ignore("unused_parameter")
func _stage_to_first_result(new_text):
	var stages_list = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui").find_child("stages_container").get_children()
	var first_location = null
	for _stage in stages_list:
		if _stage.visible:
			first_location = _stage.tooltip_text
			break
	if first_location == null:
		return
	_toggle_menu()
	game.change_stage(first_location.get_basename())
	var search_bar = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui").find_child("line_edit")
	search_bar.text = ""
	_search_stages("")

@warning_ignore("shadowed_global_identifier")
func _add_stage_button(stage, container):
	var button = Button.new()
	button.button_down.connect( func():
		game.to_entrance = 03
		_toggle_menu()
		game.change_stage(stage.get_basename())
		var search_bar = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui").find_child("line_edit")
		search_bar.text = ""
		_search_stages("")
	)
	var current_button_text = stage.get_file().replace("stage_", "").replace(".tscn", "")
	@warning_ignore("shadowed_variable_base_class")
	for name in in_game_names.keys():
		if current_button_text == name:
			current_button_text = in_game_names[name]
	button.text = current_button_text
	button.tooltip_text = stage
	container.add_child(button)
	
func _search_stages(current_query):
	var stages_list = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui").find_child("stages_container").get_children()
	for _stage in stages_list:
		if current_query != "":
			if _stage.text.contains(current_query):
				_stage.visible = true
			else:
				_stage.visible = false
		else:
			_stage.visible = true

func _input(event):
	var visible = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui").visible
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_F1:
				_toggle_menu()
			KEY_ESCAPE:
				if visible:
					_toggle_menu()
					get_viewport().set_input_as_handled()

func _toggle_menu():
	var teleport_ui = get_tree().get_first_node_in_group("teleport").get_node("teleport_ui")
	var teleport_ui_search_box = teleport_ui.find_child("line_edit")
	if teleport_ui.visible:
		teleport_ui_search_box.release_focus()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_set_player_input_enabled(true)
	else:
		teleport_ui_search_box.grab_focus()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_set_player_input_enabled(false)
	teleport_ui.visible = !teleport_ui.visible

func _set_player_input_enabled(enabled: bool) -> void:
	var nia: player = get_tree().get_first_node_in_group("player")
	if nia:
		get_tree().get_first_node_in_group("player").set_process_unhandled_input(enabled)
		get_tree().get_first_node_in_group("player").is_paused = not enabled
		if !enabled:
			get_tree().get_first_node_in_group("player").velocity = Vector3.ZERO
			var anim_tree = get_tree().get_first_node_in_group("player").get_node_or_null("anim_tree")
			if anim_tree:
				anim_tree.set("parameters/idle_walk_run/blend_position", Vector2.ZERO)

const _SETTINGS_PATH := "user://tp.cfg"

var tp_cfg_res := load(get_script().resource_path.get_base_dir() + "/tp_cfg.gd")
var tp_cfg = tp_cfg_res.new()

func _toggle_title(current_value):
	tp_cfg.instant_tp = current_value
	save_config()

func save_config() -> void:
	var cfg := ConfigFile.new()
	for _prop in tp_cfg.get_script().get_script_property_list():
		cfg.set_value("settings", _prop.name, tp_cfg.get(_prop.name))
	cfg.save(_SETTINGS_PATH)
	
func _load_config() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(_SETTINGS_PATH) != OK:
		return
	for _prop in tp_cfg.get_script().get_script_property_list():
		if cfg.has_section_key("settings", _prop.name):
			tp_cfg.set(_prop.name, cfg.get_value("settings", _prop.name))

func _skip_title_screen():
	if tp_cfg.instant_tp:
		game.change_stage(config.last_visited)
