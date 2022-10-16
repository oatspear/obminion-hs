extends HBoxContainer

################################################################################
# Constants
################################################################################

const MAX_MINIONS: int = 6

const MINION_DATA = {
    "name": "Minion",
    "power": 10,
    "health": 10,
    "faction": "Faction",
    "tribe": "Tribe",
    "supply": 1,
    "abilities": [],
}

################################################################################
# Signals
################################################################################


################################################################################
# Variables
################################################################################

var _minion_count: int = 0
var _selecting: bool = false

onready var minion1 = $Minion1
onready var minion2 = $Minion2
onready var minion3 = $Minion3
onready var minion4 = $Minion4
onready var minion5 = $Minion5
onready var minion6 = $Minion6

onready var minions: Array = [
    minion1,
    minion2,
    minion3,
    minion4,
    minion5,
    minion6,
]

################################################################################
# Interface
################################################################################


func get_minion_count() -> int:
    _minion_count = 0
    for minion in minions:
        if minion.has_minion_data():
            _minion_count += 1
    return _minion_count


func preprend_minion() -> bool:
    #minion_container.add_child(minion)
    #minion_container.move_child(minion, 0)
    return false


func append_minion() -> bool:
    if get_minion_count() >= MAX_MINIONS:
        return false
    var minion = minions[_minion_count]
    minion.set_minion_data(MINION_DATA)
    minion.show()
    return true


################################################################################
# Event Handlers
################################################################################


func _ready():
    for minion in minions:
        minion.set_minion_data(null)
        minion.visible = false
