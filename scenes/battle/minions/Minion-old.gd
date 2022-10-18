extends PanelContainer

################################################################################
# Constants
################################################################################

const STYLE_NORMAL = preload("res://data/ui/minions/style_normal.tres")
const STYLE_SELECT = preload("res://data/ui/minions/style_selected.tres")

################################################################################
# Signals
################################################################################

signal selected()

################################################################################
# Variables
################################################################################

var minion_data = null setget set_minion_data
var selectable: bool = false setget set_selectable

onready var sprite: TextureRect = $Elements/Sprite
onready var label_stats = $Elements/Stats
onready var animation = $Animation

################################################################################
# Interface
################################################################################


func has_minion_data() -> bool:
    return minion_data != null


func set_minion_data(data):
    minion_data = data


func get_power() -> int:
    return label_stats.stat1


func set_power(value: int):
    label_stats.stat1 = value


func get_health() -> int:
    return label_stats.stat2


func set_health(value: int):
    label_stats.stat2 = value


func set_selectable(is_selectable: bool):
    if selectable != is_selectable:
        selectable = is_selectable
        if selectable:
            _set_select_style()
        else:
            _set_normal_style()


################################################################################
# Helper Functions
################################################################################


func _set_normal_style():
    sprite.visible = true
    label_stats.visible = true
    set("custom_styles/panel", STYLE_NORMAL)
    if animation.is_playing():
        animation.stop()


func _set_select_style():
    sprite.visible = false
    label_stats.visible = false
    set("custom_styles/panel", STYLE_SELECT)
    animation.play("pulse")


################################################################################
# Event Handlers
################################################################################


func _on_gui_input(event: InputEvent):
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            # set_selectable(not selectable)
            if selectable:
                emit_signal("selected")
