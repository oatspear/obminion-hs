extends Reference
class_name BattleMechanics

###############################################################################
# Internal State
###############################################################################

var players: Array = []
var current_turn: int = 0


###############################################################################
# Interface
###############################################################################


func action_attack_target(
    player_index: int,
    minion_index: int,
    enemy_index: int,
    target_index: int
):
    var p1 = players[player_index]
    var p2 = players[enemy_index]
    var source = p1.active_minions[minion_index]
    var target = p2.active_minions[target_index]
    target.health -= source.power
    source.health -= target.power


###############################################################################
# Helper Functions
###############################################################################
