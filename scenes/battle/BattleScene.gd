extends Node

################################################################################
# Constants
################################################################################

const PLAYER_INDEX: int = 0
const ENEMY_INDEX: int = 1

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


func _render_initial_data():
    var p = server.players[PLAYER_INDEX]
    gui.player_nameplate.set_player_name(p.name)
    gui.player_nameplate.set_resources(p.resources, p.max_resources)
    p = server.players[ENEMY_INDEX]
    gui.enemy_nameplate.set_player_name(p.name)
    gui.enemy_nameplate.set_resources(p.resources, p.max_resources)


################################################################################
# Event Handlers
################################################################################


func _ready():
    _default_battle_setup()
    _render_initial_data()
