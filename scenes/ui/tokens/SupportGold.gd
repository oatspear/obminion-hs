tool
extends "res://scenes/ui/SelectablePanel.gd"

################################################################################
# Variables
################################################################################

export (Resource) var support_data setget set_support_data

onready var portrait: TextureRect = $Elements/Portrait
onready var label_cost = $Elements/Gold

################################################################################
# Interface
################################################################################


func set_support_data(data):
    support_data = data
    render()


func render():
    .render()
    _render_portrait()
    _render_cost_label()


################################################################################
# Helper Functions
################################################################################


func _render_portrait():
    pass


func _render_cost_label():
    var value = 0 if not support_data else support_data.cost
    if Engine.editor_hint and is_inside_tree():
        label_cost = $Elements/Gold
    if label_cost:
        label_cost.set_value(value)


################################################################################
# Event Handlers
################################################################################


func _ready():
    ._ready()
