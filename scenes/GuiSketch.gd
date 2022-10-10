extends MarginContainer

var _countdown = 0.0
onready var btn_end_turn = $Board/Decks/VBoxContainer/Button


func _process(delta):
    if _countdown > 0.0:
        _countdown -= delta
        if _countdown <= 0.0:
            _countdown = 0.0
            btn_end_turn.disabled = false


func _on_end_turn_pressed():
    print("End Turn")
    btn_end_turn.disabled = true
    _countdown = 5.0
