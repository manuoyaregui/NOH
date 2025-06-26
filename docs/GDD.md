# 🎮 GDD - *No One's Heart*

## 📑 Índice
- [1. Contexto General](#1-contexto-general)
- [2. Estructura Roguelike](#2-estructura-roguelike)
- [3. Zonas del Mundo](#3-zonas-del-mundo)
- [4. Sistema de Combate](#4-sistema-de-combate)
  - [4.1 Tipos de Movimiento](#41-tipos-de-movimiento)
  - [4.2 Cartas](#42-cartas)
  - [4.3 Estadísticas del Jugador (Tendencias)](#43-estadísticas-del-jugador-tendencias)
- [5. Progresión y Runs](#5-progresión-y-runs)
- [6. Sistema de Recursos](#6-sistema-de-recursos)
- [7. Meta-Progresión](#7-meta-progresión)
- [8. Diseño de Enemigos](#8-diseño-de-enemigos)
- [9. Dirección de Arte y Sonido](#9-dirección-de-arte-y-sonido)
- [10. Localización y Multilenguaje](#10-localización-y-multilenguaje)
- [11. Pendientes / Expansiones Futuras](#11-pendientes-expansiones-futuras)

---

## 1. Contexto General

El juego se sitúa dentro de la mente de un niño atrapado en una pesadilla. El jugador encarna a su padre, que ha entrado en ese mundo para salvarlo. Todo es simbólico, oscuro y melancólico, con lugares distorsionados y entidades pesadillescas que representan emociones fragmentadas.

---

## 2. Estructura Roguelike

Cada "run" se representa como un mapa modular y ramificado compuesto por nodos conectados. Los nodos tienen distintos tipos con nombres simbólicos:

| Tipo de Nodo | Nombre sugerido | Función |
|--------------|------------------|---------|
| ⚔️ Combate   | Conflicto        | Lucha obligatoria contra entidades. |
| 🧠 Evento    | Recuerdo Fragmentado | Evento narrativo. |
| 🌱 Zona Neutra | Refugio Sereno  | Recuperación, reseteo emocional. |
| 🔥 Jefe      | Trauma Manifiesto | Enemigo clave, carga emocional. |
| 🌀 Distorsión | Vórtice de Ansiedad | Evento de alto riesgo/alta recompensa. |
| 🏘️ Bazar    | Mercado de Intenciones | Comprar cartas, objetos o aceptar contratos. |

Cada región tiene caminos que divergen y convergen. Siempre se avanza hacia el nodo de jefe, sin posibilidad de retroceso.

---

## 3. Zonas del Mundo

El mundo está dividido en regiones, cada una con su estética y representación simbólica:

- **La Corona Silente**: Representa la autoridad y juicio.
- **Raíces del Eco**: Memorias profundas.
- **Campos Hundidos**: Juguetes enterrados, nostalgia distorsionada.
- **Cauce del Grito**: Pérdida de forma e identidad.
- **Trono del Mármol**: Origen del hechizo, final del viaje.
- **Jardines Suspendidos**: Belleza inexplicable, madre.
- **Aguas Quietas**: Reflejo de lo ausente.
- **Claro del Susurro**: Silencio emocional.
- **Valle de lo No Dicho**: Lo incomprendido entre madre e hijo.

---

## 4. Sistema de Combate

### 4.1 Tipos de Movimiento

- **Ofensivos**: Ataques, daño directo.
- **Defensivos**: Protección, mitigación.
- **Especiales**: Manipulan turnos, reflejos, estados mentales.

Los movimientos tienen ventajas y consecuencias. Se limitan usos repetidos para evitar abusos (fatiga, restricciones por stats).

### 4.2 Cartas

Tipos:
- **Contrato**: Se aceptan o no. Cumplir otorga beneficios, romper castigos.
- **Comportamiento**: Se activan al cumplir patrones.
- **RNG**: Efecto aleatorio bajo condiciones.
- **Destreza**: Requieren habilidad del jugador.

Subtipos: Forzada, Opcional, Consumible.

### 4.3 Estadísticas del Jugador (Tendencias)

- **Osadía**: Modifica daño.
- **Dureza**: Modifica defensa.
- **Moral**: Esperanza/desesperación, altera eventos y efectos pasivos.
- **Agilidad**: Influye en el orden de ataque.

---

## 5. Progresión y Runs

- Runs generadas proceduralmente.
- Cada región tiene mapa fijo con variaciones.
- Las decisiones son permanentes: si pierdes, se borra el progreso actual (permadeath).
- Guardado automático antes del combate, y borrado del archivo tras derrota.

---

## 6. Sistema de Recursos

- **Salud**: Se pierde con daño. Recuperable en refugios o efectos especiales.
- **Energía**: Se consume al usar cartas.
- **Moneda**: Fragmentos de Memoria. Se usan en el Mercado.

---

## 7. Meta-Progresión

- **Ecos Persistentes**: Recurso permanente al morir.
- **Desbloqueo de Cartas**: Nuevas cartas disponibles en futuras runs.
- **Mejoras Iniciales**: Salud extra, cartas iniciales, eventos únicos.

Sistema almacenado en JSON (`progreso_global.json`).

---

## 8. Diseño de Enemigos

- **Comunes**: Usan variaciones de movimientos estándar.
- **Jefes**: IA y movimientos únicos, representan trauma o figura importante.
- **Por región**:
  - La Corona Silente: Vigilantes, Edictos.
  - Campos Hundidos: Juguetes Rotos, Marionetas.

IA basada en perfiles: AGRESIVO, DEFENSIVO, TÁCTICO.

---

## 9. Dirección de Arte y Sonido

- **Estética**: 2.5D, oscura, surreal, texturas tipo carboncillo.
- **Sonido**: Piano, ambientes melancólicos, susurros.
- **Personajes**: Modelos 3D con sprites 2D como enemigos.

---

## 10. Localización y Multilenguaje

- Idioma por defecto: inglés.
- Opciones para `en`, `es`.
- Sistema de traducción en archivo `.csv` con columnas: `key`, `en`, `es`.
- Carga dinámica de idioma al inicio.
- Al cambiar idioma, todo texto visible se actualiza automáticamente.

---

## 11. Pendientes / Expansiones Futuras

- Minijuegos de cartas de destreza.
- Modos de dificultad adicionales.
- Eventos persistentes entre runs.
- Más zonas, jefes, y arquetipos emocionales.
