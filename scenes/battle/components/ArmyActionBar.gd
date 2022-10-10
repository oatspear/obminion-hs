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
    print("Previous pressed button? %s" % (button_group.get_pressed_button() != null))
    for button in get_children():
        button.pressed = false
        button.disabled = false
    print("Current pressed button? %s" % (button_group.get_pressed_button() != null))


################################################################################
# Event Handlers
################################################################################

func _ready():
    for button in get_children():
        button.pressed = false
        button.disabled = false
        button.group = button_group
