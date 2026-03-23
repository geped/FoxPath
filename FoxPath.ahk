#Requires AutoHotkey v2.0
#SingleInstance Force

; --- DIRETTIVE COMPILATORE (Utili per ridurre falsi positivi Antivirus) ---
;@Ahk2Exe-SetDescription FoxPath - Assistente Visivo e Tool di Produttività
;@Ahk2Exe-SetVersion 2.1.0.0
;@Ahk2Exe-SetCopyright Copyright (c) 2026
;@Ahk2Exe-SetOrigFilename FoxPath.exe

ListLines 0
ProcessSetPriority "High"
; #NoTrayIcon  ; Togli il punto e virgola a inizio riga se vuoi nascondere l'icona "H" verde

; --- GLOBALS ---
Global SelectedPath := ""
Global MascotGui    := 0
Global MascotPic    := 0
Global InfoPic      := 0
Global InfoTmpA     := A_Temp "\foxpath_a.png"
Global InfoTmpB     := A_Temp "\foxpath_b.png"
Global InfoTmpFlip  := false
Global GdipToken    := 0

; Impostazioni
Global SettingTransparency := 204
Global SettingWidth := 110
Global SettingInfoHeight := 122
Global SettingBtnColor := 0xFFD35400
Global SettingTextColor := 0xFFF1F5F9
Global SettingMultiSelect := 1
Global SettingEditMode := 0
Global SettingPlaySound := 1
Global SettingAutoHide := 0
Global SettingHotkey := "^!f"
Global IniFile := A_ScriptDir "\FoxPath.ini"
Global SettingLang := "EN"
Global SettingFirstRun := 1
Global SettingFloatingActions := ["Copia Percorso Normale"]
Global SettingQuickActions := ["Copia Percorso Normale", "Copia come File Reali", "Apri in VS Code"]
Global SettingsGuiObj := 0
Global FoxRatio := 0
Global RecentPaths := []

; --- Incorpora le immagini nell'eseguibile ---
FileInstall("fox_saluto.png", A_Temp "\fox_saluto.png", 1)
FileInstall("fox_attesa.png", A_Temp "\fox_attesa.png", 1)
FileInstall("fox_conferma.png", A_Temp "\fox_conferma.png", 1)

Global ImgSaluto   := A_Temp "\fox_saluto.png"
Global ImgAttesa   := A_Temp "\fox_attesa.png"
Global ImgConferma := A_Temp "\fox_conferma.png"

#Include "FoxPath_Lang.ahk"
InitLang()

LoadSettings()

try Hotkey(SettingHotkey, ToggleMascot)
catch {
    SettingHotkey := "^!f"
    Hotkey(SettingHotkey, ToggleMascot)
}

if (SettingFirstRun) {
    SetTimer(ShowTutorial, -500)
}

LoadSettings() {
    Global SettingTransparency, SettingWidth, SettingInfoHeight
    Global SettingBtnColor, SettingTextColor, SettingMultiSelect, SettingEditMode
    Global SettingPlaySound, SettingAutoHide, SettingHotkey, SettingLang, SettingFirstRun
    Global IniFile

    try {
        SettingTransparency := Integer(IniRead(IniFile, "Settings", "Transparency", 204))
        SettingWidth := Integer(IniRead(IniFile, "Settings", "Width", 110))
        SettingInfoHeight := Integer(IniRead(IniFile, "Settings", "InfoHeight", 122))
        SettingBtnColor := Integer(IniRead(IniFile, "Settings", "BtnColor", "0xFFD35400"))
        SettingTextColor := Integer(IniRead(IniFile, "Settings", "TextColor", "0xFFF1F5F9"))
        SettingMultiSelect := Integer(IniRead(IniFile, "Settings", "MultiSelect", 1))
        SettingEditMode := Integer(IniRead(IniFile, "Settings", "EditMode", 0))
        SettingPlaySound := Integer(IniRead(IniFile, "Settings", "PlaySound", 1))
        SettingAutoHide := Integer(IniRead(IniFile, "Settings", "AutoHide", 0))
        SettingHotkey := IniRead(IniFile, "Settings", "Hotkey", "^!f")
        SettingLang := IniRead(IniFile, "Settings", "Language", "EN")
        ; Sovrascrive automaticamente se l'utente aveva ancora il vecchio default "+f"
        if (SettingHotkey == "+f") {
            SettingHotkey := "^!f"
            IniWrite(SettingHotkey, IniFile, "Settings", "Hotkey")
        }
        SettingFirstRun := Integer(IniRead(IniFile, "Settings", "FirstRun", 1))
        
        floatStr := IniRead(IniFile, "Settings", "FloatingActions", "Copia Percorso Normale")
        SettingFloatingActions := StrSplit(floatStr, "|")
        
        qaStr := IniRead(IniFile, "Settings", "QuickActions", "Copia Percorso Normale|Copia come File Reali|Apri in VS Code")
        SettingQuickActions := StrSplit(qaStr, "|")
    } catch {
        ; Valori di default in caso di primo avvio o file corrotto
    }
}

