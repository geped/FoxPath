#Requires AutoHotkey v2.0

ShowTutorial() {
    Global SettingHotkey, ImgSaluto, SettingFirstRun, IniFile, SettingLang
    
    TutGui := Gui("-MinimizeBox -MaximizeBox +AlwaysOnTop +Owner", Tr("TutTitle"))
    
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
    TutGui.Add("Text", "x0 y0 w280 h600 Background09090B") ; zinc-950
    
    ; Immagine Volpe
    try TutGui.Add("Picture", "x50 y160 w180 h-1 BackgroundTrans", ImgSaluto)
    
    TutGui.SetFont("c94A3B8 s9 norm", "Segoe UI")
    TutGui.Add("Text", "x0 y560 w280 Center BackgroundTrans", Tr("TutCopyright"))
    
    ; ─── PANNELLO DESTRO (Contenuto) ───
    
    ; Titolo
    try TutGui.Add("Picture", "x320 y38 w36 h36 BackgroundTrans", A_ScriptDir "\foxpath.png")
    TutGui.SetFont("cWhite s22 bold", "Segoe UI")
    TutGui.Add("Text", "x365 y40 w335 h40 BackgroundTrans", Tr("TutTitle"))
    
    ; Sottotitolo
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI") ; text-slate-400
    TutGui.Add("Text", "x320 y85 w380 h45 BackgroundTrans", Tr("TutSubtitle"))
    
    ; -- Sezione 1: Come Funziona --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji") ; text-orange-500
    TutGui.Add("Text", "x320 y150 w30 h30 BackgroundTrans", "⌨️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y152 w340 BackgroundTrans", Tr("TutHowTo"))
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    hkText := ModifiersToText(SettingHotkey)
    TutGui.Add("Text", "x360 y177 w340 h45 BackgroundTrans", Tr("TutHowToDesc", hkText))
    
    ; -- Sezione 2: Interazione --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji")
    TutGui.Add("Text", "x320 y235 w30 h30 BackgroundTrans", "🖱️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y237 w340 BackgroundTrans", Tr("TutInteract"))
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    TutGui.Add("Text", "x360 y262 w340 h65 BackgroundTrans", Tr("TutInteractDesc"))

    ; -- Sezione 3: Personalizzazione --
    TutGui.SetFont("cF97316 s18", "Segoe UI Emoji")
    TutGui.Add("Text", "x320 y340 w30 h30 BackgroundTrans", "⚙️")
    TutGui.SetFont("cWhite s13 bold", "Segoe UI")
    TutGui.Add("Text", "x360 y342 w340 BackgroundTrans", Tr("TutCust"))
    TutGui.SetFont("c94A3B8 s11 norm", "Segoe UI")
    TutGui.Add("Text", "x360 y367 w340 h45 BackgroundTrans", Tr("TutCustDesc"))

    ; -- Sezione 4: Opzioni di Avvio --
    TutGui.SetFont("cWhite s10 norm", "Segoe UI")
    TutGui.Add("CheckBox", "x320 y425 w380 h35 vOptStartup Checked", Tr("TutOptStart"))
    TutGui.Add("CheckBox", "x320 y465 w380 h20 vOptDesktop Checked", Tr("TutOptDesk"))

    ; ─── PIÈ DI PAGINA E PULSANTE ───
    
    ; Linea di separazione (border-t border-slate-700)
    TutGui.Add("Text", "x310 y510 w400 h1 Background27272A")
    
    ; Language Selector
    TutGui.SetFont("c94A3B8 s10 norm", "Segoe UI")
    TutGui.Add("Text", "x320 y540 w60 BackgroundTrans", Tr("Lang") ":")
    ddlIdx := SettingLang = "EN" ? 1 : (SettingLang = "IT" ? 2 : 3)
    ddlLang := TutGui.Add("DropDownList", "x370 y536 w60 Choose" ddlIdx, ["EN", "IT", "ES"])
    ddlLang.OnEvent("Change", (Ctrl, *) => ChangeLanguage(Ctrl.Text, TutGui))

    ; Bottone Azione
    TutGui.SetFont("cBlack s12 bold", "Segoe UI")
    btn := TutGui.Add("Button", "x510 y530 w180 h40 Default", Tr("TutBtnStart"))
    btn.OnEvent("Click", (*) => CloseTutorial(TutGui))
    
    TutGui.OnEvent("Close", (*) => CloseTutorial(TutGui))
    
    TutGui.Show("w740 h600 Center")
}

ChangeLanguage(newLang, GuiObj) {
    Global SettingLang, IniFile
    SettingLang := newLang
    IniWrite(SettingLang, IniFile, "Settings", "Language")
    GuiObj.Destroy()
    ShowTutorial()
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