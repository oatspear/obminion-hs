extends MarginContainer

################################################################################
# Signals
################################################################################

signal action_deploy_left(army_index)
signal action_deploy_right(army_index)
signal action_attack_target(minion_index, target_index)

################################################################################
# Constants
################################################################################

const SIZE_POPUP_NOTICE = Vector2(192, 32)

const STR_POPUP_TITLE_END_TURN = "End Turn"
const STR_POPUP_TEXT_END_TURN = "End your turn?"

const STR_POPUP_TITLE_FORFEIT = "Forfeit"
const STR_POPUP_TEXT_FORFEIT = "Forfeit the game?"

const STR_POPUP_TITLE_ERROR = "Error"
const STR_POPUP_TITLE_NOTICE = "Notice"

enum State { MAIN, TARGET }


################################################################################
# Variables
################################################################################

var state: int = State.MAIN

onready var enemy_panel = $BattleField/EnemyCommandPanel
onready var action_panel = $BattleField/PlayerCommandPanel
onready var minion_row_enemy = $BattleField/Center/MinionField/Top
onready var minion_row_player = $BattleField/Center/MinionField/Bottom
onready var dialog_confirm: ConfirmationDialog = $Popups/Confirm
onready var dialog_notice: AcceptDialog = $Popups/Notice
onready var popup_card_info = $Popups/InfoCardPopup
onready var nameplate_player = $BattleField/PlayerNameplate/Nameplate
onready var nameplate_enemy = $BattleField/EnemyNameplate/Nameplate

var _selected_minion: WeakRef = weakref(null)
var _selection_targets: Array = []

################################################################################
# Interface
################################################################################


func reset_data():
    action_panel.reset_data()


func set_player_army(minions: Array):
    var data = null if len(minions) < 1 else minions[0]
    action_panel.army_action_bar.token1.minion_data = data
    data = null if len(minions) < 2 else minions[1]
    action_panel.army_action_bar.token2.minion_data = data
    data = null if len(minions) < 3 else minions[2]
    action_panel.army_action_bar.token3.minion_data = data
    data = null if len(minions) < 4 else minions[3]
    action_panel.army_action_bar.token4.minion_data = data
    data = null if len(minions) < 5 else minions[4]
    action_panel.army_action_bar.token5.minion_data = data
    data = null if len(minions) < 6 else minions[5]
    action_panel.army_action_bar.token6.minion_data = data


func add_to_player_army(minion: MinionData):
    action_panel.army_action_bar.add_data(minion)


func remove_from_player_army(i: int):
    action_panel.army_action_bar.remove_data_at(i)


func add_to_enemy_army(_minion: MinionData):
    pass


func spawn_player_minion(minion: BattleMinion, i: int = -1):
    if i < 0:
        i = minion_row_player.get_minion_count()
        minion_row_player.append_minion(minion.as_dict())
    else:
        minion_row_player.insert_minion(i, minion.as_dict())
    minion_row_player.minions[i].can_act = minion.can_act


func spawn_enemy_minion(minion: BattleMinion, i: int = -1):
    if i < 0:
        i = minion_row_enemy.get_minion_count()
        minion_row_enemy.append_minion(minion.as_dict())
    else:
        minion_row_enemy.insert_minion(i, minion.as_dict())
    minion_row_enemy.minions[i].can_act = minion.can_act


func remove_from_player_field(i: int):
    minion_row_player.remove_minion(i)


func remove_from_enemy_field(i: int):
    minion_row_enemy.remove_minion(i)


func set_active_minion(player_index: int, minion_index: int, data: BattleMinion):
    var minion = _get_active_minion(player_index, minion_index)
    minion.set_minion_data(data.as_dict())


func set_player_resources(current: int, maximum: int):
    nameplate_player.set_resources(current, maximum)


func set_enemy_resources(current: int, maximum: int):
    nameplate_enemy.set_resources(current, maximum)


func enter_main_phase():
    state = State.MAIN
    minion_row_enemy.reset_minion_selection()
    minion_row_enemy.reset_minion_highlights()
    minion_row_enemy.enable_minion_selection(true)
    minion_row_player.reset_minion_selection()
    minion_row_player.reset_minion_highlights()
    minion_row_player.enable_minion_selection(true)
    action_panel.commander.set_highlighted(false)
    enemy_panel.commander.set_highlighted(false)
    # this may not be the best place for the lines below
    _selection_targets = []
    _selected_minion = weakref(null)
    action_panel.show_main_command_card()


