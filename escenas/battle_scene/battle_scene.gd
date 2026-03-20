extends Control

enum EstadoBatalla { TURNO_JUGADOR, ACCION_JUGADOR, TURNO_ENEMIGO, RESOLUCION }
var estado_actual = EstadoBatalla.TURNO_JUGADOR

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

@onready var sonido_ataque = $Audio/SonidoAtaque

@onready var sonido_hover = $Audio/SndHover
@onready var sonido_select = $Audio/SndSelect

func _ready():

	nodo_enemigo.pokemon_cambiado.connect(_on_pokemon_cambiado)
	nodo_enemigo.equipo_derrotado.connect(_on_equipo_derrotado)
	
	nodo_jugador.pokemon_cambiado.connect(_on_pokemon_cambiado_jugador)
	nodo_jugador.equipo_derrotado.connect(_on_equipo_derrotado_jugador)

	nodo_enemigo.cargar_siguiente_pokemon()
	barra_enemigo.actualizar_barra(vida_enemigo)
	
	nodo_jugador.cargar_siguiente_pokemon()
	barra_jugador.actualizar_barra(vida_jugador)


func _ataque(danio: float):
	if batalla_terminada or estado_actual != EstadoBatalla.TURNO_JUGADOR:
		return
		
	estado_actual = EstadoBatalla.ACCION_JUGADOR
	texto_batalla.text = "¡Atacaste!"
	
	nodo_jugador.ejecutar_animacion_ataque()
	await get_tree().create_timer(0.2).timeout 
	
	sonido_ataque.play()
	nodo_enemigo.recibir_golpe()
	
	vida_enemigo -= danio
	label_vida_enemigo.text = str(int(max(0, vida_enemigo)))
	barra_enemigo.actualizar_barra(vida_enemigo)
	texto_batalla.text = "Daño: " + str(danio)
	
	await get_tree().create_timer(1.2).timeout 
	_revisar_resolucion("enemigo")

func _turno_enemigo():
	if batalla_terminada: return
	estado_actual = EstadoBatalla.TURNO_ENEMIGO
	texto_batalla.text = "¡El enemigo ataca!"
	
	await get_tree().create_timer(0.8).timeout
	
	nodo_enemigo.ejecutar_animacion_ataque()
	await get_tree().create_timer(0.2).timeout
	
	sonido_ataque.play()
	nodo_jugador.recibir_golpe()
	
	var danio_enemigo = randf_range(10.0, 25.0)
	vida_jugador -= danio_enemigo
	
	label_vida_jugador.text = str(int(max(0, vida_jugador)))
	barra_jugador.actualizar_barra(vida_jugador)
	texto_batalla.text = "Recibiste " + str(int(danio_enemigo)) + " de daño."
	
	await get_tree().create_timer(1.5).timeout
	_revisar_resolucion("jugador")
	
	
func _revisar_resolucion(quien_recibio_danio: String):
	estado_actual = EstadoBatalla.RESOLUCION
	
	if quien_recibio_danio == "enemigo" and vida_enemigo <= 0:
		vida_enemigo = 0
		texto_batalla.text = "¡El enemigo se ha debilitado!"
		
		nodo_enemigo.ejecutar_animacion_muerte()
		$Audio/Explosion.play()
		
		await get_tree().create_timer(1.5).timeout
		_cambiar_pokemon_enemigo()
		
	elif quien_recibio_danio == "jugador" and vida_jugador <= 0:
		vida_jugador = 0
		texto_batalla.text = "¡Tu Pokomon se ha debilitado!"
		
		nodo_jugador.ejecutar_animacion_muerte()
		$Audio/Explosion.play()
		
		await get_tree().create_timer(1.5).timeout
		_cambiar_pokemon_jugador() 
		
	else:
		# Si nadie ha muerto hay que cambiar de turno
		if quien_recibio_danio == "enemigo":
			_turno_enemigo()
		else:
			estado_actual = EstadoBatalla.TURNO_JUGADOR
			texto_batalla.text = "¡Es tu turno! ¿Qué vas a hacer?"


