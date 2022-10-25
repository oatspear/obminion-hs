extends "res://scenes/ui/SelectablePanel.gd"

################################################################################
# Variables
################################################################################

var minion_data: Dictionary = {} setget set_minion_data

onready var portrait: TextureRect = $Elements/Portrait
onready var label_stats = $Elements/Stats
onready var animation = $Animation

################################################################################
# Interface
################################################################################


func has_minion_data() -> bool:
    return not minion_data.empty()


func set_minion_data(data: Dictionary):
    minion_data = data
    set_power(minion_data.get("power", 0))
    set_health(minion_data.get("health", 0))


func get_power() -> int:
    return label_stats.stat1


func set_power(value: int):
    label_stats.stat1 = value


func get_health() -> int:
    return label_stats.stat2


func set_health(value: int):
    label_stats.stat2 = value


################################################################################
# Helper Functions
################################################################################


func _set_style_normal():
    # this will act as the "selectable" animation state
    ._set_style_selected()
    if animation:
        animation.play("pulse")


func _set_style_selected():
    ._set_style_selected()
    if animation and animation.is_playing():
        animation.seek(0, true)
        animation.stop(true)


func _set_style_disabled():
    # this will act as the normal, non-interactable state
    ._set_style_normal()
    if animation and animation.is_playing():
        animation.seek(0, true)
        animation.stop(true)


func _ready():
    render()
