extends Resource

class_name MinionData

################################################################################
# Variables
################################################################################

export (String) var name: String = "Minion"
export (String) var faction: String = "Faction"
export (String) var tribe: String = "Tribe"
export (int) var species: int = 0

export (int) var power: int = 0
export (int) var health: int = 0
export (int) var supply: int = 0

export (int) var ability: int = 0
export (String) var ability_text: String = ""

################################################################################
# Interface
################################################################################


func as_dict() -> Dictionary:
    return {
        "name": name,
        "faction": faction,
        "tribe": tribe,
        "species": species,
        "power": power,
        "health": health,
        "supply": supply,
        "ability": ability,
        "ability_text": ability_text,
    }
