extends PopupPanel

################################################################################
# Variables
################################################################################

onready var info_card = $Margin/InfoCard

################################################################################
# Interface
################################################################################


func set_display_data(data: Dictionary):
    info_card.set_display_data(data)