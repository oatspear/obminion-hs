extends HBoxContainer

################################################################################
# Signals
################################################################################

signal selected_left()
signal selected_right()

################################################################################
# Variables
################################################################################

var _selecting: bool = false

onready var minion_container: HBoxContainer = $Minions
onready var left_reinforcement: Control = $Left
onready var right_reinforcement: Control = $Right

################################################################################
# Interface
################################################################################


func enable_slot_selectors():
    _selecting = true
    left_reinforcement.glow()
    right_reinforcement.glow()


func disable_slot_selectors():
    _selecting = false
    left_reinforcement.stop_glowing()
    right_reinforcement.stop_glowing()


func preprend_minion(minion: Control):
    minion_container.add_child(minion)
    minion_container.move_child(minion, 0)


func append_minion(minion: Control):
    minion_container.add_child(minion)


################################################################################
# Event Handlers
################################################################################


func _on_Left_gui_input(event: InputEvent):
    if not _selecting:
        return
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            disable_slot_selectors()
            emit_signal("selected_left")
            print("selected left")


func _on_Right_gui_input(event: InputEvent):
    if not _selecting:
        return
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            disable_slot_selectors()
            emit_signal("selected_right")
            print("selected right")
