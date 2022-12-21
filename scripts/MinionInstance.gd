extends Reference

class_name MinionInstance

################################################################################
# Variables
################################################################################

var base_data: MinionData setget set_base_data

var index: int = -1
var player_index: int = -1
var deployed: bool = false

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
