<div align="center">
  <img src="fox_saluto.png" width="160" alt="FoxPath Mascot">
  <br>
  <img src="FoxPath.png" width="400" alt="FoxPath Logo">
  <p><b>Your visual assistant and "Swiss Army Knife" for productivity on Windows</b></p>
  
  ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-blue.svg)
  ![OS](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-lightgrey.svg)
  ![License](https://img.shields.io/badge/License-Free-green.svg)
  
  <p><b>🌍 English | <a href="README_ES.md">🇪🇸 Español</a> | <a href="README_IT.md">🇮🇹 Italiano</a></b></p>
</div>

---

**FoxPath** is an "always-on-top" assistant powered by **AutoHotkey v2**. Originally born to quickly retrieve and format file paths, it has evolved into a powerful and smart **"Swiss Army Knife"**. Everything is accompanied by a cute interactive mascot (our Fox!) that dynamically reacts to your actions.

## ✨ Why use FoxPath?

- 🚀 **No intrusive windows:** A small floating interface that appears only when you need it and disappears when you're done.
- 🧠 **Context-aware:** Instantly understands what you have selected (images, texts, JSON, folders) and only offers tools relevant to the current file.
- ⚡ **Zero Friction:** No more tedious middle steps. Convert, extract, and process files directly from your Desktop or File Explorer with one click.

## 🧰 Main Features

### 📝 Text and Editorial Tools
- **Smart Text Extraction:** Extract plain text or tables from **Word (.docx)** and **Excel (.xlsx)** files without even opening them.
- **OCR & Translation:** Extract text directly from images, or translate your notes on the fly via Google Translate.
- **Quick Notes:** Instantly create `.txt` files from whatever you currently have copied in your Windows clipboard.
- **Statistics:** Instantly count words, characters, and estimate the expected reading time of a document.

### 📸 Images and Graphics
<img src="fox_attesa.png" width="70" align="right" alt="Waiting">

- **Visual Color Picker:** Click on a photo and FoxPath will magically extract the **5 predominant colors**, ready to be copied in HEX, RGB, HSL, or CMYK format via a mini-dashboard.
- **Fast Format Converter:** Transform images on the fly between **PNG, JPG, and BMP** using the native GDI+ graphics engine.

### 💻 System and Development
- **JSON Management:** Minify or beautifully format illegible `.json` files in a single click.
- **Git & Terminals:** Open paths directly in **VS Code** or PowerShell. Execute instant Git commands (Pull, Add, Commit) on your repositories.
- **Snippet Generator:** Create instant boilerplates (basic HTML, `.gitignore`, Markdown templates) or ready-to-use direct shortcuts.

### 🛠️ Developer Tools (DevTools)
By clicking the `</>` icon, you gain access to a powerful native suite for programmers, always at your fingertips:
- **Encoders and Converters:** Base64 (Text), Gzip Archiver, and JSON ⇄ YAML.
- **Secure Generators:** Real-time Hash (MD5, SHA-256), UUID v4, and custom Password Generator.
- **Development:** Epoch Timestamp Converter and a handy native Regular Expression (Regex) Tester.
- **Graphics and Media:** Real-time Markdown file preview, JPG Image Compressor, and Colorblind Simulator.

### 📦 Advanced File Management (Super Tools)
- **Super Zip:** Compress dozens of files into a single archive, or into separate `.zip` packages simultaneously.
- **Security and Privacy Utilities:** Irrecoverably destroy files (Shredder), disguise date/time (Time Stomping), or batch rename.
- **Path Formatting:** Copy paths in dozens of formats (`/`, `\`, quotes, JSON arrays, web URIs). It also keeps a handy **History** of your last 5 copied paths.

---

## 🚀 Installation and First Run

Installation is super fast. FoxPath includes a convenient **Built-in Tutorial** to guide you through your first steps!

1. **Prerequisites:** Make sure you have AutoHotkey v2 installed on your PC. *(Note: If you use the pre-compiled `.exe` version, AutoHotkey is not required!)*
2. Extract the folder containing the `FoxPath.ahk` file (or the executable) and the `foxpath_movement` folder containing the `.gif` animations.
3. Start the script by double-clicking on `FoxPath.ahk` (or `FoxPath.exe`).
4. **On the first run**, the welcome window will automatically appear, where you can autonomously set it to start with Windows and create a Desktop shortcut!

## 🎮 How to use it

<div align="center">
  <img src="fox_conferma.png" width="120" alt="FoxPath Confirmation">
</div>

1. **Summon the Fox:** Press `Ctrl + Alt + F` at any time. The Fox will appear floating on your screen.
2. **Select an Item:** Click on files or folders. The Fox will read the selection and update in real-time.
3. **Interact:** 
   - 🖱️ **Left Click:** Standard quick copy and primary set action.
   - 🖱️ **Right Click:** Opens the powerful Context Menu to navigate through filters, special formatting, and all Advanced Tools.

## ⚙️ Customization (Settings)

FoxPath is designed to perfectly adapt to your workflow. By clicking on the **Gear (⚙️)** icon (or via Right Click > *Settings*) you can:
- Change UI colors (buttons, text, backgrounds).
- Granularly adjust the panel dimensions and **Global Transparency**.
- Choose the Global keyboard shortcut to summon it.
- **Quick Menu:** Decide your primary action and your **5 Favorite Actions** to display at the top of the context menu, keeping them just a click away.

*All your preferences are saved in a portable, extremely lightweight file called `FoxPath.ini`.*

## 🆘 FAQ and Troubleshooting

- **The Fox looks "squished" or the image is distorted?** 
  In the Settings (⚙️), check *"Unlock Manual Resize"* and slightly stretch the window by dragging its borders: this will force the calculation of optimal proportions. Then click *Save*.
- **Antivirus blocking the executable?**
  Software created in AutoHotkey interacts with windows and the clipboard, which is sometimes flagged as suspicious. Add the file to your Antivirus **Exceptions/Exclusions** safely.
- **Windows SmartScreen prevents startup ("Unrecognized app")?**
  Since FoxPath is a new open-source app without an expensive digital signature, Windows blocks it as a precaution. Click on **"More info"** and then **"Run anyway"**.

<br>