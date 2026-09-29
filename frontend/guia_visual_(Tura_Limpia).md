# Guía Visual Común · Tura Limpia (Landing - Célula 5)
*Seminario de Actualización - Universidad del Pacífico*

---

## 1. Introducción y Objetivo

Esta guía define las reglas visuales básicas para el proyecto. Su propósito es que todas las células de trabajo construyan pantallas con el mismo estilo, garantizando el orden para los usuarios administrativos y la comunidad de Buenaventura.

---

## 2. Paleta de Colores

La paleta toma directamente la identidad cromática del logo de **Pazífico Limpio**: el sol del atardecer (amarillo y zapote), las olas del mar (azul océano) y el brote de hojas (verde ecológico).

### 2.1 Colores de Identidad (Extraídos del Logo)
* **Zapote Pazífico (Principal - `#FF5500`):** Proviene de la base cálida del sol. Es el color de acción principal para botones primarios, llamados a la acción y elementos destacados.  
  *(En interacción `Hover`, oscurecer a `#D94500`).*
* **Amarillo Solar (Acento / Señalización - `#FFD000`):** Proviene de la parte superior del sol. Se usa en detalles de señalización, indicadores y en la alerta de datos de prueba.
* **Azul Océano (Informativo / Rutas - `#0077D4`):** Proviene de las olas del mar del Pacífico. Se usa en botones secundarios, mapas e información de rutas.
* **Verde Hoja (Ecológico / Éxito - `#00A850`):** Proviene del brote de hojas del logo. Se usa para indicar rutas activas, confirmaciones y mensajes de éxito.

### 2.2 Fondos y Superficies
* **Fondo general de la pantalla:** Blanco puro (`#FFFFFF`) para una interfaz limpia y luminosa.
* **Fondo de inputs y campos:** Gris claro (`#F3F4F6`), facilitando al usuario ubicar de inmediato dónde escribir.
* **Fondo de tarjetas (Cards):** Blanco (`#FFFFFF`) con borde gris sutil.
* **Texto principal:** Negro carbón (`#111827`) para máximo contraste y legibilidad.
* **Texto secundario y etiquetas:** Gris medio (`#4B5563`).
* **Bordes y separadores:** Gris suave (`#E5E7EB`).

### 2.3 Estados y Señalización
* **Alerta / Prototipo (`#FFD000` - Amarillo Solar):** **Uso obligatorio** para indicar que un dato o un horario aún es de prueba.
* **Éxito (`#00A850` - Verde Hoja):** Rutas activas y operaciones guardadas con éxito.
* **Error / Inactivo (`#EF4444` - Rojo):** Rutas no disponibles, campos con error o botones de eliminación.

---

## 3. Tipografía

Utilizaremos la fuente **Inter** (disponible de forma gratuita en Google Fonts y nativa en Figma), seleccionada por su excelente legibilidad en pantallas.

| Nivel | Tamaño | Grosor (Peso) | ¿Dónde se usa? |
|---|---|---|---|
| **Título Principal** | `32px` | Negrita (Bold) | Encabezado principal de la landing o vista |
| **Título de Sección** | `24px` | Seminegrita (SemiBold) | Títulos de módulos, tablas o paneles |
| **Subtítulo / Tarjeta**| `18px` | Seminegrita (SemiBold) | Título de una ruta, residuo o modal |
| **Texto de Lectura** | `16px` | Normal (Regular) | Párrafos, descripciones y opciones |
| **Texto de Botones** | `16px` | Medio (Medium) | Etiquetas de botones y pestañas de menú |
| **Etiquetas de Estado**| `12px` | Seminegrita (SemiBold) | Badges de alerta, estado o advertencia |

---

## 4. Espaciado y Formas

Para que los elementos se vean ordenados y alineados, seguimos múltiplos de **8 píxeles**:

* **Espaciado interior:**
  * Botones e inputs: `12px` arriba/abajo y `16px` a los lados.
  * Tarjetas y paneles: `20px` a `24px` de margen interno.
* **Separación entre elementos:**
  * Entre campos de un formulario: `16px`.
  * Entre secciones o bloques: `32px` a `48px`.
* **Bordes redondeados:**
  * Inputs y botones: `8px`.
  * Tarjetas y ventanas modales: `12px`.
  * Badges o etiquetas de estado: Totalmente redondeadas.

---

## 5. Componentes Clave

### 5.1 Botones
* **Botón Primario:** Fondo Zapote Pazífico (`#FF5500`), texto blanco. Para la acción principal (Buscar, Guardar, Registrar).
* **Botón Secundario:** Fondo blanco, borde gris (`#E5E7EB`), texto negro carbón (`#111827`). Para acciones complementarias (Cancelar, Limpiar).
* **Botón Peligro:** Fondo rojo (`#EF4444`), texto blanco. Exclusivo para eliminar registros.
* *Nota:* Todo botón debe cambiar de tono suavemente al pasar el mouse por encima y verse atenuado si está deshabilitado.

### 5.2 Campos de Formulario
* Altura estándar de `44px` para que sea fácil hacer clic.
* Fondo gris claro (`#F3F4F6`), borde gris sutil (`#E5E7EB`) y texto negro carbón (`#111827`).
* Al hacer clic dentro del campo (`Focus`), el borde se resalta en **Zapote Pazífico** (`#FF5500`) con fondo blanco.
* Si hay un error, el borde cambia a rojo y se muestra un mensaje explicativo debajo.

### 5.3 Etiqueta Obligatoria: "Dato de Prueba"
Dado que el proyecto se encuentra en fase académica con datos simulados, toda sección o tarjeta que muestre horarios o frecuencias debe incluir esta etiqueta:
* **Fondo:** Amarillo claro (`#FEFCE8`).
* **Borde y Texto:** Amarillo / Dorado oscuro (`#A16207`).
* **Contenido:** `⚠️ DATO DE PRUEBA`
