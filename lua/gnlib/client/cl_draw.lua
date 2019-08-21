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

function GNLib.DrawRadialGradient( x, y, r, c1, c2 )
    for i = 0, r do
        surface.DrawCircle( x, y, i, GNLib.LerpColor( i / r, c1, c2 ) )
    end
end

--  > Polygones
function GNLib.DrawTriangle( center_x, center_y, side1_w, side2_w, side3_w, color )
    local poly = {}
    /*table.insert( poly, { x = center_x - side1_w / 2, y = center_y + side2_w / 2 } )
    table.insert( poly, { x = center_x + side1_w / 2, y = center_y + side2_w / 2 } )
    table.insert( poly, { x = center_x, y = center_y - side2_w / 2 } )*/
    poly = {
    { x = 100, y = 200 },
	{ x = 150, y = 100 },
	{ x = 200, y = 200 } }
    
    draw.NoTexture()
    surface.SetDrawColor( color or color_white )
    surface.DrawPoly( poly )

    return poly
end

--  > Shadowed drawing
function GNLib.SimpleTextShadowed( text, font, x, y, color, align_x, align_y, shadow_x, shadow_y, shadow_color )
    --  > Shadow
    draw.SimpleText( text, font, x + (shadow_x or 1), y + (shadow_y or 1), shadow_color or color_black, align_x, align_y )

    --  > Text
    draw.SimpleText( text, font, x, y, color, align_x, align_y )
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

    draw.RoundedBox( 0, x + h / 2, y, w - h + 2, h, color or color_white )
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

function GNLib.DrawLine( x, y, target_x, target_y, thick, color )
    surface.SetDrawColor( color or color_white )
    for i = 0, thick - 1 do
        surface.DrawLine( x - i, y - i, target_x - i, target_y - i )
    end
end

function GNLib.DrawOutlinedElipse( x, y, w, h, thick, color )
    GNLib.DrawOutlinedCircle( x + h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, thick, 90, -90, color )
    GNLib.DrawOutlinedCircle( x + w - h / 2, y + h / 2 + (y == 0 and 0 or - .5), h / 2, thick, -90, 90, color )

    GNLib.DrawLine( x + h / 2, y - 1, x + w - h / 3.5, y - 1, thick, color or color_white )
    GNLib.DrawLine( x + h / 2, y + h - 2 + thick, x + w - h / 3.5, y + h - 2 + thick, thick, color or color_white )
end