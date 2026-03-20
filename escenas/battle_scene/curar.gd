extends Button

@onready var battle : Control = $"../../.."

func _ready() -> void:
	pressed.connect(_accion)
	mouse_entered.connect(_hover)


func _accion():
	battle._on_boton_curar_pressed()

func _hover():
	battle._reproducir_sonido_hover()
