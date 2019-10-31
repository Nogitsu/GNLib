local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "default_textcolor", "TextColor" )
AccessorFunc( PANEL, "hovered_textcolor", "HoveredTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

function PANEL:Init()
    self:SetSize( 100, 25 )
    self:SetCursor( "hand" )
    self:SetColor( GNLib.Colors.Wisteria )

    self.text = "Label"
    self.font = "GNLFontB15"

    self.hovered_color = GNLib.Colors.Amethyst
    self.clicked_color = GNLib.Colors.BelizeHole

    self.default_textcolor = GNLib.Colors.MidnightBlue
    self.hovered_textcolor = GNLib.Colors.WetAsphalt
    self.clicked_textcolor = GNLib.Colors.Asbestos
end

function PANEL:UpdateSize()
    surface.SetFont( self.font or "GNLFontB15" )
    local tw, th = surface.GetTextSize( self.text or "" )
    self:SetSize( math.max( self:GetWide(), tw + 25 ), math.max( self:GetTall(), th + 4 ) )
end    
--  > Change size on font and text update

function PANEL:SetText( text )
    self.text = text

    self:UpdateSize()
end

function PANEL:GetText()
    return self.text
end

function PANEL:SetFont( font )
    self.font = font

    self:UpdateSize()
end

function PANEL:GetFont()
    return self.font
end

--  > Override existing
function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self.clicking and self.clicked_color or self:IsHovered() and self.hovered_color or self.color )

    draw.SimpleText( self.text, self.font, w / 2, h / 2, self.clicking and self.clicked_textcolor or self:IsHovered() and self.hovered_textcolor or self.default_textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "GNButton", PANEL, "GNPanel" )
