extends Reference
class_name BattlePlayer

################################################################################
# Variables
################################################################################

var name: String = "Player"

var resources: int = 0
var max_resources: int = 1

var minion_deck: Array = []
var support_deck: Array = []

var active_minions: Array = []

var graveyard: Array = []
var graveyard_size: int = 0

var commander: BattleCommander

################################################################################
# Interface
################################################################################


func replenish_resources():
    resources = max_resources


func add_army_minion(base_data: MinionData) -> int:
    var minion = ArmyMinion.new()
    minion.base_data = base_data
    minion_deck.append(minion)
    return len(minion_deck)


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
