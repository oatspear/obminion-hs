extends HBoxContainer

################################################################################
# Signals
################################################################################

signal selected_unit(i)

################################################################################
# Variables
################################################################################

onready var button_group: ButtonGroup = ButtonGroup.new()

################################################################################
# Interface
################################################################################


func reset_buttons():
    for button in get_children():
        button.pressed = false
        button.disabled = false


################################################################################
# Event Handlers
################################################################################

func _ready():
    for button in get_children():
        button.pressed = false
        button.disabled = false
        button.group = button_group


func _on_Button1_toggled(button_pressed: bool):
    if button_pressed:
        emit_signal("selected_unit", 0)


func _on_Button2_toggled(button_pressed: bool):
    if button_pressed:
        emit_signal("selected_unit", 1)


func _on_Button3_toggled(button_pressed):
    if button_pressed:
        emit_signal("selected_unit", 2)


func _on_Button4_toggled(button_pressed):
    if button_pressed:
        emit_signal("selected_unit", 3)


func _on_Button5_toggled(button_pressed):
    if button_pressed:
        emit_signal("selected_unit", 4)


func _on_Button6_toggled(button_pressed):
    if button_pressed:
        emit_signal("selected_unit", 5)
