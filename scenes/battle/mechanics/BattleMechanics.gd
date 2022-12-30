extends Node

# class_name BattleMechanics

################################################################################
# Signals
################################################################################

signal action_error(msg)

signal battle_started(battle_data)
signal battle_ended(victor_index)

signal turn_started(player_index)
signal turn_ended(player_index)

signal resources_changed(player_index, current, maximum)
signal minion_recruited(player_index, minion_data)
signal minion_deployed(event)
signal minion_attacked(event)
signal minion_died(player_index, field_index)
signal minion_destroyed(player_index, field_index)
signal minion_stats_changed(minion)
signal damage_dealt(event)
signal request_select_target(player_index, target_mode)

################################################################################
# Constants
################################################################################

const MAX_ACTIVE_MINIONS: int = 6

const NO_RESOURCES = "Not enough resources."
const MSG_BOARD_FULL = "The minion board is full."

const DEFAULT_ACTION_TIMER: int = 1

enum State {
    INITIAL,
    BATTLE_SETUP,
    TURN_START,
    TURN_MAIN_PHASE,
    TURN_ATTACK_PHASE,
    TURN_RESOLVE_EFFECT,
    TURN_END,
    BATTLE_END,
    END,
}

################################################################################
# Internal State
################################################################################

var data: BattleData = BattleData.new()

var _state: int = State.INITIAL
var _ongoing_player_input: int = -1
var _ongoing_target_mode: int = Global.TargetMode.NONE
var _victor_index: int = -1

################################################################################
# Interface
################################################################################


func start_battle() -> int:
    if _state != State.INITIAL:
        return Global.GameError.BATTLE_STARTED
    _state = State.BATTLE_SETUP
    set_process(true)
    return Global.GameError.NONE


func action_end_turn(player_index: int) -> int:
    if not _player_can_act(player_index):
        return Global.GameError.NOT_YOUR_TURN
    _state = State.TURN_END
    return Global.GameError.NONE


func action_forfeit_game(player_index: int) -> int:
    assert(data.players.size() == 2)
    _victor_index = (player_index + 1) % 2
    _state = State.BATTLE_END
    return Global.GameError.NONE


func action_deploy_left(player_index: int, army_index: int) -> int:
    if not _player_can_act(player_index):
        return Global.GameError.NOT_YOUR_TURN
    _deploy(player_index, army_index, 0)
    return Global.GameError.NONE


func action_deploy_right(player_index: int, army_index: int) -> int:
    if not _player_can_act(player_index):
        return Global.GameError.NOT_YOUR_TURN
    _deploy(player_index, army_index, -1)
    return Global.GameError.NONE


func action_attack_target(
    player_index: int,
    field_index: int,
    enemy_index: int,
    target_index: int
) -> int:
    if not _player_can_act(player_index):
        return Global.GameError.NOT_YOUR_TURN
    var p1 = data.players[player_index]
    var p2 = data.players[enemy_index]
    var source: BattleMinion = p1.battlefield[field_index]
    var target: BattleMinion = p2.battlefield[target_index]
    # TODO attack declaration event
    # emit post attack event
    var event = BattleEventAttack.new()
    event.player_index = player_index
    event.field_index = field_index
    event.enemy_index = enemy_index
    event.target_index = target_index
    emit_signal("minion_attacked", event)
    # deal damage
    var a = _deal_damage(target, source.get_power())
    var b = _deal_damage(source, target.get_power())
    if target.get_current_health() <= 0 or (a > 0 and source.has_ability(Global.Abilities.POISON)):
        emit_signal("minion_died", enemy_index, target_index)
        p2.battlefield.remove(target_index)
        emit_signal("minion_destroyed", enemy_index, target_index)
        target.instance.reset()
        while not p2.add_to_graveyard(target.instance):
            print("Enemy graveyard is full")
            var minion = p2.rotate_graveyard_to_army()
            assert(minion != null)
            emit_signal("minion_recruited", enemy_index, minion)
        print("Enemy graveyard", p2.graveyard)
        # TODO emit signal
    if source.get_current_health() <= 0 or (b > 0 and target.has_ability(Global.Abilities.POISON)):
        emit_signal("minion_died", player_index, field_index)
        p1.battlefield.remove(field_index)
        emit_signal("minion_destroyed", player_index, field_index)
        source.instance.reset()
        while not p1.add_to_graveyard(source.instance):
            print("Player graveyard is full")
            var minion = p1.rotate_graveyard_to_army()
            assert(minion != null)
            emit_signal("minion_recruited", player_index, minion.base_data)
        print("Player graveyard", p1.graveyard)
        # TODO emit signal
    return Global.GameError.NONE


func set_requested_target(index: int):
    assert(_ongoing_player_input >= 0)
    assert(_ongoing_target_mode != Global.TargetMode.NONE)
    match _ongoing_target_mode:
        Global.TargetMode.FRIENDLY_MINION:
            var p: BattlePlayer = data.players[_ongoing_player_input]
            var minion: BattleMinion = p.battlefield[index]
            print("set requested target: [P:%d, BM:%d]" % [_ongoing_player_input, index])
        Global.TargetMode.HOSTILE_MINION:
            var i: int = (_ongoing_player_input + 1) % data.players.size()
            var p: BattlePlayer = data.players[i]
            var minion: BattleMinion = p.battlefield[index]
            print("set requested target: [P:%d, BM:%d]" % [_ongoing_player_input, index])
    _ongoing_player_input = -1
    _ongoing_target_mode = Global.TargetMode.NONE


