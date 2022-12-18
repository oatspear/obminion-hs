extends Reference
class_name BattlePlayer

################################################################################
# Variables
################################################################################

var index: int = 0
var name: String = "Player"

var resources: int = Global.DEFAULT_STARTING_RESOURCES
var max_resources: int = Global.DEFAULT_MAX_RESOURCES

var player_data: PlayerData

var active_minions: Array = []
var army: Array = []
var graveyard: Array = []
var graveyard_size: int = 0

var commander: BattleCommander

################################################################################
# Interface
################################################################################


func reset():
    name = player_data.name
    resources = player_data.resources
    max_resources = player_data.max_resources
    graveyard_size = player_data.graveyard_size


func replenish_resources():
    resources = max_resources


func add_army_minion(base_data: MinionData) -> int:
    var minion = ArmyMinion.new()
    minion.base_data = base_data
    player_data.minions.append(minion)
    return len(player_data.minions)


func add_active_minion(base_data: MinionData) -> int:
    var minion = BattleMinion.new()
    minion.base_data = base_data
    active_minions.append(minion)
    return len(active_minions)


func insert_active_minion(index: int, base_data: MinionData) -> int:
    var minion = BattleMinion.new()
    minion.base_data = base_data
    active_minions.insert(index, minion)
    return len(active_minions)


func add_to_graveyard(base_data: MinionData) -> bool:
    if len(graveyard) >= graveyard_size:
        return false
    graveyard.append(base_data)
    return true


func rotate_graveyard_to_army():
    print("Rotate %s from graveyard" % (graveyard[0] if graveyard else "nothing"))
    var minion = graveyard.pop_front()
    if minion != null:
        add_army_minion(minion)
    return minion
