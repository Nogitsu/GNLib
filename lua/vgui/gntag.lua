local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "text_color", "TextColor" )

AccessorFunc( PANEL, "text", "Text", FORCE_STRING )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

function PANEL:Init()  
    self.color = GNLib.Colors.Clouds
    self.text_color = GNLib.Colors.Asbestos

    self.text = "Tag"
    self.font = "GNLFontB15"

    self:SizeToContents()
end

function PANEL:SizeToContents()
    surface.SetFont( self.font )
    local w, h = surface.GetTextSize( self.text )

    self:SetSize( w + 20, h + 7 )
end

function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self.color )

    draw.SimpleText( self.text, self.font, w / 2, h / 2, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "GNTag", PANEL, "DPanel" )