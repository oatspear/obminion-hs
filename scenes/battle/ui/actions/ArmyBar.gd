extends VBoxContainer

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


func _is_click_event(event: InputEvent) -> bool:
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == BUTTON_LEFT:
            return true
    return false


func _select_minion(token):
    if _selected_minion != null:
        _selected_minion.set_selected(false)
    if _selected_minion == token:
        _selected_minion = null
        reset_ui()
    else:
        _selected_minion = token
        _selected_minion.set_selected(true)
        # panel_info.set_minion_data(token.minion_data)
        button_info.disabled = false
        button_deploy.disabled = false


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


func _on_minion1_gui_input(event: InputEvent):
    if _is_click_event(event):
        _select_minion(token_minion1)


func _on_minion2_gui_input(event):
    if _is_click_event(event):
        _select_minion(token_minion2)


func _on_minion3_gui_input(event):
    if _is_click_event(event):
        _select_minion(token_minion3)


func _on_minion4_gui_input(event):
    if _is_click_event(event):
        _select_minion(token_minion4)


func _on_minion5_gui_input(event):
    if _is_click_event(event):
        _select_minion(token_minion5)


func _on_minion6_gui_input(event):
    if _is_click_event(event):
        _select_minion(token_minion6)
