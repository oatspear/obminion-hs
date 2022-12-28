extends Reference

class_name BattleData

###############################################################################
# Signals
###############################################################################


###############################################################################
# Internal State
###############################################################################

var players: Array = [
    BattlePlayer.new(),
    BattlePlayer.new(),
]

var current_turn: int = 0

###############################################################################
# Interface
###############################################################################


func switch_turns():
    current_turn = (current_turn + 1) % players.size()


###############################################################################
# Helper Functions
###############################################################################


func _init():
    for i in range(len(players)):
        players[i].index = i
