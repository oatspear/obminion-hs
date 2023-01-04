extends "res://scenes/ui/SelectablePanel.gd"

################################################################################
# Variables
################################################################################

var commander_data: Dictionary = {} setget set_commander_data
var can_act: bool = false

onready var portrait: TextureRect = $Elements/Portrait
onready var label_power = $Elements/Stats/Power
onready var label_health = $Elements/Stats/Health

################################################################################
# Interface
################################################################################


func has_commander_data() -> bool:
    return not commander_data.empty()


func set_commander_data(data: Dictionary):
    commander_data = data
    set_power(commander_data.get("power", 0))
    var health = commander_data.get("health", 0)
    health -= commander_data.get("damage", 0)
    set_health(health)


func reset_commander_data():
    return set_commander_data({})


func get_power() -> int:
    return label_power.current_value


func set_power(value: int):
    label_power.current_value = value


func inc_power(amount: int):
    label_power.current_value += amount


func dec_power(amount: int):
    label_power.current_value -= amount


func get_health() -> int:
    return label_health.current_value


func set_health(value: int):
    label_health.current_value = value


func inc_health(amount: int):
    label_health.current_value += amount


func dec_health(amount: int):
    label_health.current_value -= amount


################################################################################
# Helper Functions
################################################################################

func _ready():
    render()
