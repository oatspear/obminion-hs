extends Reference
class_name BattlePlayer

################################################################################
# Variables
################################################################################

var index: int = 0
var name: String = "Player"

var resources: int = Global.DEFAULT_STARTING_RESOURCES
var max_resources: int = Global.DEFAULT_MAX_RESOURCES

var player_data: PlayerData setget set_player_data

var battlefield: Array = []
var army: Array = []
var graveyard: Array = []
var graveyard_size: int = 0

var commander: BattleCommander

################################################################################
# Interface
################################################################################


func set_player_data(data: PlayerData):
    player_data = data
    reset()


func reset():
    name = player_data.name
    resources = player_data.resources
    max_resources = player_data.max_resources
    graveyard_size = player_data.graveyard_size
    battlefield = []
    graveyard = []
    army = []
    for i in range(player_data.minions.size()):
        var _r = add_minion_from_deck(i)


func replenish_resources():
    if resources < max_resources:
        resources = max_resources


func add_minion_from_deck(deck_index: int) -> BattleMinion:
    var base_data: MinionData = player_data.minions[deck_index]
    var minion = BattleMinion.new()
    minion.set_base_data(base_data)
    minion.deck_index = deck_index
    minion.original_player_index = index
    # minion.index and minion.player_index are handled below
    add_to_army(minion)
    return minion


func add_to_army(minion: BattleMinion) -> void:
    # ensure that indices are consistent
    army.append(minion)
    _fix_army_indices()


func add_active_minion(minion: BattleMinion) -> void:
    # ensure that indices are consistent
    battlefield.append(minion)
    _fix_battle_indices()


func insert_active_minion(field_index: int, minion: BattleMinion) -> void:
    # ensure that indices are consistent
    battlefield.insert(field_index, minion)
    _fix_battle_indices()


func deploy(army_index: int, field_index: int):
    var minion: BattleMinion = army[army_index]
    army.remove(army_index)
    _fix_army_indices()
    if field_index < 0 or field_index > battlefield.size():
        field_index = battlefield.size()
    insert_active_minion(field_index, minion)


func remove_from_battlefield(field_index: int) -> BattleMinion:
    assert(field_index >= 0 and field_index < battlefield.size())
    var minion: BattleMinion = battlefield[field_index]
    battlefield.remove(field_index)
    _fix_battle_indices()
    return minion


func add_to_graveyard(minion: BattleMinion) -> bool:
    if graveyard.size() >= graveyard_size:
        return false
    minion.move_to_graveyard(graveyard.size())
    graveyard.append(minion)
    return true


func rotate_graveyard_to_army():
    print("Rotate %s from graveyard" % (graveyard[0].name if graveyard else "nothing"))
    var minion: BattleMinion = graveyard.pop_front()
    if minion != null:
        add_to_army(minion)
    return minion


################################################################################
# Helper Functions
################################################################################


func _fix_army_indices():
    for i in range(army.size()):
        var minion: BattleMinion = army[i]
        minion.move_to_army(i)
        minion.player_index = index


func _fix_battle_indices():
    for i in range(battlefield.size()):
        var minion: BattleMinion = battlefield[i]
        minion.move_to_battlefield(i)
        minion.player_index = index
