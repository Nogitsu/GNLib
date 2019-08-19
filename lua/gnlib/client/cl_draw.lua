
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