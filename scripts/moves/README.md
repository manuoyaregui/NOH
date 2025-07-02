# Sistema de Movimientos

Este sistema maneja todos los movimientos del juego usando recursos de Godot (.tres files) para máxima flexibilidad y facilidad de edición.

## Estructura

```
scripts/moves/
├── Move.gd                    # Clase base para todos los movimientos
├── MoveData.gd                # Recurso que define los datos de un movimiento
├── MoveFactory.gd             # Factory para crear movimientos desde recursos
├── move_types/                # Implementaciones específicas por tipo
│   ├── OffensiveMove.gd
│   ├── DefensiveMove.gd
│   └── SpecialMove.gd
└── resources/                 # Recursos de movimientos (.tres files)
    ├── offensive/
    │   ├── basic_attack.tres
    │   └── fire_strike.tres
    ├── defensive/
    │   ├── defend.tres
    │   └── heal.tres
    └── special/
        └── void_pull.tres
```

## Cómo crear un nuevo movimiento

### 1. Crear el recurso (.tres file)

1. En Godot Editor, ve a `scripts/moves/resources/[tipo]/`
2. Click derecho → New Resource → MoveData
3. Configura los campos:
   - **move_id**: Identificador único en formato UPPER_SNAKE_CASE (ej: "FIRE_STRIKE")
   - **move_name**: Nombre del movimiento para mostrar
   - **move_type**: OFFENSIVE (0), DEFENSIVE (1), SPECIAL (2)
   - **damage**: Daño base (solo para ofensivos)
   - **defense**: Defensa base (solo para defensivos)
   - **accuracy**: Precisión (0-100)
   - **special_effects**: Array de efectos especiales
   - **animation_name**: Nombre de la animación
   - **cooldown_turns**: Turnos de cooldown
   - **target_type**: "SINGLE", "ALL", "SELF"

### 2. Guardar el recurso

Guarda el archivo con el nombre en formato snake_case:

- `basic_attack.tres`
- `fire_strike.tres`
- `void_pull.tres`

### 3. Usar el movimiento

```gdscript
# Crear movimiento desde ID (recomendado)
var move = MoveFactory.create_move_by_id("FIRE_STRIKE")

# Crear múltiples movimientos desde IDs
var moves = MoveFactory.create_moves_from_ids(["BASIC_ATTACK", "DEFEND", "HEAL"])

# Crear desde recurso directo
var move = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/fire_strike.tres")

# Crear desde nombre (legacy, no recomendado)
var move = MoveFactory.create_move_by_name("Fire Strike")
```

## Tipos de Movimientos

### Offensive

- **Propósito**: Causar daño al enemigo
- **Campo principal**: `damage`
- **Ejemplos**: BASIC_ATTACK, FIRE_STRIKE

### Defensive

- **Propósito**: Proteger o curar
- **Campo principal**: `defense` o efectos de curación
- **Ejemplos**: DEFEND, HEAL

### Special

- **Propósito**: Efectos únicos y especiales
- **Campo principal**: `special_effects`
- **Ejemplos**: VOID_PULL

## Efectos Especiales

Los efectos especiales se definen como strings en el array `special_effects`:

- `"BURN"`: Quema al objetivo
- `"HEAL"`: Cura al usuario
- `"VOID_PULL"`: Atrae al objetivo

## Convenciones de Nomenclatura

- **move_id**: UPPER_SNAKE_CASE (ej: `"FIRE_STRIKE"`)
- **Archivos**: snake_case (ej: `fire_strike.tres`)
- **Nombres**: Title Case (ej: "Fire Strike")
- **Animaciones**: snake_case (ej: `fire_attack`)
- **Efectos**: UPPER_SNAKE_CASE (ej: `"BURN"`)

## IDs de Movimientos Disponibles

### Offensive

- `BASIC_ATTACK`: Ataque básico
- `FIRE_STRIKE`: Golpe de fuego con efecto quemadura

### Defensive

- `DEFEND`: Defensa básica
- `HEAL`: Curación

### Special

- `VOID_PULL`: Atracción del vacío

## Ventajas del Sistema de Recursos

1. **Editor de Godot**: Edición visual de movimientos
2. **Versionado**: Los archivos .tres se versionan mejor
3. **Escalabilidad**: Fácil agregar nuevos movimientos
4. **Consistencia**: Un solo sistema para todos los movimientos
5. **Mantenimiento**: Cambios sin tocar código
6. **Identificación única**: IDs únicos para referencias consistentes

## Uso en Configuraciones

Para usar movimientos en configuraciones de entidades:

```gdscript
# En SimpleEntityConfig
var config = SimpleEntityConfig.new()
config.moves = ["BASIC_ATTACK", "DEFEND", "HEAL"]  # Usar IDs
```

## Funciones Útiles

```gdscript
# Obtener lista de IDs disponibles
var available_ids = MoveFactory.get_available_move_ids()

# Obtener lista de nombres disponibles
var available_names = MoveFactory.get_available_moves()

# Crear movimientos por defecto
var default_moves = MoveFactory.create_default_moves()
```
