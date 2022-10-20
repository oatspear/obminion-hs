tool
extends PanelContainer

################################################################################
# Constants
################################################################################

const STYLE_NORMAL = preload("res://data/ui/styles/style_normal.tres")
const STYLE_SELECTED = preload("res://data/ui/styles/style_selected.tres")
const STYLE_DISABLED = preload("res://data/ui/styles/style_disabled.tres")

################################################################################
# Signals
################################################################################

signal selected()
signal deselected()

################################################################################
# Variables
################################################################################

export (bool) var selectable: bool = true setget set_selectable
export (bool) var selected: bool = false setget set_selected

################################################################################
# Interface
################################################################################


func set_selectable(is_selectable: bool):
    selectable = is_selectable
    render()


func set_selected(is_selected: bool):
    var was_selected = selected
    selected = is_selected
    render()
    if selected and not was_selected:
        emit_signal("selected")
    elif not selected and was_selected:
        emit_signal("deselected")


func render():
    if not selectable:
        _set_style_disabled()
    else:
        if selected:
            _set_style_selected()
        else:
            _set_style_normal()


################################################################################
# Helper Functions
################################################################################


func _set_style_normal():
    set("custom_styles/panel", STYLE_NORMAL)


func _set_style_selected():
    set("custom_styles/panel", STYLE_SELECTED)


func _set_style_disabled():
    set("custom_styles/panel", STYLE_DISABLED)


################################################################################
# Event Handlers
################################################################################


func _ready():
    render()


func _on_gui_input(event: InputEvent):
    if selectable and event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            set_selected(not selected)
