extends Panel

const GLOW_RATE = 0.8

var _decreasing: bool = false


func glow():
    set_process(true)
    _decreasing = false
    self_modulate.a = 0


func stop_glowing():
    set_process(false)
    self_modulate.a = 0


func _ready():
    stop_glowing()


func _process(delta: float):
    var r = GLOW_RATE * delta
    if _decreasing:
        self_modulate.a -= r
        if self_modulate.a <= 0:
            self_modulate.a *= -1
            _decreasing = false
    else:
        self_modulate.a += r
        if self_modulate.a >= 1.0:
            self_modulate.a -= self_modulate.a - 1.0
            _decreasing = true
