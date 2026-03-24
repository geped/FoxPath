; ==============================================================================
; FoxPath - Developer Tools Module (Fattibilità Alta)
; ==============================================================================

global DevLang := "IT" ; Imposta qui la lingua attuale (IT, EN, ES)

; --- DIZIONARIO MULTILINGUA ---
global DevT := Map(
    "IT", Map(
        "Title", "Strumenti Sviluppatore",
        "Cat_EncDec", "Codificatori / Decodificatori",
        "Cat_Generators", "Generatori Sicurezza",
        "Cat_Time", "Tempo e Date",
        "Cat_Text", "Testo e Sviluppo",
        "Cat_Graphics", "Grafica e Media",
        "Tool_Base64", "Testo Base64",
        "Tool_UUID", "Generatore UUID",
        "Tool_Hash", "Generatore Hash",
        "Tool_Password", "Generatore Password",
        "Tool_Timestamp", "Convertitore Timestamp",
        "Tool_Regex", "Tester Regex",
        "Tool_JsonYaml", "JSON ⇄ YAML",
        "Tool_Gzip", "Archiviatore Gzip",
        "Tool_Markdown", "Anteprima Markdown",
        "Tool_ImgCompress", "Comprimi Immagine",
        "Tool_ColorBlind", "Simulatore Daltonismo",
        "Lbl_WIP", "Funzionalità in fase di sviluppo (WIP).",
        "Btn_Generate", "Genera",
        "Btn_Copy", "Copia",
        "Btn_Encode", "Codifica",
        "Btn_Decode", "Decodifica",
        "Lbl_Input", "Testo di input:",
        "Lbl_Output", "Risultato:",
        "Lbl_Timestamp", "Unix Timestamp (Secondi UTC):",
        "Btn_ToDate", "Ts -> Data",
        "Lbl_Date", "Data (YYYYMMDDHHMISS):",
        "Btn_ToTs", "Data -> Ts",
        "Lbl_Length", "Lunghezza:",
        "Lbl_RegexPattern", "Pattern Regex:",
        "Lbl_RegexTest", "Testo da testare:",
        "Lbl_RegexMatch", "Risultato Match:",
        "Btn_TestMatch", "Test Match",
        "Btn_J2Y", "JSON -> YAML",
        "Btn_Y2J", "YAML -> JSON",
        "Lbl_FileToCompress", "File da comprimere:",
        "Btn_Browse", "Sfoglia",
        "Btn_CompressGz", "Comprimi in .tar.gz (tar nativo)",
        "Btn_RenderMd", "Renderizza Anteprima",
        "Lbl_SelectImg", "Seleziona Immagine (JPG/PNG/BMP):",
        "Lbl_JpgQuality", "Qualità JPG:",
        "Btn_CompressImg", "Comprimi e Salva (WIA)",
        "Lbl_ImgToSimulate", "Seleziona Immagine da simulare:",
        "Lbl_ColorblindType", "Tipo di Daltonismo:",
        "Btn_Simulate", "Genera Simulazione",
        "Opt_Protanopia", "Protanopia (Carenza Rosso)",
        "Opt_Deuteranopia", "Deuteranopia (Carenza Verde)",
        "Opt_Tritanopia", "Tritanopia (Carenza Blu)",
        "Opt_Achromatopsia", "Acromatopsia (Grigio)",
        "Msg_SelectValidFile", "Seleziona un file valido.",
        "Msg_Error", "Errore",
        "Msg_GzipSuccess", "Archivio compresso creato con successo in:`n",
        "Msg_GzipComplete", "Gzip Completato",
        "Msg_GzipError", "Errore durante la creazione dell'archivio Gzip.",
        "Msg_ComInitError", "Errore nell'inizializzazione del componente COM.",
        "Msg_Loading", "Caricamento in corso...",
        "Msg_NetError", "Errore: Connessione a Internet assente o libreria JS non caricata.",
        "Msg_SelectValidImg", "Seleziona un'immagine valida.",
        "Msg_SaveImgComp", "Salva Immagine Compressa",
        "Msg_ImgCompSuccess", "Immagine compressa e salvata con successo!",
        "Msg_Complete", "Completato",
        "Msg_ImgCompError", "Errore durante la compressione WIA:`n",
        "Msg_ImgLoadError", "Impossibile caricare l'immagine.",
        "Msg_SimSuccess", "Immagine simulata salvata in:`n",
        "Msg_MatchFound", "Match trovato in pos ",
        "Msg_NoMatch", "Nessun match.",
        "Msg_RegexError", "Errore di sintassi nel Pattern Regex."
    ),
    "EN", Map(
        "Title", "Developer Tools",
        "Cat_EncDec", "Encoders",
        "Cat_Generators", "Generators",
        "Cat_Time", "Time & Dates",
        "Cat_Text", "Text & Dev",
        "Cat_Graphics", "Graphics & Media",
        "Tool_Base64", "Base64 Text",
        "Tool_UUID", "UUID Generator",
        "Tool_Hash", "Hash Generator",
        "Tool_Password", "Password Generator",
        "Tool_Timestamp", "Timestamp Converter",
        "Tool_Regex", "Regex Tester",
        "Tool_JsonYaml", "JSON ⇄ YAML",
        "Tool_Gzip", "Gzip Archiver",
        "Tool_Markdown", "Markdown Preview",
        "Tool_ImgCompress", "Image Compressor",
        "Tool_ColorBlind", "Colorblind Simulator",
        "Lbl_WIP", "Work In Progress (WIP).",
        "Btn_Generate", "Generate",
        "Btn_Copy", "Copy",
        "Btn_Encode", "Encode",
        "Btn_Decode", "Decode",
        "Lbl_Input", "Input text:",
        "Lbl_Output", "Result:",
        "Lbl_Timestamp", "Unix Timestamp (Seconds):",
        "Btn_ToDate", "Ts -> Date",
        "Lbl_Date", "Date (YYYYMMDDHHMISS):",
        "Btn_ToTs", "Date -> Ts",
        "Lbl_Length", "Length:",
        "Lbl_RegexPattern", "Regex Pattern:",
        "Lbl_RegexTest", "Text to test:",
        "Lbl_RegexMatch", "Match Result:",
        "Btn_TestMatch", "Test Match",
        "Btn_J2Y", "JSON -> YAML",
        "Btn_Y2J", "YAML -> JSON",
        "Lbl_FileToCompress", "File to compress:",
        "Btn_Browse", "Browse",
        "Btn_CompressGz", "Compress to .tar.gz (native tar)",
        "Btn_RenderMd", "Render Preview",
        "Lbl_SelectImg", "Select Image (JPG/PNG/BMP):",
        "Lbl_JpgQuality", "JPG Quality:",
        "Btn_CompressImg", "Compress and Save (WIA)",
        "Lbl_ImgToSimulate", "Select Image to simulate:",
        "Lbl_ColorblindType", "Colorblind Type:",
        "Btn_Simulate", "Generate Simulation",
        "Opt_Protanopia", "Protanopia (Red-Blind)",
        "Opt_Deuteranopia", "Deuteranopia (Green-Blind)",
        "Opt_Tritanopia", "Tritanopia (Blue-Blind)",
        "Opt_Achromatopsia", "Achromatopsia (Monochromacy)",
        "Msg_SelectValidFile", "Please select a valid file.",
        "Msg_Error", "Error",
        "Msg_GzipSuccess", "Archive successfully compressed to:`n",
        "Msg_GzipComplete", "Gzip Complete",
        "Msg_GzipError", "Error during Gzip archive creation.",
        "Msg_ComInitError", "Error initializing COM component.",
        "Msg_Loading", "Loading...",
        "Msg_NetError", "Error: No Internet connection or JS library not loaded.",
        "Msg_SelectValidImg", "Please select a valid image.",
        "Msg_SaveImgComp", "Save Compressed Image",
        "Msg_ImgCompSuccess", "Image successfully compressed and saved!",
        "Msg_Complete", "Completed",
        "Msg_ImgCompError", "Error during WIA compression:`n",
        "Msg_ImgLoadError", "Unable to load the image.",
        "Msg_SimSuccess", "Simulated image saved to:`n",
        "Msg_MatchFound", "Match found at pos ",
        "Msg_NoMatch", "No match.",
        "Msg_RegexError", "Syntax error in Regex Pattern."
    ),
    "ES", Map(
        "Title", "Herramientas de Desarrollador",
        "Cat_EncDec", "Codificadores",
        "Cat_Generators", "Generadores",
        "Cat_Time", "Tiempo y Fechas",
        "Cat_Text", "Herramientas de Texto",
        "Cat_Graphics", "Gráficos y Medios",
        "Tool_Base64", "Texto Base64",
        "Tool_UUID", "Generador UUID",
        "Tool_Hash", "Generador Hash",
        "Tool_Password", "Generador Contraseña",
        "Tool_Timestamp", "Convertidor Timestamp",
        "Tool_Regex", "Probador Regex",
        "Tool_JsonYaml", "JSON ⇄ YAML",
        "Tool_Gzip", "Archivador Gzip",
        "Tool_Markdown", "Vista Previa Markdown",
        "Tool_ImgCompress", "Comprimir Imagen",
        "Tool_ColorBlind", "Simulador Daltonismo",
        "Lbl_WIP", "Trabajo en progreso (WIP).",
        "Btn_Generate", "Generar",
        "Btn_Copy", "Copiar",
        "Btn_Encode", "Codificar",
        "Btn_Decode", "Decodificar",
        "Lbl_Input", "Texto de entrada:",
        "Lbl_Output", "Resultado:",
        "Lbl_Timestamp", "Unix Timestamp (Segundos):",
        "Btn_ToDate", "Ts -> Fecha",
        "Lbl_Date", "Fecha (YYYYMMDDHHMISS):",
        "Btn_ToTs", "Fecha -> Ts",
        "Lbl_Length", "Longitud:",
        "Lbl_RegexPattern", "Patrón Regex:",
        "Lbl_RegexTest", "Texto a probar:",
        "Lbl_RegexMatch", "Resultado Match:",
        "Btn_TestMatch", "Probar Coincidencia",
        "Btn_J2Y", "JSON -> YAML",
        "Btn_Y2J", "YAML -> JSON",
        "Lbl_FileToCompress", "Archivo a comprimir:",
        "Btn_Browse", "Examinar",
        "Btn_CompressGz", "Comprimir a .tar.gz (tar nativo)",
        "Btn_RenderMd", "Renderizar Vista Previa",
        "Lbl_SelectImg", "Seleccionar Imagen (JPG/PNG/BMP):",
        "Lbl_JpgQuality", "Calidad JPG:",
        "Btn_CompressImg", "Comprimir y Guardar (WIA)",
        "Lbl_ImgToSimulate", "Seleccionar Imagen a simular:",
        "Lbl_ColorblindType", "Tipo de Daltonismo:",
        "Btn_Simulate", "Generar Simulación",
        "Opt_Protanopia", "Protanopía (Ceguera al Rojo)",
        "Opt_Deuteranopia", "Deuteranopía (Ceguera al Verde)",
        "Opt_Tritanopia", "Tritanopía (Ceguera al Azul)",
        "Opt_Achromatopsia", "Acromatopsia (Monocromatismo)",
        "Msg_SelectValidFile", "Por favor, seleccione un archivo válido.",
        "Msg_Error", "Error",
        "Msg_GzipSuccess", "Archivo comprimido con éxito en:`n",
        "Msg_GzipComplete", "Gzip Completado",
        "Msg_GzipError", "Error durante la creación del archivo Gzip.",
        "Msg_ComInitError", "Error inicializando el componente COM.",
        "Msg_Loading", "Cargando...",
        "Msg_NetError", "Error: Sin conexión a internet o librería JS no cargada.",
        "Msg_SelectValidImg", "Por favor, seleccione una imagen válida.",
        "Msg_SaveImgComp", "Guardar Imagen Comprimida",
        "Msg_ImgCompSuccess", "¡Imagen comprimida y guardada con éxito!",
        "Msg_Complete", "Completado",
        "Msg_ImgCompError", "Error durante la compresión WIA:`n",
        "Msg_ImgLoadError", "No se puede cargar la imagen.",
        "Msg_SimSuccess", "Imagen simulada guardada en:`n",
        "Msg_MatchFound", "Coincidencia encontrada en pos ",
        "Msg_NoMatch", "Sin coincidencias.",
        "Msg_RegexError", "Error de sintaxis en el Patrón Regex."
    )
)

