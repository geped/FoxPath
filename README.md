<div align="center">
  <img src="FoxPath.png" width="150" alt="FoxPath Logo">
  <p><b>Your visual assistant and "Swiss Army Knife" for productivity on Windows</b></p>
  
  ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-blue.svg)
  ![OS](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-lightgrey.svg)
  ![License](https://img.shields.io/badge/License-Free-green.svg)

  <p><b>🌍 English | <a href="README_ES.md">🇪🇸 Español</a> | <a href="README_IT.md">🇮🇹 Italiano</a></b></p>
</div>

---

<img src="fox_saluto.png" width="150" align="right" alt="FoxPath Mascot">

**FoxPath** is an "always-on-top" assistant based on **AutoHotkey v2**. Originally created to quickly retrieve and format file paths, it has evolved into a powerful, intelligent **"Swiss Army Knife"**. Everything is accompanied by a cute interactive mascot (our Fox!) that reacts dynamically to what you do.

## ✨ Why use FoxPath?

- 🚀 **No intrusive windows:** A small floating interface that appears only when you need it and disappears when you're done.
- 🧠 **Contextual:** It instantly understands what you have selected (images, texts, JSON, folders) and offers you only the tools suitable for the current file.
- ⚡ **Zero Friction:** No more boring intermediate steps. Convert, extract, and process files directly from the Desktop or File Explorer with a single click.

## 🧰 Main Features

### 📝 Editorial and Text Tools
- **Smart Text Extraction:** Extract pure text or tables from **Word (.docx)** and **Excel (.xlsx)** files without even opening them.
- **OCR & Translation:** Extract text directly from images, or translate your notes on the fly via Google Translate.
- **Quick Notes:** Create `.txt` files instantly starting from what you have currently copied to the Windows clipboard.
- **Statistics:** Instantly count words, characters, and estimate expected reading times of a document.

### 📸 Images and Graphics
<img src="fox_attesa.png" width="70" align="right" alt="Waiting">

- **Visual Color Picker:** Click on a photo and FoxPath will magically extract the **5 predominant colors**, ready to be copied in HEX, RGB, HSL, or CMYK format via a mini-dashboard.
- **Quick Format Converter:** Transform images on the fly between **PNG, JPG, and BMP** leveraging the native GDI+ graphics engine.

### 💻 Development and System
- **JSON Management:** Minify or beautifully format unreadable `.json` files in a single click.
- **Git & Terminals:** Open paths directly in **VS Code** or PowerShell. Run instant Git commands (Pull, Add, Commit) on your repositories.
- **Snippet Generator:** Create instant boilerplates (base HTML, `.gitignore`, Markdown templates) or ready-to-use direct shortcuts.

### 📦 Advanced File Management (Super Tools)
- **Super Zip:** Compress dozens of files into a single archive, or into separate `.zip` packages simultaneously.
- **Security and Privacy Utilities:** Irrecoverably destroy files (Shredder), disguise date/time (Time Stomping), or batch rename.
- **Path Formatting:** Copy paths in dozens of formats (`/`, `\`, quotes, JSON array, web URI). It also keeps a handy **History** of the last 5 copied paths.

---

## 🚀 Installation and First Start

Installation is extremely fast. FoxPath includes a handy **Integrated Tutorial** to guide you through your first steps!

1. **Prerequisites:** Make sure you have AutoHotkey v2 installed on your PC. *(Note: If you use the pre-compiled `.exe` version, AutoHotkey is not required!)*
2. Extract the folder containing the `FoxPath.ahk` file (or the executable) and the `foxpath_movement` folder containing the `.gif` animations.
3. Start the script by double-clicking on `FoxPath.ahk` (or `FoxPath.exe`).
4. **On first start**, the welcome window will automatically appear, where you can easily set up automatic startup with Windows and create a shortcut on the Desktop!

## 🎮 How to use it

<div align="center">
  <img src="fox_conferma.png" width="120" alt="FoxPath Confirm">
</div>

1. **Summon the Fox:** Press `Ctrl + Alt + F` at any time. The Fox will appear floating on the screen.
2. **Select an Item:** Click on files or folders. The Fox will read the selection and update in real-time.
3. **Interact:** 
   - 🖱️ **Left Click:** Standard quick copy and set primary action.
   - 🖱️ **Right Click:** Opens the powerful Context Menu to navigate between filters, special formatting, and all Advanced Tools.

## ⚙️ Customization (Settings)

FoxPath is designed to perfectly fit your workflow. By clicking on the **Gear (⚙️)** icon (or from Right Click > *Settings*), you can:
- Change the UI colors (buttons, texts, backgrounds).
- Granularly adjust the panel dimensions and the **Global Transparency**.
- Choose the custom Global keyboard shortcut for summoning.
- **Quick Menu:** Decide the primary action and what your **5 Favorite Actions** are to show at the top of the context menu to have them a click away.

*All your preferences are saved in a portable and lightweight file called `FoxPath.ini`.*

## 🆘 FAQ and Troubleshooting

- **The Fox looks "squished" or the image is distorted?** 
  In Settings (⚙️), check *"Unlock Manual Resize"* and slightly widen the window by dragging the borders: this will force the mathematical calculation of optimal proportions. Then click *Save*.
- **Multiple Selection pastes everything on a single line?** 
  By default, multiple files are joined by a line break (`\r\n`). If the app where you are pasting doesn't support it, use the *"Copy separated by Comma"* option in the Formatting menu.
- **The antivirus blocks the executable?**
  Software created in AutoHotkey is often subject to false positives due to its clipboard access. If you compiled FoxPath, add the folder to Windows Defender Exclusions, or ensure you compiled it by selecting the **"v2 64-bit"** Base File option without any compression (e.g., no UPX).

<br>

<div align="center">
  <img src="FoxPath.png" width="70" alt="FoxPath Logo">
</div>