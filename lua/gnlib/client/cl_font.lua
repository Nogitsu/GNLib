function GNLib.CreateFont( name, font, size, options )
    local name = ( name or "NewFont" ) .. size
    local options = options or {}
    options.size = ScreenScale( size / 2.5 )
    options.font = font
    
    surface.CreateFont( name, options )
    return name
end

function GNLib.CreateFonts( name, font, sizes, options )
    local names = {}
    for k, v in pairs( sizes ) do
        table.insert( names, GNLib.CreateFont( name, font, v, options ) )
    end
    return names
end

GNLib.CreateFonts( "GNLFont", "Caviar Dreams", { 10, 15, 20 } )
GNLib.CreateFonts( "GNLFontB", "Caviar Dreams Bold", { 15, 17, 20, 40 } )