################################################################################
# Helper Functions
################################################################################


func _player_can_act(player_index: int) -> bool:
    return _state == State.TURN_MAIN_PHASE and data.current_turn == player_index


func _deploy(player_index: int, army_index: int, field_index: int):
    var p: BattlePlayer = data.players[player_index]
    var instance: MinionInstance = p.army[army_index]
    if p.resources < instance.supply:
        return emit_signal("action_error", NO_RESOURCES)
    if p.battlefield.size() >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    p.resources -= instance.supply
    emit_signal("resources_changed", player_index, p.resources, p.max_resources)
    p.deploy(army_index, field_index)
    var minion: BattleMinion = p.battlefield[field_index]
    _apply_keywords(minion)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = field_index
    event.minion = minion
    emit_signal("minion_deployed", event)
    #if p.battlefield.size() > 2:
    #    _ongoing_player_input = player_index
    #    _ongoing_target_mode = Global.TargetMode.FRIENDLY_MINION
    #    emit_signal("request_select_target", player_index, _ongoing_target_mode)
    _do_battlecry(minion)


func _deal_damage(minion: BattleMinion, damage: int) -> int:
    if damage <= 0:
        return 0
    if minion.divine_shield:
        minion.divine_shield = false
        _damage_dealt(minion, 0)
        return 0
    minion.damage += damage
    _damage_dealt(minion, damage)
    return damage


func _damage_dealt(minion: BattleMinion, damage: int):
    var event = BattleEventDamage.new()
    event.player_index = minion.instance.player_index
    event.field_index = minion.instance.index
    event.damage = damage
    emit_signal("damage_dealt", event)


func _apply_keywords(minion: BattleMinion):
    # minion.action_timer = 0 if minion.has_ability(Global.Abilities.HASTE) else DEFAULT_ACTION_TIMER
    minion.divine_shield = minion.has_ability(Global.Abilities.DIVINE_SHIELD)


func _do_battlecry(minion: BattleMinion):
    var battlecry = minion.instance.battlecry
    if not battlecry:
        return

    var p: BattlePlayer = data.players[minion.instance.player_index]
    var e: BattlePlayer = data.players[(minion.instance.player_index + 1) % 2]

    if battlecry & Global.Abilities.BUFF_ADJACENT_ALLY_POWER:
        var i = minion.instance.index
        if i > 0:
            var other: BattleMinion = p.battlefield[i-1]
            other.apply_power_modifier(+1)
            emit_signal("minion_stats_changed", other)
        if (i + 1) < p.battlefield.size():
            var other: BattleMinion = p.battlefield[i+1]
            other.apply_power_modifier(+1)
            emit_signal("minion_stats_changed", other)

    if battlecry & Global.Abilities.BUFF_ADJACENT_ALLY_HEALTH:
        var i = minion.instance.index
        if i > 0:
            var other: BattleMinion = p.battlefield[i-1]
            other.apply_health_modifier(+1)
            emit_signal("minion_stats_changed", other)
        if (i + 1) < p.battlefield.size():
            var other: BattleMinion = p.battlefield[i+1]
            other.apply_health_modifier(+1)
            emit_signal("minion_stats_changed", other)


################################################################################
# Main Loop
################################################################################


func _ready():
    _state = State.INITIAL
    set_process(false)


func _process(_delta: float):
    # states listed in most likely order of relevance
    match _state:
        State.TURN_MAIN_PHASE:
            _turn_main_phase_state()
        State.TURN_ATTACK_PHASE:
            pass
        State.TURN_RESOLVE_EFFECT:
            pass
        State.TURN_START:
            _turn_start_state()
        State.TURN_END:
            _turn_end_state()
        State.BATTLE_SETUP:
            _battle_setup_state()
        State.BATTLE_END:
            _battle_end_state()
        _:
            pass


################################################################################
# Battle Setup State
################################################################################


func _battle_setup_state():
    emit_signal("battle_started", data)
    _state = State.TURN_START


################################################################################
# Turn Start State
################################################################################


func _turn_start_state():
    emit_signal("turn_started", data.current_turn)
    var p: BattlePlayer = data.players[data.current_turn]
    p.replenish_resources()
    emit_signal("resources_changed", data.current_turn, p.resources, p.max_resources)
    _state = State.TURN_MAIN_PHASE


################################################################################
# Turn Main Phase State
################################################################################


func _turn_main_phase_state():
    # this could be used to run timers, or detect available actions, for example
    # client actions trigger the main processing and state transitions
    pass


################################################################################
# Turn End State
################################################################################


func _turn_end_state():
    emit_signal("turn_ended", data.current_turn)
    data.switch_turns()
    _state = State.TURN_START


################################################################################
# Battle End State
################################################################################


func _battle_end_state():
    emit_signal("battle_ended", _victor_index)
    _state = State.END
    set_process(false)
