#Requires AutoHotkey v2.0

ShowTutorial() {
    Global SettingHotkey, ImgSaluto, SettingFirstRun, IniFile
    
    TutGui := Gui("-MinimizeBox -MaximizeBox +AlwaysOnTop +Owner", "Benvenuto in FoxPath")
    
    ; Abilita la Barra del Titolo Scura Nativa (Windows 10/11) per un look coerente e moderno
    try {
        if (VerCompare(A_OSVersion, "10.0.17763") >= 0) {
            attr := VerCompare(A_OSVersion, "10.0.18985") >= 0 ? 20 : 19
            DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", TutGui.Hwnd, "Int", attr, "Int*", 1, "Int", 4)
        }
    }
    
    TutGui.BackColor := "18181B" ; zinc-900
    TutGui.MarginX := 0
    TutGui.MarginY := 0
    
    ; ─── PANNELLO SINISTRO (Sfondo più scuro per la mascotte) ───
    TutGui.Add("Text", "x0 y0 w280 h560 Background09090B") ; zinc-950
    
    ; Immagine Volpe
    try TutGui.Add("Picture", "x50 y150 w180 h-1 BackgroundTrans", ImgSaluto)
    
    ; ─── PANNELLO DESTRO (Contenuto) ───
    
    ; Titolo
    TutGui.SetFont("cWhite s26 bold", "Segoe UI")
    TutGui.Add("Text", "x320 y40 w380 BackgroundTrans", "Benvenuto in FoxPath!")
    
    ; Sottotitolo
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI") ; text-slate-400
    TutGui.Add("Text", "x320 y85 w380 h40 BackgroundTrans", "La tua nuova mascotte è pronta ad aiutarti a gestire file e percorsi come un vero power-user!")
    
    ; -- Sezione 1: Come Funziona --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji") ; text-orange-500
    TutGui.Add("Text", "x320 y155 w30 h30 BackgroundTrans", "⌨️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y157 w340 BackgroundTrans", "Come Funziona")
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    hkText := ModifiersToText(SettingHotkey)
    TutGui.Add("Text", "x360 y182 w340 h45 BackgroundTrans", "Premi la scorciatoia  [ " hkText " ]  per evocare la volpe.`nSeleziona un file o una cartella in Esplora File.")
    
    ; -- Sezione 2: Interazione --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji")
    TutGui.Add("Text", "x320 y240 w30 h30 BackgroundTrans", "🖱️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y242 w340 BackgroundTrans", "Interazione e Menu")
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    TutGui.Add("Text", "x360 y267 w340 h65 BackgroundTrans", "• Tasto Sinistro: Copia rapida negli Appunti.`n• Tasto Destro: Accedi alle Azioni Rapide, Estrazione Testi (OCR), Menu Sviluppatore e Filtri.")

    ; -- Sezione 3: Personalizzazione --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji")
    TutGui.Add("Text", "x320 y340 w30 h30 BackgroundTrans", "⚙️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y342 w340 BackgroundTrans", "Personalizzazione")
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    TutGui.Add("Text", "x360 y367 w340 h45 BackgroundTrans", "Clicca sull'ingranaggio (o scegli l'opzione dal menu) per personalizzare i Tasti Rapidi e l'aspetto.")

    ; -- Sezione 4: Opzioni di Avvio --
    TutGui.SetFont("cWhite s10 norm", "Segoe UI")
    TutGui.Add("CheckBox", "x320 y420 w380 vOptStartup Checked", " Avvia FoxPath automaticamente all'accensione di Windows")
    TutGui.Add("CheckBox", "x320 y450 w380 vOptDesktop Checked", " Crea un collegamento rapido sul Desktop")

    ; ─── PIÈ DI PAGINA E PULSANTE ───
    
    ; Linea di separazione (border-t border-slate-700)
    TutGui.Add("Text", "x310 y490 w400 h1 Background27272A")
    
    ; Bottone Azione
    TutGui.SetFont("cBlack s12 bold", "Segoe UI")
    btn := TutGui.Add("Button", "x510 y510 w180 h40 Default", "Inizia a usare FoxPath ➔")
    btn.OnEvent("Click", (*) => CloseTutorial(TutGui))
    
    TutGui.SetFont("c94A3B8 s9 norm", "Segoe UI")
    TutGui.Add("Text", "x320 y520 w180 BackgroundTrans", "© 2026 Pedro Sanchez.`nTutti i diritti riservati.")
    
    TutGui.OnEvent("Close", (*) => CloseTutorial(TutGui))
    
    TutGui.Show("w740 h560 Center")
}

CloseTutorial(GuiObj) {
    Global SettingFirstRun, IniFile, MascotGui
    
    try {
        saved := GuiObj.Submit(false)
        
        if (saved.HasProp("OptStartup") && saved.OptStartup) {
            if (!FileExist(A_Startup "\FoxPath.lnk"))
                try FileCreateShortcut(A_ScriptFullPath, A_Startup "\FoxPath.lnk")
        }
        
        if (saved.HasProp("OptDesktop") && saved.OptDesktop) {
            if (!FileExist(A_Desktop "\FoxPath.lnk"))
                try FileCreateShortcut(A_ScriptFullPath, A_Desktop "\FoxPath.lnk")
        }
    }
    
    SettingFirstRun := 0
    try IniWrite(0, IniFile, "Settings", "FirstRun")
    GuiObj.Destroy()
    
    ; Evoca la volpe come test iniziale se non è già attiva
    if (!MascotGui)
        ToggleMascot()
}

; Helper per rendere la hotkey più leggibile
ModifiersToText(hk) {
    hk := StrReplace(hk, "^", "CTRL + ")
    hk := StrReplace(hk, "!", "Alt + ")
    hk := StrReplace(hk, "+", "SHIFT + ")
    hk := StrReplace(hk, "#", "WIN + ")
    return StrUpper(hk)
}