extends Reference

class_name MinionInstance

################################################################################
# Variables
################################################################################

# species and base stats
var base_data: MinionData setget set_base_data

# metadata
var index: int = -1
var player_index: int = -1
var original_player_index: int = -1
var deck_index: int = -1
var board_location: int = Global.BoardLocation.NONE

# current/modified stats
var name: String = "Minion"
var tribe: String = "Tribe"

var _base_power: int = 0
var _bonus_power: int = 0
var power: int = 0 setget set_power

var _base_health: int = 0
var _bonus_health: int = 0
var health: int = 0

var supply: int = 0
var ability: int = 0
var battlecry: int = 0
var deathrattle: int = 0

var effects: Array = []

################################################################################
# Interface
################################################################################


func reset():
    name = base_data.name
    tribe = base_data.tribe
    set_power(base_data.power)
    set_health(base_data.health)
    supply = base_data.supply
    ability = base_data.ability
    battlecry = base_data.battlecry
    deathrattle = base_data.deathrattle


func set_base_data(data: MinionData):
    base_data = data
    reset()


func set_power(value: int) -> void:
    # overrides species' base stat and current bonuses
    _base_power = value
    _bonus_power = 0
    power = value


func set_health(value: int) -> void:
    # overrides species' base stat and current bonuses
    _base_health = value
    _bonus_health = 0
    health = value


func is_deck_minion() -> bool:
    return player_index >= 0 and deck_index >= 0


func is_minion_token() -> bool:
    return not is_deck_minion()


func calculate_power() -> void:
    var value = _base_power + _bonus_power
    power = 0 if value < 0 else value


func calculate_health() -> void:
    var value = _base_health + _bonus_health
    health = 0 if value < 0 else value


func apply_power_modifier(amount: int) -> void:
    _bonus_power += amount
    calculate_power()


func apply_health_modifier(amount: int) -> void:
    _bonus_health += amount
    calculate_health()


func move_to_army(army_index: int):
    index = army_index
    board_location = Global.BoardLocation.BASE


func move_to_battlefield(field_index: int):
    index = field_index
    board_location = Global.BoardLocation.BATTLEFIELD


func move_to_graveyard(grave_index: int):
    index = grave_index
    board_location = Global.BoardLocation.GRAVEYARD


################################################################################
# Data Transformation Interface
################################################################################


func as_minion_data() -> MinionData:
    var data = MinionData.new()
    data.name = name
    data.faction = base_data.faction
    data.tribe = tribe
    data.species = base_data.species
    data.power = power
    data.health = health
    data.supply = supply
    data.ability = ability
    data.ability_text = base_data.ability_text  # FIXME
    return data


func as_dict() -> Dictionary:
    return {
        "name": name,
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
