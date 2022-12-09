extends Reference
class_name BattleMechanics

###############################################################################
# Signals
###############################################################################

signal action_error(msg)
signal deployed_minion(event)

###############################################################################
# Constants
###############################################################################

const MAX_ACTIVE_MINIONS: int = 6

const MSG_BOARD_FULL = "The minion board is full."

###############################################################################
# Internal State
###############################################################################

var players: Array = []
var current_turn: int = 0


###############################################################################
# Interface
###############################################################################


func action_deploy_left(player_index: int, army_index: int):
    var p = players[player_index]
    var minion = p.minion_deck[army_index]
    # FIXME check resources, etc.
    if len(p.active_minions) >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    p.resources -= minion.base_data.supply
    # emit signal
    p.minion_deck.remove(army_index)
    p.insert_active_minion(0, minion.base_data)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = 0
    event.minion = p.active_minions[0]
    emit_signal("deployed_minion", event)


func action_deploy_right(player_index: int, army_index: int):
    var p = players[player_index]
    var minion = p.minion_deck[army_index]
    # FIXME check resources, etc.
    if len(p.active_minions) >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    p.resources -= minion.base_data.supply
    # emit signal
    p.minion_deck.remove(army_index)
    var n = p.add_active_minion(minion.base_data)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = n - 1
    event.minion = p.active_minions[n-1]
    emit_signal("deployed_minion", event)


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


func _action_error(msg: String):
    emit_signal("computed_action", false, msg)
