Locales['en'] = {
    update_available = 'New version available: %s (installed: %s).',
    -- warnings about config.lua values the screen ignored
    ignored_image = "%s ignored: %s. Use a file from html/img (e.g. 'img/logo.png') or an https:// address, or '' to leave it empty.",
    ignored_music = "Config.Music, track %s ignored: file %s. Use a file from html/music (e.g. file = 'music/intro.ogg') or an https:// address.",
    ignored_music_list = "Config.Music ignored (%s). Use a list: Config.Music = { { title = 'Intro', artist = 'My Band', file = 'music/intro.ogg' } }.",

    ui = {
        lang = 'en-US',        -- time and date format
        subtitle = 'Roleplay', -- below the server name
        tagline = 'Welcome to the city',
        keys_title = 'Keys',
        news_title = 'News',
        loading = 'Loading',
        now_playing = 'Now playing',
        ambient_title = 'Ambient sound',
        previous = 'Previous',
        play = 'Play or pause',
        next = 'Next',
        -- loading stages, in the order the game goes through them
        stages = {
            INIT_BEFORE_MAP_LOADED = 'Getting the city ready',
            MAP = 'Loading the map',
            INIT_AFTER_MAP_LOADED = 'Setting up the streets',
            INIT_SESSION = 'Joining the session',
        },

        -- Your server's content: change it freely. An empty list hides the card.
        keys = {
            { 'T', 'Chat' },
            { 'F1', 'Menu' },
            { 'M', 'Map' },
            { 'Z', 'Voice range' },
        },
        news = {
            'Write your server news here.',
            'Each line becomes an item on the card.',
        },
        tips = {
            'Read the server rules before you start.',
            'Questions? Ask the staff on Discord.',
            "Respect other players' stories.",
        },
    },
}
