extends VBoxContainer

################################################################################
# Constants
################################################################################

const NO_DATA: Dictionary = {}

################################################################################
# Signals
################################################################################

signal deploy_minion(minion)
signal cancel_action()

################################################################################
# Variables
################################################################################

var _selected_minion = null

onready var panel_info: InfoToggle = $InfoToggle
onready var token1 = $Minions/Minion1
onready var token2 = $Minions/Minion2
onready var token3 = $Minions/Minion3
onready var token4 = $Minions/Minion4
onready var token5 = $Minions/Minion5
onready var token6 = $Minions/Minion6
onready var button_cancel = $Actions/Cancel
onready var button_deploy = $Actions/Deploy

################################################################################
# Interface
################################################################################


func reset_ui():
    button_deploy.disabled = true
    if _selected_minion != null:
        _selected_minion.set_selected(false)
    _selected_minion = null
    panel_info.set_display_data(NO_DATA)


################################################################################
# Helper Functions
################################################################################


func _select_token(token):
    var previous = _selected_minion
    assert(previous != token, "'selected' should only trigger on toggle")
    _selected_minion = token
    button_deploy.disabled = false
    if previous != null:
        # delay signal-emitting calls to the tail
        previous.set_selected(false)
    panel_info.set_display_data(token.minion_data.as_dict())


func _token_deselected(token):
    if _selected_minion == token:
        _selected_minion = null
        reset_ui()


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_deploy_button_pressed():
    if _selected_minion:
        emit_signal("deploy_minion", _selected_minion)


func _on_cancel_button_pressed():
    emit_signal("cancel_action")


func _on_token1_selected():
    _select_token(token1)


func _on_token2_selected():
    _select_token(token2)


func _on_token3_selected():
    _select_token(token3)


func _on_token4_selected():
    _select_token(token4)


func _on_token5_selected():
    _select_token(token5)


func _on_token6_selected():
    _select_token(token6)


func _on_token1_deselected():
    _token_deselected(token1)


func _on_token2_deselected():
    _token_deselected(token2)


func _on_token3_deselected():
    _token_deselected(token3)


func _on_token4_deselected():
    _token_deselected(token4)


func _on_token5_deselected():
    _token_deselected(token5)


func _on_token6_deselected():
    _token_deselected(token6)
