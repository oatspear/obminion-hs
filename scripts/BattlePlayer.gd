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
