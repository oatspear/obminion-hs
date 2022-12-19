extends Resource

class_name PlayerData

################################################################################
# Variables
################################################################################

export (String) var name: String = "Player"
export (String) var faction: String = "Faction"

export (int) var resources: int = Global.DEFAULT_STARTING_RESOURCES
export (int) var max_resources: int = Global.DEFAULT_MAX_RESOURCES
export (int) var graveyard_size: int = Global.DEFAULT_GRAVEYARD_SIZE

export (Array, Resource) var minions: Array = []
export (Array, Resource) var support: Array = []

################################################################################
# Interface
################################################################################


func reset():
    # useful to ensure that exported arrays are not shared between instances
    name = "Player"
    faction = "Faction"
    resources = Global.DEFAULT_STARTING_RESOURCES
    max_resources = Global.DEFAULT_MAX_RESOURCES
    graveyard_size = Global.DEFAULT_GRAVEYARD_SIZE
    minions = []
    support = []
