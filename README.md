# Pokomon Popopokopia

> **⚠️ DISCLAIMER**
> Este es un proyecto estrictamente académico, experimental y **sin fines de lucro**, desarrollado únicamente para aprender y experimentar con el motor Godot Engine. Todas las imágenes, nombres y referencias a "Pokémon" son propiedad intelectual de Nintendo, Creatures Inc. y Game Freak. No se pretende infringir ningún derecho de autor. 

Proyecto realizado en la clase de **Programación de Graficos 3D** del **Centro Universitario de Ciencias Exactas e Ingeniería (CUCEI) de la Universidad de Guadalajara** durante el semestre 2026A

**Alumno:** Primitivo Oyoque Vargas

**Profesor:** Jose Luis David Bonilla Carranza

## Sinopsis
Un simulador estratégico de combates por turnos inspirado en los clásicos RPG de la era de GameBoy. Gestiona tus ataques, calcula los riesgos y vacía la barra de salud de los monstruos de tu rival antes de que él lo haga contigo. 

## Mecánicas de Juego
* **Combate por Turnos:** El núcleo del juego. Debes esperar tu turno para ejecutar una acción, tras lo cual el oponente responderá de manera automática.
* **Gestión de Riesgo y Recompensa:** Tienes a tu disposición distintos ataques:
  * *Ataque Seguro:* Daño constante que nunca falla.
  * *Ataque Arriesgado:* Tiene probabilidad de fallar, pero si conecta, puede infligir un daño masivo o incluso un golpe crítico doble.
* **Supervivencia y Estrategia:** Puedes sacrificar tu turno de ataque para consumir una poción y curar tus puntos de vida (HP) o intentar huir del combate.
* **Relevos Automáticos:** Al debilitarse un Pokomon (ya sea tuyo o del rival), el siguiente monstruo en el equipo saldrá automáticamente a la arena con su barra de vida intacta.

## Características del Proyecto
* **Motor Gráfico:** Desarrollado en [Godot Engine 4.6](https://godotengine.org/).
* **Estado:** Prototipo jugable (HTML5).

## Implementaciones Adicionales
* **Arquitectura por Código:** Todo el sistema de interfaz de usuario (botones, bloqueos de turno, señales) está estructurado 100% mediante scripts (`.connect()`), logrando un código limpio y modular sin depender de las conexiones visuales del editor.
* **Feedback Audiovisual (Juice):** Sistema de partículas interactivo al recibir daño.
  * Animaciones de explosión *frame by frame* al debilitarse un oponente.
  * Sonidos dinámicos de interfaz (efectos de *hover* al pasar el ratón y *click* al seleccionar).
* **Máquina de Estados (State Machine):** Un sistema robusto que bloquea la interfaz durante las animaciones y acciones del enemigo para evitar que el jugador envíe múltiples inputs simultáneos.

## Controles

### Teclado y Ratón / Pantalla Táctil
* **Navegación:** `Movimiento del Ratón` 
* **Seleccionar Acción:** `Clic Izquierdo` (o toque en pantalla) sobre los botones de la interfaz:
  * Ataque 1
  * Ataque 2
  * Curar
  * Correr

---
---
**Créditos y Recursos Adicionales:**
* **Sprites de Pokomon:** Extraídos con fines educativos y sin fines de lucro desde [The Spriters Resource](https://www.spriters-resource.com/) y [PokemonDB](https://pokemondb.net/sprites).
* **Barras de Vida (Progreso):** Paquete de assets creado por [ToastedThomas en itch.io](https://toastedthomas.itch.io/pixelassetjam2024).
* **Interfaz y Audio:** Elementos de UI adicionales (Tiny Wonder / PlayfulFree), efectos de sonido y música (incluyendo pistas de Toby Fox) obtenidos de recursos gratuitos de la comunidad.
