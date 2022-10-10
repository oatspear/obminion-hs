extends MarginContainer

################################################################################
# Signals
################################################################################


################################################################################
# Variables
################################################################################

onready var action_bar_army: Control = $VBox/ArmyBar
onready var action_bar_support: Control = $VBox/SupportBar

################################################################################
# Interface
################################################################################


################################################################################
# Event Handlers
################################################################################


func _ready():
    action_bar_army.visible = false
    action_bar_support.visible = false


func _on_PrimaryActionBar_show_army():
    action_bar_army.visible = true


func _on_PrimaryActionBar_hide_army():
    action_bar_army.visible = false


func _on_PrimaryActionBar_show_support():
    action_bar_support.visible = true


func _on_PrimaryActionBar_hide_support():
    action_bar_support.visible = false
