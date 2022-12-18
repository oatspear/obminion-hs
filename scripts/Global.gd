tool
extends Node

################################################################################
# Constants
################################################################################

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
