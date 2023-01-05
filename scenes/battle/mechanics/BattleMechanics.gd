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
signal commander_died(player_index)
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
    var attacker: BattleMinion = p1.battlefield[field_index]
    if target_index >= 0:
        var target: BattleMinion = p2.battlefield[target_index]
        return _attack_minion(attacker, target)
    else:
        var target: BattleCommander = p2.commander
        return _attack_commander(attacker, target)


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
    var player: BattlePlayer = data.players[player_index]
    var minion: BattleMinion = player.army[army_index]
    if player.resources < minion.supply:
        return emit_signal("action_error", NO_RESOURCES)
    if player.battlefield.size() >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    player.resources -= minion.supply
    emit_signal("resources_changed", player_index, player.resources, player.max_resources)
    player.deploy(army_index, field_index)
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


func _attack_minion(attacker: BattleMinion, target: BattleMinion) -> int:
    # TODO attack declaration event
    if _has_taunt_minions(target.player_index):
        if not target.has_ability(Global.Abilities.TAUNT):
            return Global.GameError.MUST_TARGET_TAUNT
    # emit post attack event
    var event = BattleEventAttack.new()
    event.player_index = attacker.player_index
    event.field_index = attacker.index
    event.enemy_index = target.player_index
    event.target_index = target.index
    emit_signal("minion_attacked", event)
    # deal damage
    var a = _deal_damage(target, attacker.power)
    var b = _deal_damage(attacker, target.power)
    _post_damage_logic(target, a, attacker)
    _post_damage_logic(attacker, b, target)
    return Global.GameError.NONE


func _attack_commander(attacker: BattleMinion, target: BattleCommander) -> int:
    # TODO attack declaration event
    if _has_taunt_minions(target.player_index):
        return Global.GameError.MUST_TARGET_TAUNT
    # emit post attack event
    var event = BattleEventAttack.new()
    event.player_index = attacker.player_index
    event.field_index = attacker.index
    event.enemy_index = target.player_index
    event.target_index = -1
    emit_signal("minion_attacked", event)
    # deal damage
    # var a = _deal_damage(target, source.power)
    var damage = attacker.power
    target.damage += damage
    event = BattleEventDamage.new()
    event.player_index = target.player_index
    event.field_index = -1
    event.damage = damage
    emit_signal("damage_dealt", event)
    # var b = _deal_damage(attacker, target.power)
    if target.get_current_health() <= 0:
        emit_signal("commander_died", target.player_index)
        emit_signal("battle_ended", attacker.player_index)
    return Global.GameError.NONE


func _deal_damage(minion: BattleMinion, damage: int) -> int:
    if damage <= 0:
        return 0
    if minion.divine_shield:
        minion.divine_shield = false
        _damage_dealt(minion, 0)
        emit_signal("minion_stats_changed", minion)
        return 0
    minion.damage += damage
    _damage_dealt(minion, damage)
    return damage


func _post_damage_logic(minion: BattleMinion, damage: int, source: BattleMinion):
    var poisonous: bool = damage > 0 and source.has_ability(Global.Abilities.POISON)
    if minion.get_current_health() <= 0 or poisonous:
        var player_index = minion.player_index
        var minion_index = minion.index
        emit_signal("minion_died", player_index, minion_index)
        var player: BattlePlayer = data.players[player_index]
        var _minion = player.remove_from_battlefield(minion_index)
        assert(minion == _minion)
        emit_signal("minion_destroyed", player_index, minion_index)
        # minion.reset()
        while not player.add_to_graveyard(minion):
            print("%s graveyard is full" % player.name)
            var other = player.rotate_graveyard_to_army()
            assert(other != null)
            emit_signal("minion_recruited", player_index, other)
        print("%s graveyard" % player.name, player.graveyard)
        # TODO emit signal


func _damage_dealt(minion: BattleMinion, damage: int):
    var event = BattleEventDamage.new()
    event.player_index = minion.player_index
    event.field_index = minion.index
    event.damage = damage
    emit_signal("damage_dealt", event)


func _apply_keywords(minion: BattleMinion):
    # minion.action_timer = 0 if minion.has_ability(Global.Abilities.HASTE) else DEFAULT_ACTION_TIMER
    minion.divine_shield = minion.has_ability(Global.Abilities.DIVINE_SHIELD)


func _do_battlecry(minion: BattleMinion):
    var battlecry = minion.battlecry
    if not battlecry:
        return

    var p: BattlePlayer = data.players[minion.player_index]
    var e: BattlePlayer = data.players[(minion.player_index + 1) % 2]

    if battlecry & Global.Abilities.BUFF_ADJACENT_ALLY_POWER:
        var i = minion.index
        if i > 0:
            var other: BattleMinion = p.battlefield[i-1]
            other.apply_power_modifier(+1)
            emit_signal("minion_stats_changed", other)
        if (i + 1) < p.battlefield.size():
            var other: BattleMinion = p.battlefield[i+1]
            other.apply_power_modifier(+1)
            emit_signal("minion_stats_changed", other)

    if battlecry & Global.Abilities.BUFF_ADJACENT_ALLY_HEALTH:
        var i = minion.index
        if i > 0:
            var other: BattleMinion = p.battlefield[i-1]
            other.apply_health_modifier(+1)
            emit_signal("minion_stats_changed", other)
        if (i + 1) < p.battlefield.size():
            var other: BattleMinion = p.battlefield[i+1]
            other.apply_health_modifier(+1)
            emit_signal("minion_stats_changed", other)


func _has_taunt_minions(player_index: int) -> bool:
    var player: BattlePlayer = data.players[player_index]
    for m in player.battlefield:
        var minion: BattleMinion = m
        if minion.has_ability(Global.Abilities.TAUNT):
            return true
    return false


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
