class_name Jugador
extends Node2D

@onready var sprite = $Pokomon


var nombres_pokemon = [
	"Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", 
	"Charizard", "Squirtle", "Wartortle", "Blastoise", "Caterpie"
]

var equipo_jugador = [] 
var pokemon_actual = {} 

signal pokemon_cambiado(nombre_nuevo)
signal equipo_derrotado

func _ready() -> void:
	randomize()
	generar_equipo(3)
	
	
func generar_equipo(cantidad: int):
	equipo_jugador.clear()
	
	for i in range(cantidad):
		var poke_id = randi() % 10 # Candidad de Pokemons 10
		var variante = 0
		
		var probabilidad = randi() % 100 
		
		if probabilidad < 97: 
			variante = 0  # normal
		elif probabilidad < 99:
			variante = 1   # shiny
		else:
			variante = 2 # b y n

		var frame_base = 0
		# Si es de los primeros 10 
		if poke_id < 10:
			frame_base = (poke_id * 3) + variante
		else:
		# Si no, en la fila 3
			frame_base = 60 + ((poke_id - 10) * 3) + variante
			
		equipo_jugador.append({
			"nombre": nombres_pokemon[poke_id],
			"frame_reposo": frame_base,
			"frame_ataque": frame_base + 30 # +30 frmases para ir a la fila de abajo
		})
		print(equipo_jugador)
		
func cargar_siguiente_pokemon() -> bool:
	if equipo_jugador.size() > 0:
		pokemon_actual = equipo_jugador.pop_front()
		sprite.frame = pokemon_actual["frame_reposo"]
		pokemon_cambiado.emit(pokemon_actual["nombre"])
		return true
	else:
		equipo_derrotado.emit()
		sprite.visible = false
		return false

func ejecutar_animacion_ataque():
	sprite.frame = pokemon_actual["frame_ataque"]
	await get_tree().create_timer(0.5).timeout 
	sprite.frame = pokemon_actual["frame_reposo"]
