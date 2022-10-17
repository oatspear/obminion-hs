extends PanelContainer

################################################################################
# Constants
################################################################################

const STYLE_NORMAL = preload("res://data/ui/minions/style_normal.tres")
const STYLE_SELECT = preload("res://data/ui/minions/style_select.tres")

################################################################################
# Interface
################################################################################


func set_selected(selected: bool):
    if selected:
        set("custom_styles/panel", STYLE_SELECT)
    else:
        set("custom_styles/panel", STYLE_NORMAL)
