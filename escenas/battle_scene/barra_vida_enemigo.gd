extends TextureRect

@export var imagenes: Array[Texture2D]

func actualizar_barra(vida_actual: float):
	print("Vida actual: ", vida_actual)
	if vida_actual <= 0:
		texture = imagenes[0]
		return


	var indice = int(ceil(vida_actual / 10.0))
	

	indice = clampi(indice, 0, 10)
	
	print("El indice es: ", indice)

	texture = imagenes[indice]
