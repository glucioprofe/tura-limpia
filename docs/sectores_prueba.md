Sectores de prueba, fuente (Célula 3)

Proyecto Tura Limpia · Sprint 1 · Tarjeta [C3] Seleccionar sectores de prueba y documentar fuente Ubicación sugerida en el repositorio: docs/sectores_prueba.md

Estado: borrador para revisión. Los datos vienen de información verbal y no son oficiales. Se usan solo para probar el modelo en un prototipo académico.

1. Propósito y alcance

Definir el alcance geográfico inicial, documentar la fuente de los nombres y acordar qué es una zona, una ruta programada y un recorrido realizado para el servicio de barrido domiciliario.

Fuera de alcance en este sprint: mapa editable, ubicación en vivo, aplicación ciudadana, clasificación de imágenes, analítica avanzada. No se asume que exista una malla vial oficial.

2. Definiciones
Concepto	Definición
Zona / barrio (sector)	Unidad geográfica de servicio identificada por nombre. No exige geometría ni malla vial.
Ruta programada	Plan recurrente de una microrruta de barrido: qué zonas cubre, qué días y en qué turno. Es lo que debería pasar.
Recorrido realizado	Ejecución de una ruta en una fecha concreta, con estado programado, completado, retrasado o cancelado. Es lo que pasó.
3. Fuente de la información
Campo	Detalle
Fuente	Comunicación verbal de una persona que trabaja en la empresa prestadora del servicio de aseo en Buenaventura
Fecha de consulta	2026-09-28
Tipo	Información interna, sin documento de respaldo
Autorización de uso	Sin autorización escrita. Pendiente un mensaje de confirmación de uso académico
Uso permitido	Datos de prueba de un prototipo académico. No publicar como información oficial

Limitaciones

Horarios conocidos solo por turno (mañana, tarde, noche), sin asignación por zona.
Barrios agrupados como "y alrededores", sin listado exhaustivo.
Días de Pueblo Nuevo sin confirmar.
"Lunes - Jueves" se interpreta como lunes y jueves (deducción pendiente de confirmar).

El nombre de la empresa y de la persona de contacto se guardan en un registro privado del equipo, no en el repositorio.

4. Hallazgos de la fuente
Servicio en todo Buenaventura mediante 42 microrrutas de barrido domiciliario.
No hay servicio los domingos.
Turnos: mañana, tarde y noche ( noche para recolectores)
Centro es el sector sencillo (servicio diario); Playita es el complicado.
Mayor generación de residuos: Puertos y zona comercial de Pueblo Nuevo.
Puertos se atiende todos los días.
El supervisor verifica el cumplimiento de la ruta en los recorridos diarios.
5. Zonas y patrón de días
Patrón de días	Zonas (todas "y alrededores")
Lunes y jueves	Marino Klinger (Bellavista, Cristal) · 14 de Julio (Modelo, Rockefeller, Porvenir, Jardín, Juan XXIII) · SENA (Inmaculada, Santa Cruz) · Montechino · Playita y Palo Seco
Martes y viernes	Marina y Oriente · Ciudadela, Transformación y Gran Colombiana · Dorado y Colón · Independencia y Américas
Miércoles y sábado	Retén (Éxito, Triunfo, Nueva Granada) · Bolívar · Caldas · Bahía
Diario (lunes a sábado)	Centro · Puertos
Por confirmar	Zona comercial de Pueblo Nuevo
6. Sectores de prueba seleccionados
Sector	Motivo de selección	Días
Centro	Caso sencillo, servicio diario	Lunes a sábado
Playita y Palo Seco	Caso complicado	Lunes y jueves
Marina y Oriente	Segundo patrón de días	Martes y viernes
Puertos	Mayor generación de residuos	Lunes a sábado

Opcional: Retén, Bolívar o Caldas para probar el patrón miércoles y sábado. Datos en sectores.csv.
