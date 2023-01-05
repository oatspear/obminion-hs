tool
extends HBoxContainer

################################################################################
# Constants
################################################################################

const COLOR_NORMAL = Color.white
const COLOR_BUFF = Color.green
const COLOR_DEBUFF = Color.red

################################################################################
# Variables
################################################################################

export (int) var stat1: int = 10 setget set_stat1
export (int) var stat2: int = 10 setget set_stat2

export (int) var bonus1: int = 0 setget set_bonus1
export (int) var bonus2: int = 0 setget set_bonus2

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


func set_bonus1(value: int):
    if value > 0:
        label1.self_modulate = COLOR_BUFF
    elif value < 0:
        label1.self_modulate = COLOR_DEBUFF
    else:
        label1.self_modulate = COLOR_NORMAL


func set_bonus2(value: int):
    if value > 0:
        label2.self_modulate = COLOR_BUFF
    elif value < 0:
        label2.self_modulate = COLOR_DEBUFF
    else:
        label2.self_modulate = COLOR_NORMAL


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
