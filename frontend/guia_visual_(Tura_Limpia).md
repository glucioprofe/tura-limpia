# Guía Visual Común · Tura Limpia (Landing - Célula 5)
*Seminario de Actualización - Universidad del Pacífico*

---

## 1. Introducción y Objetivo

Esta guía define las reglas visuales básicas para el proyecto **Tura Limpia**. Su propósito es garantizar una identidad visual coherente, moderna y accesible para los usuarios administrativos y la comunidad de Buenaventura, alineada con los colores institucionales de la **Universidad del Pacífico**.

---

## 2. Paleta de Colores

La paleta cromática se basa en el escudo oficial de la **Universidad del Pacífico**, representando la selva húmeda tropical y la biodiversidad (verde), el océano Pacífico y la bahía (azul) y el sol naciente del conocimiento (amarillo oro).

### 2.1 Colores Institucionales (Extraídos del Escudo)
* **Verde Institucional Unipacífico (Principal - `#00843D`):** Color de acción principal para botones primarios, enlaces activos y acento ecológico de recolección de residuos.  
  *(En interacción `Hover`, oscurecer a `#00632E`).*
* **Azul Océano Pacífico (Secundario - `#005A9C`):** Color de navegación, barras de encabezado, botones secundarios, mapas e indicadores de rutas marítimas y terrestres.  
  *(En interacción `Hover`, oscurecer a `#004375`).*
* **Amarillo Sol / Oro (Acento / Alerta - `#FFC72C`):** Proviene del sol y la estrella del escudo. Se utiliza en detalles de señalización, avisos de servicio y en el badge de alerta de datos de prueba.
* **Celeste Agua (Apoyo - `#E0F2FE`):** Fondo suave para tarjetas informativas o estados en espera.

### 2.2 Fondos y Superficies
* **Fondo general de la pantalla:** Blanco puro (`#FFFFFF`) para una visual limpia, moderna y luminosa.
* **Fondo de inputs y campos:** Gris claro (`#F3F4F6`), facilitando al usuario ubicar de inmediato dónde escribir.
* **Fondo de tarjetas (Cards):** Blanco (`#FFFFFF`) con borde gris sutil.
* **Texto principal:** Negro carbón (`#111827`) para máximo contraste y legibilidad.
* **Texto secundario y etiquetas:** Gris medio (`#4B5563`).
* **Bordes y separadores:** Gris suave (`#E5E7EB`).

### 2.3 Estados y Señalización
* **Alerta / Prototipo (`#F59E0B` / `#FFC72C` - Amarillo Oro):** **Uso obligatorio** para indicar que un dato o un horario aún es de prueba.
* **Éxito (`#00843D` - Verde Unipacífico):** Rutas activas y operaciones guardadas con éxito.
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
* **Botón Primario:** Fondo Verde Unipacífico (`#00843D`), texto blanco. Para la acción principal (Buscar, Guardar, Registrar).
* **Botón Secundario:** Fondo blanco, borde Azul Pacífico (`#005A9C`), texto Azul Pacífico (`#005A9C`). Para acciones complementarias (Cancelar, Limpiar).
* **Botón Peligro:** Fondo rojo (`#EF4444`), texto blanco. Exclusivo para eliminar registros.
* *Nota:* Todo botón debe cambiar de tono suavemente al pasar el mouse por encima y verse atenuado si está deshabilitado.

### 5.2 Campos de Formulario
* Altura estándar de `44px` para que sea fácil hacer clic.
* Fondo gris claro (`#F3F4F6`), borde gris sutil (`#E5E7EB`) y texto negro carbón (`#111827`).
* Al hacer clic dentro del campo (`Focus`), el borde se resalta en **Verde Unipacífico** (`#00843D`) con fondo blanco.
* Si hay un error, el borde cambia a rojo y se muestra un mensaje explicativo debajo.

### 5.3 Etiqueta Obligatoria: "Dato de Prueba"
Dado que el proyecto se encuentra en fase académica con datos simulados, toda sección o tarjeta que muestre horarios o frecuencias debe incluir esta etiqueta:
* **Fondo:** Amarillo claro (`#FEFCE8`).
* **Borde y Texto:** Amarillo Oro / Dorado oscuro (`#A16207`).
* **Contenido:** `⚠️ DATO DE PRUEBA`