; Inizializza GDI+ una volta sola
GdipToken := GdipInit()

; Cerca percorso: match diretto, figlio diretto (desktop), catena parent (Explorer)
GetPathFromActiveWindow() {
    try {
        hActive := WinActive("A")
        if (!hActive)
            return ""

        winClass := WinGetClass(hActive)
        if (winClass = "TTOTAL_CMD") {
            oldClip := ClipboardAll()
            A_Clipboard := ""
            SendMessage(1075, 2018, 0, , "ahk_id " hActive)
            ClipWait(0.5)
            tcPath := A_Clipboard
            A_Clipboard := oldClip
            if (tcPath != "")
                return RTrim(tcPath, "`r`n")
            return ""
        }

        shell := ComObject("Shell.Application")
        bestWindow := 0
        fallbackWindow := 0
        winTitle := WinGetTitle(hActive)

        for window in shell.Windows {
            try {
                wHwnd := window.hwnd
                isMatch := (wHwnd = hActive)
                
                if (!isMatch && (winClass = "Progman" || winClass = "WorkerW")) {
                    wClass := WinGetClass(wHwnd)
                    if (wClass = "Progman" || wClass = "WorkerW")
                        isMatch := true
                }
                
                if (!isMatch) {
                    testHwnd := hActive
                    loop 5 {
                        testHwnd := DllCall("GetParent", "Ptr", testHwnd, "Ptr")
                        if (!testHwnd)
                            break
                        if (wHwnd = testHwnd) {
                            isMatch := true
                            break
                        }
                    }
                }
                
                if (isMatch) {
                    fallbackWindow := window
                    locName := ""
                    try locName := window.LocationName
                    
                    if (locName != "" && InStr(winTitle, locName)) {
                        bestWindow := window
                        break
                    }
                }
            }
        }

        targetWindow := bestWindow ? bestWindow : fallbackWindow

        if (targetWindow) {
            try {
                selItems := targetWindow.Document.SelectedItems
                paths := ""
                
                ; Controlla esplicitamente se ci sono elementi selezionati
                if (selItems.Count > 0) {
                    for item in selItems {
                        paths .= item.Path "`r`n"
                        if (!SettingMultiSelect)
                            break
                    }
                    if (paths != "")
                        return RTrim(paths, "`r`n")
                }
                
                ; Opzione 2: Se la selezione è vuota (clic nel vuoto), recupera la cartella corrente
                folderPath := targetWindow.Document.Folder.Self.Path
                if (folderPath != "")
                    return folderPath
            } catch {
                ; Se l'Esplora File va in errore nel restituire gli oggetti, ignora e azzera
            }
        }
    }
    return ""
}

