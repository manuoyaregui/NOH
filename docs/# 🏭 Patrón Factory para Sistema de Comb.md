# 🏭 Patrón Factory para Sistema de Combate

## 📋 Índice
- [1. Introducción](#1-introducción)
- [2. Arquitectura del Sistema](#2-arquitectura-del-sistema)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
- [4. Estructura de Archivos](#4-estructura-de-archivos)
- [5. Ejemplos de Uso](#5-ejemplos-de-uso)
- [6. Ventajas y Beneficios](#6-ventajas-y-beneficios)
- [7. Consideraciones Futuras](#7-consideraciones-futuras)

---

## 1. Introducción

### ¿Qué es el Patrón Factory?

El patrón Factory es un patrón de diseño creacional que proporciona una interfaz para crear objetos sin especificar sus clases concretas. En nuestro caso, se utiliza para crear entidades de combate, movimientos, IA y configuraciones de manera dinámica y escalable.

### ¿Por qué Factory para el Sistema de Combate?

- **Reutilización de Escena**: Una sola escena `Combat.tscn` para todos los combates
- **Configuración Dinámica**: Cada combate puede tener entidades completamente diferentes
- **Escalabilidad**: Fácil agregar nuevos tipos de enemigos y movimientos
- **Mantenibilidad**: Código limpio y fácil de mantener

---

## 2. Arquitectura del Sistema

### Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                    CombatFactory                    │
│                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │EntityFactory│  │MoveFactory  │  │AIFactory    │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────┘
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │CombatEntity │  │Move         │  │AIBehavior   │
    │             │  │             │  │             │
    │Player       │  │Offensive    │  │Aggressive   │
    │Enemy        │  │Defensive    │  │Defensive    │
    │             │  │Special      │  │Tactical     │
    └─────────────┘  └─────────────┘  └─────────────┘
```

### Componentes Principales

#### A. CombatFactory
- **Responsabilidad**: Coordinar la creación de todos los componentes del combate
- **Entrada**: CombatConfig (configuración del combate)
- **Salida**: Escena de combate completamente configurada

#### B. EntityFactory
- **Responsabilidad**: Crear entidades (jugador y enemigos)
- **Configuración**: Sprites, estadísticas, posiciones, IA

#### C. MoveFactory
- **Responsabilidad**: Crear movimientos de combate
- **Tipos**: Ofensivos, Defensivos, Especiales

#### D. AIFactory
- **Responsabilidad**: Crear comportamientos de IA
- **Perfiles**: Agresivo, Defensivo, Táctico, Boss

---

## 3. Implementación Paso a Paso

### Paso 1: Crear la Estructura Base de Datos

#### 1.1 CombatConfig Resource
```gdscript
# scripts/combat/CombatConfig.gd
class_name CombatConfig
extends Resource

@export var player_data: PlayerData
@export var enemy_data: EnemyData
@export var combat_background: String = "default"
@export var music_track: String = "combat_default"
@export var lighting_setting: String = "default"
@export var victory_rewards: Array[Resource] = []
@export var defeat_consequences: Array[Resource] = []
@export var combat_duration_limit: float = 300.0  # 5 minutos
```

#### 1.2 EntityData Resources
```gdscript
# scripts/entities/EntityData.gd
class_name EntityData
extends Resource

@export var entity_name: String
@export var sprite_frames: SpriteFrames
@export var color_modulation: Color = Color.WHITE
@export var combat_position: Vector3
@export var flip_horizontal: bool = false
@export var max_health: int = 100
@export var stats: CharacterStats
@export var moves: Array[MoveData] = []

# scripts/entities/PlayerData.gd
class_name PlayerData
extends EntityData

@export var current_health: int
@export var current_energy: int
@export var experience_level: int = 1

# scripts/entities/EnemyData.gd
class_name EnemyData
extends EntityData

@export var ai_type: String = "DEFAULT"
@export var ai_profile: AIProfile
@export var difficulty_rating: int = 1
@export var region_affiliation: String = ""
```

#### 1.3 MoveData Resource
```gdscript
# scripts/moves/MoveData.gd
class_name MoveData
extends Resource

enum MoveType { OFFENSIVE, DEFENSIVE, SPECIAL }

@export var move_name: String
@export var move_type: MoveType
@export var energy_cost: int = 0
@export var damage: int = 0
@export var defense: int = 0
@export var special_effects: Array[String] = []
@export var animation_name: String = ""
@export var cooldown_turns: int = 0
@export var target_type: String = "SINGLE"  # SINGLE, ALL, SELF
```

### Paso 2: Implementar las Factories

#### 2.1 CombatFactory Principal
```gdscript
# scripts/combat/CombatFactory.gd
class_name CombatFactory
extends RefCounted

static func create_combat_scene(config: CombatConfig) -> Node:
    # Crear la escena base
    var combat_scene = preload("res://scenes/Combat.tscn").instantiate()
    var combat_manager = combat_scene.get_node("CombatManager")
    
    # Configurar entidades usando factories específicas
    combat_manager.player = EntityFactory.create_player(config.player_data)
    combat_manager.enemy = EntityFactory.create_enemy(config.enemy_data)
    
    # Configurar movimientos
    combat_manager.player_moves = MoveFactory.create_moves(config.player_data.moves)
    combat_manager.enemy_moves = MoveFactory.create_moves(config.enemy_data.moves)
    
    # Configurar UI y efectos
    UIFactory.setup_combat_ui(combat_scene, config)
    EffectFactory.setup_combat_effects(combat_scene, config)
    
    # Configurar música y ambiente
    AudioFactory.setup_combat_audio(combat_scene, config)
    
    return combat_scene

static func create_region_combat(region: String, enemy_id: String) -> Node:
    var config = CombatConfig.new()
    
    # Configuración específica por región
    match region:
        "crown_silent":
            config.combat_background = "crown_room"
            config.music_track = "crown_combat"
            config.lighting_setting = "authority_lighting"
        "sunken_fields":
            config.combat_background = "toy_graveyard"
            config.music_track = "nostalgia_combat"
            config.lighting_setting = "melancholic_lighting"
        "marble_throne":
            config.combat_background = "throne_room"
            config.music_track = "final_boss"
            config.lighting_setting = "dramatic_lighting"
        _:
            config.combat_background = "default"
            config.music_track = "combat_default"
            config.lighting_setting = "default"
    
    config.enemy_data = ResourceLoader.load("res://scripts/entities/resources/enemy_data/" + enemy_id + ".tres")
    config.player_data = get_current_player_data()
    
    return create_combat_scene(config)
```

#### 2.2 EntityFactory
```gdscript
# scripts/entities/EntityFactory.gd
class_name EntityFactory
extends RefCounted

static func create_player(player_data: PlayerData) -> CombatEntity:
    var entity = preload("res://scenes/CombatEntity.tscn").instantiate()
    
    # Configurar sprite y animaciones
    var sprite = entity.get_node("PlayerSprite")
    sprite.sprite_frames = player_data.sprite_frames
    sprite.modulate = player_data.color_modulation
    sprite.flip_h = player_data.flip_horizontal
    
    # Configurar estadísticas
    entity.stats = player_data.stats.duplicate()
    entity.max_health = player_data.max_health
    entity.current_health = player_data.current_health
    entity.current_energy = player_data.current_energy
    entity.experience_level = player_data.experience_level
    
    # Configurar posición y transform
    entity.position = player_data.combat_position
    
    # Configurar como jugador
    entity.is_player = true
    entity.entity_name = player_data.entity_name
    
    return entity

static func create_enemy(enemy_data: EnemyData) -> CombatEntity:
    var entity = preload("res://scenes/CombatEntity.tscn").instantiate()
    
    # Configurar sprite y animaciones
    var sprite = entity.get_node("PlayerSprite")
    sprite.sprite_frames = enemy_data.sprite_frames
    sprite.modulate = enemy_data.color_modulation
    sprite.flip_h = enemy_data.flip_horizontal
    
    # Configurar estadísticas
    entity.stats = enemy_data.stats.duplicate()
    entity.max_health = enemy_data.max_health
    entity.current_health = enemy_data.max_health  # Enemigos empiezan con salud completa
    
    # Configurar IA
    entity.ai_profile = enemy_data.ai_profile
    entity.ai_behavior = AIFactory.create_behavior(enemy_data.ai_type)
    entity.difficulty_rating = enemy_data.difficulty_rating
    entity.region_affiliation = enemy_data.region_affiliation
    
    # Configurar posición y transform
    entity.position = enemy_data.combat_position
    
    # Configurar como enemigo
    entity.is_player = false
    entity.entity_name = enemy_data.entity_name
    
    return entity
```

#### 2.3 MoveFactory
```gdscript
# scripts/moves/MoveFactory.gd
class_name MoveFactory
extends RefCounted

static func create_moves(move_data_list: Array[MoveData]) -> Array[Move]:
    var moves: Array[Move] = []
    
    for move_data in move_data_list:
        var move = _create_move_by_type(move_data)
        if move != null:
            moves.append(move)
    
    return moves

static func _create_move_by_type(move_data: MoveData) -> Move:
    match move_data.move_type:
        MoveData.MoveType.OFFENSIVE:
            return OffensiveMove.new(move_data)
        MoveData.MoveType.DEFENSIVE:
            return DefensiveMove.new(move_data)
        MoveData.MoveType.SPECIAL:
            return SpecialMove.new(move_data)
        _:
            push_error("Unknown move type: " + str(move_data.move_type))
            return null

static func create_default_moves() -> Array[Move]:
    # Movimientos básicos para casos de emergencia
    var basic_attack = MoveData.new()
    basic_attack.move_name = "Basic Attack"
    basic_attack.move_type = MoveData.MoveType.OFFENSIVE
    basic_attack.damage = 10
    basic_attack.energy_cost = 0
    
    var basic_defend = MoveData.new()
    basic_defend.move_name = "Defend"
    basic_defend.move_type = MoveData.MoveType.DEFENSIVE
    basic_defend.defense = 5
    basic_defend.energy_cost = 0
    
    return create_moves([basic_attack, basic_defend])
```

#### 2.4 AIFactory
```gdscript
# scripts/ai/AIFactory.gd
class_name AIFactory
extends RefCounted

static func create_behavior(ai_type: String) -> AIBehavior:
    match ai_type.to_upper():
        "AGGRESSIVE":
            return AggressiveBehavior.new()
        "DEFENSIVE":
            return DefensiveBehavior.new()
        "TACTICAL":
            return TacticalBehavior.new()
        "BOSS":
            return BossBehavior.new()
        "RANDOM":
            return RandomBehavior.new()
        _:
            push_warning("Unknown AI type: " + ai_type + ". Using default behavior.")
            return DefaultBehavior.new()

static func create_behavior_from_profile(profile: AIProfile) -> AIBehavior:
    var behavior = create_behavior(profile.behavior_type)
    behavior.aggression_level = profile.aggression_level
    behavior.defense_priority = profile.defense_priority
    behavior.special_move_chance = profile.special_move_chance
    behavior.retreat_threshold = profile.retreat_threshold
    return behavior
```

### Paso 3: Crear las Clases de Movimientos

#### 3.1 Clase Base Move
```gdscript
# scripts/moves/Move.gd
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

func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
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
```

#### 3.2 Movimientos Específicos
```gdscript
# scripts/moves/move_types/OffensiveMove.gd
class_name OffensiveMove
extends Move

func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
    var final_damage = move_data.damage + caster.stats.attack_bonus
    target.take_damage(final_damage)
    
    # Efectos especiales
    for effect in move_data.special_effects:
        _apply_special_effect(effect, caster, target)

# scripts/moves/move_types/DefensiveMove.gd
class_name DefensiveMove
extends Move

func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
    var defense_bonus = move_data.defense + caster.stats.defense_bonus
    caster.add_defense_buff(defense_bonus, 1)  # 1 turno
    
    # Efectos especiales
    for effect in move_data.special_effects:
        _apply_special_effect(effect, caster, target)

# scripts/moves/move_types/SpecialMove.gd
class_name SpecialMove
extends Move

func _apply_effect(caster: CombatEntity, target: CombatEntity) -> void:
    # Efectos especiales únicos
    for effect in move_data.special_effects:
        _apply_special_effect(effect, caster, target)
```

### Paso 4: Implementar Sistema de IA

#### 4.1 Clase Base AIBehavior
```gdscript
# scripts/ai/AIBehavior.gd
class_name AIBehavior
extends RefCounted

var aggression_level: float = 0.5
var defense_priority: float = 0.3
var special_move_chance: float = 0.2
var retreat_threshold: float = 0.2

func choose_move(enemy: CombatEntity, player: CombatEntity) -> Move:
    # Implementado en subclases
    return null

func should_retreat(enemy: CombatEntity, player: CombatEntity) -> bool:
    var health_ratio = float(enemy.current_health) / float(enemy.max_health)
    return health_ratio <= retreat_threshold

# scripts/ai/profiles/AggressiveBehavior.gd
class_name AggressiveBehavior
extends AIBehavior

func _init():
    aggression_level = 0.8
    defense_priority = 0.1
    special_move_chance = 0.3

func choose_move(enemy: CombatEntity, player: CombatEntity) -> Move:
    var available_moves = enemy.get_available_moves()
    var offensive_moves = available_moves.filter(func(move): return move is OffensiveMove)
    
    if offensive_moves.size() > 0 and randf() < aggression_level:
        return offensive_moves[randi() % offensive_moves.size()]
    
    return available_moves[randi() % available_moves.size()]
```

### Paso 5: Crear Resources de Datos

#### 5.1 Estructura de Directorios
```
scripts/entities/resources/
├── player_data/
│   ├── player_base.tres
│   └── player_variants/
├── enemy_data/
│   ├── common_enemies/
│   │   ├── basic_guard.tres
│   │   └── shadow_creature.tres
│   ├── boss_enemies/
│   │   ├── trauma_manifesto.tres
│   │   └── authority_figure.tres
│   └── region_specific/
│       ├── crown_silent/
│       ├── sunken_fields/
│       └── marble_throne/
```

#### 5.2 Ejemplo de EnemyData Resource
```gdscript
# scripts/entities/resources/enemy_data/boss_enemies/trauma_manifesto.tres
[gd_resource type="Resource" script_class="EnemyData" load_steps=2 format=3]

[ext_resource type="SpriteFrames" uid="uid://..." path="res://assets/enemies/trauma_manifesto_frames.tres" id="1_abc123"]

[sub_resource type="EnemyData" id="EnemyData_xyz789"]
entity_name = "Trauma Manifesto"
sprite_frames = ExtResource("1_abc123")
color_modulation = Color(0.8, 0.2, 0.2, 1.0)
combat_position = Vector3(2.0, 0.0, 0.0)
flip_horizontal = true
max_health = 200
ai_type = "BOSS"
difficulty_rating = 5
region_affiliation = "marble_throne"
```

---

## 4. Estructura de Archivos

```
scripts/
├── combat/
│   ├── CombatFactory.gd
│   ├── CombatConfig.gd
│   ├── CombatManager.gd
│   └── CombatState.gd
├── entities/
│   ├── EntityFactory.gd
│   ├── EntityData.gd
│   ├── PlayerData.gd
│   ├── EnemyData.gd
│   ├── CombatEntity.gd
│   └── resources/
│       ├── player_data/
│       │   ├── player_base.tres
│       │   └── player_variants/
│       └── enemy_data/
│           ├── common_enemies/
│           ├── boss_enemies/
│           └── region_specific/
├── moves/
│   ├── MoveFactory.gd
│   ├── MoveData.gd
│   ├── Move.gd
│   ├── move_types/
│   │   ├── OffensiveMove.gd
│   │   ├── DefensiveMove.gd
│   │   └── SpecialMove.gd
│   └── resources/
│       ├── offensive/
│       ├── defensive/
│       └── special/
├── ai/
│   ├── AIFactory.gd
│   ├── AIBehavior.gd
│   ├── AIProfile.gd
│   └── profiles/
│       ├── AggressiveBehavior.gd
│       ├── DefensiveBehavior.gd
│       ├── TacticalBehavior.gd
│       ├── BossBehavior.gd
│       └── DefaultBehavior.gd
├── ui/
│   ├── UIFactory.gd
│   ├── CombatUI.gd
│   ├── MoveSelectionUI.gd
│   └── CombatHUD.gd
├── effects/
│   ├── EffectFactory.gd
│   ├── CombatEffect.gd
│   └── effects/
├── audio/
│   ├── AudioFactory.gd
│   └── CombatAudio.gd
└── utils/
    ├── ResourceLoader.gd
    ├── LocalizationManager.gd
    └── CombatUtils.gd
```

---

## 5. Ejemplos de Uso

### 5.1 Uso Básico del Factory

```gdscript
# En cualquier parte del juego
func start_combat(enemy_id: String):
    var combat_scene = CombatFactory.create_region_combat("crown_silent", enemy_id)
    combat_scene.combat_ended.connect(_on_combat_ended)
    get_tree().current_scene.add_child(combat_scene)

func _on_combat_ended(victory: bool, rewards: Array):
    if victory:
        print("¡Victoria! Recompensas: ", rewards)
    else:
        print("Derrota. Consecuencias aplicadas.")
```

### 5.2 Configuración Personalizada

```gdscript
func start_custom_combat():
    var config = CombatConfig.new()
    
    # Configurar jugador
    config.player_data = preload("res://scripts/entities/resources/player_data/player_base.tres")
    config.player_data.current_health = 80  # Modificar para este combate específico
    
    # Configurar enemigo
    config.enemy_data = preload("res://scripts/entities/resources/enemy_data/boss_enemies/trauma_manifesto.tres")
    
    # Configurar ambiente
    config.combat_background = "nightmare_void"
    config.music_track = "nightmare_combat"
    config.lighting_setting = "void_lighting"
    
    # Configurar recompensas
    config.victory_rewards = [
        preload("res://scripts/items/resources/memory_fragment.tres"),
        preload("res://scripts/items/resources/experience_boost.tres")
    ]
    
    var combat_scene = CombatFactory.create_combat_scene(config)
    add_child(combat_scene)
```

### 5.3 Integración con el Sistema de Regiones

```gdscript
# scripts/world/RegionManager.gd
class_name RegionManager
extends Node

func trigger_region_combat(region: String, node_type: String):
    var enemy_id = _get_enemy_for_node(region, node_type)
    var combat_scene = CombatFactory.create_region_combat(region, enemy_id)
    
    # Configurar señales específicas de la región
    combat_scene.combat_ended.connect(_on_region_combat_ended.bind(region))
    
    get_tree().current_scene.add_child(combat_scene)

func _get_enemy_for_node(region: String, node_type: String) -> String:
    match node_type:
        "combat":
            return _get_random_enemy(region, "common")
        "boss":
            return _get_boss_enemy(region)
        _:
            return "basic_guard"

func _on_region_combat_ended(region: String, victory: bool, rewards: Array):
    if victory:
        _unlock_region_progress(region)
        _apply_region_rewards(region, rewards)
    else:
        _handle_region_defeat(region)
```

### 5.4 Sistema de Dificultad Dinámica

```gdscript
# scripts/combat/DifficultyManager.gd
class_name DifficultyManager
extends RefCounted

static func adjust_enemy_difficulty(enemy_data: EnemyData, player_level: int) -> EnemyData:
    var adjusted_enemy = enemy_data.duplicate()
    
    # Ajustar estadísticas basadas en el nivel del jugador
    var difficulty_multiplier = 1.0 + (player_level - 1) * 0.2
    
    adjusted_enemy.max_health = int(enemy_data.max_health * difficulty_multiplier)
    adjusted_enemy.stats.attack_bonus = int(enemy_data.stats.attack_bonus * difficulty_multiplier)
    adjusted_enemy.stats.defense_bonus = int(enemy_data.stats.defense_bonus * difficulty_multiplier)
    
    return adjusted_enemy

# Uso en CombatFactory
static func create_combat_scene(config: CombatConfig) -> Node:
    # Ajustar dificultad antes de crear el combate
    config.enemy_data = DifficultyManager.adjust_enemy_difficulty(
        config.enemy_data, 
        config.player_data.experience_level
    )
    
    # Continuar con la creación normal...
```

---

## 6. Ventajas y Beneficios

### 6.1 Escalabilidad

| Aspecto | Antes | Con Factory |
|---------|-------|-------------|
| **Nuevos Enemigos** | Crear nueva escena completa | Solo crear EnemyData resource |
| **Nuevos Movimientos** | Modificar código existente | Agregar al MoveFactory |
| **Nuevas Regiones** | Duplicar escenas | Configuración en RegionCombatFactory |
| **Sistema de Cartas** | Refactorización mayor | Integración directa en MoveFactory |

### 6.2 Mantenibilidad

- **Separación de Responsabilidades**: Cada factory tiene una función específica
- **Código Reutilizable**: Lógica centralizada y compartida
- **Testing Simplificado**: Cada componente se puede testear independientemente
- **Debugging Fácil**: Problemas localizados en factories específicas

### 6.3 Rendimiento

- **Carga Lazy**: Los recursos se cargan solo cuando son necesarios
- **Caching**: Los recursos se pueden cachear para reutilización
- **Memory Management**: Mejor control sobre la memoria de recursos
- **Optimización**: Fácil implementar optimizaciones específicas

### 6.4 Flexibilidad

- **Configuración Dinámica**: Cada combate puede ser único
- **Modificaciones en Tiempo Real**: Cambios sin reiniciar el juego
- **Sistema de Mods**: Fácil extensión para mods futuros
- **Localización**: Integración directa con el sistema de idiomas

---

## 7. Consideraciones Futuras

### 7.1 Sistema de Cartas

El patrón Factory está preparado para la integración del sistema de cartas:

```gdscript
# Futura implementación
class_name CardFactory
extends RefCounted

static func create_card(card_data: CardData) -> Card:
    match card_data.card_type:
        CardData.CardType.CONTRACT:
            return ContractCard.new(card_data)
        CardData.CardType.BEHAVIOR:
            return BehaviorCard.new(card_data)
        CardData.CardType.RNG:
            return RNGCard.new(card_data)
        CardData.CardType.SKILL:
            return SkillCard.new(card_data)

# Integración en CombatFactory
static func setup_card_system(combat_scene: Node, config: CombatConfig):
    var card_deck = CardFactory.create_deck(config.player_data.cards)
    combat_scene.card_manager.set_deck(card_deck)
```

### 7.2 Múltiples Enemigos

```gdscript
# Extensión para combates con múltiples enemigos
static func create_multi_enemy_combat(config: MultiEnemyCombatConfig) -> Node:
    var combat_scene = preload("res://scenes/Combat.tscn").instantiate()
    
    # Crear múltiples enemigos
    var enemies: Array[CombatEntity] = []
    for enemy_data in config.enemy_data_list:
        var enemy = EntityFactory.create_enemy(enemy_data)
        enemies.append(enemy)
    
    combat_scene.enemy_manager.set_enemies(enemies)
    return combat_scene
```

### 7.3 Sistema de Efectos de Estado

```gdscript
# Factory para efectos de estado
class_name StatusEffectFactory
extends RefCounted

static func create_status_effect(effect_data: StatusEffectData) -> StatusEffect:
    match effect_data.effect_type:
        StatusEffectData.EffectType.POISON:
            return PoisonEffect.new(effect_data)
        StatusEffectData.EffectType.BURN:
            return BurnEffect.new(effect_data)
        StatusEffectData.EffectType.STUN:
            return StunEffect.new(effect_data)
        StatusEffectData.EffectType.BUFF:
            return BuffEffect.new(effect_data)
```

### 7.4 Sistema de Logros y Estadísticas

```gdscript
# Integración con sistema de logros
class_name AchievementFactory
extends RefCounted

static func check_combat_achievements(combat_result: CombatResult):
    var achievements = []
    
    # Verificar logros específicos
    if combat_result.turns_taken <= 3:
        achievements.append("speed_demon")
    
    if combat_result.damage_taken == 0:
        achievements.append("perfect_victory")
    
    if combat_result.special_moves_used >= 5:
        achievements.append("specialist")
    
    return achievements
```

### 7.5 Sistema de Mods

```gdscript
# Estructura preparada para mods
class_name ModFactory
extends RefCounted

static func load_mod_enemies(mod_path: String) -> Array[EnemyData]:
    var mod_enemies: Array[EnemyData] = []
    var mod_dir = DirAccess.open(mod_path)
    
    if mod_dir:
        mod_dir.list_dir_begin()
        var file_name = mod_dir.get_next()
        
        while file_name != "":
            if file_name.ends_with(".tres"):
                var enemy_data = load(mod_path + "/" + file_name)
                if enemy_data is EnemyData:
                    mod_enemies.append(enemy_data)
            file_name = mod_dir.get_next()
    
    return mod_enemies
```

---

## 8. Plan de Implementación Paso a Paso

### Fase 1: Estructura Base (Semana 1)
1. **Crear recursos base**: EntityData, PlayerData, EnemyData, MoveData
2. **Implementar CombatConfig**: Configuración central del combate
3. **Crear estructura de directorios**: Organizar archivos según la arquitectura

### Fase 2: Factories Principales (Semana 2)
1. **CombatFactory**: Factory principal de coordinación
2. **EntityFactory**: Creación de entidades
3. **MoveFactory**: Creación de movimientos
4. **AIFactory**: Creación de comportamientos de IA

### Fase 3: Sistema de Movimientos (Semana 3)
1. **Clase base Move**: Funcionalidad común de movimientos
2. **Tipos específicos**: OffensiveMove, DefensiveMove, SpecialMove
3. **Sistema de cooldowns**: Gestión de cooldowns de movimientos
4. **Efectos especiales**: Sistema de efectos de movimientos

### Fase 4: Sistema de IA (Semana 4)
1. **AIBehavior base**: Comportamiento base de IA
2. **Perfiles específicos**: Aggressive, Defensive, Tactical, Boss
3. **Sistema de decisiones**: Lógica de toma de decisiones
4. **Integración con movimientos**: IA que usa movimientos disponibles

### Fase 5: Recursos de Datos (Semana 5)
1. **Crear recursos de enemigos**: Enemigos básicos y jefes
2. **Crear recursos de movimientos**: Movimientos básicos y especiales
3. **Configurar por región**: Enemigos específicos por región
4. **Testing de recursos**: Verificar que todos los recursos funcionen

### Fase 6: Integración y Testing (Semana 6)
1. **Integrar con escena Combat**: Conectar factories con la escena existente
2. **Testing completo**: Probar todos los tipos de combate
3. **Optimización**: Mejorar rendimiento y memoria
4. **Documentación**: Completar documentación y ejemplos

### Fase 7: Características Avanzadas (Semana 7-8)
1. **Sistema de dificultad dinámica**: Ajuste automático de dificultad
2. **Sistema de recompensas**: Recompensas configurables
3. **Efectos visuales**: Factory para efectos visuales
4. **Sistema de audio**: Factory para audio de combate

---

## 9. Conclusión

El patrón Factory proporciona una base sólida y escalable para el sistema de combate de *No One's Heart*. Sus principales beneficios incluyen:

- **Reutilización completa** de la escena `Combat.tscn`
- **Configuración dinámica** para cada combate
- **Escalabilidad** para futuras características
- **Mantenibilidad** del código
- **Preparación** para el sistema de cartas

La implementación propuesta sigue los principios SOLID y las mejores prácticas de Godot, asegurando un código limpio, eficiente y fácil de mantener. El sistema está diseñado para crecer con el proyecto y adaptarse a las necesidades futuras del juego.

---

## 10. Referencias y Recursos

- [Godot Documentation - Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)
- [Design Patterns - Factory Pattern](https://refactoring.guru/design-patterns/factory-method)
- [GDScript Best Practices](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Godot Asset Library](https://godotengine.org/asset-library/asset) - Para recursos adicionales