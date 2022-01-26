local sizes = {8, 10, 12, 16, 20, 24, 36}

for _, s in pairs(sizes) do
    surface.CreateFont("StrifeSS_" .. s , {
        font = "Bahnschrift",
        size = ScreenScale(s),
        extended = true
    })
    surface.CreateFont("StrifeSS_" .. s .. "_Glow" , {
        font = "Bahnschrift",
        size = ScreenScale(s),
        antialias = true,
        blursize = 12,
        extended = true,
    })
end