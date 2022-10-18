extends PanelContainer

################################################################################
# Variables
################################################################################

onready var label_name: Label = $Margin/VBox/NameTribeCost/NameTribe/Name
onready var label_tribe: Label = $Margin/VBox/NameTribeCost/NameTribe/Tribe
onready var label_supply = $Margin/VBox/NameTribeCost/Food
onready var portrait: TextureRect = $Margin/VBox/PortraitStats/Portrait/Texture
onready var label_power: Label = $Margin/VBox/PortraitStats/Stats/Power/Value
onready var label_health: Label = $Margin/VBox/PortraitStats/Stats/Health/Value
onready var label_ability: RichTextLabel = $Margin/VBox/Abilities

################################################################################
# Interface
################################################################################


func set_minion_data(minion_data: Dictionary):
    label_name.text = minion_data["name"]
    label_tribe.text = minion_data["tribe"]
    label_supply.set_value(minion_data["supply"])
    # portrait
    label_power.text = str(minion_data["power"])
    label_health.text = str(minion_data["health"])
    label_ability.bbcode_text = minion_data["ability_text"]
