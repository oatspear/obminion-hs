extends PanelContainer

################################################################################
# Constants
################################################################################

const STR_SHOW_INFO = "+ Info"
const STR_HIDE_INFO = "- Info"

################################################################################
# Variables
################################################################################

var display_data: Dictionary = {}

onready var panel_info = $Elements/InfoPanel
onready var button_info: Button = $Elements/InfoButton

################################################################################
# Interface
################################################################################


func set_display_data(data: Dictionary):
    display_data = data
    render()


func render():
    if button_info.pressed:
        button_info.text = STR_HIDE_INFO
        if display_data.empty():
            panel_info.hide()
        else:
            panel_info.set_display_data(display_data)
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


func _on_info_button_toggled(_button_pressed: bool):
    render()
