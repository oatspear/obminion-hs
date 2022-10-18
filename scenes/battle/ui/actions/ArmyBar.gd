extends VBoxContainer

################################################################################
# Constants
################################################################################


################################################################################
# Signals
################################################################################


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
onready var panel_info = $MinionCard
onready var button_info = $Actions/Info
onready var button_deploy = $Actions/Deploy

################################################################################
# Interface
################################################################################


func reset_ui():
    panel_info.hide()
    button_info.disabled = true
    button_deploy.disabled = true
    if _selected_minion != null:
        _selected_minion.set_selected(false)
    _selected_minion = null
    button_info.text = "Info"


################################################################################
# Helper Functions
################################################################################


func _select_minion(token):
    var previous = _selected_minion
    assert(previous != token, "'selected' should only trigger on toggle")
    _selected_minion = token
    panel_info.set_minion_data(token.minion_data.as_dict())
    button_info.disabled = false
    button_deploy.disabled = false
    if previous != null:
        # delay signal-emitting calls to the tail
        previous.set_selected(false)


func _on_minion_deselected(token):
    if _selected_minion == token:
        _selected_minion = null
        reset_ui()


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_info_button_pressed():
    assert(_selected_minion != null)
    if panel_info.visible:
        panel_info.hide()
        button_info.text = "Info"
    else:
        panel_info.show()
        button_info.text = "Hide"


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
