extends HBoxContainer

################################################################################
# Constants
################################################################################

const STR_RESOURCE_FORMAT = "%d / %d"

################################################################################
# Variables
################################################################################

export (int) var current_value: int = 0 setget set_value
export (int) var max_value: int = 6 setget set_max_value

onready var label: Label = $Label

################################################################################
# Interface
################################################################################


func set_value(value: int):
    current_value = value
    render()


func set_max_value(value: int):
    max_value = value
    render()


func render():
    if label != null:
        label.text = STR_RESOURCE_FORMAT % [current_value, max_value]


################################################################################
# Event Handlers
################################################################################


func _ready():
    render()
