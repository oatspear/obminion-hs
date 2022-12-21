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
var deck_index: int = -1
var deployed: bool = false

# current/modified stats
var tribe: String = "Tribe"
var power: int = 0
var health: int = 0
var supply: int = 0
var ability: int = 0

var effects: Array = []

################################################################################
# Interface
################################################################################


func set_base_data(data: MinionData):
    base_data = data
    tribe = data.tribe
    power = data.power
    health = data.health
    supply = data.supply
    ability = data.ability


func is_deck_minion() -> bool:
    return player_index >= 0 and deck_index >= 0


func is_minion_token() -> bool:
    return not is_deck_minion()
