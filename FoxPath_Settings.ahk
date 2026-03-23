#Requires AutoHotkey v2.0

; ─────────────────────────────────────────────
;  Impostazioni e Gestione Interfaccia
; ─────────────────────────────────────────────
ShowSettings(*) {
    Global SettingsGuiObj, SettingTransparency, SettingWidth, SettingInfoHeight
    Global SettingBtnColor, SettingTextColor, SettingMultiSelect, SettingEditMode
    Global SettingPlaySound, SettingAutoHide, SettingHotkey
    Global SettingFloatingActions, SettingQuickActions
    
    if (SettingsGuiObj) {
        SettingsGuiObj.Show()
        return
    }
    
    SettingsGuiObj := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", Tr("SettingsTitle"))
    SettingsGuiObj.BackColor := "FFFFFF"
    SettingsGuiObj.MarginX := 15
    SettingsGuiObj.MarginY := 15
    SettingsGuiObj.SetFont("s9 c333333", "Segoe UI")
    SettingsGuiObj.OnEvent("Close", (*) => SettingsGuiObj.Hide())
    
    ; Titolo Finestra
    SettingsGuiObj.SetFont("s14 bold c111827", "Segoe UI")
    SettingsGuiObj.Add("Text", "w280 BackgroundTrans", Tr("SettingsTitle"))
    SettingsGuiObj.SetFont("s9 norm c333333", "Segoe UI")
    SettingsGuiObj.Add("Text", "w280 y+10 h1 0x10") ; Linea separatrice
    
    tabs := SettingsGuiObj.Add("Tab3", "w290 y+10", [Tr("TabAppearance"), Tr("TabBehavior"), Tr("TabTools")])
    
    ; --- TAB 1: ASPETTO E COLORI ---
    tabs.UseTab(1)
    SettingsGuiObj.SetFont("s10 bold c111827")
    SettingsGuiObj.Add("Text", "y+15", Tr("VisualCust"))
    SettingsGuiObj.SetFont("s9 norm c333333")
    
    SettingsGuiObj.Add("Text", "w260 y+10 vTxtTrans", Tr("Transp", SettingTransparency))
    slTrans := SettingsGuiObj.Add("Slider", "w260 vTrans Range50-255 ToolTip", SettingTransparency)
    slTrans.OnEvent("Change", (Ctrl, *) => (
        UpdateTransparency(Ctrl.Value),
        SettingsGuiObj["TxtTrans"].Value := Tr("Transp", Ctrl.Value)
    ))
    
    SettingsGuiObj.Add("Text", "w260 y+10 vTxtW", Tr("WinWidth", SettingWidth))
    slW := SettingsGuiObj.Add("Slider", "w260 vW Range100-400 ToolTip", SettingWidth)
    slW.OnEvent("Change", (Ctrl, *) => (
        LiveResize(Ctrl.Value, ""),
        SettingsGuiObj["TxtW"].Value := Tr("WinWidth", Ctrl.Value)
    ))
    
    SettingsGuiObj.Add("Text", "w260 y+10 vTxtH", Tr("PanelHeight", SettingInfoHeight))
    slH := SettingsGuiObj.Add("Slider", "w260 vH Range50-400 ToolTip", SettingInfoHeight)
    slH.OnEvent("Change", (Ctrl, *) => (
        LiveResize("", Ctrl.Value),
        SettingsGuiObj["TxtH"].Value := Tr("PanelHeight", Ctrl.Value)
    ))
    
    SettingsGuiObj.Add("Text", "w120 y+15 section", Tr("BtnColor"))
    edtBtn := SettingsGuiObj.Add("Edit", "w60 ys-3 vBtnColor Center", Format("0x{:08X}", SettingBtnColor))
    btnBtnColor := SettingsGuiObj.Add("Button", "ys-4 w60", Tr("Palette"))
    btnBtnColor.OnEvent("Click", (*) => ChooseColor(edtBtn, SettingBtnColor))

    SettingsGuiObj.Add("Text", "w120 xs y+10 section", Tr("TxtColor"))
    edtTxt := SettingsGuiObj.Add("Edit", "w60 ys-3 vTxtColor Center", Format("0x{:08X}", SettingTextColor))
    btnTxtColor := SettingsGuiObj.Add("Button", "ys-4 w60", Tr("Palette"))
    btnTxtColor.OnEvent("Click", (*) => ChooseColor(edtTxt, SettingTextColor))
    SettingsGuiObj.Add("Text", "h5", "") ; Spazio morbido
    
    ; --- TAB 2: COMPORTAMENTO ---
    tabs.UseTab(2)
    SettingsGuiObj.SetFont("s10 bold c111827")
    SettingsGuiObj.Add("Text", "y+15", Tr("InteractOpt"))
    SettingsGuiObj.SetFont("s9 norm c333333")
    
    SettingsGuiObj.Add("CheckBox", "w260 y+10 vMulti " (SettingMultiSelect ? "Checked" : ""), Tr("MultiSel"))
    SettingsGuiObj.Add("CheckBox", "w260 y+10 vEditMode " (SettingEditMode ? "Checked" : ""), Tr("UnlockResize"))
    SettingsGuiObj.Add("CheckBox", "w260 y+10 vSnd " (SettingPlaySound ? "Checked" : ""), Tr("PlaySound"))
    SettingsGuiObj.Add("CheckBox", "w260 y+10 vAutoH " (SettingAutoHide ? "Checked" : ""), Tr("AutoHide"))
    hasStartup := FileExist(A_Startup "\FoxPath.lnk")
    SettingsGuiObj.Add("CheckBox", "w260 y+10 vStartup " (hasStartup ? "Checked" : ""), Tr("AutoStart"))
    
    SettingsGuiObj.Add("Text", "w260 y+15", Tr("GlobalShortcut"))
    SettingsGuiObj.SetFont("s9 c71717A")
    SettingsGuiObj.Add("Text", "w260 y+2", "(es. ^!f per Ctrl+Alt+F, # per Win, + per Shift)")
    SettingsGuiObj.SetFont("s9 norm c333333")
    SettingsGuiObj.Add("Edit", "w120 y+5 vHotkey Center", SettingHotkey)
    
    SettingsGuiObj.Add("Text", "w260 y+15", Tr("SettingsLang"))
    ddlIdxLang := SettingLang = "EN" ? 1 : (SettingLang = "IT" ? 2 : 3)
    SettingsGuiObj.Add("DropDownList", "w120 y+5 vSettingsLang Choose" ddlIdxLang, ["EN", "IT", "ES"])
    SettingsGuiObj.Add("Text", "h5", "") ; Spazio morbido
    
    ; --- TAB 3: AZIONI E STRUMENTI ---
    tabs.UseTab(3)
    
    baseActionsList := [
        "Nessuno",
        "📋 ─── LIBRERIA COPIA E FORMATTAZIONE ───",
        "Copia Percorso Normale", "Copia come File Reali", "Copia tra Virgolette", "Copia come Link Markdown",
        "🖥️ ─── LIBRERIA PROGRAMMI E SISTEMA ───",
        "Apri in VS Code", "Apri in PowerShell", "Rinomina Elemento", "Formatta JSON", "Minifica JSON",
        "✍️ ─── LIBRERIA ESTRAZIONE E TESTO ───",
        "Copia Contenuto (Solo Testo)", "Copia Contenuto (Mantiene Formattazione)", "Statistiche Testo", "Traduci in Google Translate", "Incolla Appunti Veloci",
        "📸 ─── LIBRERIA IMMAGINI E GRAFICA ───",
        "Estrai Testo (OCR)", "Converti in PNG", "Converti in JPG", "Converti in BMP", "Estrai Palette Colori",
        "🛠️ ─── LIBRERIA UTILITÀ EXTRA ───",
        "Touch (Aggiorna Data)", "Distruzione Sicura", "Crea Collegamento", "Super Zip (Unico)", "Super Zip (Separati)", "Svuota Cestino"
    ]
    
    translatedActionsList := []
    for act in baseActionsList
        translatedActionsList.Push(Tr(act))
    
    SettingsGuiObj.SetFont("s10 bold c111827")
    SettingsGuiObj.Add("Text", "y+15", Tr("PrimaryTool"))
    SettingsGuiObj.SetFont("s9 norm c333333")
    SettingsGuiObj.Add("Text", "w260 y+5", Tr("PrimaryAction"))
    
    currentPrimary := SettingFloatingActions.Length > 0 ? SettingFloatingActions[1] : "Copia Percorso Normale"
    chooseIdx := 3
    for i, act in baseActionsList {
        if (act = currentPrimary) {
            chooseIdx := i
            break
        }
    }
    ddlPrimary := SettingsGuiObj.Add("DropDownList", "w260 y+5 vPrimaryAction AltSubmit Choose" chooseIdx, translatedActionsList)
    ddlPrimary.OnEvent("Change", (Ctrl, *) => CheckDropdownSelection(Ctrl, 3, translatedActionsList))
    
    SettingsGuiObj.Add("Text", "w260 y+10 h1 0x10") ; linea separatrice
    
    SettingsGuiObj.SetFont("s10 bold c111827")
    SettingsGuiObj.Add("Text", "w260 y+10", Tr("QuickMenu"))
    SettingsGuiObj.SetFont("s9 norm c333333")
    
    SettingsGuiObj.Add("Text", "section h0 w0", "") ; Punto di ancoraggio per la griglia
    loop 5 {
        idx := A_Index
        currQA := SettingQuickActions.Length >= idx ? SettingQuickActions[idx] : "Nessuno"
        chooseIdx := 1
        for i, act in baseActionsList {
            if (act = currQA) {
                chooseIdx := i
                break
            }
        }
        yPos := idx = 1 ? "ys+5" : "y+5"
        SettingsGuiObj.Add("Text", "w40 xs " yPos " +0x200", Tr("Slot", idx))
        ddl := SettingsGuiObj.Add("DropDownList", "w210 x+10 yp-2 vQA" idx " AltSubmit Choose" chooseIdx, translatedActionsList)
        ddl.OnEvent("Change", (Ctrl, *) => CheckDropdownSelection(Ctrl, 1, translatedActionsList))
    }
    SettingsGuiObj.Add("Text", "h5", "") ; Spazio morbido
    
    ; --- BOTTONI SALVATAGGIO GLOBALI ---
    tabs.UseTab()
    SettingsGuiObj.Add("Text", "w290 y+15 h1 0x10") ; linea separatrice
    
    SettingsGuiObj.SetFont("s10 bold")
    btnSave := SettingsGuiObj.Add("Button", "w140 h35 x35 y+10 Default", Tr("SaveApply"))
    btnSave.OnEvent("Click", SaveSettings)
    
    SettingsGuiObj.SetFont("s9 norm")
    btnReset := SettingsGuiObj.Add("Button", "w100 h35 x+10 yp", Tr("Reset"))
    btnReset.OnEvent("Click", ResetSettings)
    
    SettingsGuiObj.Show("AutoSize Center")
}

