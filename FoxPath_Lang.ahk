#Requires AutoHotkey v2.0

Global LangMap := Map()

InitLang() {
    Global LangMap
    
    ; --- ITALIANO ---
    LangMap["IT"] := Map(
        "TutTitle", "🦊 Benvenuto in FoxPath!",
        "TutBody", "FoxPath è il tuo nuovo assistente per gestire e copiare velocemente i percorsi dei file in Windows.`n`nScorciatoia principale:`nPremi la combinazione {1} per evocare o nascondere la volpe in qualsiasi momento.",
        "TutSkip", "Salta",
        "TutNext", "Avanti ➔",
        "TutTitle2", "📁 Come si usa?",
        "TutBody2", "1. Seleziona uno o più file (o cartelle) in Esplora File o sul Desktop.`n`n2. La volpe rileverà automaticamente la tua selezione.`n`n3. Clicca col tasto Sinistro sul pannello scuro per copiare il percorso negli appunti!",
        "TutTitle3", "⚙️ Menu Avanzato e Opzioni",
        "TutBody3", "Fai Clic Destro sul pannello scuro per il menu contestuale:`n• Formattazione (slash, virgolette, ecc.)`n• Apri cartella in VS Code o PowerShell`n• Cronologia dei percorsi recenti`n`nUsa la rotellina ⚙ in alto a destra per le Impostazioni!",
        "TutFinish", "Fine ✔",
        "TutDone", "Tutorial completato! Premi {1} per chiamare la volpe e iniziare a lavorare.",
        "LangSelect", "🌐 Lingua / Language:"
    )
    
    ; --- ENGLISH ---
    LangMap["EN"] := Map(
        "TutTitle", "🦊 Welcome to FoxPath!",
        "TutBody", "FoxPath is your new assistant to quickly manage and copy file paths in Windows.`n`nMain Shortcut:`nPress the {1} combination to summon or hide the fox at any time.",
        "TutSkip", "Skip",
        "TutNext", "Next ➔",
        "TutTitle2", "📁 How to use it?",
        "TutBody2", "1. Select one or more files (or folders) in File Explorer or on the Desktop.`n`n2. The fox will automatically detect your selection.`n`n3. Left-click on the dark panel to copy the path to the clipboard!",
        "TutTitle3", "⚙️ Advanced Menu and Options",
        "TutBody3", "Right-Click on the dark panel for the context menu:`n• Formatting (slash, quotes, etc.)`n• Open in VS Code or PowerShell`n• Recent path history`n`nUse the ⚙ icon at the top right for Settings!",
        "TutFinish", "Finish ✔",
        "TutDone", "Tutorial completed! Press {1} to summon the fox and start working.",
        "LangSelect", "🌐 Language:"
    )
    
    ; --- ESPAÑOL ---
    LangMap["ES"] := Map(
        "TutTitle", "🦊 ¡Bienvenido a FoxPath!",
        "TutBody", "FoxPath es tu nuevo asistente para gestionar y copiar rápidamente las rutas de archivos en Windows.`n`nAtajo principal:`nPresiona la combinación {1} para invocar o ocultar al zorro en cualquier momento.",
        "TutSkip", "Omitir",
        "TutNext", "Siguiente ➔",
        "TutTitle2", "📁 ¿Cómo se usa?",
        "TutBody2", "1. Selecciona uno o más archivos (o carpetas) en el Explorador de archivos o en el Escritorio.`n`n2. El zorro detectará automáticamente tu selección.`n`n3. ¡Haz clic izquierdo en el panel oscuro para copiar la ruta al portapapeles!",
        "TutTitle3", "⚙️ Menú Avanzado y Opciones",
        "TutBody3", "Haz Clic Derecho en el panel oscuro para el menú contextual:`n• Formato (slash, comillas, etc.)`n• Abrir en VS Code o PowerShell`n• Historial de rutas recientes`n`n¡Usa el icono ⚙ arriba a la derecha para la Configuración!",
        "TutFinish", "Finalizar ✔",
        "TutDone", "¡Tutorial completado! Presiona {1} para llamar al zorro y empezar a trabajar.",
        "LangSelect", "🌐 Idioma:"
    )
}

; Funzione Globale di Traduzione
Tr(key, params*) {
    Global SettingLang, LangMap
    if (!LangMap.Has(SettingLang))
        SettingLang := "IT"
    
    if (LangMap[SettingLang].Has(key)) {
        text := LangMap[SettingLang][key]
        for i, param in params
            text := StrReplace(text, "{" i "}", param) ; Permette di iniettare variabili come la Scorciatoia
        return text
    }
    return key ; Se la traduzione manca, mostra il nome della chiave per accorgercene
}