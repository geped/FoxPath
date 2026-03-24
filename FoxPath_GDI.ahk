#Requires AutoHotkey v2.0

; ═══════════════════════════════════════════════════════════════
;  GDI+ HELPERS  (pure DllCall, no external library)
; ═══════════════════════════════════════════════════════════════

GdipInit() {
    si := Buffer(A_PtrSize = 8 ? 24 : 16, 0)
    NumPut("UInt", 1, si, 0)
    DllCall("gdiplus\GdiplusStartup", "UPtr*", &tok := 0, "Ptr", si, "Ptr", 0)
    return tok
}

GdipEnd(tok) {
    DllCall("gdiplus\GdiplusShutdown", "Ptr", tok)
}

GdipSolidBrush(argb) {
    DllCall("gdiplus\GdipCreateSolidFill", "UInt", argb, "Ptr*", &br := 0)
    return br
}

GdipDelBrush(br) {
    DllCall("gdiplus\GdipDeleteBrush", "Ptr", br)
}

GdipFillRoundRect(g, br, x, y, w, h, r) {
    DllCall("gdiplus\GdipCreatePath", "Int", 0, "Ptr*", &path := 0)
    x += 0.0, y += 0.0, w += 0.0, h += 0.0, r += 0.0
    diam := r * 2.0
    DllCall("gdiplus\GdipAddPathArc", "Ptr", path, "Float", x, "Float", y, "Float", diam, "Float", diam, "Float", 180.0, "Float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "Ptr", path, "Float", x + w - diam, "Float", y, "Float", diam, "Float", diam, "Float", 270.0, "Float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "Ptr", path, "Float", x + w - diam, "Float", y + h - diam, "Float", diam, "Float", diam, "Float", 0.0, "Float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "Ptr", path, "Float", x, "Float", y + h - diam, "Float", diam, "Float", diam, "Float", 90.0, "Float", 90.0)
    DllCall("gdiplus\GdipClosePathFigure", "Ptr", path)
    DllCall("gdiplus\GdipFillPath", "Ptr", g, "Ptr", br, "Ptr", path)
    DllCall("gdiplus\GdipDeletePath", "Ptr", path)
}

GdipFillRect(g, br, x, y, w, h) {
    DllCall("gdiplus\GdipFillRectangle", "Ptr", g, "Ptr", br, "Float", x + 0.0, "Float", y + 0.0, "Float", w + 0.0, "Float", h + 0.0)
}

GdipFillEllipse(g, br, x, y, w, h) {
    DllCall("gdiplus\GdipFillEllipse", "Ptr", g, "Ptr", br, "Float", x + 0.0, "Float", y + 0.0, "Float", w + 0.0, "Float", h + 0.0)
}

GdipText(g, txt, x, y, w, h, size, argb, bold := false, hAlign := 1) {
    familyBuf := Buffer(16 + 2 * StrLen("Segoe UI") + 2, 0)
    DllCall("gdiplus\GdipCreateFontFamilyFromName", "Str", "Segoe UI", "Ptr", 0, "Ptr*", &family := 0)
    style := bold ? 1 : 0
    DllCall("gdiplus\GdipCreateFont", "Ptr", family, "Float", size + 0.0, "Int", style, "Int", 3, "Ptr*", &font := 0)
    DllCall("gdiplus\GdipCreateStringFormat", "Int", 0, "Int", 0, "Ptr*", &fmt := 0)
    DllCall("gdiplus\GdipSetStringFormatLineAlign", "Ptr", fmt, "Int", 1)
    DllCall("gdiplus\GdipSetStringFormatAlign", "Ptr", fmt, "Int", hAlign)
    rect := Buffer(16, 0)
    NumPut("Float", x + 0.0, rect, 0), NumPut("Float", y + 0.0, rect, 4)
    NumPut("Float", w + 0.0, rect, 8), NumPut("Float", h + 0.0, rect, 12)
    br := GdipSolidBrush(argb)
    DllCall("gdiplus\GdipDrawString", "Ptr", g, "Str", txt, "Int", -1, "Ptr", font, "Ptr", rect, "Ptr", fmt, "Ptr", br)
    GdipDelBrush(br)
    DllCall("gdiplus\GdipDeleteStringFormat", "Ptr", fmt)
    DllCall("gdiplus\GdipDeleteFont", "Ptr", font)
    DllCall("gdiplus\GdipDeleteFontFamily", "Ptr", family)
}

GdipSavePng(bmp, path) {
    clsid := Buffer(16, 0)
    NumPut("UInt", 0x557CF406, clsid, 0), NumPut("UShort", 0x1A04, clsid, 4)
    NumPut("UShort", 0x11D3, clsid, 6), NumPut("UChar", 0x9A, clsid, 8)
    NumPut("UChar", 0x73, clsid, 9), NumPut("UChar", 0x00, clsid, 10)
    NumPut("UChar", 0x00, clsid, 11), NumPut("UChar", 0xF8, clsid, 12)
    NumPut("UChar", 0x1E, clsid, 13), NumPut("UChar", 0xF3, clsid, 14)
    NumPut("UChar", 0x2E, clsid, 15)
    DllCall("gdiplus\GdipSaveImageToFile", "Ptr", bmp, "Str", path, "Ptr", clsid, "Ptr", 0)
}

; ═══════════════════════════════════════════════════════════════
;  DrawInfoPanel — renders the info panel to a PNG file
; ═══════════════════════════════════════════════════════════════
DrawInfoPanel(hasPath, fileName, pathText, btnTitle := "Copia Percorso Normale") {
    Global InfoTmpA, InfoTmpB, InfoTmpFlip, SettingWidth, SettingInfoHeight
    Global SettingBtnColor, SettingTextColor

    W := SettingWidth, H := SettingInfoHeight
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", W, "Int", H, "Int", 0, "Int", 0x26200A, "Ptr", 0, "Ptr*", &bmp := 0)
    DllCall("gdiplus\GdipGetImageGraphicsContext", "Ptr", bmp, "Ptr*", &g := 0)
    DllCall("gdiplus\GdipSetSmoothingMode", "Ptr", g, "Int", 4)
    DllCall("gdiplus\GdipSetTextRenderingHint", "Ptr", g, "Int", 5)
    DllCall("gdiplus\GdipSetCompositingQuality", "Ptr", g, "Int", 1)

    brBg := GdipSolidBrush(0xEB1E1E2E)
    GdipFillRoundRect(g, brBg, 0.0, 0.0, W + 0.0, H + 0.0, 10.0)
    GdipDelBrush(brBg)

    ; --- Riga 1: Nome File (Sinistra) ---
    txtColor := hasPath ? SettingTextColor : 0xFF6B7280
    if (hasPath) {
        GdipText(g, fileName, 10, 6, W-75, 20, 7.5, txtColor, true, 0)
    } else {
        GdipText(g, Tr("ClickFile"), 10, 6, W-75, 20, 7.0, 0xFF6B7280, false, 0)
    }

    ; --- Riga 1: Pulsanti (Destra) - Box di altezza 24px per allineamento verticale perfetto ---
    GdipText(g, "</>", W-60, 4, 32, 24, 8.5, 0xFF94A3B8, true, 1)
    GdipText(g, "⚙", W-28, 4, 24, 24, 11.0, 0xFF94A3B8, false, 1)

    ; --- Riga 2: Pallino e Stato (Sotto il nome file) ---
    dotColor := hasPath ? 0xFF22C55E : 0xFF4B5563
    brDot := GdipSolidBrush(dotColor)
    GdipFillEllipse(g, brDot, 10.0, 31.0, 7.0, 7.0)
    GdipDelBrush(brDot)

    if (hasPath) {
        GdipText(g, Tr("Detected"), 21, 26, W-25, 18, 6.5, 0xFF4ADE80, true, 0)
    } else {
        GdipText(g, Tr("NoSel"), 21, 26, W-25, 18, 6.5, 0xFF6B7280, false, 0)
    }

    ; --- Riga 3: Percorso Esteso ---
    if (hasPath && H > 100) {
        GdipText(g, pathText, 10, 48, W-20, H-95, 6.0, 0xFF94A3B8, false, 0)
    }

    brSep := GdipSolidBrush(0x22FFFFFF)
    GdipFillRect(g, brSep, 8.0, H-49, W-16, 1.0)
    GdipDelBrush(brSep)

    btnColor := hasPath ? SettingBtnColor : 0xFF4B5563
    brBtn := GdipSolidBrush(btnColor)
    GdipFillRoundRect(g, brBtn, 7.0, H-43, W-14, 36.0, 8.0)
    GdipDelBrush(brBtn)

    brGlow := GdipSolidBrush(0x18FFFFFF)
    GdipFillRoundRect(g, brGlow, 7.0, H-43, W-14, 18.0, 8.0)
    GdipDelBrush(brGlow)

    GdipText(g, StrUpper(btnTitle), 7, H-43, W-14, 36, 7.5, 0xFFF8FAFC, true, 1)

    outPath := InfoTmpFlip ? InfoTmpB : InfoTmpA
    InfoTmpFlip := !InfoTmpFlip
    GdipSavePng(bmp, outPath)

    DllCall("gdiplus\GdipDeleteGraphics", "Ptr", g)
    DllCall("gdiplus\GdipDisposeImage",   "Ptr", bmp)
    return outPath
}