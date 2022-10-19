extends VBoxContainer

################################################################################
# Variables
################################################################################

onready var label_name: Label = $NameTypeCost/NameType/Name
onready var label_type: Label = $NameTypeCost/NameType/Type
onready var label_cost = $NameTypeCost/Gold
onready var label_effect: RichTextLabel = $Effects

################################################################################
# Interface
################################################################################


func set_display_data(support_data: Dictionary):
    if support_data:
        label_name.text = support_data["name"]
        label_type.text = support_data["type"]
        label_cost.set_value(support_data["cost"])
        label_effect.bbcode_text = support_data["effect_text"]