; Funzione helper per ottenere la stringa tradotta
_T(key) => DevT[DevLang].Has(key) ? DevT[DevLang][key] : key

; ==============================================================================
; GUI PRINCIPALE DEV TOOLS
; ==============================================================================
ShowDevTools() {
    global DevGui
    if IsSet(DevGui) {
        DevGui.Show()
        return
    }

    DevGui := Gui("-MaximizeBox", "🦊 " _T("Title"))
    DevGui.BackColor := "D0D5DC" ; Colore Metallico (Gunmetal/Steel)
    DevGui.SetFont("s10 norm c111111", "Segoe UI")
    DevGui.MarginX := 20
    DevGui.MarginY := 20
    DevGui.OnEvent("Close", (*) => DevGui.Hide())

    ; --- SIDEBAR LATERALE (TreeView Professionale) ---
    tv := DevGui.Add("TreeView", "w210 h420 vToolList BackgroundE1E6EC c151515 -Lines")
    tv.SetFont("s11", "Segoe UI")
    tv.OnEvent("ItemSelect", OnToolSelect)
    
    nEnc := tv.Add(_T("Cat_EncDec"), 0, "Expand Bold")
    n1 := tv.Add(_T("Tool_Base64"), nEnc)
    tv.Add(_T("Tool_Gzip"), nEnc)
    
    nGen := tv.Add(_T("Cat_Generators"), 0, "Expand Bold")
    tv.Add(_T("Tool_UUID"), nGen)
    tv.Add(_T("Tool_Hash"), nGen)
    tv.Add(_T("Tool_Password"), nGen)
    
    nTime := tv.Add(_T("Cat_Time"), 0, "Expand Bold")
    tv.Add(_T("Tool_Timestamp"), nTime)

    nText := tv.Add(_T("Cat_Text"), 0, "Expand Bold")
    tv.Add(_T("Tool_Regex"), nText)
    tv.Add(_T("Tool_Markdown"), nText)
    tv.Add(_T("Tool_JsonYaml"), nText)

    nGra := tv.Add(_T("Cat_Graphics"), 0, "Expand Bold")
    tv.Add(_T("Tool_ImgCompress"), nGra)
    tv.Add(_T("Tool_ColorBlind"), nGra)

    ; --- PANNELLO CONTENUTI (TAB NASCOSTE) ---
    ; Usiamo Tab2 con opzione Bottom. Tab3 ha un bug su Windows 11 con Bottom,
    ; ma le coordinate Y negative bloccano i clic del mouse. Tab2 risolve perfettamente.
    global DevTabs := DevGui.Add("Tab2", "x240 y10 w460 h500 Bottom Choose2", ["Blank", "Base64", "UUID", "Timestamp", "Hash", "Password", "Regex", "JsonYaml", "Gzip", "Markdown", "ImgCompress", "ColorBlind"])

    ; --- TAB 2: BASE64 ---
    DevTabs.UseTab(2)
    DevGui.SetFont("s16 bold c2C3E50") ; Titolo color Ardesia metallico
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Base64"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10") ; Separatore metallico inciso
    
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_Input"))
    global b64Input := DevGui.Add("Edit", "w400 h80 vB64In BackgroundF8F9FA")
    
    btnEnc := DevGui.Add("Button", "w120 xs y+10", _T("Btn_Encode"))
    btnEnc.OnEvent("Click", (*) => b64Output.Value := Base64Encode(b64Input.Value))
    
    btnDec := DevGui.Add("Button", "x+10 yp w120", _T("Btn_Decode"))
    btnDec.OnEvent("Click", (*) => b64Output.Value := Base64Decode(b64Input.Value))

    DevGui.Add("Text", "xs y+15", _T("Lbl_Output"))
    global b64Output := DevGui.Add("Edit", "w400 h80 ReadOnly vB64Out BackgroundEBEEF2")
    b64Output.SetFont("s10", "Consolas")
    
    btnCopyB64 := DevGui.Add("Button", "w120 xs y+10", _T("Btn_Copy"))
    btnCopyB64.OnEvent("Click", (*) => A_Clipboard := b64Output.Value)

    ; --- TAB 3: UUID ---
    DevTabs.UseTab(3)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_UUID"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    
    DevGui.SetFont("s10 norm c111111")
    global uuidOutput := DevGui.Add("Edit", "w400 h50 xs y+40 ReadOnly Center BackgroundEBEEF2")
    uuidOutput.SetFont("s16 bold", "Consolas")
    
    btnGenUUID := DevGui.Add("Button", "w120 xs y+25", _T("Btn_Generate"))
    btnGenUUID.OnEvent("Click", (*) => uuidOutput.Value := GenerateUUID())
    
    btnCopyUUID := DevGui.Add("Button", "x+10 yp w120", _T("Btn_Copy"))
    btnCopyUUID.OnEvent("Click", (*) => A_Clipboard := uuidOutput.Value)
    uuidOutput.Value := GenerateUUID()

    ; --- TAB 4: TIMESTAMP ---
    DevTabs.UseTab(4)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Timestamp"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+20", _T("Lbl_Timestamp"))
    global tsInput := DevGui.Add("Edit", "w400 BackgroundF8F9FA", EpochNow())
    tsInput.SetFont("s11 bold", "Consolas")
    
    btnTsToDate := DevGui.Add("Button", "w150 xs y+10", _T("Btn_ToDate"))
    btnTsToDate.OnEvent("Click", (*) => tsOutputDate.Value := EpochToDate(tsInput.Value))
    
    DevGui.Add("Text", "xs y+20", _T("Lbl_Date"))
    global tsOutputDate := DevGui.Add("Edit", "w400 BackgroundF8F9FA", A_NowUTC)
    tsOutputDate.SetFont("s11 bold", "Consolas")
    
    btnDateToTs := DevGui.Add("Button", "w150 xs y+10", _T("Btn_ToTs"))
    btnDateToTs.OnEvent("Click", (*) => tsInput.Value := DateToEpoch(tsOutputDate.Value))

    ; --- TAB 5: HASH ---
    DevTabs.UseTab(5)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Hash"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_Input"))
    global hashInput := DevGui.Add("Edit", "w400 h70 BackgroundF8F9FA")
    
    DevGui.Add("Text", "xs y+15", "MD5:")
    global hashMD5 := DevGui.Add("Edit", "w400 ReadOnly BackgroundEBEEF2")
    hashMD5.SetFont("s10", "Consolas")
    
    DevGui.Add("Text", "xs y+10", "SHA-256:")
    global hashSHA256 := DevGui.Add("Edit", "w400 ReadOnly BackgroundEBEEF2")
    hashSHA256.SetFont("s10", "Consolas")
    
    hashInput.OnEvent("Change", UpdateHashes)

    ; --- TAB 6: PASSWORD ---
    DevTabs.UseTab(6)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Password"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    
    DevGui.SetFont("s10 norm c111111")
    global pwdOutput := DevGui.Add("Edit", "w400 h50 xs y+40 ReadOnly Center BackgroundEBEEF2")
    pwdOutput.SetFont("s16 bold", "Consolas")
    
    DevGui.Add("Text", "xs y+25", _T("Lbl_Length"))
    global pwdLen := DevGui.Add("Edit", "x+10 yp-3 w60 Center BackgroundF8F9FA", "16")
    pwdLen.SetFont("s11 bold")
    DevGui.Add("UpDown", "Range4-64", 16)
    
    btnGenPwd := DevGui.Add("Button", "w120 xs y+25", _T("Btn_Generate"))
    btnGenPwd.OnEvent("Click", (*) => pwdOutput.Value := GeneratePassword(pwdLen.Value))
    
    btnCopyPwd := DevGui.Add("Button", "x+10 yp w120", _T("Btn_Copy"))
    btnCopyPwd.OnEvent("Click", (*) => A_Clipboard := pwdOutput.Value)
    pwdOutput.Value := GeneratePassword(16)

    ; --- TAB 7: REGEX ---
    DevTabs.UseTab(7)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Regex"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_RegexPattern"))
    global rxPattern := DevGui.Add("Edit", "w400 BackgroundF8F9FA", "i)^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$")
    rxPattern.SetFont("s10 bold", "Consolas")
    
    DevGui.Add("Text", "xs y+10", _T("Lbl_RegexTest"))
    global rxInput := DevGui.Add("Edit", "w400 h60 BackgroundF8F9FA", "test@example.com")
    rxInput.SetFont("s10", "Consolas")
    
    DevGui.Add("Text", "xs y+10", _T("Lbl_RegexMatch"))
    global rxOutput := DevGui.Add("Edit", "w400 h60 ReadOnly BackgroundEBEEF2")
    rxOutput.SetFont("s10", "Consolas")
    
    btnRxMatch := DevGui.Add("Button", "w120 xs y+10", _T("Btn_TestMatch"))
    btnRxMatch.OnEvent("Click", (*) => rxOutput.Value := TestRegexMatch(rxPattern.Value, rxInput.Value))

    ; --- TAB 8: JSON / YAML ---
    DevTabs.UseTab(8)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_JsonYaml"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    DevGui.SetFont("s10 norm c111111")
    global jyInput := DevGui.Add("Edit", "w400 h110 xs y+10 BackgroundF8F9FA Multi", '{"chiave": "valore", "lista": [1, 2, 3]}')
    btnJ2Y := DevGui.Add("Button", "w195 xs y+5", _T("Btn_J2Y"))
    btnY2J := DevGui.Add("Button", "x+10 yp w195", _T("Btn_Y2J"))
    DevGui.Add("Text", "xs y+5", _T("Lbl_Output"))
    global jyOutput := DevGui.Add("Edit", "w400 h110 xs y+5 ReadOnly BackgroundEBEEF2 Multi")
    btnJ2Y.OnEvent("Click", (*) => jyOutput.Value := ConvertJsonYaml(jyInput.Value, "J2Y"))
    btnY2J.OnEvent("Click", (*) => jyOutput.Value := ConvertJsonYaml(jyInput.Value, "Y2J"))

    ; --- TAB 9: GZIP ---
    DevTabs.UseTab(9)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Gzip"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_FileToCompress"))
    global gzInput := DevGui.Add("Edit", "w320 xs y+5 ReadOnly BackgroundEBEEF2", "")
    btnGzSel := DevGui.Add("Button", "x+10 yp-1 w70", _T("Btn_Browse"))
    btnGzSel.OnEvent("Click", (*) => (gzInput.Value := FileSelect(3, , _T("Lbl_FileToCompress"), "(*.*)")))
    btnGzRun := DevGui.Add("Button", "w400 xs y+15 h35", _T("Btn_CompressGz"))
    btnGzRun.OnEvent("Click", (*) => RunGzip(gzInput.Value))

    ; --- TAB 10: MARKDOWN ---
    DevTabs.UseTab(10)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_Markdown"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    DevGui.SetFont("s10 norm c111111")
    global mdInput := DevGui.Add("Edit", "w400 h80 xs y+10 BackgroundF8F9FA Multi", "# Ciao FoxPath!`nQuesto è un test in **Markdown**.")
    btnMdRender := DevGui.Add("Button", "w400 xs y+5", _T("Btn_RenderMd"))
    global mdBrowser := DevGui.Add("ActiveX", "w400 h160 xs y+5", "Shell.Explorer")
    btnMdRender.OnEvent("Click", (*) => RenderMarkdown(mdInput.Value, mdBrowser))

    ; --- TAB 11: IMG COMPRESS ---
    DevTabs.UseTab(11)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_ImgCompress"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_SelectImg"))
    global imgInput := DevGui.Add("Edit", "w320 xs y+5 ReadOnly BackgroundEBEEF2", "")
    btnImgSel := DevGui.Add("Button", "x+10 yp-1 w70", _T("Btn_Browse"))
    btnImgSel.OnEvent("Click", (*) => (imgInput.Value := FileSelect(3, , _T("Lbl_SelectImg"), "(*.png; *.jpg; *.jpeg; *.bmp)")))
    DevGui.Add("Text", "xs y+15 w100", _T("Lbl_JpgQuality"))
    global imgQuality := DevGui.Add("Slider", "x+10 yp-5 w290 Range10-100 ToolTip", 50)
    btnImgRun := DevGui.Add("Button", "w400 xs y+15 h35", _T("Btn_CompressImg"))
    btnImgRun.OnEvent("Click", (*) => RunImgCompress(imgInput.Value, imgQuality.Value))

    ; --- TAB 12: COLORBLIND ---
    DevTabs.UseTab(12)
    DevGui.SetFont("s16 bold c2C3E50")
    DevGui.Add("Text", "x260 y25 w400 Section", _T("Tool_ColorBlind"))
    DevGui.Add("Text", "xs y+5 w400 h2 0x10")
    DevGui.SetFont("s10 norm c111111")
    DevGui.Add("Text", "xs y+15", _T("Lbl_ImgToSimulate"))
    global cbInput := DevGui.Add("Edit", "w320 xs y+5 ReadOnly BackgroundEBEEF2", "")
    btnCbSel := DevGui.Add("Button", "x+10 yp-1 w70", _T("Btn_Browse"))
    btnCbSel.OnEvent("Click", (*) => (cbInput.Value := FileSelect(3, , _T("Lbl_ImgToSimulate"), "(*.png; *.jpg; *.jpeg; *.bmp)")))
    DevGui.Add("Text", "xs y+15", _T("Lbl_ColorblindType"))
    global cbType := DevGui.Add("DropDownList", "w400 xs y+5 Choose1", [_T("Opt_Protanopia"), _T("Opt_Deuteranopia"), _T("Opt_Tritanopia"), _T("Opt_Achromatopsia")])
    btnCbRun := DevGui.Add("Button", "w400 xs y+15 h35", _T("Btn_Simulate"))
    btnCbRun.OnEvent("Click", (*) => RunColorBlind(cbInput.Value, cbType.Value))

    tv.Modify(n1, "Select")

    ; --- FINE TABS ---
    DevTabs.UseTab()
    DevGui.Show("w710 h460")
}

