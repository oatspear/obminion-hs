extends VBoxContainer

################################################################################
# Signals
################################################################################

signal action_canceled()
signal show_info(minion_data)

################################################################################
# Variables
################################################################################

var _selected_minion = null

onready var token_minion1 = $Minions/Minion1
onready var token_minion2 = $Minions/Minion2
onready var token_minion3 = $Minions/Minion3
onready var token_minion4 = $Minions/Minion4
onready var token_minion5 = $Minions/Minion5
onready var token_minion6 = $Minions/Minion6
onready var button_cancel = $Actions/Cancel
onready var button_deploy = $Actions/Deploy

################################################################################
# Interface
################################################################################


func reset_ui():
    button_cancel.disabled = true
    button_deploy.disabled = true
    if _selected_minion != null:
        _selected_minion.set_selected(false)
    _selected_minion = null


################################################################################
# Helper Functions
################################################################################


func _select_minion(token):
    var previous = _selected_minion
    assert(previous != token, "'selected' should only trigger on toggle")
    _selected_minion = token
    button_cancel.disabled = false
    button_deploy.disabled = false
    if previous != null:
        # delay signal-emitting calls to the tail
        previous.set_selected(false)
    emit_signal("show_info", token.minion_data.as_dict())


func _on_minion_deselected(token):
    if _selected_minion == token:
        _selected_minion = null
        reset_ui()


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_cancel_button_pressed():
    emit_signal("action_canceled")


func _on_minion1_selected():
    _select_minion(token_minion1)


func _on_minion2_selected():
    _select_minion(token_minion2)


func _on_minion3_selected():
    _select_minion(token_minion3)


func _on_minion4_selected():
    _select_minion(token_minion4)


func _on_minion5_selected():
    _select_minion(token_minion5)


func _on_minion6_selected():
    _select_minion(token_minion6)


func _on_minion1_deselected():
    _on_minion_deselected(token_minion1)


func _on_minion2_deselected():
    _on_minion_deselected(token_minion2)


func _on_minion3_deselected():
    _on_minion_deselected(token_minion3)


func _on_minion4_deselected():
    _on_minion_deselected(token_minion4)


func _on_minion5_deselected():
    _on_minion_deselected(token_minion5)


func _on_minion6_deselected():
    _on_minion_deselected(token_minion6)
