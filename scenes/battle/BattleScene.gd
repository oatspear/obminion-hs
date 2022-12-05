extends Node

################################################################################
# Variables
################################################################################

onready var server: BattleMechanics = BattleMechanics.new()
onready var gui = $BattleUI

################################################################################
# Helper Functions
################################################################################


func _default_battle_setup():
    var p = BattlePlayer.new()
    p.name = "Player 1"
    p.max_resources = 5
    server.players.append(p)
    p = BattlePlayer.new()
    p.name = "Player 2"
    p.max_resources = 5
    server.players.append(p)


################################################################################
# Event Handlers
################################################################################


func _ready():
    _default_battle_setup()
