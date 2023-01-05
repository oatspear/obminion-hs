extends Node

################################################################################
# Constants
################################################################################

const PLAYER_INDEX: int = 0
const ENEMY_INDEX: int = 1

const TARGET_DUMMY = preload("res://data/minions/TargetDummy.tres")

const PLAYER_DECK = preload("res://data/decks/PlayerDeck.tres")
const ENEMY_DECK = preload("res://data/decks/TargetDummy.tres")

const ERROR_MESSAGES = {
    Global.GameError.BOARD_FULL: "The board is full.",
    Global.GameError.BATTLE_STARTED: "The battle has already started.",
    Global.GameError.NOT_YOUR_TURN: "It is not your turn.",
    Global.GameError.NO_RESOURCES: "Not enough resources.",
}

################################################################################
# Variables
################################################################################

onready var server = $Server
onready var gui = $BattleUI

################################################################################
# Helper Functions
################################################################################


func _default_battle_setup():
    gui.reset_data()

    var data = PLAYER_DECK
    var p: BattlePlayer = server.data.players[PLAYER_INDEX]
    p.set_player_data(data)
    p.commander = BattleCommander.new()
    p.commander.health = 20

    data = ENEMY_DECK
    p = server.data.players[ENEMY_INDEX]
    p.set_player_data(data)
    p.commander = BattleCommander.new()
    p.commander.health = 20

    p.deploy(0, 0)


func _render_initial_data():
    var p = server.data.players[PLAYER_INDEX]
    gui.nameplate_player.set_player_name(p.name)
    gui.nameplate_player.set_resources(p.resources, p.max_resources)
    gui.set_player_commander(p.commander)
    gui.set_player_army(p.army)

    p = server.data.players[ENEMY_INDEX]
    gui.nameplate_enemy.set_player_name(p.name)
    gui.nameplate_enemy.set_resources(p.resources, p.max_resources)
    gui.set_enemy_commander(p.commander)
    for minion in p.battlefield:
        gui.spawn_enemy_minion(minion)


################################################################################
# Event Handlers - Internal
################################################################################


func _ready():
    _default_battle_setup()
    # `start_battle` triggers a state transition
    # will be processed in the next frame
    server.start_battle()


func _on_server_action_error(msg: String):
    print("Error: ", msg)
    gui.show_error(msg)


func _on_server_battle_started(data: BattleData):
    print("[SERVER]: battle started")
    _render_initial_data()


func _on_server_battle_ended(victor_index: int):
    gui.enter_observer_phase()
    if victor_index < 0:
        print("[SERVER]: battle ended on a draw")
        gui.show_notice("The battle ended on a draw.")
    else:
        print("[SERVER]: battle ended; P%d won" % victor_index)
        gui.show_notice("%s won the battle!" % server.data.players[victor_index].name)


func _on_server_turn_started(player_index: int):
    print("[SERVER]: turn started: P%d" % player_index)
    if player_index == PLAYER_INDEX:
        gui.enter_main_phase()
    else:
        # FIXME
        yield(get_tree(), "idle_frame")
        server.action_end_turn(player_index)


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
    print("[SERVER]: minion died: (%d, %d)" % [player_index, field_index])
    gui.animate_minion_death(player_index, field_index)


func _on_server_minion_destroyed(player_index: int, field_index: int):
    print("[SERVER]: minion destroyed: (%d, %d)" % [player_index, field_index])
    if player_index == PLAYER_INDEX:
        gui.remove_from_player_field(field_index)
    else:
        gui.remove_from_enemy_field(field_index)


func _on_server_minion_recruited(player_index: int, minion: BattleMinion):
    print("[SERVER]: minion recruited: (P%d) %s" % [player_index, minion.name])
    if player_index == PLAYER_INDEX:
        gui.add_to_player_army(minion)
    else:
        gui.add_to_enemy_army(minion)


func _on_server_minion_stats_changed(minion: BattleMinion):
    print("[SERVER]: minion stats changed: (P%d) %s" % [minion.player_index, minion.name])
    gui.set_active_minion(minion.player_index, minion.index, minion)


func _on_server_request_select_target(player_index: int, target_mode: int):
    if player_index == PLAYER_INDEX:
        gui.enter_target_phase(target_mode)


################################################################################
# Event Handlers - GUI
################################################################################


func _on_ui_action_attack_target(minion_index: int, target_index: int):
    # gui.enter_observer_phase()
    var error = server.action_attack_target(PLAYER_INDEX, minion_index, ENEMY_INDEX, target_index)
    gui.enter_main_phase()
    if error:
        gui.show_error(ERROR_MESSAGES[error])


func _on_ui_action_deploy_left(army_index: int):
    # gui.enter_observer_phase()
    var error = server.action_deploy_left(PLAYER_INDEX, army_index)
    gui.enter_main_phase()
    if error:
        gui.show_error(ERROR_MESSAGES[error])


func _on_ui_action_deploy_right(army_index: int):
    # gui.enter_observer_phase()
    var error = server.action_deploy_right(PLAYER_INDEX, army_index)
    gui.enter_main_phase()
    if error:
        gui.show_error(ERROR_MESSAGES[error])


func _on_ui_target_selected(index: int):
    # gui.enter_observer_phase()
    var error = server.set_requested_target(index)
    gui.enter_main_phase()
    if error:
        gui.show_error(ERROR_MESSAGES[error])


func _on_ui_action_end_turn():
    gui.enter_observer_phase()
    var error = server.action_end_turn(PLAYER_INDEX)
    if error:
        gui.show_error(ERROR_MESSAGES[error])


func _on_ui_action_forfeit():
    gui.enter_observer_phase()
    var error = server.action_forfeit_game(PLAYER_INDEX)
    if error:
        gui.show_error(ERROR_MESSAGES[error])