func enter_target_phase(mode: int):
    match mode:
        Global.TargetMode.ATTACK_TARGET:
            if minion_row_enemy.get_minion_count() == 0:
                print("There are no targets to attack.")
            else:
                state = State.TARGET
                assert(_selected_minion.get_ref() in minion_row_player.minions)
                _selection_targets = minion_row_enemy.minions.duplicate()
                _selection_targets.append(enemy_panel.commander)
                _target_state_enable_targets()


################################################################################
# Rendering Interface
################################################################################


func show_error(msg: String):
    dialog_notice.window_title = STR_POPUP_TITLE_ERROR
    dialog_notice.dialog_text = msg
    dialog_notice.popup_centered_minsize(SIZE_POPUP_NOTICE)


func animate_attack(
    player_index: int,
    minion_index: int,
    enemy_index: int,
    target_index: int
):
    var source = _get_active_minion(player_index, minion_index)
    var target = _get_active_minion(enemy_index, target_index)
    print("%s attacks %s" % [source.name, target.name])


func animate_damage(player_index: int, minion_index: int, damage: int):
    var minion = _get_active_minion(player_index, minion_index)
    print("%s took %d damage" % [minion.name, damage])
    minion.dec_health(damage)


func animate_minion_death(player_index: int, field_index: int):
    var minion = _get_active_minion(player_index, field_index)
    print("%s died" % minion.name)


################################################################################
# Helper Functions
################################################################################


func _get_active_minion(player_index: int, minion_index: int) -> Control:
    if player_index == 0:
        return minion_row_player.minions[minion_index]
    else:
        return minion_row_enemy.minions[minion_index]


################################################################################
# State - Main
################################################################################


func _on_main_state_minion_selected(minion: Control, friendly: bool):
    var prev = _selected_minion.get_ref()
    _selected_minion = weakref(minion)
    if prev != null and prev != minion:
        prev.set_selected(false)
    var can_act = friendly and minion.can_act
    action_panel.show_minion_action_bar(minion.minion_data, can_act)


func _on_main_state_minion_deselected(minion):
    var prev = _selected_minion.get_ref()
    if prev != null and prev == minion:
        _selected_minion = weakref(null)
        action_panel.show_main_command_card()


################################################################################
# State - Target
################################################################################


func _target_state_enable_targets():
    # assume `_selection_targets` is already set
    # reset all selections
    minion_row_enemy.disable_minion_selection()
    minion_row_player.disable_minion_selection()
    # highlight possible targets
    for target in _selection_targets:
        target.set_selected(false)
        target.set_retain_selection(false)
        target.set_selectable(true)
        target.set_highlighted(true)


func _on_target_state_minion_selected(minion):
    assert(minion in _selection_targets)
    for target in _selection_targets:
        target.set_highlighted(false)
    print("Selected %s as a target" % minion.name)
    var attacker = _selected_minion.get_ref()
    assert(attacker != null)
    enter_main_phase()
    emit_signal("action_attack_target", attacker.index, minion.index)


func _on_target_state_enemy_commander_selected():
    for target in _selection_targets:
        target.set_highlighted(false)
    print("Selected enemy commander as a target")
    enter_main_phase()


################################################################################
# Event Handlers
################################################################################


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


func _on_deploy_minion(army_index: int, right_side: bool):
    _on_hide_card_info()
    action_panel.show_main_command_card()
    if right_side:
        emit_signal("action_deploy_right", army_index)
    else:
        #ok = minion_row_player.append_minion(minion_data)
        #ok = minion_row_player.preprend_minion(minion_data)
        emit_signal("action_deploy_left", army_index)


func _on_deselect_minions():
    match state:
        State.MAIN:
            minion_row_enemy.reset_minion_selection()
            minion_row_player.reset_minion_selection()
        State.TARGET:
            enter_main_phase()


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


################################################################################
# Event Handlers - Enemy Side
################################################################################


func _on_enemy_commander_selected():
    match state:
        State.TARGET:
            _on_target_state_enemy_commander_selected()