CheckDropdownSelection(Ctrl, defaultIdx, listArray) {
    if InStr(listArray[Ctrl.Value], "───")
        Ctrl.Choose(defaultIdx)
}

UpdateTransparency(val) {
    Global SettingTransparency := val
    if (MascotGui)
        WinSetTransColor("White " val, MascotGui)
}

LiveResize(w, h) {
    Global SettingWidth, SettingInfoHeight
    if (w != "")
        SettingWidth := w
    if (h != "")
        SettingInfoHeight := h
    ApplyMascotSize()
}

ApplyMascotSize() {
    Global MascotGui, MascotPic, InfoPic, SettingWidth, SettingInfoHeight, FoxRatio
    if (!MascotGui)
        return
        
    FoxH := FoxRatio > 0 ? Integer(SettingWidth * FoxRatio) : SettingWidth
    
    try MascotPic.Move(0, 0, SettingWidth, FoxH)
    try InfoPic.Move(0, FoxH, SettingWidth, SettingInfoHeight)
    
    try MascotGui.Move(,, SettingWidth, FoxH + SettingInfoHeight)
    RefreshDisplay()
}

SaveSettings(*) {
    Global SettingsGuiObj, SettingBtnColor, SettingTextColor, SettingMultiSelect, SettingEditMode, MascotGui
    Global SettingPlaySound, SettingAutoHide, SettingHotkey, SettingLang
    Global SettingFloatingActions, SettingQuickActions
    saved := SettingsGuiObj.Submit(false)
    SettingMultiSelect := saved.Multi
    SettingEditMode := saved.EditMode
    SettingPlaySound := saved.Snd
    SettingAutoHide := saved.AutoH
    try SettingBtnColor := Integer(saved.BtnColor)
    catch
        SettingBtnColor := 0xFFD35400
    try SettingTextColor := Integer(saved.TxtColor)
    catch
        SettingTextColor := 0xFFF1F5F9
        
    newHotkey := saved.Hotkey
    if (newHotkey != SettingHotkey) {
        try {
            Hotkey(SettingHotkey, "Off")
            Hotkey(newHotkey, ToggleMascot, "On")
            SettingHotkey := newHotkey
        } catch {
            MsgBox("Scorciatoia non valida! Verrà mantenuta " SettingHotkey, "FoxPath", "IconX")
            try Hotkey(SettingHotkey, ToggleMascot, "On")
        }
    }
    if (saved.HasProp("SettingsLang") && saved.SettingsLang != SettingLang) {
        SettingLang := saved.SettingsLang
        IniWrite(SettingLang, IniFile, "Settings", "Language")
        SettingsGuiObj.Destroy()
        SettingsGuiObj := 0
    }
    
    if (saved.Startup) {
        if (!FileExist(A_Startup "\FoxPath.lnk"))
            try FileCreateShortcut(A_ScriptFullPath, A_Startup "\FoxPath.lnk")
    } else {
        if FileExist(A_Startup "\FoxPath.lnk")
            try FileDelete(A_Startup "\FoxPath.lnk")
    }
    
    priAct := GetBaseActionName(saved.PrimaryAction)
    if (priAct = "Nessuno" || InStr(priAct, "---"))
        priAct := "Copia Percorso Normale"
    SettingFloatingActions := [priAct]
    
    SettingQuickActions := []
    for qaIdx in [saved.QA1, saved.QA2, saved.QA3, saved.QA4, saved.QA5] {
        qa := GetBaseActionName(qaIdx)
        if (qa != "Nessuno" && !InStr(qa, "---"))
            SettingQuickActions.Push(qa)
    }
        
    if (SettingsGuiObj)
        SettingsGuiObj.Hide()
    SaveSettingsToIni()
    if (MascotGui) {
        CloseMascot()
        ShowMascot()
    }
}

