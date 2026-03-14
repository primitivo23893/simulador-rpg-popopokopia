extends Button

@onready var battle : Control = $"../../.."

func _ready() -> void:
	pressed.connect(_ataque)


func _ataque():
	battle._ataque(5.0)
