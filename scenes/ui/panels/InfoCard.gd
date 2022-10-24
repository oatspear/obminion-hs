extends VBoxContainer

################################################################################
# Constants
################################################################################

const DEFAULT_DATA = {
    "name": "Card Name",
    "type": Global.CardType.NONE,
    "cost": 0,
    "resource": Global.ResourceType.NONE,
    "effect": 0,
    "effect_text": "",
}

################################################################################
# Variables
################################################################################

onready var label_name: Label = $NameTypeCost/NameType/Name
onready var label_type: Label = $NameTypeCost/NameType/Type
onready var label_cost = $NameTypeCost/Cost
onready var label_power = $Stats/Power
onready var label_health = $Stats/Health
onready var label_effect: RichTextLabel = $Effects

################################################################################
# Interface
################################################################################


func set_display_data(data: Dictionary):
    if not data:
        data = DEFAULT_DATA
    _render_name(data)
    _render_type(data)
    _render_cost(data)
    _render_stats(data)
    _render_effects(data)


################################################################################
# Helper Functions
################################################################################


func _render_name(data: Dictionary):
    label_name.text = data.get("name", "Card Name")


func _render_type(data: Dictionary):
    match data.get("type", Global.CardType.NONE):
        Global.CardType.MINION:
            label_type.text = data.get("tribe", "Minion Tribe")
        Global.CardType.TECH:
            label_type.text = "Tech"
        Global.CardType.SPELL:
            label_type.text = "Spell"
        Global.CardType.COMMANDER:
            label_type.text = "Commander"
        _:
            label_type.text = ""


func _render_cost(data: Dictionary):
    label_cost.set_value(data.get("cost", 0))
    label_cost.set_value_type(data.get("resource", Global.ResourceType.RESOURCES))


func _render_stats(data: Dictionary):
    var x = data.get("power")
    if x == null:
        label_power.hide()
    else:
        label_power.set_value(x)
        label_power.show()
    x = data.get("health")
    if x == null:
        label_health.hide()
    else:
        label_health.set_value(x)
        label_health.show()


func _render_effects(data: Dictionary):
    label_effect.bbcode_text = data.get("effect_text", "")