SaveSettingsToIni() {
    Global SettingTransparency, SettingWidth, SettingInfoHeight
    Global SettingBtnColor, SettingTextColor, SettingMultiSelect, SettingEditMode
    Global SettingPlaySound, SettingAutoHide, SettingHotkey, IniFile
    Global SettingFirstRun, SettingFloatingActions, SettingQuickActions

    IniWrite(SettingTransparency, IniFile, "Settings", "Transparency")
    IniWrite(SettingWidth, IniFile, "Settings", "Width")
    IniWrite(SettingInfoHeight, IniFile, "Settings", "InfoHeight")
    IniWrite(Format("0x{:08X}", SettingBtnColor), IniFile, "Settings", "BtnColor")
    IniWrite(Format("0x{:08X}", SettingTextColor), IniFile, "Settings", "TextColor")
    IniWrite(SettingMultiSelect, IniFile, "Settings", "MultiSelect")
    IniWrite(SettingEditMode, IniFile, "Settings", "EditMode")
    IniWrite(SettingPlaySound, IniFile, "Settings", "PlaySound")
    IniWrite(SettingAutoHide, IniFile, "Settings", "AutoHide")
    IniWrite(SettingHotkey, IniFile, "Settings", "Hotkey")
    IniWrite(SettingFirstRun, IniFile, "Settings", "FirstRun")
    
    floatStr := ""
    for act in SettingFloatingActions
        floatStr .= act "|"
    IniWrite(RTrim(floatStr, "|"), IniFile, "Settings", "FloatingActions")
    
    qaStr := ""
    for act in SettingQuickActions
        qaStr .= act "|"
    IniWrite(RTrim(qaStr, "|"), IniFile, "Settings", "QuickActions")
}

