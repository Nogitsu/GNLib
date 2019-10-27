hook.Add( "HUDPaint", "TestingGraph", function()
  surface.SetDrawColor( color_white )
  surface.DrawRect( 0, 0, 750, 500 )

  local entries = {
    { value = 75, color = GNLib.Colors.Alizarin },
    { value = 12.5, color = GNLib.Colors.Wisteria },
    { value = 25, color = GNLib.Colors.BelizeHole },
    { value = 50, color = GNLib.Colors.Nephritis },
    { value = 15, color = GNLib.Colors.Orange },
  }

  GNLib.BarGraph( 0, 0, 250, 250, 0, entries, "value", "bottom" )
  GNLib.CircleGraph( 250 + 125, 125, 100, entries, "value" )
  GNLib.OutlinedCircleGraph( 500 + 125, 125, 100, 20, entries, "value" )

  GNLib.Curve( 5, 255, 240, 240, 0, 100, 0, 100, Color( 255, 0, 0 ), {
    { 0, 0 },
    { 10, 10 },
    { 20, 40 },
    { 60, 80 },
    { 65, 20 },
    { 68, 40 },
  } )

  --GNLib.DrawFunc( 255, 255, 240, 240, 0, 500, 0, 500, 1, "50", Color( 0, 255, 0 ) )
end )
hook.Remove( "HUDPaint", "TestingGraph" )