; Gestione click sulla sidebar laterale
OnToolSelect(ctrl, item, *) {
    global DevTabs
    selText := ctrl.GetText(item)
    
    if (selText = _T("Tool_Base64"))
        DevTabs.Choose(2)
    else if (selText = _T("Tool_UUID"))
        DevTabs.Choose(3)
    else if (selText = _T("Tool_Timestamp"))
        DevTabs.Choose(4)
    else if (selText = _T("Tool_Hash"))
        DevTabs.Choose(5)
    else if (selText = _T("Tool_Password"))
        DevTabs.Choose(6)
    else if (selText = _T("Tool_Regex"))
        DevTabs.Choose(7)
    else if (selText = _T("Tool_JsonYaml"))
        DevTabs.Choose(8)
    else if (selText = _T("Tool_Gzip"))
        DevTabs.Choose(9)
    else if (selText = _T("Tool_Markdown"))
        DevTabs.Choose(10)
    else if (selText = _T("Tool_ImgCompress"))
        DevTabs.Choose(11)
    else if (selText = _T("Tool_ColorBlind"))
        DevTabs.Choose(12)
}

; ==============================================================================
; LOGICA STRUMENTI (Fattibilità Alta)
; ==============================================================================

; Genera un UUID v4 tramite API nativa Windows (RPC)
GenerateUUID() {
    guid := Buffer(16)
    DllCall("rpcrt4.dll\UuidCreate", "Ptr", guid)
    pString := 0
    DllCall("rpcrt4.dll\UuidToStringW", "Ptr", guid, "Ptr*", &pString)
    uuidStr := StrGet(pString, "UTF-16")
    DllCall("rpcrt4.dll\RpcStringFreeW", "Ptr*", &pString)
    return StrUpper(uuidStr)
}

