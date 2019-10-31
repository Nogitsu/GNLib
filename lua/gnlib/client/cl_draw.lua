--  > Gradient functions
function GNLib.DrawRectGradient( x, y, w, h, color1, color2, vertical )
    vertical = vertical or false

    if not vertical then
        for i = 0, w do
            surface.SetDrawColor( GNLib.LerpColor( i / w, color1, color2 ) )
            surface.DrawLine( x + i, y, x + i, y + h )
        end
    else
        for i = 0, h do
            surface.SetDrawColor( GNLib.LerpColor( i / h, color1, color2 ) )
            surface.DrawLine( x, y + i, x + w, y + i )
        end
    end
end

local surface_DrawCircle = surface.DrawCircle
local GNLib_LerpColor = GNLib.LerpColor
function GNLib.DrawRadialGradient( x, y, r, c1, c2 )
    for i = 0, r do
        surface_DrawCircle( x, y, i, GNLib_LerpColor( i / r, c1, c2 ) )
    end
end

--  > Polygones
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
function GNLib.DrawIconText( text, font, x, y, color, mat, mat_w, mat_h, mat_color )
    surface.SetDrawColor( mat_color or color_white )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( x, y, mat_w, mat_h )

    draw.SimpleText( text, font, x + mat_w + 5, y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function GNLib.DrawIconTextOutlined( text, font, x, y, color, mat, mat_w, mat_h, mat_color, outline_color, outline_w )
    surface.SetDrawColor( mat_color or color_white )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( x, y, mat_w, mat_h )

    draw.SimpleTextOutlined( text, font, x + mat_w + 5, y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, outline_w or .5, outline_color or Color( 0, 0, 0 ) )
end

function GNLib.DrawIconTextShadowed( text, font, x, y, color, mat, mat_w, mat_h, shadow_x, shadow_y, shadow_color )
    GNLib.DrawShadowedIcon( x, y, mat_w, mat_h, mat, color_white, shadow_x, shadow_y, shadow_color )

    GNLib.SimpleTextShadowed( text, font, x + mat_w + 5, y + mat_h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, shadow_x, shadow_y, shadow_color )
end

--  > Draw filled circle
function GNLib.DrawCircle( x, y, radius, angle_start, angle_end, color )
    local poly = {}
    table.insert( poly, { x = x, y = y } )

    for i = math.min( angle_start or 0, angle_end or 360 ), math.max( angle_start or 0, angle_end or 360 ) do
        local a = math.rad( i )
        if ( angle_start or 0 ) < 0 then
            table.insert( poly, { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius } )
        else
            table.insert( poly, { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius } )
        end
    end
    table.insert( poly, { x = x, y = y } )

    draw.NoTexture()
    surface.SetDrawColor( color or color_white )
    surface.DrawPoly( poly )

    return poly
end

--  > Draw ellipse with half-circle
function GNLib.DrawElipse( x, y, w, h, color )
    GNLib.DrawCircle( x + h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, 90, -90, color )
    GNLib.DrawCircle( x + w - h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, -90, 90, color )

    draw.RoundedBox( 0, x + h / 2, y - 1, w - h + 2, h + 1, color or color_white )
end

--  > Draw outlined
function GNLib.DrawOutlinedBox( x, y, w, h, thick, color )
    surface.SetDrawColor( color or color_white )
    for i = 0, thick do
        surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
    end
end

function GNLib.DrawOutlinedCircle( x, y, radius, thick, angle_start, angle_end, color )
    surface.SetDrawColor( color or color_white )

    local corrector = 0

    local min_ang = math.min( angle_start or 0, angle_end or 360 )

    for t = 0, thick - 1 do
        local times = 0
        local last_x, last_y = x + math.cos( math.rad( min_ang ) ) + radius, y + math.sin( math.rad( min_ang ) ) + radius
        for i = min_ang, math.max( angle_start or 0, angle_end or 360 ) do
            local a = math.rad( i )
            local cur_x, cur_y = 0, 0
            if ( angle_start or 0 ) < 0 then
                cur_x = x + math.cos( a ) * ( radius + t )
                cur_y = y + math.sin( a ) * ( radius + t )
            else
                cur_x = x - math.cos( a ) * ( radius + t )
                cur_y = y - math.sin( a ) * ( radius + t )
            end
            surface.DrawLine( ( times > 0 and last_x or cur_x ), ( times > 0 and last_y or cur_y ), cur_x, cur_y )

            last_x = cur_x
            last_y = cur_y
            times = times + 1
        end
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

    surface.DrawRect( x + corner_radius, y - thick, w - corner_radius * 2 + 1, thick )
    surface.DrawRect( x + corner_radius, y + h - 1, w - corner_radius * 2, thick )
    surface.DrawRect( x - thick, y + corner_radius, thick, h - corner_radius * 2 )
    surface.DrawRect( x + w, y + corner_radius, thick, h - corner_radius * 2 )

    GNLib.DrawOutlinedCircle( x + corner_radius, y + corner_radius, corner_radius, thick, -180, -90, color )
    GNLib.DrawOutlinedCircle( x + w - corner_radius, y + corner_radius, corner_radius, thick, -90, 0, color )
    GNLib.DrawOutlinedCircle( x + corner_radius, y + h - 1 - corner_radius, corner_radius, thick, -270, -180, color )
    GNLib.DrawOutlinedCircle( x + w - corner_radius, y + h - 1 - corner_radius, corner_radius, thick, 270, 180, color )
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
