extends Reference

class_name BattleMechanics

###############################################################################
# Signals
###############################################################################

signal action_error(msg)
signal resources_changed(player_index, current, maximum)
signal minion_recruited(player_index, minion_data)
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

var data: BattleData = BattleData.new()


###############################################################################
# Interface
###############################################################################


func action_deploy_left(player_index: int, army_index: int):
    return _deploy(player_index, army_index, 0)


func action_deploy_right(player_index: int, army_index: int):
    return _deploy(player_index, army_index, -1)


func action_attack_target(
    player_index: int,
    field_index: int,
    enemy_index: int,
    target_index: int
):
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
    target.health -= source.power
    source.health -= target.power
    _damage_dealt(enemy_index, target_index, source.power)
    _damage_dealt(player_index, field_index, target.power)
    if target.health <= 0:
        emit_signal("minion_died", enemy_index, target_index)
        p2.battlefield.remove(target_index)
        emit_signal("minion_destroyed", enemy_index, target_index)
        while not p2.add_to_graveyard(target):
            print("Enemy graveyard is full")
            var minion = p2.rotate_graveyard_to_army()
            assert(minion != null)
            emit_signal("minion_recruited", enemy_index, minion)
        print("Enemy graveyard", p2.graveyard)
        # TODO emit signal
    if source.health <= 0:
        emit_signal("minion_died", player_index, field_index)
        p1.battlefield.remove(field_index)
        emit_signal("minion_destroyed", player_index, field_index)
        print("%s died" % source.base_data.name)
        while not p1.add_to_graveyard(source):
            print("Player graveyard is full")
            var minion = p1.rotate_graveyard_to_army()
            assert(minion != null)
            emit_signal("minion_recruited", player_index, minion.base_data)
        print("Player graveyard", p1.graveyard)
        # TODO emit signal


###############################################################################
# Helper Functions
###############################################################################


func _deploy(player_index: int, army_index: int, field_index: int):
    var player: BattlePlayer = data.players[player_index]
    var minion: BattleMinion = player.army[army_index]
    if player.resources < minion.supply:
        return emit_signal("action_error", NO_RESOURCES)
    if len(player.battlefield) >= MAX_ACTIVE_MINIONS:
        return emit_signal("action_error", MSG_BOARD_FULL)
    player.resources -= minion.supply
    emit_signal("resources_changed", player_index, player.resources, player.max_resources)
    player.army.remove(army_index)
    if field_index < 0 or field_index > player.battlefield.size():
        field_index = player.battlefield.size()
    # minion.can_act = true
    player.insert_active_minion(field_index, minion)
    var event = BattleEventDeploy.new()
    event.player_index = player_index
    event.army_index = army_index
    event.field_index = field_index
    event.minion = minion
    emit_signal("minion_deployed", event)


func _damage_dealt(player_index: int, field_index: int, damage: int):
    var event = BattleEventDamage.new()
    event.player_index = player_index
    event.field_index = field_index
    event.damage = damage
    emit_signal("damage_dealt", event)
