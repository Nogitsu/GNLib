
function GNLib.CreateFont( name, font, size, options )
    local name = ( name or "NewFont" ) .. size
    local options = options or {}
    options.size = size
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