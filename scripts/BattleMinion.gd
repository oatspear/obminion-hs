extends Reference

class_name BattleMinion

################################################################################
# Variables
################################################################################

# species, instance and base stats
var instance: MinionInstance setget set_minion_instance

# indices and metadata
var action_timer: int = 0

# battle-specific variables
var damage: int = 0  # taken
var _aura_power: int = 0
var _aura_health: int = 0

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
    var value = instance.power + _aura_power
    return 0 if value < 0 else value


func get_health() -> int:
    var value = instance.health + _aura_health
    return 0 if value < 0 else value


func get_current_health() -> int:
    return get_health() - damage


func get_ability() -> int:
    return instance.ability


func set_minion_instance(minion_instance: MinionInstance):
    instance = minion_instance


func is_deck_minion() -> bool:
    return instance.is_deck_minion()


func is_minion_token() -> bool:
    return instance.is_minion_token()


func has_ability(ability: int) -> bool:
    return bool(instance.ability & ability)


func apply_power_modifier(amount: int) -> void:
    instance.apply_power_modifier(amount)


func apply_health_modifier(amount: int) -> void:
    instance.apply_health_modifier(amount)


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
