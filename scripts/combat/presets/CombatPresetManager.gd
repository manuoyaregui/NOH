class_name CombatPresetManager
extends RefCounted

# Singleton instance
static var _instance: CombatPresetManager
static var instance: CombatPresetManager:
	get:
		if not _instance:
			_instance = CombatPresetManager.new()
		return _instance

# Dictionary to store loaded presets
var _presets: Dictionary = {}
var _presets_loaded: bool = false

# Default presets path
const PRESETS_PATH = "res://scripts/combat/presets/resources/"


func _init():
	load_presets()


func load_presets():
	if _presets_loaded:
		return

	var dir = DirAccess.open(PRESETS_PATH)
	if not dir:
		push_error("Could not open presets directory: " + PRESETS_PATH)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var preset_path = PRESETS_PATH + file_name
			var preset = load(preset_path) as CombatPreset

			if preset:
				_presets[preset.preset_name] = preset
				print("Loaded combat preset: " + preset.preset_name)
			else:
				push_error("Failed to load preset: " + preset_path)

		file_name = dir.get_next()

	_presets_loaded = true
	print("Loaded " + str(_presets.size()) + " combat presets")


func get_preset(preset_name: String) -> CombatPreset:
	if not _presets.has(preset_name):
		push_error("Combat preset not found: " + preset_name)
		return null

	return _presets[preset_name]


func get_all_preset_names() -> Array:
	return _presets.keys()


func has_preset(preset_name: String) -> bool:
	return _presets.has(preset_name)


func reload_presets():
	_presets.clear()
	_presets_loaded = false
	load_presets()