; Codifica in Base64 (Senza librerie esterne, usa Crypt32.dll)
Base64Encode(text) {
    if (text = "")
        return ""
    bufSize := StrPut(text, "UTF-8")
    buf := Buffer(bufSize - 1)
    StrPut(text, buf, "UTF-8")
    
    flags := 0x40000001 ; CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF
    DllCall("Crypt32.dll\CryptBinaryToStringW", "Ptr", buf, "UInt", buf.Size, "UInt", flags, "Ptr", 0, "UInt*", &outLen := 0)
    outStr := ""
    VarSetStrCapacity(&outStr, outLen * 2)
    DllCall("Crypt32.dll\CryptBinaryToStringW", "Ptr", buf, "UInt", buf.Size, "UInt", flags, "Str", outStr, "UInt*", &outLen)
    return outStr
}

; Decodifica da Base64
Base64Decode(b64) {
    if (b64 = "")
        return ""
    DllCall("Crypt32.dll\CryptStringToBinaryW", "Str", b64, "UInt", StrLen(b64), "UInt", 1, "Ptr", 0, "UInt*", &bufSize := 0, "Ptr", 0, "Ptr", 0)
    buf := Buffer(bufSize)
    DllCall("Crypt32.dll\CryptStringToBinaryW", "Str", b64, "UInt", StrLen(b64), "UInt", 1, "Ptr", buf, "UInt*", &bufSize, "Ptr", 0, "Ptr", 0)
    return StrGet(buf, "UTF-8")
}

