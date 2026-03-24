<div align="center">
  <img src="fox_saluto.png" width="160" alt="Mascota FoxPath">
  <br>
  <img src="FoxPath.png" width="400" alt="Logo FoxPath">
  <p><b>Tu asistente visual y "Navaja Suiza" para la productividad en Windows</b></p>
  
  ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-blue.svg)
  ![OS](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-lightgrey.svg)
  ![License](https://img.shields.io/badge/License-Free-green.svg)
  
  <p><b><a href="README.md">🌍 English</a> | 🇪🇸 Español | <a href="README_IT.md">🇮🇹 Italiano</a></b></p>
</div>

---

**FoxPath** es un asistente "siempre visible" basado en **AutoHotkey v2**. Nacido originalmente para recuperar y formatear rápidamente las rutas de los archivos, ha evolucionado hasta convertirse en una potente e inteligente **"Navaja Suiza"**. Todo ello acompañado de una simpática mascota interactiva (¡nuestro Zorro!) que reacciona dinámicamente a lo que haces.

## ✨ ¿Por qué usar FoxPath?

- 🚀 **Sin ventanas intrusivas:** Una pequeña interfaz flotante que aparece solo cuando la necesitas y desaparece cuando terminas.
- 🧠 **Contextual:** Entiende instantáneamente lo que has seleccionado (imágenes, textos, JSON, carpetas) y te ofrece solo las herramientas adecuadas.
- ⚡ **Cero Fricción:** Se acabaron los tediosos pasos intermedios. Convierte, extrae y procesa archivos directamente desde el Escritorio o el Explorador de Archivos con un clic.

## 🧰 Características Principales

### 📝 Herramientas Editoriales y de Texto
- **Extracción de Texto Inteligente:** Extrae texto sin formato o tablas de archivos **Word (.docx)** y **Excel (.xlsx)** sin siquiera abrirlos.
- **OCR y Traducción:** Extrae texto directamente de imágenes, o traduce tus notas sobre la marcha vía Google Translate.
- **Notas Rápidas:** Crea archivos `.txt` instantáneamente a partir de lo que tengas copiado en tu portapapeles.
- **Estadísticas:** Cuenta al instante palabras, caracteres y estima el tiempo de lectura esperado de un documento.

### 📸 Imágenes y Gráficos
<img src="fox_attesa.png" width="70" align="right" alt="Espera">

- **Selector de Color Visual:** Haz clic en una foto y FoxPath extraerá mágicamente los **5 colores predominantes**, listos para copiar en HEX, RGB, HSL o CMYK.
- **Convertidor de Formato Rápido:** Transforma imágenes sobre la marcha entre **PNG, JPG y BMP** usando el motor gráfico nativo GDI+.

### 💻 Sistema y Desarrollo
- **Gestión de JSON:** Minifica o formatea archivos `.json` ilegibles con un solo clic.
- **Git y Terminales:** Abre rutas directamente en **VS Code** o PowerShell. Ejecuta comandos Git instantáneos en tus repositorios.
- **Generador de Snippets:** Crea plantillas instantáneas (HTML básico, `.gitignore`, plantillas Markdown).

### 🛠️ Herramientas de Desarrollador (DevTools)
Al hacer clic en el icono `</>` tendrás acceso a una potente suite nativa para programadores:
- **Codificadores y Convertidores:** Base64 (Texto), Archivador Gzip y JSON ⇄ YAML.
- **Generadores Seguros:** Hash en tiempo real (MD5, SHA-256), UUID v4 y Generador de Contraseñas.
- **Desarrollo:** Convertidor de Timestamp Epoch y un práctico Probador nativo para Expresiones Regulares (Regex).
- **Gráficos y Medios:** Previsualización en tiempo real de archivos Markdown, Compresor de Imágenes JPG y Simulador de Daltonismo.

### 📦 Gestión Avanzada de Archivos (Super Tools)
- **Super Zip:** Comprime decenas de archivos en un único archivo, o en paquetes `.zip` separados simultáneamente.
- **Utilidades de Seguridad:** Destruye archivos de forma irrecuperable (Shredder), camufla fecha/hora (Time Stomping) o renombra por lotes.
- **Formato de Rutas:** Copia rutas en decenas de formatos. FoxPath también mantiene un **Historial** de tus últimas 5 rutas copiadas.

---

## 🚀 Instalación y Primer Uso

La instalación es súper rápida. ¡FoxPath incluye un práctico **Tutorial Integrado** para guiarte en tus primeros pasos!

1. **Requisitos previos:** Asegúrate de tener AutoHotkey v2 instalado en tu PC. *(Nota: Si utilizas la versión precompilada `.exe`, ¡no es necesario AutoHotkey!)*
2. Extrae la carpeta que contiene el archivo `FoxPath.ahk` (o el ejecutable) y la carpeta `foxpath_movement` que contiene las animaciones.
3. Inicia el script haciendo doble clic en `FoxPath.ahk` (o `FoxPath.exe`).
4. **En la primera ejecución**, aparecerá automáticamente la ventana de bienvenida, ¡donde podrás configurarlo para que se inicie con Windows!

## 🎮 Cómo usarlo

<div align="center">
  <img src="fox_conferma.png" width="120" alt="Confirmación FoxPath">
</div>

1. **Invoca al Zorro:** Pulsa `Ctrl + Alt + F` en cualquier momento. El Zorro aparecerá flotando en la pantalla.
2. **Selecciona un Elemento:** Haz clic en archivos o carpetas. El Zorro leerá la selección y se actualizará.
3. **Interactúa:** 
   - 🖱️ **Clic Izquierdo:** Copia rápida estándar y acción primaria establecida.
   - 🖱️ **Clic Derecho:** Abre el potente Menú Contextual para navegar por filtros, formatos especiales y las Super Tools.

## ⚙️ Personalización (Configuración)

FoxPath está diseñado para adaptarse perfectamente a tu flujo de trabajo. Haciendo clic en el icono del **Engranaje (⚙️)** podrás:
- Cambiar los colores de la interfaz de usuario.
- Ajustar el tamaño del panel y la **Transparencia global**.
- Elegir el atajo de teclado global.
- **Menú Rápido:** Decidir tu acción primaria y tus **5 Acciones Favoritas** para mostrarlas en la parte superior del menú.

*Todas tus preferencias se guardan en un archivo portátil y ligero llamado `FoxPath.ini`.*

## 🆘 FAQ y Solución de Problemas

- **¿El Zorro parece "aplastado" o la imagen está deformada?** 
  En los Ajustes (⚙️), marca *"Desbloquear Redimensionamiento Manual"* y ensancha ligeramente la ventana: esto forzará el cálculo de las proporciones óptimas. Luego haz clic en *Guardar*.
- **¿El antivirus bloquea el ejecutable?**
  El software creado en AutoHotkey suele estar sujeto a falsos positivos. Si has compilado FoxPath, añade la carpeta a las Exclusiones de Windows Defender.

<br>