; Abbrevia percorso lungo: drive\d1\d2\d3...\parent\file
FormatPath(fullPath) {
    parts := StrSplit(fullPath, "\")
    n     := parts.Length
    if (n <= 6)
        return fullPath
    head := parts[1] "\" parts[2] "\" parts[3] "\" parts[4]
    tail := parts[n - 1] "\" parts[n]
    return head "...\" tail
}

; ─────────────────────────────────────────────
;  Toggle: Mostra / Nascondi
; ─────────────────────────────────────────────
ToggleMascot(ThisHotkey := "") {
    Global MascotGui, SelectedPath
    if (MascotGui) {
        CloseMascot()
        return
    }
    SelectedPath := GetPathFromActiveWindow()
    ShowMascot()
}

; ─────────────────────────────────────────────
;  Costruisce la GUI
; ─────────────────────────────────────────────
ShowMascot() {
    Global MascotGui, MascotPic, InfoPic, SettingWidth, SettingInfoHeight, SettingTransparency, SettingEditMode, FoxRatio

    resizeOpt := SettingEditMode ? "+Resize +MinSize100x150" : ""
    MascotGui := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x08000000 " resizeOpt)
    MascotGui.BackColor := "White"
    MascotGui.MarginX := 0
    MascotGui.MarginY := 0
    MascotGui.OnEvent("DropFiles", OnMascotDrop)

    ; Fox image — white background becomes transparent via TransColor
    MascotPic := MascotGui.Add("Picture", "w" SettingWidth " h-1 x0 y0", ImgSaluto)
    MascotPic.GetPos(,, &actualW, &actualH)
    if (actualW > 0)
        FoxRatio := actualH / actualW

    ; Info panel rendered as GDI+ PNG
    primaryAct := SettingFloatingActions.Length > 0 ? SettingFloatingActions[1] : "Copia Percorso Normale"
    infoPng := DrawInfoPanel(SelectedPath != "", _GetDisplayName(), _GetFormattedPath(), Tr(primaryAct))
    InfoPic := MascotGui.Add("Picture", "w" SettingWidth " h" SettingInfoHeight " x0 y+0", infoPng)
    InfoPic.OnEvent("Click", OnInfoClick)
    InfoPic.OnEvent("ContextMenu", ShowCopyMenu)
    
    MascotGui.OnEvent("Size", OnMascotSize)

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mX, &mY)
    WinSetTransColor("White 0", MascotGui)
    MascotGui.Show("w" SettingWidth " h" (actualH + SettingInfoHeight) " x" (mX - 48) " y" (mY - 220) " NoActivate")

    ; Effetto Fade-In
    alpha := 0
    while (alpha < SettingTransparency) {
        alpha += 25
        if (alpha > SettingTransparency)
            alpha := SettingTransparency
        WinSetTransColor("White " alpha, MascotGui)
        Sleep(15)
    }
    WinSetTransColor("White " SettingTransparency, MascotGui)

    ; Saluto 3 s poi passa ad attesa
    SetTimer(() => (MascotPic ? MascotPic.Value := "*w" SettingWidth " *h-1 " ImgAttesa : 0), -3000)

    OnMessage(0x0201, WM_LBUTTONDOWN)
    InitEventHook()
}

; ─────────────────────────────────────────────
;  Gestione Ridimensionamento (Resize)
; ─────────────────────────────────────────────
OnMascotSize(GuiObj, MinMax, Width, Height) {
    Global SettingWidth, SettingInfoHeight, MascotPic, InfoPic, FoxRatio, SettingsGuiObj, MascotGui
    if (MinMax = 1) ; Minimizzato
        return
        
    ; Mantiene bloccato l'aspect ratio
    FoxHeight := FoxRatio > 0 ? Integer(Width * FoxRatio) : Width
    
    SettingWidth := Width
    SettingInfoHeight := Height - FoxHeight
    if (SettingInfoHeight < 50) {
        SettingInfoHeight := 50
    }
    try MascotPic.Move(0, 0, Width, FoxHeight)
    try InfoPic.Move(0, FoxHeight, SettingWidth, SettingInfoHeight)
    
    ; Forza la finestra all'altezza corretta se l'utente ha deformato l'aspect ratio
    if (Height != FoxHeight + SettingInfoHeight)
        try MascotGui.Move(,, SettingWidth, FoxHeight + SettingInfoHeight)
        
    SetTimer(RefreshDisplay, -100)
    
    ; Aggiorna slider attivamente se aperto
    if (SettingsGuiObj) {
        try SettingsGuiObj["W"].Value := SettingWidth
        try SettingsGuiObj["H"].Value := SettingInfoHeight
    }
}

