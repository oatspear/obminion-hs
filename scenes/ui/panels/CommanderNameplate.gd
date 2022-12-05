extends HBoxContainer

################################################################################
# Variables
################################################################################

onready var label_name = $PlayerName
onready var label_resources = $Resources

################################################################################
# Interface
################################################################################


func set_player_name(player_name: String):
    label_name.text = player_name


func set_resources(value: int, maximum: int):
    label_resources.set_max_value(maximum)
    label_resources.set_value(value)
