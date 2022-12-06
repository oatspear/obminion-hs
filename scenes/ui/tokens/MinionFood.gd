tool
extends "res://scenes/ui/SelectablePanel.gd"

################################################################################
# Variables
################################################################################

export (Resource) var minion_data setget set_minion_data

onready var portrait: TextureRect = $Elements/Portrait
onready var label_supply = $Elements/Cost

################################################################################
# Interface
################################################################################


func set_minion_data(data: MinionData):
    minion_data = data
    if data == null:
        hide()
    else:
        show()
        render()


func render():
    .render()
    _render_portrait()
    _render_supply_label()


################################################################################
# Helper Functions
################################################################################


func _render_portrait():
    pass


func _render_supply_label():
    var value = 0 if not minion_data else minion_data.supply
    if Engine.editor_hint and is_inside_tree():
        label_supply = $Elements/Cost
    if label_supply:
        label_supply.set_value(value)


################################################################################
# Event Handlers
################################################################################


func _ready():
    ._ready()
