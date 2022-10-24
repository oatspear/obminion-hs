tool
extends HBoxContainer

################################################################################
# Constants
################################################################################

const STR_USAGE = "%d/%d"

################################################################################
# Variables
################################################################################

export (Global.ResourceType) var value_type: int = Global.ResourceType.RESOURCES setget set_value_type
export (int) var current_value: int = 0 setget set_value
export (int) var max_value: int = 0 setget set_max_value
export (bool) var display_max: bool = false setget set_display_max_value

onready var icon: TextureRect = $Icon
onready var label: Label = $Label

################################################################################
# Interface
################################################################################


func set_value_type(t: int):
    assert(t in Global.ResourceType.values())
    value_type = t
    _render_icon()


func set_value(value: int):
    current_value = value
    _render_text()


func set_max_value(value: int):
    max_value = value
    _render_text()


func set_display_max_value(display: bool):
    display_max = display
    _render_text()


func render():
    _render_icon()
    _render_text()


################################################################################
# Helper Functions
################################################################################


func _render_text():
    # if is_inside_tree():
    var el: Label = label if not Engine.editor_hint else $Label
    if el == null:
        return
    if display_max:
        el.text = STR_USAGE % [current_value, max_value]
    else:
        el.text = str(current_value)


func _render_icon():
    # if is_inside_tree():
    var el: TextureRect = icon if not Engine.editor_hint else $Icon
    if el == null:
        return
    var texture = Global.VALUE_ICONS.get(value_type)
    if texture == null:
        el.hide()
    else:
        el.texture = texture
        el.show()


################################################################################
# Event Handlers
################################################################################


func _ready():
    render()
