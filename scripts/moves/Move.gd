class_name Move
extends RefCounted

var move_data: MoveData
var current_cooldown: int = 0

func _init(data: MoveData):
    move_data = data

func can_use(caster: CombatEntity) -> bool:
    return current_cooldown <= 0 and caster.current_energy >= move_data.energy_cost

func execute(caster: CombatEntity, target: CombatEntity) -> void:
    if not can_use(caster):
        push_error("Move cannot be used: " + move_data.move_name)
        return

    # Consumir energía
    caster.current_energy -= move_data.energy_cost

    # Aplicar cooldown
    current_cooldown = move_data.cooldown_turns

    # Ejecutar efecto específico
    _apply_effect(caster, target)

    # Emitir señal
    caster.move_executed.emit(self, caster, target)

func _apply_effect(_caster: CombatEntity, _target: CombatEntity) -> void:
    # Implementado en subclases
    pass

func get_display_name() -> String:
    return move_data.move_name

func get_description() -> String:
    var desc = ""
    if move_data.damage > 0:
        desc += "Damage: " + str(move_data.damage) + " "
    if move_data.defense > 0:
        desc += "Defense: " + str(move_data.defense) + " "
    if move_data.energy_cost > 0:
        desc += "Energy: " + str(move_data.energy_cost)
    return desc.strip_edges()

func update_cooldown() -> void:
    if current_cooldown > 0:
        current_cooldown -= 1

func is_on_cooldown() -> bool:
    return current_cooldown > 0

func get_cooldown_remaining() -> int:
    return current_cooldown