func _cambiar_pokemon_enemigo():
	vida_enemigo = 100.0
	barra_enemigo.actualizar_barra(vida_enemigo)
	
	label_vida_enemigo.text = str(int(vida_enemigo))
	
	var quedan_pokemons = nodo_enemigo.cargar_siguiente_pokemon()
	
	if quedan_pokemons:
		await get_tree().create_timer(1.5).timeout 
		estado_actual = EstadoBatalla.TURNO_JUGADOR
		texto_batalla.text = "¡Es tu turno! ¿Qué vas a hacer?"

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
	$Audio/SndWin.play()
	$Audio/MusicaFondo.stop()
	barra_enemigo.hide()
	label_vida_enemigo.hide()



func _cambiar_pokemon_jugador():
	vida_jugador = 100.0
	barra_jugador.actualizar_barra(vida_jugador)
	
	label_vida_jugador.text = str(int(vida_jugador))
	
	var quedan_pokemons = nodo_jugador.cargar_siguiente_pokemon()

	
	if quedan_pokemons:
		estado_actual = EstadoBatalla.TURNO_JUGADOR
		await get_tree().create_timer(1.0).timeout
		texto_batalla.text = "¡Es tu turno! ¿Qué vas a hacer?"


func _on_equipo_derrotado_jugador():
	batalla_terminada = true
	label_jugador.text = "Sin Pokomons"
	texto_batalla.text = "¡Tu equipo ha sido derrotado! Fin del juego."
	barra_jugador.hide()
	label_vida_jugador.hide()





func _on_boton_ataque_1_pressed():
	# Ataque seguro
	if estado_actual == EstadoBatalla.TURNO_JUGADOR and not batalla_terminada:
		sonido_select.play()
		_ataque(20)

func _on_boton_ataque_2_pressed():
	# Ataque pero puede fallar
	if estado_actual == EstadoBatalla.TURNO_JUGADOR and not batalla_terminada:
		sonido_select.play()
		estado_actual = EstadoBatalla.ACCION_JUGADOR 
		
		var probabilidad_acierto = randi() % 100
		
		if probabilidad_acierto < 65: 
			var danio_aleatorio = randf_range(25.0, 45.0) 
			
			estado_actual = EstadoBatalla.TURNO_JUGADOR 
			_ataque(int(danio_aleatorio))
			
		elif probabilidad_acierto < 98:
			var danio_aleatorio = randf_range(25.0, 45.0) * 2
			
			if has_node("Audio/SonidoAtaqueCritico"):
				$Audio/SonidoAtaqueCritico.play()
				
			texto_batalla.text = "¡Tu Pokomon ESTA HACIENDO UN ATAQUE CARGADO!"
			
			await get_tree().create_timer(5.0).timeout 
			
			estado_actual = EstadoBatalla.TURNO_JUGADOR
			_ataque(int(danio_aleatorio))
			
		else:
			texto_batalla.text = "¡Tu Pokomon atacó... pero falló!"
			nodo_jugador.ejecutar_animacion_ataque() 
			
			await get_tree().create_timer(2.0).timeout
			
			_turno_enemigo()

func _on_boton_curar_pressed():

	if estado_actual == EstadoBatalla.TURNO_JUGADOR and not batalla_terminada:
		estado_actual = EstadoBatalla.ACCION_JUGADOR
		sonido_select.play()
		# 30 de vida son exeder de 100
		vida_jugador = min(vida_jugador + 30.0, 100.0)
		label_vida_jugador.text = str(int(vida_jugador))
		barra_jugador.actualizar_barra(vida_jugador)
		
		texto_batalla.text = "¡Usaste una Poción! Recuperaste salud."
		
		$Audio/SndPacify.play()
			
		await get_tree().create_timer(1.5).timeout
		
		_turno_enemigo()

func _on_boton_correr_pressed():
	if estado_actual == EstadoBatalla.TURNO_JUGADOR and not batalla_terminada:
		estado_actual = EstadoBatalla.ACCION_JUGADOR
		sonido_select.play()
		texto_batalla.text = "¡Intentaste huir... pero no puedes escapar de una batalla \nde entrenador!"
		$Audio/SndEscaped.play()
		await get_tree().create_timer(2.0).timeout
		
		_turno_enemigo()


func _reproducir_sonido_hover():
	if estado_actual == EstadoBatalla.TURNO_JUGADOR and not batalla_terminada:
		sonido_hover.play()
