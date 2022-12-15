extends Reference
class_name BattleMechanics

###############################################################################
# Signals
###############################################################################

signal action_error(msg)
signal resources_changed(player_index, current, maximum)
signal minion_deployed(event)
signal minion_attacked(event)
signal minion_died(player_index, field_index)
signal minion_destroyed(player_index, field_index)
signal damage_dealt(event)

###############################################################################
# Constants
###############################################################################

const MAX_ACTIVE_MINIONS: int = 6

const NO_RESOURCES = "Not enough resources."
const MSG_BOARD_FULL = "The minion board is full."

###############################################################################
# Internal State
###############################################################################

var players: Array = []
var current_turn: int = 0


###############################################################################
# Interface
###############################################################################


func action_deploy_left(player_index: int, army_index: int):
    var p = players[player_index]
    var minion = p.minion_deck[army_index]
    if p.resources < minion.base_data.supply:
        return emit_signal("action_error", NO_RESOURCES)
    if len(p.active_minions) >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    p.resources -= minion.base_data.supply
    emit_signal("resources_changed", player_index, p.resources, p.max_resources)
    p.minion_deck.remove(army_index)
    p.insert_active_minion(0, minion.base_data)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = 0
    event.minion = p.active_minions[0]
    emit_signal("minion_deployed", event)


func action_deploy_right(player_index: int, army_index: int):
    var p = players[player_index]
    var minion = p.minion_deck[army_index]
    if p.resources < minion.base_data.supply:
        return emit_signal("action_error", NO_RESOURCES)
    if len(p.active_minions) >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    p.resources -= minion.base_data.supply
    emit_signal("resources_changed", player_index, p.resources, p.max_resources)
    p.minion_deck.remove(army_index)
    var n = p.add_active_minion(minion.base_data)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = n - 1
    event.minion = p.active_minions[n-1]
    emit_signal("minion_deployed", event)


func action_attack_target(
    player_index: int,
    field_index: int,
    enemy_index: int,
    target_index: int
):
    var p1 = players[player_index]
    var p2 = players[enemy_index]
    var source = p1.active_minions[field_index]
    var target = p2.active_minions[target_index]
    # TODO attack declaration event
    # emit post attack event
    var event = BattleEventAttack.new()
    event.player_index = player_index
    event.field_index = field_index
    event.enemy_index = enemy_index
    event.target_index = target_index
    emit_signal("minion_attacked", event)
    # deal damage
    target.health -= source.power
    source.health -= target.power
    _damage_dealt(enemy_index, target_index, source.power)
    _damage_dealt(player_index, field_index, target.power)
    if target.health <= 0:
        emit_signal("minion_died", enemy_index, target_index)
        p2.active_minions.remove(target_index)
        emit_signal("minion_destroyed", enemy_index, target_index)
        if p2.add_to_graveyard(target.base_data):
            print("Enemy graveyard", p2.graveyard)
        else:
            print("Enemy graveyard is full")  # FIXME
        # TODO emit signal
    if source.health <= 0:
        emit_signal("minion_died", player_index, field_index)
        p1.active_minions.remove(field_index)
        emit_signal("minion_destroyed", player_index, field_index)
        if p1.add_to_graveyard(source.base_data):
            print("Player graveyard", p1.graveyard)
        else:
            print("Player graveyard is full")  # FIXME
        # TODO emit signal


###############################################################################
# Helper Functions
###############################################################################


func _action_error(msg: String):
    emit_signal("computed_action", false, msg)


func _damage_dealt(player_index: int, field_index: int, damage: int):
    var event = BattleEventDamage.new()
    event.player_index = player_index
    event.field_index = field_index
    event.damage = damage
    emit_signal("damage_dealt", event)
