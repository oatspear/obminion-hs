tool
extends Node

################################################################################
# Constants
################################################################################


enum GameError {
    NONE = 0,
    BATTLE_STARTED,
    NOT_YOUR_TURN,
    NO_RESOURCES,
    BOARD_FULL,
}


enum ResourceType {
    NONE,
    RESOURCES,
    POWER,
    HEALTH,
}


const VALUE_ICONS = {
    ResourceType.RESOURCES: preload("res://assets/icons/crystal.png"),
    ResourceType.POWER: preload("res://assets/icons/sword.png"),
    ResourceType.HEALTH: preload("res://assets/icons/heart.png"),
}


enum CardType {
    NONE,
    MINION,
    TECH,
    SPELL,
    COMMANDER,
}


enum BoardLocation {
    NONE = 0,
    BASE,
    BATTLEFIELD,
    GRAVEYARD,
}


enum TargetMode {
    NONE,
    SELF,
    ATTACK_TARGET,
    HOSTILE_MINION,
    FRIENDLY_MINION,
}


const DEFAULT_MAX_RESOURCES = 5
const DEFAULT_STARTING_RESOURCES = 5
const DEFAULT_GRAVEYARD_SIZE = 2


enum Abilities {
    NONE                        = 0b_0000_0000_0000_0000,
    HASTE                       = 0b_0000_0000_0000_0001,
    POISON                      = 0b_0000_0000_0000_0010,
    DIVINE_SHIELD               = 0b_0000_0000_0000_0100,
    BUFF_ADJACENT_ALLY_POWER    = 0b_0000_0001_0000_0000,
    BUFF_ADJACENT_ALLY_HEALTH   = 0b_0000_0010_0000_0000,
}
