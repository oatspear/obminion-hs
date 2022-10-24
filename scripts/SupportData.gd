extends Resource

class_name SupportData

################################################################################
# Variables
################################################################################

export (String) var name: String = "Support"
export (String) var faction: String = "Faction"
export (String) var type: String = "Tech"
export (int) var species: int = 0

export (int) var cost: int = 0

export (int) var effect: int = 0
export (String) var effect_text: String = ""

################################################################################
# Interface
################################################################################


func as_dict() -> Dictionary:
    return {
        "name": name,
        "type": Global.CardType.TECH,
        "faction": faction,
        "species": species,
        "cost": cost,
        "resource": Global.ResourceType.RESOURCES,
        "effect": effect,
        "effect_text": effect_text,
    }

