function love.conf(t)
    t.window.width = 1024                                             -- This is your game width. Scrale will read it.
    t.window.height = 768                                            -- This is your game height. Scrale will read it.
    -- Interesting: The window will scale up by one or more multipliers of 2 to fit your desktop as best as possible
    t.window.fullscreen = love._os == "Android" or love._os == "iOS" -- Fullscreen on mobile
    t.window.fullscreentype = "desktop"                              -- "desktop" fullscreen is required for scrale
    t.window.hdpi = love._os == "Android"                                -- Enable hdpi on iOS devices
end
