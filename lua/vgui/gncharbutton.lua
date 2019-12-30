local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "default_textcolor", "DefaultTextColor" )
AccessorFunc( PANEL, "hovered_textcolor", "HoveredTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

AccessorFunc( PANEL, "default_shadowcolor", "DefaultShadowColor" )
AccessorFunc( PANEL, "hovered_shadowcolor", "HoveredShadowColor" )
AccessorFunc( PANEL, "clicked_shadowcolor", "ClickedShadowColor" )

AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

AccessorFunc( PANEL, "active_char", "ActiveChar", FORCE_BOOL )

function PANEL:Init()
    self:SetSize( 20, 20 )
    self:SetCursor( "hand" )
    self:SetColor( GNLib.Colors.Pomegranate )

    self.radius = 10

    self.char = "@"
    self.active_char = true
    self.font = "GNLFontB15"

    self.hovered_color = GNLib.Colors.Pumpkin
    self.clicked_color = GNLib.Colors.Alizarin

    self.default_textcolor = GNLib.Colors.Clouds
    self.hovered_textcolor = GNLib.Colors.Silver
    self.clicked_textcolor = GNLib.Colors.Concrete

    self.shadow_x = 1
    self.shadow_y = 1

    self.default_shadowcolor = GNLib.Colors.MidnightBlue
    self.hovered_shadowcolor = GNLib.Colors.WetAsphalt
    self.clicked_shadowcolor = GNLib.Colors.Asbestos
end

function PANEL:SetShadowPos( x, y )
    self.shadow_x = x or self.shadow_x
    self.shadow_y = y or self.shadow_y
end

function PANEL:SetRadius( radius )
    self.radius = radius or self.radius
    self:SetSize( self.radius * 2, self.radius * 2 )
end

function PANEL:SetChar( char )
    self.char = self:GetActiveChar() and string.sub( char, 1, 1 ) or char
end

function PANEL:GetChar()
    return self.char
end

PANEL.SetText = PANEL.SetChar
PANEL.GetText = PANEL.GetChar

--  > Override existing
function PANEL:Paint( w, h )
    local _ = nil
    GNLib.DrawCircle( self.radius, self.radius, self.radius, _, _, self.clicking and self.clicked_color or self:IsHovered() and self.hovered_color or self.color )

    GNLib.SimpleTextShadowed( self.char, self.font, self.radius, self.radius, self.clicking and self.clicked_textcolor or self:IsHovered() and self.hovered_textcolor or self.default_textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, self.shadow_x, self.shadow_y, _ )
end

vgui.Register( "GNCharButton", PANEL, "GNPanel" )
