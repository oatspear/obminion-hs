tool
extends HBoxContainer

################################################################################
# Variables
################################################################################

export (int) var stat1: int = 10 setget set_stat1
export (int) var stat2: int = 10 setget set_stat2

onready var label1 = $Stat1
onready var label2 = $Stat2

################################################################################
# Interface
################################################################################


func set_stat1(value: int):
    stat1 = value
    render()


func set_stat2(value: int):
    stat2 = value
    render()


func render():
    _render_stat1()
    _render_stat2()


################################################################################
# Helper Functions
################################################################################


func _render_stat1():
    if Engine.editor_hint:
        label1 = $Stat1
    label1.text = str(stat1)


func _render_stat2():
    if Engine.editor_hint:
        label2 = $Stat2
    label2.text = str(stat2)


################################################################################
# Event Handlers
################################################################################


func _ready():
    render()