; --- FUNZIONI TIMESTAMP ---
EpochNow() => DateDiff(A_NowUTC, "19700101000000", "Seconds")

EpochToDate(epoch) {
    if !IsNumber(epoch)
        return ""
    return DateAdd("19700101000000", Integer(epoch), "Seconds")
}

DateToEpoch(dateStr) {
    try return DateDiff(dateStr, "19700101000000", "Seconds")
    catch
        return "Errore"
}

; --- FUNZIONI HASH (Native Windows API - no dipendenze) ---
UpdateHashes(ctrl, *) {
    global hashMD5, hashSHA256
    text := ctrl.Value
    if (text = "") {
        hashMD5.Value := "", hashSHA256.Value := ""
        return
    }
    hashMD5.Value := CryptHash(text, "MD5")
    hashSHA256.Value := CryptHash(text, "SHA256")
}

CryptHash(str, alg := "SHA256") {
    algId := (alg = "MD5") ? 0x00008003 : 0x0000800C
    hProv := 0, hHash := 0
    if !DllCall("Advapi32\CryptAcquireContext", "Ptr*", &hProv, "Ptr", 0, "Ptr", 0, "UInt", 24, "UInt", 0xF0000000)
        return ""
    DllCall("Advapi32\CryptCreateHash", "Ptr", hProv, "UInt", algId, "Ptr", 0, "UInt", 0, "Ptr*", &hHash)
    
    bufSize := StrPut(str, "UTF-8") - 1
    buf := Buffer(bufSize)
    StrPut(str, buf, "UTF-8")
    
    DllCall("Advapi32\CryptHashData", "Ptr", hHash, "Ptr", buf, "UInt", bufSize, "UInt", 0)
    
    hashLen := 0
    DllCall("Advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", 0, "UInt*", &hashLen, "UInt", 0)
    hashBuf := Buffer(hashLen)
    DllCall("Advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", hashBuf, "UInt*", &hashLen, "UInt", 0)
    
    DllCall("Advapi32\CryptDestroyHash", "Ptr", hHash)
    DllCall("Advapi32\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    
    out := ""
    Loop hashLen
        out .= Format("{:02x}", NumGet(hashBuf, A_Index - 1, "UChar"))
    return out
}

; --- GENERATORE PASSWORD ---
GeneratePassword(length := 16) {
    chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+"
    pwd := "", maxIdx := StrLen(chars)
    lenInt := (IsNumber(length) && length > 0) ? Integer(length) : 16
    Loop lenInt
        pwd .= SubStr(chars, Random(1, maxIdx), 1)
    return pwd
}

; --- TESTER REGEX ---
TestRegexMatch(pattern, text) {
    if (pattern = "" || text = "")
        return ""
    try {
        pos := RegExMatch(text, pattern, &match)
            return (pos > 0) ? (_T("Msg_MatchFound") pos ":`r`n" match[0]) : _T("Msg_NoMatch")
    } catch {
            return _T("Msg_RegexError")
    }
}

; --- ARCHIVIATORE GZIP ---
RunGzip(target) {
    if !FileExist(target) {
            MsgBox(_T("Msg_SelectValidFile"), _T("Msg_Error"), 48)
        return
    }
    SplitPath(target, &name, &dir, &ext, &nameNoExt)
    outPath := dir "\" nameNoExt ".tar.gz"
    cmd := A_ComSpec " /c tar -czf `"" outPath "`" `"" name "`""
    try {
        RunWait(cmd, dir, "Hide")
            MsgBox(_T("Msg_GzipSuccess") outPath, _T("Msg_GzipComplete"), 64)
    } catch {
            MsgBox(_T("Msg_GzipError"), _T("Msg_Error"), 16)
    }
}

; --- JSON / YAML ---
ConvertJsonYaml(text, direction) {
    if (text = "")
        return ""
    static doc := ""
    if (doc = "") {
        try {
            doc := ComObject("htmlfile")
            doc.open()
            html := "<!DOCTYPE html><html><head><meta http-equiv='X-UA-Compatible' content='IE=edge'>"
            html .= "<script src='https://cdnjs.cloudflare.com/ajax/libs/js-yaml/3.14.1/js-yaml.min.js'></script>"
            html .= "<script>function convert(txt, dir) { try { if(dir == 'J2Y') { var obj = JSON.parse(txt); return jsyaml.dump(obj); } else { var obj = jsyaml.load(txt); return JSON.stringify(obj, null, 2); } } catch(e) { return 'Errore: ' + e.message; } }</script>"
            html .= "</head><body></body></html>"
            doc.write(html)
            doc.close()
        } catch {
                return _T("Msg_ComInitError")
        }
    }
    
    ; Attendi il caricamento della libreria esterna js-yaml (max 2 secondi)
    Loop 40 {
        try {
            if (doc.parentWindow.jsyaml)
                break
        }
        Sleep(50)
    }
    
    try {
        return doc.parentWindow.convert(text, direction)
    } catch {
            return _T("Msg_NetError")
    }
}

; --- ANTEPRIMA MARKDOWN ---
RenderMarkdown(text, browserCtrl) {
    html := "<!DOCTYPE html><html><head><meta charset='utf-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'>"
    html .= "<script src='https://cdn.jsdelivr.net/npm/marked@0.8.2/marked.min.js'></script>"
    html .= "<style>body{font-family:Segoe UI,sans-serif; font-size:14px; background-color:#EBEEF2; color:#111111; padding:10px; margin:0;} blockquote{border-left:3px solid #ccc; padding-left:10px;} code{background:#ddd; padding:2px 4px; border-radius:3px;}</style>"
        html .= "</head><body><textarea id='src' style='display:none;'></textarea><div id='content'><i>" _T("Msg_Loading") "</i></div>"
    html .= "<script>function renderMd(){ try{ document.getElementById('content').innerHTML = marked(document.getElementById('src').value); }catch(e){} }</script>"
    html .= "<script>window.onload = function() { renderMd(); };</script>"
    html .= "</body></html>"
    
    try {
        browserCtrl.Value.Navigate("about:blank")
        while browserCtrl.Value.ReadyState != 4
            Sleep(50)
        browserCtrl.Value.document.open()
        browserCtrl.Value.document.write(html)
        browserCtrl.Value.document.close()
        browserCtrl.Value.document.getElementById("src").value := text
    } catch {
            MsgBox(_T("Msg_ComInitError"), _T("Msg_Error"), 16)
    }
}

; --- COMPRESSORE IMMAGINI WIA ---
RunImgCompress(inFile, quality) {
    if !FileExist(inFile) {
            MsgBox(_T("Msg_SelectValidImg"), _T("Msg_Error"), 48)
        return
    }
    SplitPath(inFile, &name, &dir, &ext, &nameNoExt)
        outFile := FileSelect("S16", dir "\" nameNoExt "_comp.jpg", _T("Msg_SaveImgComp"), "JPEG (*.jpg)")
    if (outFile = "")
        return
    if !RegExMatch(outFile, "i)\.jpe?g$")
        outFile .= ".jpg"
        
    try {
        img := ComObject("WIA.ImageFile")
        img.LoadFile(inFile)
        ip := ComObject("WIA.ImageProcess")
        ip.Filters.Add(ip.FilterInfos.Item("Convert").FilterID)
        ip.Filters.Item(1).Properties.Item("FormatID").Value := "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
        ip.Filters.Item(1).Properties.Item("Quality").Value := quality
        outImg := ip.Apply(img)
        if FileExist(outFile)
            FileDelete(outFile)
        outImg.SaveFile(outFile)
            MsgBox(_T("Msg_ImgCompSuccess"), _T("Msg_Complete"), 64)
    } catch as e {
            MsgBox(_T("Msg_ImgCompError") e.Message, _T("Msg_Error"), 16)
    }
}

; --- SIMULATORE DALTONISMO (GDI+) ---
    RunColorBlind(inFile, typeIdx) {
    if !FileExist(inFile) {
            MsgBox(_T("Msg_SelectValidImg"), _T("Msg_Error"), 48)
        return
    }
    
    ; GDI+ Startup
    pToken := 0
    si := Buffer(16, 0)
    NumPut("UInt", 1, si, 0)
    DllCall("gdiplus\GdiplusStartup", "Ptr*", &pToken, "Ptr", si, "Ptr", 0)
    
    pBitmap := 0
    DllCall("gdiplus\GdipCreateBitmapFromFile", "WStr", inFile, "Ptr*", &pBitmap)
    
    if !pBitmap {
        DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
            MsgBox(_T("Msg_ImgLoadError"), _T("Msg_Error"), 16)
        return
    }
    
    w := 0, h := 0
    DllCall("gdiplus\GdipGetImageWidth", "Ptr", pBitmap, "UInt*", &w)
    DllCall("gdiplus\GdipGetImageHeight", "Ptr", pBitmap, "UInt*", &h)
    
    pNewBitmap := 0
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", w, "Int", h, "Int", 0, "Int", 0x26200A, "Ptr", 0, "Ptr*", &pNewBitmap) ; Format32bppArgb
    pGraphics := 0
    DllCall("gdiplus\GdipGetImageGraphicsContext", "Ptr", pNewBitmap, "Ptr*", &pGraphics)
    pImgAttr := 0
    DllCall("gdiplus\GdipCreateImageAttributes", "Ptr*", &pImgAttr)
    
    matrix := Buffer(100, 0)
    if (typeIdx == 1) {
        m := [ 0.56667, 0.55833, 0.0,     0.0, 0.0
             , 0.43333, 0.44167, 0.24167, 0.0, 0.0
             , 0.0,     0.0,     0.75833, 0.0, 0.0
             , 0.0,     0.0,     0.0,     1.0, 0.0
             , 0.0,     0.0,     0.0,     0.0, 1.0 ]
    } else if (typeIdx == 2) {
        m := [ 0.625, 0.7,   0.0, 0.0, 0.0
             , 0.375, 0.3,   0.3, 0.0, 0.0
             , 0.0,   0.0,   0.7, 0.0, 0.0
             , 0.0,   0.0,   0.0, 1.0, 0.0
             , 0.0,   0.0,   0.0, 0.0, 1.0 ]
    } else if (typeIdx == 3) {
        m := [ 0.95,  0.0,     0.0,   0.0, 0.0
             , 0.05,  0.43333, 0.475, 0.0, 0.0
             , 0.0,   0.56667, 0.525, 0.0, 0.0
             , 0.0,   0.0,     0.0,   1.0, 0.0
             , 0.0,   0.0,     0.0,   0.0, 1.0 ]
    } else {
        m := [ 0.299, 0.299, 0.299, 0.0, 0.0
             , 0.587, 0.587, 0.587, 0.0, 0.0
             , 0.114, 0.114, 0.114, 0.0, 0.0
             , 0.0,   0.0,   0.0,   1.0, 0.0
             , 0.0,   0.0,   0.0,   0.0, 1.0 ]
    }
    
    for i, val in m
        NumPut("Float", val, matrix, (i-1)*4)
        
    DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "Ptr", pImgAttr, "Int", 0, "Int", 1, "Ptr", matrix, "Ptr", 0, "Int", 0)
    DllCall("gdiplus\GdipDrawImageRectRect", "Ptr", pGraphics, "Ptr", pBitmap, "Float", 0, "Float", 0, "Float", w, "Float", h, "Float", 0, "Float", 0, "Float", w, "Float", h, "Int", 2, "Ptr", pImgAttr, "Ptr", 0, "Ptr", 0)
        
    SplitPath(inFile, &name, &dir, &ext, &nameNoExt)
    outFile := dir "\" nameNoExt "_cb.png"
    
    clsid := Buffer(16, 0)
    DllCall("ole32\CLSIDFromString", "WStr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "Ptr", clsid)
    DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pNewBitmap, "WStr", outFile, "Ptr", clsid, "Ptr", 0)
    
    DllCall("gdiplus\GdipDisposeImageAttributes", "Ptr", pImgAttr)
    DllCall("gdiplus\GdipDeleteGraphics", "Ptr", pGraphics)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", pNewBitmap)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
    DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
    
    MsgBox("Immagine simulata salvata in:`n" outFile, "Completato", 64)
}