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
