--  > Gradient functions
--- @title:
---     GNLib.DrawRectGradient: <function> Draw a rectangle gradient from multiple colors vertically or horizontally
--- @params:
---     x: <number> X position
---     y: <number> Y position
---     w: <number> Width
---		h: <number> Height
---		vertical: <bool> Whenever the gradient is vertical or horizontal
---		colors: <varargs> Colors of the gradient
--- @example:
--- 	#prompt: Draw a rectangular gradient of white, red and orange colors at the center of your screen.
--- 	#code: hook.Add( "HUDPaint", "GNLib:Test", function()\n\tGNLib.DrawRectGradient( ScrW() / 2, ScrH() / 2, 200, 50, false, color_white, GNLib.Colors.Alizarin, GNLib.Colors.Carrot )\nend )
--- 	#output: https://media.discordapp.net/attachments/615186050423324674/700382809876856862/unknown.png
function GNLib.DrawRectGradient( x, y, w, h, vertical, ... )
	vertical = vertical or false

	local colors = { ... }
	local current_index = 0

	local last_color, next_color
	local function change_to_next_color()
		if current_index >= #colors then return end

		current_index = current_index + 1
		last_color = colors[current_index]
		next_color = colors[current_index + 1] or colors[current_index]
	end

	local change_color = math.ceil( ( vertical and h or w ) / ( #colors - 1 ) )
	for i = 0, vertical and h or w do
		if i % change_color == 0 then change_to_next_color() end

		surface.SetDrawColor( GNLib.LerpColor( ( i % change_color ) / change_color, last_color, next_color ) )
		surface.DrawLine( vertical and x or x + i, vertical and y + i or y, vertical and x + w or x + i, vertical and y + i or y + h )
	end
end

--- @title:
---     GNLib.DrawRadialGradient: <function> Draw a circle gradient from two colors
---	@note:
---		This function is very expensive in performance
--- @params:
---     x: <number> X position
---     y: <number> Y position
---     r: <number> Radius
---		color1: <Color> First color of the gradient
---		color2: <Color> Second color of the gradient
local surface_DrawCircle = surface.DrawCircle
local GNLib_LerpColor = GNLib.LerpColor
function GNLib.DrawRadialGradient( x, y, r, color1, color2 )
	for i = 0, r do
		surface_DrawCircle( x, y, i, GNLib_LerpColor( i / r, color1, color2 ) )
	end
end

--  > Polygones
--- @title:
---     GNLib.DrawTriangle: <function> Draw a triangle from centers and side size
--- @params:
---     center_x: <number> X position
---     center_y: <number> Y position
---     size_side: <number> Size 
---     color: <Color> Color of the triangle
---     dir: <number> Direction of the triangle (0, 1, 2, 3)
function GNLib.DrawTriangle( center_x, center_y, side_size, color, dir )
	local poly
	if dir == 0 then
		poly = 
		{
			{ x = center_x, y = center_y - side_size / 2 },
				{ x = center_x + side_size / 2, y = center_y + side_size / 2 },
			{ x = center_x - side_size / 2, y = center_y + side_size / 2 },
		}
	elseif dir == 1 then
		poly = 
		{
			{ x = center_x - side_size / 2 + 1, y = center_y - side_size / 2 },
				{ x = center_x + side_size / 2 + 1, y = center_y  },
			{ x = center_x - side_size / 2 + 1, y = center_y + side_size / 2 },
		}
	elseif dir == 2 then
		poly = 
		{
			{ x = center_x - side_size / 2, y = center_y - side_size / 2 + 1 },
				{ x = center_x + side_size / 2, y = center_y - side_size / 2 + 1 },
			{ x = center_x, y = center_y + side_size / 2 + 1 },
		}
	else
		poly = 
		{
			{ x = center_x + side_size / 2 - 1, y = center_y - side_size / 2 },
				{ x = center_x + side_size / 2 - 1, y = center_y + side_size / 2 },
			{ x = center_x - side_size / 2 - 1, y = center_y },
		}
	end

	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawPoly( poly )

	return poly
end

--- @title:
---     GNLib.DrawTriangleRectangle: <function> Draw a triangle rectangle from size and pos
--- @params:
---     x: <number> X position
---     y: <number> Y position
---     w: <number> Width (size)
---     h: <number> Height (size)
---     pos: <number> Position (0, 1, 2, 3)
function GNLib.DrawTriangleRectangle( x, y, w, h, pos )
	local points

	if pos == 0 then
		points = {
			{ x = x, y = y },
			{ x = x + w, y = y },
			{ x = x + w, y = y + h },
		}
	elseif pos == 1 then
		points = {
			{ x = x, y = y + h },
			{ x = x + w, y = y },
			{ x = x + w, y = y + h },
		}
	elseif pos == 2 then
		points = {
			{ x = x, y = y },
			{ x = x + w, y = y + h },
			{ x = x, y = y + h },
		}
	else
		points = {
			{ x = x, y = y },
			{ x = x + w, y = y },
			{ x = x, y = y + h },
		}
  	end
  
	draw.NoTexture()
	surface.DrawPoly( points )

	return {
		A = w,
		B = h,
		C = math.sqrt( w ^ 2 + h ^ 2 )
	}
end

--	> Stencil
--- @title:
---     GNLib.DrawStencil: <function> Draw a stencil mask from a shape drawing function and the drawing function
--- @params:
---     shape_draw_func: <function> Shape of the mask drawing function (limit of the drawing function)
---     draw_func: <function> Draw function
function GNLib.DrawStencil( shape_draw_func, draw_func )
    if IsValid( halo.RenderedEntity() ) then return end

	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	shape_draw_func()

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	draw_func()

	render.SetStencilEnable( false )
	render.ClearStencil()
end	

--  > Material
--- @title:
--- 	GNLib.DrawMaterial: <function> Draw a material with given coordinates
--- @params:
--- 	mat: <Material> Material which will be drawn, remember to keep it in a variable outside of a hook/function called every frame
--- 	x: <number> X position
--- 	y: <number> Y position
--- 	w: <number> Width 
--- 	h: <number> Height
--- 	color: <Color> (optional) Color of the material
--- 	ang: <number> (optional) Angle of the material
--- @example:
--- 	#prompt: Draw a default avatar on the screen at coordinates 0, 0
--- 	#code: local avatar = Material( "vgui/avatar_default", "smooth" )\n\nhook.Add( "HUDPaint", "GNLib:DrawDefaultAvatar", function()\n\tGNLib.DrawMaterial( avatar, 0, 0, 256, 256 )\nend )
--- 	#output: 
function GNLib.DrawMaterial( mat, x, y, w, h, color, ang )
	surface.SetDrawColor( color or color_white )
	surface.SetMaterial( mat )

	if ang then
		surface.DrawTexturedRectRotated( x, y, w, h, ang )
	else
		surface.DrawTexturedRect( x, y, w, h )
	end
end

--  > Shadowed drawing
function GNLib.SimpleTextShadowed( text, font, x, y, color, align_x, align_y, shadow_x, shadow_y, shadow_color )
	--  > Shadow
	draw.SimpleText( text, font, x + (shadow_x or 1), y + (shadow_y or 1), shadow_color or color_black, align_x or TEXT_ALIGN_CENTER, align_y or TEXT_ALIGN_CENTER )

	--  > Text
	draw.SimpleText( text, font, x, y, color or color_white, align_x or TEXT_ALIGN_CENTER, align_y or TEXT_ALIGN_CENTER )
end

function GNLib.DrawShadowedIcon( x, y, mat_w, mat_h, mat, color, shadow_x, shadow_y, shadow_color )
	surface.SetMaterial( mat )

	--  > Shadow
	surface.SetDrawColor( shadow_color or color_black )
	surface.DrawTexturedRect( x + (shadow_x or 1), y + (shadow_y or 1), mat_w, mat_h )

	-- > Icon
	surface.SetDrawColor( color or color_white )
	surface.DrawTexturedRect( x, y, mat_w, mat_h )
end

--   > Drawing icons + text
function GNLib.DrawIconText( text, font, x, y, color, mat, mat_w, mat_h, mat_color, other_side )
	local text_w = GNLib.GetTextSize( text, font )

	GNLib.DrawMaterial( mat, x + ( other_side and (text_w + 5) or 0 ), y, mat_w, mat_h, mat_color )

	draw.SimpleText( text, font, x + ( other_side and 0 or (mat_w + 5) ), y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function GNLib.DrawIconTextOutlined( text, font, x, y, color, mat, mat_w, mat_h, mat_color, outline_color, outline_w, other_side )
	local text_w = GNLib.GetTextSize( text, font )

	GNLib.DrawMaterial( mat, x + ( other_side and (text_w + 5) or 0 ), y, mat_w, mat_h, mat_color )

	draw.SimpleTextOutlined( text, font, x + ( other_side and 0 or (mat_w + 5) ), y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, outline_w or .5, outline_color or Color( 0, 0, 0 ) )
end

function GNLib.DrawIconTextShadowed( text, font, x, y, color, mat, mat_w, mat_h, shadow_x, shadow_y, shadow_color, other_side )
	local text_w = GNLib.GetTextSize( text, font )

	GNLib.DrawShadowedIcon( x + ( other_side and (text_w + 5) or 0 ), y, mat_w, mat_h, mat, color_white, shadow_x, shadow_y, shadow_color )

	GNLib.SimpleTextShadowed( text, font, x + ( other_side and 0 or (mat_w + 5) ), y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, shadow_x, shadow_y, shadow_color )
end

--  > Draw filled circle
--- @title:
--- 	GNLib.DrawCircle: <function> Draw a circle with given coordinates, radius and angles
--- @params:
--- 	x: <number> X position
--- 	y: <number> Y position
--- 	radius: <number> Radius of circle
--- 	angle_start: <number> (optional) Start angle of circle
--- 	angle_end: <number> (optional) End angle of circle
--- 	color: <Color> (optional) Color of circle
--- @example:
--- 	#prompt: Draw a white half-circle of radius 100px on middle of the screen
--- 	#code: hook.Add( "HUDPaint", "GNLib:DrawCircle", function()\n\tGNLib.DrawCircle( ScrW() / 2, ScrH() / 2, 100, 0, 180 )\nend )
--- 	#output: 
function GNLib.DrawCircle( x, y, radius, angle_start, angle_end, color )
	local poly = {}
	angle_start = angle_start or 0
	angle_end   = angle_end   or 360
	
	poly[1] = { x = x, y = y }
	for i = math.min( angle_start, angle_end ), math.max( angle_start, angle_end ) do
		local a = math.rad( i )
		if angle_start < 0 then
			poly[#poly + 1] = { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius }
		else
			poly[#poly + 1] = { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius }
		end
	end
	poly[#poly + 1] = { x = x, y = y }

	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawPoly( poly )

	return poly
end

--  > Draw ellipse with half-circle
--- @title:
--- 	GNLib.DrawElipse: <function> Draw an elipse with given coordinates
--- @params:
--- 	x: <number> X position
--- 	y: <number> Y position
--- 	w: <number> Width
--- 	h: <number> Height
--- 	color: <Color> (optional) Color of circle
--- 	hide_left: <boolean> (optional) Show or not the left part
--- 	hide_right: <boolean> (optional) Show or not the right part
--- @example:
--- 	#prompt: Draw a centered red elipse
--- 	#code: local W, H = 100, 25\n\nhook.Add( "HUDPaint", "GNLib:DrawCircle", function()\n\tGNLib.DrawElipse( ScrW() / 2 - W / 2, ScrH() / 2 - H / 2, W, H, GNLib.Colors.Alizarin )\nend )
--- 	#output: 
function GNLib.DrawElipse( x, y, w, h, color, hide_left, hide_right )
	surface.SetDrawColor( color or color_white )

	if hide_left then
		surface.DrawRect( x, y, h / 2, h )
	else
		GNLib.DrawCircle( x + h / 2, y + h / 2, h / 2, 90, -90, color )
	end
	if hide_right then
		surface.DrawRect( x + w - h / 2, y, h / 2, h )
	else
		GNLib.DrawCircle( x + w - h / 2, y + h / 2, h / 2, -90, 90, color )
	end

	surface.DrawRect( x + h / 2, y, w - h + 2, h )
end

--  > Shears
function GNLib.DrawShearedRect( x, y, w, h, ang )
	local a = h * math.sin( math.rad( ang ) )
	local points = {
		{ x = x + a, y = y },
		{ x = x + w, y = y },
		{ x = x + w - a, y = y + h },
		{ x = x, y = y + h }
	}

	draw.NoTexture()
	surface.DrawPoly( points )

	return {
		A = a,
		B = h,
		C = math.sqrt( a^2 + h^2 )
	}
end

function GNLib.DrawRightShearedRect( x, y, w, h, ang )
	local a = h * math.sin( math.rad( ang ) )
	local points = {
		{ x = x, y = y },
		{ x = x + w, y = y },
		{ x = x + w - a, y = y + h },
		{ x = x, y = y + h }
	}

	draw.NoTexture()
	surface.DrawPoly( points )

	return {
		A = a,
		B = h,
		C = math.sqrt( a^2 + h^2 )
	}
end

function GNLib.DrawLeftShearedRect( x, y, w, h, ang )
	local a = h * math.sin( math.rad( ang ) )
	local points = {
		{ x = x + a, y = y },
		{ x = x + w, y = y },
		{ x = x + w, y = y + h },
		{ x = x, y = y + h }
	}

	draw.NoTexture()
	surface.DrawPoly( points )

	return {
		A = a,
		B = h,
		C = math.sqrt( a^2 + h^2 )
	}
end

function GNLib.DrawShearedElipse( x, y, w, h, tri_w, left )
	local color = surface.GetDrawColor()

	if left then
		GNLib.DrawTriangleRectangle( x, y, tri_w, h, 1 )
		GNLib.DrawElipse( x - h / 2 + tri_w, y, w + h / 2 - tri_w, h, color, true, false )
	else
		GNLib.DrawTriangleRectangle( x + w - tri_w, y, tri_w, h )
		GNLib.DrawElipse( x, y, w + h / 2 - tri_w, h, color, false, true )
	end
end

--  > Draw outlined
function GNLib.DrawOutlinedBox( x, y, w, h, thick, color )
	surface.SetDrawColor( color or color_white )
	for i = 0, thick - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end


--- @title:
--- 	GNLib.DrawOutlinedCircle: <function> Draw an outlined circle with given coordinates, radius, thickness and angles
--- @params:
--- 	x: <number> Origin's X
--- 	y: <number> Origin's Y
--- 	radius: <number> Radius of the circle
--- 	thick: <number> Thickness of the circle
--- 	angle_start: <number> (optional) Start angle of the circle
--- 	angle_end: <number> (optional) End angle of the circle
--- 	color: <Color> (optional) Color of the circle
--- @example:
--- 	#prompt: Draw a white half-circle of radius 100px and thickness 10px on middle of the screen
--- 	#code: hook.Add( "HUDPaint", "GNLib:DrawOutlinedCircle", function()\n\tGNLib.DrawCircle( ScrW() / 2, ScrH() / 2, 100, 0, 180 )\nend )\n
--- 	#output: 
function GNLib.DrawOutlinedCircle( x, y, radius, thick, angle_start, angle_end, color )
    local start = math.rad( angle_start )
    local last_ox, last_oy = x - math.cos( start ) * radius, y - math.sin( start ) * radius
    local last_ix, last_iy = x - math.cos( start ) * ( radius - thick ), y - math.sin( start ) * ( radius - thick )

    for i = math.min( angle_start or 0, angle_end or 360 ), math.max( angle_start or 0, angle_end or 360 ) do
        local a = math.rad( i )

        local ox, oy = x - math.cos( a ) * radius, y - math.sin( a ) * radius
        local ix, iy = x - math.cos( a ) * ( radius - thick ), y - math.sin( a ) * ( radius - thick )
        
        draw.NoTexture()
        surface.SetDrawColor( color or color_white )
        surface.DrawPoly( {
            { x = last_ox, y = last_oy },
            { x = ox, y = oy },
            { x = ix, y = iy },
            { x = last_ix, y = last_iy },
        } )

        last_ox, last_oy = ox, oy
        last_ix, last_iy = ix, iy
    end
end

function GNLib.DrawGradientOutlinedCircle( x, y, radius, thick, angle_start, angle_end, color1, color2 )
	color1 = color1 or GNLib.Colors.MidnightBlue
	color2 = color2 or GNLib.Colors.WetAsphalt

    local start = math.rad( angle_start )
    local last_ox, last_oy = x - math.cos( start ) * radius, y - math.sin( start ) * radius
    local last_ix, last_iy = x - math.cos( start ) * ( radius - thick ), y - math.sin( start ) * ( radius - thick )

    for i = math.min( angle_start or 0, angle_end or 360 ), math.max( angle_start or 0, angle_end or 360 ) do
        local a = math.rad( i )

        local ox, oy = x - math.cos( a ) * radius, y - math.sin( a ) * radius
        local ix, iy = x - math.cos( a ) * ( radius - thick ), y - math.sin( a ) * ( radius - thick )
        
        draw.NoTexture()
        surface.SetDrawColor( GNLib.LerpColor( ( i - angle_start ) / ( angle_end - angle_start ), color1, color2 ) )
        surface.DrawPoly( {
            { x = last_ox, y = last_oy },
            { x = ox, y = oy },
            { x = ix, y = iy },
            { x = last_ix, y = last_iy },
        } )

        last_ox, last_oy = ox, oy
        last_ix, last_iy = ix, iy
    end
end

function GNLib.DrawLine( x, y, target_x, target_y, color )
	surface.SetDrawColor( color or color_white )
	surface.DrawLine( x, y, target_x, target_y )
end

function GNLib.DrawOutlinedElipse( x, y, w, h, thick, color )
	GNLib.DrawOutlinedCircle( x + h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, thick, 90, -90, color )
	GNLib.DrawOutlinedCircle( x + w - h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, thick, -90, 90, color )

	surface.DrawRect( x + h / 2, y - thick, w - h + 1, thick, color or color_white )
	surface.DrawRect( x + h / 2, y + h, w - h + 1, thick, color or color_white )
	--surface.DrawRect( x + h / 2, y + h - 2 + thick, x + w - h / 3.5, y + h - 2 + thick, thick, color or color_white )
end

function GNLib.DrawOutlinedRoundedRect( corner_radius, x, y, w, h, thick, color )
	surface.SetDrawColor( color or color_white )

	local pos_thick = math.floor( thick / 2 )

	surface.DrawRect( x + corner_radius, y + pos_thick / 2, w - corner_radius * 2 + 1, thick )
	surface.DrawRect( x + corner_radius, y + h - thick, w - corner_radius * 2, thick )
	surface.DrawRect( x + pos_thick / 2, y + corner_radius, thick, h - corner_radius * 2 )
	surface.DrawRect( x + w - pos_thick * 2, y + corner_radius, thick, h - corner_radius * 2 )

	GNLib.DrawOutlinedCircle( x + corner_radius + pos_thick, y + corner_radius + pos_thick, corner_radius + thick / 2, thick, 0, 90, color ) --  > Top-Left
	GNLib.DrawOutlinedCircle( x + w - corner_radius - pos_thick, y + corner_radius + pos_thick, corner_radius + thick / 2, thick, -270, -180, color ) --  > Top-Right
	GNLib.DrawOutlinedCircle( x + corner_radius + pos_thick, y + h - 1 - corner_radius, corner_radius + thick / 2, thick, -90, 0, color ) --  > Bottom-Left
	GNLib.DrawOutlinedCircle( x + w - corner_radius - pos_thick, y + h - 1 - corner_radius, corner_radius + thick / 2, thick, 270, 180, color ) --  > Bottom-Right
end

function GNLib.DrawRoundedRect( corner_radius, x, y, w, h, color )
	surface.SetDrawColor( color or color_white )

	surface.DrawRect( x + corner_radius, y, w - corner_radius * 2, h )
	surface.DrawRect( x, y + corner_radius, corner_radius, h - corner_radius * 2 )
	surface.DrawRect( x + w - corner_radius, y + corner_radius, corner_radius, h - corner_radius * 2 )

	GNLib.DrawCircle( x + corner_radius, y + corner_radius, corner_radius, -180, -90, color )
	GNLib.DrawCircle( x + w - corner_radius, y + corner_radius, corner_radius, -90, 0, color )
	GNLib.DrawCircle( x + corner_radius, y + h - corner_radius, corner_radius, -270, -180, color )
	GNLib.DrawCircle( x + w - corner_radius, y + h - corner_radius, corner_radius, 270, 180, color )
end

local blur = Material( "pp/blurscreen" )
function GNLib.DrawBlur( x, y, w, h, amount, off_x, off_y )
	amount = amount or 6
   off_x = off_x or 0
   off_y = off_y or 0
	surface.SetDrawColor( color_white )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", i / 3 * amount )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
		surface.DrawTexturedRect( off_x, off_y, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

function GNLib.DrawBlurCircle( x, y, radius, angle_start, angle_end, amount )
	GNLib.DrawStencil( function()
		GNLib.DrawCircle( x, y, radius, angle_start, angle_end, color_white )
	end, function()
		GNLib.DrawBlur( x - radius, y - radius, radius * 2, radius * 2, amount )
	end )  
end

function GNLib.DrawRotated( x, y, w, h, rot, draw_func )
	rot = rot % 360

	local m = Matrix()
	m:SetTranslation( Vector( x + w/2, y + h/2 ) )
	m:SetAngles( Angle( 0, rot, 0 ) )
	m:Translate( -Vector( w/2, h/2 ) )

	cam.PushModelMatrix( m )
		draw_func( 0, 0, w, h )
	cam.PopModelMatrix()
end

function GNLib.DrawRectRotated( x, y, w, h, rot )
	GNLib.DrawRotated( x, y, w, h, rot, surface.DrawRect )
end

--  > Graphics
function GNLib.CircleGraph( x, y, radius, entries, show_type )
	local total = 0

	for _, v in pairs( entries ) do
		total = total + v.value
	end

	local last_angle = 0
	for i, v in pairs( entries ) do
		if not v.value or v.value == 0 then continue end

		local new_angle = last_angle + 360 * v.value / total + 1
		GNLib.DrawCircle( x, y, radius, last_angle, new_angle, v.color )

		if show_type then
			local text = ""

			if show_type == "percent" then
			text = v.value / total or "error"
			elseif show_type == "value" then
			text = v.value or "error"
			elseif show_type == "text" then
			text = v.text or v.value or "error"
			else
			text = show_type
			end

			local ang = math.rad( math.max( new_angle, last_angle ) - math.min( new_angle, last_angle ) )
			local text_x = x + math.cos( ang ) * radius / 2
			local text_y = y + math.sin( ang ) * radius / 2

			GNLib.SimpleTextShadowed( text, "GNLFontB15", text_x, text_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, _, _, color_black )
		end

		last_angle = new_angle - 1
	end
end

function GNLib.OutlinedCircleGraph( x, y, radius, thick, entries, show_type )
	local total = 0

	for _, v in pairs( entries ) do
		total = total + v.value
	end

	local last_angle = 0
	for i, v in pairs( entries ) do
		if not v.value or v.value == 0 then continue end

		local new_angle = last_angle + 360 * v.value / total + 1
		GNLib.DrawOutlinedCircle( x, y, radius, thick or 1, last_angle, new_angle, v.color )

		if show_type then
			local text = ""

			if show_type == "percent" then
			text = v.value / total or "error"
			elseif show_type == "value" then
			text = v.value or "error"
			elseif show_type == "text" then
			text = v.text or v.value or "error"
			else
			text = show_type
			end

			local ang = math.rad( math.max( new_angle, last_angle ) - math.min( new_angle, last_angle ) )
			local text_x = x + math.cos( ang ) * radius / 2
			local text_y = y + math.sin( ang ) * radius / 2

			GNLib.SimpleTextShadowed( text, "GNLFontB15", text_x, text_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, _, _, color_black )
		end

		last_angle = new_angle - 1
	end
end

function GNLib.BarGraph( x, y, w, h, space, entries, show_type, align )
	local max = 0
	space = space or 0

	for _, v in pairs( entries ) do
		max = math.max( max, v.value )
	end

	local bar_w = w / #entries

	for i, v in pairs( entries ) do
		if not v.value or v.value == 0 then continue end

		local bar_h = ( v.value / max ) * h
		local bar_x = x + ( bar_w + space ) * ( i - 1 )
		local bar_y = y + h - math.ceil( bar_h )

		surface.SetDrawColor( v.color )
		surface.DrawRect( math.ceil( bar_x ), math.ceil( bar_y ), math.ceil( bar_w ), math.ceil( bar_h ) )

		if show_type then
			local text = ""

			if show_type == "percent" then
			text = v.value / total or "error"
			elseif show_type == "value" then
			text = v.value or "error"
			elseif show_type == "text" then
			text = v.text or v.value or "error"
			else
			text = show_type
			end

			local alignments = {
			["top"] = { y = bar_y, t = TEXT_ALIGN_TOP },
			["center"] = { y = bar_y + bar_h / 2, t = TEXT_ALIGN_CENTER },
			["bottom"] = { y = bar_y + bar_h, t = TEXT_ALIGN_BOTTOM },
			}

			local text_x = bar_x + bar_w / 2
			local text_y = alignments[ align or "center" ].y or bar_y

			GNLib.SimpleTextShadowed( text, "GNLFontB15", text_x, text_y, color_white, TEXT_ALIGN_CENTER, alignments[ align or "center" ].t or TEXT_ALIGN_CENTER, _, _, color_black )
		end
	end
end

function GNLib.Curve( x, y, w, h, min_x, max_x, min_y, max_y, color, entries )
	local last_x, last_y = entries[ 1 ][ 1 ], entries[ 1 ][ 2 ]

	for _, coordinates in pairs( entries ) do
		surface.SetDrawColor( color or Color( 255, 0, 0 ) )
		surface.DrawLine( x + (last_x - min_x) / max_x * w, y + h - (last_y - min_y) / max_y * h, x + (coordinates[1] - min_x) / max_x * w, y + h - (coordinates[2] - min_y) / max_y * h )

		last_x, last_y = coordinates[1], coordinates[2]
	end
end

function GNLib.DrawFunc( x, y, w, h, min_x, max_x, min_y, max_y, interval, fx, color )
	local entries = {}

	for i = min_x, max_x, interval do
		entries[ #entries + 1 ] = { i, GNLib.CalculateF( fx, i ) }
	end

	GNLib.Curve( x, y, w, h, min_x, max_x, min_y, max_y, color, entries )
end

--  > Text
function GNLib.GetLinesSize( text )
	local lines = text:Split( "\n" )
	local last_y = 0

	local w = 0
	local h = 0

	for _, line in ipairs( lines ) do
		local line_w, line_h = surface.GetTextSize( line )

		w = math.max( w, line_w )
		h = h + line_h
	end

	return w, h
end

function GNLib.DrawLines( text, x, y )
	local lines = text:Split( "\n" )
	local last_y = 0

	x = x or 0
	y = y or 0

	for k, line in ipairs( lines ) do
		local line_h = select( 2, surface.GetTextSize( line ) )

		surface.SetTextPos( x, y + last_y )
		surface.DrawText( line )

		last_y = last_y + line_h
	end
end

--  > Gradient text
function GNLib.GradientText( text, font, x, y, align_x, align_y, color1, color2, linear )
	local lines = text:Split( "\n" )
	local drawn = {}
	local char_pos = 1

	for k, line in ipairs( lines ) do
		drawn[ k ] = ""
		for i = 1, #line do
			local char = line:sub( i, i )

			surface.SetFont( font or "GNLFontB15" )
			local last_x, _ = surface.GetTextSize( drawn[ k ] )
			local last_y = drawn[ k - 1 ] and select( 2, surface.GetTextSize( drawn[ 1 ] ) ) * (k-1) or 0

			draw.SimpleText( char, font or "GNLFontB15", x + last_x, y + last_y, GNLib.LerpColor( linear and (char_pos / #text) or (i/#line), color1, color2 ), align_x or TEXT_ALIGN_LEFT, align_y or TEXT_ALIGN_TOP )
			
			drawn[ k ] = drawn[ k ] .. char
			char_pos = char_pos + 1
		end
	end
end

function GNLib.GradientTextOutlined( text, font, x, y, align_x, align_y, color1, color2, linear, outline_w, outline_color )
	local lines = text:Split( "\n" )
	local drawn = {}
	local char_pos = 1

	for k, line in ipairs( lines ) do
		drawn[ k ] = ""
		for i = 1, #line do
			local char = line:sub( i, i )

			surface.SetFont( font or "GNLFontB15" )
			local last_x, _ = surface.GetTextSize( drawn[ k ] )
			local last_y = drawn[ k - 1 ] and select( 2, surface.GetTextSize( drawn[ 1 ] ) ) * (k-1) or 0

			draw.SimpleTextOutlined( char, font or "GNLFontB15", x + last_x, y + last_y, GNLib.LerpColor( linear and (char_pos / #text) or (i/#line), color1, color2 ), align_x or TEXT_ALIGN_LEFT, align_y or TEXT_ALIGN_TOP, outline_w or .5, outline_color or Color( 0, 0, 0 ) )
			
			drawn[ k ] = drawn[ k ] .. char
			char_pos = char_pos + 1
		end
	end
end
