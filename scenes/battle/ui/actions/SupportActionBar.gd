extends VBoxContainer

################################################################################
# Constants
################################################################################

const NO_DATA: Dictionary = {}

################################################################################
# Signals
################################################################################

signal display_info(data)
signal hide_info()
signal use_support(support)
signal cancel_action()

################################################################################
# Variables
################################################################################

var _selected_support = null

onready var button_info = $InfoToggle
onready var token1 = $Supports/Support1
onready var token2 = $Supports/Support2
onready var token3 = $Supports/Support3
onready var token4 = $Supports/Support4
onready var token5 = $Supports/Support5
onready var token6 = $Supports/Support6
onready var button_cancel = $Actions/Cancel
onready var button_use = $Actions/Use

################################################################################
# Interface
################################################################################


func reset_data():
    token1.support_data = null
    token2.support_data = null
    token3.support_data = null
    token4.support_data = null
    token5.support_data = null
    token6.support_data = null


func reset_ui():
    button_use.disabled = true
    if _selected_support != null:
        _selected_support.set_selected(false)
    _selected_support = null
    button_info.pressed = false
    emit_signal("hide_info")


################################################################################
# Helper Functions
################################################################################


func _select_token(token):
    var previous = _selected_support
    assert(previous != token, "'selected' should only trigger on toggle")
    _selected_support = token
    button_use.disabled = false
    if previous != null:
        # delay signal-emitting calls to the tail
        previous.set_selected(false)
    if button_info.pressed:
        emit_signal("display_info", token.support_data.as_dict())


func _on_token_deselected(token):
    if _selected_support == token:
        _selected_support = null
        button_use.disabled = true
        if button_info.pressed:
            emit_signal("hide_info")


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_use_button_pressed():
    if _selected_support:
        emit_signal("use_support", _selected_support)


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
    _on_token_deselected(token1)


func _on_token2_deselected():
    _on_token_deselected(token2)


func _on_token3_deselected():
    _on_token_deselected(token3)


func _on_token4_deselected():
    _on_token_deselected(token4)


func _on_token5_deselected():
    _on_token_deselected(token5)


func _on_token6_deselected():
    _on_token_deselected(token6)


func _on_info_toggled(button_pressed: bool):
    if _selected_support != null:
        if button_pressed:
            emit_signal("display_info", _selected_support.support_data.as_dict())
        else:
            emit_signal("hide_info")
