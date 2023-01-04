extends Reference
class_name BattleCommander

################################################################################
# Variables
################################################################################

# metadata
var player_index: int = -1

# stats
var power: int = 0
var health: int = 0

# abilities
var ability: int = 0
var effects: Array = []

# battle-specific variables
var damage: int = 0  # taken
var divine_shield: bool = false

################################################################################
# Data Transformation Interface
################################################################################


func as_dict() -> Dictionary:
    return {
        "name": "Commander",
        "type": Global.CardType.COMMANDER,
        "faction": "FIXME",
        "power": power,
        "health": health,
        "damage": damage,
    }
