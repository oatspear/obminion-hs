extends MarginContainer

################################################################################
# Constants
################################################################################

const STR_POPUP_TITLE_END_TURN = "End Turn"
const STR_POPUP_TEXT_END_TURN = "End your turn?"

const STR_POPUP_TITLE_FORFEIT = "Forfeit"
const STR_POPUP_TEXT_FORFEIT = "Forfeit the game?"


enum State { MAIN, TARGET }


################################################################################
# Variables
################################################################################

var state: int = State.MAIN

onready var action_panel = $BattleField/PlayerCommandPanel
onready var minion_row_enemy = $BattleField/Center/MinionField/Top
onready var minion_row_player = $BattleField/Center/MinionField/Bottom
onready var dialog_confirm: ConfirmationDialog = $Popups/Confirm
onready var popup_card_info = $Popups/InfoCardPopup

var _selected_minion: WeakRef = weakref(null)
var _selection_targets: Array = []

################################################################################
# Interface
################################################################################


func enter_main_phase():
    state = State.MAIN
    minion_row_enemy.reset_minion_selection()
    minion_row_enemy.enable_minion_selection(true)
    minion_row_player.reset_minion_selection()
    minion_row_player.enable_minion_selection(true)


func enter_target_phase(mode: int):
    match mode:
        Global.TargetMode.ATTACK_TARGET:
            if minion_row_enemy.get_minion_count() == 0:
                print("There are no targets to attack.")
            else:
                state = State.TARGET
                assert(_selected_minion.get_ref() in minion_row_player.minions)
                _target_state_enable_targets(minion_row_enemy.minions)


################################################################################
# State - Main
################################################################################


func _on_main_state_minion_selected(minion: Control, friendly: bool):
    var prev = _selected_minion.get_ref()
    _selected_minion = weakref(minion)
    if prev != null and prev != minion:
        prev.set_selected(false)
    action_panel.show_minion_action_bar(minion.minion_data, friendly)


func _on_main_state_minion_deselected(minion):
    var prev = _selected_minion.get_ref()
    if prev != null and prev == minion:
        _selected_minion = weakref(null)
        action_panel.show_main_command_card()


################################################################################
# State - Target
################################################################################


func _target_state_enable_targets(minions):
    _selection_targets = []
    minion_row_enemy.disable_minion_selection()
    minion_row_player.disable_minion_selection()
    for minion in minions:
        minion.set_selected(false)
        minion.set_retain_selection(false)
        minion.set_selectable(true)
        minion.set_highlighted(true)
        _selection_targets.append(minion)


func _on_target_state_minion_selected(minion):
    print("Selected %s as a target" % minion.name)


################################################################################
# Event Handlers
################################################################################


func _ready():
    enter_main_phase()
    for _i in 3:
        minion_row_enemy.append_minion({
            "name": "Minion",
            "type": Global.CardType.MINION,
            "faction": "Enemies",
            "tribe": "Enemy",
            "species": 0,
            "power": 2,
            "health": 10,
            "cost": 2,
            "resource": Global.ResourceType.RESOURCES,
            "effect": 0,
            "effect_text": "A target dummy that does nothing.",
        })


func _on_ActionPanel_use_support(_index):
    pass # Replace with function body.


func _on_ActionPanel_end_turn():
    dialog_confirm.window_title = STR_POPUP_TITLE_END_TURN
    dialog_confirm.dialog_text = STR_POPUP_TEXT_END_TURN
    dialog_confirm.popup()


func _on_ActionPanel_forfeit_game():
    dialog_confirm.window_title = STR_POPUP_TITLE_FORFEIT
    dialog_confirm.dialog_text = STR_POPUP_TEXT_FORFEIT
    dialog_confirm.popup()


func _on_show_card_info(data):
    popup_card_info.set_display_data(data)
    #popup_card_info.popup_centered()
    popup_card_info.show()


func _on_hide_card_info():
    if popup_card_info:
        popup_card_info.hide()


func _on_deploy_minion(minion_data: Dictionary, right_side: bool):
    _on_hide_card_info()
    action_panel.show_main_command_card()
    var ok = true
    if right_side:
        ok = minion_row_player.append_minion(minion_data)
    else:
        ok = minion_row_player.preprend_minion(minion_data)
    if not ok:
        print("The minion board is full.")


func _on_deselect_minions():
    match state:
        State.MAIN:
            minion_row_enemy.reset_minion_selection()
            minion_row_player.reset_minion_selection()


func _on_select_targets(mode: int):
    enter_target_phase(mode)


func _on_player_minion_selected(minion):
    match state:
        State.MAIN:
            _on_main_state_minion_selected(minion, true)
        State.TARGET:
            _on_target_state_minion_selected(minion)


func _on_player_minion_deselected(minion):
    match state:
        State.MAIN:
            _on_main_state_minion_deselected(minion)


func _on_enemy_minion_selected(minion):
    match state:
        State.MAIN:
            _on_main_state_minion_selected(minion, false)
        State.TARGET:
            _on_target_state_minion_selected(minion)


func _on_enemy_minion_deselected(minion):
    match state:
        State.MAIN:
            _on_main_state_minion_deselected(minion)
