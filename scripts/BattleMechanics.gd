extends Reference

const BPlayer = preload("res://scripts/BattlePlayer.gd")

###############################################################################
# Internal State
###############################################################################

var players: Array = []
var current_turn: int = 0


###############################################################################
# Interface
###############################################################################

func set_players(p1, p2):
    players = [_battle_player_from_data(p1), _battle_player_from_data(p2)]


###############################################################################
# Helper Functions
###############################################################################

func _battle_player_from_data(player_data):
    return BPlayer.new()
