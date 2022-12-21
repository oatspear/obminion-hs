extends Reference

class_name BattleMinion

################################################################################
# Variables
################################################################################

var base_data: MinionData setget set_base_data

var index: int = -1
var player: int = -1
var active: bool = false
var can_act: bool = false

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


func set_base_data(data: MinionData):
    base_data = data
    tribe = data.tribe
    power = data.power
    max_health = data.health
    health = data.health
    supply = data.supply
    ability = data.ability


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
