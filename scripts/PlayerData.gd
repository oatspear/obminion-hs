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
