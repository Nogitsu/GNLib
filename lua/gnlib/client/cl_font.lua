
--- @title:
--- 	GNLib.CreateFont: <function> Create a font
--- @params:
--- 	name: <string> (default: "NewFont") Name of the font, the size will be added to the name
--- 	font: <string> Font name
--- 	size: <number> Size of the font
--- 	options: <table> (optional) All default font options, see: http://wiki.garrysmod.com/page/Structures/FontData
--- 	noscale: <boolean> (optional) If we ScreenScale the size
--- @return:
--- 	name: <string> Name of the created font
function GNLib.CreateFont( name, font, size, options, noscale )
    local name = ( name or "NewFont" ) .. size
    local options = options or {}
    options.size = noscale and size or ScreenScale( size / 2.5 )
    options.font = font
    
    surface.CreateFont( name, options )
    return name
end

--- @title:
--- 	GNLib.CreateFonts: <function> Create multiple fonts, with multiple sizes
--- @params:
--- 	name: <string> (default: "NewFont") Name of the font, the size will be added to the name
--- 	font: <string> Font name
--- 	sizes: <table> Sizes of the fonts
--- 	options: <table> (optional) All default font options, see: http://wiki.garrysmod.com/page/Structures/FontData
--- 	noscale: <boolean> (optional) If we ScreenScale the size
--- @return:
--- 	names: <table> Names of the created fonts
--- @example:
--- 	#prompt: Code from `lua/gnlib/client/cl_font.lua` : create 9 fonts including 6 bolded fonts
--- 	#code: GNLib.CreateFonts( "GNLFont", "Caviar Dreams", { 10, 15, 20 } )\nGNLib.CreateFonts( "GNLFontB", "Caviar Dreams Bold", { 10, 13, 15, 17, 20, 40 } )
--- 	#output: 
function GNLib.CreateFonts( name, font, sizes, options, noscale )
    local names = {}
    for k, v in pairs( sizes ) do
        table.insert( names, GNLib.CreateFont( name, font, v, options, noscale ) )
    end
    return names
end

GNLib.CreateFonts( "GNLFont", "Caviar Dreams", { 10, 12, 15, 20 } )
GNLib.CreateFonts( "GNLFontB", "Caviar Dreams Bold", { 10, 13, 15, 17, 20, 40 } )

GNLib.registered_fonts = GNLib.registered_fonts or {}
function GNLib.RegisterFont( font, settings )
    if GNLib.registered_fonts[ font ] then return end

    settings = settings or {}
    settings.size = 255
    settings.font = font

    surface.CreateFont( "GNLib:Scale:" .. font, settings )

    GNLib.registered_fonts[ font ] = true
end

function GNLib.DrawScaledText( text, font, x, y, scale, color )
    if not GNLib.registered_fonts[ font ] then GNLib.Error( "Trying to use unregistered font '" .. font .. "'" ) return end

    local mat = Matrix()

    scale = scale / 255

	mat:Translate( Vector( x, y ) )
    mat:Scale( Vector( scale, scale, scale ) )
    
    render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	cam.PushModelMatrix( mat )
		surface.SetFont( "GNLib:Scale:" .. font )
		surface.SetTextColor( color or color_white )
		surface.SetTextPos( 0, 0 )
		surface.DrawText( text or "" )
    cam.PopModelMatrix()
    
    render.PopFilterMag()
	render.PopFilterMin()
end