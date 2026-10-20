// A tela de carregamento abre antes de qualquer script do cliente. Textos, cores e músicas vêm
// do servidor junto com a conexão (server/main.lua) em window.nuiHandoverData.almLoadscreen.
// Em algumas versões do FiveM esses dados chegam vazios ou tarde: a página confere de novo por
// alguns segundos e aceita também a reserva que o cliente manda (client/main.lua). Vale o
// primeiro que chegar, uma vez só. Até lá a tela mostra só o fundo, o relógio e a barra.
// A página só desenha: o código é aberto e nada aqui vale como regra.

const $ = (selector) => document.querySelector(selector);

const HEX = /^#[0-9a-fA-F]{6}$/;
const THEME_KEYS = ["accent", "background", "surface", "line", "text", "muted"];
const RGB_KEYS = ["accent", "background", "surface"];
// imagem ou música: arquivo do próprio resource ou endereço https, sem nada que quebre o CSS
const LOCAL_FILE = (folder) => new RegExp(`^${folder}/[\\w\\-./ ]+$`);
const REMOTE_FILE = /^https:\/\/[^\s"'()\\<>]+$/;
// por quanto tempo a página volta a olhar window.nuiHandoverData, e de quanto em quanto
const HANDOVER_WAIT = 15000;
const HANDOVER_STEP = 250;

function safeUrl(value, folder) {
    if (typeof value !== "string" || value === "" || value.includes("..")) return null;
    if (LOCAL_FILE(folder).test(value) || REMOTE_FILE.test(value)) return value;
    return null;
}

const isObject = (value) => value !== null && typeof value === "object" && !Array.isArray(value);
const list = (value) => (Array.isArray(value) ? value : []);

// preenchidos por apply(), com os dados que chegarem primeiro
let applied = false;
let ui = {};
let show = {};

const text = (key) => (typeof ui[key] === "string" ? ui[key] : "");
const enabled = (part) => show[part] !== false;

// ───────── tema ─────────

function applyTheme(theme) {
    const root = document.documentElement.style;
    for (const [key, value] of Object.entries(isObject(theme) ? theme : {})) {
        if (!THEME_KEYS.includes(key) || typeof value !== "string" || !HEX.test(value)) continue;
        root.setProperty(`--${key}`, value);
        if (RGB_KEYS.includes(key)) {
            const n = parseInt(value.slice(1), 16);
            root.setProperty(`--${key}-rgb`, `${n >> 16}, ${(n >> 8) & 255}, ${n & 255}`);
        }
    }
}

// ───────── progresso ─────────

let progress = 0;
let stage = null;

function setProgress(fraction) {
    // o jogo às vezes manda valores fora de ordem; a barra nunca volta
    progress = Math.max(progress, Math.min(1, Number(fraction) || 0));
    $("#fill").style.transform = `scaleX(${progress})`;
    $("#percent").textContent = `${Math.round(progress * 100)}%`;
}

// a etapa pode chegar antes dos textos: guarda e mostra quando eles chegarem
function renderStage() {
    const stages = isObject(ui.stages) ? ui.stages : {};
    if (typeof stages[stage] === "string") $("#stage").textContent = stages[stage];
}

const handlers = {
    loadProgress: (data) => setProgress(data.loadFraction),
    startInitFunctionOrder: (data) => {
        stage = data.type;
        renderStage();
    },
    almLoadscreen: (data) => apply(data.data),
};

// defensivo: se o FiveM passar a reenviar o handover por mensagem, aceita o pedaço deste resource
function handoverIn(message) {
    for (const blob of [message, message.data, message.handoverData]) {
        if (isObject(blob) && isObject(blob.almLoadscreen)) return blob.almLoadscreen;
    }
    return null;
}

window.addEventListener("message", (event) => {
    let message = event.data;
    if (typeof message === "string") {
        try {
            message = JSON.parse(message);
        } catch (error) {
            return;
        }
    }
    if (!isObject(message)) return;
    const handler = handlers[message.eventName];
    if (handler) handler(message);
    else if (!applied) apply(handoverIn(message));
});

// ───────── relógio ─────────

const clock = (function () {
    let lang;
    let timer = null;

    function format(now, method, options) {
        try {
            return now[method](lang, options);
        } catch (error) {
            // idioma que o navegador não conhece: usa o do computador
            return now[method](undefined, options);
        }
    }

    function tick() {
        const now = new Date();
        $("#clock").textContent = format(now, "toLocaleTimeString", { hour: "2-digit", minute: "2-digit" });
        $("#date").textContent = format(now, "toLocaleDateString", { weekday: "long", day: "2-digit", month: "long" });
    }

    function start() {
        tick();
        if (!timer) timer = setInterval(tick, 15000);
    }

    start();
    return {
        // chamado uma vez, quando os dados chegam: idioma do locale, ou desligado no config
        configure(newLang, on) {
            lang = newLang || undefined;
            if (on) return start();
            clearInterval(timer);
            timer = null;
        },
    };
})();

// ───────── brilhos subindo ─────────

const sparks = (function () {
    const canvas = $("#sparks");
    const ctx = canvas.getContext("2d");
    let colors = [];
    let width = 0;
    let height = 0;
    let running = true;
    const dots = [];

    function readColors() {
        const styles = getComputedStyle(document.documentElement);
        colors = [styles.getPropertyValue("--accent").trim(), styles.getPropertyValue("--text").trim()];
    }
    readColors();

    function resize() {
        width = canvas.width = window.innerWidth;
        height = canvas.height = window.innerHeight;
    }
    resize();
    window.addEventListener("resize", resize);

    function spawn(anywhere) {
        return {
            x: Math.random() * width,
            y: anywhere ? Math.random() * height : height + 10,
            r: 0.6 + Math.random() * 2.2,
            speed: 0.15 + Math.random() * 0.55,
            drift: (Math.random() - 0.5) * 0.3,
            alpha: 0.15 + Math.random() * 0.55,
            phase: Math.random() * Math.PI * 2,
        };
    }
    for (let i = 0; i < 70; i++) dots.push(spawn(true));

    let last = 0;

    // ~30 quadros por segundo bastam para brilhos lentos e deixam a placa de vídeo para o jogo
    function frame(time) {
        if (!running) return;
        requestAnimationFrame(frame);
        if (time - last < 33) return;
        last = time;
        ctx.clearRect(0, 0, width, height);
        for (let i = 0; i < dots.length; i++) {
            const dot = dots[i];
            dot.y -= dot.speed;
            dot.x += dot.drift + Math.sin(time / 1800 + dot.phase) * 0.15;
            if (dot.y < -10) dots[i] = spawn(false);
            ctx.globalAlpha = dot.alpha * (0.6 + 0.4 * Math.sin(time / 700 + dot.phase)) * (i % 4 === 0 ? 0.6 : 1);
            ctx.fillStyle = i % 4 === 0 ? colors[1] : colors[0];
            ctx.beginPath();
            ctx.arc(dot.x, dot.y, dot.r, 0, Math.PI * 2);
            ctx.fill();
        }
    }
    requestAnimationFrame(frame);

    return {
        // chamado uma vez, quando os dados chegam: cores do tema, ou desligado no config
        configure(on) {
            if (on) return readColors();
            running = false;
            window.removeEventListener("resize", resize);
            canvas.classList.add("hidden");
        },
    };
})();

// ───────── cartões e dicas ─────────

function fillCard(selector, part, rows, build) {
    const items = rows.filter((row) => row !== null);
    const card = $(selector).closest(".card");
    if (!items.length) {
        card.classList.add("hidden");
        return;
    }
    for (const row of items) $(selector).appendChild(build(row));
    card.classList.toggle("hidden", !enabled(part));
}

function fillCards() {
    fillCard(
        "#keys",
        "keys",
        list(ui.keys).map((row) => (Array.isArray(row) && row.length >= 2 ? [String(row[0]), String(row[1])] : null)),
        ([key, label]) => {
            const item = document.createElement("li");
            const cap = document.createElement("span");
            cap.className = "key";
            cap.textContent = key;
            item.append(cap, document.createTextNode(label));
            return item;
        },
    );

    fillCard(
        "#news",
        "news",
        list(ui.news).map((row) => (typeof row === "string" ? row : null)),
        (row) => {
            const item = document.createElement("li");
            item.textContent = row;
            return item;
        },
    );
}

function startTips(seconds) {
    const rows = list(ui.tips).filter((row) => typeof row === "string");
    if (!enabled("tips") || !rows.length) return;
    const tip = $("#tip");
    let index = Math.floor(Math.random() * rows.length);

    function next() {
        tip.classList.remove("show");
        setTimeout(() => {
            tip.textContent = rows[index % rows.length];
            index += 1;
            tip.classList.add("show");
        }, 350);
    }
    next();
    if (rows.length > 1) setInterval(next, Math.max(3, Number(seconds) || 7) * 1000);
}

// ───────── player de música ─────────

function startPlayer(data) {
    if (!enabled("music")) return;

    const playlist = list(data.music)
        .map((track) => (isObject(track) && safeUrl(track.file, "music") ? track : null))
        .filter((track) => track !== null);
    const audio = new Audio();
    const ICON_PLAY = "M7 4v16l13-8z";
    const ICON_PAUSE = "M6 4h4v16H6zM14 4h4v16h-4z";
    const STORAGE = "alm_loadscreen_volume";

    let index = Math.floor(Math.random() * Math.max(1, playlist.length));
    let playing = false;
    let ambient = null;

    function savedVolume() {
        try {
            const stored = localStorage.getItem(STORAGE);
            if (stored !== null && Number.isFinite(Number(stored))) return Number(stored);
        } catch (error) {
            // sem armazenamento: usa o padrão
        }
        const initial = Number(data.volume);
        return Number.isFinite(initial) ? initial : 25;
    }

    let volume = Math.max(0, Math.min(100, savedVolume()));
    $("#volume").value = volume;

    // Sem músicas na lista, um acorde lento feito na hora mantém a tela com som.
    function createAmbient() {
        const context = new (window.AudioContext || window.webkitAudioContext)();
        const master = context.createGain();
        const filter = context.createBiquadFilter();
        filter.type = "lowpass";
        filter.frequency.value = 700;
        master.gain.value = 0;
        filter.connect(master);
        master.connect(context.destination);

        const chords = [
            [110, 164.81, 196, 261.63],
            [87.31, 130.81, 174.61, 220],
            [130.81, 164.81, 196, 246.94],
            [98, 146.83, 196, 246.94],
        ];
        const voices = chords[0].map((frequency, voice) => {
            const oscillator = context.createOscillator();
            const gain = context.createGain();
            oscillator.type = voice % 2 ? "triangle" : "sawtooth";
            oscillator.frequency.value = frequency;
            oscillator.detune.value = (voice - 1.5) * 7;
            gain.gain.value = 0.16;
            oscillator.connect(gain);
            gain.connect(filter);
            oscillator.start();
            return oscillator;
        });

        let step = 0;
        let timer = null;
        function change() {
            step = (step + 1) % chords.length;
            voices.forEach((oscillator, voice) => {
                oscillator.frequency.linearRampToValueAtTime(chords[step][voice], context.currentTime + 3);
            });
            filter.frequency.linearRampToValueAtTime(500 + Math.random() * 500, context.currentTime + 6);
        }

        return {
            setVolume(value) {
                master.gain.linearRampToValueAtTime(value, context.currentTime + 0.4);
            },
            resume() {
                if (!timer) timer = setInterval(change, 8000);
                context.resume();
            },
            suspend() {
                clearInterval(timer);
                timer = null;
                context.suspend();
            },
        };
    }

    function applyVolume() {
        audio.volume = volume / 100;
        if (ambient) ambient.setVolume(playing ? (volume / 100) * 0.5 : 0);
    }

    function render() {
        const track = playlist[index];
        $("#track-title").textContent = track ? String(track.title || "") : text("ambient_title");
        $("#track-artist").textContent = track ? String(track.artist || "") : "";
        $("#play-icon").setAttribute("d", playing ? ICON_PAUSE : ICON_PLAY);
        $("#eq").classList.toggle("on", playing);
    }

    function start() {
        playing = true;
        if (playlist.length) {
            const track = playlist[index];
            if (audio.dataset.file !== track.file) {
                audio.src = track.file;
                audio.dataset.file = track.file;
            }
            audio.play().catch(() => {
                playing = false;
                render();
            });
        } else {
            if (!ambient) ambient = createAmbient();
            ambient.resume();
        }
        applyVolume();
        render();
    }

    function pause() {
        playing = false;
        audio.pause();
        applyVolume();
        // o som ambiente para de verdade depois de o volume descer
        if (ambient) setTimeout(() => { if (!playing) ambient.suspend(); }, 500);
        render();
    }

    function skip(direction) {
        if (!playlist.length) return;
        index = (index + direction + playlist.length) % playlist.length;
        $("#seek").style.transform = "scaleX(0)";
        start();
    }

    let failures = 0;
    audio.addEventListener("playing", () => { failures = 0; });
    audio.addEventListener("ended", () => skip(1));
    audio.addEventListener("error", () => {
        // arquivo faltando: tenta o próximo; se todos faltarem, para em vez de girar para sempre
        failures += 1;
        if (playlist.length > 1 && failures < playlist.length) skip(1);
        else pause();
    });
    audio.addEventListener("timeupdate", () => {
        if (audio.duration) $("#seek").style.transform = `scaleX(${audio.currentTime / audio.duration})`;
    });

    $("#play").addEventListener("click", () => (playing ? pause() : start()));
    $("#next").addEventListener("click", () => skip(1));
    $("#prev").addEventListener("click", () => skip(-1));
    $("#volume").addEventListener("input", (event) => {
        volume = Number(event.target.value);
        applyVolume();
    });
    // grava só ao soltar o controle, não a cada passo do arraste
    $("#volume").addEventListener("change", () => {
        try {
            localStorage.setItem(STORAGE, String(volume));
        } catch (error) {
            // sem armazenamento: vale só para esta sessão
        }
    });
    document.addEventListener("keydown", (event) => {
        if (event.code === "Space") playing ? pause() : start();
    });

    if (playlist.length < 2) $("#player").classList.add("single");
    render();
    start();
}

// ───────── dados: aplicados uma vez só ─────────

// true se aplicou agora; false se já tinha aplicado ou se o que chegou não serve
function apply(data) {
    if (applied || !isObject(data) || !isObject(data.locale)) return false;
    applied = true;
    ui = data.locale;
    show = isObject(data.show) ? data.show : {};

    applyTheme(data.theme);
    for (const el of document.querySelectorAll("[data-text]")) el.textContent = text(el.dataset.text);
    for (const el of document.querySelectorAll("[data-title]")) el.title = text(el.dataset.title);
    for (const el of document.querySelectorAll("[data-part]")) el.classList.toggle("hidden", !enabled(el.dataset.part));
    if (text("lang")) document.documentElement.lang = text("lang");
    renderStage();

    const serverName = typeof data.serverName === "string" ? data.serverName : "";
    document.title = serverName;
    $("#brand-name").textContent = serverName;

    const logo = safeUrl(data.logo, "img");
    if (logo) {
        for (const img of [$("#brand-logo"), $("#emblem")]) {
            img.addEventListener("error", () => img.classList.add("hidden"));
            img.src = logo;
            img.classList.remove("hidden");
        }
    } else if (serverName) {
        $("#center-name").textContent = serverName;
        $("#center-name").classList.remove("hidden");
    }

    const background = safeUrl(data.background, "img");
    if (background) $("#backdrop").style.backgroundImage = `url("${background}")`;

    clock.configure(text("lang"), enabled("clock"));
    sparks.configure(enabled("sparks"));
    fillCards();
    startTips(data.tipSeconds);
    startPlayer(data);
    return true;
}

// ───────── fontes dos dados ─────────

function fromHandover() {
    const handover = window.nuiHandoverData;
    return isObject(handover) ? handover.almLoadscreen : null;
}

if (!apply(fromHandover())) {
    // o handover pode chegar depois de a página abrir: olha de novo por um tempo
    const since = Date.now();
    const poll = setInterval(() => {
        if (applied || apply(fromHandover()) || Date.now() - since >= HANDOVER_WAIT) clearInterval(poll);
    }, HANDOVER_STEP);
}
