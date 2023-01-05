extends "res://scenes/ui/SelectablePanel.gd"

################################################################################
# Constants
################################################################################

const ABILITY_ICON_MASK = ~0 ^ Global.Abilities.POISON ^ Global.Abilities.DIVINE_SHIELD

################################################################################
# Variables
################################################################################

# export (bool) var highlighted: bool = false setget set_highlighted
export (int) var index: int = 0

var minion_data: Dictionary = {} setget set_minion_data
var can_act: bool = false

onready var portrait: TextureRect = $Elements/Portrait
onready var label_stats = $Elements/Stats
onready var animation = $Animation
onready var effect_shield = $Effects/Shield
onready var icon_poison = $Elements/Enhancements/Poison
onready var icon_ability = $Elements/Enhancements/Ability
onready var icon_deathrattle = $Elements/Enhancements/Deathrattle

################################################################################
# Interface
################################################################################


func has_minion_data() -> bool:
    return not minion_data.empty()


func set_minion_data(data: Dictionary):
    minion_data = data
    set_power(minion_data.get("power", 0))
    set_health(minion_data.get("health", 0))
    _update_effects()


func reset_minion_data():
    return set_minion_data({})


func get_power() -> int:
    return label_stats.stat1


func set_power(value: int):
    label_stats.stat1 = value


func inc_power(amount: int):
    label_stats.stat1 += amount


func dec_power(amount: int):
    label_stats.stat1 -= amount


func get_health() -> int:
    return label_stats.stat2


func set_health(value: int):
    label_stats.stat2 = value


func inc_health(amount: int):
    label_stats.stat2 += amount


func dec_health(amount: int):
    label_stats.stat2 -= amount


#func set_highlighted(highlight: bool):
#    highlighted = highlight
#    render()
#    if animation:
#        if highlight:
#            animation.play("pulse")
#        else:
#            animation.seek(0, true)
#            animation.stop(true)


################################################################################
# Helper Functions
################################################################################


func _update_effects():
    effect_shield.visible = minion_data.get("shield", false)
    icon_poison.visible = minion_data.get("poison", false)
    var ability = minion_data.get("effect", 0)
    var has_abilities = (ability & ABILITY_ICON_MASK) != 0
    icon_ability.visible = has_abilities
    icon_deathrattle.visible = minion_data.get("deathrattle", 0) != 0


#func _set_style_normal():
#    ._set_style_normal()
#    if animation and highlighted:
#        animation.play("pulse")


#func _set_style_selected():
#    ._set_style_selected()
#    if animation and animation.is_playing():
#        # animation.current_animation == "pulse"
#        animation.seek(0, true)
#        animation.stop(true)


#func _set_style_disabled():
#    #._set_style_disabled()
#    if selected:
#        ._set_style_selected()
#    else:
#        ._set_style_normal()
#    if animation and animation.is_playing():
#        # animation.current_animation == "pulse"
#        animation.seek(0, true)
#        animation.stop(true)


func _ready():
    render()
