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
