
function GNLib.DrawRectGradient( x, y, w, h, c1, c2, vertical )
    vertical = vertical or false

    if not vertical then
        for i = 0, w do
            surface.SetDrawColor( GNLib.LerpColor( i / w, c1, c2 ) )
            surface.DrawLine( x + i, y, x + i, y + h )
        end
    else
        for i = 0, h do
            surface.SetDrawColor( GNLib.LerpColor( i / h, c1, c2 ) )
            surface.DrawLine( x, y + i, x + w, y + i )
        end
    end
end

function GNLib.DrawRadialGradient( x, y, r, c1, c2 )
    for i = 0, r do
        surface.DrawCircle( x, y, i, GNLib.LerpColor( i / r, c1, c2 ) )
    end
end