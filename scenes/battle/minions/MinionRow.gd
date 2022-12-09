extends HBoxContainer

################################################################################
# Constants
################################################################################

const MAX_MINIONS: int = 6

################################################################################
# Signals
################################################################################

signal minion_selected(minion)
signal minion_deselected(minion)

################################################################################
# Variables
################################################################################

var _minion_count: int = 0
var _selecting: bool = false

onready var minion1 = $Minion1
onready var minion2 = $Minion2
onready var minion3 = $Minion3
onready var minion4 = $Minion4
onready var minion5 = $Minion5
onready var minion6 = $Minion6

onready var minions: Array = [
    minion1,
    minion2,
    minion3,
    minion4,
    minion5,
    minion6,
]

################################################################################
# Interface
################################################################################


func get_minion_count() -> int:
    _minion_count = 0
    for minion in minions:
        if minion.has_minion_data():
            _minion_count += 1
    return _minion_count


func preprend_minion(minion_data: Dictionary) -> bool:
    return insert_minion(0, minion_data)


func append_minion(minion_data: Dictionary) -> bool:
    if get_minion_count() >= MAX_MINIONS:
        return false
    var minion = minions[_minion_count]
    minion.set_minion_data(minion_data)
    minion.show()
    _minion_count += 1
    return true


func insert_minion(index: int, minion_data: Dictionary) -> bool:
    if get_minion_count() >= MAX_MINIONS:
        return false
    for i in range(_minion_count, index, -1):
        var prev = minions[i-1].minion_data
        minions[i].set_minion_data(prev)
    minions[index].set_minion_data(minion_data)
    minions[_minion_count].show()
    _minion_count += 1
    return true


func reset_minion_selection():
    for minion in minions:
        minion.set_selected(false)


func enable_minion_selection(retain_selection: bool = true):
    for minion in minions:
        minion.set_retain_selection(retain_selection)
        minion.set_selectable(true)


func disable_minion_selection():
    for minion in minions:
        minion.set_selectable(false)


func reset_minion_highlights():
    for minion in minions:
        minion.set_highlighted(false)


################################################################################
# Event Handlers
################################################################################


func _ready():
    for minion in minions:
        minion.set_minion_data({})
        minion.hide()


func _on_minion1_selected():
    emit_signal("minion_selected", minion1)


func _on_minion2_selected():
    emit_signal("minion_selected", minion2)


func _on_minion3_selected():
    emit_signal("minion_selected", minion3)


func _on_minion4_selected():
    emit_signal("minion_selected", minion4)


func _on_minion5_selected():
    emit_signal("minion_selected", minion5)


func _on_minion6_selected():
    emit_signal("minion_selected", minion6)


func _on_minion1_deselected():
    emit_signal("minion_deselected", minion1)


func _on_minion2_deselected():
    emit_signal("minion_deselected", minion2)


func _on_minion3_deselected():
    emit_signal("minion_deselected", minion3)


func _on_minion4_deselected():
    emit_signal("minion_deselected", minion4)


func _on_minion5_deselected():
    emit_signal("minion_deselected", minion5)


func _on_minion6_deselected():
    emit_signal("minion_deselected", minion6)
