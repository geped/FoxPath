<div align="center">
  <img src="fox_saluto.png" width="160" alt="FoxPath Mascot">
  <br>
  <img src="FoxPath.png" width="400" alt="FoxPath Logo">
  <p><b>Il tuo assistente visivo e "Coltellino Svizzero" per la produttività su Windows</b></p>
  
  ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-blue.svg)
  ![OS](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-lightgrey.svg)
  ![License](https://img.shields.io/badge/License-Free-green.svg)
  
  <p><b><a href="README.md">🌍 English</a> | <a href="README_ES.md">🇪🇸 Español</a> | 🇮🇹 Italiano</b></p>
</div>

---

**FoxPath** è un assistente "sempre in primo piano" basato su **AutoHotkey v2**. Nato originariamente per recuperare e formattare rapidamente i percorsi dei file, si è evoluto in un potente **"Coltellino Svizzero"** intelligente. Il tutto è accompagnato da una simpatica mascotte interattiva (la nostra Volpe!) che reagisce dinamicamente a ciò che fai.

## ✨ Perché usare FoxPath?

- 🚀 **Nessuna finestra invadente:** Una piccola interfaccia fluttuante che compare solo quando ti serve e scompare quando hai finito.
- 🧠 **Contestuale:** Capisce istantaneamente cosa hai selezionato (immagini, testi, JSON, cartelle) e ti offre solo gli strumenti adatti al file in uso.
- ⚡ **Zero Attrito:** Niente più noiosi passaggi intermedi. Converti, estrai ed elabora file direttamente dal Desktop o da Esplora File con un clic.

## 🧰 Funzionalità Principali

### 📝 Strumenti Editoriali e Testuali
- **Estrazione Testo Intelligente:** Estrai testo puro o tabelle da file **Word (.docx)** ed **Excel (.xlsx)** senza nemmeno aprirli.
- **OCR & Traduzione:** Estrai il testo direttamente dalle immagini, oppure traduci al volo i tuoi appunti via Google Translate.
- **Appunti Veloci:** Crea file `.txt` istantaneamente a partire da ciò che hai attualmente copiato nella clipboard di Windows.
- **Statistiche:** Conta istantaneamente parole, caratteri e stima i tempi di lettura previsti di un documento.

### 📸 Immagini e Grafica
<img src="fox_attesa.png" width="70" align="right" alt="Attesa">

- **Color Picker Visivo:** Clicca su una foto e FoxPath estrarrà magicamente i **5 colori predominanti**, pronti da copiare in formato HEX, RGB, HSL o CMYK tramite una mini-dashboard.
- **Convertitore Formato Rapido:** Trasforma immagini al volo tra **PNG, JPG e BMP** sfruttando il motore grafico GDI+ nativo.

### 💻 Sviluppo e Sistema
- **Gestione JSON:** Minifica o formatta magnificamente file `.json` illegibili in un solo clic.
- **Git & Terminali:** Apri i percorsi direttamente in **VS Code** o PowerShell. Esegui comandi Git (Pull, Add, Commit) istantanei sulle tue repository.
- **Generatore Snippet:** Crea boilerplate istantanei (HTML base, `.gitignore`, template Markdown) o collegamenti diretti pronti all'uso.

### 📦 Gestione File Avanzata (Super Tools)
- **Super Zip:** Comprimi decine di file in un singolo archivio, oppure in pacchetti `.zip` separati simultaneamente.
- **Utility di Sicurezza e Privacy:** Distruggi file in modo irrecuperabile (Shredder), camuffa data/ora (Time Stomping) o rinomina in blocco.
- **Formattazione Percorsi:** Copia path in decine di formati (`/`, `\`, virgolette, array JSON, URI web). Mantiene anche una comoda **Cronologia** degli ultimi 5 percorsi copiati.

---

## 🚀 Installazione e Primo Avvio

L'installazione è rapidissima. FoxPath include un comodo **Tutorial Integrato** per guidarti ai primi passi!

1. **Prerequisiti:** Assicurati di avere AutoHotkey v2 installato sul tuo PC. *(Nota: Se usi la versione pre-compilata `.exe`, AutoHotkey non è necessario!)*
2. Estrai la cartella contenente il file `FoxPath.ahk` (o l'eseguibile) e la cartella `foxpath_movement` contenente le animazioni `.gif`.
3. Avvia lo script facendo doppio clic su `FoxPath.ahk` (o `FoxPath.exe`).
4. **Al primo avvio** comparirà automaticamente la finestra di benvenuto, dove potrai impostare l'avvio automatico con Windows e creare un collegamento sul Desktop in totale autonomia!

## 🎮 Come si usa

<div align="center">
  <img src="fox_conferma.png" width="120" alt="FoxPath Conferma">
</div>

1. **Evoca la Volpe:** Premi `Ctrl + Alt + F` in qualsiasi momento. La Volpe apparirà fluttuante sullo schermo.
2. **Seleziona un Elemento:** Clicca su file o cartelle. La Volpe leggerà la selezione e si aggiornerà in tempo reale.
3. **Interagisci:** 
   - 🖱️ **Tasto Sinistro:** Copia rapida standard e azione primaria impostata.
   - 🖱️ **Tasto Destro:** Apre il potente Menu Contestuale per navigare tra filtri, formattazioni speciali e tutti gli Strumenti Avanzati.

## ⚙️ Personalizzazione (Impostazioni)

FoxPath è progettato per adattarsi perfettamente al tuo workflow. Cliccando sull'icona a forma di **Ingranaggio (⚙️)** (o dal Clic Destro > *Impostazioni*) potrai:
- Cambiare i colori della UI (pulsanti, testi, sfondi).
- Regolare in modo granulare le dimensioni del pannello e la **Trasparenza globale**.
- Scegliere la scorciatoia da tastiera Globale di evocazione.
- **Menu Rapido:** Decidere l'azione primaria e quali sono le tue **5 Azioni Preferite** da mostrare in cima al menu contestuale per averle a portata di clic.

*Tutte le tue preferenze vengono salvate in un file portatile e leggerissimo chiamato `FoxPath.ini`.*

<div align="center">
  <img src="FoxPath.png" width="300" alt="FoxPath Logo">
</div>