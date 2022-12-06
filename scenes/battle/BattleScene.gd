extends Node

################################################################################
# Constants
################################################################################

const PLAYER_INDEX: int = 0
const ENEMY_INDEX: int = 1

const MINION1 = preload("res://data/minions/Minion1.tres")
const MINION2 = preload("res://data/minions/Minion2.tres")
const MINION3 = preload("res://data/minions/Minion3.tres")
const MINION4 = preload("res://data/minions/Minion4.tres")
const MINION5 = preload("res://data/minions/Minion5.tres")
const MINION6 = preload("res://data/minions/Minion6.tres")
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
    gui.reset_data()

    var p = BattlePlayer.new()
    p.name = "Player 1"
    p.max_resources = 5
    p.add_army_minion(MINION1)
    p.add_army_minion(MINION2)
    p.add_army_minion(MINION3)
    p.add_army_minion(MINION4)
    p.add_army_minion(MINION5)
    p.add_army_minion(MINION6)
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
    gui.set_player_army(p.minion_deck)

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


func _on_ui_action_attack_target(minion_index: int, target_index: int):
    server.action_attack_target(PLAYER_INDEX, minion_index, ENEMY_INDEX, target_index)
    gui.animate_attack(PLAYER_INDEX, minion_index, ENEMY_INDEX, target_index)
    gui.animate_damage(ENEMY_INDEX, target_index, 0)
    gui.animate_damage(PLAYER_INDEX, minion_index, 0)
    var p = server.players[PLAYER_INDEX]
    var m = p.active_minions[minion_index]
    gui.set_active_minion(PLAYER_INDEX, minion_index, m)
    p = server.players[ENEMY_INDEX]
    m = p.active_minions[target_index]
    gui.set_active_minion(ENEMY_INDEX, target_index, m)