ResetSettings(*) {
    Global SettingTransparency := 204, SettingWidth := 110, SettingInfoHeight := 122
    Global SettingBtnColor := 0xFFD35400, SettingTextColor := 0xFFF1F5F9
    Global SettingMultiSelect := 1, SettingEditMode := 0
    Global SettingPlaySound := 1, SettingAutoHide := 0, SettingHotkey := "^!f", SettingFirstRun := 1
    Global SettingFloatingActions := ["Copia Percorso Normale"]
    Global SettingQuickActions := ["Copia Percorso Normale", "Copia come File Reali", "Apri in VS Code"]
    SaveSettingsToIni()
    Reload()
}

ChooseColor(EditCtrl, DefaultColor) {
    static CustColors := Buffer(64, 0)
    RGB := ((DefaultColor & 0xFF) << 16) | (DefaultColor & 0xFF00) | ((DefaultColor >> 16) & 0xFF)
    CC := Buffer(A_PtrSize = 8 ? 72 : 36, 0)
    
    offset_rgb := A_PtrSize = 8 ? 24 : 12
    offset_cust := A_PtrSize = 8 ? 32 : 16
    offset_flags := A_PtrSize = 8 ? 40 : 20
    
    NumPut("UInt", CC.Size, CC, 0)
    if (IsSet(SettingsGuiObj) && SettingsGuiObj)
        NumPut("Ptr", SettingsGuiObj.Hwnd, CC, A_PtrSize)
    NumPut("UInt", RGB, CC, offset_rgb)
    NumPut("Ptr", CustColors.Ptr, CC, offset_cust)
    NumPut("UInt", 0x103, CC, offset_flags) ; CC_ANYCOLOR | CC_SOLIDCOLOR | CC_RGBINIT

    if DllCall("comdlg32\ChooseColorW", "Ptr", CC) {
        RGB_New := NumGet(CC, offset_rgb, "UInt")
        ARGB := 0xFF000000 | ((RGB_New & 0xFF) << 16) | (RGB_New & 0xFF00) | ((RGB_New >> 16) & 0xFF)
        EditCtrl.Value := Format("0x{:08X}", ARGB)
    }
}

