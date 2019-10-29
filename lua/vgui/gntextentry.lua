local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "text_color", "TextColor" )
AccessorFunc( PANEL, "placeholder_color", "PlaceholderColor" )

AccessorFunc( PANEL, "title", "Title", FORCE_STRING )
AccessorFunc( PANEL, "placeholder", "Placeholder", FORCE_STRING )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )
AccessorFunc( PANEL, "font_value", "FontValue", FORCE_STRING )

function PANEL:Init()
    self:SetSize( 125, 35 )
    self:SetCursor( "beam" )
    self:SetColor( GNLib.Colors.Wisteria )

    self.title = "TextEntry"
    self.text = ""
    self.placeholder = ""
    self.font = "GNLFontB15"
    self.font_value = "GNLFontB13"

    self.value_color = GNLib.Colors.Silver
    self.placeholder_color = GNLib.Colors.Concrete
    self.hovered_color = GNLib.Colors.Amethyst
end

function PANEL:GetPaintTall()
    surface.SetFont( self.font )
    local w, h = surface.GetTextSize( self.title )
    
    return self:GetTall() - h / 2, h / 2
end

function PANEL:Paint( w, h )
    local color = self:IsHovered() and self:GetHoveredColor() or self:GetColor()
    surface.SetDrawColor( color )

    --  > Text
    surface.SetFont( self.font )
    local text_width, text_height = surface.GetTextSize( self.title )

    draw.SimpleText( self.title, self.font, 12, text_height / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    local text = self:GetValue()
    if #text == 0 and not self:IsEditing() then
        draw.SimpleText( self.placeholder, self.font_value, 5, h / 2 + text_height / 4, self.placeholder_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    else
        draw.SimpleText( text, self.font_value, 5, h / 2 + text_height / 4, self.value_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    if self:IsEditing() then
        local pos = surface.GetTextSize( string.sub( self:GetText(), 1, self:GetCaretPos() ) )
        local x_pos, y_pos = 5 + pos, h / 2 + text_height / 4

        surface.DrawLine( x_pos, y_pos - 8, x_pos, y_pos + 8 )
    end

    --  > Style    
    surface.DrawLine( 4, text_height / 2, 8, text_height / 2 )
    surface.DrawLine( text_width + 14, text_height / 2, w - 4, text_height / 2 )
    surface.DrawLine( 3, h - 1, w - 4, h - 1 )
    surface.DrawLine( 0, text_height / 2 + 4, 0, h - 4 )
    surface.DrawLine( w - 1, text_height / 2 + 4, w - 1, h - 4 )

    GNLib.DrawOutlinedCircle( 4, text_height / 2 + 4, 4, 1, -90, -180, color )
    GNLib.DrawOutlinedCircle( 4, h - 4, 4, 1, -270, -180, color )
    GNLib.DrawOutlinedCircle( w - 4, text_height / 2 + 4, 4, 1, -90, 0, color )
    GNLib.DrawOutlinedCircle( w - 4, h - 4, 4, 1, 180, 270, color )

    return true
end

function PANEL:AllowInput( char )
    surface.SetFont( self.font_value )
    local _, h = surface.GetTextSize( char )
    local allow = surface.GetTextSize( self:GetText() ) > self:GetWide() - h
    return allow
end

vgui.Register( "GNTextEntry", PANEL, "DTextEntry" )