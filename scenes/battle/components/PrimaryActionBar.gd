extends HBoxContainer

################################################################################
# Signals
################################################################################

signal show_army()
signal hide_army()
signal show_support()
signal hide_support()
signal surrender_pressed()
signal end_turn_pressed()

################################################################################
# Variables
################################################################################

onready var button_army: Button = $Army/Button
onready var button_support: Button = $Support/Button

################################################################################
# Interface
################################################################################


func select_army_toggle(emit: bool = true):
    deselect_support_toggle(emit)
    button_army.pressed = true
    if emit:
        emit_signal("show_army")


func select_support_toggle(emit: bool = true):
    deselect_army_toggle(emit)
    button_support.pressed = true
    if emit:
        emit_signal("show_support")


func deselect_toggles(emit: bool = true):
    deselect_army_toggle(emit)
    deselect_support_toggle(emit)


func deselect_army_toggle(emit: bool = true):
    button_army.pressed = false
    if emit:
        emit_signal("hide_army")


func deselect_support_toggle(emit: bool = true):
    button_support.pressed = false
    if emit:
        emit_signal("hide_support")


################################################################################
# Event Handlers
################################################################################


func _ready():
    button_army.pressed = false
    button_support.pressed = false


func _on_Army_Button_toggled(button_pressed: bool):
    if button_pressed:
        select_army_toggle(true)
    else:
        deselect_army_toggle(true)


func _on_Support_Button_toggled(button_pressed: bool):
    if button_pressed:
        select_support_toggle(true)
    else:
        deselect_support_toggle(true)


func _on_Surrender_Button_pressed():
    deselect_toggles()
    emit_signal("surrender_pressed")


func _on_EndTurn_Button_pressed():
    deselect_toggles()
    emit_signal("end_turn_pressed")
