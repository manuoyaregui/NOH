# Move System Implementation

This directory contains the implementation of the move system for the combat mechanics, following the Factory Pattern as outlined in the design document.

## Structure

```
scripts/moves/
├── MoveData.gd              # Resource class for move data
├── Move.gd                  # Base move class
├── MoveFactory.gd           # Factory for creating moves
├── MoveSystemTest.gd        # Test and example usage
├── move_types/              # Specific move type implementations
│   ├── OffensiveMove.gd     # Offensive moves (damage)
│   ├── DefensiveMove.gd     # Defensive moves (defense/healing)
│   └── SpecialMove.gd       # Special moves (unique effects)
└── resources/               # Move data resources
    ├── offensive/           # Offensive move resources
    ├── defensive/           # Defensive move resources
    └── special/             # Special move resources
```

## Key Components

### MoveData

Resource class that defines the structure for move data:

- `move_name`: Display name of the move
- `move_type`: Type of move (OFFENSIVE, DEFENSIVE, SPECIAL)

- `damage`: Base damage for offensive moves
- `defense`: Defense bonus for defensive moves
- `special_effects`: Array of special effect strings
- `animation_name`: Animation to play when using the move
- `cooldown_turns`: Number of turns before the move can be used again
- `target_type`: Target type (SINGLE, ALL, SELF)

### Move (Base Class)

Base class for all moves with common functionality:

- Cooldown management
- Move validation
- Effect application
- Move execution logic

### Move Types

#### OffensiveMove

- Applies damage to targets
- Supports special effects: BURN, STUN, BLEED, CRITICAL, PIERCE
- Calculates final damage with attack bonuses

#### DefensiveMove

- Provides defense buffs
- Supports special effects: HEAL, CLEANSE, SHIELD, REFLECT, COUNTER
- Can heal the caster

#### SpecialMove

- Unique effects and interactions
- Supports complex effects: LIFESTEAL, ENERGY_DRAIN, SWAP_STATS, MIRROR, TIME_WARP, REALITY_SHIFT, VOID_PULL, MEMORY_ERASE, PSYCHIC_LINK

### MoveFactory

Factory class that creates moves based on MoveData:

- `create_moves()`: Creates multiple moves from MoveData array
- `create_default_moves()`: Creates basic moves for fallback
- `create_move_from_resource()`: Creates move from resource file
- `create_move_by_name()`: Creates move by searching resources

## Usage Examples

### Creating Moves from Resources

```gdscript
# Create a specific move
var fire_strike = MoveFactory.create_move_from_resource("res://scripts/moves/resources/offensive/fire_strike.tres")

# Create moves for an entity
var player_moves = MoveSystemTest.create_player_moves()
```

### Using Moves in Combat

```gdscript
# Check if move can be used
if move.can_use(entity):
    # Execute the move
    move.execute(caster, target)
```

### Creating Custom Moves

```gdscript
# Create move data programmatically
var custom_move_data = MoveData.new()
custom_move_data.move_name = "Custom Attack"
custom_move_data.move_type = MoveData.MoveType.OFFENSIVE
custom_move_data.damage = 20

custom_move_data.special_effects = ["BURN"]

# Create the move
var custom_move = MoveFactory._create_move_by_type(custom_move_data)
```

## Special Effects

### Offensive Effects

- **BURN**: Applies burn status for 3 turns
- **STUN**: Applies stun status for 1 turn
- **BLEED**: Applies bleed status for 2 turns
- **CRITICAL**: Critical hit (damage calculation)
- **PIERCE**: Ignores defense (damage calculation)

### Defensive Effects

- **HEAL**: Heals caster for half the defense value
- **CLEANSE**: Removes all status effects
- **SHIELD**: Applies shield status for 2 turns
- **REFLECT**: Applies reflect status for 1 turn
- **COUNTER**: Applies counter status for 1 turn

### Special Effects

- **LIFESTEAL**: Heals caster for half the damage dealt

- **SWAP_STATS**: Temporarily swaps attack/defense stats
- **MIRROR**: Copies target's last used move
- **TIME_WARP**: Resets all cooldowns
- **REALITY_SHIFT**: Changes target's move type temporarily
- **VOID_PULL**: Forces target to use specific move
- **MEMORY_ERASE**: Removes target's last used move
- **PSYCHIC_LINK**: Shares damage between caster and target

## Testing

Run the test system to verify functionality:

```gdscript
MoveSystemTest.test_move_system()
```

This will test:

1. Creating moves from resources
2. Creating default moves
3. Move properties and data
4. Cooldown system functionality

## Integration with Combat System

The move system integrates with the CombatEntity class:

- Moves are stored in the `moves` array
- `get_available_moves()` returns moves that can be used
- `use_move()` executes a move
- `update_turn()` updates cooldowns and effects

## Future Extensions

The system is designed to be easily extensible:

- New move types can be added by extending the Move class
- New special effects can be added to existing move types
- Resource-based configuration allows easy balancing
- Factory pattern supports dynamic move creation
