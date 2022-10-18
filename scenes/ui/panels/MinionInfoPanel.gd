extends PanelContainer

################################################################################
# Constants
################################################################################

const STR_SHOW_INFO = "+ Info"
const STR_HIDE_INFO = "- Info"

################################################################################
# Variables
################################################################################

onready var info_content = $Elements/MinionInfoContent
onready var button_info: Button = $Elements/InfoButton

################################################################################
# Interface
################################################################################


func set_minion_data(data: Dictionary):
    info_content.set_minion_data(data)


func reset_ui():
    info_content.hide()
    button_info.text = STR_SHOW_INFO
    button_info.pressed = false


################################################################################
# Event Handlers
################################################################################


func _ready():
    reset_ui()


func _on_info_button_toggled(button_pressed: bool):
    if button_pressed:
        info_content.show()
        button_info.text = STR_HIDE_INFO
    else:
        reset_ui()
