<div align="center">
  <img src="fox_saluto.png" width="160" alt="Mascota FoxPath">
  <br>
  <img src="FoxPath.png" width="400" alt="FoxPath Logo">
  <p><b>Tu asistente visual y "Navaja Suiza" para la productividad en Windows</b></p>
  
  ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-blue.svg)
  ![OS](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-lightgrey.svg)
  ![License](https://img.shields.io/badge/License-Free-green.svg)
  
  <p><b><a href="README.md">🌍 English</a> | 🇪🇸 Español | <a href="README_IT.md">🇮🇹 Italiano</a></b></p>
</div>

---

**FoxPath** es un asistente "siempre visible" basado en **AutoHotkey v2**. Creado originalmente para recuperar y formatear rápidamente las rutas de los archivos, ha evolucionado hasta convertirse en una potente e inteligente **"Navaja Suiza"**. Todo ello acompañado de una simpática mascota interactiva (¡nuestro Zorro!) que reacciona dinámicamente a lo que haces.

## ✨ ¿Por qué usar FoxPath?

- 🚀 **Sin ventanas intrusivas:** Una pequeña interfaz flotante que aparece solo cuando la necesitas y desaparece cuando has terminado.
- 🧠 **Contextual:** Entiende instantáneamente lo que has seleccionado (imágenes, textos, JSON, carpetas) y te ofrece solo las herramientas adecuadas para el archivo en uso.
- ⚡ **Cero Fricción:** Se acabaron los aburridos pasos intermedios. Convierte, extrae y procesa archivos directamente desde el Escritorio o el Explorador de Archivos con un solo clic.

## 🧰 Características Principales

### 📝 Herramientas Editoriales y de Texto
- **Extracción de Texto Inteligente:** Extrae texto puro o tablas de archivos de **Word (.docx)** y **Excel (.xlsx)** sin siquiera abrirlos.
- **OCR y Traducción:** Extrae el texto directamente de las imágenes, o traduce sobre la marcha tus notas vía Google Translate.
- **Notas Rápidas:** Crea archivos `.txt` instantáneamente a partir de lo que tengas copiado actualmente en el portapapeles de Windows.
- **Estadísticas:** Cuenta instantáneamente palabras, caracteres y estima los tiempos de lectura previstos de un documento.

### 📸 Imágenes y Gráficos
<img src="fox_attesa.png" width="70" align="right" alt="Espera">

- **Selector de Color Visual:** Haz clic en una foto y FoxPath extraerá mágicamente los **5 colores predominantes**, listos para ser copiados en formato HEX, RGB, HSL o CMYK a través de un mini-panel.
- **Convertidor de Formato Rápido:** Transforma imágenes sobre la marcha entre **PNG, JPG y BMP** aprovechando el motor gráfico nativo GDI+.

### 💻 Desarrollo y Sistema
- **Gestión JSON:** Minifica o formatea maravillosamente archivos `.json` ilegibles en un solo clic.
- **Git y Terminales:** Abre las rutas directamente en **VS Code** o PowerShell. Ejecuta comandos de Git (Pull, Add, Commit) instantáneos en tus repositorios.
- **Generador de Snippets:** Crea plantillas instantáneas (HTML base, `.gitignore`, plantillas Markdown) o accesos directos listos para usar.

### 📦 Gestión de Archivos Avanzada (Super Tools)
- **Super Zip:** Comprime decenas de archivos en un único archivo, o en paquetes `.zip` separados simultáneamente.
- **Utilidades de Seguridad y Privacidad:** Destruye archivos de forma irrecuperable (Shredder), camufla la fecha/hora (Time Stomping), o renombra por lotes.
- **Formateo de Rutas:** Copia rutas en decenas de formatos (`/`, `\`, comillas, array JSON, URI web). También mantiene un práctico **Historial** de las últimas 5 rutas copiadas.

---

## 🚀 Instalación y Primer Inicio

La instalación es rapidísima. ¡FoxPath incluye un cómodo **Tutorial Integrado** para guiarte en tus primeros pasos!

1. **Requisitos Previos:** Asegúrate de tener instalado AutoHotkey v2 en tu PC. *(Nota: Si usas la versión pre-compilada `.exe`, ¡no es necesario AutoHotkey!)*
2. Extrae la carpeta que contiene el archivo `FoxPath.ahk` (o el ejecutable) y la carpeta `foxpath_movement` que contiene las animaciones `.gif`.
3. Inicia el script haciendo doble clic en `FoxPath.ahk` (o `FoxPath.exe`).
4. **En el primer inicio** aparecerá automáticamente la ventana de bienvenida, ¡donde podrás configurar el inicio automático con Windows y crear un acceso directo en el Escritorio con total autonomía!

## 🎮 Cómo se usa

<div align="center">
  <img src="fox_conferma.png" width="120" alt="Confirmación FoxPath">
</div>

1. **Invoca al Zorro:** Pulsa `Ctrl + Alt + F` en cualquier momento. El Zorro aparecerá flotando en la pantalla.
2. **Selecciona un Elemento:** Haz clic en archivos o carpetas. El Zorro leerá la selección y se actualizará en tiempo real.
3. **Interactúa:** 
   - 🖱️ **Clic Izquierdo:** Copia rápida estándar y acción principal configurada.
   - 🖱️ **Clic Derecho:** Abre el potente Menú Contextual para navegar entre filtros, formateos especiales y todas las Herramientas Avanzadas.

## ⚙️ Personalización (Configuración)

FoxPath está diseñado para adaptarse perfectamente a tu flujo de trabajo. Haciendo clic en el icono del **Engranaje (⚙️)** (o desde el Clic Derecho > *Configuración*) podrás:
- Cambiar los colores de la UI (botones, textos, fondos).
- Ajustar de forma granular las dimensiones del panel y la **Transparencia global**.
- Elegir el atajo de teclado Global de invocación.
- **Menú Rápido:** Decidir la acción principal y cuáles son tus **5 Acciones Favoritas** a mostrar en la parte superior del menú contextual para tenerlas a un clic de distancia.

*Todas tus preferencias se guardan en un archivo portátil y ligerísimo llamado `FoxPath.ini`.*

<div align="center">
  <img src="FoxPath.png" width="300" alt="FoxPath Logo">
</div>