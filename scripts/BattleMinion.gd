extends Reference

class_name BattleMinion

################################################################################
# Variables
################################################################################

# species, instance and base stats
var instance: MinionInstance setget set_minion_instance

# indices and metadata
var index: int = -1
var player_index: int = -1
var action_timer: int = 0

# battle-specific variables
var damage: int = 0  # taken

################################################################################
# Interface
################################################################################


func get_name() -> String:
    return instance.name


func get_tribe() -> String:
    return instance.tribe


func get_supply() -> int:
    return instance.supply


func get_power() -> int:
    return instance.power


func get_health() -> int:
    return instance.health


func get_current_health() -> int:
    return instance.health - damage


func get_ability() -> int:
    return instance.ability


func set_minion_instance(minion_instance: MinionInstance):
    instance = minion_instance


func is_deck_minion() -> bool:
    return instance.is_deck_minion()


func is_minion_token() -> bool:
    return instance.is_minion_token()


func has_haste() -> bool:
    return bool(instance.ability & Global.Abilities.HASTE)


func has_poison() -> bool:
    return bool(instance.ability & Global.Abilities.POISON)


################################################################################
# Data Transformation Interface
################################################################################


func as_dict() -> Dictionary:
    return {
        "name": get_name(),
        "type": Global.CardType.MINION,
        "faction": instance.base_data.faction,
        "tribe": get_tribe(),
        "species": instance.base_data.species,
        "power": get_power(),
        "health": get_health(),
        "cost": get_supply(),
        "resource": Global.ResourceType.RESOURCES,
        "effect": get_ability(),
        "effect_text": instance.base_data.ability_text,
    }
