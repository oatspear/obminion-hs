extends HBoxContainer

################################################################################
# Signals
################################################################################

signal selected_left()
signal selected_right()

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


func enable_slot_selectors():
    _selecting = true
    match get_minion_count():
        0:
            minion4.set_selectable(true)
            minion4.show()
        1:
            minion3.set_selectable(true)
            minion3.show()
            minion5.set_selectable(true)
            minion5.show()
        2:
            pass
        3:
            pass
        4:
            pass
        5:
            pass
        _:
            pass


func disable_slot_selectors():
    _selecting = false


func preprend_minion(minion: Control):
    pass
    #minion_container.add_child(minion)
    #minion_container.move_child(minion, 0)


func append_minion(minion: Control):
    pass
    #minion_container.add_child(minion)


################################################################################
# Event Handlers
################################################################################


func _ready():
    for minion in minions:
        minion.set_minion_data(null)
        minion.visible = false


func _on_Left_gui_input(event: InputEvent):
    if not _selecting:
        return
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            disable_slot_selectors()
            emit_signal("selected_left")


func _on_Right_gui_input(event: InputEvent):
    if not _selecting:
        return
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            disable_slot_selectors()
            emit_signal("selected_right")
