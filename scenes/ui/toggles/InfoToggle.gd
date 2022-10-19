extends PanelContainer

################################################################################
# Constants
################################################################################

const STR_SHOW_INFO = "+ Info"
const STR_HIDE_INFO = "- Info"

################################################################################
# Variables
################################################################################

var minion_data: Dictionary = {}

onready var panel_info = $Elements/MinionInfo
onready var button_info: Button = $Elements/InfoButton

################################################################################
# Interface
################################################################################


func set_minion_data(data: Dictionary):
    minion_data = data
    render()


func render():
    if button_info.pressed:
        button_info.text = STR_HIDE_INFO
        if minion_data.empty():
            panel_info.hide()
        else:
            panel_info.set_minion_data(minion_data)
            panel_info.show()
    else:
        button_info.text = STR_SHOW_INFO
        panel_info.hide()


func reset_ui():
    button_info.pressed = false
    render()


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_info_button_toggled(button_pressed: bool):
    render()
