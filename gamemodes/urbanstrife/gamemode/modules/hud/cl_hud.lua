function GM:HUDPaint()

end

GM.HideElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true
}
function GM:HUDShouldDraw(name)
    return not GAMEMODE.HideElements[name]
end