tool
extends PanelContainer

################################################################################
# Constants
################################################################################

const STYLE_NORMAL = preload("res://data/ui/minions/style_normal.tres")
const STYLE_SELECTED = preload("res://data/ui/minions/style_selected.tres")
const STYLE_DISABLED = preload("res://data/ui/minions/style_disabled.tres")

################################################################################
# Signals
################################################################################

signal selected()
signal deselected()

################################################################################
# Variables
################################################################################

export (bool) var enabled: bool = true setget set_enabled
export (bool) var selected: bool = false setget set_selected

################################################################################
# Interface
################################################################################


func set_enabled(is_enabled: bool):
    enabled = is_enabled
    render()


func set_selected(is_selected: bool):
    selected = is_selected
    render()
    if is_selected and not selected:
        emit_signal("selected")
    elif not is_selected and selected:
        emit_signal("deselected")


func render():
    if not enabled:
        set("custom_styles/panel", STYLE_DISABLED)
    else:
        if selected:
            set("custom_styles/panel", STYLE_SELECTED)
        else:
            set("custom_styles/panel", STYLE_NORMAL)


################################################################################
# Event Handlers
################################################################################


func _on_gui_input(event: InputEvent):
    if enabled and event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            set_selected(not selected)
