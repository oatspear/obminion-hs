extends Reference

class_name BattleMinion

################################################################################
# Variables
################################################################################

# species, instance and base stats
var instance: MinionInstance setget set_minion_instance
var base_data: MinionData setget set_base_data

# indices and metadata
var index: int = -1
var player_index: int = -1
var active: bool = false
var can_act: bool = false

# current/modified stats
var name: String = "Minion"
var tribe: String = "Tribe"
var power: int = 0
var health: int = 0
var max_health: int = 0
var supply: int = 0
var ability: int = 0

var effects: Array = []

################################################################################
# Interface
################################################################################


func set_minion_instance(minion_instance: MinionInstance):
    instance = minion_instance
    set_base_data(instance.base_data)


func set_base_data(data: MinionData):
    base_data = data
    name = data.name
    tribe = data.tribe
    power = data.power
    max_health = data.health
    health = data.health
    supply = data.supply
    ability = data.ability


func is_deck_minion() -> bool:
    return instance.is_deck_minion()


func is_minion_token() -> bool:
    return instance.is_minion_token()


func as_dict() -> Dictionary:
    return {
        "name": base_data.name,
        "type": Global.CardType.MINION,
        "faction": base_data.faction,
        "tribe": tribe,
        "species": base_data.species,
        "power": power,
        "health": health,
        "cost": supply,
        "resource": Global.ResourceType.RESOURCES,
        "effect": ability,
        "effect_text": base_data.ability_text,
    }
