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

const PLAYER_DECK = preload("res://data/decks/PlayerDeck.tres")
const ENEMY_DECK = preload("res://data/decks/TargetDummy.tres")

################################################################################
# Variables
################################################################################

# onready var server: BattleMechanics = BattleMechanics.new()
onready var server = $Server
onready var gui = $BattleUI

################################################################################
# Helper Functions
################################################################################


#func _connect_to_mechanics_events():
#    var error = server.connect("action_error", self, "_on_server_action_error")
#    assert(not error)
#    error = server.connect("resources_changed", self, "_on_server_resources_changed")
#    assert(not error)
#    error = server.connect("minion_deployed", self, "_on_server_minion_deployed")
#    assert(not error)
#    error = server.connect("minion_attacked", self, "_on_server_minion_attacked")
#    assert(not error)
#    error = server.connect("damage_dealt", self, "_on_server_damage_dealt")
#    assert(not error)
#    error = server.connect("minion_died", self, "_on_server_minion_died")
#    assert(not error)
#    error = server.connect("minion_destroyed", self, "_on_server_minion_destroyed")
#    assert(not error)
#    error = server.connect("minion_recruited", self, "_on_server_minion_recruited")
#    assert(not error)


func _default_battle_setup():
    gui.reset_data()

    var data = PLAYER_DECK
    # data.reset()  # this reset is needed so the resource does not share references
    var p = server.data.players[PLAYER_INDEX]
    p.set_player_data(data)
    #p.player_data = data
    #p.reset()
    #p.add_army_minion(MINION1)
    #p.add_army_minion(MINION2)
    #p.add_army_minion(MINION3)
    #p.add_army_minion(MINION4)
    #p.add_army_minion(MINION5)
    #p.add_army_minion(MINION6)
    assert(len(data.minions) == 6)

    data = ENEMY_DECK
    # data.reset()  # this reset is needed so the resource does not share references
    p = server.data.players[ENEMY_INDEX]
    p.set_player_data(data)
    #p.player_data = data
    #p.reset()
    #p.add_army_minion(TARGET_DUMMY)
    #p.add_army_minion(TARGET_DUMMY)
    #p.add_army_minion(TARGET_DUMMY)
    #p.add_army_minion(TARGET_DUMMY)
    #p.add_army_minion(TARGET_DUMMY)
    #p.add_army_minion(TARGET_DUMMY)
    p.add_active_minion(TARGET_DUMMY)
    assert(server.data.players[PLAYER_INDEX] != server.data.players[ENEMY_INDEX])
    assert(len(data.minions) == 6)


func _render_initial_data():
    var p = server.data.players[PLAYER_INDEX]
    gui.nameplate_player.set_player_name(p.name)
    gui.nameplate_player.set_resources(p.resources, p.max_resources)
    gui.set_player_army(p.player_data.minions)

    p = server.data.players[ENEMY_INDEX]
    gui.nameplate_enemy.set_player_name(p.name)
    gui.nameplate_enemy.set_resources(p.resources, p.max_resources)
    for minion in p.active_minions:
        gui.spawn_enemy_minion(minion)


################################################################################
# Event Handlers - Internal
################################################################################


func _ready():
    #_connect_to_mechanics_events()
    _default_battle_setup()
    _render_initial_data()
    gui.enter_main_phase()


func _on_server_action_error(msg: String):
    print("Error: ", msg)
    gui.show_error(msg)


func _on_server_resources_changed(player_index: int, current: int, maximum: int):
    if player_index == PLAYER_INDEX:
        gui.set_player_resources(current, maximum)
    else:
        gui.set_enemy_resources(current, maximum)


func _on_server_minion_deployed(event: BattleEventDeploy):
    if event.player_index == PLAYER_INDEX:
        gui.remove_from_player_army(event.army_index)
        gui.spawn_player_minion(event.minion, event.field_index)
    else:
        gui.spawn_enemy_minion(event.minion, event.field_index)


func _on_server_minion_attacked(event: BattleEventAttack):
    gui.animate_attack(
        event.player_index,
        event.field_index,
        event.enemy_index,
        event.target_index
    )


func _on_server_damage_dealt(event: BattleEventDamage):
    gui.animate_damage(event.player_index, event.field_index, event.damage)


func _on_server_minion_died(player_index: int, field_index: int):
    gui.animate_minion_death(player_index, field_index)


func _on_server_minion_destroyed(player_index: int, field_index: int):
    if player_index == PLAYER_INDEX:
        gui.remove_from_player_field(field_index)
    else:
        gui.remove_from_enemy_field(field_index)


func _on_server_minion_recruited(player_index: int, minion: MinionData):
    if player_index == PLAYER_INDEX:
        gui.add_to_player_army(minion)
    else:
        gui.add_to_enemy_army(minion)


################################################################################
# Event Handlers - GUI
################################################################################


func _on_ui_action_attack_target(minion_index: int, target_index: int):
    server.action_attack_target(PLAYER_INDEX, minion_index, ENEMY_INDEX, target_index)
    #gui.animate_attack(PLAYER_INDEX, minion_index, ENEMY_INDEX, target_index)
    #gui.animate_damage(ENEMY_INDEX, target_index, 0)
    #gui.animate_damage(PLAYER_INDEX, minion_index, 0)
    #var p = server.data.players[PLAYER_INDEX]
    #var m = p.active_minions[minion_index]
    #gui.set_active_minion(PLAYER_INDEX, minion_index, m)
    #p = server.data.players[ENEMY_INDEX]
    #m = p.active_minions[target_index]
    #gui.set_active_minion(ENEMY_INDEX, target_index, m)


func _on_ui_action_deploy_left(army_index: int):
    server.action_deploy_left(PLAYER_INDEX, army_index)


func _on_ui_action_deploy_right(army_index: int):
    server.action_deploy_right(PLAYER_INDEX, army_index)
