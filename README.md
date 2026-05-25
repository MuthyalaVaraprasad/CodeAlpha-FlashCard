# 📱 FlashCard Quiz App (Premium Portfolio Presentation)

An interactive, responsive, and gamified **FlashCard Quiz App** designed and engineered to showcase high-impact frontend development practices. Built as a professional portfolio submission for the **CodeAlpha Internship**, this app features full offline-capable state storage, custom audio synthesis, accessibility modules, and habit tracking visualizations.

---

## 🚀 Live Demo & Device Mockup
The application is wrapped inside an **immersive smartphone device mockup frame**. It dynamically adapts using CSS flex layout and responsive media query breakpoints:
*   **Desktop Browsers**: Renders as a beautiful, high-fidelity premium smartphone simulation centered on a dark glassmorphic canvas.
*   **Mobile Screens**: Automatically removes the device boundaries and transitions into a **native full-screen mobile app** for premium mobile interactivity.

---

## ✨ Key Technical Achievements & Features

### 1. 📊 Gamified Performance Engine
*   **GitHub-style Activity Heatmap**: A custom 28-day study habit grid displaying daily progress. Grid cells dynamically shade purple depending on study volume, encouraging learning habits.
*   **🔥 Daily Study Streak**: A calculated algorithm checking unique active study dates. Displays an animated fire streak badge (e.g., `🔥 3 Day`) directly on the home greeting to gamify retention.
*   **Circular Progress Wheel**: SVGs styled with dynamic `stroke-dashoffset` parameters rendering completion percentages in real-time.

### 2. 🔊 Code-Synthesized Web Audio & Animations
*   **Zero-Latency Programmatic Audio**: Utilizes the **HTML5 Web Audio API** to synthesize chimes in real-time (paper rustle card flips, success chimes on correct answers, warning buzzes on reviews) requiring **zero network bandwidth or external file downloads**.
*   **Visual Confetti Celebration**: Dynamic canvas confetti particle showers trigger instantly when a student completes/masters an entire category deck!

### 3. 📂 Portable Deck Sharing (JSON Importer Exporter)
*   **Export Decks**: Students can backup and download their custom-made decks as structured JSON files locally.
*   **Import Decks**: Seamlessly parse classmates' custom `.json` decks into the localized array database.

### 4. 🗣️ Native Text-to-Speech Reader (TTS Accessibility)
*   Integrates an interactive volume speaker button onto the card face that activates the **native Speech Synthesis API**, reading flashcard questions out loud in a premium native English voice.

### 5. 📁 Category CRUD (Create, Read, Update, Delete)
*   Allows creating custom categories with folder icons, renaming existing topics, or performing **cascade deletions** (which wipes the category and all corresponding flashcard collections in a single confirmation click).

### 6. ⏱️ 15s Timed Challenge Mode
*   Includes a switch-activated timed study tracker showing an orange countdown timer bar. If the timer reaches 0, the card automatically flips to prompt self-evaluation, adding a gamified challenge layer.

---

## 🛠️ Technology Stack
*   **Core Architecture**: HTML5, Vanilla JavaScript (ES6+), Vanilla CSS3.
*   **Design Typography & Icons**: FontAwesome 6 (solid & regular packs), Outfit Google Fonts.
*   **Web APIs**: HTML5 Web Audio API, Speech Synthesis API (TTS), LocalStorage persistence.

---

## 🖥️ Local Execution Guide

The entire app is built inside a single **fully self-contained portable structure** (`index.html`), making it perfect for rapid evaluation and offline running.

### Method A: Single-click Run (Local Browser)
Simply double-click the `index.html` file inside your explorer to launch it immediately inside any web browser (Chrome, Edge, Safari, Firefox).

### Method B: Hosting via Web Server
For full Web Speech API voice loading support, you can serve the directory using a simple local server:
*   **Python 3**:
    ```bash
    python -m http.server 8000
    ```
    Then, open [http://localhost:8000/](http://localhost:8000/) inside your browser.
*   **NodeJS**:
    ```bash
    npx serve .
    ```

---

## 📂 Database Schema (LocalStorage)
The application handles offline persistence seamlessly using the client's `localStorage` engine under the following keys:
*   `flashcards`: Primary list of custom deck cards containing schema fields (`id`, `category`, `question`, `answer`, `isStudied`).
*   `flashcard_categories`: Array of active learning categories.
*   `flashcard_study_history`: Active logs of study date strings (`YYYY-MM-DD`) backing the streak counter and activity heatmap grid.

---

*Designed and Developed for CodeAlpha Internship Portfolio Presentation.*
