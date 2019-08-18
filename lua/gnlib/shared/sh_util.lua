function GNLib.LerpColor( t, c1, c2 )
    return Color( Lerp( t, c1.r, c2.r ), Lerp( t, c1.g, c2.g ), Lerp( t, c1.b, c2.b ) )
end