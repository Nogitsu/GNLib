
function GNLib.IsInCircle( x, y, circle_x, circle_y, circle_radius )
    local in_circle = math.sqrt( ( x - circle_x ) ^ 2 + (  y - circle_y ) ^ 2 ) 
    return in_circle <= circle_radius
end