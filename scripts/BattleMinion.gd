extends Reference

class_name BattleMinion

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
var health: int = 0 setget set_health

var supply: int = 0
var ability: int = 0
var battlecry: int = 0
var deathrattle: int = 0

var effects: Array = []

# battle-specific variables
var action_timer: int = 0
var damage: int = 0  # taken
var divine_shield: bool = false
var _aura_power: int = 0
var _aura_health: int = 0


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


func reset_battle_variables():
    action_timer = 0
    damage = 0
    divine_shield = false
    _aura_power = 0
    _aura_health = 0


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
    var value = _base_power + _bonus_power + _aura_power
    power = 0 if value < 0 else value


func calculate_health() -> void:
    var value = _base_health + _bonus_health + _aura_health
    health = 0 if value < 0 else value


func get_current_health() -> int:
    return health - damage


func has_ability(ability: int) -> bool:
    return bool(self.ability & ability)


func apply_power_modifier(amount: int) -> void:
    _bonus_power += amount
    calculate_power()


func apply_health_modifier(amount: int) -> void:
    _bonus_health += amount
    calculate_health()


func apply_power_aura(amount: int) -> void:
    _aura_power += amount
    calculate_power()


func apply_health_aura(amount: int) -> void:
    _aura_health += amount
    calculate_health()


func move_to_army(army_index: int):
    index = army_index
    board_location = Global.BoardLocation.BASE
    reset_battle_variables()


func move_to_battlefield(field_index: int):
    index = field_index
    board_location = Global.BoardLocation.BATTLEFIELD


func move_to_graveyard(grave_index: int):
    index = grave_index
    board_location = Global.BoardLocation.GRAVEYARD
    reset()
    reset_battle_variables()


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
        "shield": divine_shield,
        "poison": has_ability(Global.Abilities.POISON),
        "deathrattle": deathrattle,
        "bonus_power": _bonus_power + _aura_power,
        "bonus_health": _bonus_health + _aura_health,
    }
