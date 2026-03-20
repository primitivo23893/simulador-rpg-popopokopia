extends Button

@onready var battle : Control = $"../../.."

func _ready() -> void:
	pressed.connect(_ataque)
	mouse_entered.connect(_hover)


func _ataque():
	battle._on_boton_ataque_1_pressed()

func _hover():
	battle._reproducir_sonido_hover()
