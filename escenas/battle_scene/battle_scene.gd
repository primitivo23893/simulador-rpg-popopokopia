extends Control

var vida_enemigo: float = 100.0
var vida_jugador: float = 100.0
var batalla_terminada: bool = false

@onready var barra_enemigo = $CanvasLayer/InfoEnemigo/BarraVidaEnemigo 
@onready var label_enemigo = $CanvasLayer/InfoEnemigo/Enemigo
@onready var label_vida_enemigo =  $CanvasLayer/InfoEnemigo/VidaEnemigo

@onready var barra_jugador = $CanvasLayer/InfoJugador/BarraVidaJugador
@onready var label_jugador = $CanvasLayer/InfoJugador/Jugador
@onready var label_vida_jugador =  $CanvasLayer/InfoJugador/VidaJugador

@onready var texto_batalla = $CanvasLayer/CajaInferior/TextoBatalla 

@onready var nodo_enemigo = $Enemigo 
@onready var nodo_jugador = $Jugador

func _ready():

	nodo_enemigo.pokemon_cambiado.connect(_on_pokemon_cambiado)
	nodo_enemigo.equipo_derrotado.connect(_on_equipo_derrotado)
	
	nodo_jugador.pokemon_cambiado.connect(_on_pokemon_cambiado_jugador)
	

	nodo_enemigo.cargar_siguiente_pokemon()
	barra_enemigo.actualizar_barra(vida_enemigo)
	
	nodo_jugador.cargar_siguiente_pokemon()
	barra_jugador.actualizar_barra(vida_jugador)
	

func _ataque(danio: float):
	if batalla_terminada:
		return
		
	vida_enemigo -= danio
	label_vida_enemigo.text = str(int(vida_enemigo))
	if vida_enemigo <= 0:
		vida_enemigo = 0
		barra_enemigo.actualizar_barra(vida_enemigo) 
		texto_batalla.text = "¡El enemigo se ha debilitado!"
		_cambiar_pokemon_enemigo()
	else:
		barra_enemigo.actualizar_barra(vida_enemigo)
		texto_batalla.text = "Ataque! Daño: " + str(danio)
		# Animacion

func _cambiar_pokemon_enemigo():

	vida_enemigo = 100.0
	barra_enemigo.actualizar_barra(vida_enemigo)
	

	nodo_enemigo.cargar_siguiente_pokemon()

func _on_pokemon_cambiado(nombre_nuevo: String):
	label_enemigo.text = nombre_nuevo
	texto_batalla.text = "¡Un " + nombre_nuevo + " salvaje apareció!"
	
func _on_pokemon_cambiado_jugador(nombre_nuevo: String):
	label_jugador.text = nombre_nuevo
	texto_batalla.text = "¡Adelante,  " + nombre_nuevo+ "!"

func _on_equipo_derrotado():
	batalla_terminada = true
	label_enemigo.text = "Sin Pokomons"
	texto_batalla.text = "¡Has ganado la batalla! El enemigo no tiene más Pokomon."
	barra_enemigo.hide()
	label_vida_enemigo.hide()
