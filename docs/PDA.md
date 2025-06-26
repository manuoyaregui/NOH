# 🔄 Plan de Acción - Desarrollo de *No One's Heart* con CursorAI

---

## 🔄 Fase 0: Setup y Prototipado 2.5D (Godot)

**Objetivo:** Establecer estilo visual y base técnica en Godot 4.

1. **Scaffolding Base del Proyecto**

   El agente debe crear la siguiente estructura de carpetas y archivos en la raíz del repositorio:

   - `/scenes`: Para todas las escenas de Godot (`.tscn`).
   - `/scripts`: Para scripts en GDScript.
   - `/assets`: Para recursos gráficos, audio, etc.
   - `/data`: Para archivos de configuración, localización, etc.
   - `README.md`: Instrucciones básicas de ejecución y dependencias.
   - `project.godot`: Archivo principal del proyecto Godot 4 (debe estar en la raíz).
   - `.gitignore`: Configurado para ignorar archivos temporales y de caché de Godot.

   > **Nota:** Esta estructura es el punto de partida mínimo. El agente debe asegurarse de que el proyecto pueda abrirse y ejecutarse en Godot 4 sin errores.

2. **Inicialización del Proyecto**

   * Crear proyecto en Godot 4 usando la estructura anterior.
   * Inicializar y configurar Git para control de versiones.

3. **Creación de la Escena de Combate (Escena Principal Base)**

   * Crear una escena llamada `Combat.tscn` en `/scenes`.
   * Esta escena debe contener:
     * Un nodo `CharacterBody3D` para el jugador, con un `AnimatedSprite3D` en blanco como placeholder visual.
     * Un nodo `CharacterBody3D` (u otro adecuado) para el oponente, también con un `AnimatedSprite3D` en blanco.
     * Un escenario base (puede ser un plano 3D o similar) que sirva de campo de batalla.
     * Una `Camera3D` en tercera persona, configurada para mostrar ambos personajes y el escenario.
   * Esta escena será el punto de partida para todas las pruebas y desarrollo del sistema de combate.

---

## 🏋️ Fase 1: Sandbox de Combate (Núcleo Mecánico)

**Objetivo:** Probar y construir todas las lógicas de combate en una escena aislada.

1. **Estructura de Datos**

   * `Personaje`: 
      - salud (default = 100), 
      - osadía (default = 0), 
      - dureza (default = 0), 
      - moral (default = 0).
      - agilidad (default = 0).
   * `Carta`: 
      - nombre (default = "card_name"), 
      - tipo (default = "TBD"), 
      - coste (default = 0), 
      - efecto (default = "TBD").
   * `Movimiento`: 
      - nombre (default = "move_name"), 
      - tipo (default = "move_type"), 
      - acción (default = ).

2. **Controlador de Combate**

   Implementar una FSM adaptada a turnos simultáneos con los siguientes estados:

      * `InicioTurno`: Preparación y reseteo de efectos temporales.
      * `ElecciónJugador`: El jugador elige su acción.
      * `ElecciónIA`: La IA elige su acción.
      * `ResoluciónTurno`: Se comparan ambas acciones y se ejecutan en orden definido por prioridad/agilidad.
      * `FinTurno`: Se aplican consecuencias, se actualizan stats, y se pasa al siguiente ciclo.

3. **Ejecutar Acciones**

   * Jugar carta aplica movimiento.
   * Movimiento ajusta stats y aplica daño/efectos.

4. **Tendencias y Efectos**

   * Osadía modifica daño.
   * Dureza modifica defensa.
   * Moral influye en suerte o habilidades pasivas.
   * Agilidad influye en el orden de ataques en relacion a otros oponentes.

---

## 🪡 Fase 2: IA Enemiga Inteligente

**Objetivo:** Crear enemigos con comportamiento creíble.

1. **Perfiles de IA**

   * `AGRESIVO`: prioriza daño.
   * `DEFENSIVO`: prioriza defensa.
   * `TACTICO`: usa estados, combos, buffs.

2. **Evaluador de Estado**

   * Factores: salud, acciones del jugador, tendencias, etc.

3. **Elección de Acción**

   * Funciones que usan el perfil y el contexto para decidir acción.

4. **Dificultad Escalonada**

   * Incluir factor de "nivel de oponente" que influye en complejidad de decisiones.

---

## 📖 Fase 3: Onboarding y Tutorial

**Objetivo:** Enseñar el sistema de forma progresiva y clara.

1. **Run Guiada Inicial**

   * Los primeros 3-4 nodos son fijos.
   * Introducir mecánicas una a una.

2. **Tutorial Progresivo**

   * Combate 1: Salud.
   * Combate 2: Osadía.
   * Combate 3: Dureza.
   * Evento 1: Introduce Moral y elecciones.

3. **UI/UX**

   * Tooltips para stats.
   * Intenciones del enemigo visibles.

---

## 🗺️ Fase 4: Estructura Roguelike

**Objetivo:** Implementar sistema de mapa y flujo de run.

1. **Generador de Mapa**

   * `NodoDeMapa`: tipo, conexiones, referencia al evento/combate.
   * Mapa con nodos conectados desde inicio hasta jefe.

2. **Navegación**

   * Elegir nodo => guardar estado actual.
   * Transición al evento/combat correspondiente.

3. **Permadeath y Guardado**

   * Guardado automático al elegir camino.
   * Al morir, se elimina el archivo de run.
   * Cierre forzado => combate se reinicia, no se puede volver.

---

## 🌀 Fase 5: Contenido y Meta-Progresión

**Objetivo:** Poner variedad, rejugabilidad y progreso a largo plazo.

1. **Sistema de Recompensas**

   * Al terminar combate: elegir entre 3 cartas.
   * Al terminar evento: stat o carta.

2. **Eventos Narrativos**

   * Elecciones con consecuencias.
   * Texto + opciones que afectan tendencias o recursos.

3. **Meta-Progresión**

   * Elementos permanentes: cartas desbloqueadas, puntos iniciales, mejoras pasivas.
   * Archivo JSON `progreso_global.json`.

4. **Economía de Juego**

   * Moneda: Fragmentos de Memoria.
   * Usos: Comprar cartas, mejoras, contratos.

---

## 🌐 Fase 6: Sistema de Idioma Multilenguaje

**Objetivo:** Permitir soporte multilenguaje desde el comienzo del desarrollo.

1. **Idioma por Defecto**

   * El juego se lanza en inglés por defecto.

2. **Selección de Idioma**

   * Opcion en menú para cambiar idioma entre `en` y `es`.

3. **Sistema de Traducción**

   * Archivo `.csv` llamado `localization.csv` con las columnas: `key`, `en`, `es`.
   * Cada string del juego se referencia por su `key`.

4. **Carga en Runtime**

   * Al iniciar el juego, se carga el idioma seleccionado desde el archivo CSV a un diccionario global.

5. **Actualización Dinámica**

   * Al cambiar de idioma, los textos en UI y eventos deben actualizarse sin reiniciar el juego.

---

## 📆 Fase 7: Expansión

**Objetivo:** Construir el resto del juego sobre el core funcional.

1. **Jefes y Zonas**

   * Enemigos especiales con IA y movimientos únicos.
   * Regiones con temática, enemigos y nodos específicos.

2. **Cartas Especiales y Contratos**

   * Implementar los tipos: comportamiento, contrato, RNG, destreza.

3. **Arte y Sonido**

   * Estilo: sombrío, surreal, texturas tipo carboncillo.
   * Audio: piano, ambiente distorsionado, susurros.
