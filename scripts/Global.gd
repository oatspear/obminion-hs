extends Node

################################################################################
# Constants
################################################################################

enum ValueType {
    NONE,
    RESOURCES,
    POWER,
    HEALTH,
}

const VALUE_ICONS = {
    ValueType.RESOURCES: preload("res://assets/icons/crystal.png"),
    ValueType.POWER: preload("res://assets/icons/sword.png"),
    ValueType.HEALTH: preload("res://assets/icons/heart.png"),
}


enum CardType {
    NONE,
    MINION,
    TECH,
    SPELL,
    COMMANDER,
}
