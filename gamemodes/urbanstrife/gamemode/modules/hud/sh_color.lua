GM.Colors = {
    default = Color(25, 25, 25, 220),
    empty = Color(75, 75, 75, 200),
    active = Color(0, 0, 0, 240),
    hover = Color(50, 50, 50, 240),
    empty_hover = Color(100, 100, 100, 200),

    ready = Color(50, 200, 50),
    not_ready = Color(200, 50, 50),
    ready_bot = Color(200, 200, 200),

    t = {
        [TEAM_CT] = Color(66, 104, 255),
        [TEAM_TR] = Color(255, 135, 43),
    },
    t_dark = {
        [TEAM_CT] = Color(66 - 25, 104 - 25, 255 - 25),
        [TEAM_TR] = Color(255 - 25, 135 - 25, 43 - 25),
    },
    t_light = {
        [TEAM_CT] = Color(66 + 25, 104 + 25, 255),
        [TEAM_TR] = Color(255 + 25, 135 + 25, 43 + 25),
    },
    hover_t = {
        [TEAM_CT] = Color(50, 50, 50 + 40, 220),
        [TEAM_TR] = Color(50 + 40, 50 + 20, 50, 220)},
    empty_hover_t = {
        [TEAM_CT] = Color(50, 50, 50 + 40, 200),
        [TEAM_TR] = Color(50 + 40, 50 + 20, 50, 200)},
    active_hover_t = {
        [TEAM_CT] = Color(50, 50, 50 + 40, 240),
        [TEAM_TR] = Color(50 + 40, 50 + 20, 50, 240)},

    shadow = Color(0, 0, 0, 100),

    bottombar = Color(25, 25, 25, 250),
    bottombar_hover = Color(150, 150, 150, 150),
    bottombar_press = Color(50, 50, 50, 200),
}

function GCLR(s)
    if CLIENT and not IsColor(GAMEMODE.Colors[s]) then
        return GAMEMODE.Colors[s][LocalPlayer():Team()]
    end
    return GAMEMODE.Colors[s]
end

function GCLR_UP(s)
    return GCLR(s):Unpack()
end