GetBaseActionName(idx) {
    static actions := [
        "Nessuno",
        "📋 ─── LIBRERIA COPIA E FORMATTAZIONE ───",
        "Copia Percorso Normale", "Copia come File Reali", "Copia tra Virgolette", "Copia come Link Markdown",
        "🖥️ ─── LIBRERIA PROGRAMMI E SISTEMA ───",
        "Apri in VS Code", "Apri in PowerShell", "Rinomina Elemento", "Formatta JSON", "Minifica JSON",
        "✍️ ─── LIBRERIA ESTRAZIONE E TESTO ───",
        "Copia Contenuto (Solo Testo)", "Copia Contenuto (Mantiene Formattazione)", "Statistiche Testo", "Traduci in Google Translate", "Incolla Appunti Veloci",
        "📸 ─── LIBRERIA IMMAGINI E GRAFICA ───",
        "Estrai Testo (OCR)", "Converti in PNG", "Converti in JPG", "Converti in BMP", "Estrai Palette Colori",
        "🛠️ ─── LIBRERIA UTILITÀ EXTRA ───",
        "Touch (Aggiorna Data)", "Distruzione Sicura", "Crea Collegamento", "Super Zip (Unico)", "Super Zip (Separati)", "Svuota Cestino"
    ]
    return actions.Has(idx) ? actions[idx] : "Nessuno"
}