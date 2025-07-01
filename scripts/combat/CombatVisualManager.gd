extends Node

# Handles visual elements in the combat scene, such as health billboards.


func _ready():
	var combat_manager = get_parent().get_node_or_null("CombatManager")
	if combat_manager:
		combat_manager.connect("entity_damaged", _on_entity_damaged)
		combat_manager.connect("entity_name_changed", _on_entity_name_changed)


func _on_entity_damaged(entity: CombatEntity, new_health: int):
	entity.get_node("HealthBar").set_health(new_health, entity.max_health)


func _on_entity_name_changed(entity: CombatEntity, new_name: String):
	entity.get_node("EntityName").text = new_name
