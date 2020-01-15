function GNLib.CreateFont( name, font, size, options, noscale )
    local name = ( name or "NewFont" ) .. size
    local options = options or {}
    options.size = noscale and size or ScreenScale( size / 2.5 )
    options.font = font
    
    surface.CreateFont( name, options )
    return name
end

function GNLib.CreateFonts( name, font, sizes, options, noscale )
    local names = {}
    for k, v in pairs( sizes ) do
        table.insert( names, GNLib.CreateFont( name, font, v, options, noscale ) )
    end
    return names
end

GNLib.CreateFonts( "GNLFont", "Caviar Dreams", { 10, 15, 20 } )
GNLib.CreateFonts( "GNLFontB", "Caviar Dreams Bold", { 10, 13, 15, 17, 20, 40 } )