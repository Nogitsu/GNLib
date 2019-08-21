local PANEL = {}

AccessorFunc( PANEL, "text", "Text", FORCE_STRING )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

AccessorFunc( PANEL, "text_color", "TextColor" )
AccessorFunc( PANEL, "hover_textcolor", "HoverTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

function PANEL:Init()
    self.text = "Label"
    self.font = "GNLFontB15"
    self.text_color = GNLib.Colors.Clouds
end

--  > Override existing
function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self.color )
    
    draw.SimpleText( self.text, self.font, w / 2, h / 2, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "GNTooltip", PANEL, "GNPanel" )
