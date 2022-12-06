extends Node

################################################################################
# Constants
################################################################################

const PLAYER_INDEX: int = 0
const ENEMY_INDEX: int = 1

const TARGET_DUMMY = preload("res://data/minions/TargetDummy.tres")

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
    p.add_army_minion(TARGET_DUMMY)
    p.add_army_minion(TARGET_DUMMY)
    p.add_army_minion(TARGET_DUMMY)
    p.add_army_minion(TARGET_DUMMY)
    p.add_army_minion(TARGET_DUMMY)
    p.add_army_minion(TARGET_DUMMY)
    p.add_active_minion(TARGET_DUMMY)
    server.players.append(p)


func _render_initial_data():
    var p = server.players[PLAYER_INDEX]
    gui.nameplate_player.set_player_name(p.name)
    gui.nameplate_player.set_resources(p.resources, p.max_resources)
    p = server.players[ENEMY_INDEX]
    gui.nameplate_enemy.set_player_name(p.name)
    gui.nameplate_enemy.set_resources(p.resources, p.max_resources)
    for minion in p.active_minions:
        gui.spawn_enemy_minion(minion)


################################################################################
# Event Handlers
################################################################################


func _ready():
    _default_battle_setup()
    _render_initial_data()
    gui.enter_main_phase()
