tool
extends HBoxContainer

################################################################################
# Constants
################################################################################

const STR_VALUE = "%d"
const STR_USAGE = "%d/%d"

################################################################################
# Variables
################################################################################

export (int) var current_value: int = 0 setget set_value
export (int) var max_value: int = 0 setget set_max_value
export (bool) var display_max: bool = false setget set_display_max_value

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


func set_display_max_value(display: bool):
    display_max = display
    render()


func render():
    if label != null:
        label.text = get_text()
    elif Engine.editor_hint:
        $Label.text = get_text()


func get_text() -> String:
    if display_max:
        return STR_USAGE % [current_value, max_value]
    return STR_VALUE % current_value


################################################################################
# Event Handlers
################################################################################


func _ready():
    render()