; ─────────────────────────────────────────────
;  Gestione Clic sul Pannello GDI+
; ─────────────────────────────────────────────
OnInfoClick(Ctrl, *) {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mX, &mY)
    WinGetPos(&cX, &cY, &cW, &cH, Ctrl.Hwnd)
    relX := mX - cX
    relY := mY - cY
    ; Se il clic avviene nell'angolo in alto a destra (30x30 px), apri impostazioni
    if (relX >= cW - 30 && relY <= 30) {
        ShowSettings()
    } else {
        if (SettingFloatingActions.Length > 0)
            ExecuteAction(SettingFloatingActions[1])
        else
            CopyAction()
    }
}

; ─────────────────────────────────────────────
;  Helper: display name / formatted path
; ─────────────────────────────────────────────
_GetDisplayName() {
    Global SelectedPath
    if (SelectedPath = "")
        return ""
    if InStr(SelectedPath, "`r`n") {
        count := StrSplit(SelectedPath, "`r`n").Length
        return count " file selezionati"
    }
    CleanPath := RTrim(SelectedPath, "\")
    SplitPath(CleanPath, &FileName)
    return StrLen(FileName) > 13 ? SubStr(FileName, 1, 10) "..." : FileName
}

_GetFormattedPath() {
    Global SelectedPath
    if (SelectedPath = "")
        return ""
    if InStr(SelectedPath, "`r`n") {
        firstPath := StrSplit(SelectedPath, "`r`n")[1]
        SplitPath(firstPath, , &dir)
        return FormatPath(dir)
    }
    return FormatPath(RTrim(SelectedPath, "\"))
}

; ─────────────────────────────────────────────
;  Aggiorna il pannello GDI+ senza ricostruire la GUI
; ─────────────────────────────────────────────
RefreshDisplay() {
    Global InfoPic, SelectedPath, MascotGui, SettingWidth, SettingInfoHeight, SettingFloatingActions
    if (!MascotGui)
        return
    hasPath     := SelectedPath != ""
    displayName := _GetDisplayName()
    pathText    := _GetFormattedPath()
    primaryAct  := SettingFloatingActions.Length > 0 ? SettingFloatingActions[1] : "Copia Percorso Normale"
    infoPng     := DrawInfoPanel(hasPath, displayName, pathText, Tr(primaryAct))
    ; Usa *w *h per evitare che il controllo perda l'allineamento dei pixel logici rispetto all'immagine
    InfoPic.Value := "*w" SettingWidth " *h" SettingInfoHeight " " infoPng
}

; ─────────────────────────────────────────────
;  Event Hooks per Selezione e Focus
; ─────────────────────────────────────────────
InitEventHook() {
    ; Usa un timer invece di SetWinEventHook per bypassare il bug di Windows 11 
    ; in cui il nuovo Esplora File non lancia eventi di selezione affidabili.
    SetTimer(TryGetPathFromEvent, 250)
}

RemoveEventHook() {
    SetTimer(TryGetPathFromEvent, 0)
}

TryGetPathFromEvent() {
    Global SelectedPath, MascotGui
    if (!MascotGui)
        return
        
    ; Forza continuamente la finestra in primissimo piano scavalcando altre app
    try WinSetAlwaysOnTop(1, MascotGui.Hwnd)

    newPath := GetPathFromActiveWindow()
    if (newPath != SelectedPath) {
        SelectedPath := newPath
        RefreshDisplay()
    }
}

; ─────────────────────────────────────────────
;  Supporto Drag & Drop
; ─────────────────────────────────────────────
OnMascotDrop(GuiObj, GuiCtrlObj, FileArray, X, Y) {
    Global SelectedPath, SettingMultiSelect
    paths := ""
    for file in FileArray {
        paths .= file "`r`n"
        if (!SettingMultiSelect)
            break
    }
    
    SelectedPath := RTrim(paths, "`r`n")
    RefreshDisplay()
    CopyAction()
}

; ─────────────────────────────────────────────
;  Copia percorso — la volpe rimane aperta
; ─────────────────────────────────────────────
CopyAction() {
    Global SelectedPath
    if (SelectedPath = "")
        return
    A_Clipboard := SelectedPath
    AddToHistory(SelectedPath)
    FinishCopy()
}

; ─────────────────────────────────────────────
;  Chiude la volpe
; ─────────────────────────────────────────────
CloseMascot() {
    Global MascotGui, MascotPic, InfoPic
    RemoveEventHook()
    if (MascotGui) {
        hwnd := MascotGui.Hwnd
        alpha := SettingTransparency
        while (alpha > 0) {
            alpha -= 25
            if (alpha < 0)
                alpha := 0
            try WinSetTransColor("White " alpha, hwnd)
            Sleep(15)
        }
        MascotGui.Destroy()
        MascotGui := 0
    }
    MascotPic := 0
    InfoPic   := 0
}

; Permette di trascinare la finestra
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    Global MascotGui, MascotPic
    if (!MascotGui)
        return
    if (hwnd = MascotGui.Hwnd || (MascotPic && hwnd = MascotPic.Hwnd))
        PostMessage(0xA1, 2,,, "ahk_id " hwnd)
}

; ─────────────────────────────────────────────
;  Rinomina File o Cartella
; ─────────────────────────────────────────────
RenameFileAction() {
    Global SelectedPath, MascotPic, SettingWidth, ImgConferma, ImgAttesa
    
    ; Controlla che ci sia una selezione e che non sia multipla
    if (SelectedPath = "" || InStr(SelectedPath, "`r`n")) {
        MsgBox("Seleziona un singolo file o cartella per rinominarlo.", "FoxPath", "Iconi")
        return
    }
    
    SplitPath(SelectedPath, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt)
    isDir := InStr(FileExist(SelectedPath), "D")
    
    ; Mostra il prompt precompilato con il nome senza estensione
    ib := InputBox("Inserisci il nuovo nome:", "Rinomina Elemento", "w300 h130", OutNameNoExt)
    if (ib.Result = "Cancel" || ib.Value = "")
        return
        
    newName := ib.Value
    ; Regex per prevenire i caratteri illegali di Windows
    if RegExMatch(newName, '[\\/:*?"<>|]') {
        MsgBox("Il nome contiene caratteri non validi.", "Errore", "Iconx")
        return
    }
    
    newFullName := OutDir "\" newName
    if (!isDir && OutExtension != "")
        newFullName .= "." OutExtension
        
    if (newFullName = SelectedPath)
        return
        
    if (FileExist(newFullName)) {
        MsgBox("Esiste già un elemento con questo nome.", "Errore", "Iconx")
        return
    }
    
    try {
        if (isDir)
            DirMove(SelectedPath, newFullName)
        else
            FileMove(SelectedPath, newFullName)
            
        SelectedPath := newFullName
        RefreshDisplay()
        
        ; Mostra l'immagine di conferma per 2 secondi
        if (MascotPic) {
            MascotPic.Value := "*w" SettingWidth " *h-1 " ImgConferma
            SetTimer(() => (MascotPic ? MascotPic.Value := "*w" SettingWidth " *h-1 " ImgAttesa : 0), -2000)
        }
    } catch as err {
        MsgBox("Errore durante la rinomina: " err.Message, "Errore", "Iconx")
    }
}

; ─────────────────────────────────────────────
;  Inclusioni Moduli Esterni
; ─────────────────────────────────────────────
#Include "FoxPath_Settings.ahk"
#Include "FoxPath_Actions.ahk"
#Include "FoxPath_GDI.ahk"
#Include "FoxPath_Tutorial.ahk"
