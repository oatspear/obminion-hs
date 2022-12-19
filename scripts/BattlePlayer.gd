extends Reference
class_name BattlePlayer

################################################################################
# Variables
################################################################################

var index: int = 0
var name: String = "Player"

var resources: int = Global.DEFAULT_STARTING_RESOURCES
var max_resources: int = Global.DEFAULT_MAX_RESOURCES

var player_data: PlayerData setget set_player_data

var active_minions: Array = []
var army: Array = []
var graveyard: Array = []
var graveyard_size: int = 0

var commander: BattleCommander

################################################################################
# Interface
################################################################################


func set_player_data(data: PlayerData):
    player_data = data
    reset()


func reset():
    name = player_data.name
    resources = player_data.resources
    max_resources = player_data.max_resources
    graveyard_size = player_data.graveyard_size
    active_minions = []
    graveyard = []
    army = []
    for base_data in player_data.minions:
        var minion = BattleMinion.new()
        minion.base_data = base_data
        army.append(minion)


func replenish_resources():
    resources = max_resources


func add_army_minion(data: MinionData) -> int:
    var minion = BattleMinion.new()
    minion.set_base_data(data)
    army.append(minion)
    return len(army)


func add_active_minion(data: MinionData) -> int:
    var minion = BattleMinion.new()
    minion.set_base_data(data)
    active_minions.append(minion)
    return len(active_minions)


func insert_active_minion(index: int, data: MinionData) -> int:
    var minion = BattleMinion.new()
    minion.set_base_data(data)
    active_minions.insert(index, minion)
    return len(active_minions)


func add_to_graveyard(data: MinionData) -> bool:
    if len(graveyard) >= graveyard_size:
        return false
    graveyard.append(data)
    return true


func rotate_graveyard_to_army():
    print("Rotate %s from graveyard" % (graveyard[0].name if graveyard else "nothing"))
    var minion = graveyard.pop_front()
    if minion != null:
        add_army_minion(minion)
    return minion
