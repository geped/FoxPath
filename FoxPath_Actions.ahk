#Requires AutoHotkey v2.0

; ─────────────────────────────────────────────
;  Menu Contestuale Opzioni Avanzate e Azioni
; ─────────────────────────────────────────────
ShowCopyMenu(*) {
    Global SelectedPath, RecentPaths, SettingQuickActions
    if (SelectedPath = "")
        return
        
    m := Menu()
    
    SplitPath(SelectedPath, &name, &dir, &ext)
    isDir := InStr(FileExist(SelectedPath), "D")
    isMulti := InStr(SelectedPath, "`r`n")
    if (isMulti) {
        firstPath := StrSplit(SelectedPath, "`r`n")[1]
        SplitPath(firstPath, , &dir)
    }
    
    quotesPath := ""
    commaPath := ""
    for p in StrSplit(SelectedPath, "`r`n") {
        quotesPath .= '"' p '"`r`n'
        commaPath .= '"' p '", '
    }
    quotesPath := RTrim(quotesPath, "`r`n")
    commaPath := RTrim(commaPath, ", ")
    
    jsonArray := "["
    for p in StrSplit(SelectedPath, "`r`n") {
        formatted := StrReplace(p, "\", "\\")
        formatted := StrReplace(formatted, '"', '\"')
        jsonArray .= '"' formatted '", '
    }
    jsonArray := RTrim(jsonArray, ", ") . "]"
    
    uriPath := ""
    for p in StrSplit(SelectedPath, "`r`n") {
        formatted := StrReplace(p, "\", "/")
        formatted := StrReplace(formatted, " ", "%20")
        uriPath .= "file:///" formatted "`r`n"
    }
    uriPath := RTrim(uriPath, "`r`n")
    
    wslPath := ""
    for p in StrSplit(SelectedPath, "`r`n") {
        formatted := StrReplace(p, "\", "/")
        ; Converte C:\ in /mnt/c/ per sviluppatori Linux/WSL
        if RegExMatch(formatted, "^([A-Za-z]):", &match) {
            formatted := "/mnt/" StrLower(match[1]) SubStr(formatted, 3)
        }
        wslPath .= formatted "`r`n"
    }
    wslPath := RTrim(wslPath, "`r`n")
    
    slashPath := StrReplace(SelectedPath, "\", "/")
    relPath := RegExReplace(SelectedPath, "m)^[A-Za-z]:", "") ; Rimuove le lettere unità (C:)
    
    ; --- AZIONI RAPIDE PERSONALIZZABILI ---
    addedQA := 0
    for qa in SettingQuickActions {
        if (addedQA >= 6)
            break
        if (qa != "Nessuno") {
            ; Logica Intelligente: nasconde strumenti non compatibili col file selezionato
            if (qa = "Converti in PNG" && ext = "png")
                continue
            if (qa = "Converti in JPG" && (ext = "jpg" || ext = "jpeg"))
                continue
            if (qa = "Converti in BMP" && ext = "bmp")
                continue
            if ((qa = "Formatta JSON" || qa = "Minifica JSON") && ext != "json")
                continue
            if (qa = "Estrai Testo (OCR)" && !(ext ~= "i)^(png|jpg|jpeg|webp|bmp|gif)$"))
                continue
            if (InStr(qa, "Copia Contenuto") && !(ext ~= "i)^(txt|md|csv|ini|log|js|html|css|py|ahk|bat|ps1|json|docx|doc|rtf|xlsx|xls)$"))
                continue
                
            iconText := GetIconForAction(qa) " " Tr(qa)
            m.Add(iconText, ((act, *) => ExecuteAction(act)).Bind(qa))
            addedQA++
        }
    }
    if (addedQA > 0)
        m.Add()

    mFmt := Menu()
    mFmt.Add(Tr("Copia tra Virgolette"), (*) => CopySpecific(quotesPath))
    mFmt.Add(Tr("Copia separati da Virgola"), (*) => CopySpecific(commaPath))
    mFmt.Add(Tr("Copia con Slash ( / )"), (*) => CopySpecific(slashPath))
    mFmt.Add(Tr("Copia Relativo (senza Unità)"), (*) => CopySpecific(relPath))
    mFmt.Add(Tr("Copia come Web URI (file:///)"), (*) => CopySpecific(uriPath))
    mFmt.Add(Tr("Copia come Array JSON"), (*) => CopySpecific(jsonArray))
    mFmt.Add(Tr("Copia come Percorso WSL (/mnt/...)"), (*) => CopySpecific(wslPath))
    if (!isMulti) {
        mFmt.Add()
        mFmt.Add(Tr("Copia solo Nome File"), (*) => CopySpecific(name))
        mFmt.Add(Tr("Copia Cartella Padre"), (*) => CopySpecific(dir))
    }
    m.Add(Tr("Formattazione Avanzata"), mFmt)
    
    if (!isMulti) {
        if (ext ~= "i)^(txt|md|csv|xml|ini|log|js|html|css|py|ahk|bat|ps1|json)$") {
            mText := Menu()
            mText.Add(Tr("📝 Copia Contenuto (Solo Testo)"), (*) => CopyFileContent(SelectedPath))
            if (ext = "json") {
                mText.Add()
                mText.Add(Tr("✨ Formatta JSON (Pretty Print)"), (*) => FormatJsonAction(SelectedPath, false))
                mText.Add(Tr("🗜️ Minifica JSON"), (*) => FormatJsonAction(SelectedPath, true))
            }
            m.Add(Tr("📄 Testo & Codice"), mText)
        }
        
        if (ext ~= "i)^(docx|doc|rtf|xlsx|xls)$") {
            mOffice := Menu()
            appT := (ext ~= "i)^(xlsx|xls)$") ? "Excel.Application" : "Word.Application"
            mOffice.Add(Tr("📝 Copia Contenuto (Mantiene Formattazione)"), (*) => CopyOfficeContent(SelectedPath, appT, true))
            mOffice.Add(Tr("📝 Copia Contenuto (Solo Testo Grezzo)"), (*) => CopyOfficeContent(SelectedPath, appT, false))
            mOffice.Add()
            mOffice.Add(Tr("📄 Esporta in PDF (Silenzioso)"), (*) => OfficeToPdfAction(SelectedPath, appT))
            m.Add(Tr("📄 Strumenti Office"), mOffice)
        }
        
        if (ext ~= "i)^(csv|log)$") {
            mData := Menu()
            mData.Add(Tr("🔍 Anteprima Dati (Head)"), (*) => DataPreviewAction(SelectedPath))
            if (ext = "csv")
                mData.Add(Tr("🔄 Converti in JSON"), (*) => CsvToJsonAction(SelectedPath))
            m.Add(Tr("📊 Dati & File Log"), mData)
        }
        
        if (ext ~= "i)^(txt|md|docx|doc|rtf|log|ini|json|csv)$") {
            mEd := Menu()
            mEd.Add(Tr("📈 Statistiche Testo (Parole/Caratteri)"), (*) => TextStatsAction(SelectedPath))
            mEd.Add(Tr("🌐 Traduci in Google Translate"), (*) => TranslateTextAction(SelectedPath))
            mEd.Add(Tr("🔗 Copia come Link Markdown"), (*) => CopyMarkdownLink(SelectedPath))
            m.Add(Tr("✍️ Editoriale"), mEd)
        }
        
        if (ext ~= "i)^(png|jpg|jpeg|webp|bmp|gif|svg)$") {
            mImg := Menu()
            if (ext = "svg") {
                mImg.Add(Tr("✂️ Copia SVG Minimizzato"), (*) => SvgExtractorAction(SelectedPath))
            } else {
                mImg.Add(Tr("🔍 Estrai Testo (OCR)"), (*) => ExtractOcrText(SelectedPath))
                mImg.Add(Tr("📐 Ridimensiona (Smart Resize)..."), (*) => ImageResizerAction(SelectedPath))
                if (ext = "png")
                    mImg.Add(Tr("🖼️ Genera Icona (.ico)"), (*) => GenerateIcoAction(SelectedPath))
                mImg.Add()
                if (ext != "png")
                    mImg.Add(Tr("🔄 Converti in PNG"), (*) => ConvertImageAction(SelectedPath, "png"))
                if (ext != "jpg" && ext != "jpeg")
                    mImg.Add(Tr("🔄 Converti in JPG"), (*) => ConvertImageAction(SelectedPath, "jpg"))
                if (ext != "bmp")
                    mImg.Add(Tr("🔄 Converti in BMP"), (*) => ConvertImageAction(SelectedPath, "bmp"))
                mImg.Add()
                mImg.Add(Tr("🎨 Estrai Palette (Colori Dominanti)"), (*) => ExtractPaletteAction(SelectedPath))
            }
            m.Add(Tr("📸 Immagini & Grafica"), mImg)
        }
        
        if (!isDir) {
            mDev := Menu()
            mDev.Add(Tr("🔐 Calcola Checksum (MD5/SHA-256)"), (*) => CalculateChecksumAction(SelectedPath))
            mDev.Add(Tr("🌐 URL Encode / Decode..."), (*) => UrlEncodeDecodeAction(SelectedPath))
            mDev.Add(Tr("️ Copia come Base64"), (*) => CopyBase64Action(SelectedPath))
            mDev.Add(Tr("🔑 JWT Decoder (Da Appunti)"), (*) => JwtDecoderAction())
            if (ext ~= "i)^(txt|md|csv|ini|log|js|html|css|py|ahk|bat|ps1|json)$")
                mDev.Add(Tr("🧪 Test RegEx Rapido..."), (*) => RegexTesterAction(SelectedPath))
            mDev.Add(Tr("📸 Copia Metadati (JSON)"), (*) => CopyMetadataAction(SelectedPath))
            mDev.Add(Tr("🧬 Estrai Stringhe (Text)"), (*) => ExtractStringsAction(SelectedPath))
            mDev.Add(Tr("🗜️ Aumenta Peso File (Pumper)..."), (*) => FilePumperAction(SelectedPath))
            mDev.Add()
            mDev.Add(Tr("🗑️ Distruzione Sicura"), (*) => SecureShredAction(SelectedPath))
            m.Add(Tr("🛠️ Sviluppatore & Sicurezza"), mDev)
        } else {
            mDev := Menu()
            mDev.Add(Tr("🧩 Crea File da Appunti (Decodifica Base64)"), (*) => PasteBase64Action(SelectedPath))
            mDev.Add(Tr("🗜️ Crea File Dummy (Zero Fill)..."), (*) => CreateDummyFileAction(SelectedPath))
            mDev.Add(Tr("🔗 Crea Symlink (Target da Appunti)"), (*) => PasteSymlinkAction(SelectedPath))
            m.Add(Tr("🛠️ Sviluppatore"), mDev)
            
            mGit := Menu()
            mGit.Add(Tr("⬇️ Git Pull"), (*) => GitPullAction(SelectedPath))
            mGit.Add(Tr("✅ Git Add & Commit..."), (*) => GitCommitAction(SelectedPath))
            mProgDir := Menu()
            mProgDir.Add(Tr("📄 Crea File da Snippet..."), (*) => CreateSnippetAction(SelectedPath))
            mProgDir.Add(Tr("Git Actions"), mGit)
            m.Add(Tr("💻 Programmazione"), mProgDir)
            mNote := Menu()
            mNote.Add(Tr("📝 Incolla Appunti Veloci (.txt)"), (*) => QuickNotesAction(SelectedPath))
            m.Add(Tr("✍️ Editoriale"), mNote)
        }
        
        mAct := Menu()
        if (ext ~= "i)^(exe|bat|cmd|py|ps1|ahk)$")
            mAct.Add(Tr("⚙️ Esegui con Parametri"), (*) => RunWithArgsAction(SelectedPath))
        mAct.Add(Tr("⏱️ Aggiorna Data Modifica (Touch)"), (*) => TouchAction(SelectedPath))
        mAct.Add(Tr("🕰️ Modifica Attributi e Date..."), (*) => ShowAttributesEditor(SelectedPath))
        mAct.Add(Tr("✏️ Rinomina Elemento..."), (*) => RenameFileAction())
        mAct.Add(Tr("🔗 Crea Collegamento..."), (*) => CreateShortcutAction(SelectedPath))
        mAct.Add(Tr("🖥️ Apri in PowerShell"), (*) => Run("powershell.exe -NoExit -Command cd '" dir "'"))
        mAct.Add(Tr(" Apri in VS Code"), (*) => OpenInVSCode(SelectedPath))
        m.Add(Tr("🔧 Gestione & Azioni"), mAct)
    } else {
        mAct := Menu()
        mAct.Add(Tr("🗃️ Rinomina Multipla..."), (*) => BulkRenameAction(SelectedPath))
        mAct.Add(Tr(" Fast Merge (Unione Dati/Testi)"), (*) => FastMergeAction(SelectedPath))
        mAct.Add(Tr("🔗 Crea Collegamenti..."), (*) => CreateShortcutAction(SelectedPath))
        mAct.Add(Tr("🖥️ Apri in PowerShell"), (*) => Run("powershell.exe -NoExit -Command cd '" dir "'"))
        m.Add(Tr(" Gestione & Azioni"), mAct)
        
        mZip := Menu()
        mZip.Add(Tr("🗜️ Comprimi in archivi separati (.zip)"), (*) => SuperZipAction(SelectedPath, "individual"))
        mZip.Add(Tr("🗜️ Comprimi in un unico archivio (.zip)"), (*) => SuperZipAction(SelectedPath, "single"))
        m.Add(Tr("📦 Super Zip"), mZip)
        m.Add()

        mFiltroPath := Menu()
        mFiltroFile := Menu()
        extMap := Map()
        catMap := Map("Immagini", [], "Sviluppo", [], "Documenti", [], "Archivi", [])
        
        for p in StrSplit(SelectedPath, "`r`n") {
            SplitPath(p, , , &ext, &nameNoExt)
            ext := StrLower(ext)
            if (ext = "")
                continue
            if !extMap.Has(ext)
                extMap[ext] := []
            extMap[ext].Push(p)
            
            if (ext ~= "^(png|jpg|jpeg|webp|gif|bmp|svg|ico)$")
                catMap["Immagini"].Push(p)
            else if (ext ~= "^(js|html|css|py|ahk|json|xml|ts|c|cpp|h|cs|php)$")
                catMap["Sviluppo"].Push(p)
            else if (ext ~= "^(pdf|doc|docx|txt|md|csv|xls|xlsx|ppt|pptx)$")
                catMap["Documenti"].Push(p)
            else if (ext ~= "^(zip|rar|7z|tar|gz)$")
                catMap["Archivi"].Push(p)
        }
        
        hasItems := false
        for cat, list in catMap {
            if (list.Length > 0) {
                hasItems := true
                joined := ""
                for lp in list
                    joined .= lp "`r`n"
                joined := RTrim(joined, "`r`n")
            mFiltroPath.Add(Tr("Tutti in") " " Tr(cat) " (" list.Length ")", ((text, *) => CopySpecific(text)).Bind(joined))
            mFiltroFile.Add(Tr("Tutti in") " " Tr(cat) " (" list.Length ")", ((text, *) => CopyAsFiles(text)).Bind(joined))
            }
        }
        if (hasItems) {
            mFiltroPath.Add()
            mFiltroFile.Add()
        }
        hasExts := false
        for ext, list in extMap {
            hasExts := true
            joined := ""
            for lp in list
                joined .= lp "`r`n"
            joined := RTrim(joined, "`r`n")
            mFiltroPath.Add(Tr("Solo i .") ext " (" list.Length ")", ((text, *) => CopySpecific(text)).Bind(joined))
            mFiltroFile.Add(Tr("Solo i .") ext " (" list.Length ")", ((text, *) => CopyAsFiles(text)).Bind(joined))
        }
        if (hasItems || hasExts) {
            m.Add(Tr("🔍 Filtra e Copia Percorsi..."), mFiltroPath)
            m.Add(Tr("📁 Filtra e Copia FILE reali..."), mFiltroFile)
        }
    }
    
    m.Add()
    if (RecentPaths.Length > 0) {
        mRec := Menu()
        for i, p in RecentPaths {
            disp := StrLen(p) > 40 ? SubStr(p, 1, 37) "..." : p
            mRec.Add(disp, ((path, *) => CopySpecific(path)).Bind(p))
        }
        m.Add(Tr("Recenti (History)"), mRec)
    }
    
    m.Add() ; Separatore
    m.Add(Tr("⚙️ Impostazioni..."), ShowSettings)
    
    RemoveEventHook()
    m.Show()
    InitEventHook()
}

CopySpecific(textToCopy, skipHistory := false) {
    A_Clipboard := textToCopy
    if (!skipHistory)
        AddToHistory(textToCopy)
    FinishCopy()
}

FinishCopy() {
    Global MascotPic, SettingWidth, SettingPlaySound, SettingAutoHide
    if (SettingPlaySound)
        try SoundPlay(A_WinDir "\Media\Windows Navigation Start.wav")
        
    if (MascotPic)
        MascotPic.Value := "*w" SettingWidth " *h-1 " ImgConferma
    ToolTip("  ✓ Copiato!  ")
    SetTimer(() => ToolTip(), -1500)
    
    if (SettingAutoHide)
        SetTimer(CloseMascot, -1500)
    else
        SetTimer(() => (MascotPic ? MascotPic.Value := "*w" SettingWidth " *h-1 " ImgAttesa : 0), -1500)
}

AddToHistory(pathToAdd) {
    Global RecentPaths
    if (pathToAdd = "")
        return
    for i, p in RecentPaths {
        if (p = pathToAdd) {
            RecentPaths.RemoveAt(i)
            break
        }
    }
    RecentPaths.InsertAt(1, pathToAdd)
    if (RecentPaths.Length > 5)
        RecentPaths.Pop()
}

CopyFileContent(path) {
    try {
        if (FileGetSize(path) > 1048576) {
            MsgBox("Il file è troppo grande per essere copiato negli appunti (> 1MB).", "FoxPath", "Icon!")
            return
        }
        text := FileRead(path)
        CopySpecific(text, true)
    } catch {
        MsgBox("Impossibile leggere il file.", "FoxPath", "IconX")
    }
}

OpenInVSCode(path) {
    try {
        Run('code "' path '"')
    } catch {
        pathsToTry := [
            EnvGet("LOCALAPPDATA") "\Programs\Microsoft VS Code\Code.exe",
            EnvGet("ProgramFiles") "\Microsoft VS Code\Code.exe",
            EnvGet("ProgramFiles(x86)") "\Microsoft VS Code\Code.exe"
        ]
        success := false
        for p in pathsToTry {
            if FileExist(p) {
                try Run('"' p '" "' path '"')
                success := true
                break
            }
        }
        if (!success)
            MsgBox("VS Code non trovato o non registrato nel PATH di sistema.`n`nAssicurati di averlo installato.", "FoxPath", "IconX")
    }
}

; Permette di copiare i file fisici negli Appunti di Windows usando la memoria di sistema HDROP
CopyAsFiles(pathList) {
    paths := StrSplit(pathList, "`r`n")
    
    ; CF_HDROP = 15. Calcolo buffer: Struttura DROPFILES (20 byte) + lunghezze stringhe + doppi null finali
    size := 20
    for p in paths
        size += (StrLen(p) + 1) * 2
    size += 2 
    
    hGlobal := DllCall("GlobalAlloc", "UInt", 0x42, "UPtr", size, "Ptr") ; GMEM_MOVEABLE=2 | GMEM_ZEROINIT=0x40
    if (!hGlobal)
        return
        
    pDrop := DllCall("GlobalLock", "Ptr", hGlobal, "Ptr")
    NumPut("UInt", 20, pDrop, 0) ; pFiles = inizio struttura stringhe
    NumPut("UInt", 1, pDrop, 16) ; fWide = 1 (Unicode/UTF-16)
    
    offset := 20
    for p in paths {
        StrPut(p, pDrop + offset, "UTF-16")
        offset += (StrLen(p) + 1) * 2
    }
    DllCall("GlobalUnlock", "Ptr", hGlobal)
    
    if DllCall("OpenClipboard", "Ptr", 0) {
        DllCall("EmptyClipboard")
        DllCall("SetClipboardData", "UInt", 15, "Ptr", hGlobal) ; 15 è il formato di Windows per Incolla File
        DllCall("CloseClipboard")
        
        AddToHistory(pathList)
        FinishCopy()
    } else {
        DllCall("GlobalFree", "Ptr", hGlobal)
    }
}

; ─────────────────────────────────────────────
;  Nuove Funzioni Avanzate
; ─────────────────────────────────────────────

TouchAction(path) {
    try {
        FileSetTime(A_Now, path, "M")
        ToolTip("  ✓ Data di modifica aggiornata!  ")
        SetTimer(() => ToolTip(), -2000)
    } catch {
        MsgBox("Impossibile aggiornare la data di modifica.", "Errore", "IconX")
    }
}

CalculateChecksumAction(path, algo := "") {
    if (algo == "") {
        algoGui := MsgBox("Scegli l'algoritmo:`nSì = SHA-256`nNo = MD5", "Calcolo Hash", "YesNoCancel Icon? 0x40000")
        if (algoGui == "Cancel")
            return
        algo := algoGui == "Yes" ? "SHA256" : "MD5"
    }
    try {
        tmpFile := A_Temp "\foxpath_hash.txt"
        RunWait(A_ComSpec ' /c certutil -hashfile "' path '" ' algo ' > "' tmpFile '"', , "Hide")
        if FileExist(tmpFile) {
            output := FileRead(tmpFile)
            FileDelete(tmpFile)
            lines := StrSplit(output, "`n", "`r")
            if (lines.Length >= 2) {
                hash := RegExReplace(lines[2], "\s+", "")
                if (hash != "") {
                    CopySpecific(hash, true)
                    return
                }
            }
        }
        MsgBox("Impossibile calcolare il checksum.", "Errore", "IconX 0x40000")
    } catch {
        MsgBox("Errore nell'esecuzione del calcolo.", "Errore", "IconX 0x40000")
    }
}

CopyBase64Action(path) {
    b64 := ""
    try {
        if (FileGetSize(path) > 52428800) { ; Limite innalzato a 50MB
            MsgBox("Il file è troppo grande per la conversione in Base64 (> 50MB).", "FoxPath", "Icon! 0x40000")
            return
        }
        
        ToolTip("Calcolo Base64 in corso... attendi")
        file := FileOpen(path, "r")
        size := file.Length
        if (size > 0) {
            fileBuf := Buffer(size)
            file.RawRead(fileBuf, size)
            file.Close()

            ; CRYPT_STRING_BASE64 (0x1) | CRYPT_STRING_NOCRLF (0x40000000) = 0x40000001
            flags := 0x40000001
            reqSize := 0
            DllCall("Crypt32.dll\CryptBinaryToStringW", "Ptr", fileBuf, "UInt", size, "UInt", flags, "Ptr", 0, "UInt*", &reqSize)
            
            strBuf := Buffer(reqSize * 2, 0)
            DllCall("Crypt32.dll\CryptBinaryToStringW", "Ptr", fileBuf, "UInt", size, "UInt", flags, "Ptr", strBuf, "UInt*", &reqSize)
            b64 := StrGet(strBuf)
        }
    } catch as err {
        ToolTip()
        MsgBox("Impossibile leggere il file o calcolare il Base64:`n" err.Message, "Errore", "IconX 0x40000")
        return
    }
        
    ToolTip()
    if (b64 != "") {
        try {
            CopySpecific(b64, true)
        } catch as err {
            MsgBox("Impossibile copiare il risultato negli Appunti:`n" err.Message, "Errore Appunti", "IconX 0x40000")
        }
    }
}

; ─────────────────────────────────────────────
;  Nuove Funzioni Avanzate Sviluppo & PowerUser
; ─────────────────────────────────────────────

SecureShredAction(path) {
    res := MsgBox("ATTENZIONE: Stai per distruggere fisicamente questo file.`nSarà sovrascritto con zeri e NON potrà essere recuperato in alcun modo.`n`nSei assolutamente sicuro di voler procedere?", "Distruzione Sicura", "YesNo Icon! Default2")
    if (res != "Yes")
        return
        
    try {
        f := FileOpen(path, "rw")
        size := f.Length
        f.Pos := 0
        zeros := Buffer(4096, 0)
        written := 0
        while (written < size) {
            toWrite := Min(4096, size - written)
            f.RawWrite(zeros, toWrite)
            written += toWrite
        }
        f.Close()
        FileDelete(path)
        
        Global SelectedPath := ""
        RefreshDisplay()
        MsgBox("File distrutto in modo sicuro.", "Shredder", "Iconi")
    } catch as err {
        MsgBox("Impossibile distruggere il file:`n" err.Message, "Errore", "IconX")
    }
}

PasteBase64Action(dirPath) {
    b64 := A_Clipboard
    if (b64 = "") {
        MsgBox("Gli appunti sono vuoti.", "FoxPath", "Icon! 0x40000")
        return
    }
    
    ; Rimuove eventuali intestazioni URI web (es. data:image/png;base64,)
    b64 := RegExReplace(b64, "i)^data:.*?;base64,")
    ; Rimuove qualsiasi spazio, tab o ritorno a capo che potrebbe rompere la decodifica
    b64 := RegExReplace(b64, "\s+")
    
    ib := InputBox("Inserisci il nome del file da creare (con estensione):", "Decodifica Base64 in File", "w350 h130", "decodificato.bin")
    if (ib.Result != "OK" || ib.Value = "")
        return
        
    outPath := RTrim(dirPath, "\") "\" ib.Value
    if FileExist(outPath) {
        if (MsgBox("Il file esiste già. Vuoi sovrascriverlo?", "Attenzione", "YesNo Icon!") != "Yes")
            return
    }
    
    try {
        flags := 0x00000001 ; CRYPT_STRING_BASE64
        reqSize := 0
        DllCall("Crypt32.dll\CryptStringToBinaryW", "Ptr", StrPtr(b64), "UInt", StrLen(b64), "UInt", flags, "Ptr", 0, "UInt*", &reqSize, "Ptr", 0, "Ptr", 0)
        if (reqSize > 0) {
            buf := Buffer(reqSize, 0)
            DllCall("Crypt32.dll\CryptStringToBinaryW", "Ptr", StrPtr(b64), "UInt", StrLen(b64), "UInt", flags, "Ptr", buf, "UInt*", &reqSize, "Ptr", 0, "Ptr", 0)
            
            try {
                f := FileOpen(outPath, "w")
                f.RawWrite(buf, reqSize)
                f.Close()
                ToolTip("  ✓ File Base64 creato!  ")
                SetTimer(() => ToolTip(), -2000)
            } catch {
                MsgBox("Accesso Negato (5).`n`nNon hai i permessi per scrivere in questa cartella (es. Disco C:\ o Programmi).`nScegli un'altra cartella (come Desktop o Documenti) oppure avvia FoxPath come Amministratore.", "FoxPath - Accesso Negato", "IconX")
            }
        } else {
            MsgBox("Il testo negli appunti non è un formato Base64 valido.", "Errore Decodifica", "IconX")
        }
    } catch as err {
        MsgBox("Errore durante la decodifica o scrittura:`n" err.Message, "Errore", "IconX")
    }
}

RunWithArgsAction(path) {
    ib := InputBox("Inserisci gli argomenti da passare all'eseguibile:", "Esegui con Parametri", "w350 h130")
    if (ib.Result != "OK")
        return
        
    try {
        Run('"' path '" ' ib.Value)
    } catch as err {
        MsgBox("Impossibile avviare il programma:`n" err.Message, "Errore", "IconX")
    }
}

BulkRenameAction(pathsText) {
    BRGui := Gui("+AlwaysOnTop +ToolWindow -MinimizeBox -MaximizeBox", "Rinomina Multipla")
    BRGui.MarginX := 15
    BRGui.MarginY := 15
    
    BRGui.Add("Text", "w250", "Seleziona la modalità:")
    ModeCtrl := BRGui.Add("DropDownList", "w250 Choose1", ["Aggiungi Prefisso / Suffisso", "Cerca e Sostituisci Testo"])
    
    BRGui.Add("Text", "w250 y+15", "Campo 1 (Prefisso o Testo da cercare):")
    F1Ctrl := BRGui.Add("Edit", "w250")
    
    BRGui.Add("Text", "w250 y+10", "Campo 2 (Suffisso o Testo da sostituire):")
    F2Ctrl := BRGui.Add("Edit", "w250")
    
    Btn := BRGui.Add("Button", "w250 Default y+20 h35", "Applica Rinomina in Blocco")
    Btn.OnEvent("Click", (*) => PerformBulkRename(BRGui, pathsText, ModeCtrl.Text, F1Ctrl.Value, F2Ctrl.Value))
    
    BRGui.Show("AutoSize Center")
}

PerformBulkRename(GuiObj, pathsText, mode, f1, f2) {
    GuiObj.Destroy()
    paths := StrSplit(pathsText, "`r`n")
    count := 0
    
    for p in paths {
        SplitPath(p, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt)
        
        if (mode = "Cerca e Sostituisci Testo") {
            if (f1 = "")
                continue
            newName := StrReplace(OutNameNoExt, f1, f2)
        } else {
            newName := f1 . OutNameNoExt . f2
        }
        
        if (newName == OutNameNoExt)
            continue
            
        newFullName := OutDir "\" newName
        if (OutExtension != "")
            newFullName .= "." OutExtension
        
        if (!FileExist(newFullName)) {
            try {
                if InStr(FileExist(p), "D")
                    DirMove(p, newFullName)
                else
                    FileMove(p, newFullName)
                count++
            }
        }
    }
    
    if (count > 0) {
        ToolTip("  ✓ " count " elementi rinominati!  ")
        SetTimer(() => ToolTip(), -2500)
        Global SelectedPath := ""
        RefreshDisplay()
    } else {
        MsgBox("Nessun file rinominato. Controlla i parametri.", "Rinomina Multipla", "Iconi")
    }
}

; ─────────────────────────────────────────────
;  Nuove Funzioni Avanzate "Ultra-Pro"
; ─────────────────────────────────────────────

ShowAttributesEditor(path) {
    if (!FileExist(path)) {
        MsgBox("Il file o la cartella non è più disponibile.", "FoxPath", "Icon!")
        return
    }
    SplitPath(path, &fileName)
    attr := FileExist(path)
    cTime := FileGetTime(path, "C")
    mTime := FileGetTime(path, "M")
    aTime := FileGetTime(path, "A")
    
    guiAttr := Gui("+AlwaysOnTop +ToolWindow -MinimizeBox -MaximizeBox", "Attributi: " fileName)
    guiAttr.MarginX := 15, guiAttr.MarginY := 15
    
    guiAttr.SetFont("bold")
    guiAttr.Add("Text", "w250", "Attributi:")
    guiAttr.SetFont("norm")
    cbRO := guiAttr.Add("CheckBox", "w80 x15 y+5 " (InStr(attr, "R") ? "Checked" : ""), "Sola Lettura")
    cbH := guiAttr.Add("CheckBox", "w80 x+5 " (InStr(attr, "H") ? "Checked" : ""), "Nascosto")
    cbS := guiAttr.Add("CheckBox", "w80 x+5 " (InStr(attr, "S") ? "Checked" : ""), "Sistema")
    
    guiAttr.SetFont("bold")
    guiAttr.Add("Text", "w250 x15 y+15", "Date di Sistema (Time Stomping):")
    guiAttr.SetFont("norm")
    guiAttr.Add("Text", "w250 y+5", "Creazione:")
    dtC := guiAttr.Add("DateTime", "w250 Choose" cTime, "dd/MM/yyyy HH:mm:ss")
    guiAttr.Add("Text", "w250 y+5", "Ultima Modifica:")
    dtM := guiAttr.Add("DateTime", "w250 Choose" mTime, "dd/MM/yyyy HH:mm:ss")
    guiAttr.Add("Text", "w250 y+5", "Ultimo Accesso:")
    dtA := guiAttr.Add("DateTime", "w250 Choose" aTime, "dd/MM/yyyy HH:mm:ss")
    
    btn := guiAttr.Add("Button", "w250 Default y+20 h35", "Salva Modifiche")
    btn.OnEvent("Click", (*) => ApplyAttributes(guiAttr, path, cbRO.Value, cbH.Value, cbS.Value, dtC.Value, dtM.Value, dtA.Value))
    guiAttr.Show("AutoSize Center")
}

ApplyAttributes(guiObj, path, ro, h, s, cTime, mTime, aTime) {
    guiObj.Destroy()
    try {
        newAttr := (ro ? "+R " : "-R ") . (h ? "+H " : "-H ") . (s ? "+S" : "-S")
        FileSetAttrib(newAttr, path)
        FileSetTime(cTime, path, "C")
        FileSetTime(mTime, path, "M")
        FileSetTime(aTime, path, "A")
        ToolTip("  ✓ Attributi e Date aggiornati!  ")
        SetTimer(() => ToolTip(), -2000)
    } catch as err {
        MsgBox("Errore durante l'aggiornamento:`n" err.Message, "FoxPath", "IconX")
    }
}

CopyMetadataAction(path) {
    try {
        SplitPath(path, &fileName, &dir)
        shell := ComObject("Shell.Application")
        folder := shell.NameSpace(dir)
        item := folder.ParseName(fileName)
        nullVal := ComValue(0, 0)
        
        json := "{`r`n"
        count := 0
        loop 320 {
            propName := folder.GetDetailsOf(nullVal, A_Index - 1)
            propVal := folder.GetDetailsOf(item, A_Index - 1)
            if (propName != "" && propVal != "") {
                cleanName := StrReplace(StrReplace(propName, '\', '\\'), '"', '\"')
                cleanVal := StrReplace(StrReplace(propVal, '\', '\\'), '"', '\"')
                json .= '  "' cleanName '": "' cleanVal '",`r`n'
                count++
            }
        }
        json := RTrim(json, ",`r`n") . "`r`n}"
        
        if (count > 0)
            CopySpecific(json, true)
        else
            MsgBox("Nessun metadato avanzato trovato.", "FoxPath", "Iconi")
    } catch {
        MsgBox("Impossibile leggere i metadati. File protetto o non supportato.", "Errore", "IconX")
    }
}

ExtractStringsAction(path) {
    try {
        if (FileGetSize(path) > 20971520) { ; Limite 20 MB per fluidità
            MsgBox("File troppo grande per l'estrazione rapida (>20MB).", "FoxPath", "Icon!")
            return
        }
        ToolTip("Estrazione stringhe in corso... attendi.")
        f := FileOpen(path, "r")
        rawSize := f.Length
        buf := Buffer(rawSize)
        f.RawRead(buf, rawSize)
        f.Close()
        
        extracted := ""
        currentStr := ""
        loop rawSize {
            b := NumGet(buf, A_Index - 1, "UChar")
            if (b >= 32 && b <= 126) {
                currentStr .= Chr(b)
            } else {
                if (StrLen(currentStr) >= 4)
                    extracted .= currentStr "`r`n"
                currentStr := ""
            }
        }
        if (StrLen(currentStr) >= 4)
            extracted .= currentStr "`r`n"
            
        ToolTip()
        if (extracted != "")
            CopySpecific(extracted, true)
        else
            MsgBox("Nessuna stringa leggibile trovata (solo codice macchina).", "FoxPath", "Iconi")
    } catch as err {
        ToolTip()
        MsgBox("Errore durante l'estrazione:`n" err.Message, "Errore", "IconX")
    }
}

FilePumperAction(path) {
    ib := InputBox("Quanti Megabyte (MB) di zeri vuoi aggiungere alla fine del file?", "File Pumper", "w350 h130", "5")
    if (ib.Result != "OK" || !IsNumber(ib.Value))
        return
        
    try {
        mb := Integer(ib.Value)
        f := FileOpen(path, "a") ; 'a' sta per Append (aggiunge alla fine)
        buf := Buffer(1048576, 0) ; Buffer di 1 MB pieno di zeri
        loop mb
            f.RawWrite(buf, 1048576)
        f.Close()
        ToolTip("  ✓ " mb " MB aggiunti al file!  ")
        SetTimer(() => ToolTip(), -2000)
    } catch {
        MsgBox("Errore durante la modifica (accesso negato?).", "Errore", "IconX")
    }
}

CreateDummyFileAction(dirPath) {
    ibName := InputBox("Nome del file Dummy da creare:", "Crea File Dummy", "w300 h130", "test_dummy.bin")
    if (ibName.Result != "OK" || ibName.Value = "")
        return
    ibSize := InputBox("Dimensioni in Megabyte (MB):", "Dimensioni", "w300 h130", "10")
    if (ibSize.Result != "OK" || !IsNumber(ibSize.Value))
        return
        
    outPath := RTrim(dirPath, "\") "\" ibName.Value
    try {
        mb := Integer(ibSize.Value)
        f := FileOpen(outPath, "w")
        buf := Buffer(1048576, 0)
        loop mb
            f.RawWrite(buf, 1048576)
        f.Close()
        ToolTip("  ✓ File Dummy creato!  ")
        SetTimer(() => ToolTip(), -2000)
    } catch {
        MsgBox("Impossibile creare il file Dummy.", "Errore", "IconX")
    }
}

PasteSymlinkAction(dirPath) {
    target := Trim(A_Clipboard, ' "`r`n')
    if (!FileExist(target)) {
        MsgBox("Gli appunti non contengono un percorso valido.`nCopia prima il file/cartella originale.", "FoxPath", "Icon!")
        return
    }
    
    SplitPath(target, &targetName)
    ib := InputBox("Nome del collegamento simbolico:", "Crea Symlink", "w350 h130", targetName)
    if (ib.Result != "OK" || ib.Value = "")
        return
        
    linkPath := RTrim(dirPath, "\") "\" ib.Value
    isDir := InStr(FileExist(target), "D")
    
    ; 1 = SYMBOLIC_LINK_FLAG_DIRECTORY | 2 = SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE (Windows 10+)
    flags := (isDir ? 1 : 0) | 2
    
    res := DllCall("CreateSymbolicLinkW", "Str", linkPath, "Str", target, "UInt", flags)
    if (res) {
        ToolTip("  ✓ Symlink creato!  ")
        SetTimer(() => ToolTip(), -2000)
    } else {
        MsgBox("Impossibile creare il Symlink (Errore " A_LastError ").`nPotrebbe essere necessario avviare FoxPath come Amministratore o attivare la Modalità Sviluppatore su Windows.", "Privilegi Insufficienti", "IconX")
    }
}

; ─────────────────────────────────────────────
;  Funzioni Editor & OCR Avanzate
; ─────────────────────────────────────────────

CopyOfficeContent(path, appType, keepFormat := true) {
    try {
        ToolTip("Apertura di Microsoft Office in background... attendi")
        app := ComObject(appType)
        app.Visible := false
        if (appType = "Word.Application") {
            doc := app.Documents.Open(path, false, true) ; Apre in Sola Lettura per sicurezza
            doc.Content.Copy()
            doc.Close(0) ; wdDoNotSaveChanges (0)
        } else if (appType = "Excel.Application") {
            wb := app.Workbooks.Open(path, 0, true)
            wb.Sheets(1).UsedRange.Copy()
            wb.Close(0)
        }
        app.Quit()
        if (!keepFormat) {
            A_Clipboard := A_Clipboard ; AHK rimuove nativamente tutta la formattazione e la converte in testo puro
        }
        ToolTip("  ✓ Contenuto formattato copiato con successo!  ")
        SetTimer(() => ToolTip(), -2500)
    } catch as err {
        ToolTip()
        MsgBox("Impossibile copiare il contenuto.`nAssicurati che Microsoft Office sia installato e il file non sia già aperto o corrotto.`n`nErrore: " err.Message, "FoxPath - Errore Office", "IconX")
    }
}

ExtractOcrText(path) {
    ToolTip("Scansione testo (OCR) in corso... attendi")
    
    psCode := "param($ImagePath)`n"
            . "Add-Type -AssemblyName System.Runtime.WindowsRuntime`n"
            . "try { [Windows.Storage.StorageFile,Windows.Storage,ContentType=WindowsRuntime] | Out-Null } catch {}`n"
            . "try { [Windows.Graphics.Imaging.BitmapDecoder,Windows.Graphics,ContentType=WindowsRuntime] | Out-Null } catch {}`n"
            . "try { [Windows.Media.Ocr.OcrEngine,Windows.Foundation.UniversalApiContract,ContentType=WindowsRuntime] | Out-Null } catch {}`n"
            . "try { [Windows.Media.Ocr.OcrEngine,Windows.Media,ContentType=WindowsRuntime] | Out-Null } catch {}`n"
            . "$asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation``1' })[0]`n"
            . "Function Await($WinRtTask, $ResultType) { return $asTask.MakeGenericMethod($ResultType).Invoke($null, @($WinRtTask)).Result }`n"
            . "try {`n"
            . "    $file = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($ImagePath)) ([Windows.Storage.StorageFile])`n"
            . "    $stream = Await ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])`n"
            . "    $decoder = Await ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])`n"
            . "    $bmp = Await ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])`n"
            . "    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()`n"
            . "    if ($null -eq $engine) { throw `"OcrEngine non disponibile. Assicurati di avere un Language Pack installato su Windows.`" }`n"
            . "    $result = Await ($engine.RecognizeAsync($bmp)) ([Windows.Media.Ocr.OcrResult])`n"
            . "    $text = ($result.Lines | ForEach-Object { $_.Text }) -join `"`r`n`"`n"
            . "    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8`n"
            . "    Write-Output $text`n"
            . "} catch { Write-Output `"ERRORE: $($_.Exception.Message)`" }"
            
    psFile := A_Temp "\foxpath_ocr.ps1"
    if FileExist(psFile)
        FileDelete(psFile)
    FileAppend(psCode, psFile, "UTF-8")
    
    outFile := A_Temp "\foxpath_ocr_out.txt"
    RunWait(A_ComSpec ' /c powershell -NoProfile -ExecutionPolicy Bypass -File "' psFile '" "' path '" > "' outFile '"', , "Hide")
    
    ToolTip()
    
    if FileExist(outFile) {
        extracted := Trim(FileRead(outFile, "UTF-8"), "`r`n ")
        FileDelete(outFile)
        FileDelete(psFile)
        
        if (extracted = "") {
            MsgBox("Nessun testo trovato in questa immagine.", "FoxPath OCR", "Iconi")
            return
        }
        if (InStr(extracted, "ERRORE:")) {
            MsgBox("Errore interno durante l'esecuzione dell'OCR:`n`n" extracted, "FoxPath OCR", "IconX")
            return
        }
        ShowOcrResult(extracted)
    } else {
        MsgBox("Errore di sistema durante l'esecuzione dello script OCR.", "Errore", "IconX")
    }
}

; ─────────────────────────────────────────────
;  Esecuzione Azioni Dinamiche (Bottoni/Pannello)
; ─────────────────────────────────────────────

GetIconForAction(actionName) {
    iconMap := Map(
        "Copia Percorso Normale", "📋",
        "Copia come File Reali", "📁",
        "Copia tra Virgolette", "❝",
        "Copia come Link Markdown", "🔗",
        "Apri in VS Code", "💻",
        "Apri in PowerShell", "🖥️",
        "Rinomina Elemento", "✏️",
        "Formatta JSON", "✨",
        "Minifica JSON", "🗜️",
        "Copia Contenuto (Solo Testo)", "📝",
        "Copia Contenuto (Mantiene Formattazione)", "📝",
        "Estrai Testo (OCR)", "🔍",
        "Statistiche Testo", "📈",
        "Traduci in Google Translate", "🌐",
        "Converti in PNG", "🔄",
        "Converti in JPG", "🔄",
        "Converti in BMP", "🔄",
        "Estrai Palette Colori", "🎨",
        "Incolla Appunti Veloci", "📝",
        "Touch (Aggiorna Data)", "⏱️",
        "Distruzione Sicura", "🗑️",
        "Crea Collegamento", "🔗",
        "Super Zip (Unico)", "📦",
        "Super Zip (Separati)", "📦",
        "Svuota Cestino", "♻️"
    )
    return iconMap.Has(actionName) ? iconMap[actionName] : "⚡"
}

ExecuteAction(actionName) {
    Global SelectedPath
    if (actionName = "Svuota Cestino") {
        EmptyRecycleBinAction()
        return
    }
    
    if (SelectedPath = "")
        return
        
    SplitPath(SelectedPath, &name, &dir, &ext)
    isMulti := InStr(SelectedPath, "`r`n")
    isDir := InStr(FileExist(SelectedPath), "D")
    ext := StrLower(ext)
    
    if (actionName = "Copia Percorso Normale") {
        CopySpecific(SelectedPath)
    } else if (actionName = "Copia come File Reali") {
        CopyAsFiles(SelectedPath)
    } else if (actionName = "Copia tra Virgolette") {
        quotesPath := ""
        for p in StrSplit(SelectedPath, "`r`n")
            quotesPath .= '"' p '"`r`n'
        CopySpecific(RTrim(quotesPath, "`r`n"))
    } else if (actionName = "Copia come Link Markdown") {
        if (!isMulti)
            CopyMarkdownLink(SelectedPath)
    } else if (actionName = "Apri in VS Code") {
        OpenInVSCode(SelectedPath)
    } else if (actionName = "Apri in PowerShell") {
        if (isMulti)
            SplitPath(StrSplit(SelectedPath, "`r`n")[1], , &dir)
        Run("powershell.exe -NoExit -Command cd '" dir "'")
    } else if (actionName = "Rinomina Elemento") {
        isMulti ? BulkRenameAction(SelectedPath) : RenameFileAction()
    } else if (actionName = "Copia Contenuto (Solo Testo)") {
        if (!isMulti) {
            if (ext ~= "i)^(docx|doc|rtf|xlsx|xls)$")
                CopyOfficeContent(SelectedPath, (ext ~= "i)^(xlsx|xls)$" ? "Excel.Application" : "Word.Application"), false)
            else
                CopyFileContent(SelectedPath)
        }
    } else if (actionName = "Copia Contenuto (Mantiene Formattazione)") {
        if (!isMulti && ext ~= "i)^(docx|doc|rtf|xlsx|xls)$")
            CopyOfficeContent(SelectedPath, (ext ~= "i)^(xlsx|xls)$" ? "Excel.Application" : "Word.Application"), true)
    } else if (actionName = "Formatta JSON") {
        if (!isMulti && ext = "json")
            FormatJsonAction(SelectedPath, false)
    } else if (actionName = "Minifica JSON") {
        if (!isMulti && ext = "json")
            FormatJsonAction(SelectedPath, true)
    } else if (actionName = "Statistiche Testo") {
        if (!isMulti)
            TextStatsAction(SelectedPath)
    } else if (actionName = "Traduci in Google Translate") {
        if (!isMulti)
            TranslateTextAction(SelectedPath)
    } else if (actionName = "Converti in PNG") {
        if (!isMulti)
            ConvertImageAction(SelectedPath, "png")
    } else if (actionName = "Converti in JPG") {
        if (!isMulti)
            ConvertImageAction(SelectedPath, "jpg")
    } else if (actionName = "Converti in BMP") {
        if (!isMulti)
            ConvertImageAction(SelectedPath, "bmp")
    } else if (actionName = "Estrai Palette Colori") {
        if (!isMulti)
            ExtractPaletteAction(SelectedPath)
    } else if (actionName = "Incolla Appunti Veloci") {
        if (isDir)
            QuickNotesAction(SelectedPath)
    } else if (actionName = "Touch (Aggiorna Data)") {
        TouchAction(SelectedPath)
    } else if (actionName = "Distruzione Sicura") {
        if (!isMulti && !isDir)
            SecureShredAction(SelectedPath)
    } else if (actionName = "Crea Collegamento") {
        CreateShortcutAction(SelectedPath)
    } else if (actionName = "Super Zip (Unico)") {
        SuperZipAction(SelectedPath, "single")
    } else if (actionName = "Super Zip (Separati)") {
        SuperZipAction(SelectedPath, "individual")
    }
}

ShowOcrResult(text) {
    ocrGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Risultato OCR - FoxPath")
    ocrGui.MarginX := 15, ocrGui.MarginY := 15
    ocrGui.SetFont("s10", "Segoe UI")
    ocrGui.Add("Text", "w500", "Ecco il testo estratto dall'immagine.`nPuoi modificarlo, oppure selezionare e copiare solo le parti che ti servono:")
    
    ed := ocrGui.Add("Edit", "w500 h280 Multi vOcrText", text)
    
    btn := ocrGui.Add("Button", "w500 h40 Default y+15", "Copia Tutto negli Appunti e Chiudi")
    btn.OnEvent("Click", (*) => (CopySpecific(ed.Value, true), ocrGui.Destroy()))
    
    ocrGui.Show("AutoSize Center")
}

; ─────────────────────────────────────────────
;  Nuove Funzioni Editoriali e Utility
; ─────────────────────────────────────────────

TextStatsAction(path) {
    try {
        txt := FileRead(path)
        chars := StrLen(txt)
        txtNoSp := RegExReplace(txt, "\s", "")
        charsNoSp := StrLen(txtNoSp)
        lines := StrSplit(txt, "`n", "`r").Length
        RegExReplace(txt, "\b\w+\b", "", &words)
        readTime := Max(1, Round(words / 200))
        MsgBox("Statistiche per:`n" path "`n`nParole: " words "`nCaratteri (con spazi): " chars "`nCaratteri (senza spazi): " charsNoSp "`nLinee: " lines "`nTempo di lettura stimato: ~" readTime " min", "Statistiche Testo", "Iconi")
    } catch {
        MsgBox("Errore nella lettura del file.", "FoxPath", "IconX")
    }
}

CopyMarkdownLink(path) {
    SplitPath(path, &name)
    uri := "file:///" StrReplace(StrReplace(path, "\", "/"), " ", "%20")
    CopySpecific("" name "")
}

TranslateTextAction(path) {
    try {
        txt := FileRead(path)
        if (StrLen(txt) > 2000)
            txt := SubStr(txt, 1, 2000)
        url := "https://translate.google.com/?sl=auto&tl=it&text=" UriEncode(txt) "&op=translate"
        Run(url)
    } catch {
        MsgBox("Impossibile leggere o tradurre il file.", "FoxPath", "IconX")
    }
}

UriEncode(Uri) {
    buf := Buffer(StrPut(Uri, "UTF-8"))
    StrPut(Uri, buf, "UTF-8")
    Res := ""
    Loop buf.Size - 1 {
        Code := NumGet(buf, A_Index - 1, "UChar")
        If (!Code)
            Break
        If (Code >= 0x30 && Code <= 0x39 || Code >= 0x41 && Code <= 0x5A || Code >= 0x61 && Code <= 0x7A)
            Res .= Chr(Code)
        Else
            Res .= Format("%{:02X}", Code)
    }
    Return Res
}

GitPullAction(dir) {
    RunWait(A_ComSpec " /c cd `"" dir "`" && git pull", , "Hide")
    ToolTip("  ✓ Git Pull completato  ")
    SetTimer(()=>ToolTip(), -2000)
}

; ─────────────────────────────────────────────
;  Nuovi Strumenti Avanzati (Dev, Data, Grafica)
; ─────────────────────────────────────────────

DataPreviewAction(path) {
    try {
        f := FileOpen(path, "r", "UTF-8")
        preview := ""
        loop 15 {
            if (f.AtEOF)
                break
            preview .= f.ReadLine()
        }
        f.Close()
        
        SplitPath(path, &fileName)
        prevGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Anteprima Dati: " fileName)
        prevGui.MarginX := 15, prevGui.MarginY := 15
        prevGui.Add("Text", "w600", "Prime 15 righe del file (utile per grandi dataset):")
        prevGui.Add("Edit", "w600 h250 ReadOnly", preview)
        prevGui.Show("AutoSize Center")
    } catch {
        MsgBox("Impossibile leggere il file per l'anteprima.", "Errore", "IconX")
    }
}

CsvToJsonAction(path) {
    SplitPath(path, , &dir, , &nameNoExt)
    outPath := dir "\" nameNoExt ".json"
    safePath := StrReplace(path, "'", "''")
    safeOutPath := StrReplace(outPath, "'", "''")
    psCode := "Import-Csv '" safePath "' | ConvertTo-Json -Depth 10 | Set-Content '" safeOutPath "' -Encoding UTF8"
    RunWait(A_ComSpec ' /c powershell -NoProfile -Command "' psCode '"', , "Hide")
    ToolTip("  ✓ CSV convertito in JSON!  ")
    SetTimer(()=>ToolTip(), -2000)
}

FastMergeAction(pathsText) {
    paths := StrSplit(pathsText, "`r`n")
    if (paths.Length < 2) {
        MsgBox("Seleziona almeno 2 file di testo o CSV per unirli.", "FoxPath", "Icon!")
        return
    }
    SplitPath(paths[1], , &dir)
    outPath := dir "\Merged_Output_" A_Now ".csv"
    
    try {
        fOut := FileOpen(outPath, "w", "UTF-8")
        isFirst := true
        for p in paths {
            fIn := FileOpen(p, "r", "UTF-8")
            line1 := fIn.ReadLine() 
            if (isFirst) {
                fOut.Write(line1)
                isFirst := false
            }
            while (!fIn.AtEOF) {
                fOut.Write(fIn.ReadLine())
            }
            fOut.Write("`r`n")
            fIn.Close()
        }
        fOut.Close()
        ToolTip("  ✓ " paths.Length " file uniti con successo!  ")
        SetTimer(()=>ToolTip(), -2500)
    } catch as err {
        MsgBox("Errore durante l'unione dei file.`n" err.Message, "Errore", "IconX")
    }
}

OfficeToPdfAction(path, appType) {
    SplitPath(path, , &dir, , &nameNoExt)
    outPath := dir "\" nameNoExt ".pdf"
    
    try {
        ToolTip("Esportazione in PDF in background... attendi")
        app := ComObject(appType)
        app.Visible := false
        if (appType = "Word.Application") {
            doc := app.Documents.Open(path, false, true)
            doc.ExportAsFixedFormat(outPath, 17) ; 17 = wdExportFormatPDF
            doc.Close(0)
        } else if (appType = "Excel.Application") {
            wb := app.Workbooks.Open(path, 0, true)
            wb.ExportAsFixedFormat(0, outPath) ; 0 = xlTypePDF
            wb.Close(0)
        }
        app.Quit()
        ToolTip("  ✓ Esportato in PDF!  ")
        SetTimer(()=>ToolTip(), -2000)
    } catch as err {
        ToolTip()
        MsgBox("Impossibile esportare in PDF. Assicurati che il file non sia già aperto o corrotto.`nErrore: " err.Message, "Errore Office", "IconX")
    }
}

SvgExtractorAction(path) {
    try {
        txt := FileRead(path, "UTF-8")
        txt := RegExReplace(txt, "m)^\s*") ; Rimuove spazi vuoti a inizio riga
        txt := StrReplace(txt, "`r`n", " ")
        txt := StrReplace(txt, "`n", " ")
        CopySpecific(txt, true)
    } catch {
        MsgBox("Impossibile leggere il file SVG.", "Errore", "IconX")
    }
}

GenerateIcoAction(path) {
    SplitPath(path, , &dir, , &nameNoExt)
    outPath := dir "\" nameNoExt ".ico"
    
    ; 1. Inizializza GDI+ e Carica l'immagine originale
    DllCall("gdiplus\GdipCreateBitmapFromFile", "WStr", path, "Ptr*", &bmp := 0)
    if (!bmp) {
        MsgBox("Impossibile caricare l'immagine. File non supportato o corrotto.", "Errore", "IconX")
        return
    }
    
    DllCall("gdiplus\GdipGetImageWidth", "Ptr", bmp, "UInt*", &w:=0)
    DllCall("gdiplus\GdipGetImageHeight", "Ptr", bmp, "UInt*", &h:=0)
    
    ; 2. Calcola le dimensioni proporzionali (max 256x256) in un canvas quadrato
    maxDim := Max(w, h)
    canvasSize := maxDim > 256 ? 256 : maxDim
    drawW := w, drawH := h
    if (maxDim > 256) {
        drawW := Integer(w * (256 / maxDim))
        drawH := Integer(h * (256 / maxDim))
    }
    
    posX := (canvasSize - drawW) / 2
    posY := (canvasSize - drawH) / 2
    
    ; 3. Crea il canvas e ridimensiona mantenendo l'Alta Qualità e Trasparenza
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", canvasSize, "Int", canvasSize, "Int", 0, "Int", 0x26200A, "Ptr", 0, "Ptr*", &newBmp:=0) ; 0x26200A = 32bppARGB
    DllCall("gdiplus\GdipGetImageGraphicsContext", "Ptr", newBmp, "Ptr*", &G:=0)
    DllCall("gdiplus\GdipSetInterpolationMode", "Ptr", G, "Int", 7) ; HighQualityBicubic
    DllCall("gdiplus\GdipSetSmoothingMode", "Ptr", G, "Int", 2)     ; HighQuality
    DllCall("gdiplus\GdipDrawImageRectRect", "Ptr", G, "Ptr", bmp
        , "Float", posX, "Float", posY, "Float", drawW, "Float", drawH
        , "Float", 0, "Float", 0, "Float", w, "Float", h
        , "Int", 2, "Ptr", 0, "Ptr", 0, "Ptr", 0) ; 2 = UnitPixel
        
    DllCall("gdiplus\GdipDeleteGraphics", "Ptr", G)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", bmp)
    
    ; 4. Salva in Memoria temporanea (IStream) come PNG
    DllCall("ole32\CreateStreamOnHGlobal", "Ptr", 0, "Int", 1, "Ptr*", &pStream:=0)
    clsid := Buffer(16, 0)
    NumPut("UInt", 0x557CF406, clsid, 0), NumPut("UShort", 0x1A04, clsid, 4), NumPut("UShort", 0x11D3, clsid, 6)
    NumPut("UChar", 0x9A, clsid, 8), NumPut("UChar", 0x73, clsid, 9), NumPut("UChar", 0x00, clsid, 10)
    NumPut("UChar", 0x00, clsid, 11), NumPut("UChar", 0xF8, clsid, 12), NumPut("UChar", 0x1E, clsid, 13)
    NumPut("UChar", 0xF3, clsid, 14), NumPut("UChar", 0x2E, clsid, 15)
    
    DllCall("gdiplus\GdipSaveImageToStream", "Ptr", newBmp, "Ptr", pStream, "Ptr", clsid, "Ptr", 0)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", newBmp)
    
    ; 5. Recupera i dati PNG dalla memoria
    DllCall("ole32\GetHGlobalFromStream", "Ptr", pStream, "Ptr*", &hGlobal:=0)
    pData := DllCall("GlobalLock", "Ptr", hGlobal, "Ptr")
    pngSize := DllCall("GlobalSize", "Ptr", hGlobal, "UPtr")
    
    ; 6. Scrive fisicamente il file .ico (Struttura: ICO Header + Dati PNG)
    try {
        f := FileOpen(outPath, "w")
        f.WriteUShort(0), f.WriteUShort(1), f.WriteUShort(1) ; ICO Header
        f.WriteUChar(canvasSize == 256 ? 0 : canvasSize) ; W
        f.WriteUChar(canvasSize == 256 ? 0 : canvasSize) ; H
        f.WriteUChar(0), f.WriteUChar(0), f.WriteUShort(1), f.WriteUShort(32) ; Props
        f.WriteUInt(pngSize), f.WriteUInt(22) ; Image Size & Offset
        f.RawWrite(pData, pngSize)
        f.Close()
        
        ToolTip("  ✓ Icona generata con successo!  ")
        SetTimer(()=>ToolTip(), -2000)
    } catch {
        MsgBox("Errore salvataggio file .ico (Accesso negato?).", "Errore", "IconX")
    }
    
    DllCall("GlobalUnlock", "Ptr", hGlobal)
    ObjRelease(pStream)
}

ImageResizerAction(path) {
    DllCall("gdiplus\GdipCreateBitmapFromFile", "WStr", path, "Ptr*", &bmp := 0)
    if (!bmp)
        return
    DllCall("gdiplus\GdipGetImageWidth", "Ptr", bmp, "UInt*", &w:=0)
    DllCall("gdiplus\GdipGetImageHeight", "Ptr", bmp, "UInt*", &h:=0)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", bmp)
    
    ib := InputBox("Inserisci la nuova LARGHEZZA in pixel (l'altezza sarà proporzionale):`n`nDimensione attuale: " w "x" h, "Smart Resizer", "w300 h150", w)
    if (ib.Result != "OK" || !IsNumber(ib.Value))
        return
    
    newW := Integer(ib.Value)
    newH := Integer(h * (newW / w))
    SplitPath(path, , &dir, &ext, &nameNoExt)
    outPath := dir "\" nameNoExt "_resized." ext
    
    formatMap := Map("png", "Png", "jpg", "Jpeg", "jpeg", "Jpeg", "bmp", "Bmp", "gif", "Gif")
    fmt := formatMap.Has(StrLower(ext)) ? formatMap[StrLower(ext)] : "Png"
    
    safePath := StrReplace(path, "'", "''")
    safeOutPath := StrReplace(outPath, "'", "''")
    psCode := "Add-Type -AssemblyName System.Drawing; "
            . "$img = [System.Drawing.Image]::FromFile('" safePath "'); "
            . "$bmp = New-Object System.Drawing.Bitmap($img, " newW ", " newH "); "
            . "$bmp.Save('" safeOutPath "', [System.Drawing.Imaging.ImageFormat]::" fmt "); "
            . "$bmp.Dispose(); $img.Dispose();"
            
    RunWait(A_ComSpec ' /c powershell -NoProfile -Command "' psCode '"', , "Hide")
    if FileExist(outPath) {
        ToolTip("  ✓ Immagine ridimensionata!  ")
        SetTimer(()=>ToolTip(), -2000)
    }
}

JwtDecoderAction() {
    clip := Trim(A_Clipboard, " `t`r`n")
    parts := StrSplit(clip, ".")
    if (parts.Length < 2) {
        MsgBox("Il testo negli appunti non sembra un JWT valido.", "FoxPath", "Icon! 0x40000")
        return
    }
    
    psCode := "$jwt = '" StrReplace(clip, "'", "''") "'; "
            . "$parts = $jwt.Split('.'); "
            . "if ($parts.Length -lt 2) { exit 1 }; "
            . "$payload = $parts[1].Replace('-', '+').Replace('_', '/').Replace(' ', '').Replace([Environment]::NewLine, ''); "
            . "$pad = $payload.Length % 4; "
            . "if ($pad -ne 0) { $payload += '=' * (4 - $pad) }; "
            . "try { "
            . "  $bytes = [Convert]::FromBase64String($payload); "
            . "  $json = [System.Text.Encoding]::UTF8.GetString($bytes); "
            . "  $obj = $json | ConvertFrom-Json; "
            . "  $obj | ConvertTo-Json -Depth 10; "
            . "} catch { exit 2 }"
            
    outFile := A_Temp "\foxpath_jwt.txt"
    RunWait(A_ComSpec ' /c powershell -NoProfile -Command "' psCode '" > "' outFile '"', , "Hide")
    
    if FileExist(outFile) {
        finalJson := FileRead(outFile, "UTF-8")
        FileDelete(outFile)
        if (Trim(finalJson) != "") {
            CopySpecific(Trim(finalJson, "`r`n"), true)
            return
        }
    }
    MsgBox("Errore decodifica Payload JWT. Assicurati di aver copiato un token corretto.", "Errore", "IconX 0x40000")
}

UrlEncodeDecodeAction(path) {
    guiMode := MsgBox("Premi 'Sì' per Codificare (URL Encode), 'No' per Decodificare.", "URL Encode/Decode", "YesNoCancel Icon? 0x40000")
    if (guiMode = "Cancel")
        return
    
    safePath := StrReplace(path, "'", "''")
    psCode := guiMode = "Yes" 
        ? "$txt = Get-Content -Raw -Path '" safePath "'; [uri]::EscapeDataString($txt)"
        : "$txt = Get-Content -Raw -Path '" safePath "'; [uri]::UnescapeDataString($txt)"
        
    outFile := A_Temp "\foxpath_url_out.txt"
    RunWait(A_ComSpec ' /c powershell -NoProfile -Command "' psCode '" > "' outFile '"', , "Hide")
    if FileExist(outFile) {
        res := FileRead(outFile, "UTF-8")
        FileDelete(outFile)
        CopySpecific(RTrim(res, "`r`n "), true)
    }
}

RegexTesterAction(path) {
    guiRT := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "RegEx Tester Rapido")
    guiRT.MarginX := 15, guiRT.MarginY := 15
    guiRT.Add("Text", "w400", "Inserisci la Regular Expression:")
    edRe := guiRT.Add("Edit", "w400 vRegEx")
    guiRT.Add("Text", "w400 y+10", "Risultati (prime 50 corrispondenze):")
    edRes := guiRT.Add("Edit", "w400 h200 ReadOnly vRes")
    
    btn := guiRT.Add("Button", "w400 Default y+15", "Esegui RegEx sul File")
    btn.OnEvent("Click", (*) => _RunRegExTest(guiRT, edRe.Value, edRes, path))
    guiRT.Show("AutoSize Center")
}

_RunRegExTest(guiObj, regexPattern, resCtrl, path) {
    try {
        txt := FileRead(path)
        pos := 1, count := 0
        matches := ""
        while (pos := RegExMatch(txt, regexPattern, &m, pos)) {
            matches .= "Match " (count+1) ": " m[0] "`r`n"
            pos += StrLen(m[0]) > 0 ? StrLen(m[0]) : 1
            count++
            if (count >= 50) {
                matches .= "...e altre (mostrate solo le prime 50)."
                break
            }
        }
        resCtrl.Value := count > 0 ? matches : "Nessuna corrispondenza trovata."
    } catch as err {
        resCtrl.Value := "Errore di sintassi nella RegEx: " err.Message
    }
}

GitCommitAction(dir) {
    ib := InputBox("Inserisci il messaggio per il commit:", "Git Add & Commit", "w350 h130")
    if (ib.Result = "OK" && ib.Value != "") {
        RunWait(A_ComSpec " /c cd `"" dir "`" && git add . && git commit -m `"" ib.Value "`"", , "Hide")
        ToolTip("  ✓ Git Commit completato  ")
        SetTimer(()=>ToolTip(), -2000)
    }
}

CreateSnippetAction(dirPath) {
    snipGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Crea da Snippet")
    snipGui.MarginX := 15, snipGui.MarginY := 15
    snipGui.Add("Text", "w250", "Seleziona il tipo di file:")
    ddl := snipGui.Add("DropDownList", "w250 Choose1 vSnipType", ["HTML5 Boilerplate", ".gitignore (Node/JS)", "File Markdown vuoto"])
    btn := snipGui.Add("Button", "w250 Default y+15", "Crea File")
    btn.OnEvent("Click", (*) => (snipGui.Submit(), WriteSnippet(dirPath, ddl.Text), snipGui.Destroy()))
    snipGui.Show("AutoSize Center")
}

WriteSnippet(dir, type) {
    path := RTrim(dir, "\")
    if (type = "HTML5 Boilerplate") {
        path .= "\index.html"
        content := "<!DOCTYPE html>`n<html lang=`"en`">`n<head>`n<meta charset=`"UTF-8`">`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`n<title>Document</title>`n</head>`n<body>`n`n</body>`n</html>"
    } else if (type = ".gitignore (Node/JS)") {
        path .= "\.gitignore"
        content := "node_modules/`n.env`ndist/`nbuild/`n.DS_Store"
    } else {
        path .= "\README.md"
        content := "# Nuovo Progetto`n`nDescrizione qui."
    }
    try {
        FileAppend(content, path, "UTF-8")
        ToolTip("  ✓ File creato!  ")
        SetTimer(()=>ToolTip(), -2000)
    } catch {
        MsgBox("Errore creazione file", "Errore", "IconX")
    }
}

FormatJsonAction(path, minify := false) {
    try {
        safePath := StrReplace(path, "'", "''")
        psCode := minify ? "$j = Get-Content -Raw -Path '" safePath "' | ConvertFrom-Json; $j | ConvertTo-Json -Depth 100 -Compress | Set-Content -Path '" safePath "' -Encoding UTF8" : "$j = Get-Content -Raw -Path '" safePath "' | ConvertFrom-Json; $j | ConvertTo-Json -Depth 100 | Set-Content -Path '" safePath "' -Encoding UTF8"
        RunWait(A_ComSpec " /c powershell -NoProfile -Command `"" psCode "`"", , "Hide")
        ToolTip(minify ? "  ✓ JSON Minificato!  " : "  ✓ JSON Formattato!  ")
        SetTimer(()=>ToolTip(), -2000)
    } catch {
        MsgBox("Errore nell'esecuzione dello script.", "Errore", "IconX")
    }
}

ConvertImageAction(path, ext) {
    SplitPath(path, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt)
    outPath := OutDir "\" OutNameNoExt "." ext
    DllCall("gdiplus\GdipCreateBitmapFromFile", "WStr", path, "Ptr*", &bmp := 0)
    if (!bmp) {
        MsgBox("Errore caricamento immagine. File non supportato o corrotto.", "FoxPath", "IconX")
        return
    }
    clsid := Buffer(16, 0)
    if (ext = "png") {
        NumPut("UInt", 0x557CF406, clsid, 0), NumPut("UShort", 0x1A04, clsid, 4), NumPut("UShort", 0x11D3, clsid, 6), NumPut("UChar", 0x9A, clsid, 8), NumPut("UChar", 0x73, clsid, 9), NumPut("UChar", 0x00, clsid, 10), NumPut("UChar", 0x00, clsid, 11), NumPut("UChar", 0xF8, clsid, 12), NumPut("UChar", 0x1E, clsid, 13), NumPut("UChar", 0xF3, clsid, 14), NumPut("UChar", 0x2E, clsid, 15)
    } else if (ext = "jpg") {
        NumPut("UInt", 0x557CF401, clsid, 0), NumPut("UShort", 0x1A04, clsid, 4), NumPut("UShort", 0x11D3, clsid, 6), NumPut("UChar", 0x9A, clsid, 8), NumPut("UChar", 0x73, clsid, 9), NumPut("UChar", 0x00, clsid, 10), NumPut("UChar", 0x00, clsid, 11), NumPut("UChar", 0xF8, clsid, 12), NumPut("UChar", 0x1E, clsid, 13), NumPut("UChar", 0xF3, clsid, 14), NumPut("UChar", 0x2E, clsid, 15)
    } else if (ext = "bmp") {
        NumPut("UInt", 0x557CF400, clsid, 0), NumPut("UShort", 0x1A04, clsid, 4), NumPut("UShort", 0x11D3, clsid, 6), NumPut("UChar", 0x9A, clsid, 8), NumPut("UChar", 0x73, clsid, 9), NumPut("UChar", 0x00, clsid, 10), NumPut("UChar", 0x00, clsid, 11), NumPut("UChar", 0xF8, clsid, 12), NumPut("UChar", 0x1E, clsid, 13), NumPut("UChar", 0xF3, clsid, 14), NumPut("UChar", 0x2E, clsid, 15)
    }
    res := DllCall("gdiplus\GdipSaveImageToFile", "Ptr", bmp, "WStr", outPath, "Ptr", clsid, "Ptr", 0)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", bmp)
    if (res = 0) {
        ToolTip("  ✓ Convertito in " StrUpper(ext) "!  ")
        SetTimer(()=>ToolTip(), -2000)
    } else {
        MsgBox("Errore salvataggio immagine.", "FoxPath", "IconX")
    }
}

ExtractPaletteAction(path) {
    DllCall("gdiplus\GdipCreateBitmapFromFile", "WStr", path, "Ptr*", &bmp := 0)
    if (!bmp) {
        MsgBox("Impossibile caricare immagine.", "FoxPath", "IconX")
        return
    }
    DllCall("gdiplus\GdipGetImageWidth", "Ptr", bmp, "UInt*", &w:=0)
    DllCall("gdiplus\GdipGetImageHeight", "Ptr", bmp, "UInt*", &h:=0)
    coords := [[w//2, h//2], [w//4, h//4], [w*3//4, h//4], [w//4, h*3//4], [w*3//4, h*3//4]]
    paletteHex := []
    for c in coords {
        DllCall("gdiplus\GdipBitmapGetPixel", "Ptr", bmp, "Int", c[1], "Int", c[2], "UInt*", &argb:=0)
        hex := Format("#{:06X}", argb & 0xFFFFFF)
        isDup := false
        
        for hx in paletteHex {
            if (hx = hex) {
                isDup := true
                break
            }
        }
        if (!isDup)
            paletteHex.Push(hex)
    }
    DllCall("gdiplus\GdipDisposeImage", "Ptr", bmp)
    
    if (paletteHex.Length > 0)
        ShowPaletteGui(paletteHex)
}

ShowPaletteGui(hexArray) {
    palGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Palette Estratta")
    palGui.MarginX := 15, palGui.MarginY := 15
    palGui.SetFont("s10 bold", "Segoe UI")
    
    palGui.Add("Text", "w380", "Colori dominanti estratti dall'immagine:")
    
    for i, hex in hexArray {
        colorNoHash := StrReplace(hex, "#", "")
        palGui.Add("Progress", "w30 h30 xm y+10 Background" colorNoHash, 0)
        
        rgb := HexToRGB(hex)
        hsl := HexToHSL(hex)
        cmyk := HexToCMYK(hex)
        
        palGui.SetFont("s9 norm")
        txt := "HEX: " hex "   |   RGB: " rgb "`nHSL: " hsl "   |   CMYK: " cmyk
        palGui.Add("Text", "x+10 yp w340 h30 0x200", txt)
    }
    
    palGui.SetFont("s10 bold")
    palGui.Add("Text", "xm y+20 w380", "Copia palette negli Appunti come:")
    palGui.SetFont("s10 norm")
    ddl := palGui.Add("DropDownList", "xm y+5 w280 vFmt Choose1", ["HEX (#RRGGBB)", "RGB (R, G, B)", "HSL (H, S, L)", "CMYK (C, M, Y, K)"])
    btn := palGui.Add("Button", "x+10 yp-1 w90 h26 Default", "Copia")
    btn.OnEvent("Click", (*) => CopyPaletteFormat(palGui, hexArray, ddl.Text))
    
    palGui.Show("AutoSize Center")
}

HexToRGB(hex) {
    hex := StrReplace(hex, "#", "")
    r := Integer("0x" SubStr(hex, 1, 2))
    g := Integer("0x" SubStr(hex, 3, 2))
    b := Integer("0x" SubStr(hex, 5, 2))
    return r ", " g ", " b
}

HexToHSL(hex) {
    hex := StrReplace(hex, "#", "")
    r := Integer("0x" SubStr(hex, 1, 2)) / 255
    g := Integer("0x" SubStr(hex, 3, 2)) / 255
    b := Integer("0x" SubStr(hex, 5, 2)) / 255
    maxV := Max(r, g, b), minV := Min(r, g, b)
    l := (maxV + minV) / 2
    if (maxV = minV) {
        h := 0, s := 0
    } else {
        d := maxV - minV
        s := l > 0.5 ? d / (2 - maxV - minV) : d / (maxV + minV)
        if (maxV = r)
            h := (g - b) / d + (g < b ? 6 : 0)
        else if (maxV = g)
            h := (b - r) / d + 2
        else
            h := (r - g) / d + 4
        h /= 6
    }
    return Round(h * 360) "°, " Round(s * 100) "%, " Round(l * 100) "%"
}

HexToCMYK(hex) {
    hex := StrReplace(hex, "#", "")
    r := Integer("0x" SubStr(hex, 1, 2)) / 255
    g := Integer("0x" SubStr(hex, 3, 2)) / 255
    b := Integer("0x" SubStr(hex, 5, 2)) / 255
    k := 1 - Max(r, g, b)
    if (k = 1)
        return "0%, 0%, 0%, 100%"
    c := (1 - r - k) / (1 - k)
    m := (1 - g - k) / (1 - k)
    y := (1 - b - k) / (1 - k)
    return Round(c * 100) "%, " Round(m * 100) "%, " Round(y * 100) "%, " Round(k * 100) "%"
}

CopyPaletteFormat(guiObj, hexArray, format) {
    out := ""
    for hex in hexArray {
        if InStr(format, "HEX")
            out .= hex "`r`n"
        else if InStr(format, "RGB")
            out .= HexToRGB(hex) "`r`n"
        else if InStr(format, "HSL")
            out .= HexToHSL(hex) "`r`n"
        else if InStr(format, "CMYK")
            out .= HexToCMYK(hex) "`r`n"
    }
    guiObj.Destroy()
    CopySpecific(RTrim(out, "`r`n"), true)
}

CreateShortcutAction(pathsText) {
    destDir := DirSelect("", 3, "Seleziona la cartella di destinazione per i collegamenti:")
    if (destDir = "")
        return
        
    paths := StrSplit(pathsText, "`r`n")
    count := 0
    for p in paths {
        SplitPath(p, &name, &dir, &ext, &nameNoExt)
        lnkPath := RTrim(destDir, "\") "\" nameNoExt ".lnk"
        
        if FileExist(lnkPath) {
            lnkPath := RTrim(destDir, "\") "\" nameNoExt "_collegamento.lnk"
        }
        
        try {
            FileCreateShortcut(p, lnkPath)
            count++
        } catch {
        }
    }
    if (count > 0) {
        ToolTip("  ✓ " count " collegament" (count>1 ? "i creati" : "o creato") "!  ")
        SetTimer(()=>ToolTip(), -2000)
    } else {
        MsgBox("Errore durante la creazione del collegamento.", "FoxPath", "IconX")
    }
}

QuickNotesAction(dirPath) {
    clip := A_Clipboard
    if (clip = "") {
        MsgBox("Gli appunti sono vuoti!", "FoxPath", "Icon!")
        return
    }
    words := StrSplit(RegExReplace(clip, "[^\w\s]", ""), [" ", "`n", "`r"])
    name := ""
    for w in words {
        if (StrLen(w) > 2) {
            name .= w "_"
            if (StrLen(name) > 15)
                break
        }
    }
    name := RTrim(name, "_") 
    if (name = "")
        name := "Appunti"
        
    ib := InputBox("Nome del file per gli appunti:", "Appunti Veloci", "w300 h130", name ".txt")
    if (ib.Result = "OK" && ib.Value != "") {
        f := FileOpen(RTrim(dirPath, "\") "\" ib.Value, "w", "UTF-8")
        f.Write(clip)
        f.Close()
        ToolTip("  ✓ Appunti salvati!  ")
        SetTimer(()=>ToolTip(), -2000)
    }
}

SuperZipAction(pathsText, mode) {
    paths := StrSplit(pathsText, "`r`n")
    if (mode = "individual") {
        for p in paths {
            SplitPath(p, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt)
            zipFile := OutDir "\" OutNameNoExt ".zip"
            safePath := StrReplace(p, "'", "''")
            safeZip := StrReplace(zipFile, "'", "''")
            RunWait(A_ComSpec " /c powershell -NoProfile -Command `"Compress-Archive -Path '" safePath "' -DestinationPath '" safeZip "' -Force`"", , "Hide")
        }
        ToolTip("  ✓ File zippati singolarmente!  ")
    } else {
        SplitPath(paths[1], , &OutDir)
        zipFile := OutDir "\Archivio_FoxPath.zip"
        safeZip := StrReplace(zipFile, "'", "''")
        psFiles := ""
        for p in paths
            psFiles .= "'" StrReplace(p, "'", "''") "',"
        psFiles := RTrim(psFiles, ",")
        RunWait(A_ComSpec " /c powershell -NoProfile -Command `"Compress-Archive -Path " psFiles " -DestinationPath '" safeZip "' -Force`"", , "Hide")
        ToolTip("  ✓ Archivio unico creato!  ")
    }
    SetTimer(()=>ToolTip(), -2000)
}

EmptyRecycleBinAction() {
    DllCall("shell32\SHEmptyRecycleBinW", "Ptr", 0, "Ptr", 0, "UInt", 3)
    ToolTip("  ✓ Cestino svuotato!  ")
    SetTimer(()=>ToolTip(), -2000)
}