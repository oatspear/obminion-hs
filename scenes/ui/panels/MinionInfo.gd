extends VBoxContainer

################################################################################
# Variables
################################################################################

onready var label_name: Label = $NameTribeCost/NameTribe/Name
onready var label_tribe: Label = $NameTribeCost/NameTribe/Tribe
onready var label_supply = $NameTribeCost/Food
onready var portrait: TextureRect = $PortraitStats/Portrait/Texture
onready var label_power: Label = $PortraitStats/Stats/Power/Value
onready var label_health: Label = $PortraitStats/Stats/Health/Value
onready var label_ability: RichTextLabel = $Abilities

################################################################################
# Interface
################################################################################


func set_display_data(minion_data: Dictionary):
    if minion_data:
        label_name.text = minion_data["name"]
        label_tribe.text = minion_data["tribe"]
        label_supply.set_value(minion_data["supply"])
        # portrait
        label_power.text = str(minion_data["power"])
        label_health.text = str(minion_data["health"])
        label_ability.bbcode_text = minion_data["ability_text"]
